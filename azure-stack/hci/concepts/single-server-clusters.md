---
title: Using Azure Stack HCI on a single server
description: This article describes Azure Stack HCI OS on a single server
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: kerimhanif
ms.lastreviewed: 11/14/2022
ms.date: 11/14/2022
---

# Using Azure Stack HCI on a single server

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article provides an overview of running Azure Stack HCI on a single server, also known as a single-node cluster. Using a single server minimizes hardware and software costs in locations that can tolerate lower resiliency. A single server can also allow for a smaller initial deployment that you can add servers to later (scaling out).

Along with the benefits mentioned, there are some initial limitations to recognize.

- You must use PowerShell to create the single-node cluster and enable Storage Spaces Direct.
- Single servers must use only a single drive type: Non-volatile Memory Express (NVMe) or Solid-State (SSD) drives.
- Stretched (dual-site) clusters aren't supported with individual servers (stretched clusters require a minimum of two servers in each site).
- To install updates using Windows Admin Center, use the single-server Server Manager > Updates tool. Or use PowerShell or the Server Configuration tool (SConfig). For solution updates (such as driver and firmware updates), see your solution vendor. You can't use the Cluster Manager > Updates tool to update single-node clusters at this time.
- Operating system or other updates that require a restart cause downtime to running virtual machines (VMs) because there isn't another running cluster node to move the VMs to. We recommend manually shutting down the VMs before restarting to ensure that the VMs have enough time to shut down prior to the restart.

## Prerequisites

- A server from the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/catalog) that's certified for use as a single-node cluster and configured with all NVMe or all SSD drives.
- An [Azure Subscription](https://azure.microsoft.com/).

For hardware, software, and network requirements see [What you need for Azure Stack HCI](/azure-stack/hci/overview#what-you-need-for-azure-stack-hci).

## Comparing single-node and multi-node clusters

The following table compares attributes of a single-node cluster to multi-node clusters.

|Attributes | Single-node | Multi-node |
|----------|-----------|-----------|
|Full software-defined data center (SDDC) stack (hypervisor, storage, networking) | Yes | Yes|
|Storage Spaces Direct support | Yes | Yes |
|Software Defined Networking (SDN) support | Yes | Yes |
|Native Azure Arc integration | Yes | Yes |
|Managed through Windows Admin Center and Azure portal | Yes | Yes |
|Azure billing/registration | Yes | Yes |
|Charged per physical core| Yes | Yes |
|Support through Azure | Yes | Yes |
|Connectivity (intermittent or connected) | Yes | Yes |
|[Azure benefits](../manage/azure-benefits.md) on Azure Stack HCI | Yes | Yes |
|[Activate Windows Server Subscriptions](../manage/vm-activate.md) | Yes | Yes |
|[Azure Defender and Secured-core](/shows/inside-azure-for-it/securing-azure-stack-hci-with-azure-defender-and-secured-core) | Yes | Yes |
|[Azure Kubernetes Service on Azure Stack HCI](/azure-stack/aks-hci/) (AKS-HCI) | Yes | Yes |
|[Azure Virtual Desktop](/azure/virtual-desktop/overview) | Yes | Yes |
|[Azure Site Recovery](../manage/azure-site-recovery.md) | Yes | Yes |
|[Azure Stack HCI: Stretch cluster support](../concepts/stretched-clusters.md) | No | Yes |
|[Use Graphics Processing Units (GPUs) with clustered VMs](../manage/use-gpu-with-clustered-vm.md)  | Yes | Yes |

## Known issues

The following table describes currently known issues for single-node clusters. This list is subject to change as other items are identified: check back for updates.

|Issue | Notes|
|-----------|---------------|
|SBL cache is not supported in single-node clusters. | All-flash, flat configuration with Non-volatile Memory Express (NVMe) or Solid-State Drives (SSD) must be used. |
|Windows Admin Center doesn't support creating single-node clusters. | [Deploy single server with PowerShell](../deploy/create-cluster-powershell.md). |
|Windows Admin Center cosmetic user interface (UI) changes needed. | Doesn't limit Live Migration within the same cluster; allows affinity rules to be created, etc. Actions will fail without any harm. |
|Windows Admin Center pause server fails since it tries to drain the server. | Utilize PowerShell to pause (suspend the server). |
|Windows Admin Center and PowerShell fail to create a volume. | Use PowerShell to create the volume without "StorageTier" parameter. For example,  *New-Volume -FriendlyName "Volume1" -Size 1 TB -ProvisioningType Thin*. |
|Cluster Aware Updating (CAU) doesn't support single-node clusters. | Update using PowerShell, the Server Configuration tool (SConfig), or Windows Admin Center (through server manager). [Learn more](../deploy/single-server.md#updating-single-node-clusters) |

## Next steps

> [!div class="nextstepaction"]
> [Deploy on a single server](../deploy/single-server.md)
