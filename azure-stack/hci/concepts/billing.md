---
title: Azure Stack HCI billing and payment
description: How billing and payment works in Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: conceptual
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/19/2020
---

# Azure Stack HCI billing and payment

> Applies to: Azure Stack HCI, version 20H2

Azure Stack HCI is an Azure service that goes on your Azure subscription bill just like any other Azure service. No traditional on-premises software license is required, although guest virtual machines (VMs) may require individual operating system licensing. Currencies and discounts are handled centrally by the Azure Commerce billing platform, and the customer gets one unified, itemized bill at the end of the month.

## What does Azure Stack HCI charge for?

Azure Stack HCI's cloud-style billing model is consistent, familiar, and easy for customers already using Azure or any other cloud service. Billing is based on a flat rate per physical processor core in an Azure Stack HCI cluster (additional usage charges apply if you use other Azure services).

The pricing model is different from a usage-based or consumption-based billing that's based on the number of VMs. While the number of virtual processor cores (VCPUs) may vary over the course of the month, it doesn't affect the price you pay for Azure Stack HCI: you still pay based on the number of physical cores that are present in the cluster.

## Advantages of the Azure Stack HCI billing model

- It's simple: There's no minimum, no maximum, and no math with memory, storage, or network ingress/egress.
- It rewards customers who run their virtualization infrastructure more efficiently, with higher virtual-to-physical density.
- It’s easy to figure out how much your on-premises Azure Stack HCI deployment will cost, and costs scale predictably from the network edge to the data center.

## How the number of processor cores is assessed

To determine how many cores are present in a cluster, Azure Stack HCI periodically checks the number of physical cores and reports them to Azure. If you're only occasionally connected or your connection is interrupted, don't worry; it can always try again later. Days or weeks of core data can be uploaded at once. Customers must connect to Azure at least once every 30 days to allow for billing.

To manually upload core data to Azure, use the **`Sync-AzureStackHCI`** cmdlet.

## FAQ

- If I already have an Azure subscription, can I use it for Azure Stack HCI? **Yes**
- If my organization’s finance department already approved spending on Azure, does that cover Azure Stack HCI? **Yes**
- If I have an Azure commitment to spend, can I use that toward Azure Stack HCI? **Yes**
- If I have Azure credits (e.g. for students, or awarded as a prize) can I use that toward Azure Stack HCI? **Yes**
- If my organization negotiated an Enterprise Agreement discount, does that apply to Azure Stack HCI? **Yes**
- Do the Azure portal cost management tools work for Azure Stack HCI? **Yes**
- Do third-party or custom tools built with the Azure billing APIs work for Azure Stack HCI? **Yes**

## Next steps

For related information, see also:

- [Pricing Overview—How Azure Pricing Works](https://azure.microsoft.com/pricing/)
- [Overview of Azure Cost Management and Billing](/azure/cost-management-billing/cost-management-billing-overview)
