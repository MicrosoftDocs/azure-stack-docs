---
title: Troubleshoot known issues in AKS enabled by Azure Arc
description: Learn about known issues and workarounds in AKS enabled by Arc.
ms.topic: how-to
author: sethmanheim
ms.date: 09/30/2025
ms.author: sethm
ms.lastreviewed: 07/29/2025
ms.reviewer: rcheeran

---

# Known issues in AKS enabled by Azure Arc

This article identifies known issues and their workarounds in AKS Arc. These release notes are continuously updated, and as issues that require a workaround are discovered, they're added here.

If you encounter an issue that isn't listed here, please [open a support request](help-support.md).

## Known issues

The following section describes known issues for AKS enabled by Azure Arc:

| AKS Arc CRUD operation | Issue | Fix status |
|------------------------|-------|------------|
| AKS steady state       | [Storage provisioning issue impacting cluster and node pool creation](storage-provision-issue.md)|Active|
| AKS cluster delete     | [Deleted AKS Arc cluster still visible on Azure portal](deleted-cluster-visible.md) | Active |
| AKS steady state       | [AKS Arc telemetry pod consumes too much memory and CPU](telemetry-pod-resources.md) | Fixed in 2507 release  |
| AKS cluster create     | [Can't create AKS cluster or scale node pool because of issues with AKS Arc images](gallery-image-not-usable.md) | Fixed in 2507 release |
| AKS steady state       | [Disk space exhaustion on control plane VMs due to accumulation of kube-apiserver audit logs](kube-apiserver-log-overflow.md) | Fixed in 2507 release |
| AKS cluster upgrade    | [AKS Arc cluster stuck in "Upgrading" state](cluster-upgrade-status.md) | Fixed in 2505 release |
| AKS cluster delete     | [Can't fully delete AKS Arc cluster with PodDisruptionBudget (PDB) resources](delete-cluster-pdb.md) | Fixed in 2503 release |

## Next steps

- [What is AKS enabled by Azure Arc?](aks-overview.md)
