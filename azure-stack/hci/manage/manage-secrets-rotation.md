---
title: Change deployment user password on Azure Stack HCI, version 23H2
description: This article describes how to manage internal secret rotation on Azure Stack HCI, version 23H2.
author:  alkohli
ms.author:  alkohli
ms.topic: how-to
ms.date: 01/31/2024
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

# Change deployment user password on Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how you can change the password associated with the deployment user on Azure Stack HCI.

## Change password

Use the PowerShell cmdlet `Set-azurestacklcmuserpassword` to rotate `AzureStackLCMUserCredential` domain administrator credential secrets.

The cmdlet changes the password of the user that connects to the server hosts.

## PowerShell cmdlet and properties

The `Set-azurestacklcmuserpassword` cmdlet takes 3 input properties:

- `Identity`: Username of the user whose password you want to change.

- `OldPassword`: The current password of the user.

- `NewPassword`: The new password for the user.

Once the password is changed, the session ends. You need to sign in with the updated password.

## Next steps

- [Complete the prerequisites and checklist and install Azure Stack HCI, version 23H2](../deploy/deployment-prerequisites.md).
