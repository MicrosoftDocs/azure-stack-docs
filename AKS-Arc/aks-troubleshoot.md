---
title: Troubleshoot issues in AKS enabled by Azure Arc
description: Learn how to troubleshoot various Kubernetes issues in AKS enabled by Arc.
ms.topic: how-to
author: sethmanheim
ms.date: 07/29/2025
ms.author: sethm
ms.lastreviewed: 07/29/2025
ms.reviewer: rcheeran

---

# Troubleshoot issues in AKS enabled by Azure Arc

This section describes how to find solutions for Kubernetes issues you might encounter when using AKS enabled by Azure Arc.

## Open a support request

To open a support request, see the [Get support](help-support.md) article for information about how to use the Azure portal to get support or open a support request for AKS Arc.

## Guides to diagnose and troubleshoot Kubernetes CRUD failures

| AKS Arc operation | Issue |
|------------------------|-------|
| General network validation errors | [Troubleshoot network validation errors](network-validation-errors.md) |
| Create validation      | [Control plane configuration validation errors](control-plane-validation-errors.md) |
| Create validation      | [K8sVersionValidation error](cluster-k8s-version.md) |
| Create validation      | [KubeAPIServer unreachable error](kube-api-server-unreachable.md) |
| Network configuration issues | [Use diagnostic checker](aks-arc-diagnostic-checker.md) |
| Kubernetes steady state   | [Resolve issues due to out-of-band deletion of storage volumes](delete-storage-volume.md) |
| Kubernetes steady state   | [Repeated Entra authentication prompts when running kubectl with Kubernetes RBAC](entra-prompts.md) |
| Release validation     | [Azure Advisor upgrade recommendation message](azure-advisor-upgrade.md) |
| Network validation | [Network validation error due to .local domain](network-validation-error-local.md) |
| Network validation | [Troubleshoot BGP with FRR in AKS Arc environments](connectivity-troubleshoot.md) |

## Next steps

[What is AKS enabled by Azure Arc?](aks-overview.md)
