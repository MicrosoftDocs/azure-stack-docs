---
title: Add secret encryption to an AKS Edge Essentials cluster (preview)
description: Learn how to enable the KMS plugin for AKS Edge Essentials clusters to encrypt secrets.
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 02/06/2025
ms.custom: template-how-to
ms.reviewer: leslielin
---

# Add secret encryption to an AKS Edge Essentials cluster (preview)

On AKS Edge Essentials clusters, following Kubernetes security best practices, it's recommended that you encrypt the Kubernetes secret store. You can perform this encryption by activating the Key Management Service (KMS) plugin for AKS Edge Essentials, which enables [encryption at rest for secrets](https://kubernetes.io/docs/concepts/configuration/secret/) stored in the etcd key-value store. It enables this encryption by generating a Key Encryption Key (KEK) and automatically rotating it every 30 days. For more detailed information about using KMS, see the official [KMS provider documentation](https://kubernetes.io/docs/tasks/administer-cluster/kms-provider/). This article demonstrates how to activate the KMS plugin.

> [!IMPORTANT]
> The KMS plugin for AKS Edge Essentials is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Requirements

The KMS plugin is supported for all AKS Edge Essentials clusters, version 1.10.xxx.0 and later.

## Limitations

The following limitations apply to the KMS plugin for AKS Edge Essentials:

- Disabling the KMS plugin once enabled is not supported.
- The plugin can be used for single node clusters. The KMS plugin can't be used with the [experimental multi-node features](aks-edge-howto-scale-out.md).

## Enable the KMS plugin

> [!NOTE]
> You can only enable or disable the KMS Plugin when you create a new deployment. Once you set the flag, it can't be changed unless you remove the deployment or node.

### Install the KMS plugin

To install the KMS plugin, follow these steps:

- Install the single machine deployment using the [Single Machine Kubernetes guide](aks-edge-concept-clusters-nodes.md) guide.
- During the first step in the single machine deployment process, create an **aksedge-config.json** file. In the `Init` section, set `Init.KmsPlugin.Enable` to **true**. For example:

  ```json
  "Init": {
   "KmsPlugin": {
       "Enable": true
    }
  
  ```

A new deployment was created when you see the following message:

```output
[01/22/2025 09:46:40] AksEdge - new deployment successfully created.
Azure Arc parameters not set or invalid
```

### Validate the KMS installation

The following sections describe how to validate the KMS plugin installation for AKS EE cluster.

#### Create and retrieve a secret which is encrypted using KMS

To create a new secret encrypted by KMS, run the following command:

```powershell
# Create a new secret encrypted by KMS
kubectl create secret generic db-user-pass --from-literal=username=admin --from-literal=password='your-secret'
```

#### Retrieve the secret

To retrieve the secret and test decryption, run the following command:

```powershell
# Retrieve secret to test decryption
kubectl get secret db-user-pass -o jsonpath='{.data}'
```

If successful, the terminal shows the following output:

```output
PS C:\Windows\system32> kubectl create secret generic db-user-pass1 --from-literal-username=admin --from-literal-password='your-secret" secret/db-user-pass1 created
PS C:\Windows\system32> kubectl get secret db-user-pass1 -o jsonpath='{.data}' ["password": "<password>", "username": "<username>"}
```

## Troubleshooting

If there are errors with the KMS plugin, follow this procedure:

1. Check that the AKS version is **1.10.xxx.0** or later. Use the following command to check for upgrades to Kubernetes clusters. For more information, see [Upgrade an AKS cluster](aks-edge-howto-update.md).

   ```azurecli
   az aks get-upgrades --resource-group myResourceGroup --name myAKSCluster --output table
   ```

1. View the **readyz** API. If the problem persists, validate that the installation succeeded. To check the health of the KMS plugin, run the following command and ensure that the health status of **kms-providers** is **OK**:

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

   If you receive **[-]** before the output, collect diagnostic logs for debugging. For more information, see [Get kubelet logs from cluster nodes](aks-get-kubelet-logs.md).

1. Repair KMS. If there are still errors, then the machine running the AKS Edge Essentials cluster might be paused or turned off for an extended period of time (over 30 days). To get KMS back into a healthy state, you can use the `Repair-Kms` command to restore any necessary tokens:

   ```powershell
   Repair-AksEdgeKms
   ```

1. If you still encounter errors, contact [Microsoft Customer Support](aks-edge-troubleshoot-overview.md) and [collect logs](aks-get-kubelet-logs.md).

## Next steps

- [Overview](aks-edge-overview.md)
- [Uninstall AKS cluster](aks-edge-howto-uninstall.md)
