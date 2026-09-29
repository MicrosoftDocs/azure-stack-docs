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

## Firewall allow list (2607, East US)

The following table lists the outbound endpoints and ports required for small form factor deployments with Arc Gateway in the East US region.

| No. | Endpoint FQDN | Port | Component | Notes |
|----:|---------------|:----:|-----------|-------|
| 1 | `<your-gateway-endpoint-id>.gw.arc.azure.com` | 443 | Azure Local Arc Gateway | Example: `1a2fc225-ac05-4dbf-9da2-0d9a3e9062de.gw.arc.azure.com` |
| 2 | `<your-device-endpoint>.eastus.deviceonboard.azure.net` | 443 | Azure onboarding provisioning service | Example: `onboardingservice-emh3bxgvbjg5hdgb.eastus.deviceonboard.azure.net` |
| 3 | eus.his.arc.azure.com | 443 | Azure Arc | |
| 4 | management.azure.com | 443 | Azure Arc | | 
| 5 | login.microsoftonline.com | 443 | Azure Entra Login Svc | |
| 6 | eoprodrvsvc95jfo-hzbjevbze6e0dfgv.eastus.devicerendezvous.azure.net | | |
| 7 | eastus.login.microsoft.com | Azure EastUS Login | | 
| 8 | gbl.his.arc.azure.com | Azure Arc | | 
| 9 | login.microsoft.com | Azure Entra | | 
| 10 | global.prod.micosoftmetrics.com | Azure Arc Metrics | | 

> [!NOTE]
>
> - Endpoint names that include placeholders (for example, `<your-gateway-endpoint-id>`) are environment-specific and are generated during deployment.
>
> - If you're using an enterprise proxy, include the following HTTP endpoint (Port 80): `http://www.msftconnecttest.com/connecttest.txt`

## Next steps

- [Prepare to deploy Azure Local on small form factor devices](small-form-factor-prepare-to-deploy.md).
