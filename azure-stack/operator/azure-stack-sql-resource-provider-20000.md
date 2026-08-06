---
title: Azure Stack Hub SQL resource provider 2.0.6.x release notes
description: View the release notes to see whats new in the Azure Stack Hub SQL resource provider 2.0.6.x update.
author: sethmanheim
ms.topic: release-notes
ms.date: 07/08/2026
ms.author: sethm
ms.reviewer: jiadu
ms.lastreviewed: 08/17/2021

# Intent: As an Azure Stack Hub operator, I want the release notes for the SQL resource provider 2.0.6.x update.
# Keyword: azure stack hub sql resource provider 2.0.6.x release notes
---

# SQL resource provider 2.0.6.x release notes

These release notes describe the improvements and known issues in SQL resource provider version 2.0.6.x.

## Build reference
Starting with this release, SQL resource provider is a standard Azure Stack Hub value-add RP. To get access to the SQL resource provider in Azure Stack Hub marketplace, [open a support case](../operator/azure-stack-help-and-support-overview.md) to add your subscription to the allowlist. 

The resource provider has a minimum corresponding Azure Stack Hub build. The minimum Azure Stack Hub release version required to install this version of the SQL resource provider is listed in the following table.

You must apply the minimum supported Azure Stack Hub update to your Azure Stack Hub integrated system **before** deploying the latest version of the SQL resource provider.

|Supported Azure Stack Hub version|SQL resource provider version|
|-----|-----|
|Version 2108,2206|SQL RP version 2.0.6.0|  
|     |     |

> [!IMPORTANT]
> If an existing version of SQL resource provider is running in your system, make sure to update it to version 1.1.93.x before upgrading to this latest version. 

## New features and fixes

This version of the Azure Stack Hub SQL resource provider includes the following improvements and fixes:

- **Installation and future version upgrade come from the Azure Stack Hub marketplace.** 
- **A specific version of Add-on RP Windows Server is required.** If you install the resource provider in connected environment, the correct version of **Microsoft AzureStack Add-On RP Windows Server** is automatically downloaded. In disconnected environment, make sure you download the right version of **Microsoft AzureStack Add-On RP Windows Server** image before deploying or upgrading to this version of the SQL resource provider.
- **Receive alerts when certifications are about to expire.** For more information, see [Secrets rotation](azure-stack-sql-resource-provider-maintain.md#secrets-rotation).
- **Other bug fixes.**

## Known issues

After deployment or upgrade, Azure Stack Hub operators need to manually register their default provider subscription to the tenant namespace (`Microsoft.SQLAdapter`) before they can create logins or databases. 

## Next steps

- [Learn more about the SQL resource provider](azure-stack-sql-resource-provider.md).
- [Prepare to deploy the SQL resource provider](azure-stack-sql-resource-provider-deploy.md#prerequisites).
- [Upgrade the SQL resource provider from a previous version](azure-stack-sql-resource-provider-update.md).
