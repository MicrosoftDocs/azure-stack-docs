---
title: Azure App Service on Azure Stack Hub billing overview and FAQ | Microsoft Docs
description: Details on how Azure App Service on Azure Stack Hub is metered and billed.
author: apwestgarth
manager: stefsch

ms.service: azure-stack
ms.topic: article
ms.date: 06/10/2019
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 06/10/2019

---

# Azure App Service on Azure Stack Hub billing overview and FAQ

This article shows how cloud operators are billed for offering Azure App Service on Azure Stack Hub and how they can bill their tenants for their use of the service.

## Billing overview

Azure Stack Hub cloud operators choose to deploy the Azure App Service on Azure Stack Hub onto their Azure Stack Hub stamp to offer the tenant capabilities of Azure App Service and Azure Functions to their customers. The Azure App Service resource provider consists of multiple types of roles that can be divided between infrastructure and worker tiers.

Infrastructure roles aren't billed because they're required for the core operation of the service. Infrastructure roles can be scaled out as required to support the demands of the cloud operator's tenants. The infrastructure roles are as follows:

- Controllers
- Management roles
- Publishers
- Front ends

Worker tiers consist of two main types: shared and dedicated. Worker usage is billed to the cloud operator's default provider subscription according to the following criteria.

## Shared workers

Shared workers are multitenant and host free and shared App Service plans and consumption-based Azure functions for many tenants. Shared workers emit usage meters when marked as ready in the Azure App Service resource provider.

## Dedicated workers

Dedicated workers are tied to the App Service plans that tenants create. For example, in the S1 SKU, tenants can scale to 10 instances by default. When a tenant creates an S1 App Service plan, Azure App Service allocates one of the instances in the small worker tier scale set to that tenant's App Service plan. The assigned worker is then no longer available to be assigned to any other tenants. If the tenant chooses to scale the App Service plan to 10 instances, nine more workers are removed from the available pool and are assigned to the tenant's App Service plan.

Meters are emitted for dedicated workers when they're:

- Marked as ready in the Azure App Service resource provider.
- Assigned to an App Service plan.

This billing model enables cloud operators to provision a pool of dedicated workers ready for customers to use without paying for the workers until they're effectively reserved by their tenant's App Service plan. 

For example, say you have 20 workers in the small worker tier. Then if you have five customers that create two S1 App Service plans each, and they each scale the App Service plan up to two instances, you have no workers available. As a result, there's also no capacity for any of your customers or new customers to scale out or create new App Service plans. 

Cloud operators can view the current number of available workers per worker tier by looking at the worker tiers in the Azure App Service configuration on Azure Stack Hub administration.

![App Service - Worker Tiers screen][1]

## See customer usage by using the Azure Stack Hub usage service

Cloud operators can query the [Azure Stack Hub Tenant Resource Usage API](azure-stack-tenant-resource-usage-api.md) to retrieve usage information for their customers. You can find all of the individual meters that App Service emits to describe tenant usage in the [Usage FAQ](azure-stack-usage-related-faq.md). These meters then are used to calculate the usage per customer subscription to calculate charges.

## Frequently asked questions

### How do I license the SQL Server and file server infrastructure required in the prerequisites?

Licensing for SQL Server and file server infrastructure, required by the Azure App Service resource provider, is covered in the Azure App Service on Azure Stack Hub [Before you get started](azure-stack-app-service-before-you-get-started.md#licensing-concerns-for-required-file-server-and-sql-server) article.

### The Usage FAQ lists the tenant meters but not the prices for those meters. Where can I find them?

As a cloud operator, you're free to apply your own pricing model to your customers. The usage service provides the usage metering. You can then use the meter quantity to charge your customers based on the pricing model you determine. The ability to set pricing enables operators to differentiate from other Azure Stack Hub operators.

### As a CSP, how can I offer free and shared SKUs for customers to try out the service?

As a cloud operator, you incur costs for offering free and shared SKUs because they're hosted in shared workers. To minimize that cost, you can choose to scale down the shared worker tier to a bare minimum. 

For example, to offer free and shared App Service plan SKUs and to offer consumption-based functions, you need a minimum of one A1 instance available. Shared workers are multitenant, so they can host multiple customer apps, each individually isolated and protected by the App Service sandbox. By scaling the shared worker tier in this way, you can limit your outlay to the cost of one vCPU per month.

You can then choose to create a quota, for use in a plan, which only offers free and shared SKUs and limits the number of free and shared App Service plans your customer can create.

## Sample scripts to assist with billing

The Azure App Service team created sample PowerShell scripts to assist with querying the Azure Stack Hub usage service. Cloud operators can use these sample scripts to prepare their own billing for their tenants. The sample scripts are in the [Azure Stack Hub Tools repository](https://github.com/Azure/AzureStack-tools) in GitHub. The App Service scripts are in the [AppService folder under Usage](https://aka.ms/aa6zku8).

The sample scripts available are:

- [Get-AppServiceBillingRecords](https://aka.ms/aa6zku2): This sample fetches Azure App Service on Azure Stack Hub billing records from the Azure Stack Hub Usage API.
- [Get-AppServiceSubscriptionUsage](https://aka.ms/aa6zku6): This sample calculates Azure App Service on Azure Stack Hub usage amounts per subscription. This script calculates usage amounts based on data from the Usage API and the prices provided per meter by the cloud operator.
- [Suspend-UserSubscriptions](https://aka.ms/aa6zku7): This sample suspends or enables subscriptions based on usage limits specified by the cloud operator.

## Next steps

- [Azure Stack Hub Tenant Resource Usage API](azure-stack-tenant-resource-usage-api.md)

<!--Image references-->
[1]: ./media/app-service-billing-faq/app-service-worker-tiers.png
