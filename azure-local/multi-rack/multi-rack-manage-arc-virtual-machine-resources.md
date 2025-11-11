---
title: Manage resources for Azure Local VMs for multi-rack deployments (Preview)
description: Learn how to manage resources like data disks and network interfaces on an Azure Local VM for multi-rack deployments (Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/07/2025
---

# Manage resources for Azure Local VMs for multi-rack deployments (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

After you deploy Azure Local virtual machines (VMs) enabled by Azure Arc, you may need to add or delete resources like data disks.

This article describes how to manage these VM resources for an Azure Local VM for multi-rack deployments.

> [!NOTE]
> You can't add or delete network interfaces after the VM is created. If more than one network interfaces are needed, make sure to add them during VM creation.

## Prerequisites

- Access to a deployed and registered Azure Local instance with one or more running Azure Local VMs.
  For more information, see [Create an Azure Local VM enabled by Azure Arc](../manage/create-arc-virtual-machines.md).

## Add a data disk

After you create a VM, you might want to add a data disk to it.

> [!NOTE]
> You must turn off your VM before adding or deleting a data disk. Once it is updated, you need to restart your VM.

### [Azure CLI](#tab/azurecli)

To add a data disk, you first create a disk and then attach it to the VM. Run the following commands in the Azure CLI on the computer that you're using to connect to Azure Local.

1. Create a data disk on a specified storage path:

   ```azurecli
   az stack-hci-vm disk create --resource-group $resource_group --name $diskName --custom-location $customLocationID --location $location --size-gb 1
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

   :::image type="content" source="./media/multi-rack-manage-arc-virtual-machine-resources/add-data-disk-1.png" alt-text="Screenshot of the command for adding a new disk on the Disks pane for a virtual machine." lightbox="./media/multi-rack-manage-arc-virtual-machine-resources/add-data-disk-1.png":::

1. On the **Add new disk** pane, enter the following parameters, and then select **Add**:
    1. For **Name**, specify a friendly name for the data disk.
    1. For **Size (GB)**, provide the size for the disk in gigabytes.

1. Select **Save** to add the new disk.

   :::image type="content" source="./media/multi-rack-manage-arc-virtual-machine-resources/add-data-disk-3.png" alt-text="Screenshot of the command to save a newly created data disk." lightbox="./media/multi-rack-manage-arc-virtual-machine-resources/add-data-disk-3.png":::

1. You get a notification that the job for creating a data disk started. When the disk is created, the list refreshes to display the newly added disk.

   :::image type="content" source="./media/multi-rack-manage-arc-virtual-machine-resources/add-data-disk-4.png" alt-text="Screenshot of a newly added data disk for a virtual machine." lightbox="./media/multi-rack-manage-arc-virtual-machine-resources/add-data-disk-4.png":::

---

## Expand a data disk

You can expand an existing data disk to your desired size using Azure CLI.

>[!NOTE]
>
>- The size you're changing the data disk to can't be the same or less than the original size of the data disk.
>- The maximum size the disk can expand to depends on the storage capacity of the cluster. Disk size maximum is 20 TB.

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

    :::image type="content" source="./media/multi-rack-manage-arc-virtual-machine-resources/delete-data-disk-1.png" alt-text="Screenshot of a selected data disk and the Delete button on the Disks pane." lightbox="./media/multi-rack-manage-arc-virtual-machine-resources/delete-data-disk-1.png":::

1. In the confirmation dialog, select **Yes** to continue.

    :::image type="content" source="./media/multi-rack-manage-arc-virtual-machine-resources/delete-data-disk-2.png" alt-text="Screenshot of the confirmation dialog for deleting a data disk." lightbox="./media/multi-rack-manage-arc-virtual-machine-resources/delete-data-disk-2.png":::

1. Select **Save** to save the changes.

    :::image type="content" source="./media/multi-rack-manage-arc-virtual-machine-resources/delete-data-disk-3.png" alt-text="Screenshot of the Save command in an empty list of data disks." lightbox="./media/multi-rack-manage-arc-virtual-machine-resources/delete-data-disk-3.png":::

1. You get a notification that the job for disk deletion started. After the disk is deleted, the list refreshes to display the remaining data disks.



<!-- >::: moniker range=">=azloc-2508"

## Manage DNS server configuration for logical networks (preview)

### Key considerations

Before you update the DNS server configuration for a logical network, be aware of the following caveats:

- This feature is in preview and shouldn't be used on production logical networks.
- The updated DNS server configuration only applies to new Azure Local VMs created on the logical network after the update. For all the existing Azure Local VMs, manually update the DNS server entries within the VM.
- You can't update the DNS server of a logical network that has an AKS cluster deployed.
- The infrastructure logical network (enveloping the 6 management IP address range provided during deployment) and Arc resource bridge DNS server updates are not supported.

### Update DNS server configuration

> [!IMPORTANT]
> Make sure to enter all the relevant DNS server IP entries in your `update` command and not just the entry you want to change. Running a DNS server `update` command replaces the existing configuration.

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
::: moniker-end -->

## Related content

- [Manage VM extensions on Azure Local virtual machines](../manage/virtual-machine-manage-extension.md).
