---
title: Manage VM Images on Azure Local via Azure CLI and Azure Portal
description: Learn how to list, view properties, and delete virtual machine images on Azure Local using Azure CLI or Azure portal.
author: ronmiab
ms.author: robess
ms.reviewer: kimlam
ms.date: 12/09/2025
ms.topic: how-to
ms.service: azure-local
---

# Manage Azure Local VM images via CLI and the portal

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to manage virtual machine (VM) images on your Azure Local instance. After you create VM images from various sources such as Azure Marketplace, Azure Compute Gallery, Azure Storage accounts, or local shares, you can list, view properties, and delete these images using Azure CLI or the Azure portal.

## Prerequisites

Before you begin, make sure you have:

- An Azure Local instance with Arc VM management enabled
- Appropriate permissions to manage VM images
- Azure CLI installed (if using CLI commands)
- Access to the Azure portal (if using portal)

## List VM images

View the complete list of VM images on your Azure Local instance to identify which images are available for VM management.

### [Azure CLI](#tab/azurecli)

Follow these steps to list VM image using Azure CLI.

1. Run PowerShell as an administrator.

1. Set some parameters. For example, subscription and resource group:

    ```azurecli
    $subscription = "<Subscription ID associated with your Azure Local>"
    $resource_group = "<Resource group name for your Azure Local>"
    ```

1. List all the VM images associated with your Azure Local. Run the following command:

    ```azurecli
    az stack-hci-vm image list --subscription $subscription --resource-group $resource_group
    ```

The command returns different sets of images depending on the parameters you specify:

- **Subscription only**: Lists all images in the subscription

- **Subscription and resource group**: Lists all images in the specific resource group

The results include VM images from:

- VM images from marketplace images.
- Custom images that reside in:
  - Your Azure Storage account
  - A local share on your system
  - A client connected to your system

Here's a sample output:

```azurecli
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
    "resourceGroup": "mylocal-rg",
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
```

For more information on this CLI command, see [az stack-hci-vm image list](/cli/azure/stack-hci-vm/image#az-stack-hci-vm-image-list).

### [Azure portal](#tab/azureportal)

Follow these steps to view the list of VM images in Azure portal.

1. In the Azure portal, navigate to your Azure Local resource.

1. Go to **Resources > VM images**.

1. The right pane displays the list of VM images, including:
   - Images currently downloaded
   - Images being downloaded
   - Download status and progress

:::image type="content" source="../manage/media/manage-vm-resources/list-virtual-machine-images.png" alt-text="Screenshot of the list of VM images on your Azure Local." lightbox="../manage/media/manage-vm-resources/list-virtual-machine-images.png":::

---

## View VM image properties

Review detailed properties of a VM image before using it to create virtual machines.

### [Azure CLI](#tab/azurecli)

Follow these steps to view image properties using Azure CLI:

1. Run PowerShell as an administrator.

1. Set the following parameters.

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Azure Local resource group>"
    $mktplaceImage = "<Marketplace image name>"
    ```

1. View image properties using one of two methods: marketplace image ID or name and resource group

    - **Method 1: Using marketplace image ID**

        Set the image ID parameter:

        ```azurecli
        $mktplaceImageID = "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/galleryimages/mylocal-marketplaceimage"
        ```

        Run the command:

        ```azurecli
        az stack-hci-vm image show --ids $mktplaceImageID
        ```

        Here's a sample output:

        ```azurecli
        PS C:\Users\azcli> az stack-hci-vm image show --ids $mktplaceImageID
        Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
        {
          "extendedLocation": {
            "name": "/subscriptions/<Subscription ID>/resourcegroups/myhci-rg/providers/microsoft.extendedlocation/customlocations/mylocal-cl",
            "type": "CustomLocation"
          },
          "id": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/galleryimages/mylocal-marketplaceimage",
          "location": "eastus",
          "name": "mylocal-marketplaceimage",
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
          "resourceGroup": "mylocal-rg",
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
        ```

    - **Method 2: Using name and resource group**

        Here's an example using name and resource group

        ```azurecli
        az stack-hci-vm image show --name $mktplaceImage --resource-group $resource_group
        ```

        Here's a sample output:
        <!--input needed-->

### [Azure portal](#tab/azureportal)

Follow these steps to view image properties in the Azure portal:

1. In the Azure portal, navigate to your Azure Local resource.

1. Go to **Resources** > **VM images**. The right pane displays a list of VM images.

   :::image type="content" source="../manage/media/manage-vm-resources/vm-images-list.png" alt-text="Screenshot of list of images." lightbox="../manage/media/manage-vm-resources/vm-images-list.png":::

1. Select the VM **Image name** to view the properties.

   :::image type="content" source="../manage/media/manage-vm-resources/vm-image-properties.png" alt-text="Screenshot of the properties of a selected VM image." lightbox="../manage/media/manage-vm-resources/vm-image-properties.png":::

---

## Delete VM image

Remove VM images that are no longer needed or if the download failed during creation.

### [Azure CLI](#tab/azurecli)

Follow these steps to delete a VM image using Azure CLI:

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

You can delete images using either:

- Name and resource group
- Image ID

After you've deleted an image, you can check that the image is removed.

Here's a sample output showing deletion by name and resource group:

```azurecli
PS C:\Users\azcli> $subscription = "<Subscription ID>"
PS C:\Users\azcli> $resource_group = "mylocal-rg"
PS C:\Users\azcli> $mktplaceImage = "mymylocal-marketplaceimage"
PS C:\Users\azcli> az stack-hci-vm image delete --name $mktplaceImage --resource-group $resource_group
    
Are you sure you want to perform this operation? (y/n): y
PS C:\Users\azcli> az stack-hci-vm image show --name $mktplaceImage --resource-group $resource_group
    
ResourceNotFound: The Resource 'Microsoft.AzureStackHCI/marketplacegalleryimages/myhci-marketplaceimage' under resource group 'mylocal-rg' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix
```

### [Azure portal](#tab/azureportal)

Follow these steps to delete a VM image in the Azure portal:

1. In the Azure portal, navigate to your Azure Local resource.

1. Go to **Resources** > **VM images**.

1. Locate the VM image you want to delete in the right pane.

1. Select the trash can icon next to the VM image.

   :::image type="content" source="../manage/media/manage-vm-resources/delete-vm-image.png" alt-text="Screenshot of the trash can icon against the VM image you want to delete." lightbox="../manage/media/manage-vm-resources/delete-vm-image.png":::

1. When prompted to confirm deletion, select **Yes**.

   :::image type="content" source="../manage/media/manage-vm-resources/prompt-to-confirm-deletion.png" alt-text="Screenshot of a prompt to confirm deletion." lightbox="../manage/media/manage-vm-resources/prompt-to-confirm-deletion.png":::

  After the VM image is deleted, the list of VM images refreshes to reflect the deleted image.

---
