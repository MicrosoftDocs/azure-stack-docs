---
title: Event Hubs on Azure Stack Hub 1.2102.4.0 release notes 
description: Learn about the 1.2102.4.0 release for Event Hubs on Azure Stack Hub, including bug fixes, features, and how to install the update.
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: article
ms.date: 10/13/2023
ms.reviewer: kalkeea
ms.lastreviewed: 10/13/2023
---

# Event Hubs on Azure Stack Hub 1.2102.4.0 release notes

These release notes describe improvements and fixes in Event Hubs on Azure Stack Hub version 1.2102.4.0, and any known issues.

[!INCLUDE [Azure Stack Hub update reminder](../includes/event-hubs-hub-update-banner.md)]

## Updates in this release

This release includes the following updates:

- Minimum Azure Stack Hub version is 1.2102: this release cannot be downloaded or installed on Azure Stack Hub versions less than 1.2102.
- Upgrade path for this version of Event Hubs On Azure Stack Hub:
  - 1.2102.1.0 -> 1.2102.4.0
  - 1.2102.2.0 -> 1.2102.4.0
  - 1.2102.3.0 -> 1.2102.4.0

## Issues fixed in this release

This release includes the following fixes and improvements:

- Improved reliability of cluster creation/node rejoins in environments with slow or unreliable connectivity.
- Improved exception handling in the Event Hubs cluster startup flow in environments with slow or unreliable connectivity.

## Known issues

[!INCLUDE [secret rotation related known issues](../includes/event-hubs-secret-rotation-related-known-issues.md)]

### Limit on namespace-level authorization rule is 12 even if portal allows more  

- Applicable: This issue applies to release 1.2102.0.0 of Event Hubs on Azure Stack Hub.
- Cause: A known internal limitation.
- Remediation: None at this time. A fix is being worked on to increase the limit.

### Namespace creation using PowerShell and CLI modules fails with error

- Applicable: This issue applies to all supported releases of Event Hubs on Azure Stack Hub.
- Cause: A known design gap in the SDK modules.
- Remediation: Other methods for namespace creation can be used, including an Azure Resource Manager (ARM) template or REST API.

## Next steps

- For more information, start with the [Event Hubs on Azure Stack Hub operator overview](event-hubs-rp-overview.md).
