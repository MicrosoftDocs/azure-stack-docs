---
title: Create Azure Stack HCI VM from Azure Marketplace images via Azure CLI (preview)
description: Learn how to create Azure Stack HCI VM images using source images from Azure Marketplace (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom:
  - devx-track-azurecli
ms.date: 11/20/2023
---

# Create Azure Stack HCI VM image using Azure Marketplace images (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article describes how to create virtual machine (VM) images for your Azure Stack HCI using source images from Azure Marketplace. You can create VM images using the Azure portal or Azure CLI and then use these VM images to create Arc VMs on your Azure Stack HCI.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-image-prerequisites-marketplace](../../includes/hci-vm-image-prerequisites-marketplace.md)]

- If using a client to connect to your Azure Stack HCI cluster, see [Connect to Azure Stack HCI via Azure CLI client](./azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements).


# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-vm-image-prerequisites-marketplace](../../includes/hci-vm-image-prerequisites-marketplace.md)]
   
---


## Add VM image from Azure Marketplace

You create a VM image starting from an Azure Marketplace image and then use this image to deploy VMs on your Azure Stack HCI cluster.

# [Azure CLI](#tab/azurecli)

Follow these steps to create a VM image using the Azure CLI.

### Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../../includes/hci-vm-sign-in-set-subscription.md)]

### Set some parameters

1. Set parameters for your subscription, resource group, location, OS type for the image. Replace the parameters in `< >` with the appropriate values.

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Resource group>"
    $customLocationName = "<Custom location name>"
    $customLocationID
    /subscriptions/<Subscription ID>/resourcegroups/$resource_group/providers/microsoft.extendedlocation/customlocations/$customLocationName
    $location = "<Location for your Azure Stack HCI cluster>"
    $osType = "<OS of source image>"
    ```
    
    The parameters are described in the following table:
    
    | Parameter      | Description                                                                                |
    |----------------|--------------------------------------------------------------------------------------------|
    | `subscription`   | Subscription associated with your Azure Stack HCI cluster.        |
    | `resource-group` | Resource group for Azure Stack HCI cluster that you associate with this image.        |
    | `location`       | Location for your Azure Stack HCI cluster. For example, this could be `eastus`. |
    | `os-type`         | Operating system associated with the source image. This can be Windows or Linux.           |

    Here's a sample output:
    
    ```
    PS C:\Users\azcli> $subscription = "<Subscription ID>"
    PS C:\Users\azcli> $resource_group = "myhci-rg"
    PS C:\Users\azcli> $customLocationName = "myhci-cl"
    PS C:\Users\azcli> $location = "eastus"
    PS C:\Users\azcli> $ostype = "Windows"
    ```

### Create VM image from marketplace image

1. Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Stack HCI cluster. Get the custom location ID for your Azure Stack HCI cluster. Run the following command:

    ```azurecli
    $customLocationID=(az customlocation show --resource-group $resource_group --name "<custom location name for Azure Stack HCI cluster>" --query id -o tsv)
    ```

1. Create the VM image starting with a specified marketplace image. Make sure to specify the offer, publisher, SKU, and version for the marketplace image. Use the following table to find the available marketplace images and their attribute values:

    |    Name   |    Publisher     |    Offer   |    SKU    |    Version number    |
    |-------------|-------------|-----------------|-----------|----------------------|
    | Windows 11 Enterprise multi-session + Microsoft 365 Apps, version 21H2- Gen2            | microsoftwindowsdesktop | office-365       | win10-21h2-avd-m365-g2                 | 19044.3570.231010 |
    | Windows 10 Enterprise multi-session, version 21H2 + Microsoft 365 Apps- Gen2            | microsoftwindowsdesktop | office-365       | win11-21h2-avd-m365                    | 22000.2538.231010 |
    | Windows 10 Enterprise multi-session, version 21H2- Gen2                                 | microsoftwindowsdesktop | windows-10       | win10-21h2-avd-g2                      | 19044.3570.231001 |
    | Windows 11 Enterprise multi-session, version 21H2- Gen2                                 | microsoftwindowsdesktop | windows-11       | win11-21h2-avd                         | 22000.2538.231001 |
    | Windows 11 Enterprise multi-session, version 22H2 - Gen2                                | microsoftwindowsdesktop | windows-11       | win11-22h2-avd                         | 22621.2428.231001 |
    | Windows 11, version 22H2 Enterprise multi-session + Microsoft 365 Apps (Preview) - Gen2 | microsoftwindowsdesktop | windows11preview | win11-22h2-avd-m365                    | 22621.382.220810  |
    | Windows Server 2022 Datacenter: Azure Edition - Gen2                                    | microsoftwindowsserver  | windowsserver    | 2022-datacenter-azure-edition          | 20348.2031.231006 |
    | Windows Server 2022 Datacenter: Azure Edition Core - Gen2                               | microsoftwindowsserver  | windowsserver    | 2022-datacenter-azure-edition-core     | 20348.2031.231006 |
    | Windows Server 2022 Datacenter: Azure Edition Hotpatch - Gen2                           | microsoftwindowsserver  | windowsserver    | 2022-datacenter-azure-edition-hotpatch | 20348.2031.231006 |


    ```azurecli
    az stack-hci-vm image create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name "<VM image name>" --os-type $ostype --offer "windowsserver" --publisher "<Publisher name>" --sku "<SKU>" --version "<Version number>" --storage-path-id $storagepathid
    ```

    A deployment job starts for the VM image. 

    In this example, the storage path was specified using the `--storage-path-id` flag and that ensured that the workload data (including the VM, VM image, non-OS data disk) is placed in the specified storage path.

    If the flag is not specified, the workload data is automatically placed in a high availability storage path.


The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the Marketplace image and the network bandwidth available for the download.

Here's a sample output:

```
PS C:\Users\azcli> $customLocationID=(az customlocation show --resource-group $resource_group --name "myhci-cl" --query id -o tsv)
PS C:\Users\azcli> $customLocationID
/subscriptions/<Subscription ID>/resourcegroups/myhci-rg/providers/microsoft.extendedlocation/customlocations/myhci-cl
PS C:\Users\azcli> az stack-hci-vm image create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name "myhci-marketplaceimage" --os-type $ostype --offer "windowsserver" --publisher "microsoftwindowsserver" --sku "2022-datacenter-azure-edition-core" --version "20348.2031.231006" --storage-path-id $storagepathid
{
  "extendedLocation": {
    "name": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.ExtendedLocation/customLocations/myhci-cl",
    "type": "CustomLocation"
  },
  "id": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/marketplacegalleryimages/myhci-marketplaceimage",
  "location": "eastus",
  "name": "myhci-marketplaceimage",
  "properties": {
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
        "downloadSizeInMB": 6750
      },
      "progressPercentage": 98,
      "provisioningStatus": {
        "operationId": "13be90e0-a780-45bf-a84a-ae91b6e5e468*A380D53083FF6B0A3A157ED7DFD00D33F6B3D40D5559D11AEAED6AD68F7F1A4A",
        "status": "Succeeded"
      }
    },
    "storagepathId": "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/storagecontainers/myhci-storagepath",
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
  "resourceGroup": "myhci-rg",
  "systemData": {
    "createdAt": "2023-10-27T21:43:15.920502+00:00",
    "createdBy": "guspinto@contoso.com",
    "createdByType": "User",
    "lastModifiedAt": "2023-10-27T22:06:15.092321+00:00",
    "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05",
    "lastModifiedByType": "Application"
  },
  "tags": null,
  "type": "microsoft.azurestackhci/marketplacegalleryimages"
}

PS C:\Users\azcli>
```


# [Azure portal](#tab/azureportal)

Follow these steps to create a VM image using the Azure portal. In the Azure portal of your Azure Stack HCI cluster resource, take the following steps:

1. Go to **Resources** > **VM images**.

1. Select **+ Add VM Image** and from the dropdown list, select **Add VM image from Azure Marketplace**.

   :::image type="content" source="./media/manage-vm-resources/add-image-from-azure-marketplace.png" alt-text="Screenshot showing Add VM image from Azure Marketplace option." lightbox="./media/manage-vm-resources/add-image-from-azure-marketplace.png":::

1. In the **Create an image** page, on the **Basics** tab, input the following information:

    1. **Subscription.** Select a subscription to associate with your VM image.

    1. **Resource group.** Create new or select an existing resource group that you associate with the VM image.

    1. **Custom location.** Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Stack HCI cluster.

    1. **Image to download.** Select a VM image from the list of images in Azure Marketplace. The dropdown list shows all the Azure Marketplace images that are compatible with your Azure Stack HCI cluster.

    1. **Save image as.** Enter a name for your VM image.

    1. **Storage path.** Select the storage path for your VM image.

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

### [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-list-vm-image-azure-cli](../../includes/hci-list-vm-image-azure-cli.md)]


### [Azure portal](#tab/azureportal)

[!INCLUDE [hci-list-vm-image-portal](../../includes/hci-list-vm-image-portal.md)]

---

## View VM image properties

You might want to view the properties of VM images before you use the image to create a VM. Follow these steps to view the image properties:

### [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../../includes/hci-view-vm-image-properties-azure-cli.md)]

### [Azure portal](#tab/azureportal)

[!INCLUDE [hci-view-vm-image-properties-portal](../../includes/hci-view-vm-image-properties-portal.md)]

---

## Update VM image

When a new updated image is available in Azure Marketplace, the VM images on your Azure Stack HCI cluster become stale and should be updated. The update operation isn't an in-place update of the image. Rather you can see for which VM images an updated image is available, and select images to update. After you update, the create VM image operation uses the new updated image.

To update a VM image, use the following steps in Azure portal.

1. To see if an update is available, select a VM image from the list view.

   :::image type="content" source="./media/manage-vm-resources/new-update-available.png" alt-text="Screenshot showing that a VM image update is available for download." lightbox="./media/manage-vm-resources/new-update-available.png":::

   In the **Overview** blade, you see a banner that shows the new VM image available for download, if one is available. To update to the new image, select **the arrow icon**.

   :::image type="content" source="./media/manage-vm-resources/new-update-available-in-image-details.png" alt-text="Screenshot showing a new VM image available for download in VM image details." lightbox="./media/manage-vm-resources/new-update-available-in-image-details.png":::

2. Review image details and then select **Review and create**. By default, the new image uses the same resource group and instance details as the previous image.

   The name for the new image is incremented based on the name of the previous image. For example, an existing image named *winServer2022-01* will have an updated image named *winServer2022-02*.

   :::image type="content" source="./media/manage-vm-resources/review-and-create-image.png" alt-text="Screenshot showing the Review and create dialog for a new VM image." lightbox="./media/manage-vm-resources/review-and-create-image.png":::

3. To complete the operation, select **Create**.

   :::image type="content" source="./media/manage-vm-resources/create-image.png" alt-text="Screenshot showing the Create image dialog for a new VM image." lightbox="./media/manage-vm-resources/create-image.png":::

   After the new VM image is created, create a VM using the new image and verify that the VM works properly. After verification, you can delete the old VM image.

   > [!NOTE]
   > In this release, you can't delete a VM image if the VM associated with that image is running. Stop the VM and then delete the VM image.

## Delete VM image

You might want to delete a VM image if the download fails for some reason or if the image is no longer needed. Follow these steps to delete the VM images.

### [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../../includes/hci-delete-vm-image-azure-cli.md)]

### [Azure portal](#tab/azureportal)

[!INCLUDE [hci-delete-vm-image-portal](../../includes/hci-delete-vm-image-portal.md)]
---

## Next steps

- [Create logical networks](./create-virtual-networks.md)
