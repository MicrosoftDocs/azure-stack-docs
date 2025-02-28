---
title: AKS on Azure Local issues after deleting storage volumes
description: Learn how to mitigate issues after deleting storage volumes.
author: sethmanheim
ms.author: sethm
ms.topic: troubleshooting
ms.date: 02/28/2025

---

# AKS on Azure Local issues after deleting storage volumes

This article describes how to mitigate cluster issues if a storage volume is deleted.

## Symptoms

AKS Arc workload data is stored on Azure Local storage volumes, including the AKS Arc node disks and persistent volumes of data disks. If the storage volume is accidentally deleted, the AKS Arc cluster doesn't work properly, as its data is removed as well.

## Workaround

To manage storage volumes on Azure Local, follow these steps:

- Ensure that you deleted all the storage path(s) that are created on that storage volume. Deleting storage paths raises an alert to indicate the workload that was stored on it. To delete the storage path, see [Delete a storage path](/azure/azure-local/manage/create-storage-path?view=azloc-24112&preserve-view=true&tabs=azurecli#delete-a-storage-path).
- If you have an AKS Arc cluster that must be deleted, see [Delete the AKS Arc cluster](aks-create-clusters-cli.md#delete-the-cluster).

## Next steps

[Troubleshoot issues in AKS enabled by Azure Arc](aks-troubleshoot.md)