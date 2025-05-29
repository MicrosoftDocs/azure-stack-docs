---
title: Enable secret encryption on an AKS Edge Essentials cluster (preview)
description: Learn how to enable the KMS plugin for AKS Edge Essentials clusters to encrypt secrets.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 03/11/2025
ms.custom: template-how-to
ms.reviewer: leslielin
---

# Enable secret encryption on an AKS Edge Essentials cluster (preview)

Following Kubernetes security best practices, it's recommended that you encrypt the Kubernetes secret store on AKS Edge Essentials clusters. You can perform this encryption by activating the *Key Management Service (KMS) plugin for AKS Edge Essentials*, which enables [encryption at rest for secrets](https://kubernetes.io/docs/concepts/configuration/secret/) stored in the etcd key-value store. It enables this encryption by generating a Key Encryption Key (KEK) and automatically rotating it every 30 days. The KEK is protected with administrator credentials and is accessible only to administrators.

For more detailed information about using KMS, see the official [KMS provider documentation](https://kubernetes.io/docs/tasks/administer-cluster/kms-provider/).

This article demonstrates how to activate the KMS plugin for AKS Edge Essentials clusters.

> [!IMPORTANT]
> The KMS plugin for AKS Edge Essentials is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Prerequisites

The KMS plugin is supported for all AKS Edge Essentials clusters, version 1.10.868.0 and later.

> [!NOTE]
> The KMS plugin can only be used for single node clusters. The plugin can't be used with [experimental features, such as multi-node](aks-edge-system-requirements.md#experimental-or-prerelease-features).

## Enable the KMS plugin

In your [**aksedge-config.json** file](aks-edge-deployment-config-json.md), in the `Init` section, set `Init.KmsPlugin.Enable` to `true`:

```json
"Init": {
 "KmsPlugin": {
     "Enable": true
  }
}
```

The following output is displayed during deployment, showing that the KMS plugin is enabled:

```output
Preparing to install kms-plugin as encryption provider...
```

For deployment instructions, see [Single machine deployment](aks-edge-howto-single-node-deployment.md).

> [!NOTE]
> You can only enable or disable the KMS plugin when you create a new deployment. Once you set the flag, it can't be changed.

## Verify that the KMS plugin is enabled

To verify that the KMS plugin is enabled, run the following command and ensure that the health status of **kms-providers** is **OK**:

```powershell
kubectl get --raw='/readyz?verbose'
```

```output
[+]ping ok
[+]Log ok
[+]etcd ok
[+]kms-providers ok
[+]poststarthook/start-encryption-provider-config-automatic-reload ok
```

To create secrets in AKS Edge Essentials clusters, see [Managing Secrets using kubectl](https://kubernetes.io/docs/tasks/configmap-secret/managing-secret-using-kubectl/#use-raw-data) in the Kubernetes documentation.

If you encounter errors, see the [Troubleshooting](#troubleshooting) section.

## Troubleshooting

If there are errors with the KMS plugin, follow this procedure:

1. Check that the AKS version is **1.10.868.0** or later. Use the following command to check the current version of AKS Edge Essentials:

   ```powershell
   Get-Command -Module AKSEdge | Format-Table Name, Version
   ```

   If the version is older, upgrade to the latest version. For more information, see [Upgrade an AKS cluster](aks-edge-howto-update.md).

1. View the `readyz` API. If the problem persists, verify that the KMS plugin is enabled. See the [Verify that the KMS plugin is enabled](#verify-that-the-kms-plugin-is-enabled) section.

   If you receive "**[-]**" before the `kms-providers` field, collect diagnostic logs for debugging. For more information, see [Get kubelet logs from cluster nodes](aks-get-kubelet-logs.md).

1. Repair KMS. If there are still errors, the machine running the AKS Edge Essentials cluster might be paused or turned off for an extended period of time (over 30 days). To get KMS back into a healthy state, you can use the `Repair-Kms` command to restore any necessary tokens:

   ```powershell
   Repair-AksEdgeKms
   ```

1. If you still encounter errors, contact [Microsoft Customer Support](aks-edge-troubleshoot-overview.md) and [collect logs](aks-edge-resources-logs.md).

## Next steps

- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
