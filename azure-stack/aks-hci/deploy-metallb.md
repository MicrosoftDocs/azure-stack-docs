---
title: Deploy MetalLB for load balancing in Azure Kubernetes Service on Azure Stack HCI
description: Learn how to deploy MetalLB for load balancing in Azure Kubernetes Service on Azure Stack HCI and Windows Server.
author: sethmanheim
ms.topic: how-to
ms.date: 06/27/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: rbaziwane
# Intent: As an IT Pro, I want to learn how to use MetalLB so that I can configure custom load balancers for my workload clusters.
# Keyword: MetalLB load balancers workload cluster
---

# Deploy MetalLB for load balancing on Azure Kubernetes Service on Azure Stack HCI and Windows Server

In the November update of Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server, we added support to allow users to configure custom load balancers for their workload clusters. Previously, users didn't have the flexibility to configure different load balancers on AKS on Azure Stack HCI and Windows Server. 

The default behavior remains the same: a virtual machine that runs Mariner Linux and [HAProxy](http://www.haproxy.org/) is automatically created. The HAProxy ensures high availability for requests to the Kubernetes API server, and load balances Kubernetes services of *type=LoadBalancer*. 

The added support for configuring a custom load balancer shifts the task of ensuring high availability of the API server requests to [*kube-vip*](https://kube-vip.io/), which is then automatically deployed in each worker node. 

Providing users with the flexibility to deploy custom load balancing configurations is important because it: 

- Guarantees that AKS on Azure Stack HCI and Windows Server works alongside existing deployments such as Software Defined Network (SDN) deployments that use Software Load Balancers.
- Enhances the platform with additional flexibility, unlocking a myriad of potential use cases.

This article explains how this feature works and includes an example of how to use [MetalLB](https://metallb.org/) for load balancing services in a workload cluster.

## Before you begin

Verify that you have set up the following requirements:

- An [AKS on Azure Stack HCI and Windows Server cluster](setup.md) with at least one Linux worker node that's up and running.
- [Helm v3](https://helm.sh/docs/intro/install/) command line with the prerequisites installed.
- A range of virtual IP (VIP) addresses to assign to load balancer services.

> [!IMPORTANT]
> Ensure that there is no overlap between the VIP address range provided during installation of AKS on Azure Stack HCI and Windows Server and the IP address range to be used for your custom load balancer.

## Create a workload cluster with no load balancer

1. Use the [New-AksHciLoadBalancerSetting](./reference/ps/new-akshciloadbalancersetting.md) command to create a load balancer and then select `none` for the `-loadBalancerSku` parameter: 

   ```powershell
   $lbCfg=New-AksHciLoadBalancerSetting -Name "myLb" -loadBalancerSku "none" 
   ```

2. Deploy a workload cluster without providing the `loadBalancer` configuration: 

   ```powershell
   New-AksHciCluster -Name <myclustername> -nodePoolName mynodepool -nodeCount 2 -OSType linux -nodeVmSize Standard_A4_v2 -loadBalancerSettings $lbCfg 
   ```

## Verify the control plane is reachable

A *control plane* refers to the management of resources in your subscription. When you deploy an AKS cluster with no load balancer, you need to make sure that the Kubernetes API server is reachable. Since [kube-vip](https://kube-vip.io/) is automatically deployed to handle requests to the API server, you can still immediately perform cluster operations. 

Follow these steps to verify that the control plane is reachable: 

1. Configure your local `kubectl` environment to point to your AKS on Azure Stack HCI and Windows Server cluster. You can use the [Get-AksHciCredential](./reference/ps/get-akshcicredential.md) PowerShell command to access your cluster using `kubectl`.

2. Run `kubectl get nodes` and verify that you get a response from the API server.

   ```bash
   NAME              STATUS   ROLES                  AGE   VERSION   INTERNAL-IP    EXTERNAL-IP   OS-IMAGE            KERNEL-VERSION    CONTAINER-RUNTIME
   moc-lm05pe3lxo7   Ready    <none>                 10d   v1.20.7   10.193.2.137   <none>        CBL-Mariner/Linux   5.10.74.1-1.cm1   containerd://1.4.4
   moc-lqk0zvnqi7e   Ready    <none>                 10d   v1.20.7   10.193.2.138   <none>        CBL-Mariner/Linux   5.10.74.1-1.cm1   containerd://1.4.4
   moc-lvqhjz0jki9   Ready    <none>                 10d   v1.20.7   10.193.2.139   <none>        CBL-Mariner/Linux   5.10.74.1-1.cm1   containerd://1.4.4
   moc-lw2odjpmzq2   Ready    control-plane,master   10d   v1.20.7   10.193.2.135   <none>        CBL-Mariner/Linux   5.10.74.1-1.cm1   containerd://1.4.4
   ```

## Deploy MetalLB for load balancing

With the AKS cluster deployed, configure MetalLB to handle traffic for Kubernetes services of `type=Loadbalancer`.

1. Create a new namespace `metallb-system` on which you'll create MetalLB resources:

   ```powershell
   kubectl create namespace metallb-system
   ```

2. Add the virtual IP address range to a `values.yaml` configuration file:

   ```yaml
   configInline:
     address-pools:
     - name: default
       protocol: layer2
       addresses:
       - 10.193.2.150-10.193.2.169
   ```

3. Install MetalLB using Helm:

   ```powershell
   helm install metallb metallb/metallb -f values.yaml --namespace metallb-system
   ```

## Verify the applications are reachable

To verify that applications are reachable, deploy a demo application and then check that your application has an external IP address:

```bash
NAME                     TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)        AGE
service/kubernetes       ClusterIP      10.96.0.1      <none>         443/TCP        10d
service/poemfinder-app   LoadBalancer   10.100.14.70   10.193.2.150   80:32737/TCP   43s
```

## Next steps

- Learn more about [Network concepts for deploying AKS nodes on Azure Stack HCI](./concepts-node-networking.md).