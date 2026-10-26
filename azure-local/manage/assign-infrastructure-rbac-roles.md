---
title: Use built-in RBAC roles to manage infrastructure in Azure Local (preview)
description: Learn how to use Azure role-based access control to manage access to infrastructure resources in Azure Local (preview).
author: dominicbetts
ms.author: dobett
ms.topic: how-to
ms.date: 10/07/2026
ms.subservice: hyperconverged
---

# Use built-in RBAC roles to manage infrastructure in Azure Local (preview)

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to use Azure role-based access control (RBAC) to manage access to infrastructure resources in Azure Local. Currently, the built-in infrastructure roles apply only to GPU infrastructure. These roles help separate GPU infrastructure administration from workload administration and support least-privilege access.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## About the built-in infrastructure RBAC roles

Use the following built-in roles to grant the minimum level of GPU infrastructure access required:

- **Azure Stack HCI Administrator**: Provides full access to Azure Local infrastructure and its resources. Users assigned this role can view and modify GPU infrastructure settings and assign roles to other users.
- **Azure Local Infrastructure Contributor**: Can view GPU infrastructure properties, metrics, and health, and manage GPU infrastructure. Users assigned this role can't assign roles.
- **Azure Local Infrastructure Reader**: Provides read-only access to GPU infrastructure properties, metrics, and health. Users assigned this role can't modify GPU infrastructure or assign roles.

These roles provide access to GPU infrastructure resources. Workload operations might require separate workload roles.

For example, to assign a GPU to or remove a GPU from a virtual machine (VM), you need both the applicable infrastructure role and VM role.

## Role capability comparison

The following table compares the capabilities of the built-in infrastructure roles.

| Built-in role | Infrastructure resources | Role assignments |
| --- | --- | --- |
| **Azure Stack HCI Administrator** | View properties, metrics, and health. Manage GPU infrastructure. | Can assign infrastructure roles to users and other security principals. |
| **Azure Local Infrastructure Contributor** | View properties, metrics, and health. Manage GPU infrastructure. | Can't assign roles. |
| **Azure Local Infrastructure Reader** | View properties, metrics, and health. | Can't modify infrastructure resources. Can't assign roles. |

## Prerequisites

Before you begin, ensure that you have:

- An Azure subscription that contains the Azure Local resources you want to manage.
- Permission to create role assignments at the selected scope. Typically, this permission requires the Owner or User Access Administrator role, or a custom role that includes the `Microsoft.Authorization/roleAssignments/write` permission.
- The user, group, service principal, or managed identity to which you want to assign access.
- The **Azure Stack HCI VM Contributor** role, in addition to the required infrastructure roles, to perform VM-related actions, such as assigning or unassigning resources. For more information, see [Use built-in RBAC roles for Azure Local VM to manage Azure Local VMs enabled by Azure Arc](./assign-vm-rbac-roles.md).

## Assign an infrastructure role

You can assign an infrastructure RBAC role by using the Azure portal.

1. In the Azure portal, open the subscription, resource group, Azure Local instance, or infrastructure resource that defines the required access scope.
1. Select **Access control (IAM)**.
1. Select **Add** > **Add role assignment**.
1. On the **Role** tab, search for and select one of the following roles:

   - **Azure Stack HCI Administrator**
   - **Azure Local Infrastructure Contributor**
   - **Azure Local Infrastructure Reader**

1. Select **Next**.
1. On the **Members** tab, select the appropriate member type, and then select the user, group, service principal, or managed identity.
1. Select **Review + assign**.
1. To verify access, return to **Access control (IAM)**, select **Check access**, and review the effective role assignment.

## Next steps

- [Use built-in RBAC roles to manage Azure Local VMs enabled by Azure Arc](./assign-vm-rbac-roles.md)
- [Manage GPU infrastructure resources](./gpu-manage-fabric-resources.md)