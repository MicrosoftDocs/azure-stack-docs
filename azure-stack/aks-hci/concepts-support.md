---
title: Concepts - Supported resource limits, VM sizes, and regions in AKS on Azure Stack HCI
description: Supported resource limits, VM sizes, and regions in AKS on Azure Stack HCI
author: mattbriggs
ms.topic: conceptual
ms.date: 02/03/2021
ms.author: mabrigg 
ms.lastreviewed: 02/03/2021
ms.reviewer: mamezgeb
ms.custom: references_regions

---

# Supported resource limits, VM sizes, and regions
## Maximum supported specifications

Azure Kubernetes Service on Azure Stack HCI deployments have been validated with the following configuration and up to the specified maximums. Exceeding these maximums is at your own risk and might lead to unexpected behaviors and failures. This article provides some guidance to avoid common configuration mistakes and can help creating a larger configuration. If in doubt, contact your local Microsoft office for assistance or post in the AKS in the [Azure Stack HCI community](https://feedback.azure.com/d365community/search/?q=Azure+Kubernetes).

| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 8       |
| Total number of VMs          | 200     |

The limits are tested with the default virtual machine (VM) sizes based on the following table:
- AKS-Host: **Standard_A4_v2**
- Target Cluster Control Plane: Default
- Target Cluster load balancer: **Standard_A4_v2**
- Target Cluster Linux Node: **Standard_K8S3_v1**
- Target Cluster Windows Node: **Standard_K8S3_v1**

The hardware configuration of each node in the Azure Stack HCI cluster is as follows:
- Chassis: Dell PowerEdge R650 Server or similar
- RAM: RDIMM, 3200MT/s, Dual Rank Total of 256 GB
- CPU: Two (2) Intel Xeon Silver 4316 2.3G, 20C/40T, 10.4GT/s, 30M Cache, Turbo, HT (150 W) DDR4-2666
- Disk: One (1) TB SSD (System), 1.2 TB HDD (Storage)
- Network: Four (4) 100-Gbit NICs (Mellanox or Intel)

Microsoft engineering has tested the configuration. If you want to go,  exceed the tested configuration, see [Scaling AKS on Azure Stack HCI](#scaling-aks-on-azure-stack-hci).

> [!IMPORTANT]  
> When you upgrade a deployment of Azure Kubernetes Service on Azure Stack HCI, extra resources are temporarily consumed.
> 
> Each VM is upgraded in a rolling update, starting with the control plane nodes. For each VM, a new VM is created before the old VM is cordoned off to prevent workloads from being deployed to it. The cordoned VM is then drained of all containers to distribute the containers to other VMs in the system.
The drained VM will then be removed from the cluster, shut down, and replaced by the new, updated VM. This process will repeat until all VMs are updated. 

## Supported VM sizes

Azure Kubernetes Service on Azure Stack HCI supports the following VM sizes for control plane nodes, Linux worker nodes, and Windows worker nodes. While VM sizes such as **Standard_K8S2_v1** and **Standard_K8S_v1** are supported, you may not want to use these sizes as they may result in unexpected failures due to out of memory issues.

| VM Size        | CPU | Memory (GB) |
| -------------- | ----| ------------|
| Default        | 4   | 4           |
| Standard_A2_v2 | 2   | 4           |
| Standard_A4_v2 | 4   | 8           |
| Standard_D2s_v3 | 2   | 8           |
| Standard_D4s_v3 | 4   | 16          |
| Standard_D8s_v3 | 8   | 32          |
| Standard_D16s_v3 | 16  | 64          |
| Standard_D32s_v3 | 32  | 128         |
| Standard_DS2_v2 | 2   | 7           |
| Standard_DS3_v2 | 2   | 14          |
| Standard_DS4_v2 | 8   | 28          |
| Standard_DS5_v2 | 16  | 56          |
| Standard_DS13_v2 | 8   | 56          |
| Standard_K8S_v1 | 4   | 2           |
| Standard_K8S2_v1 | 2   | 2           |
| Standard_K8S3_v1 | 4   | 6           |


## Supported Azure regions for Azure registration
Azure Kubernetes Service on Azure Stack HCI supports the following Azure regions:
- East US
- Southeast Asia
- West Europe

## Scaling AKS on Azure Stack HCI
Scaling AKS on Azure Stack HCI involves planning ahead and knowing what your workloads and target cluster needs will look like as well as what your available hardware resources will look like on your Azure Stack HCI or Windows Server cluster.

Consider the following before you start the exercise of determining your maximum scale.

To determine the number of target clusters you need to support, consider the following: 
1. Number of IP addresses you have available for pods in a target cluster.
2. Number of IP addresses available for Kubernetes services in a target cluster.
3. Number of pods you'll need to run your workloads.

To determine the size of your Azure Kubernetes Services Host VM, you'll need to know the number of worker nodes and target clusters as that determines the size of the AKS Host VM.
1. Number of target clusters in the final deployed system
2. Number of nodes including control plane, load balancer and worker nodes across all target clusters.

To determine the size of your target cluster control plane node you'll need to know the number of pods, containers and worker nodes you're planning to deploy:
1. Number of pods.
2. Number of containers.
3. Number of worker nodes in a target cluster.

### Default settings that currently can't be changed in AKS on Azure Stack HCI

There are many default configurations and settings that are currently not exposed to be controlled by the customer during or after deployment. These will also limit how far you can scale a given target cluster.

1. The number of IP addresses for Kubernetes pods in a target cluster is limited to the subnet `10.244.0.0/16`. That is 255 IP addresses per worker node across all Kubernetes namespaces can be used for pods. To see the pod CIDR assigned to each worker node in your cluster use the following command in PowerShell:

```powershell
kubectl get nodes -o json | findstr 'hostname podCIDR'
```

``` json
                    "kubernetes.io/hostname": "moc-lip6cotjt0f",
                                "f:podCIDR": {},
                                "f:podCIDRs": {
                                    "f:kubernetes.io/hostname": {},
                "podCIDR": "10.244.2.0/24",
                "podCIDRs": [
                    "kubernetes.io/hostname": "moc-lmb6zqozk4m",
                                "f:podCIDR": {},
                                "f:podCIDRs": {
                                    "f:kubernetes.io/hostname": {},
                "podCIDR": "10.244.4.0/24",
                "podCIDRs": [
                    "kubernetes.io/hostname": "moc-wgwhhijxtfv",
                                "f:podCIDR": {},
                                "f:podCIDRs": {
                                    "f:kubernetes.io/hostname": {},
                "podCIDR": "10.244.5.0/24",
                "podCIDRs": [
```

In the example you can see three (3) nodes with three (3) CIDRs each capable of hosting 253 pods. The Kubernetes scale documentation recommends that you don't exceed 110 pods per node for performance reasons (see [Considerations for large clusters](https://kubernetes.io/docs/setup/best-practices/cluster-large/)).

1. The number of IP addresses for Kubernetes services, outside of the VIP pool you've allocated, these come from the `10.96.0.0/16` address pool and the system consumes one (1) address out of the 255 available addresses for the Kubernetes API server.

1. The size of the AKS Host VM can only be set at installation time when you run **Set-AksHciConfig** for the first time. It can't be changed later.

1. The size of target cluster control plane and load balancer VMs can only be set at target cluster creation.

### Scale example

As stated earlier in this article, the tested configuration is eight (8) Azure Stack HCI nodes and with all default settings this can comfortably handle AKS on Azure Stack HCI with a total of 200 VMs. This assumes that there are no other VM based workloads on the Azure Stack HCI cluster.

Assuming you want to be able to completely tolerate the loss of one physical node in the Azure Stack HCI cluster, support upgrading target clusters to newer versions and also allow for high availability of the target cluster control plane nodes and load balancer nodes.

Based on this assumption, you need to reserve ~30% of the overall cluster capacity for failover and updates. 15% for the loss of one physical node and 15% to still allow for AKS on Azure Stack HCI updates, scaling, and further failovers if needed should it take longer to recover the failed Azure Stack HCI node.

If you want to grow beyond the 200 VM limit for a maximum hardware sized eight (8) node Azure Stack HCI clusters increase the size of the AKS Host VM. Doubling in size gets roughly double the number of VMs. In an eight (8) node Azure Stack HCI cluster, you can get to 8,192 (8x1024) VMs based on the Azure Stack HCI recommended resource limits documented in the [Maximum supported hardware specifications](/azure-stack/hci/concepts/system-requirements#maximum-supported-hardware-specifications). You'll want to reserve ~30% of capacity, which leaves you with a theoretical limit of 5,734 VMs across all nodes.

The largest available VM size in AKS on Azure Stack HCI **Standard_D32s_v3** with 32 cores and 128 GB could support a maximum of 1,600 nodes. This hasn't been tested at this time. This will require a careful approach. 

At a scale like this, you may want to split the environment into at least eight (8) target clusters with 200 worker nodes each.

To run 200 worker nodes in one target cluster, you can use the default control plane and load balancer size. Depending on the number of pods per node, you may go up at least one size on the control plane.

Depending on the number of Kubernetes services hosted in each target cluster, you might have to increase the size of the load balancer VM as well at target cluster creation to ensure that services can be reached with high-performance and traffic is routed accordingly.

The deployment of AKS on Azure Stack HCI will distribute the worker nodes for each node pool in a target cluster across the available Azure Stack HCI nodes using the Azure Stack HCI placement logic. 

>![Note]  
> Do not try to run more than four (4) target cluster creations at the same time if the physical cluster is already 50% full as that that could lead to temporary resource contention. 
> When scaling target cluster node pools up by large numbers while creating target clusters take into account available physical resources as AKS on Azure Stack HCI does not verify resource availability for parallel running creation/scaling processes. 
> Always ensure enough reserve to allow for upgrades and failover. Especially in very large environments these operations, when run in parallel, can lead to rapid resource exhaustion.

If in doubt, contact your local Microsoft office for assistance or post in the AKS in the [Azure Stack HCI community] (https://feedback.azure.com/d365community/search/?q=Azure+Kubernetes).

## Next steps
- [Storage options](./concepts-storage.md)