---
title: Troubleshoot common issues in AKS enabled by Azure Arc
description: Learn about common issues and workarounds in AKS enabled by Arc.
ms.topic: how-to
author: sethmanheim
ms.date: 02/28/2025
ms.author: sethm 
ms.lastreviewed: 02/27/2024
ms.reviewer: guanghu

---

# Troubleshoot common issues in AKS enabled by Azure Arc

This section describes how to find solutions for issues you encounter when using AKS enabled by Azure Arc.

## Open a support request

To open a support request, see the [Get support](/azure/aks/hybrid/help-support) article for information about how to use the Azure portal to get support or open a support request for AKS Arc.

## Known issues

The following sections describe known issues and workarounds for AKS enabled by Azure Arc:

| AKS Arc CRUD Operation | Issue | Fix Status |
|------------------------|-------|------------|
| Kubernetes operation   | [Issues after deleting storage volume](delete-storage-volume.md) | Pending |
| Create validation      | [Control plane configuration validation errors](control-plane-validation-errors.md) | N/A - this is to help users understand valid inputs. |
| Create validation      | [K8sVersionValidation error](cluster-k8s-version.md)   | N/A - this is to help users understand valid inputs. |
| Create validation      | [KubeAPIServer unreachable error](kube-api-server-unreachable.md)  | N/A - this is to help users understand networking misconfigurations. |
| Release validation     | [Azure Advisor upgrade recommendation message](azure-advisor-upgrade.md)   | N/A - this is to alert users to upgrade to latest available version. |
| AKS cluster delete     | [Deleted AKS Arc cluster still visible on Azure portal](deleted-cluster-visible.md) | Fixed in 2503 release |
| AKS cluster delete     | [Can't fully delete AKS Arc cluster with PodDisruptionBudget (PDB) resources](delete-cluster-pdb.md) | Fixed in 2503 release |
| Azure portal           | [Can't see VM SKUs on Azure portal](check-vm-sku.md) | Fixed in 2411 release |
| MetalLB Arc extension  | [Connectivity issues with MetalLB](load-balancer-issues.md) | Fixed in 2411 release | 


## Tools to diagnose Kubernetes cluster failures
- [Use diagnostic checker](aks-arc-diagnostic-checker.md)

## Next steps

[What is AKS enabled by Azure Arc?](aks-overview.md)
