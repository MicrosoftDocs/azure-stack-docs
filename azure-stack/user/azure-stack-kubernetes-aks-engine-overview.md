---
title: What is AKS engine on Azure Stack Hub? 
description: Learn how to use the AKS engine command-line tool to deploy and manage a Kubernetes cluster on Azure and Azure Stack Hub. 
author: sethmanheim

ms.topic: article
ms.date: 12/19/2022
ms.author: sethm
ms.reviewer: waltero
ms.lastreviewed: 09/02/2020

# Intent: As an Azure Stack Hub user, I want to learn how to use the AKS engine command-line so that I can deploy and manage a Kubernetes cluster on Azure and Azure Stack Hub.
# Keyword: deploy AKS kubernetes cluster azure stack hub

---


# What is AKS engine on Azure Stack Hub?

You can use the AKS engine command-line tool to deploy and manage a Kubernetes cluster on Azure and Azure Stack Hub. Use AKS engine to create, upgrade, and scale Azure Resource Manager native clusters. You can use the engine to deploy a cluster in both connected and disconnected environments. This article provides an overview of AKS engine, supported scenarios for using the engine with Azure Stack Hub, and an introduction to operations such as deploy, upgrade, and scale.

## Overview of AKS engine

[AKS engine](https://github.com/Azure/aks-engine) provides a command-line tool to bootstrap Kubernetes clusters on Azure and Azure Stack Hub. By using the Azure Resource Manager, AKS engine helps you create and maintain clusters running on VMs, virtual networks, and other infrastructure-as-a-service (IaaS) resources in Azure Stack Hub.

## AKS engine on Azure Stack Hub considerations

Before you use AKS engine on Azure Stack Hub, it's important to understand the differences between Azure Stack Hub and Azure. This section identifies different features and key considerations when using Azure Stack Hub with AKS engine to manage your Kubernetes cluster.

For more information on the specifics of AKS engine on Azure Stack Hub and its differences with respect to Azure, see [AKS engine on Azure Stack Hub](https://github.com/Azure/aks-engine/blob/master/docs/topics/azure-stack.md).

For more information on AKS engine and Azure Stack Hub, see [Support policies for AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-support.md).

## Install AKS engine and deploy a Kubernetes cluster

To deploy a Kubernetes cluster with AKS engine on Azure Stack Hub:

1. [Set up the prerequisites for AKS engine](azure-stack-kubernetes-aks-engine-set-up.md)
2. Install AKS engine on a machine with access to your Azure Stack Hub environment.
     - [Install AKS engine on Windows in Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-windows.md)
     - [Install AKS engine on Linux in Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-linux.md)
3. [Deploy a Kubernetes cluster with AKS engine on Azure Stack Hub](azure-stack-kubernetes-aks-engine-deploy-cluster.md)

## Next steps

> [!div class="nextstepaction"]
> [Set up the prerequisites for AKS engine](azure-stack-kubernetes-aks-engine-set-up.md)
