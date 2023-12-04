---
title: Manage BitLocker encryption on Azure Stack HCI, version 23H2 (preview)
description: Learn how to manage BitLocker encryption on your system using Azure Stack HCI, version 23H2 (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/04/2023
---

# Manage BitLocker encryption for Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes the BitLocker encryption enabled on Azure Stack HCI and the procedure to retrieve your BitLocker keys to restore the system.

[!INCLUDE [important](../../includes/hci-preview.md)]

> [!NOTE]
> It's important to save the BitLocker keys outside of the system. If the cluster is down and you don't have the key, it could potentially result in data loss.

You can view, enable, and disable BitLocker encryption settings on your Azure Stack HCI cluster.

## PowerShell cmdlet properties for `AzureStackBitLockerAgent` module

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
