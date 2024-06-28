---
title: Scale requirements for AKS on Azure Stack HCI
description: Learn about scale requirements for AKS on Azure Stack HCI.
ms.topic: conceptual
ms.date: 03/26/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: abha
ms.lastreviewed: 03/26/2024

---

# Scale requirements for AKS on Azure Stack HCI

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article describes the maximum and minimum supported scale count for AKS on Azure Stack HCI clusters and node pools.

## Support count for AKS on HCI

| Scale item                                                               | Count                                      |
|--------------------------------------------------------------------------|--------------------------------------------|
| Minimum number of physical nodes in an Azure Stack HCI cluster                 | 1                                          |
| Maximum number of physical nodes in an Azure Stack HCI cluster                 | 16                                         |
| Minimum count for control plane node                                        | 1                                          |
| Maximum count for control plane node                                        | 5 <br />    Allowed values: 1, 3, and 5.   |
| Minimum number of nodes in default node pool created during cluster create  | 1                                          |
| Minimum number of node pools in an AKS cluster                       | 1                                          |
| Maximum number of node pools in an AKS cluster                       | 16                                         |
| Minimum number of nodes in a node pool                                      | 1 <br />    Can't create empty node pools.|
| Maximum number of nodes in a node pool                                      | 64                                         |
| Maximum number of total nodes in an AKS cluster                       | 200                                        |
| Maximum number of AKS clusters per Azure Stack HCI cluster           | 32                                         |

## Concurrency for AKS enabled by Arc

| Scale item                                                                                                                                      | Count                             |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|
| Number of concurrent AKS cluster creations on an ARB                                                                                                   | 8                                     |
| Number of concurrent node pool creations on an ARB                                                                                                     | 8                                     |
| Number of concurrent operations across all different AKS clusters such as upgrade/scaling, etc., excluding creating node pool or clusters per ARB  | 32                                    |
| Number of long running operations that can be run simultaneously on an AKS cluster                                                              | 1 per cluster.  |

## Default values for virtual machine sizes

| System Role                     | VM Size                                | Memory, CPU          |
|---------------------------------|----------------------------------------|----------------------|
| AKS Arc control plane nodes  | Standard_A4_v2                         | 8-GB memory, 4 vcpu  |
| AKS Arc HA Proxy VM          | Standard_A4_v2. Can't be changed.      | 8-GB memory, 4 vcpu  |
| AKS Arc Linux worker node    | Standard_K8S3_v1                       | 6-GB memory, 4 vcpu  |
| AKS Arc Windows worker node  | Standard_K8S3_v1                       | 6-GB memory, 4 vcpu  |

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

For more worker node sizes with GPU support, see [Use GPUs](deploy-gpu-node-pool.md). 

## Next steps

- [Review AKS on Azure Stack HCI 23H2 prerequisites](aks-hci-network-system-requirements.md)
- [What's new in AKS on Azure Stack HCI](aks-whats-new-23h2.md)
