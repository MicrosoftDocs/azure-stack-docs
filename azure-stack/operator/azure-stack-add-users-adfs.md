---
title: Add Azure Stack Hub users in AD FS
description: Learn how to add Azure Stack Hub users for Active Directory Federation Services (AD FS) deployments.
author: sethmanheim
ms.topic: how-to
ms.date: 08/15/2024
ms.author: sethm
ms.reviewer: unknown
ms.lastreviewed: 06/03/2019

# Intent: As an Azure Stack operator, I want to to add new users using AD FS.
# Keyword: add users ad fs azure stack

---

# Add a new Azure Stack Hub user account in Active Directory Federation Services (AD FS)

You can use the **Active Directory Users and Computers** snap-in to add additional users to an Azure Stack Hub environment, using AD FS as its identity provider.

## Add Windows Server Active Directory users

1. Sign in to a computer with an account that provides access to the Windows administrative tools and open a new Microsoft Management Console (MMC).
1. Select **File > Add or remove snap-in**.

   > [!TIP]
   > Replace **directory-domain** with the domain that matches your directory. 

1. Select **Active Directory Users and Computers > directory-domain > Users**.
1. Select **Action > New > User**.
1. In **New Object - User**, provide user details. Select **Next**.
1. Provide and confirm a password.
1. Select **Next** to complete the values. Select **Finish** to create the user.

## Next steps

[Create an app identity to access Azure Stack Hub resources](give-app-access-to-resources.md)
