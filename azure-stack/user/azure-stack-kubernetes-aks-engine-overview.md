---
title: What is the AKS Engine on Azure Stack? | Microsoft Docs
description: Learn how to use the AKS Engine command-line tool to deploy and manage a Kubernetes cluster on Azure and Azure Stack. 
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na (Kubernetes)
ms.devlang: nav
ms.topic: article
ms.date: 08/22/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 08/22/2019

---

# What is the AKS Engine on Azure Stack?

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can use the AKS Engine command-line tool to deploy and manage a Kubernetes cluster on Azure and Azure Stack. By using the engine, you can deploy your cluster in both connected and disconnected environments. This article provides an overview of the AKS Engine, supported scenarios for using the engine with Azure Stack, and an introduction to operations such as upgrade, scale, and rotate secrets for your Kubernetes cluster.

## Overview of the AKS Engine

The [AKS Engine](https://github.com/Azure/aks-engine) provides a command-line tool to bootstrap Kubernetes clusters on Azure and Azure Stack. By using the Azure Resource Manager, the AKS Engine helps you create, remove, and maintain clusters running on VMs, virtual networks, and other infrastructure-as-a-service ((IaaS) resources in Azure Stack. The AKS Engine is also provides a library used by AKS for performing management tasks to manage your service.

You can run the AKS Engine from the command line on your client VM and run common Kubernetes cluster management actions.

## AKS Engine on Azure Stack considerations

Before you use the AKS Engine on Azure Stack, it's important to understand the differences between Azure Stack and Azure. This section identifies different features and key considerations when using Azure Stack with the AKS Engine to manage your Kubernetes cluster.

<!-- For more information on the specifics of AKS Engine on Azure Stack and its differences with respect to Azure see [document](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md). question out to Walter Oliver. -->

## Supported scenarios with the AKS Engine

The following scenarios are supported by the Azure Stack support team:


1.  AKS Engine deploys all cluster artifacts as described by the [following template](https://github.com/Azure/aks-engine/tree/master/examples/azure-stack).
2.  AKS Engine deploys the cluster on an existing VNET. For more information, see [Using a custom virtual network with AKS Engine](https://github.com/Azure/aks-engine/blob/master/docs/tutorials/custom-vnet.md).
3.  AKS Engine deploys VMs and executes associated extensions. For more information, see [Extensions](https://github.com/Azure/aks-engine/blob/master/docs/topics/extensions.md).
4.  [Upgrade](azure-stack-kubernetes-aks-engine-upgrade.md), [scale](azure-stack-kubernetes-aks-engine-scale.md), and [rotate certificates](azure-stack-kubernetes-aks-engine-cert-rotate.md) operations.

## Next steps

- Review the support [Statement for AKS Engine on Azure Stack](azure-stack-kubernetes-ask-engine-support.md)
- [Set up the prerequisites for the AKS Engine](azure-stack-kubernetes-aks-engine-set-up.md)