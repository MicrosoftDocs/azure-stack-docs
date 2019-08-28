---
title: Add Azure Stack users in AD FS | Microsoft Docs
description: Learn how to add Azure Stack users for Active Directory Federation Services (AD FS) deployments.
services: azure-stack
documentationcenter: ''
author: PatAltimore
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 06/03/2019
ms.author: patricka
ms.reviewer: unknown
ms.lastreviewed: 06/03/2019

---
# Add Azure Stack users in AD FS
You can use the **Active Directory Users and Computers** snap-in to add additional users to an Azure Stack environment using Active Directory Federation Services (AD FS) as its identity provider.

## Add Windows Server Active Directory users
> [!TIP]
> This example uses the default azurestack.local ASDK active directory. 

1. Sign in to a computer with an account that provides access to the Windows Administrative Tools and open a new Microsoft Management Console (MMC).
2. Select **File > Add or remove snap-in**.
3. Select **Active Directory Users and Computers** > **AzureStack.local** > **Users**.
4. Select **Action** > **New** > **User**.
5. In New Object - User, provide user details. Select **Next**.
6. Provide and confirm a password.
7. Select **Next** to complete the values. Select **Finish** to create the user.


## Next steps
[Create service principals](azure-stack-create-service-principals.md)