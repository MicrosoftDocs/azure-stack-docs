---
title: Tested resource limits, VM sizes, and regions for AKS hybrid
description: Resource limits, VM sizes, regions for Azure Kubernetes Service (AKS) hybrid deployment options.
author: sethmanheim
ms.topic: conceptual
ms.date: 06/12/2023
ms.author: sethm 
ms.lastreviewed: 02/03/2022
ms.reviewer: mamezgeb
ms.custom: references_regions
#intent: As an IT Pro, I need to understand and also leverage how resource limits, VM sizes, and regions work together for AKS on Azure Stack HCI or Windows Server.
#keyword: Resource limits VM sizes

---

# Resource limits, VM sizes, and regions for AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This article provides information about tested configurations, resource limits, VM sizes, and regions for Azure Kubernetes Service hybrid deployment options (AKS hybrid). The tests used the latest release of AKS on Azure Stack HCI.

## Maximum specifications

AKS on Azure Stack HCI deployments have been validated with the following configurations, including the specified maximums. Keep in mind that exceeding these maximums is at your own risk and might lead to unexpected behaviors and failures. This article provides some guidance on how to avoid common configuration mistakes and can help you create a larger configuration. If in doubt, contact your local Microsoft office for assistance or submit a question in the [Azure Stack HCI community](https://feedback.azure.com/d365community/search/?q=Azure+Kubernetes).

| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 8       |
| Total number of VMs          | 200     |

The recommended limits were tested with the default virtual machine (VM) sizes, based on the following table:

| **System Role** | **VM Size**|
|-------------|---------|
|AKS-Host| **Standard_A4_v2**|
|Target Cluster Control Plane node| **Default**|
|Target Cluster HAProxy load balancer (optional)| **Standard_A4_v2**|
|Target Cluster Linux worker node| **Standard_K8S3_v1**|
|Target Cluster Windows worker node| **Standard_K8S3_v1**|

The hardware configuration of each physical node in the Azure Stack HCI cluster is as follows:

- Chassis: Dell PowerEdge R650 Server or similar
- RAM: RDIMM, 3200MT/s, Dual Rank, total of 256 GB
- CPU: Two (2) Intel Xeon Silver 4316 2.3G, 20C/40T, 10.4GT/s, 30M Cache, Turbo, HT (150 W) DDR4-2666
- Disk: 8x HDDs (2 TB or larger) and 2x 1.6TB NVMe to support S2D storage configurations
- Network: Four (4) 100-Gbit NICs (Mellanox or Intel)

Microsoft engineering has tested AKS hybrid using the above configuration. For single node. 2 node, 4 node and 8 node Windows failover clusters. If you have a requirement to exceed the tested configuration, see [Scaling AKS hybrid on Azure Stack HCI](#scaling-aks-on-azure-stack-hci).

> [!IMPORTANT]  
> When you upgrade a deployment of AKS on Azure Stack HCI, extra resources are temporarily consumed.
> Each virtual machine is upgraded in a rolling update flow, starting with the control plane nodes. For each node in the AKS cluster, a new node VM is created. the old node VM is cordoned off in order to prevent workloads from being deployed to it. The cordoned VM is then drained of all containers to distribute the containers to other VMs in the system.
The drained VM will then be removed from the cluster, shut down, and replaced by the new, updated VM. This process will repeat until all VMs are updated.

## Available VM sizes

The following VM sizes for control plane nodes, Linux worker nodes, and Windows worker nodes are available for AKS on Azure Stack HCI. While VM sizes such as **Standard_K8S2_v1** and **Standard_K8S_v1** are supported for testing and low resource requirement deployments, use these sizes with care and apply stringent testing as they may result in unexpected failures due to out of memory conditions.

| VM Size        | CPU | Memory (GB) | GPU type | GPU count |
| -------------- | ----| ------------| -------- | --------- |
| Default        | 4   | 4           |          |           |
| Standard_A2_v2 | 2   | 4           |          |           |
| Standard_A4_v2 | 4   | 8           |          |           |
| Standard_D2s_v3 | 2   | 8           |          |           |
| Standard_D4s_v3 | 4   | 16          |          |           |
| Standard_D8s_v3 | 8   | 32          |          |           |
| Standard_D16s_v3 | 16  | 64          |          |           |
| Standard_D32s_v3 | 32  | 128         |          |           |
| Standard_DS2_v2 | 2   | 7           |          |           |
| Standard_DS3_v2 | 2   | 14          |          |           |
| Standard_DS4_v2 | 8   | 28          |          |           |
| Standard_DS5_v2 | 16  | 56          |          |           |
| Standard_DS13_v2 | 8   | 56          |          |           |
| Standard_K8S_v1 | 4   | 2           |          |           |
| Standard_K8S2_v1 | 2   | 2           |          |           |
| Standard_K8S3_v1 | 4   | 6           |          |           |
| Standard_NK6     | 6   | 12          | Tesla T4 | 1         |
| Standard_NK12    | 12  | 24          | Tesla T4 | 2         |

## Supported Azure regions for Azure registration

AKS on Azure Stack HCI is supported in the following Azure regions:

- Australia East
- East US
- Southeast Asia
- West Europe

## Scaling AKS on Azure Stack HCI

Scaling an AKS deployment on Azure Stack HCI involves planning ahead by knowing your workloads and target cluster utilization. Additionally, consider hardware resources in your underlying infrastructure such as total CPU cores, total memory, storage, IP Addresses and so on.

The following examples assume that only AKS-based workloads are deployed on the underlying infrastructure. Deploying non-AKS workloads such as stand-alone or clustered virtual machines, or database servers, reduces the resources available to AKS, which you must take into account.

Before you start, consider the following points in order to determine your maximum scale and the number of target clusters you need to support:

- The number of IP addresses you have available for pods in a target cluster.
- The number of IP addresses available for Kubernetes services in a target cluster.
- The number of pods you need to run your workloads.

To determine the size of your Azure Kubernetes Service Host VM, you need to know the number of worker nodes and target clusters, as that determines the size of the AKS Host VM. For example:

- The number of target clusters in the final deployed system.
- The number of nodes, including control plane, load balancer, and worker nodes across all target clusters.

> [!NOTE]
> A single AKS host can only manage target clusters on the same platform.

Also, to determine the size of your target cluster control plane node, you need to know the number of pods, containers, and worker nodes you're planning to deploy in each target cluster.

### Default settings that currently can't be changed in AKS on Azure Stack HCI

There are default configurations and settings currently not available for customer control during or after deployment. These settings may limit the scale for a given target cluster.

- The number of IP addresses for Kubernetes pods in a target cluster is limited to the subnet `10.244.0.0/16`. That is, 255 IP addresses per worker node across all Kubernetes namespaces can be used for pods. To see the pod CIDR assigned to each worker node in your cluster, use the following command in PowerShell:

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

Additional considerations:

- The number of IP addresses for Kubernetes services, outside the VIP pool you've allocated, come from the `10.96.0.0/16` address pool. The system consumes one of the 255 available addresses for the Kubernetes API server.
- The size of the AKS host VM can only be set at installation, when you run **Set-AksHciConfig** for the first time. You can't change it later.
- You can only set the size of target cluster control plane and load balancer VMs at the time of target cluster creation.

### Scale example

The following scaling example is based on these general assumptions/use cases:

- You want to be able to completely tolerate the loss of one physical node in the Azure Stack HCI cluster.
- You want to support upgrading target clusters to newer versions.
- You want to allow for high availability of the target cluster control plane nodes and load balancer nodes, and,
- You want to reserve a part of the overall Azure Stack HCI capacity for these cases.

#### Suggestions

- For optimal performance, make sure to set at least 15 percent (100/8=12.5) of cluster capacity aside to allow all resources from one physical node to be re-distributed to the other seven (7) nodes. This configuration ensures that you have some reserve available to do an upgrade or other AKS on Azure Stack HCI day two operations.

- If you want to grow beyond the 200-VM limit for a maximum hardware sized eight (8) node Azure Stack HCI cluster, increase the size of the AKS Host VM. Doubling in size results in roughly double the number of VMs it can manage. In an eight (8) node Azure Stack HCI cluster, you can get to 8,192 (8x1024) VMs based on the Azure Stack HCI recommended resource limits documented in the [Maximum supported hardware specifications](/azure-stack/hci/concepts/system-requirements#maximum-supported-hardware-specifications). You should reserve ~30% of capacity, which leaves you with a theoretical limit of 5,734 VMs across all nodes.

  - **Standard_D32s_v3**, for the AKS host with 32 cores and 128 GB - could support a maximum of 1,600 nodes. 
  > [!NOTE]
  > Since this has not been tested extensively at this time, it will require a careful approach and validation.

- At a scale like this, you may want to split the environment into at least eight (8) target clusters with 200 worker nodes each.
- To run 200 worker nodes in one target cluster, you can use the default control plane and load balancer size. Depending on the number of pods per node, you may go up at least one size on the control plane and use Standard_D8s_v3.
- Depending on the number of Kubernetes services hosted in each target cluster, you might have to increase the size of the load balancer VM as well at target cluster creation to ensure that services can be reached with high-performance and traffic is routed accordingly.

The deployment of AKS on Azure Stack HCI will distribute the worker nodes for each node pool in a target cluster across the available Azure Stack HCI nodes using the Azure Stack HCI placement logic.

> [!IMPORTANT]
> The node placement is not preserved during platform and AKS upgrades and will change over time. A failed physical node will also impact the distribution of virtual machines across the remaining cluster nodes.

> [!NOTE]
> Do not run more than four (4) target cluster creations at the same time if the physical cluster is already 50 percent full, as that could lead to temporary resource contention. 
> When scaling up target cluster node pools by large numbers, take into account available physical resources, as AKS on Azure Stack HCI does not verify resource availability for parallel running creation/scaling processes. 
> Always ensure enough reserve to allow for upgrades and failover. Especially in very large environments, these operations, when run in parallel, can lead to rapid resource exhaustion.

If in doubt, contact your local Microsoft office for assistance or post in the [Azure Stack HCI community forum](https://feedback.azure.com/d365community/search/?q=Azure+Kubernetes).

## Next steps

- [Storage options](./concepts-storage.md)
