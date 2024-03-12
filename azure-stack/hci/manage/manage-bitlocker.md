---
title: Manage BitLocker encryption on Azure Stack HCI, version 23H2
description: Learn how to manage BitLocker encryption on your Azure Stack HCI, version 23H2 system.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 03/12/2024
---

# Manage BitLocker encryption on Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to view and enable BitLocker encryption, and retrieve BitLocker recovery keys on your Azure Stack HCI system.

## Prerequisites

Before you begin, make sure that the following prerequisites are completed:

- You have access to an Azure Stack HCI, version 23H2 system that is deployed, registered, and connected to Azure.
- If viewing settings via the Azure portal, make sure to satisfy these extra prerequisites:
    - You have applied the Microsoft Cloud Security Benchmark (MCSB) initiative. See [Apply Microsoft Cloud Security Benchmark initiative](#apply-microsoft-cloud-security-benchmark-initiative).
    - You have at least **Owner** or **Contributor** roles in your Azure subscription to apply MCSB.

### Apply Microsoft Cloud Security Benchmark initiative

[!INCLUDE [hci-apply-security-benchmark-initiative](../../includes/hci-apply-security-benchmark-initiative.md)]

## View BitLocker settings via Azure portal

BitLocker offers two types of protection: encryption for OS volumes and encryption for data volumes. You can only view BitLocker settings in the Azure portal. To manage the settings, see [Manage BitLocker settings with PowerShell](#manage-bitlocker-settings-with-powershell).

:::image type="content" source="media/manage-bitlocker/manage-bitlocker.png" alt-text="Screenshot that shows the Data protections page for volume encryption on Azure portal." lightbox="media/manage-bitlocker/manage-bitlocker.png":::

## Manage BitLocker settings with PowerShell

You can view, enable, and disable volume encryption settings on your Azure Stack HCI cluster.

### PowerShell cmdlet properties

The following cmdlet properties are for volume encryption with BitLocker module: *AzureStackBitLockerAgent*.

- ```powershell
    Get-ASBitLocker -<Local | PerNode>
    ```

  Where `Local` and`PerNode` define the scope at which the cmdlet is run.
  - **Local** - Can be run in a regular remote PowerShell session and provides BitLocker volume details for the local node.
  - **PerNode** - Requires CredSSP (when using remote PowerShell) or a remote desktop session (RDP). Provides BitLocker volume details per node.

- ```powershell
    Enable-ASBitLocker -<Local | Cluster> -VolumeType <BootVolume | ClusterSharedVolume>
    ```


- ```powershell
    Disable-ASBitLocker -<Local | Cluster> -VolumeType <BootVolume | ClusterSharedVolume>
    ```


### View encryption settings for volume encryption with BitLocker

Follow these steps to view encryption settings:

1. Connect to your Azure Stack HCI node.

1. Run the following PowerShell cmdlet using local administrator credentials:

    ```PowerShell
    Get-ASBitLocker
    ```

### Enable, disable volume encryption with BitLocker

Follow these steps to enable volume encryption with BitLocker:

1. Connect to your Azure Stack HCI node.

1. Run the following PowerShell cmdlet using local administrator credentials:

   > [!IMPORTANT]
   > - Enabling volume encryption with BitLocker on volume type BootVolume requires TPM 2.0.
   >
   > - While enabling volume encryption with BitLocker on volume type `ClusterSharedVolume` (CSV), the volume will be put in redirected mode and any workload VMs will be paused for a short time. This operation is disruptive; plan accordingly. For more information, see [How to configure BitLocker encrypted clustered disks in Windows Server 2012](https://techcommunity.microsoft.com/t5/failover-clustering/how-to-configure-bitlocker-encrypted-clustered-disks-in-windows/ba-p/371825).

    ```PowerShell
    Enable-ASBitLocker
    ```

Follow these steps to disable volume encryption with BitLocker:

1. Connect to your Azure Stack HCI node.

1. Run the following PowerShell cmdlet using local administrator credentials:

    ```PowerShell
    Disable-ASBitLocker
    ```

## Get BitLocker recovery keys

> [!NOTE]
> It's important to save BitLocker keys outside of the system. If the cluster is down and you don't have the key, it could potentially result in data loss.

Follow these steps to get recovery keys for your cluster:

1. Connect to your Azure Stack HCI cluster as local administrator.

1. To get the recovery key information, run the following command in PowerShell:

    ```powershell
    Get-AsRecoveryKeyInfo | ft ComputerName, PasswordID, RecoveryKey
    ```

   Here's a sample output:

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
