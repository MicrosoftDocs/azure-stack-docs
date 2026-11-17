---
title: Deploy the Network Fabric Controller for multi-rack deployments
description: Create and verify the Network Fabric Controller that connects Azure to the network fabric of a multi-rack deployment of Azure Local by using Azure CLI.
author: dmattern14
ms.author: dylanmattern
ms.service: azure-local
ms.subservice: multi-rack
ms.topic: how-to
ms.date: 11/03/2026
---

# Deploy the Network Fabric Controller for multi-rack deployments

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to create a Network Fabric Controller (NFC) for a multi-rack deployment of Azure Local by using Azure CLI. You create the NFC yourself, and it's the first resource that you create in your deployment.

## About the Network Fabric Controller

The NFC is an Azure resource of type `Microsoft.ManagedNetworkFabric/networkFabricControllers`. It hosts the services that Azure uses to automate and manage the network fabric in your datacenter. The NFC reaches your on-premises network through two Azure ExpressRoute connections: an infrastructure connection and a workload connection.

Create the NFC before you create the Cluster Manager or a network fabric, because both reference it. Create the Cluster Manager before you create a Cluster. Create the NFC, the Cluster Manager, and each network fabric and Cluster that they manage in the same subscription and region. One NFC and Cluster Manager can serve one or more network fabrics and Clusters.

After you create the NFC, you create the Cluster Manager and the network fabric, and then you deploy the Cluster. You can create the Cluster Manager before or while the network fabric is being provisioned.

## Prerequisites

- Complete the [prerequisites for multi-rack deployments of Azure Local](multi-rack-prerequisites.md), including registering the `Microsoft.ManagedNetworkFabric` resource provider in your subscription.
- Install Azure CLI and the `managednetworkfabric` extension. For more information, see [Install Azure CLI extensions for multi-rack deployments of Azure Local](multi-rack-cli-extensions.md).
- Use a Bash shell, such as Azure Cloud Shell or a Linux workstation. The examples use Bash variables.
- Sign in to Azure CLI, and select the subscription where you want to create the NFC. Use the same subscription and Azure region for the Cluster Manager, the network fabric, and the Cluster.
- Have permission to create resources in the target resource group, such as the Contributor role.
- Prepare two different ExpressRoute circuits that connect your on-premises network to Azure: one for the infrastructure connection and one for the workload connection. Each circuit's status must be **Enabled**, and its provider status must be **Provisioned**.
- Get an authorization key for each circuit, and use a separate authorization for each connection. If you own a circuit, you can create the authorization as described in this article. Otherwise, get the key from the circuit owner. For more information, see [Circuit owner operations](/azure/expressroute/expressroute-howto-linkvnet-cli#circuit-owner-operations).
- Choose an IPv4 address space for the NFC with a /19 prefix length, such as `10.0.0.0/19`. It must not overlap with the other networks that the NFC must reach.

## Set the variables

Set the variables that the commands in this article use, and replace the placeholders with your values. The NFC name can have 3–128 characters. It must start with a letter and can contain only letters, numbers, hyphens (`-`), and underscores (`_`).

```azurecli
RESOURCE_GROUP="<resource-group>"
LOCATION="<azure-region>"
NFC_NAME="<nfc-name>"
NFC_IPV4_ADDRESS_SPACE="<ipv4-prefix>"
INFRA_ER_CIRCUIT_ID="/subscriptions/<subscription-id>/resourceGroups/<circuit-resource-group>/providers/Microsoft.Network/expressRouteCircuits/<infrastructure-circuit-name>"
WORKLOAD_ER_CIRCUIT_ID="/subscriptions/<subscription-id>/resourceGroups/<circuit-resource-group>/providers/Microsoft.Network/expressRouteCircuits/<workload-circuit-name>"
```

If the resource group doesn't exist, create it:

```azurecli
az group create --name $RESOURCE_GROUP --location $LOCATION
```

## Get the ExpressRoute authorization keys

Get the ExpressRoute authorization keys for use in the following commands. Treat the keys as sensitive and handle them according to your own credential-management practices.

If you own the circuits, create an authorization on each circuit and read its key:

```azurecli
az network express-route auth create --resource-group <circuit-resource-group> --circuit-name <infrastructure-circuit-name> --name <infrastructure-authorization-name> --output none
az network express-route auth create --resource-group <circuit-resource-group> --circuit-name <workload-circuit-name> --name <workload-authorization-name> --output none

INFRA_ER_AUTH_KEY=$(az network express-route auth show --resource-group <circuit-resource-group> --circuit-name <infrastructure-circuit-name> --name <infrastructure-authorization-name> --query authorizationKey --output tsv)
WORKLOAD_ER_AUTH_KEY=$(az network express-route auth show --resource-group <circuit-resource-group> --circuit-name <workload-circuit-name> --name <workload-authorization-name> --query authorizationKey --output tsv)
```

If the circuit owner gave you the keys, enter each key at a hidden prompt:

```bash
read -rs -p "Infrastructure circuit authorization key: " INFRA_ER_AUTH_KEY; echo
read -rs -p "Workload circuit authorization key: " WORKLOAD_ER_AUTH_KEY; echo
```

## Create the NFC

Create the NFC:

```azurecli
az networkfabric controller create \
  --resource-group $RESOURCE_GROUP \
  --location $LOCATION \
  --resource-name $NFC_NAME \
  --ipv4-address-space $NFC_IPV4_ADDRESS_SPACE \
  --infra-er-connections "[{expressRouteCircuitId:$INFRA_ER_CIRCUIT_ID,expressRouteAuthorizationKey:$INFRA_ER_AUTH_KEY}]" \
  --workload-er-connections "[{expressRouteCircuitId:$WORKLOAD_ER_CIRCUIT_ID,expressRouteAuthorizationKey:$WORKLOAD_ER_AUTH_KEY}]" \
  --mi-system-assigned \
  --output none
```

Then clear the authorization keys from your shell:

```bash
unset INFRA_ER_AUTH_KEY WORKLOAD_ER_AUTH_KEY
```

After the NFC is created, you can change only its ExpressRoute connections, its managed identity, and its tags.

## Verify the NFC

1. Check the provisioning state of the NFC:

    ```azurecli
    az networkfabric controller show \
      --resource-group $RESOURCE_GROUP \
      --resource-name $NFC_NAME \
      --query provisioningState \
      --output tsv
    ```

    The NFC is ready when the state is `Succeeded`. If your session ends before the create command returns, the operation continues in Azure. Run this command again to check its progress.

    If the state is `Failed` or `Canceled`, get the details of the last operation, and then open a support request with the NFC resource ID and those details:

    ```azurecli
    az networkfabric controller show \
      --resource-group $RESOURCE_GROUP \
      --resource-name $NFC_NAME \
      --query "{state:provisioningState, lastOperation:lastOperation.details}" \
      --output json
    ```

1. Save the NFC resource ID. You need it to create the Cluster Manager and the network fabric.

    ```azurecli
    NFC_ID=$(az networkfabric controller show \
      --resource-group $RESOURCE_GROUP \
      --resource-name $NFC_NAME \
      --query id \
      --output tsv)
    echo $NFC_ID
    ```

## Next steps

- [Create the Cluster Manager](multi-rack-deploy-cluster.md#create-the-cluster-manager). Set `--fabric-controller-id` to the NFC resource ID.
- [Deploy and validate the network fabric](multi-rack-deploy-network-fabric.md). Set `--nfc-id` to the NFC resource ID.
