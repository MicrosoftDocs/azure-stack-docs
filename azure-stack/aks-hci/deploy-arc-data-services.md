---
title: Deploy Azure Arc enabled data services in Azure Kubernetes Service on Azure Stack HCI and Windows Server
description: Learn how to deploy Azure Arc enabled data services in Azure Kubernetes Service on Azure Stack HCI and Windows Server.
author: mattbriggs
ms.topic: how-to
ms.date: 04/21/2022
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: rbaziwane
# Intent: As an IT Pro, I need to learn the requirements needed in order to deploy Azure Arc data in AKS on Azure Stack HCI and Windows Server.
# Keyword: Azure Arc data services
---

# Deploy Azure Arc enabled data services in Azure Kubernetes Service on Azure Stack HCI and Windows Server

This topic provides a checklist of prerequisites you need to follow to deploy Azure Arc enabled data services on  Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server. You must have [AKS on Azure Stack HCI and Windows Server](kubernetes-walkthrough-powershell.md) installed before using the checklist.

## Prerequisites for AKS on Azure Stack HCI and Windows Server

> [!div class="checklist"]
> * [Provision a workload cluster with only Linux node pools](use-node-pools.md)
> * Configure storage [using the AKS on Azure Stack HCI and Windows Server disk Container Storage Interface drivers](./container-storage-interface-disks.md#create-a-custom-storage-class-for-an-aks-on-azure-stack-hci-and-windows-server-disk)

## Prerequisites for Azure Arc enabled data services

> [!div class="checklist"]
> * [Connect your clusters to Azure Arc for Kubernetes](/azure-stack/aks-hci/connect-to-arc)

Confirm whether custom location has been enabled on your AKS-HCI cluster by running the following command and checking for `customLocation: enabled: true`
```
helm get values azure-arc
```

If custom location has not been enabled on your AKS-HCI run the following Az CLI command:
```
az connectedk8s enable-features -n <clusterName> -g <resourceGroupName> --features cluster-connect custom-locations
```
> * [Create and manage custom locations on Azure Arc-enabled Kubernetes](/azure/azure-arc/kubernetes/custom-locations)(for direct connectivity mode only)

## Next steps

- [Create data controller](/azure/azure-arc/data/create-data-controller)


