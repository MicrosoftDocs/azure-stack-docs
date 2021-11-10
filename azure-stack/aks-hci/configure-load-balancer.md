---
title: Create and use a custom load balancer with Azure Kubernetes Service (AKS) on Azure Stack HCI
description: Learn how to create and use a custom load balancer with Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: baziwane
ms.topic: how-to
ms.date: 11/10/2021
ms.author: rbaziwane
---

# Create and use a custom load balancer

In this article, you'll learn how to create and use a custom load balancer with Azure Kubernetes Service (AKS) on Azure Stack HCI.  

In AKS on Azure Stack HCI, you use load balancers to send requests to the Kubernetes API server and to manage traffic to application services. You can also create and use a custom load balancer, such as MetalLB or SDN load balancer, to load balance traffic to application services.  

## Before you begin 

This article assumes you have AKS on Azure Stack HCI installed and have provided a range of virtual IP addresses during the installation.  

> [!NOTE]
> When using a custom load balancer, [kube-vip](https://kube-vip.io/) automatically deploys to manage the load balancing of requests to the Kubernetes API server and to make sure that it's highly available. 

## Configure a custom load balancer 

> [!IMPORTANT]
> If you choose to deploy your own load balancer, it will make your Kubernetes cluster unreachable after installation. If you deploy any services with `type=LoadBalancer`, the services will be unreachable until you configure your load balancer.

This configuration assumes you want to leverage a custom load balancer in your AKS on Azure Stack HCI cluster. In this case, the workload cluster is deployed without a load balancer. 

1. Create a load balancer configuration using the `New-AksHciLoadBalancerSettings` cmdlet and then select `none` for the `loadBalancerSku` parameter:

   ```powershell
   $lbCfg=New-AksHciLoadBalancerSettings-Name "myLb" -loadBalancerSku "none" 
   ```
 
2. Deploy a workload cluster without providing the load balancer configuration:

   ```powershell
   New-AksHciCluster -Name "summertime" -nodePoolName mynodepool -nodeCount 2 -OSType linux -nodeVmSize Standard_A4_v2 -loadBalancerSettings $lbCfg 
   ```

3. Verify that the cluster is successfully deployed with the control plane nodes running `kube-vip` and that the API server requests are reachable. 

4. Manually configure your load balancer.  

During upgrades, customers should expect the load balancer configuration (`loadBalancerSku` and `count`) that were previously defined during installation will be the same configuration deployed when the upgrade completes. Customers with existing clusters running a HAProxy-based load balancer should continue running their workloads and upgrade successfully. Customers who want to update `loadBalancerSku` during an upgrade are required to redeploy their workload clusters. 

> [!IMPORTANT]
> If you change from using a custom load balancer to using the standard load balancer, you're required to  redeploy your workload cluster with the desired load balancer configuration. For standard load balancer integration, see < link to configure the standard load balancer documentation >.  

## Next Steps 

To learn more about Kubernetes services, see the [Kubernetes services documentation](https://kubernetes.io/docs/concepts/services-networking/service/). 

 

 