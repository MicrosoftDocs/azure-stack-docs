---
title: "Azure Operator Nexus: Manage private endpoints for Arc Relay connectivity"
description: Learn how to configure private endpoint connectivity for Azure Relay namespaces managed by Cluster Manager in Operator Nexus.
author: matthewernst
ms.author: matthewernst
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 01/23/2026
ms.custom: template-how-to
---

# Manage private endpoints for Arc Relay connectivity

Azure Operator Nexus uses Azure Relay to facilitate Arc connectivity between the operator's on-premises infrastructure and Azure. By default, network traffic to and from the Relays flows over the public internet. To improve end-to-end transport security and provide more control over network access, operators can configure private endpoint connectivity from their own networks (on-premises and Azure-based) to the Relay namespace managed by the Cluster Manager.

This article explains how to:

- Retrieve the Relay namespace resource ID from the Cluster Manager
- Create a private endpoint for the Relay namespace
- Approve or reject private endpoint connection requests via the Cluster Manager API

## Prerequisites

- [Install Azure CLI](/cli/azure/install-azure-cli).
- Install the latest version of the [appropriate Azure CLI extensions](./howto-install-cli-extensions.md).
- Private endpoint management requires the `2026-01-01-preview` or later version of the NetworkCloud API.
- The Cluster Manager must be in a `Succeeded` provisioning state.
- You must have appropriate permissions to create private endpoints in your Azure subscription.

## Overview

The Arc Private Relay feature enables operators to establish private connectivity to the Azure Relay namespace that facilitates Arc communication. This approach provides:

- **Enhanced security**: Traffic flows over private networks instead of the public internet.
- **Reduced operational burden**: Self-service API for managing private endpoint connections without requiring manual intervention from Microsoft personnel.
- **Flexibility**: Supports both greenfield (new) and brownfield (existing) deployments.

The workflow involves:

1. Retrieving the Relay namespace resource ID from the Cluster Manager.
1. Creating a private endpoint in your subscription pointing to the Relay namespace.
1. Approving the private endpoint connection via the Cluster Manager API.
1. Configuring private DNS and network settings.

## Retrieve the Relay namespace resource ID

Before creating a private endpoint, you need to retrieve the Relay namespace resource ID from the Cluster Manager. The `relayConfiguration` property in the Cluster Manager response contains this information.

### [Azure CLI](#tab/azure-cli)

```azurecli-interactive
az networkcloud clustermanager show \
    --name "<CLUSTER_MANAGER_NAME>" \
    --resource-group "<RESOURCE_GROUP>" \
    --subscription "<SUBSCRIPTION_ID>" \
    --query "properties.relayConfiguration.relayNamespaceId" \
    --output tsv
```

### [REST API](#tab/rest-api)

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetworkCloud/clusterManagers/{clusterManagerName}?api-version=2026-01-01-preview
```

**Sample response (relevant section):**

```json
{
  "properties": {
    "relayConfiguration": {
      "relayNamespaceId": "/subscriptions/123e4567-e89b-12d3-a456-426655440000/providers/Microsoft.Relay/namespaces/relayNamespaceName"
    }
  }
}
```

---

> [!NOTE]
> The `relayConfiguration.relayNamespaceId` property is read-only and is automatically populated when the Cluster Manager is created. This property is only available with API version `2026-01-01-preview` or later.

## Create a private endpoint for the Relay namespace

After retrieving the Relay namespace resource ID, create a private endpoint in your subscription.

### [Azure CLI](#tab/azure-cli)

```azurecli-interactive
az network private-endpoint create \
    --name "<PRIVATE_ENDPOINT_NAME>" \
    --resource-group "<RESOURCE_GROUP>" \
    --vnet-name "<VNET_NAME>" \
    --subnet "<SUBNET_NAME>" \
    --private-connection-resource-id "<RELAY_NAMESPACE_RESOURCE_ID>" \
    --group-id "namespace" \
    --connection-name "<CONNECTION_NAME>" \
    --manual-request true \
    --subscription "<SUBSCRIPTION_ID>"
```

| Parameter                          | Description                                                                                |
|------------------------------------|--------------------------------------------------------------------------------------------|
| `--name`                           | The name for the private endpoint resource.                                                |
| `--resource-group`                 | The resource group where the private endpoint will be created.                             |
| `--vnet-name`                      | The virtual network containing the subnet for the private endpoint.                        |
| `--subnet`                         | The subnet within the virtual network where the private endpoint will be deployed.         |
| `--private-connection-resource-id` | The Relay namespace resource ID retrieved from the Cluster Manager.                        |
| `--group-id`                       | The target sub-resource type. Use `namespace` for Azure Relay.                             |
| `--connection-name`                | A name for the private endpoint connection.                                                |
| `--manual-request`                 | Set to `true` because the Relay namespace is in a different subscription managed by Azure. |
| `--subscription`                   | The subscription ID where the private endpoint will be created.                            |

### [Azure Portal](#tab/portal)

To create a private endpoint using the Azure portal:

1. Navigate to **Private Link Center** > **Private endpoints**.
1. Select **+ Create**.
1. On the **Basics** tab, provide the subscription, resource group, name, and region.
1. On the **Resource** tab:
   - For **Connection method**, select **Connect to an Azure resource by resource ID or alias**.
   - For **Resource ID or alias**, enter the Relay namespace resource ID retrieved earlier.
   - For **Target sub-resource**, enter `namespace`.
1. On the **Virtual Network** tab, select the virtual network and subnet for the private endpoint.
1. Complete the wizard and select **Create**.

---

> [!IMPORTANT]
> When creating the private endpoint, use `--manual-request true` (CLI) or specify connection by resource ID (portal) since the Relay namespace is in a different subscription managed by Azure.

## Approve or reject the private endpoint connection

After creating the private endpoint, you must approve the connection using the Cluster Manager API. The private endpoint remains in a `Pending` state until approved.

### Approve a private endpoint connection

### [Azure CLI](#tab/azure-cli)

```azurecli-interactive
az networkcloud clustermanager update-relay-private-endpoint-connection \
    --resource-group "<RESOURCE_GROUP>" \
    --cluster-manager-name "<CLUSTER_MANAGER_NAME>" \
    --private-endpoint-resource-id "<PRIVATE_ENDPOINT_RESOURCE_ID>" \
    --connection-state Approved \
    --description "<DESCRIPTION>"
```

| Parameter | Description |
|-----------|-------------|
| `--resource-group` | The resource group containing the Cluster Manager. |
| `--cluster-manager-name` | The name of the Cluster Manager. |
| `--private-endpoint-resource-id` | The resource ID of the private endpoint you created (for example, `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateEndpoints/{privateEndpointName}`). |
| `--connection-state` | The state to set for the connection. Use `Approved` to approve. |
| `--description` | A description to associate with the connection action. |

### [REST API](#tab/rest-api)

```http
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetworkCloud/clusterManagers/{clusterManagerName}/updateRelayPrivateEndpointConnection?api-version=2026-01-01-preview

{
    "connectionState": "Approved",
    "privateEndpointResourceId": "/subscriptions/123e4567-e89b-12d3-a456-426655440000/resourceGroups/resourceGroupName/providers/Microsoft.Network/privateEndpoints/privateEndpointName",
    "description": "Approving private endpoint connection"
}
```

**Request body parameters:**

| Parameter                   | Type   | Required | Description                                                                                 |
|-----------------------------|--------|----------|---------------------------------------------------------------------------------------------|
| `connectionState`           | string | Yes      | The state to set for the private endpoint connection. Valid values: `Approved`, `Rejected`. |
| `privateEndpointResourceId` | string | Yes      | The resource ID of the private endpoint to approve or reject.                               |
| `description`               | string | No       | A description to associate with the private endpoint connection action.                     |

**Response:**

The API returns a `202 Accepted` response with a `Location` header that you can use to track the status of the asynchronous operation.

```http
HTTP/1.1 202 Accepted
Location: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.NetworkCloud/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-01-preview
```

To check the final status of the operation, poll the URL in the `Location` header:

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.NetworkCloud/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-01-preview
```

The response includes a `status` field that indicates the operation state. Wait until `status` is `Succeeded` or `Failed` before proceeding.

---

### Reject a private endpoint connection

If you need to reject a pending private endpoint connection or revoke an existing connection:

### [Azure CLI](#tab/azure-cli)

```azurecli-interactive
az networkcloud clustermanager update-relay-private-endpoint-connection \
    --resource-group "<RESOURCE_GROUP>" \
    --cluster-manager-name "<CLUSTER_MANAGER_NAME>" \
    --private-endpoint-resource-id "<PRIVATE_ENDPOINT_RESOURCE_ID>" \
    --connection-state Rejected \
    --description "<DESCRIPTION>"
```

| Parameter                        | Description                                                                                                                                                                                                 |
|----------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `--resource-group`               | The resource group containing the Cluster Manager.                                                                                                                                                          |
| `--cluster-manager-name`         | The name of the Cluster Manager.                                                                                                                                                                            |
| `--private-endpoint-resource-id` | The resource ID of the private endpoint you created (for example, `/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/privateEndpoints/{privateEndpointName}`). |
| `--connection-state`             | The state to set for the connection. Use `Rejected` to reject.                                                                                                                                              |
| `--description`                  | A description to associate with the connection action.                                                                                                                                                      |

### [REST API](#tab/rest-api)

```http
POST https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.NetworkCloud/clusterManagers/{clusterManagerName}/updateRelayPrivateEndpointConnection?api-version=2026-01-01-preview

{
    "connectionState": "Rejected",
    "privateEndpointResourceId": "/subscriptions/123e4567-e89b-12d3-a456-426655440000/resourceGroups/resourceGroupName/providers/Microsoft.Network/privateEndpoints/privateEndpointName",
    "description": "Rejecting private endpoint connection"
}
```

**Request body parameters:**

| Parameter                   | Type   | Required | Description                                                                                 |
|-----------------------------|--------|----------|---------------------------------------------------------------------------------------------|
| `connectionState`           | string | Yes      | The state to set for the private endpoint connection. Valid values: `Approved`, `Rejected`. |
| `privateEndpointResourceId` | string | Yes      | The resource ID of the private endpoint to approve or reject.                               |
| `description`               | string | No       | A description to associate with the private endpoint connection action.                     |

**Response:**

The API returns a `202 Accepted` response with a `Location` header that you can use to track the status of the asynchronous operation.

```http
HTTP/1.1 202 Accepted
Location: https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.NetworkCloud/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-01-preview
```

To check the final status of the operation, poll the URL in the `Location` header:

```http
GET https://management.azure.com/subscriptions/{subscriptionId}/providers/Microsoft.NetworkCloud/locations/{location}/operationStatuses/{operationId}?api-version=2026-01-01-preview
```

The response includes a `status` field that indicates the operation state. Wait until `status` is `Succeeded` or `Failed` before proceeding.

---

## Configure private DNS

After the private endpoint connection is approved, configure private DNS for the Azure Relay namespace to ensure traffic routes through the private endpoint.

1. Create a private DNS zone for Azure Relay:

   ```azurecli-interactive
   az network private-dns zone create \
       --resource-group "<RESOURCE_GROUP>" \
       --name "privatelink.servicebus.windows.net"
   ```

1. Link the private DNS zone to your virtual network:

   ```azurecli-interactive
   az network private-dns link vnet create \
       --resource-group "<RESOURCE_GROUP>" \
       --zone-name "privatelink.servicebus.windows.net" \
       --name "<DNS_LINK_NAME>" \
       --virtual-network "<VNET_NAME>" \
       --registration-enabled false
   ```

1. Create DNS records for the private endpoint:

   ```azurecli-interactive
   az network private-endpoint dns-zone-group create \
       --resource-group "<RESOURCE_GROUP>" \
       --endpoint-name "<PRIVATE_ENDPOINT_NAME>" \
       --name "default" \
       --private-dns-zone "privatelink.servicebus.windows.net" \
       --zone-name "servicebus"
   ```

## Verify connectivity

After completing the configuration, verify that the private endpoint connection is established:

1. Check the private endpoint connection state in the Azure portal or via CLI.
1. Verify DNS resolution from within your virtual network points to the private IP address.
1. Confirm Arc connectivity is functioning through the private endpoint.

## Troubleshooting

### Private endpoint connection stays in Pending state

- Ensure you're using the correct `privateEndpointResourceId` when calling the approve API.
- Verify the Cluster Manager is in a `Succeeded` provisioning state.

### DNS resolution issues

- Verify the private DNS zone is correctly linked to your virtual network.
- Ensure DNS records were created for the private endpoint.
- Check that your network configuration allows DNS queries to the private DNS zone.

### Connection approval fails

- Confirm the private endpoint exists and is in your subscription.
- Verify you have the `Microsoft.NetworkCloud/clusterManagers/updateRelayPrivateEndpointConnection/action` permission on the Cluster Manager resource, or a role that includes `Microsoft.NetworkCloud/*` permissions.
- Review the error message returned by the API for specific details.

## Related content

- [Cluster Manager: How to manage the Cluster Manager in Operator Nexus](howto-cluster-manager.md)
- [Azure Private Link documentation](/azure/private-link/private-link-overview)
- [Azure Relay documentation](/azure/azure-relay/relay-what-is-it)
