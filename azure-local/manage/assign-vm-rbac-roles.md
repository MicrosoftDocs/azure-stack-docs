---
title: Use built-in RBAC roles for Azure Local VM to manage Azure Local VMs enabled by Azure Arc
description: Learn how to use RBAC built-in roles to manage Azure Local VMs enabled by Azure Arc.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 04/29/2025
ms.custom: sfi-image-nochange
---

# Use Role-based Access Control to manage Azure Local VMs enabled by Azure Arc 

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to use the Role-based Access Control (RBAC) to control access to Azure Local virtual machines (VMs) enabled by Azure Arc.

You can use the built-in RBAC roles to control access to VMs and VM resources such as virtual disks, network interfaces, VM images, logical networks and storage paths. You can assign these roles to users, groups, service principals and managed identities.

## About built-in RBAC roles

To control access to VMs and VM resources on Azure Local, you can use the following RBAC roles:

- **Azure Stack HCI Administrator** - This role grants full access to your Azure Local instance and its resources. An Azure Stack HCI administrator can register the system as well as assign Azure Stack HCI VM contributor and Azure Stack HCI VM reader roles to other users. They can also create shared resources such as logical networks, VM images, and storage paths.
- **Azure Stack HCI VM Contributor** - This role grants permissions to perform all VM actions such as start, stop, restart the VMs. An Azure Stack HCI VM Contributor can create and delete VMs, as well as the resources and extensions attached to VMs. An Azure Stack HCI VM Contributor can't register the system or assign roles to other users, nor create system-shared resources such as logical networks, VM images, and storage paths.
- **Azure Stack HCI VM Reader** - This role grants permissions to only view the VMs. A VM reader can't perform any actions on the VMs or VM resources and extensions.

Here's a table that describes the VM actions granted by each role for the VMs and the various VM resources. The VM resources are referred to resources required to create a VM and include virtual disks, network interfaces, VM images, logical networks, and storage paths:

| Built-in role | VMs | VM resources |
|--|--|--|
| Azure Stack HCI Administrator | Create, list, delete VMs<br><br> Start, stop, restart VMs | Create, list, delete all VM resources including logical networks, VM images, and storage paths |
| Azure Stack HCI VM Contributor | Create, list, delete VMs<br><br> Start, stop, restart VMs | Create, list, delete all VM resources except logical networks, VM images, and storage paths |
| Azure Stack HCI VM Reader | List all VMs | List all VM resources |

## Prerequisites

Before you begin, make sure to complete the following prerequisites:

1. Make sure that complete the [Azure Local requirements](./azure-arc-vm-management-prerequisites.md).

1. Make sure that you have access to Azure subscription as an Owner or User Access Administrator to assign roles to others.

## Assign RBAC roles to users

You can assign RBAC roles to users via the Azure portal. Follow these steps to assign RBAC roles to users:

1. In the Azure portal, search for the scope to grant access to, for example, search for subscriptions, resource groups, or a specific resource. In this example, we use the subscription in which your Azure Local is deployed.

1. Go to your subscription and then go to **Access control (IAM)** > **Role assignments**. From the top command bar, select **+ Add** and then select **Add role assignment**.

    If you don't have permissions to assign roles, the **Add role assignment** option is disabled.

    :::image type="content" source="./media/assign-vm-rbac-roles/add-role-assignment-1.png" alt-text="Screenshot showing RBAC role assignment in Azure portal for your Azure Local." lightbox="./media/assign-vm-rbac-roles/add-role-assignment-1.png":::

1. On the **Role** tab, select an RBAC role to assign and select one of the following built-in roles:

    - **Azure Stack HCI Administrator**
    - **Azure Stack HCI VM Contributor**
    - **Azure Stack HCI VM Reader**

    :::image type="content" source="./media/assign-vm-rbac-roles/add-role-assignment-2.png" alt-text="Screenshot showing Role tab during RBAC role assignment in Azure portal for your Azure Local instance." lightbox="./media/assign-vm-rbac-roles/add-role-assignment-2.png":::

1. On the **Members** tab, select the **User, group, or service principal**. Also select a member to assign the role.

    :::image type="content" source="./media/assign-vm-rbac-roles/add-role-assignment-3.png" alt-text="Screenshot showing Members tab during role assignment in Azure portal for your Azure Local instance." lightbox="./media/assign-vm-rbac-roles/add-role-assignment-3.png":::

1. Review the role and assign it.

    :::image type="content" source="./media/assign-vm-rbac-roles/add-role-assignment-4.png" alt-text="Screenshot showing Review + assign tab during role assignment in Azure portal for your Azure Local instance." lightbox="./media/assign-vm-rbac-roles/add-role-assignment-4.png":::

1. Verify the role assignment. Go to **Access control (IAM)** > **Check access** > **View my access**. You should see the role assignment.

    :::image type="content" source="./media/assign-vm-rbac-roles/add-role-assignment-5.png" alt-text="Screenshot showing newly assigned role in Azure portal for your Azure Local instance." lightbox="./media/assign-vm-rbac-roles/add-role-assignment-5.png":::

For more information on role assignment, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

## Next steps

- [Create a storage path for Azure Local VM](./create-storage-path.md).
