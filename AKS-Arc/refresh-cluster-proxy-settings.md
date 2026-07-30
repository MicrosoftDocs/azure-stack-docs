---
title: Refresh HTTP proxy settings on an AKS on Azure Local cluster
description: Learn how to refresh an AKS on Azure Local cluster so it picks up updated HTTP proxy settings after a proxy configuration change on Azure Local.
ms.topic: how-to
ms.date: 07/28/2026
author: davidsmatlak
ms.author: davidsmatlak
ms.reviewer: srikantsarwa
ms.lastreviewed: 07/28/2026
ms.custom: local

# Intent: As an IT Pro, I want to refresh my AKS on Azure Local cluster so it picks up updated HTTP proxy settings after I change the proxy configuration on Azure Local.
# Keyword: httpProxy refresh update proxy settings

---

# Refresh HTTP proxy settings on an AKS on Azure Local cluster

> [!IMPORTANT]
> The HTTP proxy refresh capability is in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

When you update the HTTP proxy configuration on your Azure Local instance, the change is applied to the Azure Local host and to the Arc resource bridge (ARB). Existing AKS on Azure Local clusters, however, don't automatically pick up the new proxy settings. Until the cluster is refreshed, its control plane, node pools, and add-ons continue to use the proxy configuration that was in effect when they were last deployed or updated.

This article describes how to refresh an existing AKS on Azure Local cluster so that it picks up the updated proxy settings.

## When to refresh a cluster

After you update the HTTP proxy settings on Azure Local, AKS detects that the cluster's proxy configuration is out of date and surfaces the following warning on the cluster's status:

```output
Cluster proxy config is out-of-date. Refresh the cluster to apply the updated proxy settings. For more information, see https://aka.ms/AksArcRefreshProxy
```

This warning indicates that the proxy configuration was changed at the Azure Local or ARB level, but the change hasn't yet been rolled out to the AKS on Azure Local cluster. To apply the updated proxy settings, refresh the cluster by using the steps in the next section.

> [!NOTE]
> A refresh isn't strictly required for the proxy configuration to eventually be updated. Any operation that rolls out the cluster and its components&mdash;such as a Kubernetes version or OS upgrade&mdash;also applies the latest proxy settings. Running the refresh command is the recommended way to apply proxy changes immediately without changing the Kubernetes version.

## Prerequisites

- An existing AKS on Azure Local cluster whose HTTP proxy configuration was updated at the Azure Local or ARB level.
- The latest version of the Azure CLI and the `aksarc` Azure CLI extension. For more information, see [Install the Azure CLI extension](aks-create-clusters-cli.md).
- Permissions to update the AKS on Azure Local cluster resource in the target resource group.

## Refresh the cluster to apply updated proxy settings

To refresh the cluster and apply the updated proxy settings, run the [`az aksarc update`](/cli/azure/aksarc#az-aksarc-update) command with no extra parameters. Replace `<resource-group-name>` with the name of your resource group and `<cluster-name>` with the name of your AKS on Azure Local cluster:

```azurecli-interactive
az aksarc update -g <resource-group-name> -n <cluster-name>
```

Because you don't pass any other parameters, this command performs a refresh (rollout) of the cluster without changing its Kubernetes version or configuration. The refresh reconciles the control plane, node pools, and add-ons so they adopt the updated HTTP proxy settings.

After the command completes successfully, the *proxy config is out-of-date* warning clears from the cluster's status, which confirms that the updated proxy settings are now applied across the cluster.

## Next steps

- [Simplify network configuration requirements with Azure Arc gateway](arc-gateway-aks-arc.md)
- [Networking concepts and requirements](network-system-requirements.md)
