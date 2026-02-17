---
title: Backup for Disconnected Operations for Azure Local
description: Learn how to back up Azure Local environments running disconnected. Configure parameters and trigger backups.
author: ronmiab
ms.author: robess
ms.date: 01/27/2026
ms.topic: concept-article
ms.service: azure-local
ms.subservice: hyperconverged
---

# Backup for disconnected operations for Azure Local

This article explains the backup process for disconnected operations for Azure Local environments. It provides practical steps to trigger a backup and parameter configurations to customize it. Operators need access to the Operator subscription and role-based access control (RBAC) permissions.
  
For more information, see [Disconnected operations for Azure Local](/azure/azure-local/manage/disconnected-operations-overview?view=azloc-2512).

## Overview

The current implementation of backup supports the backup of the control plane VM data. The associated workload or configured clusters aren't part of the backup process currently.

The backup process backs up all data necessary for the disconnected operations control plane VM. Backups aren't automated, so the operator should take periodic backups or backups before any changes to the environment.

## Why backup operations?

Backup capability is critical because the Azure Local with disconnected operations virtual machine (VM) acts as the control plane. It stores authoritative metadata for subscriptions, resource groups, policies, and connected Azure Local resources. Any corruption or loss of this control plane disrupts the entire environment. Regular backups protect against catastrophic failures, infrastructure loss, or misconfigurations by capturing the control plane state at specific points in time.

## Prerequisites

Before you back up your system, complete these prerequisites:

### Before you back up

- **Operator access:** Ensure your identity has the required **OperatorRP** RBAC role in the Operator subscription.

- **Server Message Block (SMB) share:** Provision an accessible SMB share as backup target from the Azure Local disconnected operations VM where system state backups are written.

- **Encryption key:** Store the encryption certificate externally (*.cer* for backup) and provide it during the backup process. We recommend an Azure Key Vault in public Azure in the same subscription where the Azure Local with disconnected operations instance registration entry exists.

## Backup parameters and customization

Before running the backup command, configure environment-specific settings and parameters, such as backup paths, encryption certificates, retention preferences, and target locations. These configurations ensure that the backup process runs correctly and aligns with your infrastructure layout and security requirements.

Open an administrator PowerShell session and run these cmdlets.

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

Follow these steps:

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

