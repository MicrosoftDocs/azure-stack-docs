---
title: Advanced ASDK evaluation tasks 
description: Learn about advanced Azure Stack Development KIt (ASDK) evaluation tasks.
author: sethmanheim

ms.topic: article
ms.date: 02/12/2019
ms.author: sethm
ms.reviewer: misainat
ms.lastreviewed: 10/16/2019

# Intent: As an ASDK user, I want to know about advanced ASDK evalutation tasks to save my tenants time and resources.
# Keyword: asdk advanced evaluation tasks

---


# Advanced ASDK evaluation tasks
After you have gained familiarity with the basic Azure Stack Development Kit (ASDK) service features and capabilities, you can deepen your understanding of Azure Stack further by testing out more advanced scenarios. These more advanced evaluation tasks are documented fully in the Azure Stack Operator documentation.

> [!NOTE]
> While many operator tasks are supported for both ASDK and production and multi-node Azure Stack deployments, not all usage scenarios are supported for ASDK deployments. For more information, see [ASDK and multi-node Azure Stack differences](asdk-what-is.md#asdk-and-multi-node-azure-stack-hub-differences).

## Delegate offers in Azure Stack
As the Azure Stack Operator, you often want to put other people in charge of creating offers and signing up users. For example, if you're a service provider, you might want resellers to sign up customers and manage them on your behalf. Or if you're part of a central IT group in an enterprise, you might want subsidiaries to sign up users without your intervention.

[Delegating offers in Azure Stack](../operator/azure-stack-delegated-provider.md) helps you with these tasks by making it possible to reach and manage more users than you can directly.

## Make SQL databases available to your Azure Stack users
As an Azure Stack Operator, you can create offers that let your users (tenants) create SQL databases that they can use with their cloud-native apps, websites, and workloads. By providing these custom, on-demand, cloud-based databases to your users, you save them time and resources.

Use the SQL Server resource provider adapter to [make SQL databases available to your Azure Stack users](../operator/azure-stack-sql-resource-provider.md) as a service of Azure Stack. After you install the resource provider, you connect it to one or more SQL Server instances.

## Make web and API apps available to your Azure Stack users
As an Azure Stack Operator, you can create offers that let your users (tenants) create Azure Functions and web and API apps. By providing access to these on-demand and cloud-based apps to your users, you can save them time and resources.

Deploy the App Service resource provider to [make web and API apps available to your Azure Stack users](../operator/azure-stack-app-service-overview.md).

## Next steps

[Learn more about offering services with Azure Stack integrated systems](../operator/service-plan-offer-subscription-overview.md)
