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
ms.date: 6/20/2023
---

# Create Azure Stack HCI VM image using Azure Marketplace images (preview)

[!INCLUDE [hci-applies-to-22h2-21h2](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to create virtual machine (VM) images for your Azure Stack HCI using source images from Azure Marketplace. You can create VM images using the Azure portal or Azure CLI and then use these VM images to create Arc VMs on your Azure Stack HCI.

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

[!INCLUDE [hci-vm-image-prerequisites-marketplace](../../includes/hci-vm-image-prerequisites-marketplace.md)]


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
    | `Subscription`   | Subscription associated with your Azure Stack HCI cluster.        |
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

1. Create the VM image starting with a specified marketplace image. Make sure to specify the offer, publisher, SKU, and version for the marketplace image. Use the following table to find the available marketplace images and their attribute values:

    | Name | Publisher | Offer | SKU | Latest version |
    |---|---|---|---|---|
    | Windows Server 2022 Datacenter: Azure Edition | microsoftwindowsserver | windowsserver | 2022-datacenter-azure-edition | 20348.1547.230207 |
    | Windows Server 2022 Datacenter: Azure Edition Core | microsoftwindowsserver | windowsserver | 2022-datacenter-azure-edition-core | 20348.1487.230207 |
    | Windows 11 Enterprise multi-session, version 21H2 | microsoftwindowsdesktop | windows-11 | win11-21h2-avd | 22000.1574.230207 |
    | Windows 11 Enterprise multi-session, version 22H2 | microsoftwindowsdesktop | windows-11 | win11-22h2-avd | 22621.1265.230207 |
    | Windows 10 Enterprise multi-session, version 21H2 | microsoftwindowsdesktop | windows-10 | win10-21h2-avd | 19044.2604.230207 |
    | Windows 11 Enterprise multi-session + Microsoft 365 Apps, version 21H2 | microsoftwindowsdesktop | office-365 | win11-21h2-avd-m365 | 22000.1455.230110 |
    | Windows 10 Enterprise multi-session, version 21H2 + Microsoft 365 Apps | microsoftwindowsdesktop | office-365 | win10-21h2-avd-m365 | 19044.2486.230110 |

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

Follow these steps to create a VM image using the Azure portal. In the Azure portal of your Azure Stack HCI cluster resource, take the following steps:

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

[!INCLUDE [hci-view-vm-image-properties-azure-cli](../../includes/hci-delete-vm-image-azure-cli.md)]

# [Azure portal](#tab/azureportal)

[!INCLUDE [hci-delete-vm-image-portal](../../includes/hci-delete-vm-image-portal.md)]

---

## Next steps

- [Create virtual networks](./create-virtual-networks.md)
