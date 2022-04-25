---
title: Azure Stack HCI - Single Server Overview
description: This article describes Azure Stack HCI OS on a single server
author: robess
ms.author: robess
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/04/2022
---

# **Azure Stack HCI Single-server clusters overview**
> Applies to: Azure Stack HCI, version 21H2

This article provides information about Azure Stack HCI OS on a single-server.

Single-server, also referred to as single-node, is a cluster with one server and no failover to another server. At the workload level, if high resiliency isn't a requirement, single-server can provide flexibility. It can also minimize hardware and reduce Azure costs in locations that can tolerate lower resiliency. Therefore, contributing to more overall cost savings.

Additionally, single-server could be an alternative for users with plans to scale out in the future.

## **Requirements**
Single-server hardware, software, and network requirements are the same as multi-server. For more detail, see [What you need for Azure Stack HCI](/azure-stack/hci/overview#what-you-need-for-azure-stack-hci).

> [!IMPORTANT]
> Azure Stack HCI 21H2 single server scale is only supported on single storage type configurations. Stretch cluster and SBL cache are not supported, and when restarting the server VMs will have downtime.
## **What's Supported**
|Attributes | Single-Server | Multi-Server |
|----------|-----------|-----------|
|Full SDDC stack (hypervisor, storage, networking) | Yes | Yes|
|Native Azure Arc integration | Yes | Yes |
|Managed through WAC and/or Azure portal | Yes | Yes |
|Azure billing/registration | Yes | Yes |
|Charged per physical core| Yes | Yes |
|Support is through Azure | Yes | Yes |
|Connectivity (intermittent or connected) | Yes | Yes |
|Supported Storage Spaces Direct (S2D) fault domains | Yes | Yes |
|Azure benefits, Azure edition, Windows Srv Subscription | Yes | Yes |
|Software Defined Networking (SDN), Secured Core | Yes | Yes |
|GPU, Azure Site Recovery, *Stretch cluster support | Yes, ***Stretch cluster not supported** | Yes |
|AKS-HCI, Azure Virtual Desktop, Security features | Yes | Yes |

> [!Note]
> Features that require multiple servers will not be supported, e.g. live migration of VMs (within the cluster), affinity rules, and others.
## **Known Issues**
|Single-Server on Azure Stack HCI 21H2 | Supported Capability|
|-----------|---------------|
|WAC doesn't support single-server cluster creation. | Deploy with PowerShell. |
|WAC cosmetic UI changes needed. | Doesn't limit Live Migration (LM) within the same cluster, allows affinity rules to be created, etc. Actions will fail without any harm. |
|WAC pause server fails since it tries to drain the server. | Utilize PowerShell to pause (suspend the server). |
|WAC and PowerShell fail to create a volume. | Use PowerShell without "StorageTier" parameter. For example,  *New-Volume -FriendlyName "Volume1" -Size 1 TB -ProvisioningType Thin*. |
|Cluster Aware Updating (CAU) doesn't support single-server. | Update using SCONFIG and/or WAC (through server manager). |
|Cache drives don't auto rebind if failed. | All-flash, Nonvolatile Memory Express (NVMe) or Solid-State Drives (SSD), flat configuration must be used. ***SBL cache will not be supported at this time**. |
|Scale-out doesn't automatically fix up S2D. | Manual fixup in 21H2. |
## Next steps

> [!div class="nextstepaction"]
> [Configure Single-Server](../deploy/configure-hci-os-single-server.md)
