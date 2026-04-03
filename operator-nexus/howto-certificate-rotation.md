---
title: "Use Certificate Rotation in Azure Operator Nexus"
description: Learn the process for using certificate rotation in Azure Operator Nexus.
author: rbhupatiraju 
ms.author: rbhupatiraju
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 3/31/2026
---


# Use certificate rotation in Azure Operator Nexus

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
TODO
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
TODO
```

### 3. Resync a single device (device scope)

Retry syncing the new certificates on all devices:

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

Sample response once resync has completed: *TODO replace with successful output*

```Azure CLI
{
  "endTime": "2026-03-17T12:32:12.8626707Z",
  "error": {
    "code": "ResyncFailed",
    "details": [
      {
        "code": "FabricRotatedGNMIProfileCreationFailed",
        "details": [],
        "message": "Failed executing OC raw config command to apply SSL profile for: CR1-TOR2. Response: Failure / Unknown",
        "target": "/subscriptions/89a70903-42a2-4ff6-b437-688a27893711/resourceGroups/samdavies/providers/Microsoft.ManagedNetworkFabric/networkDevices/fabrica6526f-CompRack1-TOR2"
      }
    ],
    "message": "Apply GNMI profile to devices failed for: /subscriptions/89a70903-42a2-4ff6-b437-688a27893711/resourceGroups/samdavies/providers/Microsoft.ManagedNetworkFabric/networkDevices/fabrica6526f-CompRack1-TOR2"
  },
  "id": "/subscriptions/89a70903-42a2-4ff6-b437-688a27893711/providers/Microsoft.ManagedNetworkFabric/locations/UKSOUTH/operationStatuses/e7c426d7-aa3e-415a-9bf4-2ef845f043ec*DDE1CF80DC541EE3DCA3B0EA9F9358E1BC3F96C837B353ADF01A88F1B9B58FAB",
  "name": "e7c426d7-aa3e-415a-9bf4-2ef845f043ec*DDE1CF80DC541EE3DCA3B0EA9F9358E1BC3F96C837B353ADF01A88F1B9B58FAB",
  "resourceId": "/subscriptions/89a70903-42a2-4ff6-b437-688a27893711/resourceGroups/samdavies/providers/Microsoft.ManagedNetworkFabric/networkDevices/fabrica6526f-CompRack1-TOR2",
  "startTime": "2026-03-17T12:29:13.601236Z",
  "status": "Failed"
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