---
title: Create Azure Stack HCI VM from local share images via Azure CLI
description: Learn how to create Azure Stack HCI VM images using source images from a local share on your cluster.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/05/2022
---

# Create Azure Stack HCI VM image using images in a local share (preview)

> Applies to: Azure Stack HCI, version 22H2; Azure Stack HCI, version 21H2

This article describes how to create virtual machine (VM) images for your Azure Stack HCI using source images from a local share on your cluster. You can create VM images using the Azure portal or Azure CLI and then use these VM images to create Arc VMs on your Azure Stack HCI.

> [!IMPORTANT]
> The Azure Marketplace on Azure Stack HCI is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) before you deploy this solution.

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-image-prerequisites-local-share](../../includes/hci-vm-image-prerequisites-local-share.md)]

- Access to a client that can connect to your Azure Stack HCI cluster. This client should be:

    - Running PowerShell 5.0 or later.
    - Running the latest version of `az` CLI.
        - [Download the latest version of `az` CLI](/cli/azure/install-azure-cli-windows?tabs=azure-cli). Once you have installed `az` CLI, make sure to restart the system.
        -  If you have an older version of `az` CLI running, make sure to uninstall the older version first.

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-vm-image-prerequisites-local-share](../../includes/hci-vm-image-prerequisites-local-share.md)]
---


## Add VM image from image in local share

You'll create a VM image starting from an image in a local share of your cluster and then use this image to deploy VMs on your Azure Stack HCI cluster.

# [Azure CLI](#tab/azurecli)

Follow these steps to create a VM image using the Azure CLI.

### Set some parameters

Set your subscription, resource group, location, OS type for the image. Replace the parameters in `< >` with the appropriate values.

```azurecli
$Subscription = "<Subscription ID>"
$Resource_Group = "<Resource group>"
$Location = "<Location for your Azure Stack HCI cluster>"
$ImageName = <VM image name>
$ImageSourcePath = <path to the source image>
$OsType = "<OS of source image>"
```

The parameters are described in the following table:

| Parameter      | Description                                                                                |
|----------------|--------------------------------------------------------------------------------------------|
| `Subscription`   | Resource group for Azure Stack HCI cluster that you'll associate with this image.        |
| `Resource_Group` | Resource group for Azure Stack HCI cluster that you'll associate with this image.        |
| `Location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`, `eastus2euap`. |
| `ImageName`      | Name of the VM image created starting with the image in your local share. <br> **Note**: Azure rejects all the names that contain the keyword Windows. |
| `ImageSourcePath`| Path to the source gallery image (VHDX only) on your cluster. For example, *C:\OSImages\winos.vhdx*. See the prerequisites of the source image.|
| `OsType`         | Operating system associated with the source image. This can be Windows or Linux.           |

Here's a sample output:

```
PS C:\Users\azcli> $subscription = "<Subscription ID>"
PS C:\Users\azcli> $resource_group = "mkclus90-rg"
PS C:\Users\azcli> $location = "eastus2euap"
PS C:\Users\azcli> $osType = "Windows"
PS C:\ClusterStorage\Volume1> $ImageName = "winostest"
PS C:\ClusterStorage\Volume1> $ImageSourcePath = "C:\ClusterStorage\Volume1\Windows_K8s_17763.2928.220505-1621_202205101158.vhdx"
```

### Create VM image from image in local share

1. Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Stack HCI cluster. Get the custom location ID for your Azure Stack HCI cluster. Run the following command:

    ```azurecli
    $customLocationID=(az customlocation show --resource-group $resource_group --name "<custom location name for HCI cluster>" --query id -o tsv)
    ```
1. Create the VM image starting with a specified image in a local share on your Azure Stack HCI cluster.

    ```azurecli
    az azurestackhci galleryimage create --subscription $subscription --resource-group $resource_group --extended-location name=$customLocationID type="CustomLocation" --location $Location --image-path $galleryImageSourcePath --name $galleryImageName --os-type $osType
    ```
A deployment job starts for the VM image. The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the image in the local share and the network bandwidth available for the download.

Here's a sample output:

```
PS C:\Users\azcli> $customLocationID=(az customlocation show --resource-group $resource_group --name "cl04" --query id -o tsv)
PS C:\Users\azcli> az azurestackhci image create --subscription $subscription --resource-group $resource_group --extended-location name=$customLocationID type="CustomLocation" --location $Location --name $mktplaceImage --os-type $osType --image-path $mktImageSourcePath
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

You can create a VM image by downloading an image that resides in a local share on your Azure Stack HCI cluster and then use that VM image to deploy a virtual machine.

In the Azure portal of your Azure Stack HCI cluster resource, perform the following steps:

1. Go to **Resources** > **VM images**.

1. Select **+ Add VM Image** and from the dropdown list, select **Add VM image from a local share**.

   :::image type="content" source="./media/manage-vm-resources/add-vm-from-local-share.png" alt-text="Screenshot showing Add VM image from a local share option." lightbox="./media/manage-vm-resources/add-vm-from-local-share.png":::

1. In the **Create an image** page, on the **Basics** tab, input the following information:

    1. **Subscription.** Select a subscription to associate with your VM image.

    1. **Resource group.** Create new or select an existing resource group that you'll associate with the VM image.

    1. **Save image as.** Enter a name for your VM image.

    1. **Custom location.** Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Stack HCI cluster.

    1. **OS type.** Select the OS of the image as Windows or Linux. This is the OS associated with the image in your Storage account.

    1. **VM generation.** Select the generation for your image.

    1. **Source.** The source of the image should be **Local file share** and is automatically populated.

    1. **Local file share path.** Specify the local share path for the source image on your HCI cluster.

1. Select **Review + Create** to create your VM image.

   :::image type="content" source="./media/manage-vm-resources/create-an-image-from-local-share.png" alt-text="Screenshot of the Create an image page showing the fields in the Basics tab." lightbox="./media/manage-vm-resources/create-an-image-from-local-share.png":::

1. The input parameters are validated. If the validations succeed, you can review the VM image details and select **Create**.

   :::image type="content" source="./media/manage-vm-resources/create-an-image-create-button.png" alt-text="Screenshot of the Create an image page with the Create button highlighted." lightbox="./media/manage-vm-resources/create-an-image-create-button.png":::

   An Azure Resource Manager template deployment job starts for the VM image. The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the custom image and the network bandwidth available for the download.

   You can track the image deployment on the VM image grid. You can see the list of the VM images that are already downloaded and the ones that are being downloaded on the cluster.

1. When the image download is complete, the VM image shows up in the list of images and the **Status** shows as **Available**. To view more details of any image, select the VM image name from the list of VM images.

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

Use VM images to [Create Arc VMs](./manage-virtual-machines-in-azure-portal.md).
