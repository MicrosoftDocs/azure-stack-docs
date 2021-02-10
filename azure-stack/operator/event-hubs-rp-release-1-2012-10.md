---
title: Event Hubs on Azure Stack Hub 1.2012.1.0 release notes 
description: Learn about the 1.2012.1.0 release for Event Hubs on Azure Stack Hub, including bug fixes, features, and how to install the update.
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: article
ms.date: 02/09/2021
ms.reviewer: kalkeea
ms.lastreviewed: 02/09/2021
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

## Known issues 

There are no known issues for this release.

## Next steps

- For more information, start with the [Event Hubs on Azure Stack Hub operator overview](event-hubs-rp-overview.md).

