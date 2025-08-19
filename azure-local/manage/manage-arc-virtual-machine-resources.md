---
title: Manage resources for Azure Local VMs enabled by Azure Arc
description: Learn how to manage resources like data disks and network interfaces on an Azure Local VM enabled by Azure Arc.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 06/06/2025
---

# Manage resources for Azure Local VMs enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

After you deploy Azure Local virtual machines (VMs) enabled by Azure Arc, you need to add or delete resources like data disks and network interfaces.
This article describes how to manage these VM resources for an Azure Local VM running on your Azure Local instance.

Add or delete resources using the Azure portal. To add a data disk, use the Azure CLI.

## Prerequisites

- Access to a deployed and registered Azure Local instance with one or more running Azure Local VMs.
  For more information, see [Create an Azure Local VM enabled by Azure Arc](./create-arc-virtual-machines.md).

## Add a data disk

After you create a VM, you might want to add a data disk to it.

### [Azure CLI](#tab/azurecli)

To add a data disk, you first create a disk and then attach it to the VM. Run the following commands in the Azure CLI on the computer that you're using to connect to Azure Local.

1. Create a data disk (dynamic) on a specified storage path:

   ```azurecli
   az stack-hci-vm disk create --resource-group $resource_group --name $diskName --custom-location $customLocationID --location $location --size-gb 1 --dynamic true --storage-path-id $storagePathid
   ```

1. Attach the disk to the VM:

   ```azurecli
   az stack-hci-vm disk attach --resource-group $resource_group --vm-name $vmName --disks $diskName --yes
   ```

### [Azure portal](#tab/azureportal)

Follow these steps in the Azure portal for your Azure Local instance:

1. Go to your Azure Local resource, and then go to **Virtual machines**.

1. In the list of VMs, select and go to the VM to which you want to add a data disk.

1. Go to **Disks**. On the command bar, select **+ Add new disk**.  

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-data-disk-1.png" alt-text="Screenshot of the command for adding a new disk on the Disks pane for a virtual machine." lightbox="./media/manage-arc-virtual-machine-resources/add-data-disk-1.png":::

1. On the **Add new disk** pane, enter the following parameters, and then select **Add**:
    1. For **Name**, specify a friendly name for the data disk.
    1. For **Size (GB)**, provide the size for the disk in gigabytes.
    1. For **Provisioning type**, select **Dynamic** or **Static**.
    1. For **Storage path**, select the storage path for your VM image:

       - To have a storage path with high availability automatically selected, select **Choose automatically**.

       - To specify a storage path to store VM images and configuration files on your Azure Local instance, select **Choose manually**. Ensure that the selected storage path has sufficient storage space.

1. Select **Save** to add the new disk.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-data-disk-3.png" alt-text="Screenshot of the command to save a newly created data disk." lightbox="./media/manage-arc-virtual-machine-resources/add-data-disk-3.png":::

1. You get a notification that the job for creating a data disk started. When the disk is created, the list refreshes to display the newly added disk.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-data-disk-4.png" alt-text="Screenshot of a newly added data disk for a virtual machine." lightbox="./media/manage-arc-virtual-machine-resources/add-data-disk-4.png":::

---

## Expand a data disk

You can expand an existing data disk to your desired size using Azure CLI.

>[!NOTE]
>
>- This feature is available only in Azure Local version 2504 and later.
>- The size you're changing the data disk to can't be the same or less than the original size of the data disk.
>- The maximum size the disk can expand to depends on the storage capacity of the cluster. Hyper-V also imposes a VHD max of 2TB and VHDx max of 64TB.

To expand the size of your data disk using Azure CLI, run the following command:

```azurecli
az stack-hci-vm disk update --name $name --resource-group $resource_group --size-gb $size_in_gb
```

Here's a sample output that indicates successful resizing of the data disk:

```Output
{
 "endTime": "2025-03-17T17:55:49.3271204Z",
 "error": {},
 "extendedLocation": null,
 "id": "/providers/Microsoft.AzureStackHCI/locations/EASTUS2EUAP/operationStatuses/00000000-0000-0000-0000-000000000000*0000000000000000000000000000000000000000000000000000000000000000",
 "location": null,
 "name": "00000000-0000-0000-0000-000000000000*0000000000000000000000000000000000000000000000000000000000000000",
 "properties": null,
 "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/resourceGroupName/providers/Microsoft.AzureStackHCI/virtualHardDisks/dataDiskName",
 "startTime": "2025-03-17T17:55:25.8868586Z",
 "status": "Succeeded",
 "systemData": null,
 "tags": null,
 "type": null
}
```

## Delete a data disk

Follow these steps in the Azure portal for your Azure Local instance:

1. Go to Azure Local resource, and then go to **Virtual machines**.

1. In the list of VMs, select and go to the VM whose data disk you want to delete.

1. Go to **Disks** and select the data disk that you want to delete. On the command bar, select **Delete**.

    :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-data-disk-1.png" alt-text="Screenshot of a selected data disk and the Delete button on the Disks pane." lightbox="./media/manage-arc-virtual-machine-resources/delete-data-disk-1.png":::

1. In the confirmation dialog, select **Yes** to continue.

    :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-data-disk-2.png" alt-text="Screenshot of the confirmation dialog for deleting a data disk." lightbox="./media/manage-arc-virtual-machine-resources/delete-data-disk-2.png":::

1. Select **Save** to save the changes.

    :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-data-disk-3.png" alt-text="Screenshot of the Save command in an empty list of data disks." lightbox="./media/manage-arc-virtual-machine-resources/delete-data-disk-3.png":::

1. You get a notification that the job for disk deletion started. After the disk is deleted, the list refreshes to display the remaining data disks.

## Add a network interface

> [!NOTE]
> After you add the network interface, sign in to the virtual machine and configure the desired static IP address.

Follow these steps in the Azure portal for your Azure Local instance:

1. Go to your Azure Local resource, and then go to **Virtual machines**.

1. In the list of VMs, select and go to the VM to which you want to add a network interface.

1. Go to **Networking**. On the command bar, select **+ Add network interface**.  

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-network-interface-1.png" alt-text="Screenshot of the command for adding a network interface on the Networking pane for a virtual machine." lightbox="./media/manage-arc-virtual-machine-resources/add-network-interface-1.png":::

1. On the **Add network interface** pane, enter the following parameters, and then select **Add**:
    1. For **Name**, specify a friendly name for the network interface.
    1. In the **Network** dropdown list, select a logical network to associate with this network interface.
    1. For **IPv4 type**, select **DHCP** or **Static**.
  
   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-network-interface-2.png" alt-text="Screenshot of the pane for adding a network interface for a VM." lightbox="./media/manage-arc-virtual-machine-resources/add-network-interface-2.png":::

1. Select **Apply** to apply the changes.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-network-interface-3.png" alt-text="Screenshot of the Apply button on the Networking pane for a virtual machine." lightbox="./media/manage-arc-virtual-machine-resources/add-network-interface-3.png":::

1. You get a notification that the job for network interface creation started. After the network interface is created, it's attached to the Azure Local VM.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-network-interface-4.png" alt-text="Screenshot of the Notifications pane for network interface creation beside the Networking pane for a virtual machine." lightbox="./media/manage-arc-virtual-machine-resources/add-network-interface-4.png":::

1. The list of network interfaces is updated with the newly added network interface.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/add-network-interface-5.png" alt-text="Screenshot of an updated network interface list on the Networking pane for a virtual machine." lightbox="./media/manage-arc-virtual-machine-resources/add-network-interface-5.png":::

## Delete a network interface

Follow these steps in the Azure portal for your Azure Local instance.

1. Go to your Azure Local resource, and then go to **Virtual machines**.
1. In the list of VMs, select and go to the VM whose network interface you want to delete.

1. Go to **Networking** and select the network interface that you want to delete. On the command bar, select **Delete**.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-network-interface-1.png" alt-text="Screenshot of a selected network interface and the Delete button on the Networking pane." lightbox="./media/manage-arc-virtual-machine-resources/delete-network-interface-1.png":::

1. In the confirmation dialog, select **Yes** to continue.

    :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-network-interface-2.png" alt-text="Screenshot of the confirmation dialog for deleting a network interface." lightbox="./media/manage-arc-virtual-machine-resources/delete-network-interface-2.png":::

1. Select **Apply** to apply the changes. The network interface is dissociated from the Azure Local VM.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-network-interface-3.png" alt-text="Screenshot of the Apply button on the Networking pane for a VM." lightbox="./media/manage-arc-virtual-machine-resources/delete-network-interface-3.png":::

1. The list of network interfaces is updated with the deleted network interface.

   :::image type="content" source="./media/manage-arc-virtual-machine-resources/delete-network-interface-4.png" alt-text="Screenshot of an updated network interface list on the Networking pane for a VM." lightbox="./media/manage-arc-virtual-machine-resources/delete-network-interface-4.png":::

## Manage DNS server configuration for logical networks

### Caveats

Before you update the DNS server configuration for a logical network, be aware of the following caveats:

- This feature is in preview and shouldn't be used on production logical networks.
- The DNS server update only applies to new Azure Local VMs created on the logical network after you've updated the DNS server. For all the existing Azure Local VMs, manually update the DNS server entries within the VM.
- You can't update the DNS server of a logical network associated with an AKS cluster.
- You can only update the DNS server of the logical networks associated with the workloads.
- The infrastructure logical network and Arc resource bridge DNS server updates are not supported.

### Update DNS server configuration

Follow these steps to manage DNS server configuration for logical networks.

#### Set parameters

```PowerShell
$logicalNetwork = "your-logical-network"
$resourceGroup = "your-resource-group"
$dnsServers = "IP-address1", "IP-address2"
```

#### Update DNS server configuration

```azure cli
az stack-hci-vm network lnet update --name $logicalNetwork --resource-group $resourceGroup --dns-servers $dnsServers
```

Running a DNS server `update` command replaces the existing configuration. Your existing DNS server IP entries will be overridden with the input provided during DNS server update. 

> [!IMPORTANT]
> Ensure to enter all relevant DNS server IP entries in your update command and not just the entry you want to change.

## Related content

- [Manage VM extensions on Azure Local virtual machines](./virtual-machine-manage-extension.md).
