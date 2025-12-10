---
title: Manage Azure Local VM Images via Azure CLI and Azure Portal
description: Learn how to manage Azure Local VM images. List, view properties, update, and delete images using Azure CLI or the portal.
author: ronmiab
ms.author: robess
ms.reviewer: kimlam
ms.date: 12/09/2025
ms.topic: how-to
ms.service: azure-local
---

# Manage Azure Local VM images via CLI and the portal

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to manage Azure Local virtual machine images. Images can be from different sources such as Azure Marketplace, Azure Compute Gallery, Azure Storage accounts, local shares, and existing Azure Local VMs. You can list, view properties, update, and delete VMs using Azure CLI or the Azure portal.

## List VM images

You need to view the list of VM images to choose an image to manage.

### [Azure CLI](#tab/azurecli)

Follow these steps to list VM image using Azure CLI.

1. Run PowerShell as an administrator.

1. Set some parameters.

    ```azurecli
    $subscription = "<Subscription ID associated with your Azure Local>"
    $resource_group = "<Resource group name for your Azure Local>"
    ```

1. List all the VM images associated with your Azure Local. Run the following command:

    ```azurecli
    az stack-hci-vm image list --subscription $subscription --resource-group $resource_group
    ```

    Depending on the command used, a corresponding set of images associated with your Azure Local are listed.

    - If you specify just the subscription, the command lists all the images in the subscription.

    - If you specify both the subscription and the resource group, the command lists all the images in the resource group.

    These images include:

    - VM images from marketplace images.

    - Custom images that reside in your Azure Storage account or are in a local share on your system or a client connected to your system.

    Here's a sample output.

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

In the Azure portal of your Azure Local resource, you can track the VM image deployment on the VM image grid. You can see the list of the VM images that are already downloaded and the ones that are being downloaded on your system.

Follow these steps to view the list of VM images in Azure portal.

1. In the Azure portal, go to your Azure Local resource.

1. Go to **Resources > VM images**.

1. In the right-pane, you can view the list of the VM images.

    :::image type="content" source="../manage/media/manage-vm-resources/list-virtual-machine-images.png" alt-text="Screenshot of the list of VM images on your Azure Local." lightbox="../manage/media/manage-vm-resources/list-virtual-machine-images.png":::

---

## View VM image properties

You might want to view the properties of VM images before you use the image to create a VM. Follow these steps to view the image properties:

### [Azure CLI](#tab/azurecli)

Follow these steps to use Azure CLI to view properties of an image:

1. Run PowerShell as an administrator.

1. Set the following parameters.

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Azure Local resource group>"
    $mktplaceImage = "<Marketplace image name>"
    ```

1. You can view image properties in two different ways: specify ID or specify name and resource group. Take the following steps when specifying Marketplace image ID:

    1. Set the following parameter.

        ```azurecli
        $mktplaceImageID = "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/galleryimages/mylocal-marketplaceimage"
        ```

    1. Run the following command to view the properties.

        ```azurecli
        az stack-hci-vm image show --ids $mktplaceImageID
        ```

        Here's a sample output for this command:

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

### [Azure portal](#tab/azureportal)

In the Azure portal of your Azure Local resource, perform the following steps:

1. Go to **Resources** > **VM images**. In the right-pane, a list of VM images is displayed.

   :::image type="content" source="../manage/media/manage-vm-resources/vm-images-list.png" alt-text="Screenshot of list of images." lightbox="../manage/media/manage-vm-resources/vm-images-list.png":::

1. Select the VM **Image name** to view the properties.

   :::image type="content" source="../manage/media/manage-vm-resources/vm-image-properties.png" alt-text="Screenshot of the properties of a selected VM image." lightbox="../manage/media/manage-vm-resources/vm-image-properties.png":::

---

## Delete VM image

You might want to delete a VM image if the download fails for some reason or if you no longer need the image. Follow these steps to delete the VM images.

### [Azure CLI](#tab/azurecli)

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

    Here's a sample output for this command:

    ```azurecli
    PS C:\Users\azcli> $subscription = "<Subscription ID>"
    PS C:\Users\azcli> $resource_group = "mylocal-rg"
    PS C:\Users\azcli> $mktplaceImage = "mymylocal-marketplaceimage"
    PS C:\Users\azcli> az stack-hci-vm image delete --name $mktplaceImage --resource-group $resource_group
    
    Are you sure you want to perform this operation? (y/n): y
    PS C:\Users\azcli> az stack-hci-vm image show --name $mktplaceImage --resource-group $resource_group
    
    ResourceNotFound: The Resource 'Microsoft.AzureStackHCI/marketplacegalleryimages/myhci-marketplaceimage' under resource group 'mylocal-rg' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix
    PS C:\Users\azcli>
    ```

### [Azure portal](#tab/azureportal)

In the Azure portal of your Azure Local resource, perform the following steps:

1. Go to **Resources** > **VM images**.

1. From the list of VM images displayed in the right-pane, select the trash can icon next to the VM image you want to delete.

   :::image type="content" source="../manage/media/manage-vm-resources/delete-vm-image.png" alt-text="Screenshot of the trash can icon against the VM image you want to delete." lightbox="../manage/media/manage-vm-resources/delete-vm-image.png":::

1. When prompted to confirm deletion, select **Yes**.

   :::image type="content" source="../manage/media/manage-vm-resources/prompt-to-confirm-deletion.png" alt-text="Screenshot of a prompt to confirm deletion." lightbox="../manage/media/manage-vm-resources/prompt-to-confirm-deletion.png":::

After the VM image is deleted, the list of VM images refreshes to reflect the deleted image.

---
