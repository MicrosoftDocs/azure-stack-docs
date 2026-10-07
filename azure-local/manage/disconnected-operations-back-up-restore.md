---
title: Back up Azure Local Disconnected Environments
description: Learn how to back up Azure Local environments running disconnected. Configure parameters and trigger backups.
author: ronmiab
ms.author: robess
ms.date: 09/02/2026
ms.topic: concept-article
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Backup for disconnected operations for Azure Local

::: moniker range=">=azloc-2602"

This article explains the backup process for disconnected operations for Azure Local environments. It provides practical steps to trigger a backup and parameter configurations to customize it. Operators need access to the [Operator subscription and role-based access control (RBAC) permissions](disconnected-operations-identity.md).
  
For more information, see [Disconnected operations for Azure Local](/azure/azure-local/manage/disconnected-operations-overview?view=azloc-2602&preserve-view=true).

## Overview

The backup feature currently backs up only the control plane virtual machine (VM) data. It doesn't include associated workloads or configured clusters in the backup. Backups capture all data needed for the disconnected operations control plane VM. You can trigger backups on demand or configure them to run automatically on a recurring schedule. Take backups regularly and before making changes to the environment.

## Why back up operations?

Backup capability is critical because the Azure Local with disconnected operations VM acts as the control plane. It stores authoritative metadata for subscriptions, resource groups, policies, and connected Azure Local resources. Any corruption or loss of this control plane disrupts the entire environment. Regular backups protect against catastrophic failures, infrastructure loss, or misconfigurations by capturing the control plane state at specific points in time.

## Prerequisites

Before you back up your system, complete these prerequisites:

- **Operator access:** Ensure your identity has the required **OperatorRP** RBAC role in the Operator subscription.

- **Server Message Block (SMB) share:** Provision an accessible SMB share as backup target from the Azure Local disconnected operations VM where system state backups are written.

- **Encryption key:** Store the encryption certificate externally (*.cer* for backup) and provide it during the backup process. Use an Azure Key Vault in global Azure in the same subscription where the Azure Local with disconnected operations instance registration entry exists.

- **Import backup module (required):** Before running any backup cmdlets, import the backup module from your Operations Module by using its full path:

  ```powershell
  # Import the backup cmdlets from the Operations Module (use the full path on your system)
  Import-Module "<full path to Operations Module>\Azure.Local.Backup.psm1"
  ```

## Understand backup types

Azure Local with disconnected operations supports two types of backups:

- **On-demand backup**: A backup that you start manually by using `Start-ApplianceBackup`. On-demand backups always use the default backup configuration.
- **Scheduled backup**: A backup that runs automatically based on a configured schedule. A scheduled backup uses the backup configuration referenced by the schedule, which can be the `default` configuration or a `named` configuration.

## Configure backup access

Before you configure or create backups, configure Azure CLI and the management endpoint client context.

1. Open PowerShell as an administrator.
1. Configure Azure CLI for Azure.Local, sign in, and set the operator subscription. Use the operator subscription ID listed after you sign in.

    ```azurecli
    # Point Azure CLI to Azure.Local.
    az cloud set --name Azure.Local

    # Sign in.
    az login

    # Set the operator subscription.
    az account set --subscription <operator subscription GUID>
    ```

1. Get the management endpoint client authentication certificate (`ManagementEndpointClientAuth.pfx`) and its password.
1. Set the management endpoint client context by using the `Set-ApplianceClientContext` cmdlet.

    ```powershell
    # Set the appliance client context. Send the password (SecureString) and ManagementEndpointClientAuth.pfx.
    Set-ApplianceClientContext -ManagementEndpointClientCertificatePath <path to ManagementEndpointClientAuth.pfx> -ManagementEndpointClientCertificatePassword $securePassword -ManagementEndpoint <management endpoint IP>
    ```

### Understand backup configurations

A *backup configuration* defines where the backup is stored and how it's protected. It specifies the destination SMB share and the encryption certificate.
You can use two types of backup configurations:

- **Default configuration**: The global configuration named `default`. On-demand (ad hoc) backups always use this configuration. To target it in the configuration cmdlets, either omit the `-Name` parameter or pass `-Name default`—both refer to the same global configuration. Each system has a single default configuration.
- **Named configuration**: An additional configuration that you create with your own name (for example, `nightly`). A scheduled backup writes to the configuration it references—either the default configuration or a named one. Create as many named configurations as you need, for example, one per destination share.

## Create or update a backup configuration

Use `Set-ApplianceBackupConfiguration` to create or update a backup configuration:

| Parameter | Required | Description |
|--|--|--|
| `-Name` | No | Configuration name. If you omit this parameter or pass `default`, the cmdlet targets the **default** (global) configuration. Provide a custom name (for example, `nightly`) to create or target a named configuration. Allowed characters are letters, digits, period, underscore, and hyphen (no spaces). |
| `-Path` | Yes | UNC path of the destination SMB share (for example, `\\server\share`). |
| `-UserName` | Yes | User name used to authenticate to the SMB share. |
| `-Password` | Yes | SMB share password, provided as a `SecureString`. |
| `-EncryptionCertBase64` | Yes | Base64-encoded encryption certificate used to protect the backup. |
| `-EncryptionCertThumbprint` | No | Thumbprint of the encryption certificate. |
| `-NoWait` | No | Return immediately with an operation ID instead of waiting for the operation to complete. |
| `-ExternalDomainSuffix` | No | External domain suffix, used if the cmdlet can't resolve the ARM endpoint automatically. |

> [!IMPORTANT]
> `default` is a reserved configuration name. Omitting `-Name` or passing `-Name default` targets the single global configuration, so updating it changes the configuration that on-demand backups use.

### Create or update the default configuration

Run the following commands to create or update the default backup configuration:

```powershell
$password = Read-Host -AsSecureString -Prompt "Enter SMB password"
Set-ApplianceBackupConfiguration -Path "\\server\share" -UserName "backupuser" -Password $password -EncryptionCertBase64 "<base64-encoded-cert>"
```

### Create or update a named configuration

Specify the `-Name` parameter to create or update a named configuration. The following example uses `nightly`:

```powershell
$password = Read-Host -AsSecureString -Prompt "Enter SMB password"
Set-ApplianceBackupConfiguration -Name "nightly" -Path "\\server\share" -UserName "backupuser" -Password $password -EncryptionCertBase64 "<base64-encoded-cert>"
```

### View a backup configuration

To view the default configuration, omit `-Name`:

```powershell
Get-ApplianceBackupConfiguration
```

To view a named configuration, specify its name:

```powershell
Get-ApplianceBackupConfiguration -Name "nightly"
```

### Remove a backup configuration

Specify the configuration that you want to remove. The following example removes the `nightly` configuration:

```powershell
Remove-ApplianceBackupConfiguration -Name "nightly"
```

## Create an on-demand backup

> [!NOTE]
> On-demand backups that you trigger with `Start-ApplianceBackup` always use the **default** configuration. To write scheduled backups to a different destination, create a named configuration and reference it when you [create the schedule](#create-or-update-a-backup-schedule).

An on-demand backup captures the disconnected operations control plane state and uses the default backup configuration. The backup operation runs in the background and returns a backup ID that you can use to monitor the operation.

To trigger and monitor an on-demand backup, follow these steps:

1. Start an on-demand backup.

    ```powershell
    Start-ApplianceBackup
    ```

    Here's an example output:

    ```console
    PS F:\AzureLocalVHD\OperationsModule> Start-ApplianceBackup

    {
      "id": "/subscriptions/<operator subscription ID>/resourceGroups/system.edgeoperator/providers/Microsoft.EdgeOperator/backups/<backup ID>",
      "name": "<backup ID>",
      "type": "microsoft.edgeoperator/backups",
      "systemData": {
        "createdBy": "<operator identity>",
        "createdByType": "User",
        "createdAt": "<creation time>",
        "lastModifiedBy": "<operator identity>",
        "lastModifiedByType": "User",
        "lastModifiedAt": "<last updated time>"
      },
      "properties": {
        "backupStatus": "Running",
        "substatusMessage": null,
        "backupServiceOperationError": {
          "message": "",
          "errorCode": "",
          "statusCode": 0
        },
        "startTime": "<start time>",
        "endTime": "0001-01-01T00:00:00",
        "provisioningState": "Succeeded"
      }
    }

    Name                           Value
    ----                           -----
    BackupId                       <backup ID>
    BackupDetails                  @{id=/subscriptions/<operator subscription ID>/resourceGroups/system.edgeoperator/providers/Microsoft.EdgeOperator/backups/<backup ID>; name=<backup ID>; type=microsoft.edgeoperator/backups; systemData=; properties=}
    ```

    Use the `BackupId` value to monitor the backup operation in the following steps.

1. List the active backup operations. The output includes each backup's *provenance* through the `isScheduledBackup` property.

    ```powershell
    Get-ApplianceBackupOperationList
    ```

    Here's an example output:

    ```console
    PS F:\AzureLocalVHD\OperationsModule> Get-ApplianceBackupOperationList

    {
      "value": [
        {
          "id": "/subscriptions/<operator subscription ID>/resourceGroups/system.edgeoperator/providers/Microsoft.EdgeOperator/backups/<backup ID>",
          "name": "<backup ID>",
          "type": "Microsoft.EdgeOperator/backups",
          "properties": {
            "backupStatus": "Running",
            "isScheduledBackup": true,
            "substatusMessage": "Uploading",
            "backupServiceOperationError": {
              "message": "",
              "errorCode": "",
              "statusCode": 0
            },
            "startTime": "<start time>",
            "endTime": "0001-01-01T00:00:00"
          }
        }
      ]
    }
    ```

1. Track the backup status. Provide the backup operation ID when prompted.

    ```powershell
    Wait-ApplianceBackupOperationComplete
    ```

    Here's an example output:

    :::image type="content" source="media/disconnected-operations/back-up-restore/track-status-back-up-id.png" alt-text="Screenshot of the Wait-ApplianceBackupOperationComplete command output." lightbox="./media/disconnected-operations/back-up-restore/track-status-back-up-id.png":::

Scheduled backups appear in this same operations list. To tell scheduled and on-demand backups apart, use each backup's *provenance*. Every backup operation reports whether the scheduler triggered it: scheduled runs are marked `isScheduledBackup: true`, and backups that you start manually with `Start-ApplianceBackup` are marked `isScheduledBackup: false`.

| Provenance detail | On-demand backup (`Start-ApplianceBackup`) | Scheduled backup |
|--|--|--|
| Trigger | An operator runs the cmdlet. | The scheduler runs it automatically at `nextPlannedRunAtUtc`. |
| `isScheduledBackup` | `false` | `true` |
| Configuration used | `default` | The schedule's `-BackupConfigurationRef`. |

To inspect a specific backup, including its provenance, use `Get-ApplianceBackup -BackupId <backup ID>`.

## Configure scheduled backups

Scheduled backups run automatically according to the schedule you configure. A scheduled backup uses the backup configuration referenced by the schedule, which can be the `default` configuration or a `named` configuration.


Each system has one backup schedule. Creating or updating the schedule replaces the existing schedule.

### Create or update a backup schedule

Use the `Set-ApplianceBackupSchedule` cmdlet to create or update the schedule. The following table lists its parameters:

| Parameter | Required | Description |
|--|--|--|
| `-Enabled` | Yes | `$true` to run on the schedule, or `$false` to keep the schedule configured but paused. |
| `-Frequency` | Yes | How often the backup runs: `TwiceDaily`, `Daily`, `Weekly`, or `Monthly`. |
| `-TimeOfDayUtc` | Yes | Time of day, in Coordinated Universal Time (UTC), that the backup runs, as a 24-hour `TimeSpan` (for example, `"02:00:00"`). Must be within the range `[00:00:00, 24:00:00)`. |
| `-DayOfWeek` | Weekly only | Day of the week the backup runs (for example, `Sunday`). Required for—and valid only with—a `Weekly` schedule. |
| `-DayOfMonth` | Monthly only | Day of the month (1–31) the backup runs. Required for—and valid only with—a `Monthly` schedule. |
| `-BackupConfigurationRef` | Yes | The backup configuration that the scheduled backup writes to. Use a configuration name (for example, `nightly`) or `default`. |

> [!NOTE]
> The `-TimeOfDayUtc` value is in UTC. Convert from your local time zone when you set it.

The following examples show each frequency:

```powershell
# Daily at 02:00 UTC, writing to the "nightly" configuration
Set-ApplianceBackupSchedule -Enabled $true -Frequency Daily -TimeOfDayUtc "02:00:00" -BackupConfigurationRef "nightly"

# Twice a day, starting at 02:00 UTC
Set-ApplianceBackupSchedule -Enabled $true -Frequency TwiceDaily -TimeOfDayUtc "02:00:00" -BackupConfigurationRef "nightly"

# Weekly on Sunday at 02:00 UTC
Set-ApplianceBackupSchedule -Enabled $true -Frequency Weekly -DayOfWeek Sunday -TimeOfDayUtc "02:00:00" -BackupConfigurationRef "nightly"

# Monthly on the first day of the month at 02:00 UTC
Set-ApplianceBackupSchedule -Enabled $true -Frequency Monthly -DayOfMonth 1 -TimeOfDayUtc "02:00:00" -BackupConfigurationRef "nightly"
```

`Set-ApplianceBackupSchedule` returns the saved schedule, including `nextPlannedRunAtUtc`, which indicates the next scheduled backup.

Here's an example output of the `Set-ApplianceBackupSchedule` cmdlet:

```console
PS F:\AzureLocalVHD\OperationsModule> Set-ApplianceBackupSchedule -Enabled $true -Frequency Daily -TimeOfDayUtc "02:00:00" -BackupConfigurationRef "nightly"

{
  "id": "/subscriptions/<operator subscription ID>/resourceGroups/system.edgeoperator/providers/Microsoft.EdgeOperator/backupSchedules/default",
  "name": "default",
  "type": "microsoft.edgeoperator/backupSchedules",
  "systemData": {
    "createdBy": "<operator identity>",
    "createdByType": "User",
    "createdAt": "<creation time>",
    "lastModifiedBy": "<operator identity>",
    "lastModifiedByType": "User",
    "lastModifiedAt": "<last updated time>"
  },
  "properties": {
    "enabled": true,
    "frequency": "Daily",
    "timeOfDayUtc": "02:00:00",
    "dayOfWeek": null,
    "dayOfMonth": null,
    "backupConfigurationRef": "/subscriptions/<operator subscription ID>/resourceGroups/system.edgeoperator/providers/Microsoft.EdgeOperator/backupConfigurations/nightly",
    "nextPlannedRunAtUtc": "<next run time in UTC>",
    "createdAtUtc": "<creation time>",
    "updatedAtUtc": "<last updated time>",
    "provisioningState": "Succeeded"
  }
}
```

### View, pause, resume, or remove the schedule

```powershell
# View the current schedule and its next planned run
Get-ApplianceBackupSchedule

# Pause the schedule without deleting it (no runs are triggered)
Disable-ApplianceBackupSchedule

# Resume a paused schedule
Enable-ApplianceBackupSchedule

# Remove the schedule entirely
Remove-ApplianceBackupSchedule
```

Here's an example output of the `Get-ApplianceBackupSchedule` cmdlet:

```console
PS F:\AzureLocalVHD\OperationsModule> Get-ApplianceBackupSchedule -ExternalDomainSuffix $suffix | Format-List

id         : /subscriptions/<operator subscription ID>/resourceGroups/system.edgeoperator/providers/Microsoft.EdgeOperator/backupSchedules/default
name       : default
type       : Microsoft.EdgeOperator/backupSchedules
systemData : @{createdBy=<operator identity>; createdByType=User; createdAt=<creation time>;
               lastModifiedBy=<operator identity>; lastModifiedByType=User;
               lastModifiedAt=<last updated time>}
properties : @{enabled=True; frequency=Daily; timeOfDayUtc=<time in UTC>;
               dayOfWeek=; dayOfMonth=;
               backupConfigurationRef=/subscriptions/<operator subscription ID>/resourceGroups/system.edgeoperator/providers/Microsoft.EdgeOperator/backupConfigurations/nightly;
               nextPlannedRunAtUtc=<next run time in UTC>; createdAtUtc=<creation time>;
               updatedAtUtc=<last updated time>; provisioningState=Succeeded}
```

Disabling a schedule keeps its definition but stops the scheduler from triggering runs. The `enabled` property becomes `false` and `nextPlannedRunAtUtc` is cleared. Enabling the schedule again recomputes the next run.

## Troubleshooting

If you encounter the following error while running any backup commands:

```output
Unable to connect to the remote server
```

Rerun the command with the `-ExternalDomainSuffix` parameter set to your external domain suffix. For example:

```powershell
-ExternalDomainSuffix autonomous.aldo.private
```

## Next steps

- To restore the control plane data from a backup, see [Restore for disconnected operations for Azure Local](disconnected-operations-restore.md).
- To understand the end-to-end rehydration sequence after a restore, see [Post-restore rehydration overview for disconnected operations](disconnected-operations-post-restore-overview.md).

::: moniker-end

::: moniker range="<=azloc-2601"

This feature is available only in Azure Local 2602 or later.

::: moniker-end
