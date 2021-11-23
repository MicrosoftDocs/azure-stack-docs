---
title: Deploy Azure Arc enabled data services in Azure Kubernetes Service (AKS) on Azure Stack HCI
description: Learn how to deploy Azure Arc enabled data services in Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: baziwane
ms.topic: how-to
ms.date: 11/23/2021
ms.author: rbaziwane
---

# Deploy Azure Arc enabled data services

This checklist provides a list of prerequisites you need to follow to deploy Azure Arc enabled data services on Azure Kubernetes Service (AKS) on Azure Stack HCI. You must have installed [AKS on Azure Stack HCI](kubernetes-walkthrough-powershell.md) before using the checklist.

## Prerequisites for AKS on Azure Stack HCI

> [!div class="checklist"]
> * [Provision a workload cluster with only Linux node pools](use-node-pools.md)
> * Configure storage. by [using the AKS on Azure Stack HCI disk Container Storage Interface (CSI) drivers](/container-storage-interface-disks.md#create-a-custom-storage-class-for-an-aks-on-azure-stack-hci-disk)

## Prerequisites for Azure Arc enabled data services

> [!div class="checklist"]
> * [Connect your clusters to Azure Arc for Kubernetes](/azure-stack/aks-hci/connect-to-arc)
> * [Create and manage custom locations on Azure Arc-enabled Kubernetes](/Azure/azure-arc/kubernetes/custom-locations)(for direct connectivity mode only)

## Next steps

- [Create data controller](/azure/azure-arc/data/create-data-controller)

