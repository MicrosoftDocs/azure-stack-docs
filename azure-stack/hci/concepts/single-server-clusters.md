---
title: Azure Stack HCI - Single Server Overview
description: This article describes Azure Stack HCI OS on a single server
author: robess
ms.author: robess
ms.topic: overview
ms.reviewer: kerimhanif
ms.lastreviewed: 04/28/2022
ms.date: 04/04/2022
---

# Using Azure Stack HCI on a single server

> Applies to: Azure Stack HCI, version 21H2

This article provides information about Azure Stack HCI single server.

This article provides an overview of running Azure Stack HCI, version 21H2 on a single server, also known as a single-server cluster. Using a single server minimizes hardware and software costs in locations that can tolerate lower resiliency. A single server can also allow for a smaller initial deployment that you can add servers to later (scaling out).

Along with the benefits mentioned, there are some initial limitations to recognize.

- Single server deployment needs to be done through PowerShell.
- Single servers must use only NVMe or SSD drives.
- Stretched (dual-site) clusters don't support individual servers (you must use a minimum of four servers in a stretched cluster).
- To install updates in Windows Admin Center, you can't use the Cluster Manager > Updates tool. Instead, you can use the single-server Server Manager > Updates tool or use Server Configuration tool (SConfig). You'll have to get solution updates directly from your solution vendor.
- Host update that requires a restart will cause downtime to running virtual machines (VMs). Shut them down gracefully before restarting the host.

## Prerequisites

- A single server cluster purchased from your preferred Microsoft hardware partner from [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/).
- An [Azure Subscription](https://azure.microsoft.com/).

For hardware, software, and network requirements see [What you need for Azure Stack HCI](/azure-stack/hci/overview#what-you-need-for-azure-stack-hci).

## Comparing single-server and multi-server clusters

The following table compares attributes of a single server cluster to multi-server clusters.

|Attributes | Single-server | Multi-server |
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
|[Azure Kubernetes Service on Azure Stack HCI](/azure-stack/aks-hci/) (AKS-HCI) | Yes <sup>1</sup> | Yes |
|[Azure Virtual Desktop](/azure/virtual-desktop/overview) | Yes | Yes |
|[Azure Site Recovery](../manage/azure-site-recovery.md) | Yes | Yes |
|[Azure Stack HCI: Stretch cluster support](../concepts/stretched-clusters.md) | No <sup>2</sup> | Yes |
|[Use Graphics Processing Units (GPUs) with clustered VMs](../manage/use-gpu-with-clustered-vm.md)  | Yes | Yes |

<sup>1</sup> Limited support, AKS-HCI is "in-preview" as of June 2022.

<sup>2</sup> Planned for future versions.

## Known issues

The following table describes currently known issues for single server. This list is subject to change as other items are identified, check back for updates.

|Issue | Notes|
|-----------|---------------|
|Cache drives don't auto rebind if failed. | All-flash, flat configuration with Non-volatile Memory Express (NVMe) or Solid-State Drives (SSD) must be used. ***SBL cache is not supported at this time**. |
|Windows Admin Center doesn't support single server cluster creation. | [Deploy single server with PowerShell](../deploy/create-cluster-powershell.md). |
|Windows Admin Center cosmetic user interface (UI) changes needed. | Doesn't limit Live Migration (LM) within the same cluster, allows affinity rules to be created, etc. Actions will fail without any harm. |
|Windows Admin Center pause server fails since it tries to drain the server. | Utilize PowerShell to pause (suspend the server). |
|Windows Admin Center and PowerShell fail to create a volume. | Use PowerShell to create the volume without "StorageTier" parameter. For example,  *New-Volume -FriendlyName "Volume1" -Size 1 TB -ProvisioningType Thin*. |
|Cluster Aware Updating (CAU) doesn't support single server. |Update using command line, Server Configuration tool (SConfig), or Windows Admin Center (through server manager). |
|Adding a node to scale out the single server cluster doesn't automatically change the Storage Spaces Direct `FaultDomainAwarenessDefault`. |`FaultDomainAwarenessDefault` can be changed manually from PhysicalDisk to StorageScaleUnit. |

## Next steps

> [!div class="nextstepaction"]
> [Configure single server](../deploy/configure-hci-os-single-server.md)
