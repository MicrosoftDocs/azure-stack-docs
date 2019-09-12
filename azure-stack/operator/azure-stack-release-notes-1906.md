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
ms.date: 09/05/2019
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 07/15/2019
monikerRange: 'azs-1906'
---

# Azure Stack 1906 update

*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1906 update package. The update includes what's new improvements, and fixes for this release of Azure Stack.

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1906 update build number is **1.1906.0.30**.

### Update type

The Azure Stack 1906 update build type is **Express**. For more information about update build types, see the [Manage updates in Azure Stack](azure-stack-updates.md) article. The expected time it takes for the 1906 update to complete is approximately 10 hours, regardless of the number of physical nodes in your Azure Stack environment. Exact update runtimes will typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware specifications. Runtimes lasting longer than the expected value are not uncommon and do not require action by Azure Stack operators unless the update fails. This runtime approximation is specific to the 1906 update and should not be compared to other Azure Stack updates.

## What's in this update

<!-- The current theme (if any) of this release. -->

<!-- What's new, also net new experiences and features. -->

- Added a **Set-TLSPolicy** cmdlet in the privileged endpoint (PEP) to force TLS 1.2 on all the endpoints. For more information, see [Azure Stack security controls](azure-stack-security-configuration.md).

- Added a **Get-TLSPolicy** cmdlet in the privileged endpoint (PEP) to retrieve the applied TLS policy. For more information, see [Azure Stack security controls](azure-stack-security-configuration.md).

- Added an internal secret rotation procedure to rotate internal TLS certificates as required during a system update.

- Added a safeguard to prevent expiration of internal secrets by forcing internal secrets rotation in case a critical alert on expiring secrets is ignored. This should not be relied on as a regular operating procedure. Secrets rotation should be planned during a maintenance window. For more information, see [Azure Stack secret rotation](azure-stack-rotate-secrets.md).

- Visual Studio Code is now supported with Azure Stack deployment using AD FS.

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- The **Get-GraphApplication** cmdlet in the privileged endpoint now displays the thumbprint of the currently used certificate. This improves the certificate management for service principals when Azure Stack is deployed with AD FS.

- New health monitoring rules have been added to validate the availability of AD Graph and AD FS, including the ability to raise alerts.

- Improvements to the reliability of the backup resource provider when the infrastructure backup service moves to another instance.

- Performance optimization of external secret rotation procedure to provide a uniform execution time to facilitate scheduling of maintenance window.

- The **Test-AzureStack** cmdlet now reports on internal secrets that are about to expire (critical alerts).

- A new parameter is available for the **Register-CustomAdfs** cmdlet in the privileged endpoint that enables skipping the certificate revocation list checking when configuring the federation trust for AD FS.

- The 1906 release introduces greater visibility into update progress, so you can be assured that updates are not pausing. This results in an increase in the total number of update steps shown to operators in the **Update** blade. You might also notice more update steps happening in parallel than in previous updates.

#### Networking updates

- Updated lease time set in DHCP responder to be consistent with Azure.

- Improved retry rates to the resource provider in the scenario of failed deployment of resources.

- Removed the **Standard** SKU option from both the load balancer and public IP, as that is currently not supported.

### Changes

- Creating a storage account experience is now consistent with Azure.

- Changed alert triggers for expiration of internal secrets:
  - Warning alerts are now raised 90 days prior to the expiration of secrets.
  - Critical alerts are now raised 30 days prior to the expiration of secrets.

- Updated strings in infrastructure backup resource provider for consistent terminology.

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

- Fixed an issue where resizing a managed disk VM failed with an **Internal Operation Error**.

- Fixed an issue where a failed user image creation puts the service that manages images is in a bad state; this blocks deletion of the failed image and creation of new images. This is also fixed in the 1905 hotfix.

- Active alerts on expiring internal secrets are now automatically closed after successful execution of internal secret rotation.

- Fixed an issue in which the update duration in the update history tab would trim the first digit if the update was running for more than 99 hours.

- The **Update** blade includes a **Resume** option for failed updates.

- In the administrator and user portals, fixed the issue in marketplace in which the Docker extension was incorrectly returned from search but no further action could be taken, as it is not available in Azure Stack.

- Fixed an issue in template deployment UI that does not populate parameters if the template name begins with '_' underscore.

- Fixed an issue where the virtual machine scale set creation experience provides CentOS-based 7.2 as an option for deployment. CentOS 7.2 is not available on Azure Stack. We now provide Centos 7.5 as our option for deployment

- You can now remove a scale set from the **Virtual machine scale sets** blade.

## Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](azure-stack-release-notes-security-updates.md).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](azure-stack-release-notes-known-issues-1906.md)
- [Security updates](azure-stack-release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](azure-stack-release-notes-checklist.md)

## Download the update

You can download the Azure Stack 1906 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1905 before updating Azure Stack to 1906. After updating, install any [available hotfixes for 1906](#after-successfully-applying-the-1906-update).

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Before applying the 1906 update

The 1906 release of Azure Stack must be applied on the 1905 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1905.3.48](https://support.microsoft.com/help/4510078)

### After successfully applying the 1906 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1906.13.56](https://support.microsoft.com/help/4520375)

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
