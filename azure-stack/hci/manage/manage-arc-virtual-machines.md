---
title: Manage including restart, start, stop or delete Arc VMs on Azure Stack HCI (preview)
description: Learn how to manage Arc VMs. This includes operations such as start, stop, restart, view properties of Arc VMs running on Azure Stack HCI, version 23H2 (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 01/05/2024
---

# Manage Arc VMs on Azure Stack HCI (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage Arc virtual machines (VMs) running on Azure Stack HCI, version 23H2. The procedures to start, stop, restart or delete an Arc VM are detailed.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Manage Arc VM resources

Once the Arc VMs are deployed, you may need to manage the VMs. This would require adding data disks, network interfaces, cores or memory to a VM, starting, stopping or restarting VMs.

## Prerequisites

Before you begin, make sure to complete the following prerequisites:

1. Make sure you have access to an Azure Stack HCI cluster that is deployed and registered. During the deployment, an Arc Resource Bridge and a custom location are also created.

   Go to the resource group in Azure. You can see the custom location and Azure Arc Resource Bridge created for the Azure Stack HCI cluster. Make a note of the subscription, resource group, and the custom location as you use these later in this scenario.

1. Make sure you have one or more Arc VMs running on this Azure Stack HCI cluster. For more information, see [Create Arc VMs on Azure Stack HCI](./create-arc-virtual-machines.md).

## View VM properties

Follow these steps in the Azure portal of your Azure Stack HCI system to view VM properties.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select the name of the VM whose properties you wish to view.

   :::image type="content" source="./media/manage-arc-virtual-machines/view-virtual-machine-properties-1.png" alt-text="Screenshot of VM selected from the list of VMs." lightbox="./media/manage-arc-virtual-machines/view-virtual-machine-properties-1.png":::

1. On the **Overview** page, go to the right pane and then go to the **Properties** tab. You can view the properties of your VM.

   :::image type="content" source="./media/manage-arc-virtual-machines/view-virtual-machine-properties-2.png" alt-text="Screenshot of properties of the selected Arc VM." lightbox="./media/manage-arc-virtual-machines/view-virtual-machine-properties-2.png":::

## Start a VM

Follow these steps in the Azure portal of your Azure Stack HCI system to start a VM.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select a VM that isn't running and you wish to start.

1. On the **Overview** page for the VM, from the top command bar in the right pane, select **Start**, then select **Yes**.

1. Verify the VM has started.

   :::image type="content" source="./media/manage-arc-virtual-machines/start-virtual-machine.png" alt-text="Screenshot of select + start VM." lightbox="./media/manage-arc-virtual-machines/start-virtual-machine.png":::

## Stop a VM

Follow these steps in the Azure portal of your Azure Stack HCI system to stop a VM.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select a VM that is running and you wish to stop.

1. On the **Overview** page for the VM, from the top command bar in the right pane, select **Stop**, then select **Yes**.

1. Verify the VM has stopped.

   :::image type="content" source="./media/manage-arc-virtual-machines/stop-virtual-machine.png" alt-text="Screenshot of select + stop VM." lightbox="./media/manage-arc-virtual-machines/stop-virtual-machine.png":::

## Restart a VM

Follow these steps in the Azure portal of your Azure Stack HCI system to restart a VM.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select a VM that is stopped and you wish to restart.

1. On the **Overview** page for the VM, from the top command bar in the right pane, select **Restart**, then select **Yes**.

1. Verify the VM has restarted.

   :::image type="content" source="./media/manage-arc-virtual-machines/restart-virtual-machine.png" alt-text="Screenshot of select + restart VM." lightbox="./media/manage-arc-virtual-machines/restart-virtual-machine.png":::

## Delete a VM

Follow these steps in the Azure portal of your Azure Stack HCI system to remove a VM.

1. Go to the Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. In the right pane, from the list of virtual machines, select a VM that you wish to remove from your system.

1. On the **Overview** page for the VM, from the top command bar in the right pane, select **Delete**, then select **Yes**.

1. Verify the VM is removed.

   :::image type="content" source="./media/manage-arc-virtual-machines/delete-virtual-machine.png" alt-text="Screenshot of select + remove VM." lightbox="./media/manage-arc-virtual-machines/delete-virtual-machine.png":::

## Change cores and memory

Follow these steps in the Azure portal of your Azure Stack HCI system to change cores and memory.

1. Go to your Azure Stack HCI cluster resource and then go to **Virtual machines**.

1. From the list of VMs in the right pane, select and go to the VM whose cores and memory you want to modify.

1. Under **Settings**, select **Size**. Edit the **Virtual processor count** or **Memory (MB)** to change the cores and memory size for the VM. Only the memory size can be changed. The memory type can't be changed once a VM is created.

   :::image type="content" source="./media/manage-arc-virtual-machines/change-cores-memory.png" alt-text="Screenshot of Size page for a VM." lightbox="./media/manage-arc-virtual-machines/change-cores-memory.png":::

## Next steps

- [Manage Arc VM resources such as data disks and network interfaces](./manage-arc-virtual-machine-resources.md)