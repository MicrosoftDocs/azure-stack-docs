---
title: Use builtin RBAC roles for Arc VM management on Azure Stack HCI (preview)
description: Learn how to use RBAC builtin roles for Arc VM management on Azure Stack HCI.(preview)
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/13/2023
---

# Use Role-based Access Control to manage Azure Stack HCI Virtual Machines (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to use the Role-based Access Control (RBAC) to control access to Arc virtual machines (VMs) running on your Azure Stack HCI cluster. 

You can use the builtin RBAC roles to control access to VMs and VM resources such as virtual disks, network interfaces, VM images, logical networks and storage paths. You can assign these roles to users, groups, service principals and managed identities.


[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## About builtin RBAC roles

To control access to VMs and VM resources on your Azure Stack HCI, you can use the following RBAC roles: 

- **Azure Stack HCI Administrator** - This role grants full access to your Azure Stack HCI cluster and its resources. An Azure Stack HCI administrator can register the cluster as well as assign Azure Stack HCI VM contributor and Azure Stack HCI VM reader roles to other users.
- **Azure Stack HCI VM Contributor** - This role grants permissions to perform all VM actions such as start, stop, restart the VMs. An Azure Stack HCI VM Contributor can create and delete VMs, as well as the resources and extensions attached to VMs. An Azure Stack HCI VM Contributor can't register the cluster or assign roles to other users, nor create cluster-shared resources such as logical networks, VM images, and storage paths.
- **Azure Stack HCI VM Reader** - This role grants permissions to only view the VMs. A VM reader can't perform any actions on the VMs or VM resources and extensions.

Here's a table that describes the VM actions granted by each role for the VMs and the various VM resources. The VM resources are referred to resources required to create a VM and include virtual disks, network interfaces, VM images, logical networks, and storage paths:


|Builtin role  |VMs  |VM resources  |
|---------|---------|---------|
|Azure Stack HCI Administrator     |Create, list, delete VMs<br><br> Start, stop, restart VMs         |Create, list, delete VM resources         |
|Azure Stack HCI VM Contributor     |Create, list, delete VMs<br><br> Start, stop, restart VMs         |Create, list, delete all VM resources except logical networks, VM images, and storage paths         |
|Azure Stack HCI VM Reader    |List all VMs         |List all VM resources         |

 
## Prerequisites

Before you begin, make sure to complete the following prerequisites:

1. Make sure that you have access to an Azure Stack HCI cluster that is deployed and registered. During the deployment, an Arc Resource Bridge and a custom location are also created.
    
    Go to the resource group in Azure. You can see the custom location and Azure Arc Resource Bridge created for the Azure Stack HCI cluster. Make a note of the subscription, resource group, and the custom location as you use these later in this scenario.

1. Make sure that you have access to Azure subscription as an Owner or User Access Administrator to assign roles to others.

## Assign RBAC roles to users

You can assign RBAC roles to user via the Azure portal. Follow these steps to assign RBAC roles to users:

1. In the Azure Portal, search for the scope to grant access to, for example, search for subscriptions, resource groups, or a specific resource. In this example, we use the subscription in which the Azure Stack HCI cluster is deployed.


1. Go to your subscription and then go to **Access control (IAM) > Role assignments**. From the top command bar, select **+ Add** and then select **Add role assignment**.

    If you don't have permissions to assign roles, the **Add role assignment** option is disabled.

    :::image type="content" source="./media/assign-vm-rbac-roles/add-role-assignment-1.png" alt-text="Screenshot showing RBAC role assignment in Azure portal for your Azure Stack HCI cluster." lightbox="./media/assign-vm-rbac-roles/add-role-assignment-1.png":::

1. On the **Role** tab, select an RBAC role to assign and choose from one of the following builtin roles:

    - **Azure Stack HCI Administrator**
    - **Azure Stack HCI VM Contributor**
    - **Azure Stack HCI VM Reader**

    :::image type="content" source="./media/assign-vm-rbac-roles/add-role-assignment-2.png" alt-text="Screenshot showing Role tab during RBAC role assignment in Azure portal for your Azure Stack HCI cluster." lightbox="./media/assign-vm-rbac-roles/add-role-assignment-2.png":::

1. On the **Members** tab, select the **User, group, or service principal**. Also select a member to assign the role.

    :::image type="content" source="./media/assign-vm-rbac-roles/add-role-assignment-3.png" alt-text="Screenshot showing Members tab during role assignment in Azure portal for your Azure Stack HCI cluster." lightbox="./media/assign-vm-rbac-roles/add-role-assignment-3.png":::

1. Review the role and assign it.

    :::image type="content" source="./media/assign-vm-rbac-roles/add-role-assignment-4.png" alt-text="Screenshot showing Review + assign tab during role assignment in Azure portal for your Azure Stack HCI cluster." lightbox="./media/assign-vm-rbac-roles/add-role-assignment-4.png":::

1. Verify the role assignment. Go to **Access control (IAM) > Check access > View my access**. You should see the role assignment.

    :::image type="content" source="./media/assign-vm-rbac-roles/add-role-assignment-5.png" alt-text="Screenshot showing newly assigned role in Azure portal for your Azure Stack HCI cluster." lightbox="./media/assign-vm-rbac-roles/add-role-assignment-5.png":::

For more information on role assignment, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

## Next steps

- [Create a storage path for Azure Stack HCI VM](./create-storage-path.md).