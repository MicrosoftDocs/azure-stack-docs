---
title: Connectivity modes in small form factor deployments of Azure Local (preview)
description: Learn about connectivity modes for small form factor deployments of Azure Local (preview).
author: abha
ms.topic: concept-article
ms.date: 07/29/2026
ms.author: abha
ms.reviewer: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
ms.custom: references_regions
---

# Connectivity modes in small form factor deployments of Azure Local (preview)

This article provides information on connectivity modes for small form factor deployments of Azure Local.

Small form factor deployments require connectivity to Azure to deliver a cloud-managed experience. Operations such as provisioning a machine, applying updates, and managing the machine come from Azure. Because you deploy these devices at the edge and in other distributed environments, they might not always have stable network access. They can occasionally be unable to reach Azure, and they can operate in a semi-connected state.
 
[!INCLUDE [hci-preview](../includes/hci-preview.md)]
 
## Understand connectivity modes
 
When you work with small form factor deployments, it's important to understand how network connectivity modes impact your operations.
 
- **Connected**: With ongoing network connectivity, the machine and its Azure Arc agents can consistently communicate with Azure. This mode is the recommended mode and provides the best experience, since the machine is fully Azure-managed: provisioning, updates, SSH via Azure Arc, Azure services, and automatic log collection all work without interruption.
- **Semi-connected**: Refers to a temporary loss of connectivity with Azure, which is supported for a duration of **up to 45 days**. Some operations continue to work locally while others are unavailable until connectivity is restored. See [Impact of semi-connected mode](#impact-of-semi-connected-mode-temporary-disconnection-on-small-form-factor-operations) for details.
- **Disconnected**: Running small form factor deployments in a fully disconnected (air-gapped) environment is **not supported**. Use [Azure Local Disconnected Operations (ALDO)](../manage/disconnected-operations-overview.md) if a fully disconnected solution is required.
  
## Impact of semi-connected mode (temporary disconnection) on small form factor operations
 
The following table describes how a temporary loss of connectivity affects operations.
 
| Operation | Impact of temporary disconnection | Details | Workaround |
| --- | --- | --- | --- |
| Create a machine | Partially supported | You can *create* a provisioned machine resource, since this action is an Azure Resource Manager (ARM) operation. However, an internet connection is required to actually deploy the OS and get the machine to the *provisioned* state. | No supported workaround. Restore connectivity to complete provisioning. |
| Provision a machine | Not supported | Provisioning is where the machine is actually deployed with the OS, which requires connectivity to Azure. Note that *create* and *provision* are separate operations only in Azure CLI/ARM; in the Azure portal, both operations are combined into one. | No supported workaround. |
| Reset a machine | Partially supported | Reset doesn't work while disconnected. You can reflash the Linux machine locally, but after reflashing, the new ARM object created when you reconnect/recreate is a completely different ARM object. You must also delete the old Azure objects after reflashing. | Reflash locally, then clean up the old ARM objects once connectivity is restored. |
| Delete a machine | Partially supported | You can reflash the machine while disconnected and delete the ARM objects. | Follow best practices when deleting Azure resources with dependencies on other Azure resources. For example, delete any Kubernetes ARM resources before deleting the machine resource itself. |
| SSH into the machine using Azure Arc | Partially supported | Accessing the machine via JIT isn't possible while disconnected. | You can always SSH directly into the machine from any device that has line of sight to the provisioned machine. You must have also have a private key. |
| Set up and run Docker, K3s, or AKS Arc | Partially supported | Setting up and operating Docker and K3s works while disconnected. However, you can't connect a K3s cluster to Azure Arc-enabled Kubernetes, and Arc Kubernetes operations and Arc extensions might not function well without connectivity. | For more information, see [Azure Arc-enabled Kubernetes connectivity modes](/azure/azure-arc/kubernetes/conceptual-connectivity-modes#understand-connectivity-modes) and [AKS bare metal documentation](/azure/aks/aksarc/aks-bare-metal-overview). |
| Collect logs | Partially supported | When connected, logs are automatically emitted to Azure for the best troubleshooting experience with Microsoft Support. While disconnected, automatic log collection isn't available. | Collect logs manually after SSH-ing into the provisioned machine. |
| Update the machine | Not supported | Updates aren't possible without connectivity today. | No supported workaround. |
| Manage NICs and disks | Partially supported | You can't use the Azure portal to make changes to your network interfaces and disks while disconnected. | SSH into the machine and manage NICs and disks locally. Once connectivity is restored, an out-of-sync notice appears in the Azure portal, and you must accept the local changes there before they're recorded in Azure and synced back to the ARM objects. |

## How long can a machine stay disconnected?
 
A provisioned machine can remain disconnected for **up to 45 days**. Beyond this period, the Azure Arc-enabled server and Azure Arc-enabled Kubernetes certificates expire and the machine can no longer reconnect to Azure:

- For Azure Arc-enabled servers, after 45 to 90 days of being disconnected, the Microsoft Entra managed identity expires, and the Connected Machine agent can no longer connect to the Arc-enabled server. For more information, see [Troubleshoot Azure Arc-enabled servers in disconnected scenarios](/azure/azure-arc/servers/troubleshoot-connectivity#impact-on-arc-enabled-servers-when-disconnected).
- For Azure Arc-enabled Kubernetes, certificates managed by the platform have a limited validity period and require periodic connectivity to renew. For more information, see [Azure Arc-enabled Kubernetes connectivity modes](/azure/azure-arc/kubernetes/conceptual-connectivity-modes#understand-connectivity-modes).
> [!NOTE]
> The 45-day limit reflects the current preview, which doesn't yet include billing. Once small form factor deployments reach general availability and billing is enabled, this 45-day limit might change.
 
## Next steps
 
- [Overview of small form factor deployments of Azure Local (preview)](small-form-factor-overview.md)
