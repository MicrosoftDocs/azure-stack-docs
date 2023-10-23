---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom: devx-track-azurecli
ms.topic: include
ms.date: 10/18/2023
---

Follow these steps to list VM image using Azure CLI.

1. Run PowerShell as an administrator.
1. Set some parameters.

    ```azurecli
    $subscription = "<Subscription ID associated with your cluster>"
    $resource_group = "<Resource group name for your cluster>"
    ```
1. List all the VM images associated with your cluster. Run the following command:

    ```azurecli
    az stack-hci-vm image list --subscription $subscription --resource-group $resource_group
    ```
    
    Depending on the command used, a corresponding set of images associated with the Azure Stack HCI cluster are listed.

    - If you specify just the subscription, the command lists all the images in the subscription.
    - If you specify both the subscription and the resource group, the command lists all the images in the resource group.

    These images include:
    - VM images from marketplace images.
    - Custom images that reside in your Azure Storage account or are in a local share on your cluster or a client connected to the cluster.

Here's a sample output.

```
PS C:\Users\azcli> az stack-hci-vm image list --subscription "<Subscription ID>" --resource-group "myhci-rg"
Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
[
  {
    "extendedLocation": {
      "name": "/subscriptions/<Subscription ID>/resourcegroups/myhci-rg/providers/microsoft.extendedlocation/customlocations/myhci-cl",
      "type": "CustomLocation"
    },
    "id": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/galleryimages/testvhdgen1",
    "location": "eastus2euap",
    "name": "testvhdgen1",
    "properties": {
      "containerName": null,
      "hyperVGeneration": "V1",
      "identifier": null,
      "imagePath": null,
      "osType": "Windows",
      "provisioningState": "Succeeded",
      "status": null,
      "version": null
    },
    "resourceGroup": "myhci-rg",
    "systemData": {
      "createdAt": "2022-07-28T22:45:30.803142+00:00",
      "createdBy": "guspinto@microsoft.com",
      "createdByType": "User",
      "lastModifiedAt": "2022-07-28T22:45:30.803142+00:00",
      "lastModifiedBy": "guspinto@microsoft.com",
      "lastModifiedByType": "User"
    },
    "tags": null,
    "type": "microsoft.azurestackhci/galleryimages"
  },
  {
    "extendedLocation": {
      "name": "/subscriptions/<Subscription ID>/resourcegroups/myhci-rg/providers/microsoft.extendedlocation/customlocations/myhci-cl",
      "type": "CustomLocation"
    },
    "id": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/galleryimages/myvhdxgen2image",
    "location": "eastus2euap",
    "name": "myvhdxgen2image",
    "properties": {
      "containerName": null,
      "hyperVGeneration": null,
      "identifier": null,
      "imagePath": null,
      "osType": "Windows",
      "provisioningState": "Succeeded",
      "status": null,
      "version": null
    },
    "resourceGroup": "myhci-rg",
    "systemData": {
      "createdAt": "2022-07-28T23:00:56.490100+00:00",
      "createdBy": "guspinto@microsoft.com",
      "createdByType": "User",
      "lastModifiedAt": "2022-07-28T23:00:56.490100+00:00",
      "lastModifiedBy": "<ID>",
      "lastModifiedByType": "User"
    },
    "tags": null,
    "type": "microsoft.azurestackhci/galleryimages"
  },
  {
    "extendedLocation": {
      "name": "/subscriptions/<Subscription ID>/resourcegroups/myhci-rg/providers/microsoft.extendedlocation/customlocations/myhci-cl",
      "type": "CustomLocation"
    },
    "id": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/marketplacegalleryimages/mymktimage",
    "location": "eastus2euap",
    "name": "mymktimage",
    "properties": {
      "containerName": null,
      "hyperVGeneration": null,
      "identifier": {
        "offer": "windowsserver",
        "publisher": "microsoftwindowsserver",
        "sku": "2022-datacenter-azure-edition-core"
      },
      "imagePath": null,
      "osType": "Windows",
      "provisioningState": "Succeeded",
      "resourceName": "mymktimage",
      "status": {
        "downloadStatus": {},
        "provisioningStatus": {
          "operationId": "<Operation ID>",
          "status": "Succeeded"
        }
      },
      "version": {
        "name": "20348.707.220609",
        "properties": {
          "storageProfile": {
            "osDiskImage": {}
          }
        }
      }
    },
    "resourceGroup": "myhci-rg",
    "systemData": {
      "createdAt": "2022-08-01T22:29:11.074104+00:00",
      "createdBy": "guspinto@microsoft.com",
      "createdByType": "User",
      "lastModifiedAt": "2022-08-01T22:36:12.900694+00:00",
      "lastModifiedBy": "<ID>",
      "lastModifiedByType": "Application"
    },
    "tags": null,
    "type": "microsoft.azurestackhci/marketplacegalleryimages"
  }
]
PS C:\Users\azcli>
```