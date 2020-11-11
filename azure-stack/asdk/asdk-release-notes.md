---
title: ASDK Release Notes 
description: Improvements, fixes, and known issues for Azure Stack Development Kit (ASDK).
author: sethmanheim

ms.topic: article
ms.date: 11/11/2020
ms.author: sethm
ms.reviewer: misainat
ms.lastreviewed: 08/10/2020

# Intent: As an ASDK user, I want to know the latest changes, updates, and bug fixes to the ASDK.
# Keyword: asdk release notes

---


# ASDK release notes

This article provides information about changes, fixes, and known issues in the Azure Stack Development Kit (ASDK). If you're not sure which version you're running, [use the portal to check](../operator/azure-stack-updates.md).

Stay up-to-date with what's new in the ASDK by subscribing to the ![RSS](./media/asdk-release-notes/feed-icon-14x14.png) [RSS feed](https://docs.microsoft.com/api/search/rss?search=ASDK+release+notes&locale=en-us#).

::: moniker range="azs-2008"
## Build 1.2008.13.88

### New features

- For a list of fixed issues, changes, and new features in this release, see the relevant sections in the [Azure Stack release notes](../operator/release-notes.md).

### Fixed and known issues

::: moniker-end

::: moniker range="azs-2005"
## Build 1.2005.0.40

### New features

- For a list of fixed issues, changes, and new features in this release, see the relevant sections in the [Azure Stack release notes](../operator/release-notes.md).

### Fixed and known issues

- The decryption certification password is a new option to specify the password for the self-signed certificate (.pfx) that contains the private key necessary to decrypt backup data. This password is required only if the backup is encrypted using a certificate.
- Fixed an issue that caused cloud recovery to fail if the original external certificate password changed on the multi-node source system. 
- For a list of Azure Stack known issues in this release, see the [known issues](../operator/known-issues.md) article.
- Note that available Azure Stack hotfixes are not applicable to the ASDK.

#### Initial configuration fails in ASDK

- When deploying the ASDK, you may receive the error messages **Status of 'Deployment-Phase0-DeployBareMetal' is 'Error'** and **Status of 'Deployment-InitialSteps' is 'Error'**.

- As a workaround:

1. Open the file at C:\CloudDeployment\Roles\PhysicalMachines\Tests\BareMetal.Tests.ps1 in any editor with a line counter, such as PowerShell ISE.

2. Replace line 822 with:

   ```powershell

   PartNumber = if($_.PartNumber) {$_.PartNumber.Trim()} else {""};

   ```  
::: moniker-end

::: moniker range="azs-2002"
## Build 1.2002.0.35

### New features

- For a list of fixed issues, changes, and new features in this release, see the relevant sections in the [Azure Stack release notes](../operator/release-notes.md).

### Fixed and known issues

- The decryption certification password is a new option to specify the password for the self-signed certificate (.pfx) that contains the private key necessary to decrypt backup data. This password is required only if the backup is encrypted using a certificate.

- For a list of Azure Stack known issues in this release, see the [known issues](../operator/known-issues.md) article.

- Note that available Azure Stack hotfixes are not applicable to the ASDK.

#### SQL VM provision fails in ASDK

- Applicable: This issue applies to the ASDK 2002.
- Cause: When creating a new SQL VM in the ASDK 2002, you may receive an error message **Extension with publisher 'Microsoft.SqlServer.Management', type 'SqlIaaSAgent', and type handler version '2.0' could not be found in the extension repository.** There is no **SqlIaaSAgent** 2.0 in Azure Stack Hub.
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
