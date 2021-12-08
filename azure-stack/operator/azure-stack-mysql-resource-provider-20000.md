---
title: Azure Stack Hub MySQL resource provider 2.0.6.x release notes 
description: View the release notes to see what's new in the Azure Stack Hub MySQL resource provider 2.0.6.x update.
author: caoyang
ms.topic: article
ms.date: 08/13/2021
ms.author: caoyang
ms.reviewer: jiadu
ms.lastreviewed: 

# Intent: As an Azure Stack Hub operator, I want the release notes for the MySQL resource provider 2.0.6.x update.
# Keyword: azure stack hub mysql resource provider 2.0.6.x release notes

---

# MySQL resource provider 2.0.6.x release notes

These release notes describe the improvements and known issues in MySQL resource provider version 2.0.6.x.

## Build reference
Starting from this release, MySQL resource provider becomes a standard Azure Stack Hub value-add RP. If you want to get access to the MySQL resource provider in Azure Stack Hub marketplace, [open a support case](../operator/azure-stack-help-and-support-overview.md) to add your subscription to the allowlist. 

The resource provider has a minimum corresponding Azure Stack Hub build. The minimum Azure Stack Hub release version required to install this version of the MySQL resource provider is listed below.

It is required that you apply the minimum supported Azure Stack Hub update to your Azure Stack Hub integrated system **before** deploying the latest version of the MySQL resource provider.

> |Supported Azure Stack Hub version|MySQL resource provider version|
> |-----|-----|
> |Version 2108|MySQL RP version 2.0.6.x|  
> |     |     |

> [!IMPORTANT]
> If there is an existing version of MySQL resource provider running in your system, make sure to update it to version 1.1.93.x, before upgrading to this lattest version. 

## New features and fixes

This version of the Azure Stack Hub MySQL resource provider includes the following improvements and fixes:

- **Installation and future version upgrade will be from the Azure Stack Hub marketplace.** 
- **A specific version of Add-on RP Windows Server will be required.** The correct version of **Microsoft AzureStack Add-On RP Windows Server** will be automatically downloaded if you install the resource provider in connected environment. In disconnected environment, make sure the right version of **Microsoft AzureStack Add-On RP Windows Server** image is downloaded before deploying or upgrading to this version of the MySQL resource provider.
- **Receive alerts when certifications are about to expire.** Check [this document](azure-stack-mysql-resource-provider-maintain.md#secrets-rotation) for details.
- **Other bug fixes.**

## Known issues

After deployment or upgrade, Azure Stack Hub Operators need to manually register their default provider subscription to the tenant namespace (Microsoft.MySQLAdapter) before they can create Login or Databases. 

## Next steps

- [Learn more about the MySQL resource provider](azure-stack-mysql-resource-provider.md).
- [Prepare to deploy the MySQL resource provider](azure-stack-mysql-resource-provider-deploy.md#prerequisites).
- [Upgrade the MySQL resource provider from a previous version](azure-stack-mysql-resource-provider-update.md).
