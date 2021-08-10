---
title: Event Hubs on Azure Stack Hub 1.2012.2.0 release notes 
description: Learn about the 1.2012.2.0 release for Event Hubs on Azure Stack Hub, including bug fixes, features, and how to install the update.
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: article
ms.date: 06/08/2021
ms.reviewer: kalkeea
ms.lastreviewed: 06/08/2021
---

# Event Hubs on Azure Stack Hub 1.2012.2.0 release notes

These release notes describe improvements and fixes in Event Hubs on Azure Stack Hub version 1.2012.2.0, and any known issues. 

[!INCLUDE [Azure Stack Hub update reminder](../includes/event-hubs-hub-update-banner.md)]

## Updates in this release

This release includes the following updates:

- Upgraded the infrastructure service fabric runtime to version 7.2.477.9590

## Issues fixed in this release

This release includes the following fixes:

- Service fabric runtime version display issue in Event Hubs management, whenever an upgrade finishes.
- HTTP port of an infrastructure service whose access wasn't removed when reassigned, caused requests to error with "service unavailable".
- Internal cluster certificate secret rotation issue that rendered clusters unresponsive when rotating the cluster certificates.

## Known issues 

[!INCLUDE [secret rotation related known issues](../includes/event-hubs-secret-rotation-related-known-issues.md)]

## Next steps

- For more information, start with the [Event Hubs on Azure Stack Hub operator overview](event-hubs-rp-overview.md).
