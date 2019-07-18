---
title: Azure Stack 1907 release notes | Microsoft Docs
description: Learn about the 1907 update for Azure Stack integrated systems, including what's new, known issues, and where to download the update.
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
ms.date: 07/26/2019
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 07/26/2019
---

# Azure Stack 1907 update

*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1907 update package. The update includes what's new improvements, and fixes for this release of Azure Stack.

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1907 update build number is **1.1907.x.xx**.

### Update type

The Azure Stack 1907 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](azure-stack-updates.md) article. The expected time it takes for the 1907 update to complete is approximately 10 hours. 
 - Exact update runtimes will typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware configuration. 
 - Runtimes lasting longer than the expected value are not uncommon and do not require action by Azure Stack operators unless the update fails. 
 - This runtime approximation is specific to the 1907 update and should not be compared to other Azure Stack updates.

## What's in this update

<!-- The current theme (if any) of this release. -->

<!-- What's new, also net new experiences and features. -->
- General availability release of the Azure Stack diagnostic log collection service to facilitate and improve diagnostic log collection. The Azure Stack diagnostic log collection service provides a simplified way to collect and share diagnostic logs with Microsoft Customer Support Services (CSS). The Azure Stack diagnostic log collection service provides a new user experience in the Azure Stack administrator portal that enables operators to set up the automatic upload of diagnostic logs to a storage blob when certain critical alerts are raised, or to perform the same operation on demand. For more information, see the [Diagnostic log collection](azure-stack-diagnostic-log-collection-overview.md) article.

- Added an internal secret rotation procedure to rotate internal SQL TLS certificates as required during a system update.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- Azure Stack exposes two commands through the privileged endpoint for starting and stopping Azure Stack: **Start-AzureStack** and **Stop-AzureStack**. **Start-AzureStack** automatically runs as part of powering on an environment. **Stop-AzureStack** is the recommended way to cleanly shut down an environment. Previously, the startup process took about 40-45 minutes on a physical 4-node, and **Stop-AzureStack** about 30 minutes. In an effort to improve startup and shutdown processes, we have optimized our action plan such that the **Start-AzureStack** workflow time has been reduced to 20.5 minutes (52% reduced time on average) and **Stop-AzureStack** to 20 minutes (30% reduced time). 

- Improved error handling for the disconnected Marketplace tool. If a download fails or partially succeeds when using **Export-AzSOfflineMarketplaceItem**, a detailed error message is displayed with more details about the error and mitigation steps, if any.

- Improved the performance of managed disk creation from a large page blob/snapshot. Previously, it triggered a timeout when creating a large disk.  

<!-- https://icm.ad.msft.net/imp/v3/incidents/details/127669774/home -->
- Improved virtual disk health check before shutting down a node to avoid unexpected virtual disk detaching.

#### Networking updates

- Added a new outbound rule (HTTPS) to enable communication for Azure Stack diagnostic log collection service. For more information, see [Azure Stack datacenter integration - Publish endpoints](azure-stack-integrate-endpoints.md#ports-and-urls-outbound).

### Changes

- The infrastructure backup service will delete partially uploaded backups if the external storage location runs out of capacity.

- Infrastructure backups no longer include a backup of domain services data. This only applies to systems using Azure Active Directory as their identity provider.

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->
- Fixed an issue in which the publisher, offer, and SKU were treated as case sensitive in a Resource Manager template: the image was not fetched for deployment unless the image parameters were the same case as that of the publisher, offer, and SKU.

<!-- https://icm.ad.msft.net/imp/v3/incidents/details/129536438/home -->
- Fixed an issue with backups failing with a **PartialSucceeded** error message, due to timeouts during backup of storage service metadata.  

<!-- https://icm.ad.msft.net/imp/v3/incidents/details/127772311/home -->
- Fixed an issue in which the update fails due to a DLL file locked by the WMI provider host.

## Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](azure-stack-release-notes-security-updates-1907.md).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](azure-stack-release-notes-known-issues-1907.md)
- [Security updates](azure-stack-release-notes-security-updates-1907.md)
- [Checklist of activities before and after applying the update](azure-stack-release-notes-checklist.md)

## Download the update

You can download the Azure Stack 1907 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1906 before updating Azure Stack to 1907.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Before applying the 1907 update

The 1907 release of Azure Stack must be applied on the 1906 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1906.11.52](https://support.microsoft.com/help/4513119)

### After successfully applying the 1907 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- No hotfix available for 1907.

## Automatic update notifications

Customers with systems that can access the internet from the infrastructure network will see the **Update available** message in the operator portal. Systems without internet access can download and import the .zip file with the corresponding .xml.

> [!TIP]  
> Subscribe to the following *RSS* or *Atom* feeds to keep up with Azure Stack hotfixes:
>
> - [RSS](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/rss)
> - [Atom](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/atom)

## Archived release notes

You can see [older versions of Azure Stack release notes on the TechNet Gallery](https://aka.ms/azsarchivedrelnotes). These archived release notes are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack support, see [Azure Stack servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.

## Next steps

- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](azure-stack-apply-updates.md).
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](azure-stack-monitor-update.md).
