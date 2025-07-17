---
title: Troubleshoot common issues in AKS enabled by Azure Arc
description: Learn about common issues and workarounds in AKS enabled by Arc.
ms.topic: how-to
author: sethmanheim
ms.date: 06/27/2025
ms.author: sethm 
ms.lastreviewed: 04/01/2025
ms.reviewer: abha

---

# Troubleshoot common issues in AKS enabled by Azure Arc

This section describes how to find solutions for issues you encounter when using AKS enabled by Azure Arc.

## Open a support request

To open a support request, see the [Get support](help-support.md) article for information about how to use the Azure portal to get support or open a support request for AKS Arc.

## Known issues

The following sections describe known issues for AKS enabled by Azure Arc:

| AKS Arc CRUD operation | Issue | Fix status |
|------------------------|-------|------------|
| AKS cluster delete     | [Deleted AKS Arc cluster still visible on Azure portal](deleted-cluster-visible.md) | Active |
| AKS steady state       | [AKS Arc telemetry pod consumes too much memory and CPU](telemetry-pod-resources.md) | Fixed in 2507 release  |
| AKS cluster create     | [Can't create AKS cluster or scale node pool because of issues with AKS Arc images](gallery-image-not-usable.md) | Fixed in 2507 release |
| AKS steady state       | [Disk space exhaustion on control plane VMs due to accumulation of kube-apiserver audit logs](kube-apiserver-log-overflow.md) | Fixed in 2507 release |
| AKS cluster upgrade    | [AKS Arc cluster stuck in "Upgrading" state](cluster-upgrade-status.md) | Fixed in 2505 release |
| AKS cluster delete     | [Can't fully delete AKS Arc cluster with PodDisruptionBudget (PDB) resources](delete-cluster-pdb.md) | Fixed in 2503 release |
| Azure portal           | [Can't see VM SKUs on Azure portal](check-vm-sku.md) | Fixed in 2411 release |
| MetalLB Arc extension  | [Connectivity issues with MetalLB](load-balancer-issues.md) | Fixed in 2411 release |

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
