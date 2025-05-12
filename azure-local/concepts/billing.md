---
title: Azure Local billing and payment
description: How billing and payment works in Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-local
ms.date: 04/29/2025
---

# Azure Local billing and payment

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2-22h2.md)]

Azure Local is an Azure service that goes on your Azure subscription bill just like any other Azure service. It's priced on a per core basis on your on-premises servers. For current pricing, see [Azure Local pricing](https://azure.microsoft.com/pricing/details/azure-stack/hci/). Currencies and discounts are handled centrally by the Azure Commerce billing platform, and the customer gets one unified, itemized bill at the end of the month.

No traditional on-premises software license is required for Azure Local, although guest virtual machines (VMs) may require individual operating system licensing - see [Activate Windows Server VMs](../manage/vm-activate.md).

> [!TIP]
> You can get cost savings with Azure Hybrid Benefit if you have Windows Server Datacenter licenses with active Software Assurance. For more information about Azure Hybrid Benefit, see [Azure Hybrid Benefit for Azure Local](azure-hybrid-benefit.md).

## What does Azure Local charge for?

Azure Local's cloud-style billing model is consistent, familiar, and easy for customers already using Azure or any other cloud service. Billing is based on a flat rate per physical processor core in an Azure Local instance (additional usage charges apply if you use other Azure services).

The pricing model is different from a usage-based or consumption-based billing that's based on the number of VMs. While the number of virtual processor cores (VCPUs) may vary over the course of the month, it doesn't affect the price you pay for Azure Local: you still pay based on the number of physical cores that are present in the system.

## Advantages of the Azure Local billing model

- It's simple: There's no minimum, no maximum, and no math with memory, storage, or network ingress/egress.
- It rewards customers who run their virtualization infrastructure more efficiently, with higher virtual-to-physical density.
- It's easy to figure out how much your on-premises Azure Local deployment will cost, and costs scale predictably from the network edge to the data center.

## How the number of processor cores is assessed

To determine how many cores are present in a system, Azure Local periodically checks the number of physical cores and reports them to Azure. If you're only occasionally connected or your connection is interrupted, don't worry; it can always try again later. Days or weeks of core data can be uploaded at once. Customers must connect to Azure at least once every 30 days to allow for billing.

To manually upload core data to Azure, use the **`Sync-AzureStackHCI`** cmdlet.

## Billing changes for 12.2504.1001.20 and later

For deployments running solution version 12.2504.1001.20 and later, the usage record originates from the Azure Local resource in Azure directly.

If you shut down or decommission your system without deleting the Azure Local resource in Azure, billing continues until the Azure Local resource in Azure is in a disconnected state for over 31 days.

To avoid unexpected charges, you must delete the Azure Local resource in Azure when you decide to decommission the cluster. If you need to deploy the service again, you must go through the Azure Local deployment process. For more information, see [Deploy Azure Local](../deploy/deploy-via-portal.md).

## FAQ

- If I already have an Azure subscription, can I use it for Azure Local? **Yes**
- If my organization's finance department already approved spending on Azure, does that cover Azure Local? **Yes**
- If I have an Azure commitment to spend, can I use that toward Azure Local? **Yes**
- If I have Azure credits (for example, for students, or awarded as a prize) can I use that toward Azure Local? **Yes**
- If my organization negotiated an Enterprise Agreement discount, does that apply to Azure Local? **Yes**
- Do the Azure portal cost management tools work for Azure Local? **Yes**
- Do third-party or custom tools built with the Azure billing APIs work for Azure Local? **Yes**

## Next steps

For related information, see also:

- [Pricing Overview—How Azure Pricing Works](https://azure.microsoft.com/pricing/).
- [Azure Cost and Billing](/azure/cost-management-billing/cost-management-billing-overview).
