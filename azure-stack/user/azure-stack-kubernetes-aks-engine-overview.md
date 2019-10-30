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
ms.date: 09/14/2019
ms.author: mabrigg
ms.reviewer: waltero
ms.lastreviewed: 09/14/2019

---

# What is the AKS Engine on Azure Stack?

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

You can use the AKS Engine command-line tool to deploy and manage a Kubernetes cluster on Azure and Azure Stack. Use the AKS Engine to create, upgrade, and scale Azure Resource Manager native clusters. You can use the engine to deploy a cluster in both connected and disconnected environments. This article provides an overview of the AKS Engine, supported scenarios for using the engine with Azure Stack, and an introduction to operations such as deploy, upgrade, and scale.

> [!IMPORTANT]
> The AKS Engine is currently in public preview.
> This preview version is provided without a service level agreement, and it's not recommended for production workloads. Certain features might not be supported or might have constrained capabilities. 
> For more information, see [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/).

## Overview of the AKS Engine

The [AKS Engine](https://github.com/Azure/aks-engine) provides a command-line tool to bootstrap Kubernetes clusters on Azure and Azure Stack. By using the Azure Resource Manager, the AKS Engine helps you create and maintain clusters running on VMs, virtual networks, and other infrastructure-as-a-service (IaaS) resources in Azure Stack.

## AKS Engine on Azure Stack considerations

Before you use the AKS Engine on Azure Stack, it's important to understand the differences between Azure Stack and Azure. This section identifies different features and key considerations when using Azure Stack with the AKS Engine to manage your Kubernetes cluster.

For more information on the specifics of the AKS Engine on Azure Stack and its differences with respect to Azure see [AKS Engine on Azure Stack](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md).

## Supported scenarios with the AKS Engine

The following scenarios are supported by the Azure Stack support team:

1.  AKS Engine deploys all cluster artifacts following the guidelines in this documentation and using the [following template](https://github.com/Azure/aks-engine/tree/master/examples/azure-stack).
2.  AKS Engine deploys the cluster on an existing VNET. For more information, see [Using a custom virtual network with AKS Engine](https://github.com/Azure/aks-engine/blob/master/docs/tutorials/custom-vnet.md).
3.  [Upgrade](azure-stack-kubernetes-aks-engine-upgrade.md) and [scale](azure-stack-kubernetes-aks-engine-scale.md) operations.

For more information on the AKS Engine and Azure Stack, see [Support policies for AKS Engine on Azure Stack](azure-stack-kubernetes-aks-engine-support.md).

## Install the AKS Engine and deploy a Kubernetes cluster

To deploy a Kubernetes cluster with the AKS Engine on Azure Stack:

1. [Set up the prerequisites for the AKS Engine](azure-stack-kubernetes-aks-engine-set-up.md)
2. Install the AKS Engine to a machine with access to your Azure Stack environment.
     - [Install the AKS Engine on Windows in Azure Stack](azure-stack-kubernetes-aks-engine-deploy-windows.md)
     - [Install the AKS Engine on Linux in Azure Stack](azure-stack-kubernetes-aks-engine-deploy-linux.md)
3. [Deploy a Kubernetes cluster with the AKS engine on Azure Stack](azure-stack-kubernetes-aks-engine-deploy-cluster.md)

## Next steps

> [!div class="nextstepaction"]
> [Set up the prerequisites for the AKS Engine](azure-stack-kubernetes-aks-engine-set-up.md)