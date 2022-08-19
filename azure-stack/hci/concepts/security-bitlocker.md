---
title: BitLocker Encryption
description: Learn how to encrypt BitLocker.
author: meaghanlewis
ms.author: mosagie
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 08/19/2022
---

# BitLocker Encryption

Out of the box data-at-rest encryption is enabled with the military grade standard XTS AES256. We recommend you retrieve your BitLocker recovery keys right after the deployment and store them in a secure location outside of the system. Not having the recovery keys during certain support scenarios may result in data loss and require a system restore from a backup image.  

How to get your BitLocker recovery key:

1. Open PowerShell session as Admin and use the following command (make sure you add your host IP address.)

```powershell
Invoke-Command -ComputerName <host ip address> -Credential $cred -Authentication Credssp -ScriptBlock { Get-AszRecoveryKeyInfo } | ft ComputerName, PasswordID, RecoveryKey
```

2. Login with your Administrator account / password
3. See the results of the Recovery keys:

## Next steps

- [Azure Stack HCI security considerations](./security.md)
