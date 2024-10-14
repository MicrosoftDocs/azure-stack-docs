---
title: Create Azure Stack HCI VM image from an existing Arc VM
description: Learn how to create Azure Stack HCI VM images using an existing Arc VM via Azure CLI.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack-hci
ms.custom:
  - devx-track-azurecli
ms.date: 10/13/2024
---

# Create Azure Stack HCI VM image using existing Arc VMs

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to create virtual machine (VM) images for your Azure Stack HCI using existing Arc VMs via the Azure CLI. The operating system (OS) disk of the Arc VM is used to create a gallery image on your Azure Stack HCI.


## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

- Make sure to review and complete the prerequisites.
- If using a client to connect to your Azure Stack HCI cluster, see [Connect to Azure Stack HCI via Azure CLI client](./azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements).


## Create VM image from existing Arc VM

You create a VM image starting from the OS disk of the Arc VM and then use this image to deploy VMs on your Azure Stack HCI.

Follow these steps to create a VM image using the Azure CLI.

### Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../../includes/hci-vm-sign-in-set-subscription.md)]

### Set some parameters

Set your subscription, resource group, location, path to the image in local share, and OS type for the image. Replace the parameters in `< >` with the appropriate values.

```azurecli
$subscription = "<Subscription ID>"
$resource_group = "<Resource group>"
$location = "<Location for your Azure Stack HCI>"
$custom_location = "<Custom location for your Azure Stack HCI>"
$osType = "<OS of source VM>"
$imageName = "<VM image name>"
$sourceVmName = "<Name of source VM  in the Storage account>"
```

The parameters are described in the following table:

| Parameter        | Description                                                                                |
|------------------|--------------------------------------------------------------------------------------------|
| `subscription`   | Subscription for Azure Stack HCI cluster that you associate with this image.        |
| `resource_group` | Resource group for Azure Stack HCI cluster that you associate with this image.        |
| `location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`. |
| `custom-location`| Custom location ID for your Azure Stack HCI cluster.  |
| `name`           | Name of the VM image created starting with the image in your local share. <br> **Note**: Azure rejects all the names that contain the keyword Windows. |
| `source-vm`      | Name of an existing Arc VM that you'll use to create the VM image. |
| `os-type`        | Operating system associated with the source image. This can be Windows or Linux.           |

Here's a sample output:

```
PS C:\Users\azcli> $subscription = "mysub-id"
PS C:\Users\azcli> $resource_group = "myhci-rg"
PS C:\Users\azcli> $location = "eastus"
PS C:\Users\azcli> $custom_location = "myhci-cl"
PS C:\Users\azcli> $osType = "Windows"
PS C:\Users\azcli> $imageName = "myhci-image"
PS C:\Users\azcli> $sourceVmName = "mysourcevm"
```

### Create VM image from an Arc VM


Create the VM image from an existing Arc VM. Run the following command:

```azurecli
az stack-hci-vm image create -resource-group $resource_group --location $location --custom-location $custom_location --os-type $osType --source-vm $sourceVmName --name $imageName
```

A deployment job starts for the VM image. The image deployment takes a few minutes to complete.

Here's a sample output:

```
{
  "extendedLocation": {
    "name": "/subscriptions/mysub-id/resourceGroups/myhci-rg/providers/Microsoft.ExtendedLocation/customLocations/myhci-cl",
    "type": "CustomLocation"
  },
  "id": "/subscriptions/mysub-id/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/galleryImages/myhci-image",
  "location": "eastus",
  "name": "myhci-image",
  "properties": {
    "cloudInitDataSource": null,
    "containerId": null,
    "hyperVGeneration": null,
    "identifier": null,
    "imagePath": null,
    "osType": "Windows",
    "provisioningState": "Succeeded",
    "sourceVirtualMachineId": "/subscriptions/mysub-id/resourceGroups/myhci-rg/providers/Microsoft.HybridCompute/machines/mysourcevm/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default",
    "status": {
      "downloadStatus": {
        "downloadSizeInMb": null
      },
      "errorCode": "",
      "errorMessage": "",
      "progressPercentage": null,
      "provisioningStatus": {
        "operationId": null,
        "status": null
      }
    },
    "version": {
      "name": null,
      "properties": {
        "storageProfile": {
          "osDiskImage": {
            "sizeInMb": null
          }
        }
      }
    }
  },
  "resourceGroup": "myhci-rg",
  "systemData": {
    "createdAt": "2024-09-26T20:16:17.625002+00:00",
    "createdBy": "a5e473cb-e3e7-4035-b4da-290a65350ae1",
    "createdByType": "Application",
    "lastModifiedAt": "2024-09-26T20:16:17.625002+00:00",
    "lastModifiedBy": "a5e473cb-e3e7-4035-b4da-290a65350ae1",
    "lastModifiedByType": "Application"
  },
  "tags": null,
  "type": "microsoft.azurestackhci/galleryimages"
}
```

## List VM images

You need to view the list of VM images to choose an image to manage.

[!INCLUDE [hci-list-vm-image-azure-cli](../../includes/hci-list-vm-image-azure-cli.md)]

## View VM image properties

You might want to view the properties of VM images before you use the image to create a VM. Follow these steps to view the image properties:

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../../includes/hci-view-vm-image-properties-azure-cli.md)]


## Delete VM image

You might want to delete a VM image if the download fails for some reason or if the image is no longer needed. Follow these steps to delete the VM images.

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../../includes/hci-delete-vm-image-azure-cli.md)]

## Next steps

- [Create logical networks](./create-virtual-networks.md)
