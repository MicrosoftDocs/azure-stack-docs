---
title: Let your Cloud Solution Provider manage your Azure Stack Hub subscription 
description: Learn how to let your Cloud Solution Provider (CSP) manage your Azure Stack Hub subscription for you.
author: sethmanheim

ms.topic: article
ms.date: 01/22/2020
ms.author: sethm
ms.reviewer: alfredop
ms.lastreviewed: 05/20/2019

---

# Let your Cloud Solution Provider manage your Azure Stack Hub subscription

If you use Azure Stack Hub with a Cloud Solution Provider (CSP), you might choose to manage your own subscription to access resources in Azure and in Azure Stack Hub. You can also let the provider manage your subscription for you. This article shows you how to:

* Give your service provider access to your subscription.
* Make sure the service provider can manage your service.

> [!NOTE]
> If the CSP is not managing your account, and you skip the following steps, the CSP cannot manage your Azure Stack Hub subscription for you.

## Manage your subscription with a CSP

Add the CSP as **user** to your subscription.

1. Add your CSP as a guest user with the **user** role to your tenant directory. For help with adding a user, see [Add new users to Azure Active Directory](/azure/active-directory/add-users-azure-active-directory).

2. The CSP creates the local Azure Stack Hub subscription for you. You are ready to start using Azure Stack Hub.

3. Your CSP should create a resource in your subscription to verify that they can also manage your resources. For example, they can [Create a Windows virtual machine with the Azure Stack Hub portal](azure-stack-quick-windows-portal.md).

## Let the CSP manage your subscription using RBAC rights

Add the CSP as **owner** to your subscription.

1. Add your CSP as guest user to your tenant directory. For information about adding a user, see [Add new users to Azure Active Directory](/azure/active-directory/add-users-azure-active-directory).

2. Add the **Owner** role to the CSP guest user. For information about adding a CSP user to your subscription, see [Use Role-Based Access Control to manage access to your Azure subscription resources](/azure/role-based-access-control/role-assignments-portal). The CSP creates the local Azure Stack Hub subscription for you. You are ready to start using Azure Stack Hub.
3. Your CSP should create a resource in your subscription to verify that they can manage your resources.

## Next steps

* To learn more about how to retrieve resource usage information from Azure Stack Hub, see [Usage and billing in Azure Stack Hub](../operator/azure-stack-billing-and-chargeback.md).
