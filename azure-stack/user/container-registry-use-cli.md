---
title: Use Azure CLI with Azure Container Registries on Azure Stack Hub
description: Learn how to use Azure CLI with Azure Container Registries on Azure Stack Hub
author: mattbriggs
ms.topic: article
ms.date: 10/26/201
ms.author: mabrigg
ms.reviewer: chasat
ms.lastreviewed: 10/26/201

# Intent: As an Azure Stack user, I want to use Azure CLI to manage my registry.
# Keyword: Azure CLI ACR

---

# Use Azure CLI with Azure Container Registries on Azure Stack Hub

You can use Azure CLI to work with your Azure Container Registries (ACR) on Azure Stack Hub. This article will help you get set up and oriented to working with Azure CLI on Azure Stack Hub.

## Prerequisites

Azure CLI to manage ACR on Hub requires Azure CLI version 2.28.0 or higher. Install or update your current CLI installation to the latest release. You can find Azure CLI documentation, [How to install the Azure CLI ](/cli/azure/install-azure-cli).

## Register an Azure Stack Hub with ACR using CLI

Once you've installed the Azure CLI, you'll need to register the Azure Stack Hub as a cloud and provide the required endpoints including the new `suffix-acr-login-server-endpoint`. Update the script to include details specific to your Azure Stack Hub and run the script. For more details on using CLI with Azure Stack Hub visit this link [Manage Azure Stack Hub with Azure CLI](azure-stack-version-profiles-azurecli2.md)

```azurecli
az cloud register `
    -n <CloudName>
    --endpoint-resource-manager "https://management.<region>.<fqdn>" `
    --suffix-storage-endpoint "<region>.<fqdn>" `
    --suffix-keyvault-dns ".vault.<region>.<fqdn>" `
    --endpoint-active-directory-graph-resource-id "https://graph.windows.net/" `
    --suffix-acr-login-server-endpoint ".azsacr.<region>.<fqdn>"
```

## Update the ACR login server endpoint

Update an existing Azure Stack Hub CLI registration to include the ACR login server endpoint.

If you previously installed the CLI and registered a cloud, you'll need to update the CLI to include the new `suffix-acr-login-server-endpoint` before you can create and manage ACR resources. Update the script below to include details specific to your Azure Stack Hub and run the script.

```azurecli  
az cloud update -n <CloudName> `
--suffix-acr-login-server-endpoint ".azsacr.<region>.<fqdn>"
```
## Set the active Cloud environment and API profile

Set the active Cloud environment by using the following command:

```azurecli
az cloud set -n <CloudName>
```
Update your environment configuration to use the Azure Stack Hub specific API version profile. To update the configuration, run the following command:

```azurecli
az cloud update --profile 2020-09-01-hybrid
```

## Review supported commands

Before using CLI to manage ACR resources review the list of [supported commands](container-registry-commands.md).

## ACR CLI quickstart

Get started creating a registry using [Quickstart: Create a private container registry using the Azure CLI](/azure/container-registry/container-registry-get-started-azure-cli).

When using ACR documentation for global Azure, such as the quickstart, keep in mind the key differences between ACR on Azure Stack Hub and ACR in global Azure. For a list of differences, see [Azure Container Registries on Azure Stack Hub overview](container-registry-overview.md#acr-on-azure-and-acr-on-azure-stack-hub)

## Next steps

Learn more about the [Azure Container Registry on Azure Stack Hub](container-registry-overview.md).
