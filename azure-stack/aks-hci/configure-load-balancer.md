---
title: Create and use load balancer with Azure Kubernetes Service (AKS) on Azure Stack HCI
description: Learn how to create and use load balancer with Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: mattbriggs
ms.topic: how-to
ms.date: 11/18/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: rbaziwane
---

# Create and use load balancer in AKS on Azure Stack HCI and Windows Server

In AKS on Azure Stack HCI and Windows Server, the load balancer is deployed as a virtual machine (VM) running Linux and HAProxy + KeepAlive to provide load balanced services for the workload clusters. It load balances requests to the Kubernetes API server and manages traffic to application services.

This article details how to configure HAProxy as your load balancer for a workload cluster. For custom load balancer integration, see [Create and use a custom load balancer](configure-custom-load-balancer.md).

## Before you begin

- You must have installed [AKS on Azure Stack HCI and Windows Server](kubernetes-walkthrough-powershell.md) and provided a range of virtual IP addresses for the load balancer during the network configuration step.
  
- You need to ensure that you have enough memory and storage to create a new virtual machine and virtual IP addresses to assign to application services.

## Configure load balancer

To configure a load balancer, use [New-AksHciCluster](./reference/ps/new-akshcicluster.md) to provision a new cluster as shown in the following example:

```powershell
New-AksHciCluster -name mycluster -loadBalancerVmSize Standard_A4_v2
```

This example creates a new workload cluster with a load balancer deployed as a virtual machine running HAProxy to manage traffic for your applications.

## Next steps 

To learn more about Kubernetes services, see the [Kubernetes services documentation](https://kubernetes.io/docs/concepts/services-networking/service/). 