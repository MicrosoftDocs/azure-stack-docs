---
title: Usage reporting infrastructure for Cloud Solution Providers for Azure Stack | Microsoft Docs
description: Learn about the usage reporting infrastructure used to track usage for tenants serviced by a Cloud Solution Provider (CSP).
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/31/2019
ms.author: sethm
ms.reviewer: alfredop
ms.lastreviewed: 05/09/2019

---

# Usage reporting infrastructure for Cloud Solution Providers

Azure Stack includes the infrastructure needed to track usage as it occurs and forwards it to Azure. In Azure, Azure Commerce processes the usage data and charges usage to the appropriate Azure subscriptions. This process works in the same way as usage tracking in the global Azure cloud.

Certain concepts are consistent between global Azure and Azure Stack. Azure Stack has local subscriptions, which fulfill a similar role to an Azure subscription. Local subscriptions are only valid locally. Local subscriptions are mapped to Azure subscriptions when usage is forwarded to Azure.

Azure Stack has local usage meters. Local usage is mapped to the meters used in Azure commerce. However, the meter IDs are different. There are more meters available locally than the one Microsoft uses for billing.

There are some differences between how services are priced in Azure Stack and Azure. For example, in Azure Stack, the charge for VMs is only based on vcore/hours, with the same rate for all VM series, unlike Azure. The reason is that in global Azure the different prices reflect different hardware. In Azure Stack, the customer provides the hardware, so there's no reason to charge different rates for different VM classes.

You can find out about the Azure Stack meters used in Commerce and their prices in Partner Center. The process is the same as it is for Azure services:

1. In Partner Center, go to the **Dashboard menu**, then select **Sell**, then select **Pricing and offers**.
2. Under **Usage-based services**, select **Current**.
3. Open the **Azure in Global CSP price list** spreadsheet.
4. Filter on **Region = Azure Stack**.

## Terms used for billing and usage

The following terms and concepts are used for usage and billing in Azure Stack:

| Term | Definition |
| --- | --- |
| Direct CSP partner | A direct Cloud Solution Provider (CSP) partner receives an invoice directly from Microsoft for Azure and Azure Stack usage, and bills customers directly. |
| Indirect CSP | Indirect resellers work with an indirect provider (also known as a distributor). The resellers recruit end customers; the indirect provider holds the billing relationship with Microsoft, manages customer billing, and provides additional services like product support. |
| End customer | End customers are the businesses and government agencies that own the apps and other workloads that run on Azure Stack. |

## Next steps

- To learn more about the CSP program, see [Cloud Solutions](https://partner.microsoft.com/solutions/microsoft-cloud-solutions).
- To learn more about how to retrieve resource usage information from Azure Stack, see [Usage and billing in Azure Stack](azure-stack-billing-and-chargeback.md).
