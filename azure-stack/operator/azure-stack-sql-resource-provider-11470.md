---
title: Azure Stack Hub SQL resource provider 1.1.47.0 release notes | Microsoft Docs
description: Learn about what's in the latest Azure Stack Hub SQL resource provider update, including any known issues and where to download it.
author: justinha

ms.service: azure-stack
ms.topic: article
ms.date: 11/26/2019
ms.author: justinha
ms.reviewer: xiaofmao
ms.lastreviewed: 11/26/2019
---

# SQL resource provider 1.1.47.0 release notes

These release notes describe the improvements and known issues in SQL resource provider version 1.1.47.0.

## Build reference
Download the SQL resource provider binary and then run the self-extractor to extract the contents to a temporary directory. The resource provider has a minimum corresponding Azure Stack Hub build. The minimum Azure Stack Hub release version required to install this version of the SQL resource provider is listed below:

> |Minimum Azure Stack Hub version|SQL resource provider version|
> |-----|-----|
> |Version 1910 (1.1910.0.58)|[SQL RP version 1.1.47.0](https://aka.ms/azurestacksqlrp11470)|  
> |     |     |

> [!IMPORTANT]
> Apply the minimum supported Azure Stack Hub update to your Azure Stack Hub integrated system before deploying the latest version of the SQL resource provider.

## New features and fixes

This version of the Azure Stack Hub SQL resource provider is a hotfix release to make the resource provider compatible with some of the latest portal changes in the 1910 update without any new feature.

It also supports the current latest Azure Stack Hub API version profile 2019-03-01-hybrid and Azure Stack Hub PowerShell module 1.8.0. So during deployment and update, no specific history versions of modules need to be installed.

Please follow the resource provider update process to apply the SQL resource provider hotfix 1.1.47.0 after Azure Stack Hub is upgraded to the 1910 update. It will help address a known issue in the administrator portal where Capacity Monitoring in SQL resource provider keeps loading.

## Known issues

None.

## Next steps
[Learn more about the SQL resource provider](azure-stack-sql-resource-provider.md).

[Prepare to deploy the SQL resource provider](azure-stack-sql-resource-provider-deploy.md#prerequisites).

[Upgrade the SQL resource provider from a previous version](azure-stack-sql-resource-provider-update.md). 
