---
title: Scale requirements for AKS on Azure Local
description: Learn about scale requirements for AKS on Azure Local.
ms.topic: conceptual
ms.date: 03/21/2025
author: sethmanheim
ms.author: sethm 
ms.reviewer: abha
ms.lastreviewed: 03/26/2024

---

# Scale requirements for AKS on Azure Local

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article describes the maximum and minimum supported scale count for AKS on Azure Local clusters and node pools.

## Support count for AKS on Azure Local

| Scale item   | Minimum  | Maximum |
|--------------|----------|---------|
| Number of physical nodes in an Azure Local cluster  | 1  | 16 |
| Count of control plane nodes (Allowed values are 1, 3, and 5)  | 1 | 5 |
| Number of nodes in default node pool created during cluster create  | 1 | 200 |
| Number of node pools in an AKS cluster  | 1  | 16  |
| Number of nodes in a node pool (empty node pools not supported)  | 1 | 64 |
| Total number of nodes in an AKS cluster across nodepools | 1 | 200 |
| Number of AKS clusters per Azure Local cluster | 0| 32 |

## Concurrency for AKS enabled by Arc

| Scale item  | Count  |
|-------------|--------|
| Number of concurrent AKS cluster creations on an ARB  | 8 |
| Number of concurrent node pool creations on an ARB  | 8  |
| Number of concurrent operations across all different AKS clusters such as upgrade/scaling, etc., excluding creating node pool or clusters per ARB  | 32  |
| Number of long running operations that can be run simultaneously on an AKS cluster  | 1 per cluster.  |

## Default values for virtual machine sizes

| System Role                     | VM Size                                | Memory, CPU          |
|---------------------------------|----------------------------------------|----------------------|
| AKS Arc control plane nodes     | Standard_A4_v2                         | 8-GB memory, 4 vcpu  |
| AKS Arc Linux worker node       | Standard_A4_v2                         | 8-GB memory, 4 vcpu  |
| AKS Arc Windows worker node     | Standard_K8S3_v1                       | 6-GB memory, 4 vcpu  |

## Supported values for control plane node sizes

| VM Size                     | CPU  | Memory (GB)  |
|-----------------------------|------|--------------|
| Standard_A4_v2              | 4    | 8            |
| Standard_D4s_v3             | 4    | 16           |
| Standard_D8s_v3             | 8    | 32           |
| Standard_K8S3_v1            | 4    | 6            |

## Supported values for worker node sizes

| VM Size                     | CPU  | Memory (GB)  |
|-----------------------------|------|--------------|
| Standard_A4_v2              | 4    | 8            |
| Standard_A2_v2              | 2    | 4            |
| Standard_D4s_v3             | 4    | 16           |
| Standard_D8s_v3             | 8    | 32           |
| Standard_K8S3_v1            | 4    | 6            |

For more worker node sizes with GPU support, see the next section.

## Supported GPU models

The following GPU models are supported by AKS on Azure Local, version 23H2:

| Manufacturer | GPU model | Supported version |
|--------------|-----------|-------------------|
| NVidia       | A2        | 2311.2            |
| NVidia       | A16       | 2402.0            |
| NVidia       | T4        | 2408.0            |

## Supported VM sizes

The following VM sizes for each GPU models are supported by AKS on Azure Local, version 23H2.

### Nvidia T4 is supported by NK T4 SKUs

| VM size | GPUs | GPU Memory: GiB | vCPU | Memory: GiB |
|-----------------|---|----|-----|----|
| Standard_NK6    | 1 | 8  | 6   | 12 |
| Standard_NK12   | 2 | 16 | 12  | 24 |

### Nvidia A2 is supported by NC2 A2 SKUs

| VM size | GPUs | GPU Memory: GiB | vCPU | Memory: GiB |
|-------------------|---|----|----|----|
| Standard_NC4_A2   | 1 | 16 | 4  | 8  |
| Standard_NC8_A2   | 1 | 16 | 8  | 16 |
| Standard_NC16_A2  | 2 | 48 | 16 | 64 |
| Standard_NC32_A2  | 2 | 48 | 32 | 128 | 

### Nvidia A16 is supported by NC2 A16 SKUs

| VM size | GPUs | GPU Memory: GiB | vCPU | Memory: GiB |
|--------------------|---|----|----|----|
| Standard_NC4_A16   | 1 | 16 | 4  | 8  |
| Standard_NC8_A16   | 1 | 16 | 8  | 16 |
| Standard_NC16_A16  | 2 | 48 | 16 | 64 |
| Standard_NC32_A16  | 2 | 48 | 32 | 128 | 

## Next steps

- [Review AKS on Azure Local, version 23H2 prerequisites](aks-hci-network-system-requirements.md)
- [What's new in AKS on Azure Local](aks-whats-new-23h2.md)
