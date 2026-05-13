---
title: Security bulletins for AKS enabled by Azure Arc
description: Security vulnerability advisories and mitigation guidance for AKS enabled by Azure Arc.
author: leslielin
ms.author: leslielin
ms.topic: concept-article
ms.date: 05/13/2026
---

# Security bulletins for AKS enabled by Azure Arc

This page provides up-to-date information on security vulnerabilities affecting AKS enabled by Azure Arc and its components. This information includes details on:

- **Critical Security Advisories** — High-impact security vulnerabilities, including zero-day vulnerabilities and other critical CVEs requiring immediate attention, along with mitigation guidance.
- **Ongoing Security Investigations** — Security issues under review, including CVEs where a patch isn't yet available or further assessment is needed.
- **False Positives & Non-Exploitable CVEs** — Cases where a reported CVE doesn't impact AKS enabled by Azure Arc due to specific configurations, mitigations, or lack of exploitability.

> [!NOTE]
> For security bulletins affecting AKS in Azure, see [Security bulletins for Azure Kubernetes Service (AKS)](/azure/aks/security-bulletins/overview).

---

## AKSARC-2026-0001: Advisory & Mitigation Guide for CVE-2026-31431 (Copy Fail)

**Last updated**: May 13, 2026

### Description

This bulletin provides an update on a local privilege escalation (LPE) vulnerability that was publicly disclosed on April 29, 2026 affecting the Linux kernel's `algif_aead` module. This vulnerability has been assigned **CVE-2026-31431** and is referred to as **"Copy Fail"**.

- **CVSS Score**: 7.8 HIGH (`CVSS:3.1/AV:L/AC:L/PR:L/UI:N/S:U/C:H/I:H/A:H`)
- **Attack Vector**: Local — requires code execution on the node (e.g., from a container)
- **Affected Component**: `algif_aead` kernel module (hardware-accelerated cryptographic functions)
- **Canonical Advisory**: [https://ubuntu.com/blog/copy-fail-vulnerability-fixes-available](https://ubuntu.com/blog/copy-fail-vulnerability-fixes-available)

### References

- [CVE-2026-31431](https://nvd.nist.gov/vuln/detail/CVE-2026-31431)
- [AKS Advisory](https://github.com/Azure/AKS/issues/5753)

### Affected Components

# [AKS on Azure Local](#tab/azure-local)

**Affected Versions**

All AKS node images on Azure Local releases 2604 and earlier are affected. Although `algif_aead` is **not loaded by default** on AKS nodes, the Linux kernel's module auto-loading mechanism (`request_module`) will **automatically load it on demand** when any process — **including unprivileged containers** — creates an AF_ALG socket with AEAD type. An attacker with code execution in any pod (even non-root) can escalate to root on the node without special privileges.

**Resolutions**

Patched VHD images are available through AKS extension hotfixes. Follow the steps below that match your Azure Local version.

##### Azure Local 2605

No action required. The fix is included natively (extension 6.0.133).

##### Azure Local 2604

1. Update the AKS extension to version **6.0.133**:

   ```azurecli
   az k8s-extension update \
     --resource-group <resource-group> \
     --cluster-name <azure-local-cluster> \
     --cluster-type connectedClusters \
     --name <extension-name> \
     --version 6.0.133
   ```

2. Wait for the extension to reach **Succeeded** provisioning state.
3. [Refresh your AKS cluster nodes](#refresh-aks-cluster-nodes) to apply the patched VHDs.
4. Verify: run `kubectl get nodes -o wide` and confirm all nodes are running the patched image.

##### Azure Local 2603

1. Update the AKS extension to version **5.0.122**:

   ```azurecli
   az k8s-extension update \
     --resource-group <resource-group> \
     --cluster-name <azure-local-cluster> \
     --cluster-type connectedClusters \
     --name <extension-name> \
     --version 5.0.122
   ```

2. Wait for the extension to reach **Succeeded** provisioning state.
3. [Refresh your AKS cluster nodes](#refresh-aks-cluster-nodes) to apply the patched VHDs.
4. Verify: run `kubectl get nodes -o wide` and confirm all nodes are running the patched image.

##### Azure Local 2602

**Prerequisite**: Install and import the [AKS Arc Support Tool](/azure/aks/aksarc/support-module) on your Azure Local node.

1. Run the remediation command:

   ```powershell
   Invoke-SupportAksArcRemediation_FixCVE_2026_31431
   ```

2. Verify: run `kubectl get nodes -o wide` and confirm all nodes are running the patched image.

> [!NOTE]
> This command is available only for Azure Local 2602. Running it on other versions logs a warning and takes no action.

<!-- TODO: Confirm with Rohit — does the customer need to install a module first (Install-Module)? Where should they run this command (Azure Local host PowerShell)? Does this command handle both extension update AND node refresh, or only extension update? -->

##### Azure Local versions prior to 2602

1. Upgrade your Azure Local deployment to 2602 or later. See [Azure Local update documentation](/azure/azure-local/update/about-updates-23h2) for upgrade guidance.
2. After upgrading, follow the remediation steps for your new Azure Local version above.

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

  ```azurecli
  az aksarc nodepool scale \
    --resource-group <resource-group> \
    --cluster-name <cluster> \
    --name <pool> \
    --node-count <node-count>
  ```

  > [!NOTE]
  > Repeat the scale-out/scale-in cycle until all nodes in the pool are running patched VHDs.

- **New clusters** created after the hotfix use patched VHDs automatically.

---

<!-- Additional platform tabs will be added here as fixes become available:
# [AKS on Windows Server](#tab/windows-server)
# [AKS Edge Essentials](#tab/aksee)
# [AKS on SFF Linux](#tab/sff-linux)
-->
