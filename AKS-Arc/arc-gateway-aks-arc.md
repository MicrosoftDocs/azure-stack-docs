---
title: Simplify network configuration requirements with Azure Arc gateway (preview)
description: Learn how to enable Arc gateway on AKS Arc clusters to simplify network configuration requirements
ms.topic: how-to
ms.date: 11/18/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: abha
ms.lastreviewed: 11/18/2024

---

# Simplify network configuration requirements with Azure Arc Gateway (preview)

If you use enterprise proxies to manage outbound traffic, Azure Arc gateway can help simplify the process of enabling connectivity.

The Azure Arc gateway (currently in preview) lets you:

- Connect to Azure Arc by opening public network access to only seven fully qualified domain names (FQDNs).
- View and audit all traffic that the Arc agents send to Azure via the Arc gateway.

> [!IMPORTANT]
> Azure Arc gateway is currently in preview.
>
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## How the Azure Arc gateway works

The Arc gateway works by introducing two new components:

- The **Arc gateway resource** is an Azure resource that serves as a common front end for Azure traffic. The gateway resource is served on a specific domain/URL. You must create this resource by following the steps described in this article. After you successfully create the gateway resource, this domain/URL is included in the success response.
- The **Arc Proxy** is a new component that runs as its own pod (called *Azure Arc Proxy*). This component acts as a forward proxy used by Azure Arc agents and extensions. There is no configuration required on your part for the Azure Arc Proxy.

For more information, see [how the Azure Arc gateway works](/azure/azure-arc/kubernetes/arc-gateway-simplify-networking?tabs=azure-cli).

> [!IMPORTANT]
> Azure Local and AKS do not support TLS terminating proxies, ExpressRoute/site-to-site VPN or private endpoints. Also, there is a limit of five Arc gateway resources per Azure subscription.

## Before you begin

- Ensure you complete the [prerequisites for creating AKS clusters on Azure Local](aks-hci-network-system-requirements.md).
- This article requires version 1.4.23 or later of Azure CLI. If you use Azure CloudShell, the latest version is already installed.
- The following Azure permissions are required to create Arc gateway resources and manage their association with AKS Arc clusters:
  - `Microsoft.Kubernetes/connectedClusters/settings/default/write`
  - `Microsoft.hybridcompute/gateways/read`
  - `Microsoft.hybridcompute/gateways/write`
- You can create an Arc gateway resource using Azure CLI or the Azure portal. For more information about how to create an Arc gateway resource for your AKS clusters and Azure Local, see [create the Arc gateway resource in Azure](/azure/azure-local/deploy/deployment-azure-arc-gateway-overview?tabs=portal#create-the-arc-gateway-resource-in-azure). When you create the Arc gateway resource, get the gateway resource ID by running the following command:

  ```azurecli
  $gatewayId = "(az arcgateway show --name <gateway's name> --resource-group <resource group> --query id -o tsv)"
  ```

## Confirm access to required URLs

Ensure your Arc gateway URL and all of the URLs below are allowed through your enterprise firewall:

|URL  |Purpose  |
|---------|---------|
|`[Your URL prefix].gw.arc.azure.com`       | Your gateway URL. You can obtain this URL by running `az arcgateway list` after you create the resource.         |
|`management.azure.com`    |Azure Resource Manager endpoint, required for the Azure Resource Manager control channel.         |
|`<region>.obo.arc.azure.com`     |Required when `az connectedk8s proxy` is used.         |
|`login.microsoftonline.com`, `<region>.login.microsoft.com`     | Microsoft Entra ID endpoint, used for acquiring identity access tokens.         |
|`gbl.his.arc.azure.com`, `<region>.his.arc.azure.com`   |The cloud service endpoint for communicating with Arc Agents. Uses short names; for example `eus` for East US.          |
|`mcr.microsoft.com`, `*.data.mcr.microsoft.com`     |Required to pull container images for Azure Arc agents.         |

## Create an AKS Arc cluster with Arc gateway enabled

Run the following command to create an AKS Arc cluster with the Arc gateway enabled:

```azurecli
az aksarc create -n $clusterName -g $resourceGroup --custom-location $customlocationID --vnet-ids $arcVmLogNetId --aad-admin-group-object-ids $aadGroupID --gateway-id $gatewayId --generate-ssh-keys
```

## Update an AKS Arc cluster and enable Arc gateway

Run the following command to update an AKS Arc cluster to enable Arc gateway:

```azurecli
az aksarc update -n $clusterName -g $resourceGroup --gateway-id $gatewayId
```

## Disable Arc gateway on an AKS Arc cluster

Run the following command to disable Arc gateway:

```azurecli
az aksarc update -n $clusterName -g $resourceGroup --disable-gateway
```

## Monitor traffic

To audit your gateway traffic, view the gateway router logs:

1. Run `kubectl get pods -n azure-arc`.
1. Identify the Arc Proxy pod (its name will begin with `arc-proxy-`).
1. Run `kubectl logs -n azure-arc <Arc Proxy pod name>`.

## Other scenarios

During the public preview, Arc gateway covers endpoints required for AKS Arc clusters, and a portion of endpoints required for additional Arc-enabled scenarios. Based on the scenarios you adopt, additional endpoints must still be allowed in your proxy.

All endpoints listed for the following scenarios must be allowed in your enterprise proxy when Arc gateway is in use:

- [Container insights in Azure Monitor](/azure/azure-monitor/containers/kubernetes-monitoring-firewall):
  - `*.ods.opinsights.azure.com`
  - `*.oms.opinsights.azure.com`
  - `*.monitoring.azure.com`
- [Azure Key Vault](/azure/key-vault/general/access-behind-firewall):
  - `<vault-name>.vault.azure.net`
- [Azure Policy](/azure/governance/policy/concepts/policy-for-kubernetes):
  - `data.policy.core.windows.net`
  - `store.policy.core.windows.net`
- [Microsoft Defender for Containers](/azure/defender-for-cloud/defender-for-containers-enable?pivots=defender-for-container-arc&toc=%2Fazure%2Fazure-arc%2Fkubernetes%2Ftoc.json&bc=%2Fazure%2Fazure-arc%2Fkubernetes%2Fbreadcrumb%2Ftoc.json&tabs=aks-deploy-portal%2Ck8s-deploy-asc%2Ck8s-verify-asc%2Ck8s-remove-arc%2Caks-removeprofile-api):
  - `*.ods.opinsights.azure.com`
  - `*.oms.opinsights.azure.com`
- [Azure Arc-enabled data services](/azure/azure-arc/network-requirements-consolidated?tabs=azure-cloud)
  - `*.ods.opinsights.azure.com`
  - `*.oms.opinsights.azure.com`
  - `*.monitoring.azure.com`

## Next steps

- [Deploy extension for MetalLB for Azure Arc enabled Kubernetes clusters](deploy-load-balancer-cli.md).
