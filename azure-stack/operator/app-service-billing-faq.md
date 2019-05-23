---
title: Azure App Service on Azure Stack Billing Overview and FAQ | Microsoft Docs
description: Details on how Azure App Service on Azure Stack is metered and charged for.
services: azure-stack
documentationcenter: ''
author: apwestgarth
manager: stefsch
editor: ''

ms.assetid:
ms.service: azure-stack
ms.workload: app-service
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/22/2019
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 05/22/2019

---

# Azure App Service on Azure Stack Billing Overview and FAQ

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

The guidance in this document illustrates how Cloud Operators are billed for offering Azure App Service on Azure Stack and how they can in turn bill their tenants for their usage of the service.

## Billing Overview

Azure Stack Cloud Operators choose to deploy the Azure App Service on Azure Stack onto their Azure Stack stamp in order to offer the tenant capabilities of Azure App Service and Azure Functions to their customers.  The Azure App Service resource provider consists of multiple types of roles which can be divided between infrastructure and worker tiers.

Infrastructure roles are not billed for as they are required for the core operation of the service.  These can be scaled out as required to support the demands of the Cloud Operator's tenants.  The infrastructure roles are as follows:

- Controllers
- Management Roles
- Publishers
- Front Ends

Worker tiers consist of two main types - shared and dedicated.  Worker usage is billed to the Cloud Operator according to the following criteria.

## Shared Workers

Shared workers are multi-tenant and host Free and Shared App Service Plans and Consumption based Azure Functions for many tenants.  Shared workers emit usage meters when marked as Ready in the Azure App Service Resource Provider.

## Dedicated workers

Dedicated workers are tied to the App Service plans which tenant(s) create.  For example in the S1 SKU by default. tenants can scale to 10 instances by default.  Therefore when a tenant creates an S1 App Service Plan, Azure App Service will allocated one of the instances in the Small Worker Tier scale set to that tenant's app Service Plan.  Subsequently the assigned worker will no longer be available to be assigned to any other tenants.  If the tenant chooses to scale the App Service Plan to 10 instances then a further 9 workers are removed from the available pool and are assigned to the tenants' App Service Plan.

Meters are emitted for dedicated workers when they are:
1. Marked as Ready in the Azure App Service Resource Provider;
1. Are assigned to an App Service Plan



Frequently Asked Questions
 