---
title: Event Hubs on Azure Stack Hub 1.2012.1.0 release notes 
description: Learn about the 1.2012.1.0 release for Event Hubs on Azure Stack Hub, including bug fixes, features, and how to install the update.
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: release-notes
ms.date: 02/15/2021
ms.reviewer: kalkeea
ms.lastreviewed: 02/15/2021
---

# Event Hubs on Azure Stack Hub 1.2012.1.0 release notes

These release notes describe improvements and fixes in Event Hubs on Azure Stack Hub version 1.2012.1.0, and any known issues. 

[!INCLUDE [Azure Stack Hub update reminder](../includes/event-hubs-hub-update-banner.md)]

## Updates in this release

This release includes the following updates:

- For Azure portal SDK developers, portal version 5.0.303.7361 is now supported.
- Internal logging improvements for Event Hubs clusters.

## Issues fixed in this release

This release includes the following fixes:

- A fix to the upgrade order for Event Hubs clusters, to address an upgrade issue.
- The cluster health and backup health check for Event Hubs clusters were not running
when clusters were in "Upgrading" or "Upgrade Failed" state. The issue has been fixed in this release.
- Fixed a bug causing usage records to contain the wrong quantity. Instead of cores, we were emitting capacity units (CU). Previously, a 1CU cluster would show 1 core in hourly usage. Users will now see the correct quantity of 10 cores for a 1 CU cluster in their hourly usage.

## Known issues 

[!INCLUDE [Azure Stack Hub update reminder](../includes/event-hubs-secret-rotation-related-known-issues.md)]

## Next steps

- For more information, start with the [Event Hubs on Azure Stack Hub operator overview](event-hubs-rp-overview.md).
