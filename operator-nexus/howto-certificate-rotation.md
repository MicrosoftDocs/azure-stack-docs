---
title: "Use Certificate Rotation in Azure Operator Nexus"
description: Learn the process for using certificate rotation in Azure Operator Nexus.
author: rbhupatiraju 
ms.author: rbhupatiraju
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 31/03/2026
---

# Use certificate rotation in Azure Operator Nexus

This article explains how to rotate certificates for a network fabric.

## Prerequisites

* Enable the environment on supported NF version with supported API.
* Install and authenticate the Azure CLI to the correct subscription.
* Ensure that Nexus Network Fabric is in a healthy state, the configuration state is provisioned, and the administrative state is Enabled.
* Run outside commit/upgrade workflows. Ensure that the administrative state for the targeted devices is Enabled.

## Operational guardrails

* Don't rotate during an upgrade or while the upgrade status is Failed.
* Enable disabled devices before rotation or resync.
* Treat rotation as mutually exclusive with other fabric-wide operations.

## Azure CLI procedures (GA, Az CLI only)

### 1. Rotate certificates across the fabric

Start a fabric-scoped rotation across all supported devices:

```Azure CLI
az rest --method post --url "https://management.azure.com/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkFabrics/MyFabric/rotateCertificates?api-version=2025-07-15" --verbose
```

Note: you must pass either `--verbose` or `--debug` so that the reply includes the `Location` parameter, needed to query the result.

Sample response, containing `Location` parameter which is needed to query status:

```Azure CLI
Request URL: 'https://management.azure.com/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkFabrics/MyFabric/rotateCertificates?api-version=2025-07-15'
Request method: 'POST'
Request headers:
    ...
Request body:
None
Response status: 202
Response headers:
    ...
    'Location': 'https://management.azure.com/subscriptions/...'
    ...
Response content:
null
```

Result of the operation can be queried using `az rest`:

```Azure CLI
az rest --url '{Location}'
```

Sample response while rotation is happening:

```Azure CLI
{
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.ManagedNetworkFabric/locations/{Region}/operationStatuses/...",
  "name": "...",
  "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkFabrics/MyFabric",
  "startTime": "...",
  "status": "Accepted"
}
```

Sample response once rotation has completed:

```Azure CLI
{
  "endTime": "2026-03-19T16:36:21.0453827Z",
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.ManagedNetworkFabric/locations/{Region}/operationStatuses/...",
  "name": "23d4460f...",
  "properties": null,
  "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/NetworkFabrics/MyFabric",
  "startTime": "2026-03-19T16:25:01.6370816Z",
  "status": "Succeeded"
}
```

### 2. Resync failed devices (fabric scope)

Retry syncing the new certificates on all devices:

```Azure CLI
az rest --method post --url "https://management.azure.com/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkFabrics/MyFabric/resyncCertificates?api-version=2025-07-15" --verbose
```

Note: you must pass either `--verbose` or `--debug` so that the reply includes the `Location` parameter, needed to query the result.

Sample response, containing `Location` parameter which is needed to query status:

```Azure CLI
Request URL: 'https://management.azure.com/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkFabrics/MyFabric/resyncCertificates?api-version=2025-07-15'
Request method: 'POST'
Request headers:
    ...
Request body:
None
Response status: 202
Response headers:
    ...
    'Location': 'https://management.azure.com/subscriptions/...'
    ...
Response content:
null
```

Result of the operation can be queried using `az rest`:

```Azure CLI
az rest --url '{Location}'
```

Sample response while resync is happening:

```Azure CLI
{
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.ManagedNetworkFabric/locations/{Region}/operationStatuses/...",
  "name": "...",
  "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkFabrics/MyFabric",
  "startTime": "...",
  "status": "Accepted"
}
```

Sample response once resync has completed:

```Azure CLI
{
  "endTime": "2026-03-19T17:21:38.8649384Z",
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.ManagedNetworkFabric/locations/{Region}}/operationStatuses/...",
  "name": "...",
  "properties": null,
  "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkFabrics/MyFabric",
  "startTime": "2026-03-19T17:14:16.6026953Z",
  "status": "Succeeded"
}
```

### 3. Resync a single device (device scope)

Retry syncing the new certificates on a single device:

```Azure CLI
az rest --method post --url "https://management.azure.com/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/MyDevice/resyncCertificates?api-version=2025-07-15" --verbose
```

Note: you must pass either `--verbose` or `--debug` so that the reply includes the `Location` parameter, needed to query the result.

Sample response, containing `Location` parameter which is needed to query status:

```Azure CLI
Request URL: 'https://management.azure.com/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/MyDevice/resyncCertificates?api-version=2025-07-15'
Request method: 'POST'
Request headers:
    ...
Request body:
None
Response status: 202
Response headers:
    ...
    'Location': 'https://management.azure.com/subscriptions/...'
    ...
Response content:
null
```

Result of the operation can be queried using `az rest`:

```Azure CLI
az rest --url '{Location}'
```

Sample response while resync is happening:

```Azure CLI
{
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.ManagedNetworkFabric/locations/{Region}/operationStatuses/...",
  "name": "...",
  "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/MyDevice",
  "startTime": "...",
  "status": "Accepted"
}
```

Sample response once resync has completed:

```Azure CLI
{
  "endTime": "2026-03-19T16:53:51.3739074Z",
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.ManagedNetworkFabric/locations/{Region}/operationStatuses/...",
  "name": "...",
  "properties": null,
  "resourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/MyDevice",
  "startTime": "2026-03-19T16:48:16.6660348Z",
  "status": "Succeeded"
}
```

### 4. Get device certificate rotation status

Return the device-level certificate rotation status object for auditing and troubleshooting:

```Azure CLI
az rest --url "https://management.azure.com/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/MyDevice?api-version=2025-07-15" --query "properties.certificateRotationStatus"
```

Sample output:

```Azure CLI
[
  {
    "certificateArchiveReference": {
      "certificateName": "azcert-MyFabric-20260206-client-20260206",
      "certificateVersion": "00000000000000000000000000000000",
      "keyVaultId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/nfc000000-HostedResources-000000/providers/Microsoft.KeyVault/vaults/nfcd00000000000000kv",
      "keyVaultUri": "https://nfcd00000000000000kv.vault.azure.net/certificates/azcert-MyFabric-20260206-client-20260206/00000000000000000000000000000000"
    },
    "certificateType": "ClientCertificate",
    "expireTime": "2027-02-27T12:40:55Z",
    "lastRotationTime": "2026-02-27T12:40:55Z",
    "synchronizationStatus": "InSync"
  },
  {
    "certificateArchiveReference": {
      "certificateName": "azcert-MyFabric-20260206-server-20260206",
      "certificateVersion": "00000000000000000000000000000000",
      "keyVaultId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/nfc000000-HostedResources-000000/providers/Microsoft.KeyVault/vaults/nfcd00000000000000kv",
      "keyVaultUri": "https://nfcd00000000000000kv.vault.azure.net/certificates/azcert-MyFabric-20260206-server-20260206/00000000000000000000000000000000"
    },
    "certificateType": "ServerCertificate",
    "expireTime": "2027-02-27T12:40:55Z",
    "lastRotationTime": "2026-02-27T12:40:55Z",
    "synchronizationStatus": "InSync"
  }
]
```

## Troubleshooting

* **Operation fails:** Check output from the command.  Result may be Failed (if the whole operation has failed) or PartialSuccess (if the operation succeeded on some devices but not others).  The error detail will list errors on devices.  Address any issues and then run the per-device resync operation on the affected devices.
* **BadRequest/Operation not allowed:** Fabric is in a conflicting workflow (commit/upgrade). Wait for the operation to finish, and then retry.
* **Devices remain under failedDeviceIds:** Ensure that the device administrative state is Enabled, and then run a resync.