---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 10/05/2022
---

1. Run PowerShell as an administrator.
1. Set the following parameters.

    ```azurecli
    $Subscription = "<Subscription ID>"
    $Resource_Group = "<Cluster resource group>"
    $GalleryImageName = "<Gallery image name>"    
    ```

1. Remove an existing VM image. Run the following command:

    ```azurecli
    az azurestackhci galleryimage delete --subscription $Subscription --resource-group $Resource_Group --name $GalleryImageName --yes
    ```

You can delete image two ways:

- Specify name and resource group.
- Specify ID.

After you've deleted an image, you can check that the image is removed. Here's a sample output when the image was deleted by specifying the name and the resource-group.

```
PS C:\Users\azcli> $subscription = "<Subscription ID>"
PS C:\Users\azcli> $resource_group = "mkclus90-rg"
PS C:\Users\azcli> $mktplaceImage = "marketplacetest04"
PS C:\Users\azcli> az azurestackhci image delete --name $mktplaceImage --resource-group $resource_group
Command group 'azurestackhci' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
Are you sure you want to perform this operation? (y/n): y
PS C:\Users\azcli> az azurestackhci image show --name $mktplaceImage --resource-group $resource_group
Command group 'azurestackhci' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
ResourceNotFound: The Resource 'Microsoft.AzureStackHCI/marketplacegalleryimages/marketplacetest04' under resource group 'mkclus90-rg' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix
PS C:\Users\azcli>
```