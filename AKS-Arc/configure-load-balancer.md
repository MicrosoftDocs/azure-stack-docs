---
title: Create and use load balancer with Azure Kubernetes Service in AKS on Windows Server
description: Learn how to create and use load balancer with Azure Kubernetes Service (AKS) in AKS Arc.
author: sethmanheim
ms.topic: how-to
ms.date: 06/24/2024
ms.author: sethm 
ms.lastreviewed: 01/30/2024
ms.reviewer: rbaziwane

# Intent: As an IT Pro, I need to learn how to create a load balancer and use it as a Virtual Machine (VM).
# Keyword: load balancer configure HAProxy + KeepAliveS

---

# Create and use load balancer with Azure Kubernetes Service in AKS on Windows Server

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes how to configure **HAProxy** as your load balancer for a workload cluster in AKS Arc. For custom load balancer integration, see [Create and use a custom load balancer](configure-custom-load-balancer.md).

In AKS Arc, the load balancer is deployed as a virtual machine (VM) running Linux and **HAProxy + KeepAlive** to provide load balanced services for the workload clusters. AKS load balances requests to the Kubernetes API server, and manages traffic to application services.

## Before you begin

- Install [AKS Arc](kubernetes-walkthrough-powershell.md), and provide a range of virtual IP addresses for the load balancer during the network configuration step.
- Make sure you have enough memory and storage to create a new virtual machine and have virtual IP addresses to assign to application services.

## Configure load balancer

To configure a load balancer, use [New-AksHciCluster](./reference/ps/new-akshcicluster.md) to provision a new cluster as shown in the following example:

```powershell
New-AksHciCluster -name mycluster -loadBalancerVmSize Standard_A4_v2
```

This example creates a new workload cluster with a load balancer deployed as a virtual machine running HAProxy to manage traffic for your applications.

## Next steps

- [Learn more about Kubernetes services](https://kubernetes.io/docs/concepts/services-networking/service/).
