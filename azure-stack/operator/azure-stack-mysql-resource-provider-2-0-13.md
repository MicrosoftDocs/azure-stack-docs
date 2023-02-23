---
title: Azure Stack Hub MyMySQL resource provider 2.0.13.x release notes 
description: View the release notes to see what's new in the Azure Stack Hub MyMySQL resource provider 2.0.13.x update.
author: caoyang
ms.topic: article
ms.date: 02/16/2023
ms.author: caoyang
ms.reviewer: jiadu
ms.lastreviewed: 02/16/2023

# Intent: As an Azure Stack Hub operator, I want the release notes for the MySQL resource provider 2.0.13.x update.
# Keyword: azure stack hub MySQL resource provider 2.0.13.x release notes
---

# MySQL resource provider 2.0.13.x release notes

These release notes describe the improvements and known issues in MySQL resource provider version 2.0.13.x.

## Build reference
After release version 2.0, MySQL resource provider becomes a standard Azure Stack Hub value-add RP. If you want to get access to the MySQL resource provider in Azure Stack Hub marketplace, [open a support case](../operator/azure-stack-help-and-support-overview.md) to add your subscription to the allowlist. 

The resource provider has a minimum corresponding Azure Stack Hub build. It is required that you apply the minimum supported Azure Stack Hub update to your Azure Stack Hub integrated system **before** deploying the latest version of the MySQL resource provider.

 |Supported Azure Stack Hub version|MySQL resource provider version|MySQL Connector version|
 |-----|-----|-----|
 |Version 2108,2206|MySQL RP version 2.0.6.0|mysql-connector-net-8.0.21|
 |Version 2206|MySQL RP version 2.0.13.0|mysql-connector-net-8.0.21|
 |     |     |     |

> [!IMPORTANT]
> It is strongly recommended to upgrade to 2.0.13.0 when your Azure Stack Hub version is 2206. 

## New features and fixes

This version of the Azure Stack Hub MySQL resource provider includes the following improvements and fixes:

- UI fixes to prevent future breaks when portal is upgraded.
- Other bug fixes.

> [!IMPORTANT]
> You may need to refresh the web browser cache for the new UI fixes to take effect.

## Known issues



## Next steps

- [Learn more about the MySQL resource provider](azure-stack-MySQL-resource-provider.md).
- [Prepare to deploy the MySQL resource provider](azure-stack-MySQL-resource-provider-deploy.md#prerequisites).
- [Upgrade the MySQL resource provider from a previous version](azure-stack-MySQL-resource-provider-update.md).
