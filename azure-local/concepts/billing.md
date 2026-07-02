---
title: Azure Local billing and payment
description: How billing and payment works in Azure Local.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.service: azure-local
ms.date: 06/25/2026
---

# Azure Local billing and payment

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

Azure Local is an Azure service that appears on your Azure subscription bill just like any other Azure service. It's priced per core on your on-premises servers. For current pricing, see [Azure Local pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci/). The Azure Commerce billing platform centrally handles currencies and discounts, and you get one unified, itemized bill at the end of the month.

Azure Local doesn't require a traditional on-premises software license, although guest virtual machines (VMs) might require individual operating system licensing. For more information, see [Activate Windows Server VMs](../manage/vm-activate.md).

## What does Azure Local charge for?

Azure Local's cloud-style billing model is consistent, familiar, and easy for customers already using Azure or any other cloud service. Billing is based on a flat rate per physical processor core in an Azure Local instance (additional usage charges apply if you use other Azure services).

This pricing model is different from a usage-based or consumption-based billing model that's based on the number of VMs. While the number of virtual processor cores (VCPUs) can vary over the course of the month, it doesn't affect the price you pay for Azure Local. You still pay based on the number of physical cores that are present in the system.

## Advantages of the Azure Local billing model

- It's simple: There's no minimum, no maximum, and no math with memory, storage, or network ingress or egress.
- It rewards customers who run their virtualization infrastructure more efficiently, with higher virtual-to-physical density.
- It's easy to figure out how much your on-premises Azure Local deployment will cost, and costs scale predictably from the network edge to the data center.

## How the number of processor cores is assessed

To determine how many cores are present in a system, Azure Local periodically checks the number of physical cores and reports them to Azure. If you're only occasionally connected or your connection is interrupted, don't worry. Azure Local can always try again later. Days or weeks of core data can be uploaded at once. You must connect to Azure at least once every 30 days to allow for billing.

To manually upload core data to Azure, use the **`Sync-AzureStackHCI`** cmdlet.

## Azure Local with external storage

Azure Local uses tiered pricing based on the infrastructure capabilities you deploy:

- Azure Local (L1) applies to [hyperconverged deployments](../overview/hyperconverged-overview.md) that use local storage and support up to 16 nodes.
- Azure Local (L2) applies to deployments that use [disaggregated deployments](../overview/disaggregated-overview.md) or advanced capabilities such as [external storage (SAN)](../deploy/enable-external-storage.md) or [multi-rack deployment](../multi-rack/multi-rack-overview.md).
- Azure Local (L3) applies to deployments that use [disconnected operations](../manage/disconnected-operations-overview.md) with a locally hosted control plane.

For more information, see [Azure Local pricing overview](https://azure.microsoft.com/pricing/details/azure-local/).

Tiers L2 and L3 require cloud-connected management.

#### Existing hyperconverged deployments

When you add external storage to an existing hyperconverged deployment, a 30-day trial begins.

During the trial:

- Billing continues under your current Azure Local pricing.
- If the cluster is still within its 60-day Azure Local free trial, that free trial remains in effect until it expires.
- If the cluster free trial ends before the external storage trial, billing continues at the Azure Local (L1) rate until the external storage trial ends.

After all applicable trials end, billing automatically switches to Azure Local (L2).

Billing is updated automatically when you add or remove external storage, so charges always reflect the capabilities currently in use.

#### New SAN-only deployments

For a new SAN-only disaggregated deployment, Azure Local provides a 60-day free trial after registration.

After the free trial ends, the deployment is billed using the Azure Local (L2) meter.

## Billing changes for version 2504 and later

For deployments running solution version 12.2504.1001.20 and later, the usage record comes directly from the Azure Local resource in Azure. From this version onward, billing is cloud-based and doesn't use on-premises records.

If you shut down or decommission your system without deleting the Azure Local resource in Azure, billing continues until the Azure Local resource in Azure is disconnected for more than 31 days.

To avoid unexpected charges, delete the Azure Local resource in Azure when you decide to decommission the cluster. If you need to deploy the service again, you must go through the Azure Local deployment process. For more information, see [Deploy Azure Local](../deploy/deploy-via-portal.md).

## FAQ

- If I already have an Azure subscription, can I use it for Azure Local? **Yes**
- If my organization's finance department already approved spending on Azure, does that cover Azure Local? **Yes**
- If I have an Azure commitment to spend, can I use that toward Azure Local? **Yes**
- If I have Azure credits (for example, for students, or awarded as a prize) can I use that toward Azure Local? **Yes**
- If my organization negotiated an Enterprise Agreement discount, does that apply to Azure Local? **Yes**
- Do the Azure portal cost management tools work for Azure Local? **Yes**
- Do third-party or custom tools built with the Azure billing APIs work for Azure Local? **Yes**

## Next steps

For related information, see:

- [Pricing Overview—How Azure Pricing Works](https://azure.microsoft.com/pricing/).
- [Azure Cost and Billing](/azure/cost-management-billing/cost-management-billing-overview).
