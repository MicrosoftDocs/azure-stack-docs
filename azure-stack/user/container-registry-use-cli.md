---
title: Use Azure CLI with Azure Container Registry on Azure Stack Hub
description: Learn how to use Azure CLI with Azure Container Registry on Azure Stack Hub.
author: sethmanheim
ms.topic: article
ms.custom:
  - devx-track-azurecli
ms.date: 07/25/2024
ms.author: sethm
ms.reviewer: dgarrity
ms.lastreviewed: 04/10/2024

# Intent: As an Azure Stack user, I want to use Azure CLI to manage my container registry.
# Keyword: Azure CLI ACR
---

# Use Azure CLI with Azure Container Registry on Azure Stack Hub

This article describes how to use Azure CLI to work with Azure Container Registry on Azure Stack Hub.

## Prerequisites

Using Azure CLI to manage Azure Container Registry on Hub requires Azure CLI version 2.28.0 or higher. Install or update your current CLI installation to the latest release. FOr more information, see [How to install the Azure CLI](/cli/azure/install-azure-cli).

## Register an Azure Stack Hub with Azure Container Registry using CLI

Once you've installed the Azure CLI, you'll need to register Azure Stack Hub as a cloud and provide the required endpoints including the new `suffix-acr-login-server-endpoint`. Update the script to include details specific to your Azure Stack Hub and run the script. For more information about using CLI with Azure Stack Hub, see [Manage Azure Stack Hub with Azure CLI](azure-stack-version-profiles-azurecli2.md)

```azurecli
az cloud register `
    -n <CloudName>
    --endpoint-resource-manager "https://management.<region>.<fqdn>" `
    --suffix-storage-endpoint "<region>.<fqdn>" `
    --suffix-keyvault-dns ".vault.<region>.<fqdn>" `
    --endpoint-active-directory-graph-resource-id "https://graph.windows.net/" `
    --suffix-acr-login-server-endpoint ".azsacr.<region>.<fqdn>"
```

## Update the Azure Container Registry login server endpoint

Update an existing Azure Stack Hub CLI registration to include the Azure Container Registry login server endpoint.

If you previously installed the CLI and registered a cloud, you'll need to update the CLI to include the new `suffix-acr-login-server-endpoint` before you can create and manage Azure Container Registry resources. Update the following script to include details specific to your Azure Stack Hub, then run the script:

```azurecli  
az cloud update -n <CloudName> `
--suffix-acr-login-server-endpoint ".azsacr.<region>.<fqdn>"
```

## Set the active cloud environment and API profile

Set the active cloud environment by using the following command:

```azurecli
az cloud set -n <CloudName>
```

Update your environment configuration to use the Azure Stack Hub-specific API version profile. To update the configuration, run the following command:

```azurecli
az cloud update --profile 2020-09-01-hybrid
```

## Review supported commands

Before you use CLI to manage Azure Container Registry resources, review the [list of supported commands](container-registry-commands.md).

## Azure Container Registry CLI quickstart

Get started creating a container registry using the [Quickstart: Create a private container registry using the Azure CLI](/azure/container-registry/container-registry-get-started-azure-cli).

When you use the Azure Container Registry documentation for global Azure, such as the quickstart, keep in mind the key differences between Azure Container Registry on Azure Stack Hub and Azure Container Registry in global Azure. For a list of differences, see the [Azure Container Registry on Azure Stack Hub overview](container-registry-overview.md#azure-container-registry-on-azure-and-azure-container-registry-on-azure-stack-hub).

## Next steps

Learn more about [Azure Container Registry on Azure Stack Hub](container-registry-overview.md)
