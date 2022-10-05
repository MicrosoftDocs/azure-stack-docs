---
title: Create Azure Stack HCI VM from Azure Marketplace images via Azure CLI
description: Learn how to create Azure Stack HCI VM images using source images from Azure Marketplace.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/26/2022
---

# Create Azure Stack HCI VM image using Azure Marketplace images (preview)

> Applies to: Azure Stack HCI versions 22H2 (preview) and 21H2

This article describes how to create virtual machine (VM) images for your Azure Stack HCI using source images from Azure Marketplace. You can create VM images using the Azure portal or Azure CLI and then use these VM images to create Arc VMs on your Azure Stack HCI.

> [!IMPORTANT]
> The Azure Marketplace on Azure Stack HCI is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) before you deploy this solution.

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-image-prerequisites-marketplace](../../includes/hci-vm-image-prerequisites-marketplace.md)]
- If you're using custom images, you'll have the following extra prerequisites depending on where the custom images are located:

    - You should have a VHD loaded in your Azure Storage account. See how to [Upload a VHD image in your Azure Storage account](/azure/databox-online/azure-stack-edge-gpu-create-virtual-machine-image?tabs=windows#copy-vhd-to-storage-account-using-azcopy). The container and the blob associated with the image must have anonymous read access if using Blob URL to specify as the image path. For more information, see how to [Change the access level for the container in your Storage account](/azure/storage/blobs/anonymous-read-access-configure?tabs=portal#set-the-public-access-level-for-a-container). If you don't want to change the container access, you'll need to use the Blob SAS URI. For more information, see how to [Get the Blob SAS URI](/azure/applied-ai-services/form-recognizer/create-sas-tokens#use-the-azure-portal).
    - You should have a VHD/VHDX uploaded to a local share on your Azure Stack HCI cluster.
    - The VHDX image must be Gen 2 type and secure boot enabled.
    - The image should reside on a Cluster Shared Volume available to all the servers in the cluster. Arc-enabled Azure Stack HCI supports Windows and Linux operating systems.

- Access to a client that can connect to your Azure Stack HCI cluster. This client should be:

    - Running PowerShell 5.0 or later.
    - Running the latest version of `az` CLI.
        - [Download the latest version of `az` CLI](/cli/azure/install-azure-cli-windows?tabs=azure-cli). Once you have installed `az` CLI, make sure to restart the system.
        -  If you have an older version of `az` CLI running, make sure to uninstall the older version first.

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-vm-image-prerequisites-marketplace](../../includes/hci-vm-image-prerequisites-marketplace.md)]
---


## Add VM image from Azure Marketplace

You'll create a VM image starting from an Azure Marketplace image and then use this image to deploy VMs on your Azure Stack HCI cluster.

# [Azure CLI](#tab/azurecli)

Follow these steps to create a VM image using the Azure CLI.

### Set some parameters

1. Run PowerShell as an administrator.


1. Sign in. Type:

    ```azurecli
    az login
    ```

1. Set your subscription.

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

1. Set parameters for your subscription, resource group, location, OS type for the image. Replace the parameters in `< >` with the appropriate values.

    ```azurecli
    $Subscription = "<Subscription ID>"
    $Resource_Group = "<Resource group>"
    $Location = "<Location for your Azure Stack HCI cluster>"
    $OsType = "<OS of source image>"
    ```
    
    The parameters are described in the following table:
    
    | Parameter      | Description                                                                                |
    |----------------|--------------------------------------------------------------------------------------------|
    | `Subscription`   | Resource group for Azure Stack HCI cluster that you'll associate with this image.        |
    | `Resource_Group` | Resource group for Azure Stack HCI cluster that you'll associate with this image.        |
    | `Location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`, `eastus2euap`. |
    | `OsType`         | Operating system associated with the source image. This can be Windows or Linux.           |

    Here's a sample output:
    
    ```
    PS C:\Users\azcli> $subscription = "<Subscription ID>"
    PS C:\Users\azcli> $resource_group = "mkclus90-rg"
    PS C:\Users\azcli> $location = "eastus2euap"
    PS C:\Users\azcli> $osType = "Windows"
    ```

### Create VM image from marketplace image

1. Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Stack HCI cluster. Get the custom location ID for your Azure Stack HCI cluster. Run the following command:

    ```azurecli
    $customLocationID=(az customlocation show --resource-group $resource_group --name "<custom location name for HCI cluster>" --query id -o tsv)
    ```
1. Create the VM image starting with a specified marketplace image. Make sure to specify the offer, publisher, sku and version for the marketplace image.

    ```azurecli
    az azurestackhci image create --subscription $subscription --resource-group $resource_group --extended-location name=$customLocationID type="CustomLocation" --location $Location --name "<VM image name>"  --os-type $osType --offer "windowsserver" --publisher "microsoftwindowsserver" --sku "2022-datacenter-azure-edition-core" --version "20348.707.220609"
    ```
A deployment job starts for the VM image. The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the Marketplace image and the network bandwidth available for the download.

Here's a sample output:

```
PS C:\Users\azcli> $customLocationID=(az customlocation show --resource-group $resource_group --name "cl04" --query id -o tsv)
PS C:\Users\azcli> $customLocationID
/subscriptions/<Subscription ID>/resourcegroups/mkclus90-rg/providers/microsoft.extendedlocation/customlocations/cl04
PS C:\Users\azcli> az azurestackhci image create --subscription $subscription --resource-group $resource_group --extended-location name=$customLocationID type="CustomLocation" --location $Location --name "marketplacetest03"  --os-type $osType --offer "<Offer>" --publisher "<Publisher>" --sku "<SKU>" --version "<Version number>"
{
 "extendedLocation": {
 "name": "/subscriptions/<Subscription ID>/resourcegroups/mkclus90-rg/providers/microsoft.extendedlocation/customlocations/cl04",
 "type": "CustomLocation"
 },
 "id": "/subscriptions/<Subscription ID>/resourceGroups/mkclus90-rg/providers/Microsoft.AzureStackHCI/marketplacegalleryimages/marketplacetest03",
 "location": "eastus2euap",
 "name": "marketplacetest03",
 "properties": {
    "containerName": null,
    "identifier": {
    "offer": "windowsserver",
    "publisher": "microsoftwindowsserver",
    "sku": "2022-datacenter-azure-edition-core"
    },
  "imagePath": null,
  "provisioningState": "Succeeded",
  "resourceName": "marketplacetest03",
  "status": {
    "downloadStatus": {},
    "provisioningStatus": {
    "operationId": "<Operation ID>",
      "status": "Succeeded"
    }
  },
    "version": {
      "name": "20348.707.220609",
        "storageProfile": {
          "osDiskImage": {}
        }
      }
    }
  },
  "resourceGroup": "mkclus90-rg",
  "systemData": {
    "createdAt": "2022-08-01T22:29:11.074104+00:00",
    "createdBy": "guspinto@microsoft.com",
    "createdByType": "User",
    "lastModifiedAt": "2022-08-01T22:36:12.900694+00:00",
    "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
    "lastModifiedByType": "Application"
  },
  "tags": null,
  "type": "microsoft.azurestackhci/marketplacegalleryimages"
}
PS C:\Users\azcli>
```

# [Azure portal](#tab/azureportal)

Follow these steps to create a VM image using the Azure portal. In the [Azure preview portal](https://aka.ms/edgevmmgmt) of your Azure Stack HCI cluster resource, take the following steps:

1. Go to **Resources** > **VM images**.

1. Select **+ Add VM Image** and from the dropdown list, select **Add VM image from Azure Marketplace**.

   :::image type="content" source="./media/manage-vm-resources/add-image-from-azure-marketplace.png" alt-text="Screenshot showing Add VM image from Azure Marketplace option." lightbox="./media/manage-vm-resources/add-image-from-azure-marketplace.png":::

1. In the **Create an image** page, on the **Basics** tab, input the following information:

    1. **Subscription.** Select a subscription to associate with your VM image.

    1. **Resource group.** Create new or select an existing resource group that you'll associate with the VM image.

    1. **Custom location.** Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Stack HCI cluster.

    1. **Image to download.** Select a VM image from the list of images in Azure Marketplace. The dropdown list shows all the Azure Marketplace images that are compatible with your Azure Stack HCI cluster.

    1. **Save image as.** Enter a name for your VM image.

1. Select **Review + Create** to create your VM image.

   :::image type="content" source="./media/manage-vm-resources/create-an-image.png" alt-text="Screenshot of the Create an Image page highlighting the Review + Create button." lightbox="./media/manage-vm-resources/create-an-image.png":::

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

Follow these steps to list VM image using Azure CLI.

1. Run PowerShell as an administrator.
1. Set some parameters.

    ```azurecli
    $Subscription = "<Subscription ID associated with your cluster>"
    $Resource_Group = "<Resource group name for your cluster>"
    ```
1. List all the VM images associated with your cluster. Run the following command:

    ```azurecli
    az azurestackhci image list --subscription $Subscription --resource-group $Resource_Group
    ```
    
    Depending on the command used, a corresponding set of images associated with the Azure Stack HCI cluster are listed.

    - If you specify just the subscription, the command lists all the images in the subscription.
    - If you specify both the subscription and the resource group, the command lists all the images in the resource group.

    These images include:
    - VM images from marketplace images.
    - Custom images that reside in your Azure Storage account or are in a local share on your cluster or a client connected to the cluster.

Here's a sample output.

```
PS C:\Users\azcli> az azurestackhci image list --subscription "b8d594e5-51f3-4c11-9c54-a7771b81c712" --resource-group "mkclus90-rg"
Command group 'azurestackhci' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
[
  {
    "extendedLocation": {
      "name": "/subscriptions/<Subscription ID>/resourcegroups/mkclus90-rg/providers/microsoft.extendedlocation/customlocations/cl04",
      "type": "CustomLocation"
    },
    "id": "/subscriptions/<Subscription ID>/resourceGroups/mkclus90-rg/providers/Microsoft.AzureStackHCI/galleryimages/testvhdgen1",
    "location": "eastus2euap",
    "name": "testvhdgen1",
    "properties": {
      "containerName": null,
      "hyperVGeneration": "V1",
      "identifier": null,
      "imagePath": null,
      "osType": "Windows",
      "provisioningState": "Succeeded",
      "status": null,
      "version": null
    },
    "resourceGroup": "mkclus90-rg",
    "systemData": {
      "createdAt": "2022-07-28T22:45:30.803142+00:00",
      "createdBy": "guspinto@microsoft.com",
      "createdByType": "User",
      "lastModifiedAt": "2022-07-28T22:45:30.803142+00:00",
      "lastModifiedBy": "guspinto@microsoft.com",
      "lastModifiedByType": "User"
    },
    "tags": null,
    "type": "microsoft.azurestackhci/galleryimages"
  },
  {
    "extendedLocation": {
      "name": "/subscriptions/<Subscription ID>/resourcegroups/mkclus90-rg/providers/microsoft.extendedlocation/customlocations/cl04",
      "type": "CustomLocation"
    },
    "id": "/subscriptions/<Subscription ID>/resourceGroups/mkclus90-rg/providers/Microsoft.AzureStackHCI/galleryimages/testvhdxgen2",
    "location": "eastus2euap",
    "name": "testvhdxgen2",
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
      "createdAt": "2022-07-28T23:00:56.490100+00:00",
      "createdBy": "guspinto@microsoft.com",
      "createdByType": "User",
      "lastModifiedAt": "2022-07-28T23:00:56.490100+00:00",
      "lastModifiedBy": "guspinto@microsoft.com",
      "lastModifiedByType": "User"
    },
    "tags": null,
    "type": "microsoft.azurestackhci/galleryimages"
  },
  {
    "extendedLocation": {
      "name": "/subscriptions/<Subscription ID>/resourcegroups/mkclus90-rg/providers/microsoft.extendedlocation/customlocations/cl04",
      "type": "CustomLocation"
    },
    "id": "/subscriptions/<Subscription ID>/resourceGroups/mkclus90-rg/providers/Microsoft.AzureStackHCI/marketplacegalleryimages/marketplacetest03",
    "location": "eastus2euap",
    "name": "marketplacetest03",
    "properties": {
      "containerName": null,
      "hyperVGeneration": null,
      "identifier": {
        "offer": "windowsserver",
        "publisher": "microsoftwindowsserver",
        "sku": "2022-datacenter-azure-edition-core"
      },
      "imagePath": null,
      "osType": "Windows",
      "provisioningState": "Succeeded",
      "resourceName": "marketplacetest03",
      "status": {
        "downloadStatus": {},
        "provisioningStatus": {
          "operationId": "<Operation ID>",
          "status": "Succeeded"
        }
      },
      "version": {
        "name": "20348.707.220609",
        "properties": {
          "storageProfile": {
            "osDiskImage": {}
          }
        }
      }
    },
    "resourceGroup": "mkclus90-rg",
    "systemData": {
      "createdAt": "2022-08-01T22:29:11.074104+00:00",
      "createdBy": "guspinto@microsoft.com",
      "createdByType": "User",
      "lastModifiedAt": "2022-08-01T22:36:12.900694+00:00",
      "lastModifiedBy": "<ID>",
      "lastModifiedByType": "Application"
    },
    "tags": null,
    "type": "microsoft.azurestackhci/marketplacegalleryimages"
  }
]
PS C:\Users\azcli>

```

# [Azure portal](#tab/azureportal)

In the Azure portal of your Azure Stack HCI cluster resource, you can track the VM image deployment on the VM image grid. You can see the list of the VM images that are already downloaded and the ones that are being downloaded on the cluster.

Follow these steps to view the list of VM images in Azure portal.

1. In the Azure portal, go to your Azure Stack HCI cluster resource.
1. Go to **Resources > VM images**.
1. In the right-pane, you can view the list of the VM images.

    :::image type="content" source="./media/manage-vm-resources/list-virtual-machine-images.png" alt-text="Screenshot showing the list of VM images on Azure Stack HCI cluster." lightbox="./media/manage-vm-resources/list-virtual-machine-images.png":::

---


## View VM image properties

You may want to view the properties of VM images before you use the image to create a VM. Follow these steps to view the image properties:

# [Azure CLI](#tab/azurecli)

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

        ```az azurestackhci image show --id $mktplaceImageID```

        Here's a sample output for this command:

        ```
        PS C:\Users\azcli> az azurestackhci image show --id $mktplaceImageID
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
        az azurestackhci image show --name $MktplaceImage --resource-group $Resource_Group
        ```
    	
        Here's a sample output:

         ```azurecli
         PS C:\Users\azcli> az azurestackhci image show --name $mktplaceImage --resource-group $resource_group
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

# [Azure portal](#tab/azureportal)

In the [Azure preview portal](https://aka.ms/edgevmmgmt) of your Azure Stack HCI cluster resource, perform the following steps:

1. Go to **Resources (Preview)** > **VM images**. In the right-pane, a list of VM images is displayed.

   :::image type="content" source="./media/manage-vm-resources/vm-images-list.png" alt-text="Screenshot showing list of images." lightbox="./media/manage-vm-resources/vm-images-list.png":::

1. Select the VM **Image name** to view the properties.

   :::image type="content" source="./media/manage-vm-resources/vm-image-properties.png" alt-text="Screenshot showing the properties of a selected VM image." lightbox="./media/manage-vm-resources/vm-image-properties.png":::
---


## Delete VM image

You may want to delete a VM image if the download fails for some reason or if the image is no longer needed. Follow these steps to delete the VM images.

# [Azure CLI](#tab/azurecli)

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

# [Azure portal](#tab/azureportal)

 In the [Azure preview portal](https://aka.ms/edgevmmgmt) of your Azure Stack HCI cluster
resource, perform the following steps:

1. Go to **Resources (Preview)** > **VM images**.

1. From the list of VM images displayed in the right-pane, select the trash can icon next to the VM image you want to delete.

   :::image type="content" source="./media/manage-vm-resources/delete-vm-image.png" alt-text="Screenshot showing the trash can icon against the VM image you want to delete." lightbox="./media/manage-vm-resources/delete-vm-image.png":::

1. When prompted to confirm deletion, select **Yes**.

   :::image type="content" source="./media/manage-vm-resources/prompt-to-confirm-deletion.png" alt-text="Screenshot showing a prompt to confirm deletion." lightbox="./media/manage-vm-resources/prompt-to-confirm-deletion.png":::

After the VM image is deleted, the list of VM images refreshes to reflect the deleted image.

---

## Next steps

Use VM images to [Create Arc-enabled VMs]