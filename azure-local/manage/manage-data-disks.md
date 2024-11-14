---
title: Download Azure managed disk to Azure Local
description: Learn how to download Azure managed disk to Azure Local.
author: alkohli
ms.topic: how-to
ms.date: 11/14/2024
ms.author: alkohli
ms.service: azure-stack-hci
---

# Download managed data disks to Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to download an Azure managed disk from Azure to your Azure Local instance. You can then use the disk to create an image or to attach it to your Arc virtual machines (VMs) as needed.

## Download an Azure managed disk

To download a data disk from Azure, first generate a SAS URL of the disk using Azure CLI:  

```azurecli
az disk grant-access --access-level Read --duration-in-seconds 3600 --name MyManagedDisk --resource-group $rg
```

Once the SAS URL is generated, use the following command to download it to your Azure Local:  

```azurecli
az stack-hci-vm disk create -resource-group $rg --disk-file-format vhd --custom-location $cl --download-url $encodedUrl --name httpvhd02
```

Set parameters for your subscription, resource group, location, disk, and SAS URL. Replace the parameters in `< >` with the appropriate values.

```azurecli
$subscription = "<Subscription ID>"
$resource-group = "<Resource group>"
$name = "<Data disk name>"
$customLocation = "<Custom location resource ID>"
$disk-file-format = "<Data disk file format>"
$download-url = "<SAS URL>"
```

The parameters are described in the following table:

| Parameter | Description |
| --- | --- |
| subscription | Subscription associated with your Azure Local. 
| resource-group | Resource group for Azure Local that you associate with this image. |
| name | Name of the data disk for Azure Local. | 
| customLocation | Resource ID of the custom location for Azure Local. |
| disk-file-format | File format of the data disk. This can be .vhd or .vhdx format. |
| download-url | SAS URL of the Azure managed disk.| 

Here is an example output:

```azurecli
Download Uri for VHD is: https://***** 
{ 
  "extendedLocation": { 
    "name": "/subscriptions/resourceGroups/providers/Microsoft.ExtendedLocation/customLocations/", 
    "type": "CustomLocation" 
  }, 
  "id": "/subscriptions/resourceGroups/providers/Microsoft.AzureStackHCI/virtualHardDisks/httpvhd02", 
  "location": "eastus2euap", 
  "name": "httpvhd02", 
  "properties": { 
    "blockSizeBytes": null, 
    "containerId": "/subscriptions/resourceGroups/providers/Microsoft.AzureStackHCI/storageContainers/UserStorage", 
    "diskFileFormat": "vhd", 
    "diskSizeGb": null, 
    "downloadUrl": null, 
    "dynamic": null, 
    "hyperVGeneration": null, 
    "logicalSectorBytes": null, 
    "physicalSectorBytes": null, 
    "provisioningState": "Succeeded", 
    "status": { 
      "downloadStatus": null, 
      "errorCode": "", 
      "errorMessage": "", 
      "provisioningStatus": null, 
      "uploadStatus": null 
    } 
  }, 
  "resourceGroup": "myresourcegroup", 
  "systemData": { 
    "createdAt": "2024-09-25T20:41:27.685358+00:00", 
    "createdBy": "mycreatedby", 
    "createdByType": "Application", 
    "lastModifiedAt": "2024-09-25T20:41:41.082674+00:00", 
    "lastModifiedBy": "mylastmodifiedby", 
    "lastModifiedByType": "Application" 
  }, 
  "tags": null, 
  " 
```

### Create an image using an existing Arc VM 

You can create a gallery image using an existing Arc VM. The OS disk of the Arc VM is used to create a gallery image on your Azure Local instance:

```azurecli
az stack-hci-vm image create -resource-group $rg --location eastus2euap --custom-location $cl --os-type "Windows" --source-vm "testvm001" --name image03
```

Set parameters for your subscription, resource group, location, disk, and SAS URL. Replace the parameters in `< >` with the appropriate values.

```azurecli
$subscription = "<Subscription ID>"
$resource-group = "<Resource group>"
$name = "<Data disk name>"
$customLocation = "<Custom location resource ID>"
$disk-file-format = "<Data disk file format>"
$download-url = "<SAS URL>"
```

The parameters are described in the following table:

| Parameter | Description |
| --- | --- |
| subscription | Subscription associated with your Azure Local. 
| resource-group | Resource group for Azure Local that you associate with this image. |
| name | Name of the data disk for Azure Local. | 
| customLocation | Resource ID of the custom location for Azure Local. |
| disk-file-format | File format of the data disk. This can be .vhd or .vhdx format. |
| download-url | SAS URL of the Azure managed disk.| 

Here is an example output:

```azurecli
{ 
  "extendedLocation": { 
    "name": "/subscriptions/resourceGroups/providers/Microsoft.ExtendedLocation/customLocations/", 
    "type": "CustomLocation" 
  }, 
  "id": "/subscriptions/resourceGroups/providers/Microsoft.AzureStackHCI/galleryImages/image03", 
  "location": "eastus2euap", 
  "name": "image03", 
  "properties": { 
    "cloudInitDataSource": null, 
    "containerId": null, 
    "hyperVGeneration": null, 
    "identifier": null, 
    "imagePath": null, 
    "osType": "Windows", 
    "provisioningState": "Succeeded", 
    "sourceVirtualMachineId": "/subscriptions/resourceGroups/providers/Microsoft.HybridCompute/machines/testvm001/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default", 
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
  "resourceGroup": "myresourcegrou", 
  "systemData": { 
    "createdAt": "2024-09-26T20:16:17.625002+00:00", 
    "createdBy": "mycreatedby", 
    "createdByType": "Application", 
    "lastModifiedAt": "2024-09-26T20:16:17.625002+00:00", 
    "lastModifiedBy": "mylastmodifiedby", 
    "lastModifiedByType": "Application" 
  }, 
  "tags": null, 
  "type": "microsoft.azurestackhci/galleryimages" 
}
```

Once the image is created, you can check the newly created image in Azure portal.  


## Next steps

[Create Azure Local VM image using images in a local share](virtual-machine-image-local-share.md)