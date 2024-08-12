---
title: Manage Arc VM resources such as disks, network interface for Azure Stack HCI virtual machines
description: Learn how to manage resource such as data disks, network interfaces on an Arc VM.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 02/13/2024
---

# Manage resources for Arc VM on your Azure Stack HCI

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to manage VM resources such as disks and networks interfaces for an Azure Arc virtual machine (VM) running on your Azure Stack HCI system.  You can add or delete data disks and add or delete network interfaces using the Azure portal.


## Manage Arc VM resources

Once the Arc VMs are deployed, you may need to manage the VMs. This would require adding or deleting data disks, and adding or deleting network interfaces.
  
## Prerequisites

Before you begin, make sure to complete the following prerequisites:

- Make sure that you have access to an Azure Stack HCI cluster that is deployed and registered. You should have one or more Arc VMs running on this Azure Stack HCI cluster. For more information, see [Create Arc VMs on your Azure Stack HCI](./create-arc-virtual-machines.md).

## Add a data disk

After you have created a VM, you may want to add a data disk to it. You can add a data disk via the Azure CLI or the Azure portal.

### [Azure CLI](#tab/azurecli)

To add a data disk, you need to first create a disk and then attach the disk to the VM. Follow these steps in Azure CLI of the computer that you are using to connect to your Azure Stack HCI system.

To create a data disk (dynamic) on a specified storage path, run the following command:

```azurecli
az stack-hci-vm disk create --resource-group $resource_group --name $diskName --custom-location $customLocationID --location $location --size-gb 1 --dynamic true --storage-path-id $storagePathid
```

You can then attach the disk to the VM using the following command:

```azurecli
az stack-hci-vm disk attach --resource-group $resource_group --vm-name $vmName --disks $diskName --yes
```

### [Azure portal](#tab/azureportal)

Follow these steps in Azure portal of your Azure Stack HCI system.

1. Go to your Azure Stack HCI cluster resource and then go to **Virtual machines**.
1. From the list of VMs in the right pane, select and go to the VM to which you want to add a data disk.
1. Go to **Disks**. From the top command bar in the right pane, select **+ Add new disk**.  

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-data-disk-1.png" alt-text="Screenshot of + Add disk selected." lightbox="./media/manage-arc-virtual-machine-resources/add-data-disk-1.png":::

1. In the **Add new disk** blade, input the following parameters:
    1. Specify a friendly **Name** for the data disk.
    1. Provide the **Size** for the disk in GB.
    1. Choose the **Provisioning type** for disk as **Dynamic** or **Static**.
    1. **Storage path** - Select the storage path for your VM image. Select **Choose automatically** to have a storage path with high availability automatically selected.  Select **Choose manually** to specify a storage path to store VM images and configuration files on the Azure Stack HCI cluster. In this case, ensure that the selected storage path has sufficient storage space. 
  
   <!--:::image type="content" source="./media/manage-arc-virtual-machine-resources/add-data-disk-2.png" alt-text="Screenshot of Add new disk blade with provided inputs." lightbox="./media/manage-arc-virtual-machine-resources/add-data-disk-2.png":::-->

1. Select **Save** to add the new disk.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-data-disk-3.png" alt-text="Screenshot of Save selected for data disk to create." lightbox="./media/manage-arc-virtual-machine-resources/add-data-disk-3.png":::

1. You'll see a notification that the data disk creation job has started. Once the disk is created, the list refreshes to display the newly added disk.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-data-disk-4.png" alt-text="Screenshot of list of refreshed data disk." lightbox="./media/manage-arc-virtual-machine-resources/add-data-disk-4.png":::


---

## Delete a data disk

Follow these steps in Azure portal of your Azure Stack HCI system.

1. Go to Azure Stack HCI cluster resource and then go to **Virtual machines**.  
1. From the list of VMs in the right pane, select and go to the VM whose data disk you want to delete.

    :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-data-disk-1.png" alt-text="Screenshot of delete icon selected for the data disk to delete." lightbox="./media/manage-arc-virtual-machine-resources/delete-data-disk-1.png":::

1. In the confirmation dialog, select **Yes** to continue.

    :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-data-disk-2.png" alt-text="Screenshot of confirmation page for the data disk to delete." lightbox="./media/manage-arc-virtual-machine-resources/delete-data-disk-2.png":::

1. **Save** the changes to delete the specified data disk.

    :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-data-disk-3.png" alt-text="Screenshot of save selected for the data disk to delete." lightbox="./media/manage-arc-virtual-machine-resources/delete-data-disk-3.png":::

1. You'll see a notification that the disk deletion job has started. Once the disk is deleted, the list refreshes to display the remaining data disks.

## Add a network interface

> [!NOTE]
> Adding a network interface with static IP after the VM is provisioned is not supported.

Follow these steps in Azure portal of your Azure Stack HCI system.

1. Go to your Azure Stack HCI cluster resource and then go to **Virtual machines**.
1. From the list of VMs in the right pane, select and go to the VM to which you want to add a network interface.

1. Go to **Networking**. From the top command bar in the right pane, select **+ Add network interface**.  

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-network-interface-1.png" alt-text="Screenshot of + Add network interface option selected in the Networking page for a VM." lightbox="./media/manage-arc-virtual-machine-resources/add-network-interface-1.png":::

1. In the **Add network interface** blade, input the following parameters:
    1. Specify a friendly **Name** for the network interface.
    1. From the dropdown list, select a logical **Network** to associate with this network interface. 
    1. Choose the **IPv4 type** as **DHCP** or **Static**.
  
   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-network-interface-2.png" alt-text="Screenshot of Add network interface with inputs provided for the new network interface for a VM." lightbox="./media/manage-arc-virtual-machine-resources/add-network-interface-2.png":::

1. **Apply** the changes to add the specified network interface.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-network-interface-3.png" alt-text="Screenshot of Apply option selected in the Networking page for a VM." lightbox="./media/manage-arc-virtual-machine-resources/add-network-interface-3.png":::

1. You'll see a notification that the network interface creation job has started. Once the network interface is created, it is then attached to the Arc VM.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-network-interface-4.png" alt-text="Screenshot of confirmation page for the new network interface creation in the Networking page for a VM." lightbox="./media/manage-arc-virtual-machine-resources/add-network-interface-4.png":::

1. The list of network interfaces is updated with the newly added network interface.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-network-interface-5.png" alt-text="Screenshot of newly refreshed network interface list in the Networking page for a VM." lightbox="./media/manage-arc-virtual-machine-resources/add-network-interface-5.png":::

## Delete a network interface

Follow these steps in Azure portal of your Azure Stack HCI system.

1. Go to your Azure Stack HCI cluster resource and then go to **Virtual machines**.
1. From the list of VMs in the right pane, select and go to the VM whose network interface you want to delete.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-network-interface-1.png" alt-text="Screenshot of VM selected whose network interface you want to delete." lightbox="./media/manage-arc-virtual-machine-resources/delete-network-interface-1.png":::

1. In the confirmation dialog, select **Yes** to continue.

    :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-network-interface-2.png" alt-text="Screenshot of deletion confirmation." lightbox="./media/manage-arc-virtual-machine-resources/delete-network-interface-2.png":::

1. **Apply** the changes to delete the specified network interface. The network interface is dissociated from the Arc VM.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-network-interface-3.png" alt-text="Screenshot of Apply selected in the Networking page for a VM." lightbox="./media/manage-arc-virtual-machine-resources/delete-network-interface-3.png":::

1. The list of network interfaces is updated with the deleted network interface.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-network-interface-4.png" alt-text="Screenshot of newly refreshed network interface list for VM." lightbox="./media/manage-arc-virtual-machine-resources/delete-network-interface-4.png":::

## Next steps

- [Manage VM extensions](./virtual-machine-manage-extension.md).
