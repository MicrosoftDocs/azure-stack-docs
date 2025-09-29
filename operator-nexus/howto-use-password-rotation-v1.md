---
title: How to use Password Rotation v1 in Azure Operator Nexus
description: Learn the process for using Password Rotation v1 in Azure Operator Nexus
author: RaghvendraMandawale
ms.author: rmandawale
ms.date: 09/26/2025
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to, devx-track-azurecli
---

# How to use Password Rotation v1 in Azure Operator Nexus

This guide explains prerequisites for rotating password for a network fabric

## Prerequisites

* Network Fabric & Network Fabric Controller are deployed.
* Environment on NNF 9.2 with API 2025-07-15 enabled .
* Azure CLI installed and authenticated to the correct subscription.
* Run outside commit/upgrade workflows; ensure targeted devices are in administrative state - Enabled.

## Operational guardrails

* Do not start rotation while a commit batch is in progress.
* Do not rotate during an upgrade or while upgrade is Failed.
* Enable disabled devices before rotation or resync.
* Treat rotation as mutually exclusive with other fabric-wide operations.

## Azure CLI procedures (GA, Az CLI only)

### 1) Rotate passwords across the fabric

Start a fabric-scoped rotation across all supported devices:

`az networkfabric fabric password-rotate \
 --resource-group MyResourceGroup \
 --resource-name MyFabric \
 --only-show-errors`

Sample response (acknowledgement):

`{
 "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkFabrics/MyFabric",
 "name": "MyFabric",
 "type": "Microsoft.ManagedNetworkFabric/networkFabrics",
 "location": "eastus",
 "properties": {
 "provisioningState": "Accepted",
 "operation": "PasswordRotate"
 }
}`

### 2) Check rotation status (fabric)

View last rotation results and per-device outcomes:

`az networkfabric fabric show \
 --resource-group MyResourceGroup \
 --resource-name MyFabric \
 --query "properties.passwordRotationStatus"`

Sample output:

`{
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
}`

### 3) Resync failed devices (fabric scope)

Retry the new password only on specific devices (use device ARM IDs from the previous status output):

`az networkfabric fabric resync-passwords \
 --resource-group MyResourceGroup \
 --resource-name MyFabric \
 --device-ids \
 "/subscriptions/.../resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/ce-09" \
 "/subscriptions/.../resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/ce-10" \
 --only-show-errors`

Sample response (acknowledgement):

`{
 "operation": "ResyncPasswords",
 "scope": "Fabric",
 "submittedDeviceCount": 2,
 "status": "Accepted"
}`

### 4) Resync a single device (device scope)

Use the device ARM ID with --ids (no device name parameter):

`az networkfabric device resync-passwords \
 --ids \
 "/subscriptions/.../resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/ce-09" \
 --only-show-errors`

### 5) Get device password status (GA fields)

Return the device-level password/secret status object for auditing and troubleshooting:

`az networkfabric device show \
 --ids \
 "/subscriptions/.../resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/ce-09" \
 --query "properties.passwordStatus"`

Sample output (based on latest GA example fields):

`{
 "lastRotationTime": "2025-08-09T02:32:12.904Z",
 "secrets": [
 {
 "synchronizationStatus": "OutOfSync",
 "secretType": "AzureOperatorRWUserPassword",
 "secretArchiveReference": {
 "keyVaultUri": "https://example-kv.vault.azure.net/secrets/{SECRET_NAME}/{SECRET_VERSION}",
 "keyVaultId": "/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP}/providers/Microsoft.KeyVault/vaults/{KEYVAULT_NAME}",
 "secretName": "{SECRET_NAME_PLACEHOLDER}",
 "secretVersion": "{SECRET_VERSION_PLACEHOLDER}"
 }
 },
 {
 "synchronizationStatus": "Synchronizing",
 "secretType": "AzureOperatorROUserPassword",
 "secretArchiveReference": {
 "keyVaultUri": "https://example-kv.vault.azure.net/secrets/{SECRET_NAME}/{SECRET_VERSION}",
 "keyVaultId": "/subscriptions/{SUBSCRIPTION_ID}/resourceGroups/{RESOURCE_GROUP}/providers/Microsoft.KeyVault/vaults/{KEYVAULT_NAME}",
 "secretName": "{SECRET_NAME_PLACEHOLDER}",
 "secretVersion": "{SECRET_VERSION_PLACEHOLDER}"
 }
 }
 ]
}`

## Troubleshooting

* BadRequest / Operation not allowed: Fabric is in a conflicting workflow (commit/upgrade). Wait to complete, then retry.
* Devices remain under failedDeviceIds: Ensure device administrative state is Enabled; then run a resync.
* Rotation Accepted but no progress: Verify NNF 9.2, GA API 2025-07-15 enabled, and feature flag is active.
