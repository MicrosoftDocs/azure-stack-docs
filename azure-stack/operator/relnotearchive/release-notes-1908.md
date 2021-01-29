---
title: Azure Stack 1908 release notes | Microsoft Docs
description: Learn about the updates for Azure Stack 1908 integrated systems, including what's new, and where to download the update.
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
ms.date: 10/29/2019
ms.author: sethm
ms.reviewer: prchint
ms.lastreviewed: 10/29/2019
---

# Azure Stack updates: 1908 release notes

*Applies to: Azure Stack integrated systems*

This article describes the contents of Azure Stack update packages. The update includes what's new improvements, and fixes for this release of Azure Stack.

To access release notes for a different version, use the version selector dropdown above the table of contents on the left.

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

> [!IMPORTANT]  
> If your Azure Stack instance is behind by more than two updates, it's considered out of compliance. You must [update to at least the minimum supported version to receive support](../azure-stack-servicing-policy.md#keep-your-system-under-support).

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](known-issues-1908.md)
- [Security updates](../release-notes-security-updates.md)
- [Checklist of activities before and after applying the update](../release-notes-checklist.md)

For help with troubleshooting updates and the update process, see [Troubleshoot patch and update issues for Azure Stack](../azure-stack-updates-troubleshoot.md).

## 1908 build reference

The Azure Stack 1908 update build number is **1.1908.4.33**.

### Update type

For 1908, the underlying operating system on which Azure Stack runs has been updated to Windows Server 2019. This enables core fundamental enhancements, as well as the ability to bring additional capabilities to Azure Stack in the near future.

The Azure Stack 1908 update build type is **Full**. As a result, the 1908 update has a longer runtime than express updates like 1906 and 1907. Exact runtimes for full updates typically depend on the number of nodes that your Azure Stack instance contains, the capacity used on your system by tenant workloads, your system's network connectivity (if connected to the internet), and your system hardware configuration. The 1908 update has had the following expected runtimes in our internal testing: 4 nodes - 42 hours, 8 nodes - 50 hours, 12 nodes - 60 hours, 16 nodes - 70 hours. Update runtimes lasting longer than these expected values are not uncommon and do not require action by Azure Stack operators unless the update fails.

For more information about update build types, see [Manage updates in Azure Stack](../azure-stack-updates.md).

- Exact update runtimes typically depend on the capacity used on your system by tenant workloads, your system network connectivity (if connected to the internet), and your system hardware configuration.
- Runtimes lasting longer than expected are not uncommon and do not require action by Azure Stack operators unless the update fails.
- This runtime approximation is specific to the 1908 update and should not be compared to other Azure Stack updates.

<!-- ## What's in this update -->

<!-- The current theme (if any) of this release. -->

### What's new

<!-- What's new, also net new experiences and features. -->

- For 1908, note that the underlying operating system on which Azure Stack runs has been updated to Windows Server 2019. This enables core fundamental enhancements, as well as the ability to bring additional capabilities to Azure Stack in the near future.
- All components of Azure Stack infrastructure now operate in FIPS 140-2 mode.
- Azure Stack operators can now remove portal user data. For more information, see [Clear portal user data from Azure Stack](../azure-stack-portal-clear.md).

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->
- Improvements to data at rest encryption of Azure Stack to persist secrets into the hardware Trusted Platform Module (TPM) of the physical nodes.

### Changes

- Hardware providers will be releasing OEM extension package 2.1 or later at the same time as Azure Stack version 1908. The OEM extension package 2.1 or later is a prerequisite for Azure Stack version 1908. For more information about how to download OEM extension package 2.1 or later, contact your system's hardware provider, and see the [OEM updates](../azure-stack-update-oem.md#oem-contact-information) article.  

### Fixes

- Fixed an issue with compatibility with future Azure Stack OEM updates and an issue with VM deployment useing customer user images. This issue was found in 1907 and fixed in hotfix [KB4517473](https://support.microsoft.com/en-us/help/4517473/azure-stack-hotfix-1-1907-12-44)  
- Fixed an issue with OEM Firmware update and corrected misdiagnosis in Test-AzureStack for Fabric Ring Health. This issue was found in 1907 and fixed in hotfix [KB4515310](https://support.microsoft.com/en-us/help/4515310/azure-stack-hotfix-1-1907-7-35)
- Fixed an issue with OEM Firmware update process. This issue was found in 1907 and fixed in hotfix [KB4515650](https://support.microsoft.com/en-us/help/4515650/azure-stack-hotfix-1-1907-8-37)

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

## Security updates

For information about security updates in this update of Azure Stack, see [Azure Stack security updates](../release-notes-security-updates.md).

## <a name="download-the-update-1908"></a>Download the update

You can download the Azure Stack 1908 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1907 before updating Azure Stack to 1908.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Prerequisites: Before applying the 1908 update

The 1908 release of Azure Stack must be applied on the 1907 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1907.17.54](https://support.microsoft.com/help/4523826)

The Azure Stack 1908 Update requires **Azure Stack OEM version 2.1 or later** from your system's hardware provider. OEM updates include driver and firmware updates to your Azure Stack system hardware. For more information about applying OEM updates, see [Apply Azure Stack original equipment manufacturer updates](../azure-stack-update-oem.md)

### After successfully applying the 1908 update

After the installation of this update, install any applicable hotfixes. For more information, see our [servicing policy](../azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- [Azure Stack hotfix 1.1908.6.37](https://support.microsoft.com/help/4527372)
