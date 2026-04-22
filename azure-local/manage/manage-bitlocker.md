---
title: Manage BitLocker encryption on Azure Local, version 23H2
description: Learn how to manage BitLocker encryption on your Azure Local, version 23H2 system.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 4/22/2026
ms.subservice: hyperconverged
---

# Manage BitLocker encryption on Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to view and enable BitLocker encryption, and retrieve BitLocker recovery keys on your Azure Local instance.

## Prerequisites

Before you begin, make sure that you have access to an Azure Local instance that is deployed, registered, and connected to Azure.

## View BitLocker settings via Azure portal

To view the BitLocker settings in the Azure portal, make sure that you apply the MCSB initiative. For more information, see [Apply Microsoft Cloud Security Benchmark initiative](./manage-security-with-defender-for-cloud.md#apply-microsoft-cloud-security-benchmark-initiative).

BitLocker offers two types of protection: encryption for OS volumes and encryption for data volumes. You can only view BitLocker settings in the Azure portal. To manage the settings, see [Manage BitLocker settings with PowerShell](#manage-bitlocker-settings-with-powershell).

:::image type="content" source="media/manage-bitlocker/manage-bitlocker.png" alt-text="Screenshot that shows the Data protections page for volume encryption on Azure portal." lightbox="media/manage-bitlocker/manage-bitlocker.png":::

## Manage BitLocker settings with PowerShell

You can view, enable, and disable volume encryption settings on your Azure Local instance.

### PowerShell cmdlet properties

The following cmdlets are part of the *AzureStackBitLockerAgent* module:

#### Get-ASBitLocker

Retrieves the current BitLocker encryption status for volumes on your Azure Local instance.

```powershell
Get-ASBitLocker -VolumeType <BootVolume | ClusterSharedVolume> -<Local | PerNode>
```

| Parameter | Required | Description |
|-----------|----------|-------------|
| `-VolumeType` | Yes | The type of volume to query. Valid values: `BootVolume`, `ClusterSharedVolume`. |
| `-Local` | No | Retrieves BitLocker details for volumes on the local node. Can be run in a regular remote PowerShell session. This is the default scope. |
| `-PerNode` | No | Retrieves BitLocker details for each node in the cluster. Requires CredSSP authentication (remote PowerShell) or a Remote Desktop (RDP) session. |

#### Enable-ASBitLocker

Enables BitLocker encryption on the specified volume type.

```powershell
Enable-ASBitLocker -VolumeType <BootVolume | ClusterSharedVolume> -<Local | Cluster> [-MountPoint <path>]
```

| Parameter | Required | Description |
|-----------|----------|-------------|
| `-VolumeType` | Yes | The type of volume to encrypt. Valid values: `BootVolume`, `ClusterSharedVolume`. |
| `-Local` | No | Encrypts volumes owned by the local node. This is the default scope. |
| `-Cluster` | No | Encrypts volumes across all nodes in the cluster. Requires CredSSP authentication. |
| `-MountPoint` | No | Targets a specific CSV by mount point path (for example, `C:\ClusterStorage\Volume1`). Only available with `-Local` scope. If omitted, all CSVs owned by the local node are encrypted. |

#### Disable-ASBitLocker

Disables BitLocker encryption on the specified volume type.

```powershell
Disable-ASBitLocker -VolumeType <BootVolume | ClusterSharedVolume> -<Local | Cluster> [-MountPoint <path>]
```

| Parameter | Required | Description |
|-----------|----------|-------------|
| `-VolumeType` | Yes | The type of volume to decrypt. Valid values: `BootVolume`, `ClusterSharedVolume`. |
| `-Local` | No | Decrypts volumes owned by the local node. This is the default scope. |
| `-Cluster` | No | Decrypts volumes across all nodes in the cluster. Requires CredSSP authentication. |
| `-MountPoint` | No | Targets a specific CSV by mount point path (for example, `C:\ClusterStorage\Volume1`). Only available with `-Local` scope. If omitted, all CSVs owned by the local node are decrypted. |

### View encryption settings for volume encryption with BitLocker

Follow these steps to view encryption settings:

1. Connect to your Azure Local machine.

1. Run the following PowerShell cmdlet by using local administrator credentials:

    ```powershell
    Get-ASBitLocker -VolumeType BootVolume -Local
    ```

   To view encryption status for Cluster Shared Volumes:

    ```powershell
    Get-ASBitLocker -VolumeType ClusterSharedVolume -Local
    ```

   To view encryption status across all nodes in the cluster (requires CredSSP or RDP):

    ```powershell
    Get-ASBitLocker -VolumeType ClusterSharedVolume -PerNode
    ```

### Enable volume encryption with BitLocker

> [!IMPORTANT]
> - Enabling volume encryption on volume type `BootVolume` requires TPM 2.0.
> - All CSVs owned by the target node must be in the **Online** state before you begin.

#### What happens during CSV encryption

When you enable BitLocker on a `ClusterSharedVolume`, the volume goes through the following lifecycle:

| Phase | Volume state | Volume accessible? | VM impact |
|-------|-------------|---------------------|-----------|
| **1. Maintenance mode** | CSV is suspended via `Suspend-ClusterResource`. | **No** — I/O to the volume is paused. | Workload VMs with virtual disks on this CSV are **paused**. |
| **2. Encryption initiated** | BitLocker encryption starts. Key protectors are created. | **No** — volume remains in maintenance mode. | VMs remain paused. |
| **3. Resume** | CSV is brought back online via `Resume-ClusterResource`. | **Yes** — volume is accessible again. | VMs resume. |
| **4. Redirected I/O** | While encryption completes in the background, the CSV enters **redirected I/O mode**. All I/O from non-owner nodes routes through the coordinator (owner) node. | **Yes** — volume is fully accessible. | VMs are running. I/O performance may be reduced on non-owner nodes until encryption completes. |
| **5. Direct I/O** | Once encryption finishes, the CSV returns to normal **direct I/O mode**. | **Yes** | No impact. |

**Plan for the maintenance window.** The duration of the maintenance phase (phases 1–2) depends on volume size and system load. During this time, workload VMs are paused and the volume is inaccessible. Perform this operation during a planned maintenance window.

> [!NOTE]
> **Key protectors:** During encryption, two key protectors are created automatically:
> - A **recovery password** — backed up to Active Directory (domain joined deployment type) and Azure Key Vault (non-domain joined deployment type) for disaster recovery.
> - An **external key** — stored at `C:\Windows\Cluster` on the owner node, used for automatic CSV unlock during failover.
>
> To save your recovery keys to an external location such as Azure Key Vault, see [Get BitLocker recovery keys](#get-bitlocker-recovery-keys).

> [!WARNING]
> If encryption fails, the system attempts to disable BitLocker and fully decrypt the volume before resuming. If cleanup also fails, the CSV may remain in **maintenance mode** and require manual investigation. Check the encryption logs at `C:\MASLogs\ASEncryptionLogs` for details.

Follow these steps to enable volume encryption with BitLocker:

1. Connect to your Azure Local machine.

1. Run the following PowerShell cmdlet by using local administrator credentials.

   To encrypt boot volumes on the local node:

    ```powershell
    Enable-ASBitLocker -VolumeType BootVolume -Local
    ```

   To encrypt all Cluster Shared Volumes owned by the local node:

    ```powershell
    Enable-ASBitLocker -VolumeType ClusterSharedVolume -Local
    ```

   To encrypt a specific CSV by mount point:

    ```powershell
    Enable-ASBitLocker -VolumeType ClusterSharedVolume -Local -MountPoint "C:\ClusterStorage\Volume1"
    ```

   To encrypt all CSVs across the cluster (requires CredSSP):

    ```powershell
    Enable-ASBitLocker -VolumeType ClusterSharedVolume -Cluster
    ```

### Disable volume encryption by using BitLocker

Disabling BitLocker follows the same maintenance mode lifecycle as enabling it: the process suspends the CSV, initiates decryption, and then resumes the CSV. Decryption continues in the background while the volume is accessible in redirected I/O mode.

Follow these steps to disable volume encryption by using BitLocker:

1. Connect to your Azure Local machine.

1. Run the following PowerShell cmdlet by using local administrator credentials.

   To decrypt boot volumes on the local node:

    ```powershell
    Disable-ASBitLocker -VolumeType BootVolume -Local
    ```

   To decrypt all Cluster Shared Volumes owned by the local node:

    ```powershell
    Disable-ASBitLocker -VolumeType ClusterSharedVolume -Local
    ```

   To decrypt a specific CSV by mount point:

    ```powershell
    Disable-ASBitLocker -VolumeType ClusterSharedVolume -Local -MountPoint "C:\ClusterStorage\Volume1"
    ```

   To decrypt all CSVs across the cluster (requires CredSSP):

    ```powershell
    Disable-ASBitLocker -VolumeType ClusterSharedVolume -Cluster
    ```

## Get BitLocker recovery keys

> [!NOTE]
> You can retrieve BitLocker keys at any time from your local Active Directory. If the cluster is down and you don't have the keys, you might be unable to access the encrypted data on the cluster. To save your BitLocker recovery keys, we recommend that you export and store them in a secure external location such as Azure Key Vault.

To export the recovery keys for your cluster, follow these steps:

1. Connect to your Azure Local instance as local administrator. Run the following command in a local console session, local Remote Desktop Protocol (RDP) session, or a Remote PowerShell session with CredSSP authentication:

1. To get the recovery key information, run the following command in PowerShell:

    ```powershell
    Get-AsRecoveryKeyInfo | ft ComputerName, PasswordID, RecoveryKey
    ```

   Here's a sample output:

   ```output
    PS C:\Users\ashciuser> Get-AsRecoveryKeyInfo | ft ComputerName, PasswordID, RecoveryKey

    ComputerName    PasswordId    RecoveryKey
    -------         ----------    -----------
    NODE01    {Password1}   Key1
    NODE02    {Password2}   Key2
    NODE03    {Password3}   Key3
    NODE04    {Password4}   Key4
    ```

## Next steps

For more information about BitLocker integration with Cluster Shared Volumes, see:

- [Use BitLocker with Cluster Shared Volumes](/windows-server/failover-clustering/bitlocker-on-csv-in-ws-2022).
