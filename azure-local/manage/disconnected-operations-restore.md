---
title: Restore Azure Local Disconnected Environments
description: Learn how to restore an Azure Local environment running in disconnected mode. Configure restore parameters and trigger a restore operation.
author: ronmiab
ms.author: robess
ms.date: 04/03/2026
ms.topic: concept-article
ms.service: azure-local
ms.subservice: hyperconverged
ai-usage: ai-assisted
---

# Restore for disconnected operations for Azure Local

::: moniker range=">=azloc-2602"

This article explains the restore process for disconnected operations for Azure Local environments. It provides practical steps to trigger a restore and parameter configurations to customize it. Operators need access to the [Operator subscription and role-based access control (RBAC) permissions](disconnected-operations-identity.md).
  
For more information, see [Disconnected operations for Azure Local](/azure/azure-local/manage/disconnected-operations-overview?view=azloc-2602&preserve-view=true).

> [!IMPORTANT]
> The restore operation supports restoring the backup to the same version of Azure local disconnected environment.

## Overview

The backup feature currently backs up only the control plane VM data. It doesn't include associated workloads or configured clusters. The restore functionality restores the control plane data from the backup. So, ensure that you configure the same version of Azure local disconnected where you restore the backup.

## Why backup and restore operations?

Backup capability is critical because the Azure Local with disconnected operations virtual machine (VM) acts as the control plane. It stores authoritative metadata for subscriptions, resource groups, policies, and connected Azure Local resources. Any corruption or loss of this control plane disrupts the entire environment. Regular backups protect against catastrophic failures, infrastructure loss, or misconfigurations by capturing the control plane state at specific points in time. The restore functionality helps you get back the environment to the state which was at the time of backup.

## Prerequisites

Before you restore your system, complete these prerequisites:

- **Operator access:** Ensure your identity has the required OperatorRP RBAC role in the Operator subscription.

- **Environment Setup:** Ensure that you have a fresh Azure local Disconnected environment that you set up and that the version matches the backup version. Cross version restores aren't supported.

- **Root Certificate:** For the Restore VM, ensure that the same Root Certificate - Certificate Authority is used for the new VM Creation to ensure the trust.

- **Server Message Block (SMB) share:** The SMB share where the backup file to restore is stored is accessible from the new environment.

- **Decryption key:** The decryption key that you stored externally is available and you need to provide it during the restore process. 

- **Import restore module (required):** Before running any restore cmdlets, import the restore module from your Operations Module by using its full path:

  ```powershell
  # Import the restore cmdlets from the Operations Module (use the full path on your system)
  Import-Module "<full path to Operations Module>\Azure.Local.Restore.psm1"
  ```

## Trigger and monitor a backup

To trigger the restore, open an administrator PowerShell session and invoke the restore operation by passing the requested parameters. This operation initiates the restore process which runs in the background. 

To trigger and monitor the restore, follow these steps:


1. Trigger the restore operation.

    ```powershell
    Start-ApplianceRestore
    ```

    Here's an example output:

    :::image type="content" source="media/disconnected-operations/back-up-restore/trigger-restore.png" alt-text="Screenshot of the Start-ApplianceRestore command output." lightbox=" ./media/disconnected-operations/back-up-restore/trigger-restore.png":::

1. Track the restore status until it completes, where status refreshes every 30 seconds.

    ```powershell
    Wait-ApplianceRestore
    ```

    Here's an example output:

    :::image type="content" source="media/disconnected-operations/back-up-restore/wait-appliance-restore.png" alt-text="Screenshot of Wait-ApplianceRestore command output." lightbox=" ./media/disconnected-operations/back-up-restore/wait-appliance-restore.png":::

1. Restore Completion - After a few hours, the restore operation completes. You can check the status by using the following command:
   
    ```powershell
    Get-ApplianceRestore 
    ```

    Here's an example output:

    :::image type="content" source="media/disconnected-operations/back-up-restore/get-appliance-restore.png" alt-text="Screenshot of the Get-ApplianceRestore command output." lightbox=" ./media/disconnected-operations/back-up-restore/get-appliance-restore.png":::


## Important – Post restore environment mismatch
> [!IMPORTANT]
> Before you initiate a restore, the backup state and the current environment state might have differences in the workload state of the control plane data. The restore operation can cause a drift in the resource metadata. 
- **Lost resources:** You cannot recover cloud-only resources that are created after the backup. You must recreate these resources.
- **Untracked Arc resources:** You need to rehydrate or re-register resources that are created after the backup and exist on the cluster but are missing in restored metadata.
- **Phantom / Resurrected resources:** You need to clean up resources that are deleted after the backup but reappear as metadata after restoring.
- **Drifted resources:** Restored environment reflects old state for resources that are updated after backup. This state might break authentication or management until remediated.
- **Azure Local cluster infra drift:** You need to repair registration and re-Arc actions for membership changes or new clusters registered after the backup.
- **Certificate expiry / rotation:** Older backups might contain expired certificates or mismatched client authentication certificate. You need manual remediation and rotation.

::: moniker-end

::: moniker range="<=azloc-2602"

This feature is available only in Azure Local 2603 or later.

::: moniker-end
