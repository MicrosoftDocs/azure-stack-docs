---
title: Tested resource limits, VM sizes, and regions on Azure Stack HCI
description: Tested resource limits, VM sizes, and regions in AKS on Azure Stack HCI
author: mattbriggs
ms.topic: conceptual
ms.date: 04/11/2022
ms.author: mabrigg 
ms.lastreviewed: 02/03/2022
ms.reviewer: mamezgeb
ms.custom: references_regions

# Intent: As an IT Pro, I need to understand and also leverage how resource limits, VM sizes, and regions work together in AKS on Azure Stack HCI.
# Keyword: vm sizes

---

# Tested resource limits, VM sizes, and regions on Azure Stack HCI

In this article, you can find information about tested resource limits, VM sizes, and regions on Azure Stack HCI for Azure Kubernetes Service on Azure Stack HCI.
## Maximum specifications

Azure Kubernetes Service on Azure Stack HCI deployments 's been validated with the following configurations, including the specified maximums. Keep in mind that exceeding these maximums is at your own risk and might lead to unexpected behaviors and failures. This article provides some guidance on how to avoid common configuration mistakes and can help you create a larger configuration. If in doubt, contact your local Microsoft office for assistance or submit a question in the [Azure Stack HCI community](https://feedback.azure.com/d365community/search/?q=Azure+Kubernetes).


| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 8       |
| Total number of VMs          | 200     |

The limits have been tested with the default virtual machine (VM) sizes, based on the following table:
- AKS-Host: **Standard_A4_v2**
- Target Cluster Control Plane: **Default**
- Target Cluster load balancer: **Standard_A4_v2**
- Target Cluster Linux Node: **Standard_K8S3_v1**
- Target Cluster Windows Node: **Standard_K8S3_v1**

The hardware configuration of each node in the Azure Stack HCI cluster is as follows:
- Chassis: Dell PowerEdge R650 Server or similar
- RAM: RDIMM, 3200MT/s, Dual Rank, total of 256 GB
- CPU: Two (2) Intel Xeon Silver 4316 2.3G, 20C/40T, 10.4GT/s, 30M Cache, Turbo, HT (150 W) DDR4-2666
- Disk: 8x HDDs (2 TB or larger) and 2x 1.6TB NVMe to support S2D storage configurations
- Network: Four (4) 100-Gbit NICs (Mellanox or Intel)

Microsoft engineering has tested these configurations. If you want to exceed the tested configurations, see [Scaling AKS on Azure Stack HCI](#scaling-aks-on-azure-stack-hci).

> [!IMPORTANT]  
> When you upgrade a deployment of Azure Kubernetes Service on Azure Stack HCI, extra resources are temporarily consumed.
> 
> Each VM is upgraded in a rolling update, starting with the control plane nodes. For each VM, a new VM is created before the old VM is cordoned off in order to prevent workloads from being deployed to it. The cordoned VM is then drained of all containers to distribute the containers to other VMs in the system.
The drained VM will then be removed from the cluster, shut down, and replaced by the new, updated VM. This process will repeat until all VMs are updated. 

## Validated VM sizes

The following VM sizes for control plane nodes, Linux worker nodes, and Windows worker nodes have been tested for Azure Kubernetes Service on Azure Stack HCI. While VM sizes such as **Standard_K8S2_v1** and **Standard_K8S_v1** are supported, you may not want to use these sizes as they may result in unexpected failures due to out of memory issues.

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
- Australia East
- East US
- Southeast Asia
- West Europe

## Scaling AKS on Azure Stack HCI
Scaling AKS on Azure Stack HCI involves planning ahead and knowing what your workloads and target cluster needs will look like. Additionally, consider what your available hardware resources will look like on your Azure Stack HCI or Windows Server cluster.

Before you start, consider the following in order to determine your maximum scale and the number of target clusters you'll need to support:

 - The number of IP addresses you have available for pods in a target cluster.
 - The number of IP addresses available for Kubernetes services in a target cluster.
 - The number of pods you'll need to run your workloads.

To determine the size of your Azure Kubernetes Services Host VM, you'll need to know the number of worker nodes and target clusters, as that determines the size of the AKS Host VM. For example:
 - The number of target clusters in the final deployed system
 - The number of nodes, including control plane, load balancer and worker nodes across all target clusters.

Also, to determine the size of your target cluster control plane node, you'll need to know the number of pods, containers and worker nodes you're planning to deploy.
 
### Default settings that currently can't be changed in AKS on Azure Stack HCI

Keep in mind that there are many default configurations and settings currently not available for customer control  during or after deployment. These settings may also limit how far you can scale a given target cluster.

 - The number of IP addresses for Kubernetes pods in a target cluster is limited to the subnet `10.244.0.0/16`. That is 255 IP addresses per worker node across all Kubernetes namespaces can be used for pods. To see the pod CIDR assigned to each worker node in your cluster, use the following command in PowerShell:

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

In the example, you can see three (3) nodes with three (3) CIDRs, each capable of hosting 254 pods. The Kubernetes scale documentation recommends that you don't exceed 110 pods per node for performance reasons (see [Considerations for large clusters](https://kubernetes.io/docs/setup/best-practices/cluster-large/).

In addition:

 - The number of IP addresses for Kubernetes services, outside of the VIP pool you've allocated, come from the `10.96.0.0/16` address pool. The system consumes one (1) address out of the 255 available addresses for the Kubernetes API server.

 - The size of the AKS Host VM can only be set at installation time when you run **Set-AksHciConfig** for the first time. You can't change it later.
 
 - The size of target cluster control plane and load balancer VMs can only be set at target cluster creation.

### Scale example

The following scaling example is based on these general assumptions/use cases: 
 - You want to be able to completely tolerate the loss of one physical node in the Azure Stack HCI cluster.
 - You want to support upgrading target clusters to newer versions.
 - You want to allow for high availability of the target cluster control plane nodes and load balancer nodes, and, 
 -  You want to reserve a part of the overall Azure Stack HCI capacity for these cases.

**Suggestions:**

 - For optimal performance, make sure to set at least 15% (100/8=12.5) of cluster capacity aside to allow all resources from one physical node to be re-distributed to the other seven (7) nodes. This ensures you will have some reserve available to do an upgrade or other AKS on Azure Stack HCI day two (2) operations.

 - If you want to grow beyond the 200 VM limit for a maximum hardware sized eight (8) node Azure Stack HCI clusters, then increase the size of the AKS Host VM. Doubling in size will result in roughly double the number of VMs. In an eight (8) node Azure Stack HCI cluster, you can get to 8,192 (8x1024) VMs based on the Azure Stack HCI recommended resource limits documented in the [Maximum supported hardware specifications](/azure-stack/hci/concepts/system-requirements#maximum-supported-hardware-specifications). You'll want to reserve ~30% of capacity, which leaves you with a theoretical limit of 5,734 VMs across all nodes.

 - The largest available VM size in AKS on Azure Stack HCI **Standard_D32s_v3** with 32 cores and 128 GB could support a maximum of 1,600 nodes. Since this hasn't been tested at this time, it will require a careful approach. 

 - At a scale like this, you may want to split the environment into at least eight (8) target clusters with 200 worker nodes each.

 - To run 200 worker nodes in one target cluster, you can use the default control plane and load balancer size. Depending on the number of pods per node, you may go up at least one size on the control plane.

 - Depending on the number of Kubernetes services hosted in each target cluster, you might have to increase the size of the load balancer VM as well at target cluster creation to ensure that services can be reached with high-performance and traffic is routed accordingly.

The deployment of AKS on Azure Stack HCI will distribute the worker nodes for each node pool in a target cluster across the available Azure Stack HCI nodes using the Azure Stack HCI placement logic. 

> [!Note]  
> Do not run more than four (4) target cluster creations at the same time if the physical cluster is already 50% full, as that that could lead to temporary resource contention. 
> When scaling up target cluster node pools by large numbers, take into account available physical resources, as AKS on Azure Stack HCI does not verify resource availability for parallel running creation/scaling processes. 
> Always ensure enough reserve to allow for upgrades and failover. Especially in very large environments these operations, when run in parallel, can lead to rapid resource exhaustion.

If in doubt, contact your local Microsoft office for assistance or post in the AKS in the [Azure Stack HCI community](https://feedback.azure.com/d365community/search/?q=Azure+Kubernetes).

## Next steps
- [Storage options](./concepts-storage.md)
