---
title: Create Azure Local VM from Azure Marketplace images via Azure CLI
description: Learn how to create Azure Local VM images using source images from Azure Marketplace.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.custom:
  - devx-track-azurecli
ms.date: 03/04/2025
---

# Create Azure Local VM image using Azure Marketplace images

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article explains how to create Windows virtual machine (VM) images for Azure Local using source images from Azure Marketplace, either through the Azure portal or Azure CLI.

To create Linux VM images from Azure Marketplace, choose:

- [Prepare RHEL Azure Marketplace image for Azure Local VM deployment](../manage/virtual-machine-azure-marketplace-red-hat.md).

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

- Make sure to review and [complete the prerequisites](./azure-arc-vm-management-prerequisites.md).

- Make sure you have the **Azure Connected Machine Resource Manager** role. For more information, see [Assign Azure roles](/azure/role-based-access-control/role-assignments-portal).

- Make sure that your subscription is registered with the `Microsoft.EdgeMarketplace` resource provider. For more information, see [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).

- If using a client to connect to your Azure Local instance, see [Connect to the system remotely](./azure-arc-vm-management-prerequisites.md#connect-to-the-system-remotely).

# [Azure portal](#tab/azureportal)

- Make sure to review and [complete the prerequisites](./azure-arc-vm-management-prerequisites.md).

- Make sure you have the **Azure Connected Machine Resource Manager** role. For more information, see [Assign Azure roles](/azure/role-based-access-control/role-assignments-portal).

- Make sure that your subscription is registered with the `Microsoft.EdgeMarketplace` resource provider. For more information, see [Register resource provider](/azure/azure-resource-manager/management/resource-providers-and-types#register-resource-provider).
---

## Add VM image from Azure Marketplace

You create a VM image starting from an Azure Marketplace image and then use this image to deploy VMs on your Azure Local instance.

# [Azure CLI](#tab/azurecli)

Follow these steps to create a VM image using the Azure CLI.

### Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]

### Set some parameters

1. Set parameters for your subscription, resource group, location, OS type for the image. Replace the parameters in `< >` with the appropriate values.

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Resource group>"
    $mktplaceImage = "<Marketplace image name>"
    $customLocationName = "<Custom location name>"
    $customLocationID = (az customlocation show --resource-group $resource_group --name "<custom_location_name_for_Azure_Local>" --query id -o tsv)
    $location = "<Location for your Azure Local>"
    $osType = "<OS of source image>"
    ```

    The parameters are described in the following table:

    | Parameter      | Description                                                                                |
    |----------------|--------------------------------------------------------------------------------------------|
    | `subscription`   | Subscription associated with your Azure Local.        |
    | `resource-group` | Resource group for your Azure Local that you associate with this image.     |
    | `name` | Name of the marketplace image for Azure Local.  |
    | `customLocation` | Resource ID of custom location for your Azure Local.   |
    | `location`       | Location for your Azure Local. For example, this could be `eastus`. |
    | `os-type`         | Operating system associated with the source image. This can be Windows or Linux.           |

    Here's a sample output:

    ```
    PS C:\Users\azcli> $subscription = "<Subscription ID>"
    PS C:\Users\azcli> $resource_group = "mylocal-rg"
    PS C:\Users\azcli> $mktplaceImage= "mylocal-marketplaceimage"
    PS C:\Users\azcli> $customLocationName = "mylocal-cl"
    PS C:\Users\azcli> $customerLocationID /subscriptions$subscription/resourcegroups/$resource_group/providers/microsoft.extendedlocation/customlocations/$customLocationName
    PS C:\Users\azcli> $location = "eastus"
    PS C:\Users\azcli> $ostype = "Windows"
    ```

### Create VM image from marketplace image

1. Set additional parameters that specify the intended VM image you would like to create. You will need to include the offer, publisher, SKU, and version for the marketplace image. Replace the parameters in \< \> with the appropriate values:

    ```azurecli
    $publisher = "<Publisher name>"
    $offer = "<OS offer>"
    $sku = "<Image SKU>"
    ```

    Use the following table to find the available marketplace images and their attribute values:

    | Name | Publisher | Offer | SKU |
    |------|-----------|-------|------|
    | Windows 11 Enterprise multi-session + Microsoft 365 | microsoftwindowsdesktop | office-365 | win11-23h2-avd-m365 <br> win11-24h2-avd-m365 |
    | Windows 10 Enterprise multi-session + Microsoft 365  | microsoftwindowsdesktop | office-365 | win10-21h2-avd-m365 |
    | Windows 11 Pro | microsoftwindowsdesktop | windows-11 | win11-23h2-pro |
    | Windows 11 Enterprise | microsoftwindowsdesktop | windows-11 | win11-22h2-ent<br>win11-23h2-ent<br>win11-24h2-ent |
    | Windows 11 Enterprise multi-session | microsoftwindowsdesktop | windows-11 | win11-22h2-avd<br>win11-23h2-avd<br>win11-24h2-avd |
    | Windows 10 Pro | microsoftwindowsdesktop | windows-10 | win10-22h2-pro-g2 |
    | Windows 10 Enterprise | microsoftwindowsdesktop | windows-10 | win10-22h2-ent-g2 |
    | Windows 10 Enterprise multi-session | microsoftwindowsdesktop | windows-10 | win10-22h2-avd |
    | Windows Server 2025 Datacenter: Azure Edition  | microsoftwindowsserver  | windowsserver  | 2025-datacenter-azure-edition-smalldisk<br>2025-datacenter-azure-edition-core<br>2025-datacenter-azure-edition |
    | Windows Server 2022 Datacenter: Azure Edition | microsoftwindowsserver | windowsserver | 2022-datacenter-azure-edition-hotpatch<br>2022-datacenter-azure-edition-core<br>2022-datacenter-azure-edition |
    | Windows Server 2019 | microsoftwindowsserver | windowsserver | 2019-datacenter-gensecond<br>2019-datacenter-core-g2 |
    | SQL Server 2022 Enterprise on Windows Server 2022 | microsoftsqlserver | sql2022-ws2022 | enterprise-gen2<br>standard-gen2 |

    If you wanted to create a Windows Server 2019 Datacenter image, you would have the following parameters: 


    ```azurecli
    $publisher = "microsoftwindowsserver" 
    $offer = "windowsserver" 
    $sku = "2019-datacenter-gensecond"
    ```

1. Create the VM image starting with a specified marketplace image:

    ```azurecli
    az stack-hci-vm image create --resource-group $resource_group --custom-location $customLocationID --name $mktplaceImage --os-type $ostype --offer $offer --publisher $publisher --sku $sku 
    ```

Here's a sample output:

```
PS C:\Users\azcli> az stack-hci-vm image create --custom-location $cl --name $mktplaceImage --os-type $ostype --resource-group $rg --publisher $publisher --offer $offer --sku $sku 
{ 
  "extendedLocation": { 
    "name": “/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.ExtendedLocation/customLocations/mylocal-cl", 
    "type": "CustomLocation" 
  }, 
  "id": "/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/marketplacegalleryimages/myhci-marketplaceimage", 
\ 
  "location": "eastus", 
  "name": "myhci-marketplaceimage", 
  "properties": { 
    "cloudInitDataSource": null, 
    "containerId": null, 
    "hyperVGeneration": null, 
    "identifier": { 
      "offer": "windowsserver", 
      "publisher": "microsoftwindowsserver", 
      "sku": "2019-datacenter-gensecond" 
    }, 
    "osType": "Windows", 
    "provisioningState": "Succeeded", 
    "status": { 
      "downloadStatus": { 
        "downloadSizeInMb": 10832 
      }, 
      "errorCode": "", 
      "errorMessage": "", 
      "progressPercentage": 100, 
      "provisioningStatus": { 
        "operationId": "13efc468-7473-429f-911b-858c1e6fc1d5*B11A62EE76B08EF194F8293CDD40F7BC71BFB93255D5A99DD11B4167690752D9", 
        "status": "Succeeded" 
      } 
    }, 
    "version": { 
      "name": "17763.6293.240905", 
      "properties": { 
        "storageProfile": { 
          "osDiskImage": { 
            "sizeInMb": 130050 
          } 
        } 
      } 

    } 
  }, 
  "resourceGroup": "mylocal-rg", 
  "systemData": { 
    "createdAt": "2024-09-23T18:53:13.734389+00:00", 
    "createdBy": "guspinto@contoso.com", 
    "createdByType": "User", 
    "lastModifiedAt": "2024-09-23T19:06:07.532276+00:00", 
    "lastModifiedBy": "319f651f-7ddb-4fc6-9857-7aef9250bd05", 
    "lastModifiedByType": "Application" 
  }, 

  "tags": null, 
  "type": "microsoft.azurestackhci/marketplacegalleryimages" 
} 
```

For more information on this CLI command, see [az stack-hci-vm image](/cli/azure/stack-hci-vm/image).

# [Azure portal](#tab/azureportal)

Follow these steps to create a VM image using Azure portal. In Azure portal for your Azure Local resource, take the following steps:

1. Go to **Resources** > **VM images**.

1. Select **+ Add VM Image** and from the dropdown list, select **Add VM image from Azure Marketplace**.

   :::image type="content" source="./media/virtual-machine-image-azure-marketplace/add-image-from-azure-marketplace.png" alt-text="Screenshot showing Add VM image from Azure Marketplace option." lightbox="./media/virtual-machine-image-azure-marketplace/add-image-from-azure-marketplace.png":::

1. In the **Create an image** page, on the **Basics** tab, input the following information:

    1. **Subscription.** Select a subscription to associate with your VM image.

    1. **Resource group.** Create new or select an existing resource group that you associate with the VM image.

    1. **Custom location.** Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Local.

    1. **Image to download.** Select a VM image from the list of images in Azure Marketplace. The dropdown list shows all the Azure Marketplace images that are compatible with your Azure Local.

    1. **Save image as.** Enter a name for your VM image.

    1. **Storage path.** Select the storage path for your VM image. Select **Choose automatically** to have a storage path with high availability automatically selected. Select **Choose manually** to specify a storage path to store VM images and configuration files on the Azure Local instance. In this case, ensure that the specified storage path has sufficient storage space.

1. Select **Review + Create** to create your VM image.

   :::image type="content" source="./media/virtual-machine-image-azure-marketplace/create-an-image.png" alt-text="Screenshot of the Create an Image page highlighting the Review + Create button." lightbox="./media/virtual-machine-image-azure-marketplace/create-an-image.png":::

1. The input parameters are validated. If the validations succeed, you can review the VM image details and select **Create**.
        
   :::image type="content" source="./media/virtual-machine-image-azure-marketplace/create-an-image-create.png" alt-text="Screenshot of the Create an Image page highlighting the Create button." lightbox="./media/virtual-machine-image-azure-marketplace/create-an-image-create.png":::
  
1. An Azure Resource Manager template deployment job starts for the VM image. The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the Marketplace image and the network bandwidth available for the download. 

   :::image type="content" source="./media/virtual-machine-image-azure-marketplace/deployment-in-progress.png" alt-text="Screenshot showing deployment is in progress." lightbox="./media/virtual-machine-image-azure-marketplace/deployment-in-progress.png":::

   You can track the image deployment on the VM image grid. You can see the list of the VM images that are already downloaded and the ones that are being downloaded on the system.

   To view more details of any image, select the VM image name from the list of VM images.

1. When the image download is complete, the VM image shows up in the list of images, and the **Status** shows as **Available**.

   :::image type="content" source="./media/virtual-machine-image-azure-marketplace/added-vm-image.png" alt-text="Screenshot showing the newly added VM image in the list of images." lightbox="./media/virtual-machine-image-azure-marketplace/added-vm-image.png":::

   If the download of the VM image fails, the error details are shown in the portal blade.

   :::image type="content" source="./media/virtual-machine-image-azure-marketplace/failed-deployment.png" alt-text="Screenshot showing an error when the download of VM image fails." lightbox="./media/virtual-machine-image-azure-marketplace/failed-deployment.png":::

---

## List VM images

You need to view the list of VM images to choose an image to manage.

### [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-list-vm-image-azure-cli](../includes/hci-list-vm-image-azure-cli.md)]


### [Azure portal](#tab/azureportal)

[!INCLUDE [hci-list-vm-image-portal](../includes/hci-list-vm-image-portal.md)]

---

## View VM image properties

You might want to view the properties of VM images before you use the image to create a VM. Follow these steps to view the image properties:

### [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../includes/hci-view-vm-image-properties-azure-cli.md)]

### [Azure portal](#tab/azureportal)

[!INCLUDE [hci-view-vm-image-properties-portal](../includes/hci-view-vm-image-properties-portal.md)]

---

## Update VM image

> [!IMPORTANT]
> The latest updates may take some time to reflect on your VM images as additional validations are performed.

When a new updated image is available in Azure Marketplace, the VM images on your Azure Local become stale and should be updated. The update operation isn't an in-place update of the image. Rather you can see for which VM images an updated image is available, and select images to update. After you update, the create VM image operation uses the new updated image.

To update a VM image, use the following steps in Azure portal.

1. To see if an update is available, select a VM image from the list view.

   :::image type="content" source="./media/virtual-machine-image-azure-marketplace/new-update-available.png" alt-text="Screenshot showing that a VM image update is available for download." lightbox="./media/virtual-machine-image-azure-marketplace/new-update-available.png":::

   In the **Overview** blade, you see a banner that shows the new VM image available for download, if one is available. To update to the new image, select **the arrow icon**.

   :::image type="content" source="./media/virtual-machine-image-azure-marketplace/new-update-available-in-image-details.png" alt-text="Screenshot showing a new VM image available for download in VM image details." lightbox="./media/virtual-machine-image-azure-marketplace/new-update-available-in-image-details.png":::

2. Review image details and then select **Review and create**. By default, the new image uses the same resource group and instance details as the previous image.

   The name for the new image is incremented based on the name of the previous image. For example, an existing image named *winServer2022-01* will have an updated image named *winServer2022-02*.

   :::image type="content" source="./media/virtual-machine-image-azure-marketplace/review-and-create-image.png" alt-text="Screenshot showing the Review and create dialog for a new VM image." lightbox="./media/virtual-machine-image-azure-marketplace/review-and-create-image.png":::

3. To complete the operation, select **Create**.

   :::image type="content" source="./media/virtual-machine-image-azure-marketplace/create-image.png" alt-text="Screenshot showing the Create image dialog for a new VM image." lightbox="./media/virtual-machine-image-azure-marketplace/create-image.png":::

   After the new VM image is created, create a VM using the new image and verify that the VM works properly. After verification, you can delete the old VM image.

## Delete VM image

You might want to delete a VM image if the download fails for some reason or if the image is no longer needed. Follow these steps to delete the VM images.

### [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../includes/hci-delete-vm-image-azure-cli.md)]

### [Azure portal](#tab/azureportal)

[!INCLUDE [hci-delete-vm-image-portal](../includes/hci-delete-vm-image-portal.md)]
---

## Next steps

- [Create logical networks](./create-virtual-networks.md)
