---
title: Install CLI extensions for multi-rack deployments of Azure Local (preview)
description: Learn how to install the needed Azure CLI extensions for multi-rack deployments of Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.service: azure-local
ms.topic: how-to
ms.date: 11/14/2025
---

# Install Azure CLI extensions for multi-rack deployments of Azure Local (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article explains how to install the required Azure CLI extensions for multi-rack deployments of Azure Local.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Install Azure CLI

Ensure Azure CLI is installed before installing the extensions. Follow [Install Azure CLI](/cli/azure/install-azure-cli) instructions to install it.

## Install required Azure CLI extensions

See the following sections to install the required Azure CLI extensions:

- `networkcloud` for Microsoft.NetworkCloud APIs
- `managednetworkfabric` for Microsoft.ManagedNetworkFabric APIs
- `stack-hci-vm` for Microsoft.AzureStackHCI APIs

> [!NOTE]
> Any upgrade of the Azure CLI downloads the latest stable version of the installed extension.
> To install the preview version of the extensions, you must explicitly set the `--allow-preview=True` parameter.

### Install the `networkcloud` CLI extension

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

### Install the `managednetworkfabric` CLI extension

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

### Install the `stack-hci-vm` CLI extension

- Upgrade any previously installed version of the extension.

    ```azurecli
    az extension add --yes --upgrade --name stack-hci-vm 
    ```

- Install and test the latest version of the `stack-hci-vm` CLI extension.

    ```azurecli
    az extension add --name stack-hci-vm 
    az stack-hci-vm --help
    ```

### Install other Azure extensions

Install other Azure CLI extensions that multi-rack deployment makes use of:

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
stack-hci-vm             0.1.18
customlocation           0.1.3
ssh                      2.0.6
```
