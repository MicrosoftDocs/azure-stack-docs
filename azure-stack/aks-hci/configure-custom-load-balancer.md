---
title: Create and use a custom load balancer with Azure Kubernetes Service (AKS) on Azure Stack HCI
description: Learn how to create and use a custom load balancer with Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: mattbriggs
ms.topic: how-to
ms.date: 11/18/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: rbaziwane
---

# Create and use a custom load balancer in AKS on Azure Stack HCI

This article covers how to create and use a custom load balancer. In AKS on Azure Stack HCI, you use load balancers to send requests to the Kubernetes API server and to manage traffic to application services. When using a custom load balancer, [kube-vip](https://kube-vip.io/) automatically deploys to manage the load balancing of requests to the Kubernetes API server and to make sure that it's highly available.

> [!NOTE]
> You can also use a other load balancers, such as MetalLB or Software Defined Networking (SDN) load balancing, to load balance traffic to application services.  

## Before you begin 

You must have installed [AKS on Azure Stack HCI](kubernetes-walkthrough-powershell.md) and provided a range of virtual IP addresses for the load balancer during the network configuration step during installation.

## Configure a custom load balancer 

> [!WARNING]
> If you choose to deploy your own load balancer, the Kubernetes cluster will be unreachable after installation. If you deploy any services with `type=LoadBalancer`, the services will also be unreachable until you configure your load balancer.

This configuration assumes you want to leverage a custom load balancer in your cluster. In this case, the workload cluster is deployed without a load balancer. 

1. Create a load balancer configuration using the [New-AksHciLoadBalancerSetting](./reference/ps/new-akshciloadbalancersetting.md) cmdlet and then select `none` for the `loadBalancerSku` parameter:

   ```powershell
   $lbCfg=New-AksHciLoadBalancerSettings -name "myLb" -loadBalancerSku "none" 
   ```
 
2. Deploy a workload cluster without providing the load balancer configuration using the following command:

   ```powershell
   New-AksHciCluster -name "summertime" -nodePoolName mynodepool -nodeCount 2 -OSType linux -nodeVmSize Standard_A4_v2 -loadBalancerSettings $lbCfg 
   ```

3. Use [Get-AksHciCluster](./reference/ps/get-akshcicluster.md) to verify that the cluster is successfully deployed with the control plane nodes running `kube-vip` and that the API server requests are reachable. 

4. Manually configure your load balancer.  

If you run an upgrade, the load balancer configuration (`loadBalancerSku` and `count`) you defined during installation will remain the same after the upgrade completes. However, if you want to update `loadBalancerSku` during an upgrade, you must redeploy your workload clusters. If you have existing clusters running a HAProxy-based load balancer, you can continue running your workloads and the upgrade will successfully complete. 

> [!IMPORTANT]
> If you change from using a custom load balancer to using the default load balancer, you're required to  redeploy your workload cluster with the new load balancer configuration. For instructions on how to configure the default load balancer, see [Configure load balancer](configure-load-balancer.md).  

## Next steps 

To learn more about Kubernetes services, see the [Kubernetes services documentation](https://kubernetes.io/docs/concepts/services-networking/service/). 

 

 