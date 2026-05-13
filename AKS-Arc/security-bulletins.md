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

2. Confirm the extension update succeeded:

   ```azurecli
   az k8s-extension show \
     --resource-group <resource-group> \
     --cluster-name <azure-local-cluster> \
     --cluster-type connectedClusters \
     --name <extension-name> \
     --query "{version: version, provisioningState: provisioningState}"
   ```

   Verify that `version` is **6.0.133** and `provisioningState` is **Succeeded**.

3. [Refresh your AKS cluster nodes](#refresh-aks-cluster-nodes) to apply the patched VHDs.

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

2. Confirm the extension update succeeded:

   ```azurecli
   az k8s-extension show \
     --resource-group <resource-group> \
     --cluster-name <azure-local-cluster> \
     --cluster-type connectedClusters \
     --name <extension-name> \
     --query "{version: version, provisioningState: provisioningState}"
   ```

   Verify that `version` is **5.0.122** and `provisioningState` is **Succeeded**.

3. [Refresh your AKS cluster nodes](#refresh-aks-cluster-nodes) to apply the patched VHDs.

##### Azure Local 2602

**Prerequisites**:

- Install and import the [AKS Arc Support Tool](/azure/aks/aksarc/support-module) on your Azure Local node.
- Run `az login` on the node before running the remediation command.

1. Run the remediation command:

   ```powershell
   Invoke-SupportAksArcRemediation_FixCVE_2026_31431
   ```

2. [Refresh your AKS cluster nodes](#refresh-aks-cluster-nodes) to apply the patched VHDs.

##### Azure Local versions prior to 2602

1. Upgrade your Azure Local deployment to 2602 or later. See [Azure Local update documentation](/azure/azure-local/update/about-updates-23h2) for upgrade guidance.
2. After upgrading, follow the remediation steps for your new Azure Local version above.

#### Refresh AKS cluster nodes

> [!IMPORTANT]
> The extension update makes patched VHDs available but does **not** automatically apply them to running clusters. You must refresh nodes using one of the methods below.

The following Kubernetes versions are available after the extension update: **1.31.12, 1.31.13, 1.32.8, 1.32.9, 1.33.4, 1.33.5**. For a complete version list, see [Supported Kubernetes versions](/azure/aks/aksarc/supported-kubernetes-versions#aks-arc-supported-kubernetes-minor-and-patch-versions-per-release).

- **If your cluster is on an older Kubernetes version** than those listed above: upgrade the cluster. The upgrade pulls the patched VHDs and replaces nodes.

  ```azurecli
  az aksarc upgrade \
    --resource-group <resource-group> \
    --name <cluster> \
    --kubernetes-version <version>
  ```

- **If your cluster is already on one of the versions above**: scale out then scale in each node pool. New nodes are provisioned from the patched VHDs; old nodes are drained and removed.

  ```azurecli
  az aksarc nodepool scale \
    --resource-group <resource-group> \
    --cluster-name <cluster> \
    --name <pool> \
    --node-count <node-count>
  ```

  > [!NOTE]
  > Set `--node-count` to your current count + 1, wait for the new node, then scale back to the original count. Repeat until all nodes are replaced.

- **New clusters** created after the extension update use patched VHDs automatically.

After refreshing, verify that all nodes have been replaced by checking their age:

```bash
kubectl get nodes -o wide
```

Nodes created after the extension update are running the patched VHDs. Confirm that no old nodes remain.

---

<!-- Additional platform tabs will be added here as fixes become available:
# [AKS on Windows Server](#tab/windows-server)
# [AKS Edge Essentials](#tab/aksee)
# [AKS on SFF Linux](#tab/sff-linux)
-->
