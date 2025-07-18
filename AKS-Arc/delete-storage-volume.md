---
title: AKS on Azure Local issues after deleting storage volumes
description: Learn how to mitigate issues after deleting storage volumes.
author: sethmanheim
ms.author: sethm
ms.topic: troubleshooting
ms.date: 07/18/2025
ms.reviewer: guanghu
ms.lastreviewed: 07/18/2025

---

# AKS on Azure Local issues after deleting storage volumes

This article describes how to mitigate cluster issues if a storage volume is deleted.

## Symptoms

AKS Arc workload data is stored on Azure Local storage volumes, including the AKS Arc node disks and persistent volumes of data disks. If the storage volume is accidentally deleted, the AKS Arc cluster doesn't work properly, as its data is removed as well.

## Workaround

If the storage volume is accidentally deleted, you can mitigate the issue by recreating the storage path using the Azure CLI. For more information, see [Create storage path for Azure Local](/azure/azure-local/manage/create-storage-path). For example:

```azurecli
$storagepathname="<Storage path name>"
$path="<Path on the disk to cluster shared volume>"
$subscription="<Subscription ID>"
$resource_group="<Resource group name>"
$customLocName="<Custom location of your Azure Local>"
$customLocationID="/subscriptions/<Subscription ID>/resourceGroups/$resource_group/providers/Microsoft.ExtendedLocation/customLocations/$customLocName"
$location="<Azure region where the system is deployed>"

az stack-hci-vm storagepath create --resource-group $resource_group --custom-location $customLocationID --name $storagepathname --path $path
az stack-hci-vm storagepath update --resource-group $resource_group --custom-location $customLocationID --name $storagepathname --location $location
```

Once the storage path is recreated, the [MOC service](concepts-node-networking.md#microsoft-on-premises-cloud-service) automatically re-downloads the required **MocGalleryImages**.

## Next steps

[Troubleshoot issues in AKS enabled by Azure Arc](aks-troubleshoot.md)