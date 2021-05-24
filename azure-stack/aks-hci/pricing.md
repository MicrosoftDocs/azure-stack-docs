---
title: Concepts - Pricing options for AKS on Azure Stack HCI
description: Learn about the pricing options for AKS on Azure Stack HCI.
author: mamezgeb
ms.topic: conceptual
ms.date: 05/12/2021
ms.author: mamezgeb
ms.reviewer: 
---

# Pricing for AKS on Azure Stack HCI
Azure Kubernetes Service (AKS) on Azure Stack HCI is a subscription-based on-premises Kubernetes offering that can be run on Azure Stack HCI 20H2 or Windows Server 2019 Hyper-V clusters. The cost of AKS on Azure Stack HCI is based on usage, and the billing data is sent to Azure.

Use the following list to explore the pricing options:

- Billing unit: **per vCPU of running worker nodes within workload clusters**:
  - AKS on Azure Stack HCI management cluster usage is *not* charged
  - The workload cluster control plane and load balancer nodes are *not* charged
  - If you enable hyperthreading on the physical computer, this reduces the measured vCPU count by 50 percent.
- Pricing: **US $1.33 per vCPU (of running worker nodes) per day**:
  - All AKS on Azure Stack HCI deployments include a free 60-day evaluation period
- Includes Linux (CBL-Mariner) Container Hosts:
  - Pricing does not include Windows container hosts as they are licensed separately through regular licensing channels
  - Windows Server Standard: Unlimited Windows containers and two Hyper-V containers
  - Windows Server Datacenter: Unlimited Windows and Hyper-V containers
- Includes Azure Arc-enabled Kubernetes at no extra charge and includes the following items:
  - **Inventory, grouping, and tagging** in Azure
  - **Deploy apps and configurations with GitOps** (usually, the initial six vCPUs are free, and then afterwards, it's $2/vCPU/month)
  - **Azure Policy for Kubernetes** (usually, $3/vCPU/cluster/month)

## Impact of hyperthreading
The AKS on Azure Stack HCI billing unit is a virtual core. If you enable hyperthreading on your physical computer, AKS on Azure Stack HCI will also enable hyperthreading on the worker nodes.  If you enable hyperthreading, it will effectively halve the number of virtual cores needed in each worker node.

![image of Hyper-V Manager showing CPU details](media/concepts/hyper-thread-hyperv-manager.png)

## Pricing comparison summary

Use the table below to compare pricing options.

> [!NOTE]
> There are additional details on pricing in the section that follows the table.

|Workload cluster configuration| AKS on Azure Stack HCI *without* hyperthreading | AKS on Azure Stack HCI *with* hyperthreading  | AKS in Azure  |
|-----------------|---|---|---|
|**-2 Worker Nodes <br> -1 x (2 vCPU VM with Linux) <br> -1 x (8 vCPU VM with Windows) <br> -10 vCPUs Total**|~US $400 per month   |~US $200 per month    | ~US $350 per month   |
|**-4 Worker Nodes <br> -2 x (4 vCPU VM with Linux) <br> -2 x (4 vCPU VM with Windows) <br> -16 vCPUs Total**|~US $640 per month   |~US $320 per month    | ~US $654 per month   | 
|**Other information**| Includes Azure Arc enabled Kubernetes. <br> Requires an additional infrastructure cost: <br>  - Azure Stack HCI 20H2+ <br>  - Windows Server 2019 Hyper-V   | Includes Azure Arc enabled Kubernetes. <br> Requires additional infrastructure cost: <br> - Azure Stack HCI 20H2+ <br> - Windows Server 2019 Hyper-V   | Includes Arc-enabled Kubernetes and the underlying infrastructure.  | 


### Additional pricing notes

- AKS on Azure Stack HCI pricing is based on the US currency list pricing with no discounts applied.
- Pricing for Windows container hosts are licensed separately. For hyperthreading, price assumes hyperthreading is available and enabled on physical systems.
- AKS on Azure Stack HCI pricing is subject to change.
- Pricing is based on US currency list pricing in the East US region with: *pay-as-you-go* pricing, D-series general purpose VM sizes, standard HDD, and no uptime SLA in the included support level.
- Pricing does not include the additional license cost for running Windows container hosts (which is required unless you have the Azure Hybrid Benefit for existing Windows Sever licenses).
- Monthly price estimates are based on 730 hours of usage. Price assumes that systems are running for the entire month.