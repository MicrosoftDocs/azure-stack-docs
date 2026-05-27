---
title: Public preview limitations for AKS on bare metal
description: Known limitations and scope for the Azure Kubernetes Service on bare metal public preview.
ms.topic: conceptual
ms.date: 06/01/2026
---

# Public preview limitations

> [!IMPORTANT]
> Azure Kubernetes Service on bare metal is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability. Azure Kubernetes Service on bare metal previews are partially covered by customer support on a best-effort basis.

This article lists the known limitations and scope boundaries for the AKS on bare metal public preview.

## Supported scope

| Feature | Status |
|---------|--------|
| Single-node clusters | ✅ Supported |
| Cluster creation via Azure portal | ✅ Supported |
| Cluster creation via Bicep | ✅ Supported |
| Cluster creation via ARM template | ✅ Supported |
| Kubernetes 1.34.2 | ✅ Supported |
| Kubernetes 1.34.3 | ✅ Supported |
| Small form factor Azure Local host | ✅ Supported |
| Azure Arc connectivity | ✅ Supported |
| Azure RBAC for Kubernetes | ✅ Supported |
| Cilium CNI | ✅ Supported |
| Cluster upgrades (patch versions) | ✅ Supported |
| `az connectedk8s proxy` for cluster access | ✅ Supported |

## Billing

AKS on bare metal public preview uses **zero-rated billing meters**. There are no charges for the AKS cluster resources during the preview period. Standard Azure charges for the underlying Arc-enabled machine and any Azure services (Monitor, Policy, etc.) still apply.

## Support

Public preview features are covered by customer support on a **best-effort basis**. Preview features:

- Are not recommended for production workloads
- May have limited or no SLA
- May introduce breaking changes before GA
- May be deprecated or removed

## Known issues

For current known issues and workarounds, see [Known issues (public preview)](known-issues.md).

## Next steps

- [What is AKS on bare metal?](what-is-aks-on-bare-metal.md)
- [System requirements and prerequisites](system-requirements.md)
