---
title: Create Azure Local VM image for multi-rack deployments using Azure Storage account (Preview)
description: Learn how to create Azure Local VMs for multi-rack deployments using source images from Azure Storage account via Azure portal and Azure CLI. (Preview)
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/07/2025
---

# Create Azure Local VM image for multi-rack deployments using Azure Storage account (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create Azure Local VMs for multi-rack deployments using source images from the Azure Storage account. You can create VM images using the Azure portal or Azure CLI and then use these images to create Azure Local VMs.


## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

# [Azure CLI](#tab/azurecli)

For custom images in Azure Storage account, you have the following extra prerequisites:

- You should have a VHD loaded in your Azure Storage account. For more information, see [Upload a VHD image in your Azure Storage account](/azure/databox-online/azure-stack-edge-gpu-create-virtual-machine-image#copy-vhd-to-storage-account-using-azcopy). 

- Make sure that you're uploading your VHD or VHDX as a page blob image into the Storage account. Only page blob images are supported to create VM images via the Storage account.

- The VHDX image must be prepared using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options#oobe&preserve-view=true). This is true for both Windows and Linux VM images.

- For Linux VM image:

    - To allow for initial configuration and customization during VM provisioning, you need to ensure that the image contains `cloud init with nocloud` datasource.

    - You need to configure the bootloader, kernel, and init system in your image to enable both serial connectivity and text-based console. Use both `GRUB_TERMINAL="console serial"` and kernel cmdline settings. This configuration is required to enable serial access for troubleshooting deployment issues and console support for your VM after deployment. Make sure the serial port settings on your system and terminal match to establish proper communication.
- For Windows VM image, install **VirtIO** drivers in the image to ensure proper detection of virtual storage and network devices during VM deployment. 

- If using a client to connect to your Azure Local instance, see [Connect to Azure Local via Azure CLI client](../manage/azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements).

- Make sure that you have **Storage Blob Data Contributor** role on the Storage account that you use for the image. For more information, see [Assign an Azure role for access to blob data](/azure/role-based-access-control/role-assignments-portal?tabs=current).


# [Azure portal](#tab/azureportal)

For custom images in Azure Storage account, you have the following extra prerequisites:

- You should have a VHD loaded in your Azure Storage account. For more information, see [Upload a VHD image in your Azure Storage account](/azure/databox-online/azure-stack-edge-gpu-create-virtual-machine-image#copy-vhd-to-storage-account-using-azcopy). 

- Make sure that you're uploading your VHD or VHDX as a page blob image into the Storage account. Only page blob images are supported to create VM images via the Storage account.

- The VHDX image must be prepared using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options#oobe&preserve-view=true). This is true for both Windows and Linux VM images.

- For Linux VM image:

    - To allow for initial configuration and customization during VM provisioning, you need to ensure that the image contains `cloud init with nocloud` datasource.

    - You need to configure the bootloader, kernel, and init system in your image to enable both serial connectivity and text-based console. Use both `GRUB_TERMINAL="console serial"` and kernel cmdline settings. This configuration is required to enable serial access for troubleshooting deployment issues and console support for your VM after deployment. Make sure the serial port settings on your system and terminal match to establish proper communication.
- For Windows VM image, install **VirtIO** drivers in the image to ensure proper detection of virtual storage and network devices during VM deployment. 

- If using a client to connect to your Azure Local instance, see [Connect to Azure Local via Azure CLI client](../manage/azure-arc-vm-management-prerequisites.md#azure-command-line-interface-cli-requirements).

- Make sure that you have **Storage Blob Data Contributor** role on the Storage account that you use for the image. For more information, see [Assign an Azure role for access to blob data](/azure/role-based-access-control/role-assignments-portal?tabs=current).

---

## Add VM image from Azure Storage account

You create a VM image starting from an image in Azure Storage account and then use this image to deploy VMs on your Azure Local max.

# [Azure CLI](#tab/azurecli)

Follow these steps to create a VM image using the Azure CLI.

### Sign in and set subscription

1. [Connect to a machine](../manage/azure-arc-vm-management-prerequisites.md#connect-to-the-system-directly) on your Azure Local.

1. Sign in and type:

    ```azurecli
    az login --use-device-code 
    ```

1. Set your subscription:

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

### Set some parameters

1. Set your subscription, resource group, location, path to the image in local share, and OS type for the image. Replace the parameters in `< >` with the appropriate values.

```azurecli
$subscription = "<Subscription ID>"
$resource_group = "<Resource group>"
$location = "<Location for your Azure Local>"
$osType = "<OS of source image>"
$imageName = "<VM image name>"
$imageSourcePath = '"<Blob SAS URL path to the source image in the storage account>"'
```

> [!NOTE]
> For `$imageSourcePath`, the string must be escaped by double quotes, then enclosed by single quotes as follows: `'""'`.

The parameters are described in the following table:

| Parameter        | Description                                                                                |
|------------------|--------------------------------------------------------------------------------------------|
| `subscription`   | Subscription for Azure Local that you associate with this image.        |
| `resource_group` | Resource group for Azure Local that you associate with this image.        |
| `location`       | Location for your Azure Local instance. For example, this could be `eastus`. |
| `imageName`      | Name of the VM image created starting with the image in your local share. <br> **Note**: Azure rejects all the names that contain the keyword Windows. |
| `imageSourcePath`| Blob SAS URL path to the source image in the storage account. For instructions, see [Generating SAS tokens](/azure/applied-ai-services/form-recognizer/create-sas-tokens#generating-sas-tokens).<br>**Note**: The path string must be escaped by double quotes, then enclosed by single quotes as follows: `'""'`. |
| `os-type`         | Operating system associated with the source image. This can be Windows or Linux.           |

Here's a sample output:

```
PS C:\Users\azcli> $subscription = "<Subscription ID>"
PS C:\Users\azcli> $resource_group = "mylocal-rg"
PS C:\Users\azcli> $location = "eastus"
PS C:\Users\azcli> $osType = "Windows"
PS C:\Users\azcli> $imageName = "mylocal-storacctimage"
PS C:\Users\azcli> $imageSourcePath = '"https://vmimagevhdsa1.blob.core.windows.net/vhdcontainer/Windows_InsiderPreview_ServerStandard_en-us_VHDX_25131.vhdx?sp=r"&"st=2022-08-05T18:41:41Z"&"se=2022-08-06T02:41:41Z"&"spr=https"&"sv=2021-06-08"&"sr=b"&"sig=X7A98cQm%2FmNRaHmTbs9b4OWVv%2F9Q%2FJkWDBHVPyAc8jo%3D"'
```

### Create VM image from image in Azure Storage account

1. Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Local. Get the custom location ID for your Azure Local. Run the following command:

    ```azurecli
    $customLocationID=(az customlocation show --resource-group $resource_group --name "<custom location name for your Azure Local>" --query id -o tsv)
    ```
1. Create the VM image from an image in the storage account:

    ```azurecli
    az stack-hci-vm image create --subscription $subscription --resource-group $resource_Group --custom-location $customLocationID --location $location --name $imageName --os-type $osType --image-path $imageSourcePath
    ```
    A deployment job starts for the VM image. 

The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the image in Azure Storage account and the network bandwidth available for the download.

Here's a sample output:

```
PS > $customLocationID=(az customlocation show --resource-group $resource_group --name "mylocal-cl" --query id -o tsv)
PS C:\Users\azcli> az stack-hci-vm image create --subscription $subscription --resource-group $resource_Group --custom-location $customLocationID --location $location --name $imageName --os-type $osType --image-path $imageSourcePath

Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
{
  "extendedLocation": {
    "name": "/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.ExtendedLocation/customLocations/mylocal-cl",
    "type": "CustomLocation"
  },
  "id": "/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/galleryimages/mylocal-storacctimage",
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
    "storagepathId": "/subscriptions/<Subscription ID>/resourceGroups/mylocal-rg/providers/Microsoft.AzureStackHCI/storagecontainers/mylocal-storagepath",
    "version": null
  },
  "resourceGroup": "mylocal-rg",
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

Follow these steps to create a VM image using the Azure portal. In the Azure portal of your Azure Local resource, take the following steps:

1. Go to **Resources** > **VM images**.

1. Select **+ Add VM Image** and from the dropdown list, select **Add VM image from Azure Storage Account**.

   :::image type="content" source="./media/multi-rack-virtual-machine-image-storage-account/add-image-from-azure-storage-account.png" alt-text="Screenshot showing Add VM image from Azure Marketplace option." lightbox="./media/multi-rack-virtual-machine-image-storage-account/add-image-from-azure-storage-account.png":::

1. In the **Create an image** page, on the **Basics** tab, input the following information:

    1. **Subscription** Select a subscription to associate with your VM image.

    1. **Resource group** Create new or select an existing resource group that you associate with the VM image.
    
    1. **Save image as** Enter a name for your VM image.

    1. **Custom location** Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Local.

    1. **Image to download** Select a VM image from the list of images in Azure Marketplace. The dropdown list shows all the Azure Marketplace images that are compatible with your Azure Local.

    1. **OS type** Select the OS of the image as Windows or Linux. This is the OS associated with the image in your Storage account.
    
    1. **VM generation.** Select the Generation of the image.

    1. **Source.** The source of the image should be Storage blobs and is automatically populated.

    1. **Storage blob.** Specify the Azure Storage account path for the source image on your system.

    1. **Storage path.** Select the storage path for your VM image. Select **Choose automatically** to have a storage path with high availability automatically selected. Select **Choose manually** to specify a storage path to store VM images and configuration files on the Azure Local instance. In this case, ensure that the specified storage path has sufficient storage space.

1. Select **Review + Create** to create your VM image.

   :::image type="content" source="./media/multi-rack-virtual-machine-image-storage-account/create-an-image-storage-account-review-create.png" alt-text="Screenshot of the Create an Image page highlighting the Review + Create button." lightbox="./media/multi-rack-virtual-machine-image-storage-account/create-an-image-storage-account-review-create.png":::

1. The input parameters are validated. If the validations succeed, you can review the VM image details and select **Create**.
        
   :::image type="content" source="./media/multi-rack-virtual-machine-image-storage-account/create-an-image-create.png" alt-text="Screenshot of the Create an Image page highlighting the Create button." lightbox="./media/multi-rack-virtual-machine-image-storage-account/create-an-image-create.png":::
    
1. An Azure Resource Manager template deployment job starts for the VM image. The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the Marketplace image and the network bandwidth available for the download.

   :::image type="content" source="./media/multi-rack-virtual-machine-image-storage-account/deployment-in-progress.png" alt-text="Screenshot showing deployment is in progress." lightbox="./media/multi-rack-virtual-machine-image-storage-account/deployment-in-progress.png":::

   You can track the image deployment on the VM image grid. You can see the list of the VM images that are already downloaded and the ones that are being downloaded on the system.

   To view more details of any image, select the VM image name from the list of VM images.

1. When the image download is complete, the VM image shows up in the list of images, and the **Status** shows as **Available**.

   :::image type="content" source="./media/multi-rack-virtual-machine-image-storage-account/added-vm-image.png" alt-text="Screenshot showing the newly added VM image in the list of images." lightbox="./media/multi-rack-virtual-machine-image-storage-account/added-vm-image.png":::

   If the download of the VM image fails, the error details are shown in the portal blade.

   :::image type="content" source="./media/multi-rack-virtual-machine-image-storage-account/failed-deployment.png" alt-text="Screenshot showing an error when the download of VM image fails." lightbox="./media/multi-rack-virtual-machine-image-storage-account/failed-deployment.png":::

---

## List VM images

You need to view the list of VM images to choose an image to manage.

# [Azure CLI](#tab/azurecli)

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

    These images include custom images that reside in your Azure Storage account.

Here's a sample output.

```
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
PS C:\Users\azcli>
```

For more information on this CLI command, see [az stack-hci-vm image list](/cli/azure/stack-hci-vm/image#az-stack-hci-vm-image-list).


# [Azure portal](#tab/azureportal)

In the Azure portal of your Azure Local resource, you can track the VM image deployment on the VM image grid. You can see the list of the VM images that are already downloaded and the ones that are being downloaded on your system.

Follow these steps to view the list of VM images in Azure portal.

1. In the Azure portal, go to your Azure Local resource.
1. Go to **Resources > VM images**.
1. In the right-pane, you can view the list of the VM images.

    :::image type="content" source="./media/multi-rack-virtual-machine-image-storage-account/list-virtual-machine-images.png" alt-text="Screenshot showing the list of VM images on your Azure Local." lightbox="./media/multi-rack-virtual-machine-image-storage-account/list-virtual-machine-images.png":::

---

## View VM image properties

You might want to view the properties of VM images before you use the image to create a VM. Follow these steps to view the image properties:

# [Azure CLI](#tab/azurecli)

Follow these steps to use Azure CLI to view properties of an image:

1. Run PowerShell as an administrator.
1. Set the following parameters.

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Azure Local resource group>"
    $Image = "<Image name>"
    ```

1. You can view image properties in two different ways: specify ID or specify name and resource group. Take the following steps when specifying Marketplace image ID:

    1. Set the following parameter.

        ```azurecli
        $ImageID = "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/galleryimages/mylocal-marketplaceimage"
        ```

    1.	Run the following command to view the properties.

        ```az stack-hci-vm image show --ids $ImageID```

        Here's a sample output for this command:

        ```
        PS C:\Users\azcli> az stack-hci-vm image show --ids $mktplaceImageID
        Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: `https://aka.ms/CLI_refstatus`
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
        PS C:\Users\azcli> 
        ```
<!--
1.	Take the following steps when specifying name and resource group.

    1. Set the following parameters:
    
        ```azurecli
        $mktplaceImage = "mylocal-marketplaceimage"
        $resource_group = "mylocal-rg"    
        ```
    
    1. Run the following command to view the properties:
    
        ```azurecli
        az azurestackhci image show --name $MktplaceImage --resource-group $Resource_Group
        ```
    	
        Here's a sample output:

         ```azurecli
            PS C:\Users\azcli> az stack-hci-vm image show --ids $mktplaceImageID
            Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
            {
              "extendedLocation": {
                "name": "/subscriptions/<Suscription ID>/resourceGroups/myhci-rg/providers/Microsoft.ExtendedLocation/customLocations/cluster-638d2f5b237b4af6978885a2885d3ef4-mocarb-cl",
                "type": "CustomLocation"
              },
              "id": "/subscriptions/<Suscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/marketplacegalleryimages/mylocal-marketplaceimage",
              "location": "eastus",
              "name": "mylocal-marketplaceimage",
              "properties": {
                "identifier": {
                  "offer": "windowsserver",
                  "publisher": "microsoftwindowsserver",
                  "sku": "2022-datacenter-azure-edition-core"
                },
                "imagePath": null,
                "osType": "Windows",
                "provisioningState": "Accepted",
                "status": {
                  "downloadStatus": {
                    "downloadSizeInMB": 3932
                  },
                  "progressPercentage": 57,
                  "provisioningStatus": {}
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
                "createdAt": "2023-10-27T21:43:15.920502+00:00",
                "createdBy": "guspinto@contoso.com",
                "createdByType": "User",
                "lastModifiedAt": "2023-10-27T21:43:15.920502+00:00",
                "lastModifiedBy": "guspinto@contoso.com",
                "lastModifiedByType": "User"
              },
              "tags": null,
              "type": "microsoft.azurestackhci/marketplacegalleryimages"
            }
            PS C:\Users\azcli>
   
 -->        ```


# [Azure portal](#tab/azureportal)

In the Azure portal of your Azure Local resource, perform the following steps:

1. Go to **Resources** > **VM images**. In the right-pane, a list of VM images is displayed.

   :::image type="content" source="./media/multi-rack-virtual-machine-image-storage-account/vm-images-list.png" alt-text="Screenshot showing list of images." lightbox="./media/multi-rack-virtual-machine-image-storage-account/vm-images-list.png":::

1. Select the VM **Image name** to view the properties.

   :::image type="content" source="./media/multi-rack-virtual-machine-image-storage-account/vm-image-properties.png" alt-text="Screenshot showing the properties of a selected VM image." lightbox="./media/multi-rack-virtual-machine-image-storage-account/vm-image-properties.png":::

---


## Delete VM image

You might want to delete a VM image if the download fails for some reason or if the image is no longer needed. Follow these steps to delete the VM images.

# [Azure CLI](#tab/azurecli)

1. Run PowerShell as an administrator.
1. Set the following parameters:

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Azure Local resource group>"
    $Image = "<Image name>"    
    ```

1. Remove an existing VM image. Run the following command:

    ```azurecli
    az stack-hci-vm image delete --subscription $subscription --resource-group $resource_group --name $Image --yes
    ```

You can delete image two ways:

- Specify name and resource group.
- Specify ID.

After you've deleted an image, you can check that the image is removed. Here's a sample output when the image was deleted by specifying the name and the resource-group.

```
PS C:\Users\azcli> $subscription = "<Subscription ID>"
PS C:\Users\azcli> $resource_group = "mylocal-rg"
PS C:\Users\azcli> $Image = "mymylocal-marketplaceimage"
PS C:\Users\azcli> az stack-hci-vm image delete --name $mktplaceImage --resource-group $resource_group
Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: `https://aka.ms/CLI_refstatus`
Are you sure you want to perform this operation? (y/n): y
PS C:\Users\azcli> az stack-hci-vm image show --name $mktplaceImage --resource-group $resource_group
Command group 'stack-hci-vm' is experimental and under development. Reference and support levels: https://aka.ms/CLI_refstatus
ResourceNotFound: The Resource 'Microsoft.AzureStackHCI/marketplacegalleryimages/myhci-marketplaceimage' under resource group 'mylocal-rg' was not found. For more details please go to https://aka.ms/ARMResourceNotFoundFix
PS C:\Users\azcli>
```

# [Azure portal](#tab/azureportal)

In the Azure portal of your Azure Local resource, perform the following steps:

1. Go to **Resources** > **VM images**.

1. From the list of VM images displayed in the right-pane, select the trash can icon next to the VM image you want to delete.

   :::image type="content" source="./media/multi-rack-virtual-machine-image-storage-account/delete-vm-image.png" alt-text="Screenshot showing the trash can icon against the VM image you want to delete." lightbox="./media/multi-rack-virtual-machine-image-storage-account/delete-vm-image.png":::

1. When prompted to confirm deletion, select **Yes**.

   :::image type="content" source="./media/multi-rack-virtual-machine-image-storage-account/prompt-to-confirm-deletion.png" alt-text="Screenshot showing a prompt to confirm deletion." lightbox="./media/multi-rack-virtual-machine-image-storage-account/prompt-to-confirm-deletion.png":::

After the VM image is deleted, the list of VM images refreshes to reflect the deleted image.

---

## Next steps

- [Create logical networks](../manage/create-logical-networks.md)