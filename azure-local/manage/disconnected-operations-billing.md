---
title: Billing for Disconnected Operations for Azure Local
description: Learn how disconnected operation for Azure Local is billed.
author: ronmiab
ms.author: robess
ms.reviewer: lihou
ms.date: 02/18/2026
ms.topic: concept-article
---

# Billing for disconnected operations for Azure Local

::: moniker range=">=azloc-2602"

This article explains billing for disconnected operations for Azure Local, including the capacity-based pricing model that uses physical processor cores and the licensing requirements for Windows Server virtual machines.

## Billing and payment

Disconnected operations is one of the deployment options for Azure Local for customers with the strictest sovereignty requirements. The billing for this capability appears on your Azure subscription bill just like any other Azure service and is priced per physical core on your on-premises servers that disconnected operations manages. This includes the physical cores needed to run the disconnected control plane. Contact your account representative for current pricing. The Azure Commerce billing platform centrally handles currencies and discounts, and you get one unified, itemized bill at the end of the month.

## Disconnected operations for Azure Local charges

Azure Local uses a cloud-style billing model that's consistent and familiar if you already use Azure or other cloud services. Billing is based on a flat monthly rate per physical processor core for Azure Local instances managed by disconnected operations. This includes the cores needed to run the local control plane.

Disconnected operations for Azure Local are licensed on a capacity-based model with an annual term, billed monthly through Azure. Unlike usage-based or consumption-based billing that charges by the number of virtual machines (VMs), Azure Local charges by physical cores. Although the number of virtual processor cores (VCPUs) can vary over the course of the month, it doesn't affect the Azure Local price you pay. You pay based on the number of physical cores you purchase with disconnected operations.

## How the number of processor cores is used

When you create a disconnected operations resource, provide the number of processor cores that it manages, including the control plane itself. During the annual term, you can increase the number of physical cores if you need more managed cores. Billing adjusts based on the new total core count for the remainder of the license period.

## How can Windows Server VMs be licensed?

To license Windows Server virtual machines running on Azure Local with disconnected operations or to apply the Azure Hybrid Benefit, you need an eligible Windows Server license with Software Assurance, or an active Windows Server subscription.

## Licensing prerequisites

To qualify for Azure Hybrid Benefit for Windows VMs on Azure Local with disconnected operations, meet the following licensing prerequisites.

Types of license:

- Windows Server Standard with active Software Assurance or subscription.

- Windows Server Datacenter with active Software Assurance or subscription.

### Number of licenses

You need at least 8-core licenses (Datacenter or Standard edition) per VM. For example, you need 8-core licenses if you run a 4-core instance. You can run instances larger than 8-cores by allocating licenses equal to the core size of the instance. For example, 12-core licenses are required for a 12-core instance. For customers with processor licenses, each processor license is equivalent to 16-core licenses.

### Azure Migration Allowance

- **Windows Server Standard edition:** Use licenses either on-premises or on Azure Local with disconnected operations, but not both at the same time. The only exception is a one-time 180-day period that lets you migrate the same workloads to Azure Local.

- **Windows Server Datacenter edition:** For VM licensing, when you migrate workloads to Azure, licenses let you use them simultaneously on-premises and on Azure Local with disconnected operations indefinitely.

## Related content

- [Pricing Overview—How Azure Pricing Works](https://azure.microsoft.com/pricing/).

- [Azure Cost and Billing](/azure/cost-management-billing/cost-management-billing-overview).

::: moniker-end

::: moniker range="<=azloc-2601"

::: moniker-end
