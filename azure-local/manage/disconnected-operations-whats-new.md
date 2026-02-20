---
title: What's New in Disconnected Operations for Azure Local
description: Find out about the new features and enhancements in disconnected operations for Azure Local.
author: ronmiab
ms.topic: concept-article
ms.date: 02/23/2026
ms.author: robess
ms.reviewer: haraldfianbakken
ai-usage: ai-assisted
---

# What's new in disconnected operations for Azure Local

::: moniker range=">=azloc-2602"

This article describes new features and improvements in disconnected operations for Azure Local. Before you deploy disconnected operations with Azure Local, review the [Known issues](./disconnected-operations-known-issues.md) to understand current limitations and available workarounds.

## Features and improvements in 2602

- This release marks the general availability of disconnected operations for Azure Local.
- Added support for the Azure Local 2602 ISO and its associated capabilities.
- Several bug fixes for deployment stability and usability.
- Improved security and bug fixes.

## Related content

- [Disconnected operations for Azure Local](./disconnected-operations-overview.md).
- [Known issues in disconnected operations for Azure Local](./disconnected-operations-known-issues.md).

::: moniker-end

::: moniker range="<=azloc-2601"

## Features and improvements in 2601 (Preview)

- Added support for the Azure Local 2601 ISO and its associated capabilities.
- Added Zero Day Update (ZDU) capability for Azure Local.
- Updated Azure CLI versions and extensions.
- Improved security and bug fixes.

## Features and improvements in 2512 (Preview)

- Added support for the Azure Local 2512 ISO and its associated capabilities.
- Added update capability for 2512.
- Added registration UX to the Azure portal.
- Improved security and bug fixes.

## Features and improvements in 2511 (Preview)

- Added support for the Azure Local 2511 ISO and its associated capabilities.
- Bundled update uploader in OperationsModule.
- Improved the log collection experience.
- Added deployment automation capability for operator account during bootstrap.
- Enabled full end-to-end deployment automation.
- Fixed empty groups not synchronizing for identity integration.
- RBAC update and refresh (AKS Arc).
- Added control plane awareness for Azure Local instance deployments.

## Features and improvements in 2509 (Preview)

- Added support for the Azure Local 2508 ISO and its associated capabilities.
- Added support for System Center Operations Manager 2025 and fixed a management pack failure on newer System Center Operations Manager versions; continuing support for System Center Operations Manager 2022.
- Enabled update scenario.
- Improved security.
- Improved observability.
- Enabled LDAPS and custom port configuration for LDAP binding.
- Fixed Portal and UX issues.
- Improved OperationsModule logging and error messages and added certificate validation and CSR generation.
- Added external certificate rotation in OperationsModule. For example, `Set-ApplianceExternalEndpointCertificates`.
- Enabled the use of a FQDN in the SAN of the management certificate.

## Related content

- [Disconnected operations for Azure Local](./disconnected-operations-overview.md).
- [Known issues in disconnected operations for Azure Local](./disconnected-operations-known-issues.md).

::: moniker-end
