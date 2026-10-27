---
title: SAN storage deployment and preparation for multi-rack deployments of Azure Local
description: Learn about supported SAN storage configurations and appliance placement for multi-rack deployments of Azure Local.
author: perfectchaos
ms.author: chaoschhapi
ms.service: azure-local
ms.date: 10/12/2026
ms.topic: concept-article
ms.subservice: multi-rack
---

# SAN storage deployment and preparation for multi-rack deployments of Azure Local

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

Microsoft delivers multi-rack deployments of Azure Local as preintegrated racks that include compute, storage, and networking. SAN storage provides persistent storage for platform services and workloads.

Deployment engineers perform vendor-specific preparation and configuration to onboard and validate the storage appliance as part of rack preparation. You provide the site prerequisites and deployment inputs identified by the deployment team. For the deployment prerequisites, see [Prerequisites for multi-rack deployments](multi-rack-prerequisites.md).

This article describes the supported storage configurations and appliance placement for storage included in the approved hardware bill of materials (BOM).

## Supported storage configurations

The following table lists supported storage vendors, appliance models, software versions, and release applicability. ALRS refers to the Azure Local Rack Scale platform release.

| Storage vendor | Supported models | Minimum supported software version and release applicability |
| --- | --- | --- |
| Pure Storage | FlashArray X-series and C-series | Purity//FA 6.9.x, from ALRS 1.6. |
| NetApp | AFF and ASA A-series and C-series | Minimum validated ONTAP version: 9.12.1, from ALRS 1.3. |
| Dell Technologies | PowerStore T and Q models | Minimum validated PowerStoreOS version: 4.3.0, from ALRS 2.0. |

A minimum validated software version doesn't, by itself, establish compatibility with every later version. Confirm compatibility with Microsoft and your storage vendor before changing the appliance software or hardware configuration.

Appliance capacity and expansion options depend on the approved configuration. Work with your Microsoft account team and storage vendor to select a configuration that's appropriate for your workload capacity and performance requirements.

## Storage appliance placement and connectivity

Multi-rack deployments of Azure Local support up to two on-rack storage appliances. The approved BOM determines the appliance models and combination included in your deployment.

Azure Local and the appliances communicate by using internal, predefined networks, addresses, and VLANs that the rack preparation process configures.

> [!NOTE]
> You don't need to configure your own networks to enable communication between the platform and its storage appliances.

For information about responsibilities and supported operations after deployment, see [Manage SAN storage appliances](multi-rack-manage-san-storage.md).
