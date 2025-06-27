---
title: Encrypt etcd secrets for Kubernetes clusters in AKS on Azure Local
description: Learn how to encrypt etcd secrets in AKS on Azure Local.
author: sethmanheim
ms.topic: how-to
ms.date: 04/11/2025
ms.author: sethm 
ms.lastreviewed: 04/10/2025
ms.reviewer: khareanushka
# Intent: As an IT Pro, I want to learn about encrypted etcd secrets and how they are used in my AKS deployment. 
# Keyword: etcd secrets AKS Windows Server

---

# How to: Encrypt etcd secrets for Kubernetes clusters

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

A [*secret*](https://kubernetes.io/docs/concepts/configuration/secret/) in Kubernetes is an object that contains a small amount of sensitive data, such as passwords and SSH keys. In the Kubernetes API server, secrets are stored in *etcd*, which is a highly available key value store used as the Kubernetes backing store for all cluster data.

Azure Kubernetes Service (AKS) on Azure Local comes with encryption of etcd secrets using a **Key Management Service (KMS) plugin**. All Kubernetes clusters in Azure Local have a built-in KMS plugin enabled by default. This plugin generates the [Key Encryption Key (KEK)](https://kubernetes.io/docs/tasks/administer-cluster/kms-provider/#kms-encryption-and-per-object-encryption-keys)
and automatically rotates it every 30 days.

This article describes how to verify that the data is encrypted. For more information, see the [official Kubernetes documentation for the KMS plugin](https://kubernetes.io/docs/tasks/administer-cluster/kms-provider/).

> [!NOTE]
> The KMS plugin currently uses the KMS v1 protocol.

## Before you begin

Before you begin, ensure that you have the following prerequisites:

- To interact with Kubernetes clusters, you must install [**kubectl**](https://kubernetes.io/docs/tasks/tools/) and [**kubelogin**](https://azure.github.io/kubelogin/install.html).
- To view or manage secrets, ensure you have the necessary entitlements to access them. For more information, see [Access and identity](concepts-security-access-identity.md#built-in-roles).

## Access your Microsoft Entra-enabled cluster

Get the user credentials to access your cluster using the [az aksarc get-credentials](/cli/azure/aksarc#az-aksarc-get-credentials) command. You need the **Microsoft.HybridContainerService/provisionedClusterInstances/listUserKubeconfig/action** resource, which is included in the **Azure Kubernetes Service Arc Cluster User** role permission:

```azurecli
az aksarc get-credentials --resource-group $resource_group --name $aks_cluster_name
```

## Verify that the KMS plugin is enabled

To verify that the KMS plugin is enabled, run the following command and ensure that the health status of **kms-providers** is **OK**:

```azurecli
kubectl get --raw='/readyz?verbose'
```

```output
[+]ping ok
[+]Log ok
[+]etcd ok
[+]kms-providers ok
[+]poststarthook/start-encryption-provider-config-automatic-reload ok
```

## Verify that the data is encrypted

To verify that secrets and data has been encrypted using a KMS plugin, [see the Kubernetes documentation](https://kubernetes.io/docs/tasks/administer-cluster/kms-provider/#verifying-that-the-data-is-encrypted). You can use the following commands to verify that the data is encrypted:

```azurecli
kubectl exec --stdin --tty <etcd pod name> -n kube-system --etcdctl --cacert /etc/kubernetes/pki/etcd/ca.crt --key /etc/kubernetes/pki/etcd/server.key --cert /etc/kubernetes/pki/etcd/server.crt get /registry/secrets/default/db-user-pass -w fields
```

- `kubectl exec`: This is the kubectl command used to execute a command inside a running pod. It enables you to run commands within the container of a pod.
- `--stdin`: This flag enables you to send input (stdin) to the command you are running inside the pod.
- `--tty`: This flag allocates a TTY (terminal) for the command, making it behave as though you're interacting with a terminal session.
- `<etcd pod name>`: to find the etcd pod name, run the following command:

  ```azurecli
   kubectl get pods -n kube-system | findstr etcd-moc
   ```

- `-n kube-system`: Specifies the namespace where the pod is located. **kube-system** is the default namespace used by Kubernetes for system components, such as etcd and other control plane services.
- `--etcdctl`: Reads the secret from etcd. Additional fields are used for authentication before you get access to etcd.

The following fields are returned in the command output:

```output
"ClusterID" : <cluster id> 
"MemberID" : <member id> 
"Revision" : <revision number> 
"RaftTerm" : 2 
"Key" : <path to the key>
"CreateRevision" : <revision number at the time the key was created> 
"ModRevision" :  <revision number at the time the key was modified> 
"Version" : <version of the key-value pair in etcd> 
"Value" : "k8s:enc:kms:v1:kms-plugin: <encrypted secret value>"  
"Lease" : <lease associated with the secret> 
"More" : <indicates if there are more results> 
"Count" : <number of key-value pairs returned> 
```

After you run the command, examine the `Value` field in the output in the terminal window. This output shows the value stored in the etcd secret store for this key, which is the encrypted value of the secret. The value is encrypted using a KMS plugin. The `k8s:enc:kms:v1:` prefix indicates that Kubernetes is using the KMS v1 plugin to store the secret in an encrypted format.

> [!NOTE]
> If you use the `kubectl describe secrets` command to retrieve secrets, it returns them in base64-encoded format, but unencrypted. The `kubectl describe` command retrieves the details of a Kubernetes resource via the API server, which manages encryption and decryption automatically. For sensitive data such as secrets, even if they are mounted on a pod, the API server ensures that they are decrypted when accessed. As a result, running the `kubectl describe` command does not display secrets in their encrypted form, but rather in their decrypted form if they are being used by a resource.

## Troubleshooting

If you encounter any errors with the KMS plugin, follow the procedure on the [Troubleshooting page](aks-troubleshoot.md) to troubleshoot the issue.

## Next steps

- Help to protect your cluster in other ways by following the guidance in the [security book for AKS enabled by Azure Arc](/azure/azure-arc/kubernetes/conceptual-security-book).
- [Create Kubernetes clusters](aks-create-clusters-cli.md#deploy-the-application-and-load-balancer)
- [Deploy a Linux application on a Kubernetes cluster](deploy-linux-application.md)

