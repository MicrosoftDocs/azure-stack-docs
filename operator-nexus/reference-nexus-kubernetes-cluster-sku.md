---
title: Azure Operator Nexus Kubernetes cluster Virtual Machine SKUs
description: Learn about Azure Operator Nexus Kubernetes cluster SKUs
author: eak13
ms.author: ekarandjeff
ms.service: azure-operator-nexus
ms.topic: reference
ms.date: 01/07/2026
ms.custom: template-reference
---

# Azure Operator Nexus Kubernetes cluster VM SKUs

The Azure Operator Nexus Kubernetes cluster virtual machines (VM) are grouped into node pools, which are collections of VMs that have the same configuration. The VMs in a node pool are used to run your Kubernetes workloads. The Azure Operator Nexus Kubernetes cluster supports the following VM stock keeping units (SKUs). These SKUs are available in all Azure regions where the Azure Operator Nexus Kubernetes cluster is available.

## SKU types and characteristics

There are four types of VM SKUs:

* General purpose
* Performance optimized
* Memory optimized
* Storage optimized

The primary difference between general-purpose and performance-optimized types of VMs is their approach to emulator thread isolation. VM SKUs optimized for performance have dedicated emulator threads, which allow each VM to operate at maximum efficiency. Conversely, general-purpose VM SKUs have emulator threads that run on the same processors as applications running inside the VM. For application workloads that can't tolerate other workloads sharing their processors, we recommend using the performance-optimized SKUs. Memory-optimized SKUs allow application workloads with large memory requirements to access resources from both nonuniform memory access (NUMA) cells within the physical machine. As these SKUs are highly resource intensive, the recommendation is to use a smaller SKU if suitable for the application workload. Storage-optimized SKUs enable Kubernetes nodes to allocate up to 1.6 TiB of local disk space for workloads that need more storage than the standard 300 GiB allocated by other SKUs.

The general purpose and performance optimized VM SKUs can be used for both worker and control plane nodes within the Azure Operator Nexus Kubernetes cluster. Memory optimized VM SKUs can only be used for worker nodes.

### Common characteristics for all SKU types

* Hugepages enabled (1Gi).
* Dedicated host-to-VM CPU placement.
* Two threads per core (hyperthreading).
* CPUs 0 and 1 reserved for kubelet (except for NC_G2_8_v1 and NC_P4_28_v1).

### General Purpose (G-type) SKUs

* **Purpose**: Standard production workloads.
* **Differentiating characteristics**:
  * Emulator threads share CPU with applications.
* **Use cases**: Control plane and worker nodes.

### Performance Optimized (P-type) SKUs

* **Purpose**: High-performance workloads requiring maximum efficiency.
* **Differentiating characteristics**:
  * Isolated emulator threads for maximum performance.
* **Use cases**: Latency-sensitive applications. Used for control plane and worker nodes.

### Memory Optimized (E-type) SKUs - Cross-NUMA

* **Purpose**: Large memory requirements
* **Differentiating characteristics**:
  * Access memory from both NUMA cells on physical machine.
  * Highly resource intensive (336-448 GiB memory).
  * Isolated emulator threads for maximum performance.
* **Use cases**: Recommended for worker nodes with intensive processing requirements. Not recommended for control plane nodes.
* **Note**: Use smaller SKUs if workload fits to avoid resource waste.

### Storage Optimized (L-type) SKUs

* **Purpose**: Workloads requiring large local disk space.
* **Differentiating characteristics**:
  * Root disk of **1638Gi** (vs standard 300Gi).
  * 224-GiB memory.
  * Isolated emulator threads for maximum performance.
* **Use Cases**: Data-intensive applications, log aggregation, local caching.

### Configuration matrix by SKU type

| Property                  | G-type    | P-type    | E-type    | L-type     |
|---------------------------|-----------|-----------|-----------|------------|
| **hugepageSize**          | `"1Gi"`   | `"1Gi"`   | `"1Gi"`   | `"1Gi"`    |
| **dedicatedCPUPlacement** | `true`    | `true`    | `true`    | `true`     |
| **isolateEmulatorThread** | `false`   | `true`    | `true`    | `true`     |
| **threadsPerCore**        | `2`       | `2`       | `2`       | `2`        |
| **kubeletReservedCPUs**   | `[0, 1]`  | `[0, 1]`  | `[0, 1]`  | `[0, 1]`   |
| **root disk**             | `"300Gi"` | `"300Gi"` | `"300Gi"` | `"1638Gi"` |

## SKU naming conventions

SKU names follow the pattern: `NC_{type}{cores}_{memory}_v{version}`

Where:

* **Type**: `G` (General), `P` (Performance), `E` (Memory), `L` (Storage)
* **Cores**: Number of vCPUs (actual cores × threadsPerCore)
* **Memory**: Memory in GiB
* **Version**: SKU version (typically `1`)

**Examples**:

* `NC_G14_56_v1`: General purpose, 14 vCPUs (seven cores × two threads), 56-GiB memory.
* `NC_P12_56_v1`: Performance optimized, 12 vCPUs (six cores × two threads), 56-GiB memory.
* `NC_E70_336_v1`: Memory optimized, 70 vCPUs (35 cores × two threads), 336-GiB memory.

## SKU selection guidelines

To use these VM SKUs, hardware compatibility should be considered. Operator Nexus offers two hardware options: Bill of Materials (BOM) 1.7.3 and BOM 2.0 (More details about compute servers can be found [here](./reference-operator-nexus-skus.md#compute-skus)). The larger VM SKUs, specifically `NC_G56_224_v1`, `NC_P54_224_v1`, and `NC_E110_448_v1`, can only be supported on hardware BOM 2.0.

Nexus Tenant Kubernetes cluster VM SKUs are compatible with BOM 2.0, enabling users to use them alongside the larger VM SKUs. However, if a user tries to use BOM 2.0-specific VM SKUs on BOM 1.7.3 compute hardware, an "insufficient resources" error triggers during resource creation. For SKUs that are deployable on both BOMs, the bolded BOM version makes the best use of hardware resources for the SKU.

When considering which VM SKU to use, the primary difference between BOM 1.7.3 and BOM 2.0.0 is the vCPUs available. BOM 2.0.0 has eight additional vCPUs available for use. When selecting VM SKUs, consider using SKUs with a larger CPU to RAM ratio for deployment on BOM 2.0.0. While most SKUs are deployable on either Nexus BOM, you experience better bin packing and space utilization by selecting SKU that reflect the best possible resource usage for each BOM.

For example, take the VM SKU `NC_G14_56_v1`, which is best used on BOM 2.0.0. Four instances of that SKU would use up all the resources on a given Bare Metal Machine, with no waste.

|         | VM1 | VM2 | VM3 | VM4 | Used | Leftover |
| ------- | --- | --- | --- | --- | ---- | -------- |
| CPU     | 14  | 14  | 14  | 14  | 56   | **0**    |
| Memory  | 56  | 56  | 56  | 56  | 224  | **0**    |

However, if you used that SKU on BOM 1.7.3, only three NC_G14_56_v1 SKUs are deployable and a sizable amount of RAM goes left unused, even after deploying a smaller fourth VM. For BOM 1.7.3, the NC_G12_56_v1 is the optimized choice.

|         | VM1 | VM2 | VM3 | VM4 | Used | Leftover |
| ------- | --- | --- | --- | --- | ---- | -------- |
| CPU     | 14  | 14  | 14  | 6   | 48   | **0**    |
| Memory  | 56  | 56  | 56  | 28  | 196  | **28**   |

|         | VM1 | VM2 | VM3 | VM4 | Used | Leftover |
| ------- | --- | --- | --- | --- | ---- | -------- |
| CPU     | 12  | 12  | 12  | 12  | 48   | **0**    |
| Memory  | 56  | 56  | 56  | 56  | 224  | **0**    |

While the placement of the VMs is determined systematically at deployment time, selecting VM SKUs with an awareness of resource utilization improves the overall functionality of the platform, especially after it reaches 50% or more capacity.  

## General purpose VM SKUs

| VM SKU Name   | vCPU | Memory (GiB) | Root Disk (GiB) | Compatible Compute SKUs |
|---------------|------|--------------|-----------------|-------------------------|
| NC_G56_224_v1 | 56   | 224          | 300             | 2.0                     |
| NC_G48_224_v1 | 48   | 224          | 300             | **1.7.3**, 2.0          |
| NC_G42_168_v1 | 42   | 168          | 300             | 1.7.3, **2.0**          |
| NC_G36_168_v1 | 36   | 168          | 300             | **1.7.3**, 2.0          |
| NC_G28_112_v1 | 28   | 112          | 300             | 1.7.3, **2.0**          |
| NC_G24_112_v1 | 24   | 112          | 300             | **1.7.3**, 2.0          |
| NC_G18_74_v1  | 18   | 74           | 300             | 1.7.3, **2.0**          |
| NC_G16_74_v1  | 16   | 74           | 300             | **1.7.3**, 2.0          |
| NC_G14_56_v1  | 14   | 56           | 300             | 1.7.3, **2.0**          |
| NC_G12_56_v1  | 12   | 56           | 300             | **1.7.3**, 2.0          |
| NC_G6_28_v1   | 6    | 28           | 300             | **1.7.3**, 2.0          |
| NC_G2_8_v1    | 2    | 8            | 300             | 1.7.3, 2.0              |

## Performance optimized VM SKUs

| VM SKU Name   | vCPU | Memory (GiB) | Root Disk (GiB) | Compatible Compute SKUs |
|---------------|------|--------------|-----------------|-------------------------|
| NC_P54_224_v1 | 54   | 224          | 300             | 2.0                     |
| NC_P46_224_v1 | 46   | 224          | 300             | **1.7.3**, 2.0          |
| NC_P40_168_v1 | 40   | 168          | 300             | 1.7.3, **2.0**          |
| NC_P34_168_v1 | 34   | 168          | 300             | **1.7.3**, 2.0          |
| NC_P26_112_v1 | 26   | 112          | 300             | 1.7.3, **2.0**          |
| NC_P22_112_v1 | 22   | 112          | 300             | **1.7.3**, 2.0          |
| NC_P16_74_v1  | 16   | 74           | 300             | 1.7.3, **2.0**          |
| NC_P14_74_v1  | 14   | 74           | 300             | **1.7.3**, 2.0          |
| NC_P12_56_v1  | 12   | 56           | 300             | 1.7.3, **2.0**          |
| NC_P10_56_v1  | 10   | 56           | 300             | **1.7.3**, 2.0          |
| NC_P4_28_v1   | 4    | 28           | 300             | **1.7.3**, 2.0          |

## Memory optimized VM SKUs

| VM SKU Name   | vCPU | Memory (GiB) | Root Disk (GiB) | Compatible Compute SKUs |
|---------------|------|--------------|-----------------|-------------------------|
| NC_E110_448_v1| 110  | 448          | 300             | 2.0                     |
| NC_E94_448_v1 | 94   | 448          | 300             | 1.7.3, 2.0              |
| NC_E70_336_v1 | 70   | 336          | 300             | 1.7.3, **2.0**          |

## Storage optimized VM SKUs

| VM SKU Name   | vCPU | Memory (GiB) | Root Disk (GiB) | Compatible Compute SKUs |
|---------------|------|--------------|-----------------|-------------------------|
| NC_L54_224_v1 | 54   | 224          | 1638            | 2.0                     |
| NC_L46_224_v1 | 46   | 224          | 1638            | 2.0                     |

## Next steps

Try these SKUs in the Azure Operator Nexus Kubernetes cluster. For more information, see [Quickstart: Deploy an Azure Operator Nexus Kubernetes cluster](./quickstarts-kubernetes-cluster-deployment-bicep.md).
