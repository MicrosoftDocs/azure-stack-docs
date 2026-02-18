---
title: Billing for Disconnected Operations for Azure Local
description: Learn about billing for disconnected operations for Azure Local, the capacity-model, processor cores, Windows Server VMs, and more.
author: ronmiab
ms.author: robess
ms.reviewer: lihou
ms.date: 02/18/2026
ms.topic: concept-article
---

# Billing for disconnected operations for Azure Local

::: moniker range=">=azloc-2602"

This article explains billing for disconnected operations for Azure Local, including the flat-rate pricing model based on physical processor cores and the licensing requirements for Windows Server virtual machines.

## Billing and payment

Disconnected operations is one of the deployment options for Azure Local targeting customers with the strictest sovereignty requirements. The billing for the usage of this capability goes on your Azure subscription bill just like any other Azure service. It's priced on a per physical core basis on your on-premises servers that disconnected operations manages, including the physical cores needed to run the disconnected control plane. For current pricing, contact your account representative for details. The Azure Commerce billing platform centrally handles currencies and discounts, and the customer gets one unified, itemized bill at the end of the month.

## What disconnected operations for Azure Local charges for

Azure Local's cloud-style billing model is consistent, familiar, and easy for customers already using Azure or any other cloud service. Billing is based on a flat rate per physical processor core for the Azure Local instances managed by disconnected operations, including the cores to run the local control plane.

Disconnected operations for Azure Local are licensed on a capacity-based model with an annual term and billed monthly through Azure. The pricing model is different from a usage-based or consumption-based billing that's based on the number of VMs. While the number of virtual processor cores (VCPUs) can vary over the course of the month, it doesn't affect the price you pay for Azure Local. You still pay based on the number of physical cores that you purchase with disconnected operations.

## How the number of processor cores is used

When you create a disconnected operations resource, you need to provide the number of processor cores that disconnected operations manages, including the control plane itself. During the annual term, you can increase the number of physical cores if you require additional managed cores. Billing is adjusted based on the new total core count for the remainder of the license period.

## How the Windows Server VMs can be licensed

To license Windows Server virtual machines running on Azure Local with disconnected operations or to apply the Azure Hybrid Benefit, you need an eligible Windows Server license with Software Assurance or an active Windows Server subscription.

## Licensing prerequisites

To qualify for Azure Hybrid Benefit for Windows VMs on Azure Local with disconnected operations, you must meet the following licensing prerequisites.

### Types of license

- Windows Server Standard with active Software Assurance or subscription.

- Windows Server Datacenter with active Software Assurance or subscription.

### Number of licenses

You need a minimum of 8-core licenses (Datacenter or Standard edition) per VM. For example, you need 8-core licenses if you run a 4-core instance. You might run instances larger than 8-cores by allocating licenses equal to the core size of the instance. For example, 12-core licenses are required for a 12-core instance. For customers with processor licenses, each processor license is equivalent to 16-core licenses.

### Azure Migration Allowance

- **Windows Server Standard edition:** Use licenses either on-premises or on Azure Local with disconnected operations, but not at the same time. The only exception is on a one-time basis, for up to 180 days, to allow you to migrate the same workloads to Azure Local.

- **Windows Server Datacenter edition:** For VM Licensing, when migrating workloads to Azure, licenses allow simultaneous usage on-premises and on Azure Local with disconnected operations indefinitely.

## Related content

- [Pricing Overview—How Azure Pricing Works](https://azure.microsoft.com/pricing/).

- [Azure Cost and Billing](/azure/cost-management-billing/cost-management-billing-overview).

::: moniker-end

::: moniker range="<=azloc-2601"

::: moniker-end
