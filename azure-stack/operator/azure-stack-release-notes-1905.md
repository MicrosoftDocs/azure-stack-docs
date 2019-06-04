---
title: Azure Stack 1905 release notes | Microsoft Docs
description: Learn about the 1905 update for Azure Stack integrated systems, including what's new, known issues, and where to download the update.
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
ms.date: 06/04/2019
ms.author: sethm
ms.reviewer: ''
ms.lastreviewed: 06/04/2019
---

# Azure Stack 1905 update

*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1905 update package. The update includes what's new improvements, and fixes for this release of Azure Stack. This article contains the following information:

- [Description of what's new, improvements, fixes, and security updates](#whats-in-this-update)
- [Update planning](#update-planning)

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Archived release notes

You can see [older versions of Azure Stack release notes on the TechNet Gallery](http://aka.ms/azsarchivedrelnotes). These archived release notes are provided for reference purposes only and do not imply support for these versions. For information about Azure Stack support, see [Azure Stack servicing policy](azure-stack-servicing-policy.md). For further assistance, contact Microsoft Customer Support Services.

## Build reference

The Azure Stack 1905 update build number is **1.1905.0.40**.

### Update type

The Azure Stack 1905 update build type is **Full**. For more information about update build types, see the [Manage updates in Azure Stack](azure-stack-updates.md) article.

## What's in this update

<!-- The current theme (if any) of this release. -->

<!-- What's new, also net new experiences and features. -->

- With this update, the update engine in Azure Stack can update the firmware of scale unit nodes. This requires a compliant update package from the hardware partners. Reach out to your hardware partner for details about availability.

- Windows Server 2019 is now supported and available to syndicate through the Azure Stack Marketplace.
With this update, Windows Server 2019 can now be successfully activated on a 2016 host.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->
- As a part of enforcing TLS 1.2 on Azure Stack, the following extensions have been updated to these versions:

  - microsoft.customscriptextension-arm-1.9.3
  - microsoft.iaasdiagnostics-1.12.2.2
  - microsoft.antimalware-windows-arm-1.5.5.9
  - microsoft.dsc-arm-2.77.0.0
  - microsoft.vmaccessforlinux-1.5.2

  Please download these versions of the extensions immediately, so that new deployments of the extension do not fail. Always set **autoupdateminorversion=true** so that minor version updates to extensions (for example, 1.8 to 1.9) are automatically performed.

- A new **Help + support** option in the Azure Stack portal makes it easier for operators to check their support options, get expert help, and learn more about Azure Stack. For more information, see [Azure Stack help and support](azure-stack-help-and-support-overview.md).
- When multiple Azure Active Directories are onboarded (through [this process](azure-stack-enable-multitenancy.md)), it is possible to neglect rerunning the script when certain updates occur, or when changes to the AAD Service Principal authorization cause rights to be missing. This can cause various issues, from blocked access for certain features, to more discrete failures which are hard to trace back to the original issue. To prevent this, 1905 introduces a new feature that checks for these permissions and creates an alert when certain configuration issues are found. This validation runs every hour, and displays the remediation actions required to fix the issue. The alert closes once all the tenants are in a healthy state.

- Improved reliability of infrastructure backup operations during service failover. 

- An new version of the Azure Stack Nagios pluign is available that now uses the adal library for authentication. The plugin now also supports Azure Active Directory (AAD) and Active Directory Federation Services (ADFS) deployments of Azure Stack. (https://exchange.nagios.org/directory/Plugins/Cloud/Monitoring-AzureStack-Alerts/details)

### Changes

- To increase reliability and availability during planned and unplanned maintenance scenarios, Azure Stack adds an additional infrastructure role instance for domain services.

- With this update, during repair and add node operations, the hardware is validated to ensure homogenous scale unit nodes within a scale unit.

- If scheduled backups are failing to complete and the defined retention period is exceeded, the infrastructure backup controller will ensure at least one successful backup is retained. 

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

- Fixed an issue in which a **Compute host agent** warning appeared after restarting a node in the scale unit.

- Fixed issues in marketplace management in the administrator portal which showed incorrect results when filters were applied, and showed duplicate publisher names in the publisher filter. Also made performance improvements to display results faster.

- Fixed issue in the available backup blade that listed a new available backup before it completed upload to the external storage location. Now the available backup will show in the list after it is successfully uploaded to the storage location. 

<!-- ICM: 114819337; Task: 4408136 -->
- Fixed issue with retrieving recovery keys during backup operation. 

### Security updates

This update of Azure Stack does not include security updates to the underlying operating system which hosts Azure Stack. For information, see [Azure Stack security updates](azure-stack-release-notes-security-updates-1905.md).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](azure-stack-release-notes-known-issues-1905.md)
- [Security updates](azure-stack-release-notes-security-updates-1905.md)
- [Checklist of activities before and after applying the update](azure-stack-release-notes-checklist.md)

## Download the update

You can download the Azure Stack 1905 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1904 before updating Azure Stack to 1905.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Before applying the 1905 update

The 1905 release of Azure Stack must be applied on the 1904 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1904.4.45](https://support.microsoft.com/help/4505688)

### After successfully applying the 1905 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- No hotfix available for 1905.

## Automatic update notifications

Customers with systems that can access the internet from the infrastructure network will see the **Update available** message in the operator portal. Systems without internet access can download and import the .zip file with the corresponding .xml.

> [!TIP]  
> Subscribe to the following *RSS* or *Atom* feeds to keep up with Azure Stack hotfixes:
>
> - [RSS](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/rss)
> - [Atom](https://support.microsoft.com/app/content/api/content/feeds/sap/en-us/32d322a8-acae-202d-e9a9-7371dccf381b/atom)

## Next steps

- For an overview of the update management in Azure Stack, see [Manage updates in Azure Stack overview](azure-stack-updates.md).  
- For more information about how to apply updates with Azure Stack, see [Apply updates in Azure Stack](azure-stack-apply-updates.md).
- To review the servicing policy for Azure Stack integrated systems, and what you must do to keep your system in a supported state, see [Azure Stack servicing policy](azure-stack-servicing-policy.md).  
- To use the Privileged End Point (PEP) to monitor and resume updates, see [Monitor updates in Azure Stack using the privileged endpoint](azure-stack-monitor-update.md).  
- Fill out survey to provide [feedback on release notes](https://forms.microsoft.com).
