---
title: Event Hubs on Azure Stack Hub 1.2102.1.0 release notes 
description: Learn about the 1.2102.1.0 release for Event Hubs on Azure Stack Hub, including bug fixes, features, and how to install the update.
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: article
ms.date: 10/25/2021
ms.reviewer: kalkeea
ms.lastreviewed: 10/25/2021
---

# Event Hubs on Azure Stack Hub 1.2102.1.0 release notes

These release notes describe improvements and fixes in Event Hubs on Azure Stack Hub version 1.2102.1.0, and any known issues. 

[!INCLUDE [Azure Stack Hub update reminder](../includes/event-hubs-hub-update-banner.md)]

## Updates in this release

This release includes the following updates:

- Previous releases had a limit on the throughput units in a namespace, which has been removed in this release. Users can update the throughput unit of a namespace to any number, as long as the cluster allows it. 

## Issues fixed in this release

There are no fixes in this release.

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
