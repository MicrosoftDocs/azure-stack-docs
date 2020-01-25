---
title: Add Azure Stack Hub users in AD FS
description: Learn how to add Azure Stack Hub users for Active Directory Federation Services (AD FS) deployments.
author: PatAltimore

ms.topic: article
ms.date: 06/03/2019
ms.author: patricka
ms.reviewer: unknown
ms.lastreviewed: 06/03/2019

---
# Add a new Azure Stack Hub user account in Active Directory Federation Services (AD FS)

You can use the **Active Directory Users and Computers** snap-in to add additional users to an Azure Stack Hub environment, using AD FS as its identity provider.

## Add Windows Server Active Directory users

1. Sign in to a computer with an account that provides access to the Windows Administrative Tools and open a new Microsoft Management Console (MMC).
2. Select **File > Add or remove snap-in**.

   > [!TIP]
   > Replace *directory-domain* with the domain that matches your directory. 

3. Select **Active Directory Users and Computers** > *directory-domain* > **Users**.
4. Select **Action** > **New** > **User**.
5. In New Object - User, provide user details. Select **Next**.
6. Provide and confirm a password.
7. Select **Next** to complete the values. Select **Finish** to create the user.


## Next steps

[Create an app identity to access Azure Stack Hub resources](azure-stack-create-service-principals.md)