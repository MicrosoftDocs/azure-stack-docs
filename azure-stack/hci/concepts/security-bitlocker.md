---
title: BitLocker encryption on Azure Stack HCI (preview)
description: Learn how to get your BitLocker recovery keys (preview).
author: meaghanlewis
ms.author: mosagie
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/06/2022
---

# BitLocker encryption for Azure Stack HCI (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes the BitLocker encryption enabled on Azure Stack HCI and the procedure to retrieve your BitLocker keys if the system needs to be restored.

[!INCLUDE [important](../../includes/hci-preview.md)]

## About BitLocker encryption

On your Azure Stack HCI cluster, all the data-at-rest is encrypted via BitLocker XTS-AES 256-bit encryption. When you deploy your Azure Stack HCI cluster, you have the option to modify the associated security settings. By default, the data-at-rest encryption is enabled on your data volumes. We recommend that you accept the default setting.

Once Azure Stack HCI is successfully deployed, you can retrieve the BitLocker recovery keys. We recommend that you store the BitLocker keys in a secure location outside of the system. The recovery keys help you recover the local data if a system is restored from a backup image.

> [!NOTE]
> It is important that you save the BitLocker keys outside of the system. If the cluster is down and you don't have the key, it could potentially result in data loss.

## Get BitLocker recovery keys

Follow these steps to get the BitLocker recovery keys for your cluster.

1. Run PowerShell as Administrator on your Azure Stack HCI cluster.
1. Run the following command in PowerShell:

    ```powershell
    Get-AsRecoveryKeyInfo | ft ComputerName, PasswordID, RecoveryKey
    ```

1. See the results of the recovery keys displayed in PowerShell.

    ![Image showing a PowerShell window displaying recovery keys.](media/security-bitlocker/recovery-keys.png)

## Next steps

- [Azure Stack HCI security considerations](./security.md)
