---
title: Scale requirements for AKS enabled by Azure Arc on VMware (preview)
description: Learn about scale requirements for AKS Arc on VMware.
ms.topic: conceptual
ms.date: 03/26/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: leslielin
ms.lastreviewed: 03/26/2024

---

# Scale requirements for AKS enabled by Arc on VMware (preview)

[!INCLUDE [aks-applies-to-vmware](includes/aks-hci-applies-to-skus/aks-applies-to-vmware.md)]

This article lists the supported scale count for clusters and node pools in AKS enabled by Azure Arc on VMware. These scale counts are contingent on the resources available from the underlying infrastructure.

## Support count

| Scale item                                                               | Count                                      |
|--------------------------------------------------------------------------|--------------------------------------------|
| Minimum number of physical nodes in a VMware vSphere cluster                 | 1                                          |
| Maximum number of physical nodes in a VMware vSphere cluster                 | 32                                         |
| Minimum count for control plane nodes                                        | 1 <br />    Allowed values: 1, 3, and 5.    |
| Minimum number of nodes in default node pool created during cluster create  | 1                                          |
| Minimum number of node pools in an AKS cluster                       | 1                                          |
| Minimum number of nodes in a node pool                                      | 1 <br />    Can't create empty node pools.|
| Maximum number of AKS clusters in a VMware vSphere cluster           | 10                                         |

## Concurrency

| Scale item                                                                                                                                      | Count                             |
|-----------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|
| Number of concurrent AKS cluster creations on an ARB                                                                                                   | 6                                     |
| Number of concurrent node pool creations on an ARB                                                                                                     | 6                                     |

## Default values for virtual machine sizes for AKS on VMware

| System role                     | VM size                                | Memory, CPU          |
|---------------------------------|----------------------------------------|----------------------|
| AKS Arc control plane nodes  | Standard_A4_v2                         | 8-GB memory, 4 vcpu  |
| AKS Arc HA Proxy VM          | Standard_A4_v2. Can't be changed.      | 8-GB memory, 4 vcpu  |
| AKS Arc Linux worker node    | Standard_A4_v2                         | 8-GB memory, 4 vcpu  |

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
| Standard_A2_v2 (default)    | 2    | 4            |
| Standard_A4_v2              | 4    | 8            |
| Standard_D4s_v3             | 4    | 16           |
| Standard_D8s_v3             | 8    | 32           |

> [!NOTE]
> In the previous version of Arc Resource Bridge, there was a known issue in which the VM size was deployed with incorrect specifications. This issue was resolved in the Arc Resource Bridge version 1.1.0 and later releases. [See this article](/azure/azure-arc/resource-bridge/upgrade) to upgrade your Arc Resource Bridge. For more information, see the [Arc Resource Bridge release notes](https://github.com/Azure/ArcResourceBridge/releases). To understand the full context of this issue, see the [known issues in AKS enabled by Azure Arc on VMware](aks-vmware-known-issues.md).

## Next steps

- [AKS Arc on VMware overview](aks-vmware-overview.md)
- [AKS Arc on VMware system requirements](aks-vmware-system-requirements.md)
