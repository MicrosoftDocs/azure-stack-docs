---
title: Create and use a load balancer with Azure Kubernetes Service (AKS) on Azure Stack HCI
description: Learn how to create and use a load balancer with Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: baziwane
ms.topic: how-to
ms.date: 11/18/2021
ms.author: rbaziwane
---

# Create and use a load balancer in AKS on Azure Stack HCI

In AKS on Azure Stack HCI, the load balancer is deployed as a virtual machine (VM) running Linux and HAProxy + KeepAlive to provide load balanced services for the workload clusters. This load balancer is used to load balance requests to the Kubernetes API server and for handling traffic to application services.

This article shows you how to configure HAProxy as your load balancer for a workload cluster. For custom load balancer integration, see [Create and use a custom load balancer](configure-custom-load-balancer.md).

## Before you begin

This topic assumes you have [AKS on Azure Stack HCI installed](kubernetes-walkthrough-powershell.md) and have provided a range of virtual IP addresses for the load balancer during the network configuration step.
  
You need to ensure that you have enough memory and storage to create a new virtual machine and virtual IP addresses to assign to application services.

## Configure the load balancer

To configure a load balancer, start by provisioning a new cluster as shown in the following example:

```powershell
New-AksHciCluster -name mycluster -loadBalancerVmSize Standard_A4_v2
```

This example creates a new workload cluster with a load balancer deployed as a virtual machine running HAProxy to manage traffic for your applications.

> [!NOTE]
> The parameter set above is going to be deprecated in a future release. This set will still be supported and will be the default behavior when running [New-AksHciCluster](./reference/ps/new-akshcicluster.md) with the -name parameter, which is the only required parameter.

## Next Steps 

To learn more about Kubernetes services, see the [Kubernetes services documentation](https://kubernetes.io/docs/concepts/services-networking/service/). 