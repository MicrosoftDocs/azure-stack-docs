---
title: ASDK Release Notes | Microsoft Docs
description: Improvements, fixes, and known issues for Azure Stack Development Kit (ASDK).
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila

ms.assetid:
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/30/2019
ms.author: sethm
ms.reviewer: misainat
ms.lastreviewed: 08/30/2019

---

# ASDK release notes

This article provides info on changes, fixes, and known issues in the Azure Stack Development Kit (ASDK). If you're not sure which version you're running, [use the portal to check](../operator/azure-stack-updates.md).

Stay up-to-date with what's new in the ASDK by subscribing to the [![RSS](./media/asdk-release-notes/feed-icon-14x14.png)](https://docs.microsoft.com/api/search/rss?search=Azure+Stack+Development+Kit+release+notes&locale=en-us#) [RSS feed](https://docs.microsoft.com/api/search/rss?search=Azure+Stack+Development+Kit+release+notes&locale=en-us#).

::: moniker range="azs-1908"
## Build 1.1908.0.20

### New features

- For a list of new features in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1908#whats-new-1908) of the Azure Stack release notes.

<!-- ### Changes -->

### Fixed and known issues

<!-- - For a list of Azure Stack issues fixed in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1908#fixes-1908) of the Azure Stack release notes. -->
- For a list of known issues, see [this article](/azure-stack/operator/known-issues?view=azs-1908).
- Note that available Azure Stack hotfixes are not applicable to the ASDK.
::: moniker-end

::: moniker range="azs-1907"
## Build 1.1907.0.20

### New features

- For a list of new features in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1907#whats-in-this-update-1907) of the Azure Stack release notes.

<!-- ### Changes -->

### Fixed and known issues

- When creating VM resources using some Marketplace images, you might not be able to complete the deployment. As a workaround, you can click on the **Download template and parameters** link in the **Summary** page and click on the **Deploy** button in the **Template** blade.
- For a list of Azure Stack issues fixed in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1907#fixes-1907) of the Azure Stack release notes.
- For a list of known issues, see [this article](/azure-stack/operator/known-issues?view=azs-1907).
- Note that [available Azure Stack hotfixes](/azure-stack/operator/release-notes?view=azs-1907#hotfixes-1907) are not applicable to the Azure Stack ASDK.
::: moniker-end

::: moniker range="azs-1906"
## Build 1.1906.0.30

### New features

- For a list of new features in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1906#whats-in-this-update-1906) of the Azure Stack release notes.

### Changes

- Added an **AzS-SRNG01** support ring VM hosting the log collection service for Azure Stack. For more info, see [Virtual machine roles](asdk-architecture.md).

### Fixed and known issues

- When creating VM resources using some Marketplace images, you might not be able to complete the deployment. As a workaround, you can click on the **Download template and parameters** link in the **Summary** page and click on the **Deploy** button in the **Template** blade.
- For a list of Azure Stack issues fixed in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1906#fixes-1906) of the Azure Stack release notes.
- For a list of known issues, see [this article](/azure-stack/operator/known-issues?view=azs-1906).
- Note that [available Azure Stack hotfixes](/azure-stack/operator/release-notes?view=azs-1906#hotfixes-1906) are not applicable to the Azure Stack ASDK.
::: moniker-end

::: moniker range="azs-1905"
## Build 1.1905.0.40

<!-- ### Changes -->

### New features

- For a list of new features in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1905#whats-in-this-update-1905) of the Azure Stack release notes.

### Fixed and known issues

- Fixed an issue in which you had to edit the **RegisterWithAzure.psm1** PowerShell script in order to [register the ASDK](asdk-register.md) successfully.
- For a list of other Azure Stack issues fixed in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1905#fixes-1905) of the Azure Stack release notes.
- For a list of known issues, see [this article](/azure-stack/operator/known-issues?view=azs-1905).
- Note that [available Azure Stack hotfixes](/azure-stack/operator/release-notes?view=azs-1905#hotfixes-1905) are not applicable to the Azure Stack ASDK.
::: moniker-end
