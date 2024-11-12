---
title: Download Azure managed disk to Azure Local
description: Learn how to download Azure managed disk to Azure Local.
author: alkohli
ms.topic: how-to
ms.date: 11/12/2024
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

The parameters used are described in the table:

| Parameter | Description |
| --- | --- |
| subscription | Subscription associated with your Azure Local. 
| resource-group | Resource group for Azure Local that you associate with this image. |
| name | Name of the data disk for Azure Local. | 
| customLocation | Resource ID of the custom location for Azure Local. |
| disk-file-format | File format of the data disk. This can be .vhd or .vhdx format. |
| download-url | SAS URL of the Azure managed disk.| 

See the following example output:

```azurecli
Download Uri for VHD is: https://***** 
{ 
  "extendedLocation": { 
    "name": "/subscriptions/17ee8ecb-b995-4a26-b4d5-c281538f9a99/resourceGroups/EDGECI-REGISTRATION-HC1n25r1501-4GhAg3Or/providers/Microsoft.ExtendedLocation/customLocations/s-cluster-customlocation", 
    "type": "CustomLocation" 
  }, 
  "id": "/subscriptions/17ee8ecb-b995-4a26-b4d5-c281538f9a99/resourceGroups/EDGECI-REGISTRATION-HC1n25r1501-4GhAg3Or/providers/Microsoft.AzureStackHCI/virtualHardDisks/httpvhd02", 
  "location": "eastus2euap", 
  "name": "httpvhd02", 
  "properties": { 
    "blockSizeBytes": null, 
    "containerId": "/subscriptions/17ee8ecb-b995-4a26-b4d5-c281538f9a99/resourceGroups/EDGECI-REGISTRATION-HC1n25r1501-4GhAg3Or/providers/Microsoft.AzureStackHCI/storageContainers/UserStorage4-96856aae75a54391b4180dea4609b0f8", 
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
  "resourceGroup": "EDGECI-REGISTRATION-HC1n25r1501-4GhAg3Or", 
  "systemData": { 
    "createdAt": "2024-09-25T20:41:27.685358+00:00", 
    "createdBy": "a5e473cb-e3e7-4035-b4da-290a65350ae1", 
    "createdByType": "Application", 
    "lastModifiedAt": "2024-09-25T20:41:41.082674+00:00", 
    "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05", 
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

The parameters used are described in the table:

| Parameter | Description |
| --- | --- |
| subscription | Subscription associated with your Azure Local. 
| resource-group | Resource group for Azure Local that you associate with this image. |
| name | Name of the data disk for Azure Local. | 
| customLocation | Resource ID of the custom location for Azure Local. |
| disk-file-format | File format of the data disk. This can be .vhd or .vhdx format. |
| download-url | SAS URL of the Azure managed disk.| 

Here is example output:

```azurecli
{ 
  "extendedLocation": { 
    "name": "/subscriptions/17ee8ecb-b995-4a26-b4d5-c281538f9a99/resourceGroups/EDGECI-REGISTRATION-HC1n25r1501-4GhAg3Or/providers/Microsoft.ExtendedLocation/customLocations/s-cluster-customlocation", 
    "type": "CustomLocation" 
  }, 
  "id": "/subscriptions/17ee8ecb-b995-4a26-b4d5-c281538f9a99/resourceGroups/EDGECI-REGISTRATION-HC1n25r1501-4GhAg3Or/providers/Microsoft.AzureStackHCI/galleryImages/image03", 
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
    "sourceVirtualMachineId": "/subscriptions/17ee8ecb-b995-4a26-b4d5-c281538f9a99/resourceGroups/EDGECI-REGISTRATION-HC1n25r1501-4GhAg3Or/providers/Microsoft.HybridCompute/machines/testvm001/providers/Microsoft.AzureStackHCI/virtualMachineInstances/default", 
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
  "resourceGroup": "EDGECI-REGISTRATION-HC1n25r1501-4GhAg3Or", 
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

Once the image is created, you can check the newly created image in Azure portal.  


## Next steps

[Create Azure Local VM image using images in a local share](virtual-machine-image-local-share.md)