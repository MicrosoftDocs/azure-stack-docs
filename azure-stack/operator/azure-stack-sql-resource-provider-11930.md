---
title: Azure Stack Hub SQL resource provider 1.1.93.0 release notes 
description: View the release notes to see what's new in the Azure Stack Hub SQL resource provider 1.1.93.0 update.
author: caoyang
ms.topic: article
ms.date: 09/22/2020
ms.author: caoyang
ms.reviewer: xiaofmao
ms.lastreviewed: 09/22/2020

# Intent: As an Azure Stack Hub operator, I want the release notes for the SQL resource provider 1.1.93.0 update.
# Keyword: azure stack hub sql resource provider 1.1.93.0 release notes

---

# SQL resource provider 1.1.93.0 release notes

These release notes describe the improvements and known issues in SQL resource provider version 1.1.93.0.

## Build reference
Download the SQL resource provider binary and then run the self-extractor to extract the contents to a temporary directory. The resource provider has a minimum corresponding Azure Stack Hub build. The minimum Azure Stack Hub release version required to install this version of the SQL resource provider is listed below:

> |Supported Azure Stack Hub version|SQL resource provider version|
> |-----|-----|
> |Version 2008, 2005|[SQL RP version 1.1.93.0](https://aka.ms/azshsqlrp11930)|  
> |     |     |

> [!IMPORTANT]
> Apply the minimum supported Azure Stack Hub update to your Azure Stack Hub integrated system before deploying the latest version of the MySQL resource provider.

## New features and fixes

This version of the Azure Stack Hub SQL resource provider includes the following improvements and fixes:

- **Update the base VM to a specialized Windows Server.** This Windows Server version is specialize for Azure Stack Hub Add-On RP Infrastructure and it is not visible to the tenant marketplace. Make sure to download the **Microsoft AzureStack Add-On RP Windows Server INTERNAL ONLY** image before deploying or upgrading to this version of the SQL resource provider.
- **Support removing orphaned database metadata and hosting server metadata.** When a hosting server cannot be connected anymore, the tenant will have an option to remove the orphaned database metadata from the portal. When there is no orphaned database metadata linked to the hosting server, the operator will be able to remove the orphaned hosting server metadata from the admin portal.
- **Make KeyVaultPfxPassword an optional argument when performing secrets rotation.** Check [this document](azure-stack-sql-resource-provider-maintain.md#secrets-rotation) for details.
- **Other bug fixes.**

It's recommended that you apply SQL resource provider 1.1.93.0 after Azure Stack Hub is upgraded to the 2005 release.

## Known issues
None.

## Next steps

- [Learn more about the SQL resource provider](azure-stack-sql-resource-provider.md).
- [Prepare to deploy the SQL resource provider](azure-stack-sql-resource-provider-deploy.md#prerequisites).
- [Upgrade the SQL resource provider from a previous version](azure-stack-sql-resource-provider-update.md).

