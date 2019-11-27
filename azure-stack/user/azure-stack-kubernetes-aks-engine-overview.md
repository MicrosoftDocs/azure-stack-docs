---
title: What is the AKS engine on Azure Stack? | Microsoft Docs
description: Learn how to use the AKS engine command-line tool to deploy and manage a Kubernetes cluster on Azure and Azure Stack. 
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
ms.date: 11/21/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 11/21/2019

---

# What is the AKS engine on Azure Stack?

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can use the AKS engine command-line tool to deploy and manage a Kubernetes cluster on Azure and Azure Stack. Use the AKS engine to create, upgrade, and scale Azure Resource Manager native clusters. You can use the engine to deploy a cluster in both connected and disconnected environments. This article provides an overview of the AKS engine, supported scenarios for using the engine with Azure Stack, and an introduction to operations such as deploy, upgrade, and scale.

## Overview of the AKS engine

The [AKS engine](https://github.com/Azure/aks-engine) provides a command-line tool to bootstrap Kubernetes clusters on Azure and Azure Stack. By using the Azure Resource Manager, the AKS engine helps you create and maintain clusters running on VMs, virtual networks, and other infrastructure-as-a-service (IaaS) resources in Azure Stack.

## AKS engine on Azure Stack considerations

Before you use the AKS engine on Azure Stack, it's important to understand the differences between Azure Stack and Azure. This section identifies different features and key considerations when using Azure Stack with the AKS engine to manage your Kubernetes cluster.

For more information on the specifics of the AKS engine on Azure Stack and its differences with respect to Azure see [AKS engine on Azure Stack](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md).

## Supported scenarios with the AKS engine

The following scenarios are supported by the Azure Stack support team:

1.  AKS engine deploys all cluster artifacts following the guidelines in this documentation and using the [following template](https://github.com/Azure/aks-engine/tree/master/examples/azure-stack).
2.  AKS engine deploys the cluster on an existing VNET. For more information, see [Using a custom virtual network with AKS engine](https://github.com/Azure/aks-engine/blob/master/docs/tutorials/custom-vnet.md).
3.  [Upgrade](azure-stack-kubernetes-aks-engine-upgrade.md) and [scale](azure-stack-kubernetes-aks-engine-scale.md) operations.

For more information on the AKS engine and Azure Stack, see [Support policies for AKS engine on Azure Stack](azure-stack-kubernetes-aks-engine-support.md).

## Install the AKS engine and deploy a Kubernetes cluster

To deploy a Kubernetes cluster with the AKS engine on Azure Stack:

1. [Set up the prerequisites for the AKS engine](azure-stack-kubernetes-aks-engine-set-up.md)
2. Install the AKS engine to a machine with access to your Azure Stack environment.
     - [Install the AKS engine on Windows in Azure Stack](azure-stack-kubernetes-aks-engine-deploy-windows.md)
     - [Install the AKS engine on Linux in Azure Stack](azure-stack-kubernetes-aks-engine-deploy-linux.md)
3. [Deploy a Kubernetes cluster with the AKS engine on Azure Stack](azure-stack-kubernetes-aks-engine-deploy-cluster.md)

## Next steps

> [!div class="nextstepaction"]
> [Set up the prerequisites for the AKS engine](azure-stack-kubernetes-aks-engine-set-up.md)