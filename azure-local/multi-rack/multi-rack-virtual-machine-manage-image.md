---
title: Manage VM images for Azure Local multi-rack VMs enabled by Azure Arc (preview)
description: Learn how to list, view properties, and delete virtual machine images on Azure Local multi-rack deployments using Azure CLI or Azure portal.
author: dramasamy
ms.author: dramasamy
ms.reviewer: kimlam
ms.date: 04/15/2026
ms.topic: how-to
ms.service: azure-local
ms.subservice: multi-rack
---

# Manage VM images for Azure Local multi-rack VMs enabled by Azure Arc (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to manage virtual machine (VM) images on your Azure Local multi-rack instance. You can create VM images from an Azure Storage account. After you create images, you can list, view properties, and delete them using Azure CLI or the Azure portal.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you have:

- Access to an Azure Local VM image created via [Azure Storage account](./multi-rack-virtual-machine-image-storage-account.md).

## List VM images

To identify which images on your Azure Local multi-rack instance are available for VM management, you can view the complete list of VM images.

### [Azure CLI](#tab/azurecli)

To list VM images using Azure CLI, follow these steps:

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

The results include custom images that are in your Azure Storage account.

Here's a sample output:

```console
PS C:\Users\azcli> az stack-hci-vm image list --subscription "<Subscription ID>" --resource-group "<Resource group>"
Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
[
  {
    "extendedLocation": {
      "name": "/subscriptions/<subscription ID>/resourcegroups/<resource group>/providers/microsoft.extendedlocation/customlocations/<custom location>",
      "type": "CustomLocation"
    },
    "id": "/subscriptions/<subscription ID>/resourceGroups/<resource group>/providers/Microsoft.AzureStackHCI/galleryimages/mylocal-storacctimage",
    "location": "eastus",
    "name": "mylocal-storacctimage",
    "properties": {
      "osType": "Windows",
      "provisioningState": "Succeeded",
      "status": {
        "downloadStatus": {
          "downloadSizeInMB": 7876
        },
        "progressPercentage": 100,
        "provisioningStatus": {
          "operationId": "<operation ID>",
          "status": "Succeeded"
        }
      },
    },
    "resourceGroup": "mylocal-rg",
    "systemData": {
      "createdAt": "2023-11-03T20:17:10.971662+00:00",
      "createdBy": "guspinto@contoso.com",
      "createdByType": "User",
      "lastModifiedAt": "2023-11-03T21:08:01.190475+00:00",
      "lastModifiedBy": "bbbbbbbb-1111-2222-3333-cccccccccccc",
      "lastModifiedByType": "Application"
    },
    "tags": null,
    "type": "microsoft.azurestackhci/galleryimages"
  }
]
```

For more information on this CLI command, see [az stack-hci-vm image list](/cli/azure/stack-hci-vm/image#az-stack-hci-vm-image-list).

### [Azure portal](#tab/azureportal)

To view the list of VM images in Azure portal, follow these steps.

1. In the Azure portal, navigate to your Azure Local resource.

1. Go to **Resources > VM images**.

1. The right pane displays the list of VM images, including:
   - Images currently downloaded
   - Images being downloaded
   - Download status and progress

:::image type="content" source="../manage/media/virtual-machine-manage-images/list-virtual-machine-images.png" alt-text="Screenshot of the list of VM images on your Azure Local." lightbox="../manage/media/virtual-machine-manage-images/list-virtual-machine-images.png":::

---

## View VM image properties

Review detailed properties of a VM image before using it to create virtual machines.

### [Azure CLI](#tab/azurecli)

To view image properties using Azure CLI, follow these steps:

1. Run PowerShell as an administrator.

1. Set the following parameters.

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Azure Local resource group>"
    $imageName = "<Image name>"
    ```

1. View image properties using one of two methods: image ID or name and resource group.

    - **Method 1: Using image ID**

        Set the image ID parameter:

        ```azurecli
        $imageID = "/subscriptions/<subscription ID>/resourceGroups/<resource group>/providers/Microsoft.AzureStackHCI/galleryimages/mylocal-storacctimage"
        ```

        Run the command:

        ```azurecli
        az stack-hci-vm image show --ids $imageID
        ```

        Here's a sample output:

        ```console
        PS C:\Users\azcli> az stack-hci-vm image show --ids $imageID
        Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
        {
          "extendedLocation": {
            "name": "/subscriptions/<subscription ID>/resourcegroups/<resource group>/providers/microsoft.extendedlocation/customlocations/<custom location>",
            "type": "CustomLocation"
          },
          "id": "/subscriptions/<subscription ID>/resourceGroups/<resource group>/providers/Microsoft.AzureStackHCI/galleryimages/mylocal-storacctimage",
          "location": "eastus",
          "name": "mylocal-storacctimage",
          "properties": {
            "osType": "Windows",
            "provisioningState": "Succeeded",
            "status": null
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

        Run the command:

        ```azurecli
        az stack-hci-vm image show --name $imageName --resource-group $resource_group
        ```

### [Azure portal](#tab/azureportal)

To view image properties in the Azure portal, follow these steps:

1. In the Azure portal, navigate to your Azure Local resource.

1. Go to **Resources** > **VM images**. The right pane displays a list of VM images.

1. Select the VM **Image name** to view the properties.

   :::image type="content" source="../manage/media/virtual-machine-manage-images/marketplace-image-overview.png" alt-text="Screenshot of gallery image properties." lightbox="../manage/media/virtual-machine-manage-images/marketplace-image-overview.png":::

---

## Delete VM image

Remove VM images that are no longer needed or if the download failed during creation.

### [Azure CLI](#tab/azurecli)

To delete a VM image using Azure CLI, follow these steps:

1. Run PowerShell as an administrator.

1. Set the following parameters:

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Azure Local resource group>"
    $imageName = "<Image name>"
    ```

1. Remove an existing VM image. Run the following command:

    ```azurecli
    az stack-hci-vm image delete --subscription $subscription --resource-group $resource_group --name $imageName --yes
    ```

You can delete images using either:

- Name and resource group
- Image ID

After you delete an image, you can check that the image is removed.

Here's a sample output showing deletion by name and resource group:

```console
PS C:\Users\azcli> $subscription = "<Subscription ID>"
PS C:\Users\azcli> $resource_group = "<Resource group>"
PS C:\Users\azcli> $imageName = "mylocal-storacctimage"
PS C:\Users\azcli> az stack-hci-vm image delete --name $imageName --resource-group $resource_group

Are you sure you want to perform this operation? (y/n): y
PS C:\Users\azcli> az stack-hci-vm image show --name $imageName --resource-group $resource_group

ResourceNotFound: The Resource 'Microsoft.AzureStackHCI/galleryimages/mylocal-storacctimage' under resource group '<resource group>' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix
```

### [Azure portal](#tab/azureportal)

To delete a VM image in the Azure portal, follow these steps:

1. In the Azure portal, navigate to your Azure Local resource.

1. Go to **Resources** > **VM images**.

1. Locate the VM image you want to delete in the right pane.

1. Select the trash can icon next to the VM image.

   :::image type="content" source="../manage/media/virtual-machine-manage-images/delete-virtual-machine-image.png" alt-text="Screenshot of the trash can icon against the VM image you want to delete." lightbox="../manage/media/virtual-machine-manage-images/delete-virtual-machine-image.png":::

1. When prompted to confirm deletion, select **Yes**.

   :::image type="content" source="../manage/media/virtual-machine-manage-images/prompt-to-confirm-deletion.png" alt-text="Screenshot of a prompt to confirm deletion." lightbox="../manage/media/virtual-machine-manage-images/prompt-to-confirm-deletion.png":::

  After the VM image is deleted, the list of VM images refreshes to reflect the deleted image.

---

## Next steps

- [Create logical networks](./multi-rack-create-logical-networks.md).
