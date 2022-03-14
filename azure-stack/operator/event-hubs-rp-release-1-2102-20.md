---
title: Event Hubs on Azure Stack Hub 1.2102.2.0 release notes 
description: Learn about the 1.2102.2.0 release for Event Hubs on Azure Stack Hub, including bug fixes, features, and how to install the update.
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: article
ms.date: 03/14/2022
ms.reviewer: kalkeea
ms.lastreviewed: 03/14/2022
---

# Event Hubs on Azure Stack Hub 1.2102.2.0 release notes

These release notes describe improvements and fixes in Event Hubs on Azure Stack Hub version 1.2102.1.0, and any known issues. 

[!INCLUDE [Azure Stack Hub update reminder](../includes/event-hubs-hub-update-banner.md)]

## Updates in this release

This release includes the following updates:

- Support for Windows OS version 1.2104.0.
- Support for 2020-09-01 API Profile.

## Issues fixed in this release

This release includes the following fixes:

- Initial VM provisioning failures in slow environments.
- VM rejoining the cluster after a reboot fails sometimes.

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
