---
title: ASDK Release Notes 
description: Improvements, fixes, and known issues for Azure Stack Development Kit (ASDK).
author: sethmanheim

ms.topic: article
ms.date: 01/27/2020
ms.author: sethm
ms.reviewer: misainat
ms.lastreviewed: 11/21/2019

# Intent: As an ASDK user, I want to know the latest changes, updates, and bug fixes to the ASDK.
# Keyword: asdk release notes

---


# ASDK release notes

This article provides information about changes, fixes, and known issues in the Azure Stack Development Kit (ASDK). If you're not sure which version you're running, [use the portal to check](../operator/azure-stack-updates.md).

Stay up-to-date with what's new in the ASDK by subscribing to the [![RSS](./media/asdk-release-notes/feed-icon-14x14.png)](https://docs.microsoft.com/api/search/rss?search=Azure+Stack+Development+Kit+release+notes&locale=en-us#) [RSS feed](https://docs.microsoft.com/api/search/rss?search=Azure+Stack+Development+Kit+release+notes&locale=en-us#).

::: moniker range="azs-2002"
## Build 1.2002.x.xx

### New features

- For a list of fixed issues, changes, and new features in this release, see the relevant sections in the [Azure Stack release notes](../operator/release-notes.md).

### Fixed and known issues

- For a list of Azure Stack known issues in this release, see the [known issues](../operator/known-issues.md) article.
- Note that available Azure Stack hotfixes are not applicable to the ASDK.
::: moniker-end

::: moniker range="azs-1910"
## Build 1.1910.0.58

### New features

- For a list of fixed issues, changes, and new features in this release, see the relevant sections in the [Azure Stack release notes](../operator/release-notes.md).

### Fixed and known issues

- Fixed an issue with collecting logs and storing them in an Azure Storage blob container. The syntax for this operation is as follows:

  ```powershell
  Get-AzureStackLog -OutputSasUri "<Blob service SAS Uri>"
  ``` 

- Fixed a deployment issue where a slow loading spooler service prevents the removal of some Windows features and requires a reboot.
- For a list of Azure Stack known issues in this release, see the [known issues](../operator/known-issues.md) article.
- Note that available Azure Stack hotfixes are not applicable to the ASDK.
::: moniker-end

::: moniker range="azs-1908"
  
## Build 1.1908.0.20

### New features

- For a list of new features in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1908#whats-new-1) of the Azure Stack release notes.

<!-- ### Changes -->

### Fixed and known issues

<!-- - For a list of Azure Stack issues fixed in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1908#fixes-1) of the Azure Stack release notes. -->
- For a list of known issues, see [this article](/azure-stack/operator/known-issues?view=azs-1908).
- Note that available Azure Stack hotfixes are not applicable to the ASDK.
::: moniker-end

::: moniker range="azs-1907"
## Build 1.1907.0.20

### New features

- For a list of new features in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1907#whats-in-this-update) of the Azure Stack release notes.

<!-- ### Changes -->

### Fixed and known issues

- When creating VM resources using some Marketplace images, you might not be able to complete the deployment. As a workaround, you can click on the **Download template and parameters** link in the **Summary** page and click on the **Deploy** button in the **Template** blade.
- For a list of Azure Stack issues fixed in this release, see [this section](/azure-stack/operator/release-notes?view=azs-1907#fixes-2) of the Azure Stack release notes.
- For a list of known issues, see [this article](/azure-stack/operator/known-issues?view=azs-1907).
- Note that [available Azure Stack hotfixes](/azure-stack/operator/release-notes?view=azs-1907#hotfixes-2) are not applicable to the Azure Stack ASDK.
::: moniker-end
