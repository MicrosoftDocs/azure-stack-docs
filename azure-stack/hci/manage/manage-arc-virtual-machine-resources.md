---
title: Manage Arc VM resources such as disks, network interface for Azure Stack HCI virtual machines (preview)
description: Learn how to manage resource such as data disks, network interfaces on an Arc VM (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/06/2023
---

# Manage resources for Arc VM on your Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage VM resources such as disks, networks interfaces, cores or memory.  storage path for VM images used on your Azure Stack HCI cluster. Storage paths are an Azure resource and are used to provide a path to store VM configuration files, VM image, and VHDs on your cluster. You can create a storage path using the Azure CLI.


[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Manage Arc VM resources

Once the Arc VMs are deployed, you may need to manage the VMs. This would require adding data disks, network interafces, cores or memory to a VM, starting, stopping or restarting VMs.
  
## Prerequisites

Before you begin, make sure to complete the following prerequisites:

1. Make sure that you have access to an Azure Stack HCI cluster that is deployed and registered. During the deployment, an Arc Resource Bridge and a custom location are also created.
    
    Go to the resource group in Azure. You can see the custom location and Azure Arc Resource Bridge created for the Azure Stack HCI cluster. Make a note of the subscription, resource group, and the custom location as you use these later in this scenario.

1. You have one or more Arc VMs running on this Azure Stack HCI cluster. For more information, see [Create Arc VMs on your Azure Stack HCI](./create-arc-virtual-machines.md).



## Add a data disk

Follow these steps in Azure portal of your Azure Stack HCI system.

1. Go to Azure Stack HCI cluster resource and then go to **Storage paths**. If you chose to create workload volumes during the deployment, default storage paths were also automatically created. You can see these default storage paths that were created during deployment. 

1. From the top command bar in the right pane, select **+ Create storage path**. 

   :::image type="content" source="./media/create-storage-path/create-storage-path-1.png" alt-text="Screenshot of select + Create storage path." lightbox="./media/create-storage-path/create-storage-path-1.png":::

1. In the **Create storage path** pane, input the following parameters:
    1. Specify a file system path on your disk where the VMs, VM images and other data reside. This path should be on a cluster share volume (CSV) on your cluster.
    1. Provide a friendly name for your storage path. The name should be 3 to 64 characters long and should contain letters, numbers, and hyphens.
  
    :::image type="content" source="./media/create-storage-path/create-storage-path-2.png" alt-text="Screenshot of specifying file path and friendly name." lightbox="./media/create-storage-path/create-storage-path-2.png":::  

1. You'll see a notification that the storage path creation job has started. Once the storage path is created, the list refreshes to display the newly created storage path.

    :::image type="content" source="./media/create-storage-path/create-storage-path-3.png" alt-text="Screenshot of new storage path added to list of storage paths." lightbox="./media/create-storage-path/create-storage-path-3.png":::  

## Delete a data disk


Follow these steps in Azure portal of your Azure Stack HCI system.

1. Go to Azure Stack HCI cluster resource and then go to **Storage paths**.  
1. For the storage path that you wish to delete, select the corresponding trashcan icon. 

    :::image type="content" source="./media/create-storage-path/delete-storage-path-1.png" alt-text="Screenshot of delete icon selected for the storage path to delete." lightbox="./media/create-storage-path/delete-storage-path-1.png":::

1. In the confirmation dialog, select Yes to continue. 

    :::image type="content" source="./media/create-storage-path/delete-storage-path-2.png" alt-text="Screenshot of deletion confirmation." lightbox="./media/create-storage-path/delete-storage-path-2.png":::

1. You'll see a notification that the storage path deletion job has started. Once the storage path is deleted, the list refreshes to display the remaining storage paths.

    :::image type="content" source="./media/create-storage-path/delete-storage-path-3.png" alt-text="Screenshot of updated storage path list after the deletion." lightbox="./media/create-storage-path/delete-storage-path-3.png":::  


## Add a network interfaces


1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.
1. In the right pane, from the list of virtual machines, select the VM to which you want to add a network interface.
1. 



## Delete a network interface

## Change cores and memory




## Next steps

- [Manage Arc VMs](./manage-arc-virtual-machines.md)