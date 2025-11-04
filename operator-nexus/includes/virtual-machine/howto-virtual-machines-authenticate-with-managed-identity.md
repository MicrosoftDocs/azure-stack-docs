---
ms.date: 10/23/2025
ms.author: omarrivera
author: g0r1v3r4
ms.topic: include
ms.service: azure-operator-nexus
---

## Authentication using Azure CLI and managed identities

No matter the preferred approach of using a cloud-init script or manual execution, the authentication process using managed identities is similar.
The main difference is that when using a user-assigned managed identity, it's necessary to specify the resource ID of the identity.

### Authenticate with a System-Assigned Managed Identity

```azurecli-interactive
az login --identity --allow-no-subscriptions
```

### Authenticate with a User-Assigned Managed Identity

```azurecli-interactive
export UAMI_ID=$(az identity show --name "$UAMI_NAME" --resource-group "$RESOURCE_GROUP" --query "id" -o tsv)
```

```azurecli-interactive
az login --identity --allow-no-subscriptions --msi-resource-id "${UAMI_ID}"
```

### Get an access token using the managed identity

After successfully authenticating using the managed identity, you can retrieve an access token for a specific Azure resource.
This token can be used to access Azure services securely.

```azurecli-interactive
ACCESS_TOKEN=$(az account get-access-token --resource https://management.azure.com/ --query accessToken -o tsv)
```
