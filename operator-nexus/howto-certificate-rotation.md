---
title: "Use Certificate Rotation in Azure Operator Nexus"
description: Learn the process for using certificate rotation in Azure Operator Nexus.
author: ronmiab
ms.author: robess
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 3/31/2026
---


# Use certificate rotation in Azure Operator Nexus
API-driven Certificate Rotation enables customers to self-serve certificate rotation and resynchronization for Nexus Network Fabric. This capability allows customers to manage certificate lifecycle operations directly, while preserving existing operational safeguards. 

## Key capabilities

* **Fabric-wide certificate rotation:** Creates new client and server (leaf) certificates and applies them across supported devices in a network fabric.
* **Asynchronous execution with status tracking:** Rotation and resync operations run as ARM async actions; use the `Location` header and operation status endpoint to track progress to completion.
* **Device-scoped certificate resynchronization:** Re-syncs the latest certificates on an individual device, especially for devices that were missed or temporarily disabled.
* **Device-level certificate visibility:** Exposes certificateRotationStatus on each network device, including certificate type, last rotation time, expiry time, and sync state.
* **Expiry monitoring at scale:** Supports Azure Resource Graph queries to identify certificates nearing expiration across devices.
* **Partial-success remediation path:** If some devices fail during fabric operations, failures are surfaced for remediation by enabling affected devices and rerunning targeted resync.

This article explains the prerequisites for rotating certificates for a network fabric.

## Prerequisites

* Enable the environment on supported NF version with supported API. 
* Install and authenticate the Azure CLI to the correct subscription.
* Ensure that Nexus Network Fabric is in a healthy state, the configuration state is provisioned, and the administrative state is Enabled.
* Run outside commit/upgrade workflows. Ensure that the administrative state for the targeted devices is Enabled.

## Operational guardrails

* Don't rotate during an upgrade or while the upgrade status is Failed.
* Enable disabled devices before rotation or resync.
* Treat rotation as mutually exclusive with other fabric-wide operations.

## Azure CLI procedures

### 1. Rotate certificates across the fabric

Start a fabric-scoped rotation across all supported devices:

```Azure CLI
az rest --method post --url "https://management.azure.com/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkFabrics/MyFabric/rotateCertificates?api-version=2025-07-15" --verbose
```
>[!Note]
>You must pass either `--verbose` or `--debug` so that the reply includes the `Location` parameter, needed to query the result.

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


### 3. Resync a single device 

Retry syncing the new certificates on all devices:

```Azure CLI
az rest --method post --url "https://management.azure.com/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/MyResourceGroup/providers/Microsoft.ManagedNetworkFabric/networkDevices/MyDevice/resyncCertificates?api-version=2025-07-15" --verbose
```

>[!Note]
>You must pass either `--verbose` or `--debug` so that the reply includes the `Location` parameter, needed to query the result.

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
      "keyVaultId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/nfcdd4383-HostedResources-66492796/providers/Microsoft.KeyVault/vaults/nfcd43830206150742kv",
      "keyVaultUri": "https://nfcd43830206150742kv.vault.azure.net/certificates/azcert-MyFabric-20260206-client-20260206/00000000000000000000000000000000"
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
      "keyVaultId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/nfcdd4383-HostedResources-66492796/providers/Microsoft.KeyVault/vaults/nfcd43830206150742kv",
      "keyVaultUri": "https://nfcd43830206150742kv.vault.azure.net/certificates/azcert-MyFabric-20260206-server-20260206/00000000000000000000000000000000"
    },
    "certificateType": "ServerCertificate",
    "expireTime": "2027-02-27T12:40:55Z",
    "lastRotationTime": "2026-02-27T12:40:55Z",
    "synchronizationStatus": "InSync"
  }
]
```

## Monitoring
It's possible to set up queries to show certificates that are nearing expiry.

For example, this query finds the 10 certificates closest to expiry, limited to those expiring within the next 30 days.
Change `30d` from the `expireTime` filter to expand the time range.  Change or remove the `| take 10` filter to display more results.

```Powershell
$KQL = @'
resources
| where type =~ 'microsoft.managednetworkfabric/networkdevices'
| where isnotempty(properties.certificateRotationStatus)
| mv-expand certEntry = properties.certificateRotationStatus
| extend expireTime = todatetime(certEntry.expireTime)
| where expireTime < now() + 30d
| summarize earliestExpiry = min(expireTime) by resourceGroup, name
| project earliestExpiry, resourceGroup, name
| sort by earliestExpiry asc, resourceGroup asc, name asc
| take 10
'@

$KQL = $KQL -replace "`r`n", " " -replace "`n", " "

az graph query --graph-query "$KQL" --query "data[]" --output table
```

```Azure Linux
#!/bin/bash
set -u

read -r -d '' KQL << EOF
resources
  | where type =~ "microsoft.managednetworkfabric/networkdevices"
  | where isnotempty(properties.certificateRotationStatus)
  | mv-expand certEntry = properties.certificateRotationStatus
  | extend expireTime = todatetime(certEntry.expireTime)
  | where expireTime < now() + 30d
  | summarize earliestExpiry = min(expireTime) by resourceGroup, name
  | project earliestExpiry, resourceGroup, name
  | sort by earliestExpiry asc, resourceGroup asc, name asc
  | take 10
EOF

az graph query \
  --graph-query "${KQL}" \
  --query "data[]" \
  --output table
```

## Troubleshooting

* **Operation fails:** Check output from the command.  Result may be Failed (if the whole operation has failed) or PartialSuccess (if the operation succeeded on some devices but not others).  The error detail will list errors on devices.  Address any issues and then run the per-device resync operation on the affected devices.
* **BadRequest/Operation not allowed:** Fabric is in a conflicting workflow (commit/upgrade). Wait for the operation to finish, and then retry.
* **Devices remain under failedDeviceIds:** Ensure that the device administrative state is Enabled, and then run a resync.