---
title: Customer billing and chargeback in Azure Stack Hub 
description: Learn how Azure Stack Hub users are billed for resource usage, and how the billing info is accessed for analytics and chargeback.
author: sethmanheim

ms.topic: how-to
ms.date: 12/15/2021
ms.author: sethm
ms.reviewer: alfredop
ms.lastreviewed: 03/21/2019

# Intent: As an Azure Stack operator, I want to know how billing and chargebacks work and how to access them for analytics.
# Keyword: azure stack billing chargebacks

---


# Usage and billing in Azure Stack Hub

This article describes how Azure Stack Hub users are billed for resource usage, and how the billing information is accessed for analytics and chargeback.

Azure Stack Hub collects and groups usage data for resources that are used, then forwards this data to Azure Commerce. Azure Commerce bills you for Azure Stack Hub usage in the same way it bills you for Azure usage.

You can also get usage data and export it to your own billing or chargeback system by using a billing adapter, or export it to a business intelligence tool such as Microsoft Power BI.

## Usage pipeline

Each resource provider in Azure Stack Hub posts usage data per resource usage. The usage service periodically (hourly and daily) aggregates usage data and stores it in the usage database. Azure Stack Hub operators and users can access the stored usage data through the Azure Stack Hub resource usage APIs.

If you've [registered your Azure Stack Hub instance with Azure](azure-stack-registration.md), Azure Stack Hub is configured to send the usage data to Azure Commerce. After the data is uploaded to Azure, you can access it through the billing portal or by using Azure resource usage APIs. For more information about what usage data is reported to Azure, see [Usage data reporting](azure-stack-usage-reporting.md).  

The following figure shows the key components in the usage pipeline:

![Usage pipeline](media/azure-stack-billing-and-chargeback/usagepipeline.svg)

## What usage information can I find, and how?

Azure Stack Hub resource providers (such as Compute, Storage, and Network) generate usage data at hourly intervals for each subscription. The usage data contains information about the resource used; such as resource name, subscription used, and quantity used. To learn about the meters' ID resources, see the [Usage API FAQ](azure-stack-usage-related-faq.yml).

After the usage data has been collected, it is [reported to Azure](azure-stack-usage-reporting.md) to generate a bill, which can be viewed through the Azure billing portal.

> [!NOTE]  
> Usage data reporting is not required for the Azure Stack Development Kit (ASDK) and for Azure Stack Hub integrated system users who license under the capacity model. To learn more about licensing in Azure Stack Hub, see the [packaging and pricing data sheet](https://azure.microsoft.com/resources/azure-stack-hub-licensing-packaging-pricing-guide/).

The Azure billing portal shows usage data for the chargeable resources. In addition to the chargeable resources, Azure Stack Hub captures usage data for a broader set of resources, which you can access in your Azure Stack Hub environment through REST APIs or PowerShell cmdlets. Azure Stack Hub operators can get the usage data for all user subscriptions. Individual users can only get their own usage details.

## Usage reporting for multi-tenant Cloud Solution Providers

A multi-tenant Cloud Solution Provider (CSP) using Azure Stack Hub might want to report each customer usage separately, so that the provider can charge usage to different Azure subscriptions.

Each customer has their identity represented by a different Microsoft Entra tenant. Azure Stack Hub supports assigning one CSP subscription to each Microsoft Entra tenant. You can add tenants and their subscriptions to the base Azure Stack Hub registration. The base registration is done for all Azure Stack Hub instances. If a subscription is not registered for a tenant, the user can still use Azure Stack Hub, and their usage is sent to the subscription used for the base registration.

## Next steps

- [Register with Azure Stack Hub](azure-stack-registration.md)
- [Report Azure Stack Hub usage data to Azure](azure-stack-usage-reporting.md)
- [Provider Resource Usage API](azure-stack-provider-resource-api.md)
- [Tenant Resource Usage API](azure-stack-tenant-resource-usage-api.md)
- [Usage-related FAQ](azure-stack-usage-related-faq.yml)
