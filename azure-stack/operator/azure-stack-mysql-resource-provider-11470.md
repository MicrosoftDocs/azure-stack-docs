---
title: Azure Stack Hub MySQL resource provider 1.1.47.0 release notes 
description: View the release notes to see what's new in the Azure Stack Hub MySQL resource provider 1.1.47.0 update.
author: sethmanheim
ms.topic: release-notes
ms.date: 01/17/2025
ms.author: sethm
ms.lastreviewed: 11/26/2019

# Intent: As an Azure Stack Hub operator, I want the release notes for the MySQL resource provider 1.1.47.0 update.
# Keyword: azure stack hub mysql resource provider 1.1.47.0 release notes

---

# MySQL resource provider 1.1.47.0 release notes

These release notes describe the improvements and known issues in MySQL resource provider version 1.1.47.0.

## Build reference

Download the MySQL resource provider binary and then run the self-extractor to extract the contents to a temporary directory. The resource provider has a minimum corresponding Azure Stack Hub build. The minimum Azure Stack Hub release version required to install this version of the MySQL resource provider is listed below:

> |Minimum Azure Stack Hub version|MySQL resource provider version|
> |-----|-----|
> |Version 1910 (1.1910.0.58)|[MySQL RP version 1.1.47.0](https://aka.ms/azurestackmysqlrp11470)|  
> |     |     |

> [!IMPORTANT]
> Apply the minimum supported Azure Stack Hub update to your Azure Stack Hub integrated system or deploy the latest Azure Stack Development Kit (ASDK) before deploying the latest version of the MySQL resource provider.

## New features and fixes

This version of the Azure Stack Hub MySQL resource provider is a hotfix release to make the resource provider compatible with some of the latest portal changes in the 1910 update. There are no new features.

It also supports the latest Azure Stack Hub API version profile 2019-03-01-hybrid and Azure Stack Hub PowerShell module 1.8.0. So during deployment and update, no specific history versions of modules need to be installed.

It's recommended that you apply the MySQL resource provider hotfix 1.1.47.0 after Azure Stack Hub is upgraded to the 1910 release.

## Known issues

When you [rotate a certificate](azure-stack-mysql-resource-provider-maintain.md#secrets-rotation) for Azure Stack Hub integrated systems, the `KeyVaultPfxPassword` argument is mandatory, even if there's no intention to update the Key Vault certificate password.

## Next steps

- [Learn more about the MySQL resource provider](azure-stack-mysql-resource-provider.md).
- [Prepare to deploy the MySQL resource provider](azure-stack-mysql-resource-provider-deploy.md#prerequisites).
- [Upgrade the MySQL resource provider from a previous version](azure-stack-mysql-resource-provider-update.md).
