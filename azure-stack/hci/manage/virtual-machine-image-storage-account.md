---
title: Create Azure Stack HCI VM from images in Azure Storage account (preview)
description: Learn how to create Azure Stack HCI VM images using source images from Azure Storage account via Azure portal and Azure CLI (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/05/2022
---

# Create Azure Stack HCI VM image using image in Azure Storage account (preview)

> Applies to: Azure Stack HCI, versions 22H2 and 21H2

This article describes how to create virtual machine (VM) images for your Azure Stack HCI using source images from Azure Marketplace. You can create VM images using the Azure portal or Azure CLI and then use these VM images to create Arc VMs on your Azure Stack HCI.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-image-prerequisites-storage-account](../../includes/hci-vm-image-prerequisites-storage-account.md)]

- Access to a client that can connect to your Azure Stack HCI cluster. This client should be:

    - Running PowerShell 5.0 or later.
    - Running the latest version of `az` CLI.
        - [Download the latest version of `az` CLI](/cli/azure/install-azure-cli-windows?tabs=azure-cli). Once you have installed `az` CLI, make sure to restart the system.
        -  If you have an older version of `az` CLI running, make sure to uninstall the older version first.

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-vm-image-prerequisites-storage-account](../../includes/hci-vm-image-prerequisites-storage-account.md)]

---


## Add VM image from Azure Storage account

You'll create a VM image starting from an image in Azure Storage account and then use this image to deploy VMs on your Azure Stack HCI cluster.

# [Azure CLI](#tab/azurecli)

Follow these steps to create a VM image using the Azure CLI.

### Set some parameters

Set your subscription, resource group, location, path to the image in local share, and OS type for the image. Replace the parameters in `< >` with the appropriate values.

```azurecli
$Subscription = "<Subscription ID>"
$Resource_Group = "<Resource group>"
$Location = "<Location for your Azure Stack HCI cluster>"
$OsType = "<OS of source image>"
$ImageName = "<VM image name>"
$ImageSourcePath = "<path to the source image in the Storage account>"

```

The parameters are described in the following table:

| Parameter        | Description                                                                                |
|------------------|--------------------------------------------------------------------------------------------|
| `Subscription`   | Resource group for Azure Stack HCI cluster that you'll associate with this image.        |
| `Resource_Group` | Resource group for Azure Stack HCI cluster that you'll associate with this image.        |
| `Location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`, `eastus2euap`. |
| `ImageName`      | Name of the VM image created starting with the image in your local share. <br> **Note**: Azure rejects all the names that contain the keyword Windows. |
| `ImageSourcePath`| Path to the Blob SAS URL of the image in the Storage account. For more information, see instructions on how to [Get a blob SAS URL of the image in the Storage account](/azure/applied-ai-services/form-recognizer/create-sas-tokens#use-the-azure-portal). <br> **Note**: Make sure that all the Ampersands in the path are escaped with double quotes and the entire path string is wrapped within single quotes. If your container that has the image has anonymous read access, then you can specify the blob URL (select the blob URL and right click to view the properties and then copy blob URL).|
| `OsType`         | Operating system associated with the source image. This can be Windows or Linux.           |

Here's a sample output:

```
PS C:\Users\azcli> $Subscription = "<Subscription ID>"
PS C:\Users\azcli> $Resource_Group = "mkclus90-rg"
PS C:\Users\azcli> $Location = "eastus2euap"
PS C:\Users\azcli> $OsType = "Windows"
PS C:\Users\azcli> $ImageName = "mktplace8"
PS C:\Users\azcli> $ImageSourcePath = 'https://vmimagevhdsa1.blob.core.windows.net/vhdcontainer/Windows_InsiderPreview_ServerStandard_en-us_VHDX_25131.vhdx?sp=r"&"st=2022-08-05T18:41:41Z"&"se=2022-08-06T02:41:41Z"&"spr=https"&"sv=2021-06-08"&"sr=b"&"sig=X7A98cQm%2FmNRaHmTbs9b4OWVv%2F9Q%2FJkWDBHVPyAc8jo%3D'
```

### Create VM image from image in Azure Storage account

1. Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Stack HCI cluster. Get the custom location ID for your Azure Stack HCI cluster. Run the following command:

    ```azurecli
    $customLocationID=(az customlocation show --resource-group $resource_group --name "<custom location name for HCI cluster>" --query id -o tsv)
    ```
1. Create the VM image starting with a specified marketplace image. Make sure to specify the offer, publisher, sku and version for the marketplace image.

    ```azurecli
    az azurestackhci image create --subscription $Subscription --resource-group $Resource_Group --extended-location name=$customLocationID type="CustomLocation" --location $Location --name $ImageName --os-type $OsType --image-path $ImageSourcePath"
    ```
A deployment job starts for the VM image. The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the image in Azure Storage account and the network bandwidth available for the download.

Here's a sample output:

```
PS > $customLocationID=(az customlocation show --resource-group $resource_group --name "cl04" --query id -o tsv)
PS C:\Users\azcli> az azurestackhci image create --subscription $subscription --resource-group $resource_group --extended-location name=$customLocationID type="CustomLocation" --location $Location --name $ImageName --os-type $osType --image-path $ImageSourcePath
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

# [Azure portal](#tab/azureportal)

Follow these steps to create a VM image using the Azure portal. In the [Azure preview portal](https://aka.ms/edgevmmgmt) of your Azure Stack HCI cluster resource, take the following steps:

1. Go to **Resources** > **VM images**.

1. Select **+ Add VM Image** and from the dropdown list, select **Add VM image from Azure Storage Account**.

   :::image type="content" source="./media/manage-vm-resources/add-image-from-azure-storage-account.png" alt-text="Screenshot showing Add VM image from Azure Marketplace option." lightbox="./media/manage-vm-resources/add-image-from-azure-storage-account.png":::

1. In the **Create an image** page, on the **Basics** tab, input the following information:

    1. **Subscription** Select a subscription to associate with your VM image.

    1. **Resource group** Create new or select an existing resource group that you'll associate with the VM image.
    
    1. **Save image as** Enter a name for your VM image.

    1. **Custom location** Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Stack HCI cluster.

    1. **Image to download** Select a VM image from the list of images in Azure Marketplace. The dropdown list shows all the Azure Marketplace images that are compatible with your Azure Stack HCI cluster.

    1. **OS type** Select the OS of the image as Windows or Linux. This is the OS associated with the image in your Storage account.
    
    1. **VM generation.** Select the Generation of the image.

    1. **Source.** The source of the image should be Storage blobs and is automatically populated.

    1. **Storage blob.** Specify the Azure Storage account path for the source image on your HCI cluster.

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

You may want to view the properties of VM images before you use the image to create a VM. Follow these steps to view the image properties:

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../../includes/hci-view-vm-image-properties-azure-cli.md)]

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-view-vm-image-properties-portal](../../includes/hci-view-vm-image-properties-portal.md)]

---


## Delete VM image

You may want to delete a VM image if the download fails for some reason or if the image is no longer needed. Follow these steps to delete the VM images.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../../includes/hci-view-vm-image-properties-azure-cli.md)]

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-delete-vm-image-portal](../../includes/hci-delete-vm-image-portal.md)]

---

## Next steps

- [Create virtual networks](./create-virtual-networks.md)