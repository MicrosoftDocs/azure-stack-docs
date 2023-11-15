---
title: BitLocker encryption on Azure Stack HCI, version 23H2 (preview)
description: Learn how to get BitLocker recovery keys and manage BitLocker encryption on your system using Azure Stack HCI, version 23H2 (preview).
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/13/2023
---

# BitLocker encryption for Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes the BitLocker encryption enabled on Azure Stack HCI and the procedure to retrieve your BitLocker keys if the system needs to be restored.

[!INCLUDE [important](../../includes/hci-preview.md)]

## About BitLocker encryption

On your Azure Stack HCI cluster, all the data-at-rest is encrypted via BitLocker XTS-AES 256-bit encryption. When you deploy your Azure Stack HCI cluster, you have the option to modify the associated security settings. By default, the data-at-rest encryption is enabled on your data volumes created durign deployment. We recommend that you accept the default setting.

> [!NOTE]
> Cluster Shared Volumes created after deployment might need to be encrypted. Use the Powershell cmdlets to [Enable Bitlocker on newly created volumes](#manage-bitlocker-encryption).

Once Azure Stack HCI is successfully deployed, you can retrieve the BitLocker recovery keys. We recommend that you store the BitLocker keys in a secure location outside of the system. The recovery keys help you recover the local data if a system is restored from a backup image.

> [!NOTE]
> It is important that you save the BitLocker keys outside of the system. If the cluster is down and you don't have the key, it could potentially result in data loss.

## Manage BitLocker encryption

You can view, enable, and disable BitLocker encryption settings on your Azure Stack HCI cluster.

### PowerShell cmdlet properties for `AzureStackBitLockerAgent` module

The following cmdlet properties are for BitLocker module: *AzureStackBitLockerAgent*.

- `Get-ASBitLocker` - Scope <Local | PerNode | AllNodes | Cluster>
     - **Local** - Provides BitLocker volume details for the local node. Can be run in a regular remote PowerShell session.
     - **PerNode** - Provides BitLocker volume details per node. Requires CredSSP (when using remote PowerShell) or Console session (RDP).
 - `Enable-ASBitLocker` - Scope <Local | Cluster> -VolumeType <BootVolume | ClusterSharedVolume>
 - `Disable-ASBitLocker` - Scope <Local | Cluster> -VolumeType <BootVolume | ClusterSharedVolume>

## View BitLocker encryption settings

Use the following steps to view BitLocker encryption settings:

1. Connect to your Azure Stack HCI node.

2. Run the following PowerShell cmdlet using local administrator credentials:

    ```PowerShell
    Get-ASBitLocker
    ```

## Modify BitLocker encryption

Use the following steps to modify BitLocker encryption:

1. Connect to your Azure Stack HCI node.

2. Run the following PowerShell cmdlets using local administrator credentials:

   **Enable BitLocker encryption:**

   > [!IMPORTANT]
   > - Enabling BitLocker on volume type BootVolume requires TPM 2.0.
   >
   > - While enabling BitLocker on volume type `ClusterSharedVolume` (CSV), the volume will be put in redirected mode and any workload VMs will be paused for a short time. This operation is disruptive; plan accordingly.

    ```PowerShell
    Enable-ASBitLocker
    ```

   **Disable BitLocker encryption:**

    ```PowerShell
    Disable-ASBitLocker
    ```

## Get BitLocker recovery keys

Use the following steps to get the BitLocker recovery keys for your cluster.

1. Run PowerShell as Administrator on your Azure Stack HCI cluster.
1. Run the following command in PowerShell:

    ```powershell
    Get-AsRecoveryKeyInfo | ft ComputerName, PasswordID, RecoveryKey
    ```

   Here is sample output:

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

- [Assess deployment readiness via the Environment Checker](../manage/use-environment-checker.md).
