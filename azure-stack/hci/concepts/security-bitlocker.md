---
title: BitLocker encryption on Azure Stack HCI (preview)
description: Learn how to get BitLocker recovery keys on your Azure Stack HCI cluster (preview).
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/14/2023
---

# BitLocker encryption for Azure Stack HCI (preview)

>Applies to: Azure Stack HCI, versions 23H2 (preview) and 22H2 Supplemental Package

This article describes the BitLocker encryption enabled on Azure Stack HCI and the procedure to retrieve your BitLocker keys if the system needs to be restored.

[!INCLUDE [important](../../includes/hci-preview.md)]

## About BitLocker encryption

On your Azure Stack HCI cluster, all the data-at-rest is encrypted via BitLocker XTS-AES 256-bit encryption. When you deploy your Azure Stack HCI cluster, you have the option to modify the associated security settings. By default, the data-at-rest encryption is enabled on your data volumes. We recommend that you accept the default setting.

Once Azure Stack HCI is successfully deployed, you can retrieve the BitLocker recovery keys. We recommend that you store the BitLocker keys in a secure location outside of the system. The recovery keys help you recover the local data if a system is restored from a backup image.

> [!NOTE]
> It is important that you save the BitLocker keys outside of the system. If the cluster is down and you don't have the key, it could potentially result in data loss.

## Manage BitLocker encryption

You can enable, disable, and view BitLocker encryption settings on your Azure Stack HCI cluster. Follow these steps to modify the BitLocker encryption:

1. Connect to a server on your Azure Stack HCI system via Remote Desktop Protocol.

2. Use option 15 in *Sconfig* to open a PowerShell session.

3. To enable BitLocker encryption, use the following cmdlet:

    ```PowerShell
    Get-command -Module AzureStackBitlockerAgent -Name Enable-ASBitlocker
    ```
    To disable encryption, use the following:
    ```PowerShell
    Get-command -Module AzureStackBitlockerAgent -Name Disable-ASBitlocker
    ```
    To view encryption settings, use the following:
    ```PowerShell
    Get-command -Module AzureStackBitlockerAgent -Name Get-ASBitlocker
    ```

## Get BitLocker recovery keys

Follow these steps to get the BitLocker recovery keys for your cluster.

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

- [Azure Stack HCI security considerations](./security.md).
