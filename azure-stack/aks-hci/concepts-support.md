---
title: Concepts - Supported resource limits, VM sizes, and regions in AKS on Azure Stack HCI
description: Supported resource limits, VM sizes, and regions in AKS on Azure Stack HCI
author: mattbriggs
ms.topic: conceptual
ms.date: 05/20/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: mamezgeb
ms.custom: references_regions

---

# Supported resource limits, VM sizes, and regions
## Maximum supported specifications
Azure Kubernetes Service on Azure Stack HCI deployments that exceed the following specifications are not supported:

| Resource                     | Maximum |
| ---------------------------- | --------|
| Physical servers per cluster | 4       |
| Kubernetes Clusters          | 4       |
| Total number of VMs          | 200     |

> [!IMPORTANT]
> When you upgrade a deployment of Azure Kubernetes Service on Azure Stack HCI, extra resources are temporarily consumed.
> 
> Each VM is upgraded in a rolling update, starting with the control plane nodes. For each VM, a new VM is created before the old VM is cordoned off
to prevent workloads from being deployed to it. The cordoned VM is then drained of all containers to distribute the containers to other VMs in the system.
The drained VM will then be removed from the cluster, shut down, and replaced by the new, updated VM. This process will repeat until all VMs are updated. 

## Supported VM sizes
Azure Kubernetes Service on Azure Stack HCI supports the following VM sizes for control plane nodes, Linux worker nodes, and Windows worker nodes. While we currently do support VM sizes like `Standard_K8S2_v1` and `Standard_K8S_v1` we do not recommend using it as it may result in unexpected failures due to out of memory issues.

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

## Next steps
- [Storage options](./concepts-storage.md)
