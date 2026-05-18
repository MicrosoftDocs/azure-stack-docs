---
title: Security bulletins for AKS enabled by Azure Arc
description: Security vulnerability advisories and mitigation guidance for AKS enabled by Azure Arc.
author: leslielin
ms.author: leslielin
ms.topic: concept-article
ms.date: 05/18/2026
---

# Security bulletins for AKS enabled by Azure Arc

This article provides up-to-date information on security vulnerabilities that affect AKS enabled by Azure Arc and its components. This information includes details on:

- **Critical Security Advisories** — High-impact security vulnerabilities, including zero-day vulnerabilities and other critical CVEs that require immediate attention, along with mitigation guidance.
- **Ongoing Security Investigations** — Security issues under review, including CVEs where a patch isn't yet available or further assessment is needed.
- **False Positives & Non-Exploitable CVEs** — Cases where a reported CVE doesn't impact AKS enabled by Azure Arc due to specific configurations, mitigations, or lack of exploitability.

> [!NOTE]
> For security bulletins that affect AKS in Azure, see [Security bulletins for Azure Kubernetes Service (AKS)](/azure/aks/security-bulletins/overview).

---

## AKSARC-2026-0001: Advisory & Mitigation Guide for CVE-2026-31431 (Copy Fail)

**Last updated**: May 18, 2026

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

- All AKS node images on Azure Local releases 2604 and earlier are affected. For Azure Local 2605 and beyond, the fix is included natively. No action is required.
- Although `algif_aead` is **not loaded by default** on AKS nodes, the Linux kernel's module auto-loading mechanism (`request_module`) will **automatically load it on demand** when any process — **including unprivileged containers** — creates an AF_ALG socket with AEAD type. This means:
- **An attacker with code execution in any pod (even non-root) can escalate to root on the node**
- No special pod privileges, capabilities, or host access are required

**Resolutions**

#### Step 1: Upgrade Azure Local (if needed)

If your Azure Local deployment is on version 2601 or earlier, upgrade to 2602 or later. See [Azure Local update documentation](/azure/azure-local/update/about-updates-23h2) for upgrade guidance. After upgrading, follow Step 2.

#### Step 2: Choose a remediation path

##### Option A: Upgrade AKS clusters (recommended)

1. Install the [AKS Arc Support Tool](/azure/aks/aksarc/support-module) and run `az login` on your Azure Local node.

2. Run the remediation command:

   ```powershell
   Invoke-SupportAksArcRemediation_FixCVE_2026_31431
   ```

3. Upgrade your AKS clusters to refresh nodes with patched VHDs. Use the table below to determine your upgrade path.

   | Current K8s version | Supported versions for Azure Local 2602 |
   |---|---|
   | 1.30 or earlier | 1.31.12, 1.31.13 |
   | 1.31.12 | 1.31.13, 1.32.8, 1.32.9 |
   | 1.31.13 | 1.32.8, 1.32.9 |
   | 1.32.8 | 1.32.9, 1.33.4, 1.33.5 |
   | 1.32.9 | 1.33.4, 1.33.5 |
   | 1.33.4 | 1.33.5 |
   | 1.33.5 (latest) | No upgrade available — use Option B |

   For the full version list, see [Supported Kubernetes versions](/azure/aks/aksarc/supported-kubernetes-versions#aks-arc-supported-kubernetes-minor-and-patch-versions-per-release).

   ```azurecli
   az aksarc upgrade \
     --resource-group <resource-group> \
     --name <cluster> \
     --kubernetes-version <version>
   ```

##### Option B: Self-service mitigation

If you can't upgrade immediately, or your clusters are already on Kubernetes 1.33.5 (the latest available version), we strongly recommend applying the self-service mitigation described in [AKS Advisory](https://github.com/Azure/AKS/issues/5753).

---

<!-- Additional platform tabs will be added here as fixes become available:
# [AKS on Windows Server](#tab/windows-server)
# [AKS Edge Essentials](#tab/aksee)
# [AKS on SFF Linux](#tab/sff-linux)
-->
