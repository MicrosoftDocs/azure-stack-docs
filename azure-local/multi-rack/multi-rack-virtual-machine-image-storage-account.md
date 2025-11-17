---
title: Create Azure Local VM images for multi-rack deployments using Azure Storage account (Preview)
description: Learn how to create Azure Local VMs for multi-rack deployments using source images from Azure Storage account via Azure portal and Azure CLI (Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 11/14/2025
---

# Create Azure Local VM images for multi-rack deployments using Azure Storage account (Preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create Azure Local virtual machines (VMs) for multi-rack deployments using source images from the Azure Storage account. You can create VM images using Azure Command Line Interface (CLI) and then use these images to create Azure Local VMs.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

For custom images in the Azure Storage account, make sure that the following prerequisites are met:

- You should have a VHD loaded in your Azure Storage account. For more information, see [Upload a VHD image in your Azure Storage account](/azure/databox-online/azure-stack-edge-gpu-create-virtual-machine-image#copy-vhd-to-storage-account-using-azcopy).

- Make sure that you upload your VHD or VHDX as a page blob image into the Storage account. Only page blob images are supported to create VM images via the Storage account.

- Prepare the VHDX image using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options#oobe&preserve-view=true). This requirement applies to both Windows and Linux VM images.

- Use only English (en-us) language VHDs to create VM images.

- For Linux VM images:

  - To allow for initial configuration and customization during VM provisioning, ensure that the image contains `cloud init with nocloud` datasource.

  - Configure the bootloader, kernel, and init system in your image to enable both serial connectivity and text-based console. Use both `GRUB_TERMINAL="console serial"` and kernel cmdline settings. This configuration is required to enable serial access for troubleshooting deployment issues and console support for your VM after deployment. Make sure the serial port settings on your system and terminal match to establish proper communication.
  
- For Windows VM images, install **VirtIO** drivers in the image to ensure proper detection of virtual storage and network devices during VM deployment.

- Connect to Azure Local via Azure CLI client.

- Make sure that you have **Storage Blob Data Contributor** role on the Storage account that you use for the image. For more information, see [Assign an Azure role for access to blob data](/azure/role-based-access-control/role-assignments-portal?tabs=current).

## Add VM image from Azure Storage account

Create a VM image from an image in an Azure Storage account, and then use this image to deploy VMs on your Azure Local instance.

To create a VM image using the Azure CLI, follow these steps:

### Sign in and set subscription

1. Connect to a machine on your Azure Local.

1. Sign in and type:

    ```azurecli
    az login --use-device-code 
    ```

1. Set your subscription:

    ```azurecli
    az account set --subscription <Subscription ID>
    ```

### Set some parameters

1. Set your subscription, resource group, location, SAS URL for the image in the storage account, and OS type for the image. Replace the parameters in `< >` with the appropriate values.

```azurecli
$subscription = "<Subscription ID>"
$resource_group = "<Resource group>"
$location = "<Location for your Azure Local>"
$customLocation = "<Custom or extended location of your Azure Local instance>"
$osType = "<OS of source image>"
$imageName = "<VM image name>"
$imageSourcePath = '"<Blob SAS URL path to the source image in the storage account>"'
```

> [!NOTE]
> For `$imageSourcePath`, escape the string with double quotes, then enclose it with single quotes: `'""'`.

The parameters are described in the following table:

| Parameter        | Description                                                                                |
|------------------|--------------------------------------------------------------------------------------------|
| `subscription`   | Subscription for Azure Local that you associate with this image.        |
| `resource-group` | Resource group for Azure Local that you associate with this image.        |
| `location`       | Location for your Azure Local instance. For example, this could be `eastus`. |
| `custom-location`       | ARM ID of the custom or extended location of your Azure Local instance. |
| `name`      | Name of the VM image created starting with the image in your local share. <br> **Note**: Azure rejects all the names that contain the keyword Windows. |
| `image-path`| Blob SAS URL path to the source image in the storage account. For instructions, see [Generating SAS tokens](/azure/applied-ai-services/form-recognizer/create-sas-tokens#generating-sas-tokens).<br>**Note**: Escape the path with double quotes, then enclose it with single quotes like: `'""'`. |
| `os-type`         | Operating system associated with the source image. This can be Windows or Linux.           |

Here's a sample output:

```console
PS C:\Users\azcli> $subscription = "<Subscription ID>"
PS C:\Users\azcli> $resource_group = "mylocal-rg"
PS C:\Users\azcli> $location = "eastus"
PS C:\Users\azcli> $osType = "Windows"
PS C:\Users\azcli> $imageName = "mylocal-storacctimage"
PS C:\Users\azcli> $imageSourcePath = '"https://vmimagevhdsa1.blob.core.windows.net/vhdcontainer/Windows_InsiderPreview_ServerStandard_en-us_VHDX_25131.vhdx?sp=r"&"st=2022-08-05T18:41:41Z"&"se=2022-08-06T02:41:41Z"&"spr=https"&"sv=2021-06-08"&"sr=b"&"sig=X7A98cQm%2FmNRaHmTbs9b4OWVv%2F9Q%2FJkWDBHVPyAc8jo%3D"'
```

### Create VM image from image in Azure Storage account

1. Select a custom location to deploy your VM image. The custom location should correspond to the custom location for your Azure Local. Get the custom location ID for your Azure Local from the Azure Local **Overview** page on Azure portal or run the following command:

    ```azurecli
    $customLocationID=(az customlocation show --resource-group $resource_group --name "<custom location name for your Azure Local>" --query id -o tsv)
    ```

1. Create the VM image from an image in the storage account:

    ```azurecli
    az stack-hci-vm image create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $imageName --os-type $osType --image-path $imageSourcePath
    ```

    A deployment job starts for the VM image.

    The image deployment takes a few minutes to complete. The time taken to download the image depends on the size of the image in Azure Storage account and the network bandwidth available for the download.

    Here's a sample output:

    ```output
    PS > $customLocationID=(az customlocation show --resource-group $resource_group --name "mylocal-cl" --query id -o tsv)
    PS C:\Users\azcli> az stack-hci-vm image create --subscription $subscription --resource-group $resource_group --custom-location $customLocationID --location $location --name $imageName --os-type $osType --image-path $imageSourcePath

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

## List VM images

View the list of VM images to choose an image to manage.

To list VM images using Azure CLI:

1. Run PowerShell as an administrator.
1. Set some parameters.

    ```azurecli
    $subscription = "<Subscription ID associated with your Azure Local>"
    $resource_group = "<Resource group name for your Azure Local>"
    ```

1. List all the VM images associated with your Azure Local:

    ```azurecli
    az stack-hci-vm image list --subscription $subscription --resource-group $resource_group
    ```

    Depending on the command used, a corresponding set of images associated with your Azure Local are listed.

    - If you specify just the subscription, the command lists all the images in the subscription.
    - If you specify both the subscription and the resource group, the command lists all the images in the resource group.

    These images include custom images that are in your Azure Storage account.

    Here's a sample output:

    ```output
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
        "type": "microsoft.azurestackhci/    marketplacegalleryimages"
      }
    ]
    PS C:\Users\azcli>
    ```

    For more information on this CLI command, see [az stack-hci-vm image list](/cli/azure/stack-hci-vm/image#az-stack-hci-vm-image-list).

## View VM image properties

You might want to view VM image properties before you use the image to create a VM. Follow these steps to view the image properties:

To use Azure CLI to view image properties:

1. Run PowerShell as an administrator.
1. Set the following parameters.

    ```azurecli
    $subscription = "<Subscription ID>"
    $resource_group = "<Azure Local resource group>"
    $Image = "<Image name>"
    ```

1. You can view image properties in two ways: specify ID or specify name and resource group. When specifying a Marketplace image ID:

    1. Set the following parameter.

        ```azurecli
        $ImageID = "/subscriptions/<Subscription ID>/resourceGroups/myhci-rg/providers/Microsoft.AzureStackHCI/galleryimages/mylocal-marketplaceimage"
        ```

    1. To view the properties, run this command:

        ```az stack-hci-vm image show --ids $ImageID```

        Here's sample output for this command:

        ```output
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

## Delete VM image

You might want to delete a VM image if the download fails for some reason or if the image isn't needed anymore. To delete a VM image, follow these steps:

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

You can delete an image in two ways:

- Specify name and resource group.
- Specify ID.

After you delete an image, check that it's removed. Here's sample output when the image is deleted by specifying the name and the resource group.

```console
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

## Next steps

- [Create logical networks](./multi-rack-create-logical-networks.md).