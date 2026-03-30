---
title: Backup for Disconnected Operations for Azure Local
description: Learn how to back up Azure Local environments running disconnected. Configure parameters and trigger backups.
author: ronmiab
ms.author: robess
ms.date: 02/23/2026
ms.topic: concept-article
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Backup for disconnected operations for Azure Local

::: moniker range=">=azloc-2602"

This article explains the backup process for disconnected operations for Azure Local environments. It provides practical steps to trigger a backup and parameter configurations to customize it. Operators need access to the [Operator subscription and role-based access control (RBAC) permissions](disconnected-operations-identity.md).
  
For more information, see [Disconnected operations for Azure Local](/azure/azure-local/manage/disconnected-operations-overview?view=azloc-2602&preserve-view=true).

> [!IMPORTANT]
> The restore feature is currently in development. Documentation for the restore process will be available once the feature is stable.

## Overview

The backup feature currently backs up the control plane VM data only. Associated workloads or configured clusters aren't included in the backup. Backups capture all data needed for the disconnected operations control plane VM. Because backups aren't automated, take backups regularly and before making changes to the environment.

## Why backup operations?

Backup capability is critical because the Azure Local with disconnected operations virtual machine (VM) acts as the control plane. It stores authoritative metadata for subscriptions, resource groups, policies, and connected Azure Local resources. Any corruption or loss of this control plane disrupts the entire environment. Regular backups protect against catastrophic failures, infrastructure loss, or misconfigurations by capturing the control plane state at specific points in time.

## Prerequisites

Before you back up your system, complete these prerequisites:

- **Operator access:** Ensure your identity has the required **OperatorRP** RBAC role in the Operator subscription.

- **Server Message Block (SMB) share:** Provision an accessible SMB share as backup target from the Azure Local disconnected operations VM where system state backups are written.

- **Encryption key:** Store the encryption certificate externally (*.cer* for backup) and provide it during the backup process. We recommend an Azure Key Vault in global Azure in the same subscription where the Azure Local with disconnected operations instance registration entry exists.

- **Import backup module (required):** Before running any backup cmdlets, import the backup module from your Operations Module by using its full path:

  ```powershell
  # Import the backup cmdlets from the Operations Module (use the full path on your system)
  Import-Module "<full path to Operations Module>\Azure.Local.Backup.psm1"
  ```

## Backup parameters and customization

Before running the backup command, configure environment-specific settings and parameters, such as backup paths, encryption certificates, retention preferences, and target locations. These configurations ensure that the backup process runs correctly and aligns with your infrastructure layout and security requirements.

To configure settings and parameters, open an administrator PowerShell session and run these cmdlets.

```PowerShell
# point az to arca
> az cloud set --name arca

# Login as admin
> az login

# set operator subscription which will be listed after login
> az account set --subscription <operator subscription GUID> 

# Create backup config with SMB share details, Encryption Key
> Set-ApplianceBackupConfiguration 
```

Here's an example output of the `Set-ApplianceBackupConfiguration` cmdlet:

:::image type="content" source="media/disconnected-operations/back-up-restore/set-appliance-back-up-configuration.png" alt-text="Screenshot of the Set-ApplianceBackupConfiguration command output." lightbox=" ./media/disconnected-operations/back-up-restore/set-appliance-back-up-configuration.png":::

## Trigger and monitor a backup

To trigger the backup, invoke the backup operation by using the configured settings and parameters. This operation captures a consistent snapshot of the disconnected operations control plane. After you start the operation, the system validates the configuration and begins creating the backup based on the defined backup policy. This process runs in the background and triggers a backup ID.

To trigger and monitor a backup, follow these steps:

1. Trigger the backup operation.

    ```PowerShell
    Start-ApplianceBackup
    ```

    Here's an example output:

    :::image type="content" source="media/disconnected-operations/back-up-restore/trigger-monitor-back-up.png" alt-text="Screenshot of the Start-ApplianceBackup command output." lightbox=" ./media/disconnected-operations/back-up-restore/trigger-monitor-back-up.png":::

1. List the active backup operations.

    ```powershell
    Get-ApplianceBackupOperationList
    ```

    Here's an example output:

    :::image type="content" source="media/disconnected-operations/back-up-restore/list-active-back-ups.png" alt-text="Screenshot of PowerShell terminal showing Get-ApplianceBackupOperationList output with backup ID and status details." lightbox=" ./media/disconnected-operations/back-up-restore/list-active-back-ups.png":::

1. Track the backup status. Provide the backup operation ID when prompted.

    ```powershell
    Wait-ApplianceBackupOperationComplete
    ```

    Here's an example output:

    :::image type="content" source="media/disconnected-operations/back-up-restore/track-status-back-up-id.png" alt-text="Screenshot of the Wait-ApplianceBackupOperationComplete command output." lightbox=" ./media/disconnected-operations/back-up-restore/track-status-back-up-id.png":::

::: moniker-end

::: moniker range="<=azloc-2601"

This feature is available only in Azure Local 2602 or later.

::: moniker-end
