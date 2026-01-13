---
title: AKS Arc Cluster unhealthy after K8s Upgrade
description: Learn how to troubleshoot and mitigate an issue that causes AKS cluster to become unhealthy after K8s upgrade
ms.topic: troubleshooting
author: rayoef
ms.author: rayoflores
ms.date: 1/13/2026
ms.lastreviewed: 1/13/2026
---

# AKS Arc cluster becomes unhealthy after upgrading to Kubernetes v1.31 with Azure Policy or Gatekeeper enabled

## Symptoms

After upgrading an AKS Arc cluster to **Kubernetes v1.31 or later**, the cluster may enter a **degraded or unhealthy state**.

This issue is observed when:

- The cluster is configured with a **single control plane**, and
- **Azure Policy and/or Gatekeeper** is enabled.

Cluster operations such as reconciliation, upgrades, or certificate rotation may fail or behave unexpectedly.

---

## Cause

In **Kubernetes v1.31 and later**, certain update and reconciliation paths interact incorrectly with **Azure Policy and Gatekeeper** when running on a **single control plane configuration**.

This issue can be triggered by:

- Kubernetes version upgrades (for example, v1.30 → v1.31), or
- Automated update mechanisms such as the **45-day Workload Identity Federation (WLIF) certificate rotation**

When Azure Policy or Gatekeeper is enabled, these updates can cause the control plane to enter a degraded state.

---

## Affected configurations

- AKS Arc clusters
- Single control plane deployments
- Kubernetes version **v1.31 and later**
- Azure Policy and/or Gatekeeper enabled

---

## Workaround

Until a permanent fix is available, use one of the following mitigations.

### Option 1: Temporarily disable Azure Policy (recommended)

Disable **Azure Policy** on the affected cluster before performing:

- Kubernetes version upgrades, or
- Any operation that may trigger control plane updates (for example, certificate rotation)

Azure Policy can be re-enabled once the fix is available.

---

### Option 2: Update Gatekeeper policies

If **Gatekeeper** is enabled, update the Gatekeeper constraint templates and policies to ensure compatibility with Kubernetes v1.31 behavior.

> [!NOTE]
> This workaround may be customer-specific and may not apply in all environments.

---

## Resolution

This issue is currently under investigation, and a **permanent fix** is in progress.

Until the fix is fully validated and released, customers are advised to follow the recommended workarounds described in this article. This page will be updated as additional guidance becomes available.

---

## Next steps

- If you are planning to upgrade to **Kubernetes v1.31 or later**, review your cluster configuration and apply the recommended mitigations before proceeding.
- If your cluster is already affected, apply one of the workarounds and contact Microsoft Support if assistance is required.
