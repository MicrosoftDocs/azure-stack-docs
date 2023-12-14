---
title: Scale requirements for AKS on Azure Stack HCI (preview)
description: Learn about scale requirements for AKS on Azure Stack HCI.
ms.topic: conceptual
ms.date: 12/13/2023
author: sethmanheim
ms.author: sethm 
ms.reviewer: oadeniji
ms.lastreviewed: 12/12/2023

---

# Scale requirements for AKS on Azure Stack HCI (preview)

This article describes the maximum and minimum supported scale count for AKS on Azure Stack HCI clusters and node pools.

Currently, for AKS-HCI using PowerShell/Windows Admin Center, we support the following scale configuration:

- 8 physical nodes.
- A maximum of 200 VMs (in any configuration of clusters, worker nodes).

## Support count for AKS on HCI (preview)

| Scale item                                                               | Count                                      |
|--------------------------------------------------------------------------|--------------------------------------------|
| Minimum number of physical nodes in Azure Stack HCI cluster                 | 1                                          |
| Maximum number of physical nodes in Azure Stack HCI cluster                 | 16                                         |
| Minimum count for control plane node                                        | 1                                          |
| Maximum count for control plane node                                        | 5 <br />    Allowed values: 1, 3, and 5.   |
| Minimum number of nodes in default node pool created during cluster create  | 1                                          |
| Minimum number of node pools in an AKS hybrid cluster                       | 1                                          |
| Maximum number of node pools in an AKS hybrid cluster                       | 16                                         |
| Minimum number of nodes in a node pool                                      | 1 <br />    Cannot create empty node pools.|
| Maximum number of nodes in a node pool                                      | 64                                         |
| Maximum number of total nodes in a AKS hybrid cluster                       | 200                                        |
| Maximum number of AKS hybrid clusters per Azure Stack HCI cluster           | 32                                         |

## Concurrency for AKS enabled by Arc

| Scale item                                                                                                                                      | Count                             |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|
| Number of concurrent AKS cluster creations on an ARB                                                                                                   | 8                                     |
| Number of concurrent node pool creations on an ARB                                                                                                     | 8                                     |
| Number of concurrent operations across all different AKS hybrid clusters like upgrade/scaling/etc. excluding create for node pool or clusters per ARB  | 32                                    |
| Number of long running operations that can be run simultaneously on an AKS hybrid cluster                                                              | 1 per cluster.  |

## Default values for virtual machine sizes

| System Role                     | VM Size                                | Memory, CPU          |
|---------------------------------|----------------------------------------|----------------------|
| AKS hybrid control plane nodes  | Standard_A4_v2                         | 8 GB memory, 4 vcpu  |
| AKS hybrid HA Proxy VM          | Standard_A4_v2. Cannot be changed.     | 8 GB memory, 4 vcpu  |
| AKS hybrid Linux worker node    | Standard_K8S3_v1                       | 6 GB memory, 4 vcpu  |
| AKS hybrid Windows worker node  | Standard_K8S3_v1                       | 6 GB memory, 4 vcpu  |

## Supported values for virtual machine sizes

| VM Size                     | CPU  | Memory (GB)  | GPU type  | Recommended for control plane nodes?  |
|-----------------------------|------|--------------|-----------|---------------------------------------|
| Default                     | 4    | 4            | N/A       |                                       |
| Standard_A4_v2              | 4    | 8            |           |                                       |
| Standard_D4s_v3             | 4    | 16           |           |                                       |
| Standard_D8s_v3             | 8    | 32           |           |                                       |
| Standard_D16s_v3            | 16   | 64           |           |                                       |
| Standard_D32s_v3            | 32   | 128          |           |                                       |
| Standard_DS4_v2             | 8    | 28           |           |                                       |
| Standard_DS5_v2             | 16   | 56           |           |                                       |
| Standard_DS13_v2            | 8    | 56           |           |                                       |
| Standard_K8S3_v1            | 4    | 6            | N/A       |                                       |
| Standard_NK6                | 6    | 12           | Tesla T4  |                                       |
| Standard_NK12               | 12   | 24           | Tesla T4  |                                       |
| GPU rows for A2, A16, etc.  |      |              |           |                                       |

## Next steps

- [Review AKS on Azure Stack HCI 23H2 prerequisites](aks-hci-network-system-requirements.md)
- [What's new in AKS on Azure Stack HCI](aks-preview-overview.md)
