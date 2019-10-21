---
title: Azure Stack services, plans, offers, subscriptions overview | Microsoft Docs
description: An overview of Azure Stack services, plans, offers, and subscriptions.
services: azure-stack
documentationcenter: ''
author: BryanLa
manager: femila
editor: ''

ms.service: azure-stack
ms.topic: conceptual
ms.date: 08/29/2019
ms.author: bryanla
ms.reviewer: efemmano
ms.lastreviewed: 10/01/2019

---
# Service, plan, offer, subscription overview

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

[Microsoft Azure Stack](azure-stack-overview.md) is a hybrid cloud platform that lets you deliver services from your datacenter. Services include virtual machines (VMs), SQL Server databases, SharePoint, Exchange, and even [Azure Marketplace items](azure-stack-marketplace-azure-items.md). As a service provider, you can offer services to your tenants. Within a business or government agency, you can offer on-premises services to your employees.

## Overview

As an Azure Stack operator, you configure and deliver services by using offers, plans, and subscriptions. Offers contain one or more plans, and each plan includes one or more services, each configured with quotas. By creating plans and combining them into different offers, users can subscribe to your offers and deploy resources. This allows you to manage:

- Which services and resources your users can access.
- The amount of resources that users can consume.
- Which regions have access to the resources.

To deliver a service, follow these high-level steps:

1. Plan your service offering, using:

   - Foundational services, like compute, storage, networking, or Key Vault.
   - Add-on services, like App Service, SQL Server, or MySQL Server.

2. Create a plan that consists of one or more services. When creating a plan, select or create quotas that define the resource limits of each service in the plan.
3. Create an offer that has one or more plans. The offer can include base plans and optional add-on plans.

After you've created the offer, your users can subscribe to it to access the services and deploy resources. Users can subscribe to as many offers as they want. The following figure shows a simple example of a user who has subscribed to two offers. Each offer has a plan or two, and each plan gives them access to specific services.

![Tenant subscription with offers and plans](media/azure-stack-key-features/image4.png)

## Services

You can offer [Infrastructure as a Service](https://azure.microsoft.com/overview/what-is-iaas/) (IaaS) services that enable your users to build an on-demand computing infrastructure, provisioned and managed from the Azure Stack user portal.

You can also deploy [Platform as a Service](https://azure.microsoft.com/overview/what-is-paas/) (PaaS) services for Azure Stack from Microsoft and other third-party providers. The PaaS services that you can deliver include, but aren't limited to:

- [App Service](azure-stack-app-service-overview.md)
- [SQL Server](azure-stack-sql-resource-provider-deploy.md)
- [MySQL Server](azure-stack-mysql-resource-provider-deploy.md)

You can also combine services to integrate and build complex solutions for different users.

### Quotas

To help manage your cloud capacity, you can use pre-configured *quotas*, or create a new quota for each service in a plan. Quotas define the upper resource limits that a user subscription can provision or consume. For example, a quota might allow a user to create up to five VMs.

> [!IMPORTANT]
> It can take up to two hours for new quotas to be available in the user portal or before a changed quota is enforced.

You can set up quotas by region. For example, a plan that provides compute services for Region A could have a quota of two VMs.

>[!NOTE]
>In the Azure Stack Development Kit (ASDK), only one region (named *local*) is available.

Learn more about [quota types in Azure Stack](azure-stack-quota-types.md).

## Plans

Plans are groupings of one or more services. As an Azure Stack operator, you [create plans](azure-stack-create-plan.md) to offer to your users. In turn, your users subscribe to your offers to use the plans and services they include. When creating plans, make sure to set your quotas, define your base plans, and consider including optional add-on plans.

### Base plan

When creating an offer, the service administrator can include a base plan. These base plans are included by default when a user subscribes to that offer. When a user subscribes, they have access to all the resource providers specified in those base plans (with the corresponding quotas).

### Add-on plans

Add-on plans are optional plans you add to an offer. Add-on plans are not included by default in the subscription. Add-on plans are additional plans (with quotas) available in an offer that a subscriber can add to their subscriptions. For example, you can offer a base plan with limited resources for a trial, and an add-on plan with more substantial resources to customers who decide to adopt the service.

## Offers

Offers are groups of one or more plans that you create so that users can subscribe to them. For example, Offer Alpha can contain Plan A, which provides a set of compute services and Plan B, which provides a set of storage and network services.

When you [create an offer](azure-stack-create-offer.md), you must include at least one base plan, but you can also create add-on plans that users can add to their subscription.

When you're planning your offers, keep the following points in mind:

**Trial offers**: You use trial offers to attract new users, who can then upgrade to additional services. To create a trial offer, create a small [base plan](service-plan-offer-subscription-overview.md#base-plan) with an optional larger add-on plan. Alternatively, you can create a trial offer consisting of a small base plan, and a separate offer with a larger "pay as you go" plan.

**Capacity planning**: You might be concerned about users who grab large amounts of resources and clog the system for all users. To help performance, you can [configure your plans with quotas](service-plan-offer-subscription-overview.md#plans) to cap usage.

**Delegated providers**: You can grant others the ability to create offers in your environment. For example, if you're a service provider, you can [delegate](azure-stack-delegated-provider.md) this ability to your resellers. Or, if you're an organization, you can delegate to other divisions/subsidiaries.

## Subscriptions

Subscriptions let users access your offers. If you're an Azure Stack operator for a service provider, your users (tenants) buy your services by subscribing to your offers. If you're an Azure Stack operator at an organization, your users (employees) can subscribe to the services you offer without paying.

Users create new subscriptions and get access to existing subscriptions by signing in to Azure Stack. Each subscription represents an association with a single offer. The offer (and its plans and quotas) assigned to one subscription can't be shared with other subscriptions. Each resource that a user creates is associated with one subscription.

### Default provider subscription

The default provider subscription is automatically created when you deploy the ASDK. This subscription can be used to manage Azure Stack, deploy additional resource providers, and create plans and offers for users. For security and licensing reasons, it shouldn't be used to run customer workloads and apps. The quota of the default provider subscription can't be changed.

## Next steps

To learn more about creating plans, offers, and subscriptions, start with [Create a plan](azure-stack-create-plan.md).
