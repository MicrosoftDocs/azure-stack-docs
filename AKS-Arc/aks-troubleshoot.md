---
title: Troubleshoot common issues in AKS enabled by Azure Arc
description: Learn about common issues and workarounds in AKS enabled by Arc.
ms.topic: how-to
author: sethmanheim
ms.date: 11/22/2024
ms.author: sethm 
ms.lastreviewed: 02/27/2024
ms.reviewer: guanghu

---

# Troubleshoot common issues in AKS enabled by Azure Arc

This article describes how to find solutions for issues you encounter when using AKS enabled by Azure Arc. Known issues and errors are organized by functional area. You can use the links provided in this article to find solutions and workarounds to resolve them.

## Open a support request

See the [Get support](/azure/aks/hybrid/help-support?tabs=aksee) article for information about how to use the Azure portal to get support or open a support request for AKS Arc.

## Upgrade

### Azure Advisor upgrade recommendation

If you continually see an [Azure Advisor](/azure/advisor/) upgrade recommendation that says "Upgrade to the latest version of AKS enabled by Azure Arc," follow these steps to disable the recommendation:

- Ensure that you update your Azure Local solution to the latest version. For more information, see [About updates for Azure Local, version 23H2](/azure-stack/hci/update/about-updates-23h2).
- If you use any of the Azure SDKs, ensure that you're using the latest version of that SDK. You can find the Azure SDKs by searching for "HybridContainerService" on the [Azure SDK releases](https://azure.github.io/azure-sdk/) page.

## Storage

### AKS on Azure Local might not work after storage volume been deleted 

AKS Arc workload data is been stored on Azure Local storage volumes, including the AKS Arc node disks and persistent volumes of data disks. If the storage volume is been accidently deleted, the AKS Arc cluster will not work properly as its data is removed as well.  Please follow these steps to manage storage volumes on Azure Local: 

- Ensure that you deleted all the storage path(s) that are created on that storage volume. Deleting storage path will raise alert to indicate the worklaod that has been stored on it. To delete storage path, see [Delete a storage path](/azure-local/manage/create-storage-path?view=azloc-24112&tabs=azurecli#delete-a-storage-path).
- If you have any AKS Arc cluster need to be deleted, that is notified in the previous step of storage path deletion, see [Delete the AKS Arc cluster](/aks/aksarc/aks-create-clusters-cli#delete-the-cluster).

## Next steps

- [Troubleshoot K8sVersionValidation error](cluster-k8s-version.md)
- [Use diagnostic checker](aks-arc-diagnostic-checker.md)
