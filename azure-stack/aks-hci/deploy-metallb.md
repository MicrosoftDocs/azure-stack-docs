---
title: Deploy MetalLB for load balancing in Azure Kubernetes Service (AKS) on Azure Stack HCI
description: Learn how to deploy MetalLB for load balancing in Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: baziwane
ms.topic: how-to
ms.date: 11/23/2021
ms.author: rbaziwane
---

# Deploy MetalLB for load balancing on Azure Kubernetes Service (AKS) on Azure Stack HCI

In the November Update of AKS on Azure Stack HCI, support was added to allow users to configure custom load balancers for their workload clusters. Previously, customers did not have the flexibility to configure different load balancers on AKS on Azure Stack HCI. The default behavior remains the same: a virtual machine that runs Mariner Linux and [HAProxy](http://www.haproxy.org/) is automatically created. The HAProxy ensures high availability (HA) for requests to the Kubernetes API server and load balancing for Kubernetes services of *type=LoadBalancer*. With the added support for configuring a custom load balancer, the task of ensuring high availability of the API server requests shifts to [*kube-vip*](https://kube-vip.io/), which will be automatically deployed in each worker node when you use this option. 

Providing customers with the flexibility to deploy custom load balancing configurations is important because it: 

1. Guarantees that AKS on Azure Stack HCI works alongside existing customer deployments, such as Software Defined Network (SDN) deployments that use Software Load Balancers.
2. Enhances the platform with additional flexibility, and therefore, unlocks a myriad of potential use cases for customers.

This article explains how this feature works and includes an example of how to use [MetalLB](https://metallb.org/) for load balancing services in a workload cluster.

## Before you begin

Verify that you have the following set up:

- An [AKS on Azure Stack HCI cluster](setup.md) with at least one Linux worker node that's up and running.
- [Helm v3](https://helm.sh/docs/intro/install/) command line with the prerequisites installed.
- A range of virtual IP (VIP) addresses to assign to load balancer services.

> [!IMPORTANT]
> Ensure that there is no overlap between the VIP address range provided during installation of AKS on Azure Stack HCI and the IP address range to be used for your custom load balancer.

## Create a workload cluster with no load balancer

1. Create a load balancer using the [New-AksHciLoadBalancerSetting](./reference/ps/new-akshciloadbalancersetting.md) command and then select `none` for `-loadBalancerSku`. 

   ```powershell
   $lbCfg=New-AksHciLoadBalancerSetting -Name "myLb" -loadBalancerSku "none" 
   ```

2. Deploy a workload cluster without providing the `loadBalancer` configuration: 

   ```powershell
   New-AksHciCluster -Name <myclustername> -nodePoolName mynodepool -nodeCount 2 -OSType linux -nodeVmSize Standard_A4_v2 -loadBalancerSettings $lbCfg 
   ```

## Verify the control plane is reachable

When you deploy an AKS cluster with no load balancer, you still need to make sure that the Kubernetes API server is reachable. Since [kube-vip](https://kube-vip.io/) is automatically deployed to handle requests to the API server, you can still perform cluster operations immediately. 

1. Make sure you have configured your local `kubectl` environment to point to your AKS on Azure Stack HCI cluster. You can use the [Get-AksHciCredential](./reference/ps/get-akshcicredential.md) PowerShell command to access your cluster using `kubectl`.

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

1. Create a new namespace (for example, `metallb-system`) on which you'll create MetalLB resources:

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

To verify that applications are reachable, deploy a demo application and check that your application has an external IP address:

```bash
NAME                     TYPE           CLUSTER-IP     EXTERNAL-IP    PORT(S)        AGE
service/kubernetes       ClusterIP      10.96.0.1      <none>         443/TCP        10d
service/poemfinder-app   LoadBalancer   10.100.14.70   10.193.2.150   80:32737/TCP   43s
```

## Next steps

- Learn more about [Network concepts for deploying AKS nodes on Azure Stack HCI](./concepts-node-networking.md).