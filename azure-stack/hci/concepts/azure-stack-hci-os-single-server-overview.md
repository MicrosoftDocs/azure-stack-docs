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

This article provides information about Azure Stack HCI single-server.

Azure Stack HCI Single-server is a new cluster configuration option that is available for all Azure Stack HCI installations starting with version 21H2. This configuration option promotes flexibility if high resiliency isn't a requirement. This server scale minimizes hardware and promotes lower Azure costs in locations that can tolerate lower resiliency. Single server may also be a concept for users who desire a minimal initial setup, with plans to scale out in the future.

Along with the benefits mentioned, there are some initial limitations to recognize.
- Storage Bus Layer (SBL) cache isn't supported. Single-server is only supported on single storage type configurations (for example all NVMe or all SSD).
- Stretch cluster isn't supported at this time.
- Host update that requires a restart will cause downtime to running virtual machines (VMs). Shut them down gracefully before restarting the host.
## **Requirements**

1. A single server cluster purchased from your preferred Microsoft hardware partner from [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/)
2. An [Azure Subscription](https://azure.microsoft.com/)

For hardware, software, and network requirements reference [What you need for Azure Stack HCI](/azure-stack/hci/overview#what-you-need-for-azure-stack-hci).
## **Comparing single-server and multi-server clusters**
|Attributes | Single-Server | Multi-Server |
|----------|-----------|-----------|
|Full SDDC stack (hypervisor, storage, networking) | Yes | Yes|
|Storage Spaces Direct (S2D) support | Yes | Yes |
|Software Defined Networking (SDN) support | Yes | Yes |
|Native Azure Arc integration | Yes | Yes |
|Managed through WAC and/or Azure portal | Yes | Yes |
|Azure billing/registration | Yes | Yes |
|Charged per physical core| Yes | Yes |
|Support through Azure | Yes | Yes |
|Connectivity (intermittent or connected) | Yes | Yes |
|Azure benefits on Azure Stack HCI | Yes | Yes |
|Activate Windows Server Subscriptions | Yes | Yes |
|Azure Defender and Secured-core | Yes | Yes |
|Azure Kubernetes Service on Azure Stack HCI (AKS-HCI) | Yes | Yes |
|Azure Virtual Desktop | Yes | Yes |
|Azure Site Recovery | Yes | Yes |
|Azure Stack HCI: Stretch cluster support | No | Yes |
|Use GPUs with clustered VMs | Yes | Yes |

## **Known Issues**
|Issue | Notes|
|-----------|---------------|
|Cache drives don't auto rebind if failed. | All-flash, flat configuration with Non-volatile Memory Express (NVMe) or Solid-State Drives (SSD) must be used. ***SBL cache will not be supported at this time**. |
|Windows Admin Center (WAC) doesn't support single-server cluster creation. | [Deploy Single-server with PowerShell](../deploy/create-cluster-powershell.md). |
|WAC cosmetic UI changes needed. | Doesn't limit Live Migration (LM) within the same cluster, allows affinity rules to be created, etc. Actions will fail without any harm. |
|WAC pause server fails since it tries to drain the server. | Utilize PowerShell to pause (suspend the server). |
|WAC and PowerShell fail to create a volume. | Use PowerShell to create the volume without "StorageTier" parameter. For example,  *New-Volume -FriendlyName "Volume1" -Size 1 TB -ProvisioningType Thin*. |
|Cluster Aware Updating (CAU) doesn't support single-server. |Update using command line, SCONFIG and/or use WAC to update (through server manager). |
|Adding a node to scale out the single-server cluster doesn't automatically change the S2D FaultDomainAwarenessDefault. |FaultDomainAwarenessDefault can be changed manually from PhysicalDisk to StorageScaleUnit. |
## Next steps

> [!div class="nextstepaction"]
> [Configure Single-Server](../deploy/configure-hci-os-single-server.md)
