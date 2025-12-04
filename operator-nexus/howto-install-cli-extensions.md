---
title: "Azure Operator Nexus: Install CLI extensions"
description: Learn to install the needed Azure CLI extensions for Operator Nexus
author: eak13
ms.author: ekarandjeff
ms.service: azure-operator-nexus
ms.custom: devx-track-azurecli
ms.topic: include
ms.date: 12/03/2025
# ms.custom: template-include
---

# Prepare to install Azure CLI extensions

This how-to guide explains the steps for installing the required az CLI and extensions required to interact with Operator Nexus.

Azure CLI is required to be installed before the extensions installations. Follow [Install Azure CLI][installation-instruction] instructions to install it.

Installations of the following CLI extensions are required:
- `networkcloud` for Microsoft.NetworkCloud APIs
- `managednetworkfabric` for Microsoft.ManagedNetworkFabric APIs

>[!NOTE]
> Any upgrade of the Azure CLI downloads the latest stable version of the installed extension.
>The `--allow-preview=True` needs to be explicitly set to install the preview version of the extensions.

## Install `networkcloud` CLI extension

- For list of available versions, see [the extension release history][az-cli-networkcloud-cli-versions].

- Install and verify the latest version of `networkcloud` CLI extension. If the extension is already installed, the command upgrades it when a newer version exists.

    ```azurecli
    az extension add --yes --upgrade --name networkcloud
    az networkcloud --help
    ```

## Install `managednetworkfabric` CLI extension

- For list of available versions, see [the extension release history][az-cli-managednetworkfabric-cli-versions].

- Install and verify the latest version of `networkcloud` CLI extension. If the extension is already installed, the command upgrades it when a newer version exists.

    ```azurecli
    az extension add --yes --upgrade --name managednetworkfabric
    az networkfabric --help
    ```

## Install other Azure extensions

Install the other Azure CLI extensions that Nexus uses. If these extensions are already installed, the commands upgrade them when a newer version exists.

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

<!-- LINKS - External -->
[installation-instruction]: https://aka.ms/azcli

[az-cli-networkcloud-cli-versions]: https://github.com/Azure/azure-cli-extensions/blob/main/src/networkcloud/HISTORY.rst
[az-cli-managednetworkfabric-cli-versions]: https://github.com/Azure/azure-cli-extensions/blob/main/src/managednetworkfabric/HISTORY.rst
