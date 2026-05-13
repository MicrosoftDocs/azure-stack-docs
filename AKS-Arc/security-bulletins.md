---
title: Security bulletins for AKS enabled by Azure Arc
description: Security vulnerability advisories and mitigation guidance for AKS enabled by Azure Arc.
author: leslielin
ms.author: leslielin
ms.topic: concept-article
ms.date: 05/13/2026
---

# Security bulletins for AKS enabled by Azure Arc

This page provides information on security vulnerabilities affecting AKS enabled by Azure Arc, including critical advisories, ongoing investigations, and confirmed false positives.

> [!NOTE]
> For security bulletins affecting AKS in Azure, see [Security bulletins for Azure Kubernetes Service (AKS)](/azure/aks/security-bulletins/overview).

---

## AKSARC-2026-0001: Advisory & Mitigation Guide for CVE-2026-31431 (Copy Fail)

**Last updated**: May 13, 2026

### Description

A local privilege escalation (LPE) vulnerability was publicly disclosed on April 29, 2026 affecting the Linux kernel's `algif_aead` module.

- **CVE**: [CVE-2026-31431](https://nvd.nist.gov/vuln/detail/CVE-2026-31431)
- **CVSS Score**: 7.8 HIGH
- **Attack Vector**: Local — requires code execution on the node

Although `algif_aead` is **not loaded by default** on AKS nodes, the Linux kernel's module auto-loading mechanism (`request_module`) automatically loads it on demand when any process — including unprivileged containers — creates an AF_ALG socket with AEAD type. This means an attacker with code execution in any pod (even non-root) can escalate to root on the node without special privileges.

### References

- [CVE-2026-31431 · NVD](https://nvd.nist.gov/vuln/detail/CVE-2026-31431)
- [Ubuntu advisory](https://ubuntu.com/blog/copy-fail-vulnerability-fixes-available)
- [CVE-2026-31431 — AKS Advisory & Mitigation Guide](https://github.com/Azure/AKS/issues/5753)

### Affected Components

# [AKS on Azure Local](#tab/azure-local)

#### Affected Versions

All AKS node images based on Azure Linux running on Azure Local releases 2604 and earlier are affected.

| OS | Kernel | Exploitable? |
|----|--------|-------------|
| Azure Linux 3.0 (6.6 branch) | < 6.6.137.1-1 | ⚠️ **Yes** |
| Azure Linux 3.0 (6.12 branch) | < 6.12.85.1-1 | ⚠️ **Yes** |

#### Resolutions

Patched VHD images are available through AKS extension hotfixes. Choose the remediation steps that match your Azure Local version.

##### Azure Local 2605

✅ Fix is included natively (extension 6.0.133). **No action required.**

##### Azure Local 2604

Update the AKS extension to version **6.0.133**, then refresh your AKS cluster nodes.

```azurecli
az k8s-extension update \
  --resource-group <resource-group> \
  --cluster-name <azure-local-cluster> \
  --cluster-type connectedClusters \
  --name <extension-name> \
  --version 6.0.133
```

Wait for the extension to reach **Succeeded** provisioning state, then [refresh your cluster nodes](#refresh-aks-cluster-nodes).

##### Azure Local 2603

Update the AKS extension to version **5.0.122**, then refresh your AKS cluster nodes.

```azurecli
az k8s-extension update \
  --resource-group <resource-group> \
  --cluster-name <azure-local-cluster> \
  --cluster-type connectedClusters \
  --name <extension-name> \
  --version 5.0.122
```

Wait for the extension to reach **Succeeded** provisioning state, then [refresh your cluster nodes](#refresh-aks-cluster-nodes).

##### Azure Local 2602

A support module provides a single-command remediation:

```powershell
Invoke-SupportAksArcRemediation_FixCVE_2026_31431
```

> [!NOTE]
> This command is available only for Azure Local 2602. Running it on other versions logs a warning and takes no action.

<!-- TODO: Confirm with Rohit — does the customer need to install a module first (Install-Module)? Where should they run this command (Azure Local host PowerShell)? Does this command handle both extension update AND node refresh, or only extension update? -->

##### Azure Local versions prior to 2602

> [!IMPORTANT]
> Customers on Azure Local releases prior to 2602 must first upgrade their Azure Local deployment to 2602 or later before applying this fix. See [Azure Local update documentation](/azure/azure-local/update/about-updates-23h2) for upgrade guidance.

After upgrading to 2602, follow the [Azure Local 2602](#azure-local-2602) remediation steps above.

#### Refresh AKS cluster nodes

> [!IMPORTANT]
> The extension update makes patched VHDs available but does **not** automatically apply them to running clusters. You must refresh nodes using one of the methods below.

- **If a newer Kubernetes version is available**: upgrade the cluster to pull the patched VHDs.

```azurecli
az aksarc upgrade \
  --resource-group <resource-group> \
  --name <cluster> \
  --kubernetes-version <version>
```

- **If already on the latest Kubernetes version**: scale out then scale in each node pool. Set `--node-count` to your current count + 1, wait for the new node, then scale back to the original count.

> [!NOTE]
> Repeat the scale-out/scale-in cycle until all nodes in the pool are running patched VHDs. Verify with the step below after each cycle.

```azurecli
az aksarc nodepool scale --resource-group <resource-group> --cluster-name <cluster> --name <pool> --node-count <node-count>
```

- **New clusters** created after the hotfix use patched VHDs automatically.

#### Verify

Confirm nodes are running patched kernels:

```bash
kubectl get nodes -o wide
```

Verify the kernel version is at or above 6.6.137.1-1 (6.6 branch) or 6.12.85.1-1 (6.12 branch).

---

<!-- Additional platform tabs will be added here as fixes become available:
# [AKS on Windows Server](#tab/windows-server)
# [AKS Edge Essentials](#tab/aksee)
# [AKS on SFF Linux](#tab/sff-linux)
-->
