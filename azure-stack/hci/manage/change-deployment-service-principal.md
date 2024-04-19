---
title: Change deployment service principal on Azure Stack HCI, version 23H2
description: This article describes how to change the deployment service principal on Azure Stack HCI, version 23H2.
author:  alkohli
ms.author:  alkohli
ms.topic: how-to
ms.date: 03/26/2024
ms.service: azure-stack
ms.subservice: azure-stack-hci
---

# Change deployment service principal on Azure Stack HCI, version 23H2

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how you can change the service principal secret used for deployment. This scenario only applies when you have upgraded from Azure Stack HCI running version 2306 to Azure Stack HCI version 23H2.

Complete these steps in order to change the deployment service principal:

1. Sign on to your Azure Active Directory account.
1. Locate the deployment service principal and then create a new client secret.
1. Make a note of the appID and the new client secret.
1. Sign on to one of you Azure Stack HCI server nodes using the deployment user credentials.
1. Run following PowerShell commands:

    ```azurepowershell
    Import-Module Microsoft.AS.ArcIntegration.psm1 -Force
    $secretText=ConvertTo-SecureString -String <client_secret> -AsPlainText -Force
    Update-ServicePrincipalName -AppId <appID> -SecureSecretText $secretText
    ```
