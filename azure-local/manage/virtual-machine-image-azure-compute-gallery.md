---
title: Create Azure Local VM from Azure Compute gallery images via Azure CLI
description: Learn how to create Azure Local VM images using Azure Compute gallery images.
author: sipastak
ms.author: sipastak
ms.topic: how-to
ms.service: azure-local
ms.custom:
  - devx-track-azurecli
ms.date: 05/21/2025
---

# Create Azure Local VM image using Azure Compute Gallery images

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to create Azure Local VMs enabled by Azure Arc using source images from the Azure Compute Gallery. You can create VM images on Azure CLI using the following steps and then use these VM images to create Azure Local VMs.

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

- Make sure to review and [complete the prerequisites](./azure-arc-vm-management-prerequisites.md).
- Make sure that your image is using a [supported operating system](/azure/azure-arc/servers/prerequisites#supported-operating-systems).
- For custom images in Azure Compute Gallery, ensure you meet the following extra prerequisites:
    - You should have a VHD loaded in your Azure Compute Gallery. See how to [Create an image definition and image version](/azure/virtual-machines/image-version).
    - If using a VHDX:
        - The VHDX image must be Gen 2 type and secure boot enabled.
        - The VHDX image must be prepared using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options).

## Export image to managed disk

To transfer your Azure Compute Gallery image to be an Azure Local compatible image, you need to export your Azure Compute Gallery image version to a managed disk.

1. To download the Azure Compute Gallery image to your resource group, follow the steps in [Export an image version to a managed disk](/azure/virtual-machines/managed-disk-from-image-version). Note the name of the managed disk.  

1. Obtain the SAS token of the managed disk by using the following command:

    ```azurecli
    az disk grant-access --resource-group $resourceGroupName --name $diskName --duration-in-seconds $sasExpiryDuration --query [accessSas] -o tsv
    ```

## Set some parameters

### Set some parameters

1. Set your subscription, resource group, location, path to the image in local share, and OS type for the image. Replace the parameters in `< >` with the appropriate values.

```azurecli
$subscription = "<Subscription ID>"
$resource_group = "<Resource group>"
$location = "<Location for your Azure Local>"
$osType = "<OS of source image>"
$imageName = "<VM image name>"
```

The parameters are described in the following table:

| Parameter        | Description                                                                                |
|------------------|--------------------------------------------------------------------------------------------|
| `subscription`   | Subscription for Azure Local that you associate with this image.        |
| `resource_group` | Resource group for Azure Local that you associate with this image.        |
| `location`       | Location for your Azure Local instance. For example, this could be `eastus`. |
| `imageName`      | Name of the VM image created starting with the image in your local share. <br> **Note**: Azure rejects all the names that contain the keyword Windows. |
| `os-type`         | Operating system associated with the source image. This can be Windows or Linux.           |

Here's a sample output:

```
PS C:\Users\azcli> $subscription = "<Subscription ID>"
PS C:\Users\azcli> $resource_group = "mylocal-rg"
PS C:\Users\azcli> $location = "eastus"
PS C:\Users\azcli> $osType = "Windows"
PS C:\Users\azcli> $imageName = "mylocal-computegalleryimage"
```

## Create an Azure Local VM image

To create an Azure Local VM image:

1. Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Local. Get the custom location ID for your Azure Local. Run the following command:

    ```azurecli
    $customLocationID=(az customlocation show --resource-group $resource_group --name "<custom location name for your Azure Local>" --query id -o tsv)
    ```

1. Create the VM image starting with a specified marketplace image. Make sure to specify the offer, publisher, sku and version for the marketplace image.

    ```azurecli
    az stack-hci-vm image create --subscription $subscription --resource-group $resource_Group --custom-location $customLocationID --location $location --name $imageName --os-type $osType --image-path $imageSourcePath --storage-path-id $storagepathid
    ```

    A deployment job starts for the VM image.

    In this example, the storage path was specified using the `--storage-path-id` flag and that ensured that the workload data (including the VM, VM image, non-OS data disk) is placed in the specified storage path.

    If the flag is not specified, the workload data is automatically placed in a high availability storage path.

The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the image and the network bandwidth available for the download.

Here's a sample output:

```
PS > $customLocationID=(az customlocation show --resource-group $resource_group --name "mylocal-cl" --query id -o tsv)
PS C:\Users\azcli> az stack-hci-vm image create -g $rg --custom-location $cl --name "ws2022-acg" --os-type "Windows" --image-path $sas 

{ 
  "extendedLocation": { 
    "name": "/subscriptions/304d8fdf-1c02-4907-9c3a-ddbd677199cd/resourceGroups/EDGECI-REGISTRATION-rr1s45r2305-yxwEPQD5/providers/Microsoft.ExtendedLocation/customLocations/s45r2305-cl-customlocation", 
    "type": "CustomLocation" 
  }, 
  "id": "/subscriptions/304d8fdf-1c02-4907-9c3a-ddbd677199cd/resourceGroups/EDGECI-REGISTRATION-rr1s45r2305-yxwEPQD5/providers/Microsoft.AzureStackHCI/galleryImages/ws2022-acg", 
  "location": "eastus2euap", 
  "name": "ws2022-acg", 
  "properties": { 
    "cloudInitDataSource": null, 
    "containerId": "/subscriptions/304d8fdf-1c02-4907-9c3a-ddbd677199cd/resourceGroups/EDGECI-REGISTRATION-rr1s45r2305-yxwEPQD5/providers/Microsoft.AzureStackHCI/storageContainers/UserStorage2-213e900d7d9646a18b0f0d78e05d2fac", 
    "hyperVGeneration": null, 
    "identifier": null, 
    "imagePath": null, 
    "osType": "Windows", 
    "provisioningState": "Succeeded", 
    "sourceVirtualMachineId": null, 
    "status": { 
      "downloadStatus": { 
        "downloadSizeInMb": 11482 
      }, 
      "errorCode": "", 
      "errorMessage": "", 
      "progressPercentage": 100, 
      "provisioningStatus": { 
        "operationId": "c8ddceb0-024a-4c2c-b085-5851f49c8e70*C185A1631E1C1B45E1069847327BBD6B413DB17AA1F8C87B2911596ACA473D16", 
        "status": "Succeeded" 
      } 
    }, 
    "version": { 
      "name": null, 
      "properties": { 
        "storageProfile": { 
          "osDiskImage": { 
            "sizeInMb": 130050 
          } 
        } 
      } 
    }, 
    "vmImageRepositoryCredentials": null 
  }, 
  "resourceGroup": "EDGECI-REGISTRATION-rr1s45r2305-yxwEPQD5", 
  "systemData": { 
    "createdAt": "2025-05-21T00:44:16.385633+00:00", 
    "createdBy": "guspinto@contoso.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2025-05-21T00:48:34.016113+00:00", 
    "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05", 
    "lastModifiedByType": "Application" 
  }, 
  "tags": null, 
  "type": "microsoft.azurestackhci/galleryimages" 
} 
```

1. To avoid costs associated with a disk, make sure to delete the managed disk that was used to create this image using the following command:

    ```azurecli
    az disk delete --name $diskName --resource-group $resourceGroupName
    ```

## Next steps

- [Create logical networks](./create-virtual-networks.md)
