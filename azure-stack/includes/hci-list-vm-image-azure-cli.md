---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom: devx-track-azurecli
ms.topic: include
ms.date: 11/06/2023
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
    "id": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/microsoft.azurestackhci/marketplacegalleryimages/w
inServer2022Az-01",
    "location": "eastus",
    "name": "winServer2022Az-01",
    "properties": {
      "hyperVGeneration": "V2",
      "identifier": {
        "offer": "windowsserver",
        "publisher": "microsoftwindowsserver",
        "sku": "2022-datacenter-azure-edition-core"
      },
      "imagePath": null,
      "osType": "Windows",
      "provisioningState": "Succeeded",
      "status": {
        "downloadStatus": {
          "downloadSizeInMB": 6710
        },
        "progressPercentage": 100,
        "provisioningStatus": {
          "operationId": "19742d69-4a00-4086-8f17-4dc1f7ee6681*E1E9889F0D1840B93150BD74D428EAE483CB67B0904F9A198C161AD471F670ED",
          "status": "Succeeded"
        }
      },
      "storagepathId": null,
      "version": {
        "name": "20348.2031.231006",
        "properties": {
          "storageProfile": {
            "osDiskImage": {
              "sizeInMB": 130050
            }
          }
        }
      }
    },
    "resourceGroup": "myhci-rg",
    "systemData": {
      "createdAt": "2023-10-30T21:44:53.020512+00:00",
      "createdBy": "guspinto@contoso.com",
      "createdByType": "User",
      "lastModifiedAt": "2023-10-30T22:08:25.495995+00:00",
      "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
      "lastModifiedByType": "Application"
    },
    "tags": {},
    "type": "microsoft.azurestackhci/marketplacegalleryimages"
  }
]
PS C:\Users\azcli>
```