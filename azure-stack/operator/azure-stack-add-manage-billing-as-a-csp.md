---
title: Manage usage and billing for Azure Stack as a Cloud Solution Provider | Microsoft Docs
description: Learn how to register Azure Stack as a Cloud Solution Provider (CSP) and add customers for billing.
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
ms.date: 10/02/2019
ms.author: sethm
ms.reviewer: alfredop
ms.lastreviewed: 10/15/2018

---

# Manage usage and billing for Azure Stack as a Cloud Solution Provider

*Applies to: Azure Stack integrated systems*

This article describes how to register Azure Stack as a Cloud Solution Provider (CSP) and how to add customers.

As a CSP, you work with diverse customers using your Azure Stack. Each customer has a CSP subscription in Azure. You must direct usage from your Azure Stack to each user subscription.

The following figure shows the required steps to choose your shared services account, and to register the Azure account with the Azure Stack account. Once registered, you can onboard your end customers:

[![Process for enabling usage and management as a Cloud Solution Provider](media/azure-stack-add-manage-billing-as-a-csp/process-add-useage-as-a-csp.png "Process for enabling usage and management as a Cloud Solution Provider")](media/azure-stack-add-manage-billing-as-a-csp/process-add-useage-as-a-csp.png#lightbox)

## Create a CSP or APSS subscription

### CSP subscription types

Choose the type of shared services account that you use for Azure Stack. The types of subscriptions that can be used for registration of a multi-tenant Azure Stack are:

- Cloud Solution Provider
- Partner Shared Services subscription

#### Azure Partner Shared Services

Azure Partner Shared Services (APSS) subscriptions are the preferred choice for registration when a direct CSP or a CSP distributor operates Azure Stack.

APSS subscriptions are associated with a shared-services tenant. When you register Azure Stack, you provide credentials for an account that's an owner of the subscription. The account you use to register Azure Stack can be different from the admin account that you use for deployment. Furthermore, the two accounts do not need to belong to the same domain; you can deploy using the tenant that you already use. For example, you can use `ContosoCSP.onmicrosoft.com`, then register using a different tenant; for example, `IURContosoCSP.onmicrosoft.com`. You must remember to sign in using `ContosoCSP.onmicrosoft.com` when you perform daily Azure Stack administration. You sign in to Azure using `IURContosoCSP.onmicrosoft.com` when you need to perform registration operations.

For a description of APSS subscriptions and how to create them, see [Add Azure Partner Shared Services](/partner-center/shared-services).

#### CSP subscriptions

CSP subscriptions are the preferred choice for registration when a CSP reseller or an end customer operates Azure Stack.

## Register Azure Stack

Use the APSS subscription created using the info in the preceding section to register Azure Stack with Azure. For more info, see [Register Azure Stack with your Azure Subscription](azure-stack-registration.md).

## Add end customer

To configure Azure Stack so that a new tenant's resource usage is reported to their CSP subscription, see [Add tenant for usage and billing to Azure Stack](azure-stack-csp-howto-register-tenants.md).

## Charge the right subscriptions

Azure Stack uses a feature called *registration*. A registration is an object stored in Azure. The registration object documents which Azure subscription(s) to use to charge for a given Azure Stack. This section addresses the importance of registration.

Using registration, Azure Stack can:

- Forward Azure Stack usage data to Azure Commerce and bill an Azure subscription.
- Report each customer's usage on a different subscription with a multi-tenant Azure Stack deployment. Multi-tenancy enables Azure Stack to support different organizations on the same Azure Stack instance.

For each Azure Stack, there is one default subscription and many tenant subscriptions. The default subscription is an Azure subscription that is charged if there's no tenant-specific subscription. It must be the first subscription to be registered. For multi-tenant usage reporting to work, the subscription must be a CSP or APSS subscription.

Then, the registration is updated with an Azure subscription for each tenant that uses Azure Stack. Tenant subscriptions must be of the CSP type, and must roll up to the partner who owns the default subscription. You cannot register someone else's customers.

When Azure Stack forwards usage info to global Azure, a service in Azure consults the registration and maps each tenant's usage to the appropriate tenant subscription. If a tenant has not been registered, that usage goes to the default subscription for the Azure Stack instance from which it originated.

Because tenant subscriptions are CSP subscriptions, their bill is sent to the CSP partner, and usage info is not visible to the end customer.

## Next steps

- To learn more about the CSP program, see [Cloud Solution Provider program](https://partner.microsoft.com/solutions/microsoft-cloud-solutions).
- To learn more about how to retrieve resource usage info from Azure Stack, see [Usage and billing in Azure Stack](azure-stack-billing-and-chargeback.md).
