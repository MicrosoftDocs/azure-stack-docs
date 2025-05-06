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

This article describes how to create virtual machine (VM) images for Azure Local using source images from Azure Marketplace. You can create VM images using the Azure portal or Azure CLI and then use these VM images to create Arc VMs on Azure Local.

## Prerequisites

Before you begin, make sure that the following prerequisites are completed.

- Make sure to review and [complete the prerequisites](./azure-arc-vm-management-prerequisites.md).

## Export image to managed disk

To transfer your Azure compute gallery image to be an Azure Local compatible image, you export your Azure Compute Gallery image version to a managed disk.

Follow these steps to create a VM image using the Azure CLI.

## Create Azure Local image

[Create Azure Local VMs enabled by Azure Arc in Azure Storage account](virtual-machine-image-storage-account.md#set-some-parameters)

## Delete managed disk

To avoid costs associated with a disk, make sure to delete the managed disk that was used to create this image.   

## Next steps

- [Create logical networks](./create-virtual-networks.md)
