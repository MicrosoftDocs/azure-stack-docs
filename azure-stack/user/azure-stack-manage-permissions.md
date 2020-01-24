---
title: Manage access to resources in Azure Stack Hub with role-based access control | Microsoft Docs
description: Learn how to manage role-based access control (RBAC) permissions as an admin or a tenant in Azure Stack Hub.
author: bryanla

ms.service: azure-stack
ms.topic: article
ms.date: 09/13/2019
ms.author: bryanla
ms.reviewer: fiseraci
ms.lastreviewed: 03/11/2019

---

# Manage access to resources in Azure Stack Hub with role-based access control

Azure Stack Hub supports role-based access control (RBAC), the same [security model for access management](/azure/role-based-access-control/overview) that Microsoft Azure uses. You can use RBAC to manage user, group, or app access to subscriptions, resources, and services.

## Basics of access management

Role-based access control (RBAC) provides fine-grained access control that you can use to secure your environment. You give users the exact permissions they need by assigning an RBAC role at a certain scope. The scope of the role assignment can be a subscription, a resource group, or a single resource. For more detailed information about access management, see the [Role-Based Access Control in the Azure portal](/azure/role-based-access-control/overview) article.

> [!NOTE]
> When Azure Stack Hub is deployed using Active Directory Federation Services as the identity provider, only Universal Groups are supported for RBAC scenarios.

### Built-in roles

Azure Stack Hub has three basic roles that you can apply to all resource types:

* **Owner**: can manage everything, including access to resources.
* **Contributor**: can manage everything, except access to resources.
* **Reader**: can view everything, but can't make any changes.

### Resource hierarchy and inheritance

Azure Stack Hub has the following resource hierarchy:

* Each subscription belongs to one directory.
* Each resource group belongs to one subscription.
* Each resource belongs to one resource group.

Access that you grant at a parent scope is inherited at child scopes. For example:

* You assign the **Reader** role to an Azure AD group at the subscription scope. The members of that group can view every resource group and resource in the subscription.
* You assign the **Contributor** role to an app at the resource group scope. The app can manage resources of all types in that resource group, but not other resource groups in the subscription.

### Assigning roles

You can assign more than one role to a user and each role can be associated with a different scope. For example:

* You assign TestUser-A the **Reader** role to Subscription-1.
* You assign TestUser-A the **Owner** role to TestVM-1.

The Azure [role assignments](/azure/role-based-access-control/role-assignments-portal) article provides detailed information about viewing, assigning, and deleting roles.

## Set access permissions for a user

The following steps describe how to configure permissions for a user.

1. Sign in with an account that has owner permissions to the resource you want to manage.
2. In the left navigation pane, choose **Resource groups**.
3. Choose the name of the resource group that you want to set permissions on.
4. In the resource group navigation pane, choose **Access control (IAM)**.<BR> The **Role Assignments** view lists the items that have access to the resource group. You can filter and group the results.
5. On the **Access control** menu bar, choose **Add**.
6. On **Add permissions** pane:

   * Choose the role you want to assign from the **Role** drop-down list.
   * Choose the resource you want to assign from the **Assign access to** drop-down list.
   * Select the user, group, or app in your directory that you wish to grant access to. You can search the directory with display names, email addresses, and object identifiers.

7. Select **Save**.

## Next steps

[Create service principals](../operator/azure-stack-create-service-principals.md)
