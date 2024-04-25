---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom: devx-track-azurecli
ms.topic: include
ms.date: 11/06/2023
---

Follow these steps to use Azure CLI to view properties of an image:

1. Run PowerShell as an administrator.
1. Set the following parameters.

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Cluster resource group>"
    $mktplaceImage = "<Marketplace image name>"
    ```

1. You can view image properties in two different ways: specify ID or specify name and resource group. Take the following steps when specifying Marketplace image ID:

    1. Set the following parameter.

        ```azurecli
        $mktplaceImageID = "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/galleryimages/myhci-marketplaceimage"
        ```

    1.	Run the following command to view the properties.

        ```az stack-hci-vm image show --ids $mktplaceImageID```

        Here's a sample output for this command:

        ```
        PS C:\Users\azcli> az stack-hci-vm image show --ids $mktplaceImageID
        Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
        {
          "extendedLocation": {
            "name": "/subscriptions/<Subscription ID>/resourcegroups/myhci-rg/providers/microsoft.extendedlocation/customlocations/myhci-cl",
            "type": "CustomLocation"
          },
          "id": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/galleryimages/myhci-marketplaceimage",
          "location": "eastus",
          "name": "myhci-marketplaceimage",
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
            "createdAt": "2022-08-05T20:52:38.579764+00:00",
            "createdBy": "guspinto@microsoft.com",
            "createdByType": "User",
            "lastModifiedAt": "2022-08-05T20:52:38.579764+00:00",
            "lastModifiedBy": "guspinto@microsoft.com",
            "lastModifiedByType": "User"
          },
          "tags": null,
          "type": "microsoft.azurestackhci/galleryimages"
        }
        PS C:\Users\azcli> 
        ```
<!--
1.	Take the following steps when specifying name and resource group.

    1. Set the following parameters:
    
        ```azurecli
        $mktplaceImage = "myhci-marketplaceimage"
        $resource_group = "myhci-rg"    
        ```
    
    1. Run the following command to view the properties:
    
        ```azurecli
        az azurestackhci image show --name $MktplaceImage --resource-group $Resource_Group
        ```
    	
        Here's a sample output:

         ```azurecli
            PS C:\Users\azcli> az stack-hci-vm image show --ids $mktplaceImageID
            Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
            {
              "extendedLocation": {
                "name": "/subscriptions/<Suscription ID>/resourceGroups/myhci-rg/providers/Microsoft.ExtendedLocation/customLocations/cluster-638d2f5b237b4af6978885a2885d3ef4-mocarb-cl",
                "type": "CustomLocation"
              },
              "id": "/subscriptions/<Suscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/marketplacegalleryimages/myhci-marketplaceimage",
              "location": "eastus",
              "name": "myhci-marketplaceimage",
              "properties": {
                "identifier": {
                  "offer": "windowsserver",
                  "publisher": "microsoftwindowsserver",
                  "sku": "2022-datacenter-azure-edition-core"
                },
                "imagePath": null,
                "osType": "Windows",
                "provisioningState": "Accepted",
                "status": {
                  "downloadStatus": {
                    "downloadSizeInMB": 3932
                  },
                  "progressPercentage": 57,
                  "provisioningStatus": {}
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
                "createdAt": "2023-10-27T21:43:15.920502+00:00",
                "createdBy": "guspinto@contoso.com",
                "createdByType": "User",
                "lastModifiedAt": "2023-10-27T21:43:15.920502+00:00",
                "lastModifiedBy": "guspinto@contoso.com",
                "lastModifiedByType": "User"
              },
              "tags": null,
              "type": "microsoft.azurestackhci/marketplacegalleryimages"
            }
            PS C:\Users\azcli>
   
         ```
-->
