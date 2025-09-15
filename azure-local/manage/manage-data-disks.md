---
title: Download Azure managed disk to Azure Local
description: Learn how to download Azure managed disk to Azure Local.
author: alkohli
ms.topic: how-to
ms.date: 06/27/2025
ms.author: alkohli
ms.service: azure-local
---

# Download managed data disks to Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to download an Azure managed disk from Azure to your Azure Local instance. You can then use the disk to create an image or to attach it to your Azure Local virtual machines (VMs) enabled by Arc, as needed.

## Prerequisites

Before you begin, make sure to complete the following prerequisites:

- You have access to an Azure Local instance that is deployed and registered.
- There is already a managed disk in Azure.


## Download an Azure managed disk

Download an Azure managed disk as follows:

1. Set parameters for `subscription`, `resource-group`, `name`, and `custom-location`. Replace the parameters in `< >` with the appropriate values:

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource-group = "<Resource group>"
    $name = "<Data disk name>"
    $custom-location = "<Custom location resource ID>"
    ```

1. Generate a SAS URL of the disk using Azure CLI:  

    ```azurecli
    az disk grant-access --access-level Read --duration-in-seconds 3600 --name $name --resource-group $resource-group
    ```

1. Once the SAS URL is generated, use the following command to download it to your Azure Local:  

    ```azurecli
    az stack-hci-vm disk create -resource-group $resource-group --custom-location $custom-location --download-url $download-url --name $name
    ```

The parameters are described in the following table:

| Parameter | Description |
| --- | --- |
| `subscription` | Subscription associated with your Azure Local. 
| `resource-group` | Resource group for Azure Local that you associate with this image. |
| `name` | Name of the data disk for Azure Local. | 
| `custom-location` | Resource ID of the custom location for Azure Local. |
| `download-url` | SAS URL of the Azure managed disk.| 

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

## Next steps

[Create Azure Local VM image using images in a local share](virtual-machine-image-local-share.md)
