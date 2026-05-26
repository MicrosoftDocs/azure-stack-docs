---
title: Firewall Requirements for Small Form Factor Deployments of Azure Local (preview)
description: This article provides guidance on firewall requirements for small form factor deployments of Azure Local (preview).
author: sipastak
ms.topic: concept-article
ms.date: 05/04/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
ms.custom: references_regions
---

# Firewall requirements for small form factor deployments of Azure Local (preview)

This article describes the fully qualified domain name (FQDN) firewall requirements for small form factor deployments of Azure Local that use **Arc Gateway** in the **East US** region.

Use this allow list to configure outbound firewall rules required for a successful deployment.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Firewall allow list (2604, East US)

The following table lists the outbound endpoints and ports required for small form factor deployments with Arc Gateway in the East US region.

| No. | Endpoint FQDN | Port | Component | Notes |
|----:|---------------|:----:|-----------|-------|
| 1 | `<your-gateway-endpoint-id>.gw.arc.azure.com` | 443 | Azure Local Arc Gateway | Example: `1a2fc225-ac05-4dbf-9da2-0d9a3e9062de.gw.arc.azure.com` |
| 2 | `<your-device-endpoint>.eastus.deviceonboard.azure.net` | 443 | Azure onboarding provisioning service | Example: `onboardingservice-emh3bxgvbjg5hdgb.eastus.deviceonboard.azure.net` |
| 3 | `agentserviceapi.guestconfiguration.azure.com` | 443 | Azure Local Arc agent | |
| 4 | `aka.ms` | 443 | Azure Local OS provisioning | |
| 5 | `azgn-eastus-public-1p-cusdm-vazr0001.servicebus.windows.net` | 443 | Azure Local Arc agent | |
| 6 | `azgn-eastus-public-2p-cusdm-vazr0002.servicebus.windows.net` | 443 | Azure Local Arc agent | |
| 7 | `azurestackreleases.download.prss.microsoft.com` | 443 | Azure Local OS provisioning | |
| 8 | `dp.stackhci.azure.com` | 443 | Azure Local diagnostics and billing | |
| 9 | `eastus-gas.guestconfiguration.azure.com` | 443 | Azure Local Arc agent | |
| 10 | `eastus-mdm.prod.hot.ingest.monitor.core.windows.net` | 443 | Azure Local monitoring | |
| 11 | `eastus-shared.prod.warm.ingest.monitor.core.windows.net` | 443 | Azure Local monitoring | |
| 12 | `eastus.login.microsoft.com` | 443 | Azure Local authentication | |
| 13 | `eoprodrvsvc95jfo-hzbjevbze6e0dfgv.eastus.devicerendezvous.azure.net` | 443 | Azure onboarding discovery service | |
| 14 | `eus.his.arc.azure.com` | 443 | Azure Local Arc agent | |
| 15 | `gbl.his.arc.azure.com` | 443 | Azure Local Arc agent | |
| 16 | `gcs.prod.monitoring.core.windows.net` | 443 | Azure Local monitoring | |
| 17 | `global.prod.microsoftmetrics.com` | 443 | Azure Local monitoring | |
| 18 | `guestnotificationservice.azure.com` | 443 | Azure Local storage | |
| 19 | `login.microsoft.com` | 443 | Azure Local ROE connectivity test | |
| 20 | `login.microsoftonline.com` | 443 | Azure Local authentication | |
| 21 | `management.azure.com` | 443 | Azure Local management | |
| 22 | `packages.microsoft.com` | 443 | Azure Local extensions | |
| 23 | `pas.windows.net` | 443 | Azure Local Arc agent | |
| 24 | `prod6.prod.microsoftmetrics.com` | 443 | Azure Local monitoring | |

> [!NOTE]
> Endpoint names that include placeholders (for example, `<your-gateway-endpoint-id>`) are environment-specific and are generated during deployment.