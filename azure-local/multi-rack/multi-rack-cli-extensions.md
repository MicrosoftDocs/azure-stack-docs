---
title: "Install CLI extensions for Azure Local multi-rack deployments (Preview)"
description: Learn to install the needed Azure CLI extensions for Azure Local multi-rack deployments (preview).
author: sipastak
ms.author: sipastak
ms.service: azure-local
ms.topic: how-to
ms.date: 11/10/2025
---

# Install Azure CLI extensions for Azure Local multi-rack deployments (Preview)

This article explains how to install the required Azure CLI extensions for Azure Local multi-rack deployments.

Ensure Azure CLI is installed before the installing the extensions. Follow [Install Azure CLI](/cli/azure) instructions to install it.

Install the following CLI extensions:

- `networkcloud` for Microsoft.NetworkCloud APIs
- `managednetworkfabric` for Microsoft.ManagedNetworkFabric APIs
- `stack-hci-vm` for Microsoft.AzureStackHCI APIs

> [!NOTE]
> Any upgrade of the Azure CLI downloads the latest stable version of the installed extension.
> The `--allow-preview=True` needs to be explicitly set to install the preview version of the extensions.

## Install the `networkcloud` CLI extension

For the list of available versions, see [the extension release history](https://github.com/Azure/azure-cli-extensions/blob/main/src/networkcloud/HISTORY.rst).

- Upgrade any previously installed version of the extension:

    ```azurecli
    az extension add --yes --upgrade --name networkcloud
    ```

- Install and test the latest version of the `networkcloud` CLI extension:

    ```azurecli
    az extension add --name networkcloud
    az networkcloud --help
    ```

## Install the `managednetworkfabric` CLI extension

For the list of available versions, see [the extension release history](https://github.com/Azure/azure-cli-extensions/blob/main/src/managednetworkfabric/HISTORY.rst).

- Upgrade any previously installed version of the extension:

    ```azurecli
    az extension add --yes --upgrade --name managednetworkfabric
    ```

- Install and test the latest version of the `managednetworkfabric` CLI extension:

    ```azurecli
    az extension add --name managednetworkfabric
    az networkfabric --help
    ```

## Install the `stack-hci-vm` CLI extension

- Upgrade any previously installed version of the extension.

    ```azurecli
    az extension add --yes --upgrade --name stack-hci-vm 
    ```

- Install and test the latest version of the `stack-hci-vm` CLI extension.

    ```azurecli
    az extension add --name stack-hci-vm 
    az networkfabric --help
    ```

## Install other Azure extensions

Install the other Azure CLI extensions that multi-rack makes use of:

```azurecli
az extension add --yes --upgrade --name customlocation
az extension add --yes --upgrade --name k8s-extension
az extension add --yes --upgrade --name k8s-configuration
az extension add --yes --upgrade --name connectedmachine
az extension add --yes --upgrade --name monitor-control-service
az extension add --yes --upgrade --name ssh
az extension add --yes --upgrade --name connectedk8s
```

## List installed CLI extensions and versions

List the extension version running:

```azurecli
az extension list --query "[].{Name:name,Version:version}" -o table
```

Example output:

```output
Name                     Version
-----------------------  -------------
monitor-control-service  0.4.1
connectedmachine         1.0.0
connectedk8s             1.10.6
k8s-extension            1.6.4
networkcloud             2.0.0
k8s-configuration        2.2.0
managednetworkfabric     8.0.0
customlocation           0.1.3
ssh                      2.0.6
```
