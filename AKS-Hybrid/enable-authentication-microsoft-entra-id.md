---
title: Enable Azure managed identity authentication for Kubernetes clusters with kubelogin
description: Learn how to enable Microsoft Entra ID on Azure Kubernetes Service with kubelogin and authenticate Azure users with credentials or managed roles.
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 06/14/2024
ms.reviewer: abha
ms.topic: how-to
ms.custom:
  - devx-track-azurecli
ms.date: 01/26/2024

# Intent: As an IT Pro, I need to learn how to enable Microsoft Entra ID authentication for Kubernetes clusters
# Keyword: Microsoft Entra ID
---

# Enable Azure managed identity authentication for Kubernetes clusters with kubelogin

The Microsoft Entra integration for AKS enabled by Azure Arc simplifies the Microsoft Entra integration process. Previously, you were required to create a client and server app, and the Microsoft Entra tenant had to assign [Directory Readers](/entra/identity/role-based-access-control/permissions-reference#directory-readers) role permissions. Now, the AKS Arc resource provider manages the client and server apps for you.

Cluster administrators can configure Kubernetes role-based access control (Kubernetes RBAC) based on a user's identity or directory group membership. Microsoft Entra authentication is provided to AKS clusters with OpenID Connect. OpenID Connect is an identity layer built on top of the OAuth 2.0 protocol. For more information about OpenID Connect, see the [OpenID Connect documentation](/entra/identity-platform/v2-protocols-oidc).

For more information about the Microsoft Entra integration flow, see the [Microsoft Entra documentation](concepts-security-access-identity.md#microsoft-entra-integration).

This article provides details on how to enable and use managed identities for Azure resources with your AKS cluster.

## Limitations

The following are constraints when integrating Azure managed identity authentication on AKS enabled by Azure Arc:

* Integration can't be disabled once added.
* Downgrades from an integrated cluster to the legacy Microsoft Entra ID clusters aren't supported.
* Clusters without Kubernetes RBAC support are unable to add the integration.

## Before you begin

Make sure you have the following requirements in order to properly install the AKS addon for managed identity:

* Azure CLI version 2.29.0 or later is installed and configured. Run `az --version` to find the version. If you need to install or upgrade, see [Install Azure CLI](/cli/azure/install-azure-cli).
* `kubectl` with a minimum version of [1.18.1](https://github.com/kubernetes/kubernetes/blob/master/CHANGELOG/CHANGELOG-1.18.md#v1181) or [`kubelogin`](https://github.com/Azure/kubelogin). With the Azure CLI and the Azure PowerShell module, these two commands are included and automatically managed. In other words. they're upgraded by default, so it isn't required or recommended that you run `az aks install-cli`. If you're using an automated pipeline, you must manage upgrades for the correct or latest version. The difference between the minor versions of Kubernetes and `kubectl` shouldn't be more than one version. Otherwise, authentication issues can occur on the wrong version.
* If you're using [helm](https://github.com/helm/helm), you need a minimum version of helm 3.3.
* This configuration requires you have a Microsoft Entra group for your cluster. This group is registered as an admin group on the cluster to grant admin permissions. If you don't have an existing Microsoft Entra group, you can create one using the [`az ad group create`](/cli/azure/ad/group#az_ad_group_create) command.

> [!NOTE]
> Microsoft Entra integrated clusters using a Kubernetes version newer than version 1.24 automatically use the `kubelogin` format. Starting with Kubernetes version 1.24, the default format of the `clusterUser` credential for Microsoft Entra ID clusters is `exec`, which requires the [`kubelogin`](https://github.com/Azure/kubelogin) binary in the execution path. There is no behavior change for non-Microsoft Entra clusters, or for Microsoft Entra ID clusters running a version older than 1.24.
> The existing downloaded `kubeconfig` continues to work. An optional query parameter **format** is included when getting the `clusterUser` credential to overwrite the default behavior change. You can explicitly specify the format as **azure** if you need to maintain the old `kubeconfig` format.

## Enable the integration on your AKS Arc cluster

### Create a new cluster

1. Create an Azure resource group using the [`az group create`](/cli/azure/group#az-group-create) command.

    ```azurecli
    az group create --name myResourceGroup --location centralus
    ```

2. Create an AKS Arc cluster and enable administration access for your Microsoft Entra group using the [`az aksarc create`](/cli/azure/aksarc#az-aksarc-create) command.

    ```azurecli
    az aksarc create \
        --resource-group myResourceGroup \
        --custom-location myCustomLocation
        --name myManagedCluster \
        --aad-admin-group-object-ids <id> [--aad-tenant-id <id>] \
        --generate-ssh-keys
    ```

    A successful creation of an AKS Arc Microsoft Entra ID cluster has the following section in the response body:

    ```output
    "AADProfile": {
        "adminGroupObjectIds": [
        "5d24****-****-****-****-****afa27aed"
        ],
        "clientAppId": null,
        "managed": true,
        "serverAppId": null,
        "serverAppSecret": null,
        "tenantId": "72f9****-****-****-****-****d011db47"
    }
    ```

### Use an existing cluster

Enable Microsoft Entra integration on your existing Kubernetes RBAC-enabled cluster using the [`az aksarc update`](/cli/azure/aksarc#az-aksarc-update) command. Make sure to set your admin group to retain access on your cluster:

```azurecli
az aksarc update \
--resource-group MyResourceGroup 
--name myManagedCluter
--aad-admin-group-object-ids <id-1>,<id-2> [--aad-tenant-id <id>]
```

A successful activation of an AKS-managed Microsoft Entra ID cluster has the following section in the response body:

```output
"AADProfile": {
    "adminGroupObjectIds": [
        "5d24****-****-****-****-****afa27aed"
    ],
    "clientAppId": null,
    "managed": true,
    "serverAppId": null,
    "serverAppSecret": null,
    "tenantId": "72f9****-****-****-****-****d011db47"
    }
```

## Access your enabled cluster

1. Get the user credentials to access your cluster using the [`az aksarc get-credentials`](/cli/azure/aksarc#az-aksarc-get-credentials) command:

    ```azurecli
    az aksarc get-credentials --resource-group myResourceGroup --name myAKSCluster
    ```

2. Follow the instructions to sign in.

3. Set `kubelogin` to use the Azure CLI:

    ```azurecli
    kubelogin convert-kubeconfig -l azurecli
    ```

4. View the nodes in the cluster with the `kubectl get nodes` command:

    ```azurecli
    kubectl get nodes
    ```

## Next steps

* [Microsoft Entra integration with Kubernetes RBAC](kubernetes-rbac-23h2.md)
* [Access and identity options for AKS enabled by Azure Arc](concepts-security-access-identity.md)
