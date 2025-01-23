---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.custom: devx-track-azurecli
ms.topic: include
ms.date: 10/25/2024
---

1. Run PowerShell as an administrator.
1. Set the following parameters:

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Azure Local resource group>"
    $mktplaceImage = "<Markeplace image name>"    
    ```

1. Remove an existing VM image. Run the following command:

    ```azurecli
    az stack-hci-vm image delete --subscription $subscription --resource-group $resource_group --name $mktplaceImage --yes
    ```

You can delete image two ways:

- Specify name and resource group.
- Specify ID.

After you've deleted an image, you can check that the image is removed. Here's a sample output when the image was deleted by specifying the name and the resource-group.

```
PS C:\Users\azcli> $subscription = "<Subscription ID>"
PS C:\Users\azcli> $resource_group = "mylocal-rg"
PS C:\Users\azcli> $mktplaceImage = "mymylocal-marketplaceimage"
PS C:\Users\azcli> az stack-hci-vm image delete --name $mktplaceImage --resource-group $resource_group
Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
Are you sure you want to perform this operation? (y/n): y
PS C:\Users\azcli> az stack-hci-vm image show --name $mktplaceImage --resource-group $resource_group
Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
ResourceNotFound: The Resource 'Microsoft.AzureStackHCI/marketplacegalleryimages/myhci-marketplaceimage' under resource group 'mylocal-rg' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix
PS C:\Users\azcli>
```
