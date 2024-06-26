---

title: Azure Kubernetes Service (AKS) enabled by Azure Arc pricing details
description: Learn about detailed pricing information for AKS enabled by Azure Arc.
ms.topic: conceptual
author: sethmanheim
ms.author: sethm 
ms.date: 06/24/2024
ms.lastreviewed: 05/31/2023
ms.reviewer: rbaziwane

# Intent: As a subscription owner, I want to understand how the AKS Arc service is priced and what I am paying for.
# Keyword: pricing

---


# AKS enabled by Azure Arc pricing details

[!INCLUDE [aks-hybrid-applies-to-azure-stack-hci-windows-server-sku](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)], AKS on Azure Stack HCI 23H2

Azure Kubernetes Service (AKS) enabled by Azure Arc is a subscription-based Kubernetes offering that can be run on Azure Stack HCI or Windows Server Hyper-V clusters. You can download and install AKS Arc on your existing hardware either in your own on-premises data center, or on the edge. The pricing is based on usage and requires an Azure subscription, which you can obtain for free. The billing unit is a virtual core or vCPU. All initial AKS deployments include a free 60-day evaluation period, at the end of which a pay-as-you-go rate per vCPU (of running worker nodes) per day is applied.

> [!IMPORTANT]
> Starting in June 2023, we have made revisions that solidify the 60-day evaluation period as a one-time benefit per subscription, at the end of which a pay-as-you-go rate per vCPU will apply. This modification means the evaluation period no longer resets when you reinstall AKS enabled by Arc. This change is being made to better align with our existing pricing guidelines and to ensure the continued provision of high-quality services.

## Pricing details

Azure pricing for running workloads on AKS enabled by Arc is based on US currency list pricing with:

- Pay-as-you-go pricing
- D-series general purpose VM sizes (D2s v4, D4s V4, and D8s V4)
- Standard HDD
- No uptime SLA (included in the support level)

In addition, AKS Arc pricing is based on the US currency list pricing with no discounts applied. The monthly price estimates are based on 730 hours of usage.

For detailed pricing information, see the [AKS pricing details](https://azure.microsoft.com/pricing/details/azure-stack/aks-hci/#overview) page. The list price for AKS Arc includes the following:

- Includes Kubernetes control plane and load balancer nodes:
  - The Arc-enabled AKS management cluster usage is not charged.
  - The workload cluster control plane and load balancer nodes are not charged.

- Includes Linux (CBL-Mariner) container hosts:
  - Pricing does not include Windows container hosts as they are licensed separately through regular licensing channels.
  - Windows Server Standard: Unlimited Windows containers and two Hyper-V containers.
  - Windows Server Datacenter: Unlimited Windows and Hyper-V containers.

- Includes Azure Arc-enabled Kubernetes at no extra charge and the following items:
  - **Inventory, grouping, and tagging** in Azure.
  - **Deployment of apps and configurations with GitOps**: Included at no extra charge (normally, the initial six vCPUs are free, and then afterwards, the charged per vCPU per month).
  - **Azure Policy for Kubernetes**: Included at no extra charge (normally, the charge per vCPU per cluster for each month).

- If you enable hyper-threading on the physical computer, this reduces the measured vCPU count by 50 percent.

> [!NOTE]
> Running Windows Server containers on AKS Arc requires a Windows Server license. The license can be acquired separately through regular licensing channels, or it can be added to the cost of running a Windows virtual machine on Azure. For users with Windows Server Software Assurance, [Azure Hybrid Benefits](azure-hybrid-benefit.md) might apply, thus reducing or eliminating the Windows Server license fees.

## Impact of hyper-threading on pricing for AKS

If you enable hyper-threading on your physical computer, AKS also enables hyper-threading on the worker nodes. If you enable hyper-threading, it effectively halves the number of virtual cores needed in each worker node.

:::image type="content" source="media/pricing/hyper-thread-hyperv-manager.png" alt-text="Screenshot showing how pricing for AKS is affected by hyper-threading." lightbox="media/pricing/hyper-thread-hyperv-manager.png":::

## Next steps

[AKS on Azure Stack HCI pricing details](https://azure.microsoft.com/pricing/details/azure-stack/aks-hci)
