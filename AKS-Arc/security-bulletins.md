
# Security bulletins for AKS on Azure Local

> Applies to: AKS on Azure Local (AKS enabled by Azure Arc)

This page provides information on security vulnerabilities affecting AKS on Azure Local, including critical advisories, ongoing investigations, and confirmed false positives.

> [!NOTE]
> For security bulletins affecting AKS in Azure, see [Security bulletins for Azure Kubernetes Service (AKS)](https://learn.microsoft.com/en-us/azure/aks/security-bulletins/overview).

---

## AKSARC-2026-0001: Advisory & Mitigation Guide for CVE-2026-31431 (Copy Fail)

**Published Date**: May 8, 2026

### Description

A local privilege escalation (LPE) vulnerability was publicly disclosed on April 29, 2026 affecting the Linux kernel's `algif_aead` module.

- **CVE**: [CVE-2026-31431](https://nvd.nist.gov/vuln/detail/CVE-2026-31431)
- **CVSS Score**: 7.8 HIGH
- **Attack Vector**: Local — requires code execution on the node

### References

- [CVE-2026-31431 · NVD](https://nvd.nist.gov/vuln/detail/CVE-2026-31431)
- [Ubuntu advisory](https://ubuntu.com/blog/copy-fail-vulnerability-fixes-available)

### Affected Components

#### Node Images

**Affected Versions**

All AKS node images based on Azure Linux running on Azure Local releases 2602, 2603, and 2604 are affected.

| OS | Kernel | Exploitable? |
|----|--------|-------------|
| Azure Linux 3.0 (6.6 branch) | < 6.6.137.1-1 | ⚠️ **Yes** |
| Azure Linux 3.0 (6.12 branch) | < 6.12.85.1-1 | ⚠️ **Yes** |

Although `algif_aead` is **not loaded by default** on AKS nodes, the Linux kernel's module auto-loading mechanism (`request_module`) will **automatically load it on demand** when any process — **including unprivileged containers** — creates an AF_ALG socket with AEAD type. This means:

- **An attacker with code execution in any pod (even non-root) can escalate to root on the node**
- No special pod privileges, capabilities, or host access are required

**Resolutions**

Patched VHD images are available through AKS extension hotfixes. Remediation requires two steps.

**Step 1: Update the AKS extension**

| Azure Local Release | Required Extension Version |
|--------------------|---------------------------|
| 2604 | 6.0.133 |
| 2603 | 5.0.122 |
| 2602 | 5.0.122 |

Azure Local 2605 ships with the fix natively (extension 6.0.133). No action needed.

```azurecli
az k8s-extension update \
  --resource-group <resource-group> \
  --cluster-name <azure-local-cluster> \
  --cluster-type connectedClusters \
  --name <extension-name> \
  --version <target-version>
```

Wait for the extension to reach **Succeeded** provisioning state.

**Step 2: Refresh AKS cluster nodes**

> [!IMPORTANT]
> The extension update makes patched VHDs available but does **not** automatically apply them to running clusters. You must refresh nodes.

- **If a newer Kubernetes version is available**: upgrade the cluster to pull the patched VHDs.

```azurecli
az aksarc upgrade \
  --resource-group <resource-group> \
  --name <cluster> \
  --kubernetes-version <version>
```

- **If already on the latest Kubernetes version**: scale out then scale in each node pool. Set `--node-count` to your current count + 1, wait for the new node, then scale back to the original count.

> [!NOTE]
> Repeat the scale-out/scale-in cycle until all nodes in the pool are running patched VHDs. Verify with Step 3 after each cycle.

```azurecli
az aksarc nodepool scale --resource-group <resource-group> --cluster-name <cluster> --name <pool> --node-count <node-count>
```

- **New clusters** created after the hotfix use patched VHDs automatically.

**Step 3: Verify**

Confirm nodes are running patched kernels:

```bash
kubectl get nodes -o wide
```

Verify the kernel version is at or above 6.6.137.1-1 (6.6 branch) or 6.12.85.1-1 (6.12 branch).
