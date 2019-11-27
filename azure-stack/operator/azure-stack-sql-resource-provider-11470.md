---
title: Azure Stack SQL resource provider 1.1.47.0 release notes | Microsoft Docs
description: Learn about what's in the latest Azure Stack SQL resource provider update, including any known issues and where to download it.
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila
editor: ''

ms.assetid:  
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 11/26/2019
ms.author: justinha
ms.reviewer: jiahan
ms.lastreviewed: 11/26/2019
---

# SQL resource provider 1.1.47.0 release notes

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

These release notes describe the improvements and known issues in SQL resource provider version 1.1.47.0.

## Build reference
Download the SQL resource provider binary and then run the self-extractor to extract the contents to a temporary directory. The resource provider has a minimum corresponding Azure Stack build. The minimum Azure Stack release version required to install this version of the SQL resource provider is listed below:

> |Minimum Azure Stack version|SQL resource provider version|
> |-----|-----|
> |Version 1808 (1.1808.0.97)|[SQL RP version 1.1.33.0](https://aka.ms/azurestacksqlrp11330)|  
> |     |     |

> [!IMPORTANT]
> Apply the minimum supported Azure Stack update to your Azure Stack integrated system or deploy the latest Azure Stack Development Kit (ASDK) before deploying the latest version of the SQL resource provider.

## New features and fixes
This version of the Azure Stack SQL resource provider includes the following improvements and fixes:

### Fixes
- **SQL resource provider portal extension might choose the wrong subscription**. The SQL resource provider uses Azure Resource Manager calls to determine the first service admin subscription to use, which might not be the *Default Provider Subscription*. If that happens, the SQL resource provider does not work normally. 

## Known issues 

- **SQL SKUs can take up to an hour to be visible in the portal**. It can take up to an hour for newly created SKUs to be visible for use when creating new SQL databases. 

    **Workaround**: None.


### Known issues for Cloud Admins operating Azure Stack
Refer to the documentation in the [Azure Stack Release Notes](azure-stack-servicing-policy.md).

## Next steps
[Learn more about the SQL resource provider](azure-stack-sql-resource-provider.md).

[Prepare to deploy the SQL resource provider](azure-stack-sql-resource-provider-deploy.md#prerequisites).

[Upgrade the SQL resource provider from a previous version](azure-stack-sql-resource-provider-update.md). 