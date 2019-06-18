---
title: Azure Stack 1906 release notes | Microsoft Docs
description: Learn about the 1906 update for Azure Stack integrated systems, including what's new, known issues, and where to download the update.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid:  
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 06/18/2019
ms.author: sethm
ms.reviewer: ''
ms.lastreviewed: 06/18/2019
---

# Azure Stack 1906 update

*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1906 update package. The update includes what's new improvements, and fixes for this release of Azure Stack. This article contains the following information:

- [Description of what's new, improvements, fixes, and security updates](#whats-in-this-update)
- [Update planning](#update-planning)

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1906 update build number is **1.1906.0.21**.

### Update type

The Azure Stack 1906 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](azure-stack-updates.md) article.

## What's in this update

<!-- The current theme (if any) of this release. -->

<!-- What's new, also net new experiences and features. -->

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

### Changes

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

### Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](azure-stack-release-notes-security-updates-1906.md).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](azure-stack-release-notes-known-issues-1906.md)
- [Security updates](azure-stack-release-notes-security-updates-1906.md)
- [Checklist of activities before and after applying the update](azure-stack-release-notes-checklist.md)

## Download the update

You can download the Azure Stack 1906 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1905 before updating Azure Stack to 1906.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Before applying the 1906 update

The 1906 release of Azure Stack must be applied on the 1905 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- No hotfix available for 1905.

### After successfully applying the 1906 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- No hotfix available for 1906.

## Automatic update notifications

Customers with systems that can access the internet from the infrastructure network will see the **Update available** message in the operator portal. Systems without internet access can download and import the .zip file with the corresponding .xml.

> [!TIP]  
> Subscribe to the following *RSS* or *Atom* feeds to keep up with Azure Stack hotfixes:
>
> - [RSS](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/rss)
> - [Atom](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/atom)

## Archived release notes

You can see [older versions of Azure Stack release notes on the TechNet Gallery](http://aka.ms/azsarchivedrelnotes). These archived release notes are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack support, see [Azure Stack servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.

## Next steps

- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](azure-stack-apply-updates.md).
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](azure-stack-monitor-update.md).  

