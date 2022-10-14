---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 10/05/2022
---

Follow these steps to use Azure CLI to view properties of an image:

1. Run PowerShell as an administrator.
1. Set the following parameters.

    ```azurecli
    $Subscription = "<Subscription ID>"
    $Resource_Group = "<Cluster resource group>"
    $MktplaceImage = "<Marketplace image name>"
    ```

1. You can view image properties in two different ways: specify ID or specify name and resource group. Take the following steps when specifying ID:

    1. Set the following parameter.

        ```azurecli
        $MktplaceImageID = "/subscriptions/<Subscription ID>/resourceGroups/mkclus90-rg/providers/Microsoft.AzureStackHCI/galleryimages/mktplace8"
        ```

    1.	Run the following command to view the properties.

        ```az azurestackhci galleryimage show --id $mktplaceImageID```

        Here's a sample output for this command:

        ```
        PS C:\Users\azcli> az azurestackhci galleryimage show --id $mktplaceImageID
        Command group 'azurestackhci' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
        {
          "extendedLocation": {
            "name": "/subscriptions/<Subscription ID>/resourcegroups/mkclus90-rg/providers/microsoft.extendedlocation/customlocations/cl04",
            "type": "CustomLocation"
          },
          "id": "/subscriptions/<Subscription ID>/resourceGroups/mkclus90-rg/providers/Microsoft.AzureStackHCI/galleryimages/mktplace8",
          "location": "eastus2euap",
          "name": "mktplace8",
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
          "resourceGroup": "mkclus90-rg",
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

1.	Take the following steps when specifying name and resource group.

    1. Set the following parameters:
    
        ```azurecli
        $mktplaceImage = "mktplace8"
        $resource_group = "mkclus90-rg"    
        ```
    
    1. Run the following command to view the properties:
    
        ```azurecli
        az azurestackhci galleryimage show --name $MktplaceImage --resource-group $Resource_Group
        ```
    	
        Here's a sample output:

         ```azurecli
         PS C:\Users\azcli> az azurestackhci galleryimage show --name $mktplaceImage --resource-group $resource_group
         Command group 'azurestackhci' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
         {
            "extendedLocation": {
            "name": "/subscriptions/<Subscription ID>/resourcegroups/mkclus90-rg/providers/microsoft.extendedlocation/customlocations/cl04",
            "type": "CustomLocation"
            },
            "id": "/subscriptions/b8d594e5-51f3-4c11-9c54-a7771b81c712/resourceGroups/mkclus90-rg/providers/Microsoft.AzureStackHCI/galleryimages/mktplace8",
            "location": "eastus2euap",
            "name": "mktplace8",
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
            "resourceGroup": "mkclus90-rg",
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
