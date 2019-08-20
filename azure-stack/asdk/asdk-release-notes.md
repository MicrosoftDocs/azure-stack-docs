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
ms.date: 07/25/2019
ms.author: sethm
ms.reviewer: misainat
ms.lastreviewed: 07/25/2019

---

# ASDK release notes

This article provides info on changes, fixes, and known issues in the Azure Stack Development Kit (ASDK). If you're not sure which version you're running, [use the portal to check](../operator/azure-stack-updates.md#determine-the-current-version).

Stay up-to-date with what's new in the ASDK by subscribing to the [![RSS](./media/asdk-release-notes/feed-icon-14x14.png)](https://docs.microsoft.com/api/search/rss?search=Azure+Stack+Development+Kit+release+notes&locale=en-us#) [RSS feed](https://docs.microsoft.com/api/search/rss?search=Azure+Stack+Development+Kit+release+notes&locale=en-us#).

## Build 1.1907.0.20

### New features

- For a list of new features in this release, see [this section](../operator/azure-stack-release-notes-1907.md#whats-in-this-update) of the Azure Stack release notes.

<!-- ### Changes -->

### Fixed and known issues

- When creating VM resources using some Marketplace images, you might not be able to complete the deployment. As a workaround, you can click on the **Download template and parameters** link in the **Summary** page and click on the **Deploy** button in the **Template** blade.
- For a list of Azure Stack issues fixed in this release, see [this section](../operator/azure-stack-release-notes-1907.md#fixes) of the Azure Stack release notes.
- For a list of known issues, see [this article](../operator/azure-stack-release-notes-known-issues-1907.md).
- Note that [available Azure Stack hotfixes](../operator/azure-stack-release-notes-1907.md#hotfixes) aren't applicable to the Azure Stack ASDK.

## Build 1.1906.0.30

### New features

- For a list of new features in this release, see [this section](../operator/azure-stack-release-notes-1906.md#whats-in-this-update) of the Azure Stack release notes.

### Changes

- Added an **AzS-SRNG01** support ring VM hosting the log collection service for Azure Stack. For more info, see [Virtual machine roles](asdk-architecture.md).

### Fixed and known issues

- When creating VM resources using some Marketplace images, you might not be able to complete the deployment. As a workaround, you can click on the **Download template and parameters** link in the **Summary** page and click on the **Deploy** button in the **Template** blade.
- For a list of Azure Stack issues fixed in this release, see [this section](../operator/azure-stack-release-notes-1906.md#fixes) of the Azure Stack release notes.
- For a list of known issues, see [this article](../operator/azure-stack-release-notes-known-issues-1906.md).
- Note that [available Azure Stack hotfixes](../operator/azure-stack-release-notes-1906.md#hotfixes) aren't applicable to the Azure Stack ASDK.

## Build 1.1905.0.40

<!-- ### Changes -->

### New features

- For a list of new features in this release, see [this section](../operator/azure-stack-release-notes-1905.md#whats-in-this-update) of the Azure Stack release notes.

### Fixed and known issues

- Fixed an issue in which you had to edit the **RegisterWithAzure.psm1** PowerShell script in order to [register the ASDK](asdk-register.md) successfully.
- For a list of other Azure Stack issues fixed in this release, see [this section](../operator/azure-stack-release-notes-1905.md#fixes) of the Azure Stack release notes.
- For a list of known issues, see [this article](../operator/azure-stack-release-notes-known-issues-1905.md).
- Note that [available Azure Stack hotfixes](../operator/azure-stack-release-notes-1905.md#hotfixes) aren't applicable to the Azure Stack ASDK.

## Build 1.1904.0.36

<!-- ### Changes -->

### New features

- For a list of new features in this release, see [this section](../operator/azure-stack-release-notes-1904.md#whats-in-this-update) of the Azure Stack release notes.

### Fixed and known issues

- Due to a service principal timeout when running the registration script, to [register the ASDK](asdk-register.md) successfully you must edit the **RegisterWithAzure.psm1** PowerShell script. Do the following:

  1. On the ASDK host computer, open the file **C:\AzureStack-Tools-master\Registration\RegisterWithAzure.psm1** in an editor with elevated permissions.
  2. On line 1249, add a `-TimeoutInSeconds 1800` parameter at the end. This addition is required due to a service principal timeout when running the registration script. Line 1249 should now appear as follows:

     ```powershell
      $servicePrincipal = Invoke-Command -Session $PSSession -ScriptBlock { New-AzureBridgeServicePrincipal -RefreshToken $using:RefreshToken -AzureEnvironment $using:AzureEnvironmentName -TenantId $using:TenantId -TimeoutInSeconds 1800 }
      ```

- Fixed the VPN connection issue identified in release 1902.

- For a list of other Azure Stack issues fixed in this release, see [this section](../operator/azure-stack-release-notes-1904.md#fixes) of the Azure Stack release notes.
- For a list of known issues, see [this article](../operator/azure-stack-release-notes-known-issues-1904.md).
- Note that [available Azure Stack hotfixes](../operator/azure-stack-release-notes-1904.md#hotfixes) aren't applicable to the Azure Stack ASDK.

