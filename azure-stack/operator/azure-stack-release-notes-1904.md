---
title: Azure Stack 1904 update | Microsoft Docs
description: Learn about the 1904 update for Azure Stack integrated systems, including what's new, known issues, and where to download the update.
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
ms.date: 04/24/2019
ms.author: sethm
ms.reviewer: ''
ms.lastreviewed: 04/24/2019
---

# Azure Stack 1904 update

*Applies to: Azure Stack integrated systems*

This article describes the contents of the 1904 update package. The update includes what's new improvements, and fixes for this release of Azure Stack. This article contains the following information:

- [Description of what's new, improvements, fixes, and security updates](azure-stack-release-notes-1904.md#whats-in-this-update)
- [Update planning](azure-stack-release-notes-1904.md#update-planning)

> [!IMPORTANT]  
> This update package is only for Azure Stack integrated systems. Do not apply this update package to the Azure Stack Development Kit.

## Build reference

The Azure Stack 1904 update build number is **1.1904.0.xx**.

## What's in this update

<!-- The current theme (if any) of this release. -->

<!-- ### What's new

What's new, also net new experiences and features. -->

### Improvements

<!-- Changes and product improvements with tangible customer-facing value. -->

- Added a notification in the administrator portal, when the currently logged in user does not have the necessary permissions, which will allow the dashboard to load properly as well as a link to the documentation on which accounts have the appropriate permissions depending on the identity provider used during deployment.

We have added fixes to improve VM resiliency and uptime which resolves the scenario where all VMs go offline if the storage volume containing the VM configuration files goes offline.

### Fixes

<!-- Product fixes that came up from customer deployments worth highlighting, especially if there is an SR/ICM associated to it. -->

| Case ID                  | Details                                                                          |
|-----------------------|----------------------------------------------------------------------------------|
| N/A                   | Fixed an issue in which the syslog configuration was not persisted through an update cycle, causing the syslog client to lose its configuration, and the syslog messages to stop being forwarded. Syslog configuration is now preserved.                                                        |

### Security updates

This update of Azure Stack does not include any security updates to the underlying operating system which hosts Azure Stack.

## Update planning

Before applying the update, make sure to review the following information:

- [Known issues](azure-stack-release-notes-known-issues-1904.md)
- [Security updates](azure-stack-release-notes-security-updates-1904.md)
- [Checklist of activities before and after applying the update](azure-stack-release-notes-checklist.md)

## Download the update

You can download the Azure Stack 1904 update package from [the Azure Stack download page](https://aka.ms/azurestackupdatedownload).

### Automatic update notifications

Customers with systems that can access the internet from the infrastructure network will see the **Update available** message in the operator portal. Systems without internet access can download and import the .zip file with the corresponding .xml.

## System monitoring

When Azure Stack is managed by System Center Operations Manager, make sure to update the [Management Pack for Microsoft Azure Stack](https://www.microsoft.com/download/details.aspx?id=55184) to version 1.0.3.11 before applying 1903.

## Hotfixes

Azure Stack releases hotfixes on a regular basis. Be sure to install the latest Azure Stack hotfix for 1903 before updating Azure Stack to 1904.

Azure Stack hotfixes are only applicable to Azure Stack integrated systems; do not attempt to install hotfixes on the ASDK.

### Before applying the 1904 update

The 1904 release of Azure Stack must be applied on the 1903 release with the following hotfixes:

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- No hotfixes available for 1903.

### After successfully applying the 1904 update

After the installation of this update, install any applicable hotfixes. For more information, see our [Servicing Policy](azure-stack-servicing-policy.md).

<!-- One of these. Either no updates at all, nothing is required, or the LATEST hotfix that is required-->
- No hotfixes available for 1904.

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
