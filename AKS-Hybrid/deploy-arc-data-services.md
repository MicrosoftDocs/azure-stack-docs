---
title: Deploy Azure Arc-enabled data services in AKS enabled by Azure Arc
description: Learn how to deploy Azure Arc-enabled data services in AKS enabled by Azure Arc.
author: sethmanheim
ms.topic: how-to
ms.date: 07/03/2024
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: rbaziwane
# Intent: As an IT Pro, I need to learn the requirements needed in order to deploy Azure Arc data.
# Keyword: Azure Arc data services
---

# Deploy Azure Arc-enabled data services

[!INCLUDE [aks-hybrid-applies-to-azure-stack-hci-windows-server-sku](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article provides a checklist of prerequisites you can follow to deploy Azure Arc-enabled data services on Azure Kubernetes Service (AKS) enabled by Azure Arc. You must have [AKS](kubernetes-walkthrough-powershell.md) installed before using the checklist.

## Prerequisites for AKS on Azure Stack HCI and Windows Server

> [!div class="checklist"]
> * [Provision a workload cluster with only Linux node pools](use-node-pools.md).
> * Configure storage [using the disk Container Storage Interface (CSI) drivers](container-storage-interface-disks.md#create-custom-storage-class-for-disks).

## Prerequisites for Azure Arc-enabled data services

> [!div class="checklist"]
> * [Connect your clusters to Azure Arc for Kubernetes](connect-to-arc.md).

Confirm whether custom location is enabled on your Kubernetes cluster by running the following command and checking for `customLocation: enabled: true`:

```console
helm get values azure-arc
```

If custom location isn't enabled, run the following CLI command:

```azurecli
az connectedk8s enable-features -n <clusterName> -g <resourceGroupName> --features cluster-connect custom-locations
```

> [!div class="checklist"]
> * [Create and manage custom locations on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/custom-locations) (for direct connectivity mode only).

## Next steps

* [Create data controller](/azure/azure-arc/data/create-data-controller)
