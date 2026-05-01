---
title: Download Azure managed disk to Azure Local multi-rack
description: Learn how to download an Azure managed disk to Azure Local multi-rack deployments.
author: sipastak
ms.topic: how-to
ms.date: 04/15/2026
ms.author: sipastak
ms.reviewer: vlakshmanan
ms.service: azure-local
ms.custom: sfi-image-nochange
ms.subservice: multi-rack
---

# Download managed data disks to Azure Local multi-rack

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to download an Azure managed disk from Azure to your Azure Local multi-rack instance. You can then use the disk to create an image or to attach it to your Azure Local virtual machines (VMs) enabled by Arc, as needed.

## Prerequisites

Before you begin, make sure to complete the following prerequisites:

- You have access to an Azure Local multi-rack instance that is deployed and registered.
- There's already a managed disk in Azure.

## Sign in and set subscription

[!INCLUDE [hci-vm-sign-in-set-subscription](../includes/hci-vm-sign-in-set-subscription.md)]

## Set parameters

Set parameters for `subscription`, `resource-group`, `name`, and `custom-location`. Replace the parameters in `< >` with the appropriate values:

```azurecli
$subscription = "<Subscription ID>"
$resourceGroup = "<Resource group>"
$name = "<Data disk name>"
$customLocation = "<Custom location resource ID>"
```

## Download the managed disk

1. Generate a SAS URL of the disk using Azure CLI:

    ```azurecli
    $downloadUrl = (az disk grant-access --access-level Read --duration-in-seconds 3600 --name $name --resource-group $resourceGroup --query accessSas -o tsv)
    ```

1. Once the SAS URL is generated, use the following command to download it to your Azure Local multi-rack instance:

    ```azurecli
    az stack-hci-vm disk create --resource-group $resourceGroup --custom-location $customLocation --download-url $downloadUrl --name $name
    ```

The parameters are described in the following table:

| Parameter | Description |
| --- | --- |
| `subscription` | Subscription associated with your Azure Local. |
| `resource-group` | Resource group for Azure Local that you associate with this disk. |
| `name` | Name of the data disk for Azure Local. |
| `custom-location` | Resource ID of the custom location for Azure Local. |
| `download-url` | SAS URL of the Azure managed disk. |

## Next steps

- [Manage Azure Local VM resources for multi-rack deployments](multi-rack-manage-arc-virtual-machine-resources.md)
- [Create Azure Local VMs enabled by Azure Arc for multi-rack deployments](multi-rack-create-arc-virtual-machines.md)
