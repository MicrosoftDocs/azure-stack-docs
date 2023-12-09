---
title: Manage including restart, start, stop or delete Arc VMs on Azure Stack HCI (preview)
description: Learn how to manage Arc VMs. This includes operations such as start, stop, restart, view properties of Arc VMs running on your Azure stack HCI, version 23H2 (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/06/2023
---

# Manage Arc VMs on your Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage Arc VMs running on your Azure Stack HCI, version 23H2. The procedures to start, stop, restart or delete an Arc VM are detailed.


[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Manage Arc VM resources

Once the Arc VMs are deployed, you may need to manage the VMs. This would require adding data disks, network interafces, cores or memory to a VM, starting, stopping or restarting VMs.
  
## Prerequisites

Before you begin, make sure to complete the following prerequisites:

1. Make sure that you have access to an Azure Stack HCI cluster that is deployed and registered. During the deployment, an Arc Resource Bridge and a custom location are also created.
    
    Go to the resource group in Azure. You can see the custom location and Azure Arc Resource Bridge created for the Azure Stack HCI cluster. Make a note of the subscription, resource group, and the custom location as you use these later in this scenario.

1. You have one or more Arc VMs running on this Azure Stack HCI cluster. For more information, see [Create Arc VMs on your Azure Stack HCI](./create-arc-virtual-machines.md).


## View VM properties

Follow these steps in Azure portal of your Azure Stack HCI system.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select the name of the VM whose properties you wish to view.

   :::image type="content" source="./media/manage-arc-virtual-machines/view-virtual-machine-properties-1.png" alt-text="Screenshot of VM selected from the list of VMs." lightbox="./media/manage-arc-virtual-machines/view-virtual-machine-properties-1.png":::

1. On the **Overview** page, go to the right pane and then go to the **Properties** tab. You can view the properties of your VM.
    
   :::image type="content" source="./media/manage-arc-virtual-machines/view-virtual-machine-properties-2.png" alt-text="Screenshot of properties of the selected Arc VM." lightbox="./media/manage-arc-virtual-machines/view-virtual-machine-properties-2.png":::

  
## Start a VM

Follow these steps in Azure portal of your Azure Stack HCI system.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select a VM that is not running and you wish to start. 

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/view-virtual-machine-properties-1.png" alt-text="Screenshot of VM selected from the list of VMs." lightbox="./media/create-storage-path/create-storage-path-1.png":::

1. On the **Overview** page for the VM, from the top command bar in the right pane, select **Start**. 
    
   :::image type="content" source="./media/create-storage-path/create-storage-path-1.png" alt-text="Screenshot of select + Create storage path." lightbox="./media/create-storage-path/create-storage-path-1.png":::


## Stop a VM

## Restart a VM

## Delete a VM






## Next steps

- [Manage Arc VM resources such as data disks, network interfaces](./manage-arc-virtual-machine-resources.md)
