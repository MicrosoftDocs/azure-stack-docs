---
title: Create Azure Local VM from Azure Compute gallery images via Azure CLI
description: Learn how to create Azure Local VM images using Azure Compute gallery images.
author: sipastak
ms.author: sipastak
ms.topic: how-to
ms.service: azure-local
ms.custom:
  - devx-track-azurecli
ms.date: 05/06/2025
---

# Create Azure Local VM image using Azure Compute Gallery images

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to create Azure Local VMs enabled by Azure Arc using source images from the Azure Compute Gallery. You can create VM images on Azure CLI using the following steps and then use these VM images to create Azure Local VMs.

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

- Make sure to review and [complete the prerequisites](./azure-arc-vm-management-prerequisites.md).
- Make sure that your image is using a [supported operating system](/azure/azure-arc/servers/prerequisites#supported-operating-systems).
    - For custom images in Azure Compute Gallery, you have the following extra prerequisites:
    - You should have a VHD loaded in your Azure Compute Gallery. See how to [Create an image definition and image version](/azure/virtual-machines/image-version).
    - If using a VHDX:
        - The VHDX image must be Gen 2 type and secure boot enabled.
        - The VHDX image must be prepared using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options).

## Export image to managed disk

To transfer your Azure Compute Gallery image to be an Azure Local compatible image, you need to export your Azure Compute Gallery image version to a managed disk.

1. To download the Azure Compute Gallery image to your resource group, follow the steps in [Export an image version to a managed disk](/azure/virtual-machines/managed-disk-from-image-version). Note the name of the managed disk.  

1. Obtain the SAS token of the managed disk by using the following command:

    ```azurecli
    az disk grant-access --resource-group $resourceGroupName --name $diskName --duration-in-seconds $sasExpiryDuration --query [accessSas] -o tsv
    ```

## Create an Azure Local VM image

To create an Azure Local VM image:

1. Follow the steps in [Create Azure Local VM image in Azure Storage account](virtual-machine-image-storage-account.md#set-some-parameters), using the SAS token from the managed disk instead of the storage account container.

1. To avoid costs associated with a disk, make sure to delete the managed disk that was used to create this image using the following command:

    ```azurecli
    az disk delete --name $diskName --resource-group $resourceGroupName
    ```

## Next steps

- [Create logical networks](./create-virtual-networks.md)
