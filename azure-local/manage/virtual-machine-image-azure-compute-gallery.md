---
title: Create Azure Local VM from Azure Compute Gallery images via Azure CLI
description: Learn how to create Azure Local VM images using Azure Compute Gallery images.
author: sipastak
ms.author: sipastak
ms.topic: how-to
ms.service: azure-local
ms.custom:
  - devx-track-azurecli
ms.date: 10/06/2025
---

# Create Azure Local VM image using Azure Compute Gallery images

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to create Azure Local VMs enabled by Azure Arc using source images from the Azure Compute Gallery. You can create VM images on Azure CLI using the instructions in this article and then use these VM images to create Azure Local VMs.

## Prerequisites

- Make sure to review and [complete the Azure Local VM prerequisites](./azure-arc-vm-management-prerequisites.md).
- Make sure that your image is using a [supported operating system](/azure/azure-arc/servers/prerequisites#supported-operating-systems).
- For custom images in Azure Compute Gallery, ensure you meet the following extra prerequisites:
    - You should have a Virtual Hard Disk (VHD) loaded in your Azure Compute Gallery. See how to [Create an image definition and image version](/azure/virtual-machines/image-version).
    - If using a VHDX:
        - The VHDX image must be Gen 2 type and secure boot enabled.
        - The VHDX image must be prepared using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options).

## Create an Azure Local VM image from Azure Compute Gallery

Follow these steps to create an Azure Local VM image using Azure CLI.

### Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]

### Export image to managed disk

To transfer your Azure Compute Gallery image to be an Azure Local compatible image, you need to export your Azure Compute Gallery image version to a managed disk.

1. To download the Azure Compute Gallery image to your resource group, follow the steps in [Export an image version to a managed disk](/azure/virtual-machines/managed-disk-from-image-version). Note the name of the managed disk.  

1. Obtain the SAS token of the managed disk by using the following command:

    ```azurecli
    # Variables to get SAS URL for the managed disk
    $resource_group = "<Resource Group Name>"
    $diskName = "<myDiskName>" # Replace 'myDiskName' with your actual disk name
    $sasExpiryDuration = 100000 # Duration in seconds for SAS URL validity
    ```

    ```azurecli
    az disk grant-access --resource-group $resource_group --name $diskName --duration-in-seconds $sasExpiryDuration --query [accessSas] -o tsv
    ```

### Set parameters

Before creating an Azure Local VM image, you need to set some parameters.

- Set your subscription, resource group, location, path to the image in local share, and OS type for the image. Replace the parameters in `< >` with the appropriate values.

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Resource group>"
    $location = "<Location for your Azure Local>"
    $osType = "<OS of source image>"
    $imageName = "<VM image name>"
    $customLocationID = "<Custom Location ID>"
    $imageSourcePath = '"<SAS URL path to the source image>"'
    ```

    The parameters are described in the following table:

    | Parameter        | Description                                                                                |
    |------------------|--------------------------------------------------------------------------------------------|
    | `subscription`   | Subscription for Azure Local that you associate with this image.        |
    | `resource_group` | Resource group for Azure Local that you associate with this image.        |
    | `location`       | Location for your Azure Local instance. For example, this could be `eastus`. |
    | `imageName`      | Name of the VM image created starting with the image in your local share. <br> **Note**: Azure rejects all the names that contain the keyword Windows. |
    | `os-type`         | Operating system associated with the source image. This can be Windows or Linux.           |
    | `customLocationID` | Custom location ID for your Azure Local instance.      |
    | `imageSourcePath`  | Path to the compute gallery image managed disk SAS URL.        |
  
    Here's a sample output:
  
    ```azurecli
    PS C:\Users\azcli> $subscription = "<Subscription ID>"
    PS C:\Users\azcli> $resource_group = "mylocal-rg"
    PS C:\Users\azcli> $location = "eastus"
    PS C:\Users\azcli> $osType = "Windows"
    PS C:\Users\azcli> $imageName = "mylocal-computegalleryimage"
    PS C:\Users\azcli> $customLocationID = "/subscriptions/$subscription/resourcegroups/$resource_group/providers/microsoft.extendedlocation/customlocations/$customLocationName"
    PS C:\Users\azcli> $imageSourcePath = '"https://EXAMPLE.blob.storage.azure.net/EXAMPLE/abcd<sas-token>"'
    ```

### Create an Azure Local VM image

To create an Azure Local VM image:

1. Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Local. Get the custom location ID for your Azure Local. Run the following command:

    ```azurecli
    $customLocationID=(az customlocation show --resource-group $resource_group --name "<custom location name for your Azure Local>" --query id -o tsv)
    ```

1. Create the VM image starting with a specified marketplace image. Make sure to specify the offer, publisher, sku, and version for the marketplace image.

    ```azurecli
    az stack-hci-vm image create --subscription $subscription --resource-group $resource_Group --custom-location $customLocationID --location $location --name $imageName --os-type $osType --image-path $imageSourcePath
    ```

    A deployment job starts for the VM image and takes a few minutes to complete. The image download time depends on the image size and the network bandwidth available for the download.

    Here's a sample output:

    ```azurecli
      { 
      "extendedLocation": { 
        "name": "/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.ExtendedLocation/customLocations/mylocal-cl", 
        "type": "CustomLocation" 
      }, 
      "id": "/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/galleryImages/mylocal-image", 
      "location": "eastus", 
      "name": "mylocal-image", 
      "properties": { 
        "cloudInitDataSource": null, 
        "containerId": "/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/storageContainers/mylocal-storagepath", 
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
            "operationId": "00000000-0000-0000-0000-000000000000*0000000000000000000000000000000000000000000000000000000000000000", 
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
      "resourceGroup": "mylocal-rg", 
      "systemData": { 
        "createdAt": "2025-05-21T00:44:16.385633+00:00", 
        "createdBy": "guspinto@contoso.com", 
        "createdByType": "User", 
        "lastModifiedAt": "2025-05-21T00:48:34.016113+00:00", 
        "lastModifiedBy": "00000000-0000-0000-0000-000000000000", 
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

- [Create logical networks](./create-logical-networks.md)
