---
title: Use builtin RBAC roles for Arc VM management on Azure Stack HCI (preview)
description: Learn how to use RBAC builtin roles for Arc VM management on Azure Stack HCI.(preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/24/2023
---

# Use Role-based Access Control to manage Azure Stack HCI Virtual Machines (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to use the Role-based Access Control (RBAC) to control access to Arc virtual machines (VMs) running on your Azure Stack HCI cluster. You can use the builtin RBAC roles to control access to VMs and VM resources such as disks, network interfaces, and snapshots. You can assign these roles to users, groups, and applications.


[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## About builtin RBAC roles

To control access to VMs and VM resources on your Azure Stack HCI, you can use the following RBAC roles: 

- **Azure Stack HCI Administrator** - This role grants full access to your Azure Stack HCI cluster and its resources. AN Azure Stack HCI administrator can register the cluster as well as assign VM contributor and VM reader roles to users.
- **Azure Stack HCI VM Contributor** - This role grants permissions to perform all VM actions such as create, delete, and start the VMs and VM resources. A VM contributor can't register the cluster or assign roles to other users.
- **Azure Stack HCI VM Reader** - This role grants permissions to only view the VMs. A VM reader can't perform any actions on the VMs or VM resources.

Here's a table that describes the VM actions granted by each role for the VMs and the various VM resources:


|Builtin role  |VMs  |VM resources  |
|---------|---------|---------|
|Azure Stack HCI Administrator     |Create, show, list, delete VMs<br><br> Start, stop, restart VMs         |Create, show, list, delete VM resources         |
|Azure Stack HCI VM Contributor     |Create, show, list, delete VMs<br><br> Start, stop, restart VMs         |Create, show, list, delete all VM resources except virtual networks, VM images, and storage paths         |
|Azure Stack HCI VM Reader    |Show, list all VMs         |Show, list all VM resources         |

 
## Prerequisites

Before you begin, make sure to complete the following prerequisites:

1. Make sure that you have access to an Azure Stack HCI cluster that is deployed and registered. During the deployment, an Arc Resource Bridge and a custom location are also created. 
    
    Go to the resource group in Azure. You can see the custom location and Azure Arc Resource Bridge created for the Azure Stack HCI cluster. Make a note of the subscription, resource group, and the custom location as you use these later in this scenario.

1. Make sure that you have access to Azure subscription as a Contributor or User Access Administrator to assign roles to users.

## Assign RBAC roles to users

You can assign RBAC roles to user via the Azure portal. Follow these steps to assign RBAC roles to users:

1. In the Azure portal, go to your Azure Stack HCI
cluster resource.

1. Go to **Access control (IAM) > Role assignments**. From the top command bar, select **+ Add** and then select **Add role assignment**.

    If you don't have permissions to assign roles, the **Add role assignment** option will be disabled.

1. Choose from one of the following builtin roles:

    - **Azure Stack HCI Administrator**
    - **Azure Stack HCI VM Contributor**
    - **Azure Stack HCI VM Reader**
  
    To identify the scope of the role to assign, you can use the role descriptions in the previous section.

For more information on role assignment, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

## Next steps

- [Create a storage path for Azure Stack HCI VM](./create-storage-path.md).