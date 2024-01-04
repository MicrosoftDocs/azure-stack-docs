---
title: Manage secrets rotation on Azure Stack HCI, version 23H2 (preview)
description: This article describes how to manage internal secret rotation on Azure Stack HCI, version 23H2 (preview).
author:  alkohli
ms.author:  alkohli
ms.topic: how-to
ms.date: 01/04/2024
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

# Manage secrets rotation on Azure Stack HCI, version 23H2 (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage internal secret rotation on Azure Stack HCI.

[!INCLUDE [important](../../includes/hci-preview.md)]

All services exposed internally by Lifecycle Manager have authentication or encryption certificates associated with them. When you review your cluster nodes, you will see several certificates created under the path `LocalMachine/Personal certificate store (Cert:\LocalMachine\My).

## Rotate credentials

Use the PowerShell cmdlet `Set-azurestacklcmuserpassword` to rotate `AzureStackLCMUserCredential` domain administrator credential secrets.

This cmdlet rotates the credentials of the user that connects to the server hosts.

## PowerShell cmdlet and properties

The `Set-azurestacklcmuserpassword` cmdlet takes 3 input properties:

- `Identity`: Username of the user whose credentials are to be rotated.

- `OldPassword`: The current password of the user.

- `NewPassword`: The new password for the user.

Note that the computer session used to run this cmdlet becomes unresponsive once the command completes. You will be logged out while the credential change takes effect in Active Directory.

## Next steps

- [Review the deployment checklist and install Azure Stack HCI, version 23H2](../deploy/deployment-checklist.md).
