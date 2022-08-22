---
title: BitLocker encryption
description: Learn how to get your BitLocker recovery keys.
author: meaghanlewis
ms.author: mosagie
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/22/2022
---

# BitLocker encryption

Out of the box data-at-rest encryption is enabled with the military grade standard XTS AES256.

We recommend you retrieve your BitLocker recovery keys right after the deployment and store them in a secure location outside of the system. Not having the recovery keys during certain support scenarios may result in data loss and require a system restore from a backup image.  

## How to get your BitLocker recovery keys

1. Open a PowerShell session as Admin and use the following command (make sure you add your host IP address.)

```powershell
Invoke-Command -ComputerName <host ip address> -Credential $cred -Authentication Credssp -ScriptBlock { Get-AszRecoveryKeyInfo } | ft ComputerName, PasswordID, RecoveryKey
```

2. Sign in with your Administrator account credentials.

![Image showing the Windows PowerShell credential request.](media/security-bitlocker/powershell-credentials.png)

3. See the results of the recovery keys displayed in PowerShell.

![Image showing a PowerShell window displaying recovery keys.](media/security-bitlocker/recovery-keys.png)

## Next steps

- [Azure Stack HCI security considerations](./security.md)
