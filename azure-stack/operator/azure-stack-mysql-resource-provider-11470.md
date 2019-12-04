---
title: Azure Stack MySQL resource provider 1.1.47.0 release notes | Microsoft Docs
description: View the release notes to see what's new in the Azure Stack MySQL resource provider 1.1.47.0 update.
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
ms.reviewer: xiaofmao
ms.lastreviewed: 11/26/2019
---

# MySQL resource provider 1.1.47.0 release notes

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

These release notes describe the improvements and known issues in MySQL resource provider version 1.1.47.0.

## Build reference
Download the MySQL resource provider binary and then run the self-extractor to extract the contents to a temporary directory. The resource provider has a minimum corresponding Azure Stack build. The minimum Azure Stack release version required to install this version of the MySQL resource provider is listed below:

> |Minimum Azure Stack version|MySQL resource provider version|
> |-----|-----|
> |Version 1910 (1.1910.0.58)|[MySQL RP version 1.1.47.0](https://aka.ms/azurestackmysqlrp11470)|  
> |     |     |

> [!IMPORTANT]
> Apply the minimum supported Azure Stack update to your Azure Stack integrated system or deploy the latest Azure Stack Development Kit (ASDK) before deploying the latest version of the MySQL resource provider.

## New features and fixes

This version of the Azure Stack MySQL resource provider is a hotfix release to make the resource provider compatible with some of the latest portal changes in the 1910 update without any new feature.

It also supports the current latest Azure Stack API version profile 2019-03-01-hybrid and Azure Stack PowerShell module 1.8.0. So during deployment and update, no specific history versions of modules need to be installed.

It is recommended that you apply the MySQL resource provider hotfix 1.1.47.0 after Azure Stack is upgraded to the 1910 release.

## Known issues

None.

## Next steps
[Learn more about the MySQL resource provider](azure-stack-mysql-resource-provider.md).

[Prepare to deploy the MySQL resource provider](azure-stack-mysql-resource-provider-deploy.md#prerequisites).

[Upgrade the MySQL resource provider from a previous version](azure-stack-mysql-resource-provider-update.md). 
