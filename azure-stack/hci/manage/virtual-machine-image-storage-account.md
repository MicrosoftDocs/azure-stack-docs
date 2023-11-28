---
title: Create Azure Stack HCI VM from images in Azure Storage account (preview)
description: Learn how to create Azure Stack HCI VM images using source images from Azure Storage account via Azure portal and Azure CLI (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom:
  - devx-track-azurecli
ms.date: 11/20/2023
---

# Create Azure Stack HCI VM image using image in Azure Storage account (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to create virtual machine (VM) images for your Azure Stack HCI using source images from Azure Storage account. You can create VM images using the Azure portal or Azure CLI and then use these VM images to create Arc VMs on your Azure Stack HCI.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-image-prerequisites-storage-account](../../includes/hci-vm-image-prerequisites-storage-account.md)]

- If using a client to connect to your Azure Stack HCI cluster, see [Connect to Azure Stack HCI via Azure CLI client](./azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements).

- Make sure that you have **Storage Blob Data Contributor** role on the Storage account that you use for the image. For more information, see [Assign an Azure role for access to blob data](/azure/role-based-access-control/role-assignments-portal?tabs=current).

- Make sure that you're uploading your VHD or VHDX as a page blob image into the Storage account. Only page blob images are supported to create VM images via the Storage account.

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-vm-image-prerequisites-storage-account](../../includes/hci-vm-image-prerequisites-storage-account.md)]

---


## Add VM image from Azure Storage account

You create a VM image starting from an image in Azure Storage account and then use this image to deploy VMs on your Azure Stack HCI cluster.

# [Azure CLI](#tab/azurecli)

Follow these steps to create a VM image using the Azure CLI.

### Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../../includes/hci-vm-sign-in-set-subscription.md)]

### Set some parameters

1. Set your subscription, resource group, location, path to the image in local share, and OS type for the image. Replace the parameters in `< >` with the appropriate values.

```azurecli
$subscription = "<Subscription ID>"
$resource_group = "<Resource group>"
$location = "<Location for your Azure Stack HCI cluster>"
$osType = "<OS of source image>"
$imageName = "<VM image name>"
$imageSourcePath = "<path to the source image in the Storage account>"

```

The parameters are described in the following table:

| Parameter        | Description                                                                                |
|------------------|--------------------------------------------------------------------------------------------|
| `subscription`   | Resource group for Azure Stack HCI cluster that you associate with this image.        |
| `resource_group` | Resource group for Azure Stack HCI cluster that you associate with this image.        |
| `location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`. |
| `imageName`      | Name of the VM image created starting with the image in your local share. <br> **Note**: Azure rejects all the names that contain the keyword Windows. |
| `imageSourcePath`| Path to the Blob SAS URL of the image in the Storage account. For more information, see instructions on how to [Get a blob SAS URL of the image in the Storage account](/azure/applied-ai-services/form-recognizer/create-sas-tokens#use-the-azure-portal). <br> **Note**: Make sure that all the Ampersands in the path are escaped with double quotes and the entire path string is wrapped within single quotes. |
| `os-type`         | Operating system associated with the source image. This can be Windows or Linux.           |

Here's a sample output:

```
PS C:\Users\azcli> $subscription = "<Subscription ID>"
PS C:\Users\azcli> $resource_group = "myhci-rg"
PS C:\Users\azcli> $location = "eastus"
PS C:\Users\azcli> $osType = "Windows"
PS C:\Users\azcli> $imageName = "myhci-storacctimage"
PS C:\Users\azcli> $imageSourcePath = 'https://vmimagevhdsa1.blob.core.windows.net/vhdcontainer/Windows_InsiderPreview_ServerStandard_en-us_VHDX_25131.vhdx?sp=r"&"st=2022-08-05T18:41:41Z"&"se=2022-08-06T02:41:41Z"&"spr=https"&"sv=2021-06-08"&"sr=b"&"sig=X7A98cQm%2FmNRaHmTbs9b4OWVv%2F9Q%2FJkWDBHVPyAc8jo%3D'
```

### Create VM image from image in Azure Storage account

1. Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Stack HCI cluster. Get the custom location ID for your Azure Stack HCI cluster. Run the following command:

    ```azurecli
    $customLocationID=(az customlocation show --resource-group $resource_group --name "<custom location name for HCI cluster>" --query id -o tsv)
    ```
1. Create the VM image starting with a specified marketplace image. Make sure to specify the offer, publisher, sku and version for the marketplace image.

    ```azurecli
    az stack-hci-vm image create --subscription $subscription --resource-group $resource_Group --custom-location $customLocationID --location $location --name $imageName --os-type $osType --image-path $imageSourcePath --storage-path-id $storagepathid
    ```
    A deployment job starts for the VM image. 

    In this example, the storage path was specified using the `--storage-path-id` flag and that ensured that the workload data (including the VM, VM image, non-OS data disk) is placed in the specified storage path.

    If the flag is not specified, the workload data is automatically placed in a high availability storage path.

The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the image in Azure Storage account and the network bandwidth available for the download.

Here's a sample output:

```
PS > $customLocationID=(az customlocation show --resource-group $resource_group --name "myhci-cl" --query id -o tsv)
PS C:\Users\azcli> az stack-hci-vm image create --subscription $subscription --resource-group $resource_Group --custom-location $customLocationID --location $location --name $imageName --os-type $osType --image-path $imageSourcePath --storage-path-id $storagepathid
Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
{
  "extendedLocation": {
    "name": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.ExtendedLocation/customLocations/myhci-cl",
    "type": "CustomLocation"
  },
  "id": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/galleryimages/myhci-storacctimage",
  "location": "eastus",
  "name": "windos",
  "properties": {
    "identifier": null,
    "imagePath": null,
    "osType": "Windows",
    "provisioningState": "Succeeded",
    "status": {
      "downloadStatus": {
        "downloadSizeInMB": 7876
      },
        "progressPercentage": 100,
      "provisioningStatus": {
        "operationId": "cdc9c9a8-03a1-4fb6-8738-7a8550c87fd1*31CE1EA001C4B3E38EE29B78ED1FD47CCCECF78B4CEA9E9A85C0BAEA5F6D80CA",
        "status": "Succeeded"
      }
    },
    "storagepathId": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/storagecontainers/myhci-storagepath",
    "version": null
  },
  "resourceGroup": "myhci-rg",
  "systemData": {
    "createdAt": "2023-11-03T20:17:10.971662+00:00",
    "createdBy": "guspinto@contoso.com",
    "createdByType": "User",
    "lastModifiedAt": "2023-11-03T21:08:01.190475+00:00",
    "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
    "lastModifiedByType": "Application"
  },
  "tags": null,
  "type": "microsoft.azurestackhci/galleryimages"
}
PS C:\Users\azcli>
```

# [Azure portal](#tab/azureportal)

Follow these steps to create a VM image using the Azure portal. In the [Azure preview portal](https://aka.ms/edgevmmgmt) of your Azure Stack HCI cluster resource, take the following steps:

1. Go to **Resources** > **VM images**.

1. Select **+ Add VM Image** and from the dropdown list, select **Add VM image from Azure Storage Account**.

   :::image type="content" source="./media/manage-vm-resources/add-image-from-azure-storage-account.png" alt-text="Screenshot showing Add VM image from Azure Marketplace option." lightbox="./media/manage-vm-resources/add-image-from-azure-storage-account.png":::

1. In the **Create an image** page, on the **Basics** tab, input the following information:

    1. **Subscription** Select a subscription to associate with your VM image.

    1. **Resource group** Create new or select an existing resource group that you associate with the VM image.
    
    1. **Save image as** Enter a name for your VM image.

    1. **Custom location** Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Stack HCI cluster.

    1. **Image to download** Select a VM image from the list of images in Azure Marketplace. The dropdown list shows all the Azure Marketplace images that are compatible with your Azure Stack HCI cluster.

    1. **OS type** Select the OS of the image as Windows or Linux. This is the OS associated with the image in your Storage account.
    
    1. **VM generation.** Select the Generation of the image.

    1. **Source.** The source of the image should be Storage blobs and is automatically populated.

    1. **Storage blob.** Specify the Azure Storage account path for the source image on your HCI cluster.

    1. **Storage path.** Select the storage path for your VM image.

1. Select **Review + Create** to create your VM image.

   :::image type="content" source="./media/manage-vm-resources/create-an-image-storage-account-review-create.png" alt-text="Screenshot of the Create an Image page highlighting the Review + Create button." lightbox="./media/manage-vm-resources/create-an-image-storage-account-create.png":::

1. The input parameters are validated. If the validations succeed, you can review the VM image details and select **Create**.
        
   :::image type="content" source="./media/manage-vm-resources/create-an-image-create.png" alt-text="Screenshot of the Create an Image page highlighting the Create button." lightbox="./media/manage-vm-resources/create-an-image-create.png":::
    
1. An Azure Resource Manager template deployment job starts for the VM image. The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the Marketplace image and the network bandwidth available for the download.

   :::image type="content" source="./media/manage-vm-resources/deployment-in-progress.png" alt-text="Screenshot showing deployment is in progress." lightbox="./media/manage-vm-resources/deployment-in-progress.png":::

   You can track the image deployment on the VM image grid. You can see the list of the VM images that are already downloaded and the ones that are being downloaded on the cluster.

   To view more details of any image, select the VM image name from the list of VM images.

1. When the image download is complete, the VM image shows up in the list of images, and the **Status** shows as **Available**.

   :::image type="content" source="./media/manage-vm-resources/added-vm-image.png" alt-text="Screenshot showing the newly added VM image in the list of images." lightbox="./media/manage-vm-resources/added-vm-image.png":::

   If the download of the VM image fails, the error details are shown in the portal blade.

   :::image type="content" source="./media/manage-vm-resources/failed-deployment.png" alt-text="Screenshot showing an error when the download of VM image fails." lightbox="./media/manage-vm-resources/failed-deployment.png":::

---

## List VM images

You need to view the list of VM images to choose an image to manage.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-list-vm-image-azure-cli](../../includes/hci-list-vm-image-azure-cli.md)]


# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-list-vm-image-portal](../../includes/hci-list-vm-image-portal.md)]

---

## View VM image properties

You might want to view the properties of VM images before you use the image to create a VM. Follow these steps to view the image properties:

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../../includes/hci-view-vm-image-properties-azure-cli.md)]

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-view-vm-image-properties-portal](../../includes/hci-view-vm-image-properties-portal.md)]

---


## Delete VM image

You might want to delete a VM image if the download fails for some reason or if the image is no longer needed. Follow these steps to delete the VM images.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../../includes/hci-delete-vm-image-azure-cli.md)]

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-delete-vm-image-portal](../../includes/hci-delete-vm-image-portal.md)]

---

## Next steps

- [Create logical networks](./create-virtual-networks.md)
