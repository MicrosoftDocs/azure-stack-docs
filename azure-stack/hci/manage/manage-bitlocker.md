---
title: Manage volume encryption with BitLocker on Azure Stack HCI, version 23H2 (preview)
description: Learn how to manage volume encryption with Bitlocker on your Azure Stack HCI, version 23H2 system (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 01/25/2024
---

# Manage volume encryption with BitLocker on Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage volume encryption and network protection with BitLocker, and how to retrieve BitLocker recovery keys on your Azure Stack HCI system.

[!INCLUDE [important](../../includes/hci-preview.md)]

## View BitLocker settings

### View settings via Azure portal

You can use two kinds of protection, volume encryption and network encryption.

:::image type="content" source="media/manage-bitlocker/manage-bitlocker.png" alt-text="Screenshot that shows the Data protections page on Azure." lightbox="media/manage-bitlocker/manage-bitlocker.png":::

- **Volume encryption** - Use BitLocker to encrypt data on your OS volumes and data volumes.
- **Network protection** - Use BitLocker to protect data on the host's network and on VM network connections.

### Manage security settings with PowerShell

## Enable BitLocker encryption

> [!NOTE]
> It's important to save the BitLocker keys outside of the system. If the cluster is down and you don't have the key, it could potentially result in data loss.

You can view, enable, and disable BitLocker encryption settings on your Azure Stack HCI cluster.

## PowerShell cmdlet properties

The following cmdlet properties are for BitLocker module: *AzureStackBitLockerAgent*.

- `Get-ASBitLocker` - Scope <Local | PerNode | AllNodes | Cluster>
  - **Local** - Provides BitLocker volume details for the local node. Can be run in a regular remote PowerShell session.
  - **PerNode** - Provides BitLocker volume details per node. Requires CredSSP (when using remote PowerShell) or a remote desktop session (RDP).
- `Enable-ASBitLocker` - Scope <Local | Cluster> -VolumeType <BootVolume | ClusterSharedVolume>
- `Disable-ASBitLocker` - Scope <Local | Cluster> -VolumeType <BootVolume | ClusterSharedVolume>

## View BitLocker encryption settings

Follow these steps to view BitLocker encryption settings:

1. Connect to your Azure Stack HCI node.

1. Run the following PowerShell cmdlet using local administrator credentials:

    ```PowerShell
    Get-ASBitLocker
    ```

## Enable, disable BitLocker encryption

Follow these steps to enable BitLocker encryption:

1. Connect to your Azure Stack HCI node.

1. Run the following PowerShell cmdlet using local administrator credentials:

   > [!IMPORTANT]
   > - Enabling BitLocker on volume type BootVolume requires TPM 2.0.
   >
   > - While enabling BitLocker on volume type `ClusterSharedVolume` (CSV), the volume will be put in redirected mode and any workload VMs will be paused for a short time. This operation is disruptive; plan accordingly. For more information, see [How to configure BitLocker encrypted clustered disks in Windows Server 2012](https://techcommunity.microsoft.com/t5/failover-clustering/how-to-configure-bitlocker-encrypted-clustered-disks-in-windows/ba-p/371825).

    ```PowerShell
    Enable-ASBitLocker
    ```

Follow these steps to disable BitLocker encryption:

1. Connect to your Azure Stack HCI node.

1. Run the following PowerShell cmdlet using local administrator credentials:

    ```PowerShell
    Disable-ASBitLocker
    ```

## Get BitLocker recovery keys

Follow these steps to get the BitLocker recovery keys for your cluster:

1. Connect to your Azure Stack HCI cluster as local administrator.

1. To get the recovery key information, run the following command in PowerShell:

    ```powershell
    Get-AsRecoveryKeyInfo | ft ComputerName, PasswordID, RecoveryKey
    ```

   Here is a sample output:

   ```output
    PS C:\Users\ashciuser> Get-AsRecoveryKeyInfo | ft ComputerName, PasswordID, RecoveryKey

    ComputerName    PasswordId    RecoveryKey
    -------         ----------    -----------
    ASB88RR1OU19    {Password1}   Key1
    ASB88RR1OU20    {Password2}   Key2
    ASB88RR1OU21    {Password3}   Key3
    ASB88RR1OU22    {Password4}   Key4
    ```

## Next steps

- [Use BitLocker with Cluster Shared Volumes](../manage/bitlocker-on-csv.md#use-bitlocker-with-cluster-shared-volumes).
