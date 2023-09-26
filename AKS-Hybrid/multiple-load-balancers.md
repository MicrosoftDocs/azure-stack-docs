---
title: Use multiple load balancers in AKS hybrid
description: How to use multiple load balancer instances and scale the numbers of instances on your Azure Kubernetes Service (AKS) deployment in AKS hybrid.
author: sethmanheim
ms.author: sethm
ms.date: 10/21/2022 
ms.reviewer: rbaziwane
ms.lastreviewed: 07/29/2022
ms.topic: how-to

# Intent: As an IT Pro, I want to learn about using multiple load balancers in Azure Kubernetes Service (AKS).
# Keyword: Kubernetes load balancer

---

# Use multiple load balancers in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article describes how to deploy one or more instances of the **HAProxy** load balancer in AKS hybrid, and how to scale out or in the load balancer configuration in the target cluster. 

In AKS hybrid, the load balancer is deployed as a virtual machine (VM) running Linux and **HAProxy + KeepAlive** to provide load balanced services for the workload clusters. This VM is used to load balance requests to the Kubernetes API server and for handling traffic to application services. 

You can also use a custom load balancer with AKS hybrid. For more information, see [Create and use a custom load balancer](configure-custom-load-balancer.md).

## Before you begin

- Install [AKS hybrid](kubernetes-walkthrough-powershell.md), and provide a range of virtual IP addresses for the load balancer during the network configuration step.

- Make sure you have enough memory and storage to create a new virtual machine and have virtual IP addresses to assign to application services.

## Deploy multiple load balancer instances

To deploy multiple load balancers during the workload cluster creation, use the `New-AksHciLoadBalancerSetting` cmdlet to set the `VmSize`; the number of instances for your **HAProxy** load balancer as follows:

1. Create a load balancer configuration using the [New-AksHciLoadBalancerSetting](reference/ps/new-akshciloadbalancersetting.md) cmdlet, and then select `HAProxy` for the `loadBalancerSku` parameter:

   ```powershell
   $lbcfg = New-AksHciLoadBalancerSetting -name "haProxyLB" -loadBalancerSku HAProxy -vmSize Standard_K8S3_v1 -loadBalancerCount 3
   ```

1. Deploy a workload cluster by providing the load balancer configuration using the following command:

   ```powershell
   New-AksHciCluster -name "holidays" -nodePoolName "thanksgiving" -nodeCount 2 -OSType linux -nodeVmSize Standard_A4_v2 -loadBalancerSettings $lbCfg
   ```

1. Verify that a new workload cluster is created with a load balancer deployed as a virtual machine running **HAProxy** to manage traffic for your applications.

## Scale out the load balancer instances

> [!IMPORTANT]
> Make sure you have enough physical memory and storage in your cluster before performing this operation. If the amount of physical memory required to deploy the requested number of load balancers is insufficient, this operation will fail.

To scale out (or in) your load balancer instances after deployment of a workload cluster, follow these steps:

1. Run `Set-AksHciLoadBalancer` with the number of instances you want to deploy in the cluster

   ```powershell
   Set-AksHciLoadBalancer -clusterName "holidays" -loadBalancerCount 5
   ```

1. Verify that the exact number of load balancer instances are created and that Kubernetes services are reachable.

## Next steps

- [Learn more about Kubernetes services](https://kubernetes.io/docs/concepts/services-networking/service/).
