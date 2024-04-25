---
title: ASDK Release Notes 
description: Improvements, fixes, and known issues for Azure Stack Development Kit (ASDK).
author: sethmanheim
ms.topic: article
ms.date: 01/23/2024
ms.author: sethm
ms.reviewer: rtiberiu
ms.lastreviewed: 08/10/2020

# Intent: As an ASDK user, I want to know the latest changes, updates, and bug fixes to the ASDK.
# Keyword: asdk release notes

---


# ASDK release notes

This article provides information about changes, fixes, and known issues in the Azure Stack Development Kit (ASDK). If you're not sure which version you're running, [use the portal to check](../operator/azure-stack-updates.md).

> [!IMPORTANT]
> Starting with Azure Stack Hub 2311, we are not releasing new ASDK versions. This decision is due to modifications to internal services that would lead to substantial complexity for the ASDK. The currently released ASDK version remains suitable for operational, testing, or training purposes, including for the [Azure Stack Hub Foundation Core scripts](https://aka.ms/azshasdk) used for [Azure-Stack-Hub-Foundation-Core](https://github.com/Azure-Samples/Azure-Stack-Hub-Foundation-Core/tree/master/ASF-Training).

::: moniker range=">=azs-2306"
## Build 1.2306.2.47

### New features

- For a list of fixed issues, changes, and new features in this release, see the relevant sections in the [Azure Stack release notes](../operator/release-notes.md).

::: moniker-end

::: moniker range="azs-2301"
## Build 1.2301.0.14

### New features

- For a list of fixed issues, changes, and new features in this release, see the relevant sections in the [Azure Stack release notes](../operator/release-notes.md).

::: moniker-end

::: moniker range="azs-2206"
## Build 1.2206.0.6

### New features

- For a list of fixed issues, changes, and new features in this release, see the relevant sections in the [Azure Stack release notes](../operator/release-notes.md).

<!-- ### Fixed and known issues -->

::: moniker-end

::: moniker range="azs-2108"
## Build 1.2108.2.65

### New features

- For a list of fixed issues, changes, and new features in this release, see the relevant sections in the [Azure Stack release notes](../operator/release-notes.md).

### Fixed and known issues

- Backup and restore validation using the ASDK requires an increase to the VHD size. For more information, see [Validate an Azure Stack backup](asdk-validate-backup.md).
- SQL RP and MySQL RP are no longer supported in the ASDK.
- Metrics on the portal showing capacity information are no longer available due to product changes.

::: moniker-end
