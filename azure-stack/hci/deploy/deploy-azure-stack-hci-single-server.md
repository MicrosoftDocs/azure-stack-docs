---
title: Azure Stack HCI - Single Server Overview
description: This article describes Azure Stack HCI OS on a Single Server
author: robess
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/04/2022
---

# **Deploy Azure Stack HCI OS - Single-Server**

This article provides information about installing Azure Stack HCI OS on a single-server. For this overview, the reference is via PowerShell as Windows Admin Center (WAC) isn't supported for this setup.

## Requirements
Hardware and software requirement for Multi-node apply to single server see more for detail []()

## **What's Single-Server HCI**
Single-server or single-node, is a cluster with one node and no failover to another node. Using single-server is an alternative if high resiliency isn't a requirement. Single-server may contribute to cost savings, when handling resiliency at the workload level.

### **Considerations for Single-Server**
Single-server can be considered if you have the following (what word goes here?)
Flexibility in reducing hardware and Azure costs in locations that can tolerate lower resiliency.

>[!NOTE]
>Single-server could be an option for (fill in this word) and scaling out.

> [!IMPORTANT]
> This setup can only provide hardware resiliency. VMs will have downtime when restarting the single node.
#### **What's Supported**
|Attributes | Single-Server |
|-----------|---------------|
|Full SDDC stack (hypervisor, storage, networking) | Yes |
|Native Azure Arc integration | Yes |
|Managed through WAC and/or Azure portal | Yes |
|Azure billing/registration | Yes |
|Charged per physical core| Yes |
|Support is through Azure | Yes |
|Connectivity (intermittent or connected) | Yes |
|Supported Storage Spaces Direct (S2D) fault domains | Yes |
|Azure benefits, Azure edition, Windows Srv Subscription | Yes |
|Software Defined Networking (SDN), Secured Core | Yes |
|GPU, Azure Site Recovery, *Stretch cluster support | Yes, *stretch cluster not supported |
|AKS-HCI, Azure Virtual Desktop, Security features | Yes |

## **Known Issues**
|Single-Server on Azure Stack HCI 21H2 | Supported Capability|
|-----------|---------------|
|WAC doesn't support single-server cluster creation. | Deploy with PowerShell. |
|WAC cosmetic UI changes needed. | Doesn't limit Live Migration (LM) within the same cluster, allows affinity rules to be created, etc. Actions will fail without any harm. |
|WAC pause node fails since it tries to drain the node. | Utilize PowerShell to pause (suspend the node). |
|WAC and PowerShell fail to create a volume. | Use PowerShell without "StorageTier" parameter. For example,  New-Volume -FriendlyName "Volume1" -Size 1 TB -ProvisioningType Thin. |
|Cluster Aware Updating (CAU) doesn't support single-node. | Update using SCONFIG and/or WAC (through server manager). |
|Cache drives don't auto rebind if failed. | All-flash, Nonvolatile Memory Express (NVMe) or Solid-State Drives (SSD), flat configuration must be used. ***SBL cache will not be supported at this time**. |
|Scale-out doesn't automatically fix up S2D. | Manual fixup in 21H2. |

## Next steps

> [!div class="nextstepaction"]
> [Configure Single-Server]()