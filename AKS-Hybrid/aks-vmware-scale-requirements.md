---
title: Scale requirements for AKS enabled by Azure Arc on VMware (preview)
description: Learn about scale requirements for AKS Arc on VMware.
ms.topic: conceptual
ms.date: 03/22/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: leslielin
ms.lastreviewed: 03/15/2024

---

# Scale requirements for AKS Arc on VMware (preview)

[!INCLUDE [aks-applies-to-vmware](includes/aks-hci-applies-to-skus/aks-applies-to-vmware.md)]

This article describes the minimum and maximum supported scale count for clusters and node pools in AKS enabled by Azure Arc on VMware.

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
| Number of long running operations that can be run simultaneously on an AKS cluster                                                              | 1 per cluster  |

## Default values for virtual machine sizes

| System Role                     | VM Size                                | Memory, CPU          |
|---------------------------------|----------------------------------------|----------------------|
| AKS Arc control plane nodes  | Standard_A4_v2                         | 16-GB memory, 4 vcpu  |
| AKS Arc HA Proxy VM          | Standard_A4_v2. Can't be changed.      | 8-GB memory, 4 vcpu  |
| AKS Arc Linux worker node    | Standard_K8S3_v1                       | 4-GB memory, 2 vcpu  |

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
| Standard_A2_v2 (default)             | 2    | 4            |
| Standard_A4_v2              | 4    | 8            |
| Standard_D4s_v3             | 4    | 16           |
| Standard_D8s_v3             | 8    | 32           |

> [!WARNING]
> There is a known issue with the VM size **Standard_A4_v2**, which is currently deployed with 2vCPU and 8GB memory. Microsoft is aware of the problem and is working on a resolution.

## Next steps

- [AKS Arc on VMware overview](aks-vmware-overview.md)
- [AKS Arc on VMware system requirements](aks-vmware-system-requirements.md)
