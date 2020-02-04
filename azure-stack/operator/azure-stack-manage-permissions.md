---
title: Set access permissions using role-based access control 
description: Learn how to set access permissions using role-based access control (RBAC) in Azure Stack Hub.
author: justinha

ms.topic: article
ms.date: 12/23/2019
ms.author: justinha
ms.reviewer: thoroet
ms.lastreviewed: 12/23/2019

---
# Set access permissions using role-based access control

A user in Azure Stack Hub can be a reader, owner, or contributor for each instance of a subscription, resource group, or service. For example, User A might have reader permissions to Subscription One, but have owner permissions to Virtual Machine Seven.

 - Reader: User can view everything, but can't make any changes.
 - Contributor: User can manage everything except access to resources.
 - Owner: User can manage everything, including access to resources.
 - Custom: User has limited, specific access to resources.

 For more information about creating a custom role, see [Custom roles for Azure resources](https://docs.microsoft.com/azure/role-based-access-control/custom-roles).

## Set access permissions for a user

1. Sign in with an account that has owner permissions to the resource you want to manage.
2. In the blade for the resource, click the **Access** icon ![](media/azure-stack-manage-permissions/image1.png).
3. In the **Users** blade, click **Roles**.
4. In the **Roles** blade, click **Add** to add permissions for the user.

## Set access permissions for a universal group 

> [!Note]
> Applicable only to Active Directory Federated Services (AD FS).

1. Sign in with an account that has owner permissions to the resource you want to manage.
2. In the blade for the resource, click the **Access** icon ![](media/azure-stack-manage-permissions/image1.png).
3. In the **Users** blade, click **Roles**.
4. In the **Roles** blade, click **Add** to add permissions for the Universal Group Active Directory Group.

## Next steps

[Add an Azure Stack Hub tenant](azure-stack-add-new-user-aad.md)