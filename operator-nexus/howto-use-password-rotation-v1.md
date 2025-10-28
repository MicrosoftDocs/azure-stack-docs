---
title: "How to Use Secret Rotation v1 in Azure Operator Nexus"
description: Learn the process for using Password Rotation v1 in Azure Operator Nexus
author: RaghvendraMandawale
ms.author: rmandawale
ms.date: 09/26/2025
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to, devx-track-azurecli
---

# How to use Secret Rotation v1 in Azure Operator Nexus

This guide explains prerequisites for rotating password for a network fabric

## Prerequisites

* Network Fabric & Network Fabric Controller are deployed.
* Environment on NNF 9.2 with API 2025-07-15 enabled .
* Azure CLI installed and authenticated to the correct subscription.
* Ensure Network fabric is in healthy state - Configuration state provisioned and Administrative state : enabled.
* Run outside commit/upgrade workflows; ensure targeted devices are in administrative state - Enabled.

## Operational guardrails

* Do not rotate during an upgrade or while upgrade is Failed.
* Enable disabled devices before rotation or resync.
* Treat rotation as mutually exclusive with other fabric-wide operations.
* If password rotation fails on Terminal server device, customer can retry using Resync password on Network Fabric resource. 

## Azure CLI procedures (GA, Az CLI only)

### 1) Rotate passwords across the fabric

Start a fabric-scoped rotation across all supported devices:

```Azure CLI
az networkfabric fabric rotate-password --ids <nf-id>
```

Sample response (acknowledgment):

```Azure CLI
{ 
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkFabrics/MyFabric", 
  "name": "MyFabric", 
  "type": "Microsoft.ManagedNetworkFabric/networkFabrics", 
  "location": "eastus", 
  "properties": { 
    "provisioningState": "Accepted", 
    "operation": "PasswordRotate" 
  } 
}
```

### 2) Check rotation status (fabric)

View last rotation results and per-device outcomes:
```Azure CLI
az networkfabric fabric show --resource-group "example-rg" --resource-name "example-fabric"
```

Sample output:

```Azure CLI
{
 "lastRotationTime": "2025-09-15T07:46:49Z",
 "state": "Succeeded",
 "totalDevices": 24,
 "succeededDeviceIds": [
 "/subscriptions/.../resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/ce-01",
 "/subscriptions/.../resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/ts-01"
 ],
 "failedDeviceIds": [
 "/subscriptions/.../resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/ce-09"
 ],
 "uniquePasswordSetCount": 2
}
```

### 3) Resync failed devices (fabric scope)

Retry the new password only on specific devices (use device Azure Resource Manager IDs from the previous status output): 

```Azure CLI
az networkfabric fabric resync-password --resource-group example-rg -resource-name example-fabric
```

Sample response (acknowledgment):

```Azure CLI
{
 "operation": "ResyncPasswords",
 "scope": "Fabric",
 "submittedDeviceCount": 2,
 "status": "Accepted"
}
```

### 4) Resync a single device (device scope)

Use the device Azure Resource Manager ID with --IDs (no device name parameter): 

```Azure CLI
az networkfabric device resync-password --resource-group example-rg --resource-name example-device
```

### 5) Get device password status (GA fields)

Return the device-level password/secret status object for auditing and troubleshooting:

```Azure CLI
az networkfabric device show --resource-group "example-rg" --resource-name "example-device"
```

Sample output (based on latest GA example fields):

```Azure CLI
{ 
  "lastRotationTime": "2025-08-09T02:32:12.904Z", 
  "secrets": [ 
    { 
      "synchronizationStatus": "OutOfSync", 
      "secretType": "AzureOperatorRWUserPassword", 
      "secretArchiveReference": { 
        "keyVaultUri": "https://example-kv.vault.azure.net/secrets/example-secret-2/11a536561da34d6b8b452d880df58f3a", 
        "keyVaultId": "/subscriptions/1234ABCD-0A1B-1234-5678-123456ABCDEF/resourceGroups/example-rg/providers/Microsoft.KeyVault/vaults/example-kv", 
        "secretName": "example-secret-2", 
        "secretVersion": "11a536561da34d6b8b452d880df58f3a" 
      } 
    }, 
    { 
      "synchronizationStatus": "Synchronizing", 
      "secretType": "AzureOperatorROUserPassword", 
      "secretArchiveReference": { 
        "keyVaultUri": "https://example-kv.vault.azure.net/secrets/example-secret-3/22b646561da34d6b8b452d880df69a4b", 
        "keyVaultId": "/subscriptions/1234ABCD-0A1B-1234-5678-123456ABCDEF/resourceGroups/example-rg/providers/Microsoft.KeyVault/vaults/example-kv", 
        "secretName": "example-secret-3", 
        "secretVersion": "22b646561da34d6b8b452d880df69a4b" 
      } 
    } 
  ] 
}
```

## Troubleshooting

* BadRequest / Operation not allowed: Fabric is in a conflicting workflow (commit/upgrade). Wait to complete, then retry.
* Devices remain under failedDeviceIds: Ensure device administrative state is Enabled; then run a resync.
* Rotation Accepted but no progress: Verify NNF 9.2, GA API 2025-07-15 enabled, and feature flag is active.
