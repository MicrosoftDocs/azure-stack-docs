---
title: "Use Certificate Rotation in Azure Operator Nexus"
description: Learn the process for using certificate rotation in Azure Operator Nexus.
author: rbhupatiraju-ms
ms.author: rbhupatiraju
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

### Rotate certificates across the fabric

Start a fabric-scoped rotation across all supported devices:

```Azure CLI
az networkfabric fabric rotate-certificate --resource-group <resource-group-name> --resource-name <fabric-name>
```

Sample response:
```json
{
  "endTime": "2026-04-22T09:58:29.5174661Z",
  "id": "/subscriptions/1234abcd-0000-1234-5678-abcdef123456/providers/Microsoft.ManagedNetworkFabric/locations/WESTUS3/operationStatuses/a1b2c3d4-5678-9abc-def0-123456789abc*A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2",
  "name": "a1b2c3d4-5678-9abc-def0-123456789abc*A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2",
  "resourceId": "/subscriptions/1234abcd-0000-1234-5678-abcdef123456/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkFabrics/example-fabric",
  "startTime": "2026-04-22T09:40:13.3419824Z",
  "status": "Succeeded"
}
```

Rotation with `--no-wait` for asynchronous execution:
```Azure CLI
    az networkfabric fabric rotate-certificate --resource-group <resource-group-name> --resource-name <fabric-name> --no-wait
```
If you use `--no-wait` for any certificate rotation operation, check the status by running this command to query for provisioning state:
```Azure CLI
az networkfabric fabric show --resource-group <rg> --resource-name <fabric-name> --query "provisioningState" -o ts
```
The provisioning state is `Succeeded` when the rotation finishes.

### Resync certificates across the fabric

This operation brings back into sync network devices missed during a previous certificate rotation.
Retry syncing the new certificates on all devices:

```Azure CLI
az networkfabric fabric resync-certificate --resource-group <resource-group-name> --resource-name <fabric-name>
```

Sample response:

```json
{
  "endTime": "2026-04-22T10:24:12.6499675Z",
  "id": "/subscriptions/1234abcd-0000-1234-5678-abcdef123456/providers/Microsoft.ManagedNetworkFabric/locations/WESTUS3/operationStatuses/a1b2c3d4-5678-9abc-def0-123456789abc*A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2",
  "name": "a1b2c3d4-5678-9abc-def0-123456789abc*A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2",
  "resourceId": "/subscriptions/1234abcd-0000-1234-5678-abcdef123456/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkFabrics/example-fabric",
  "startTime": "2026-04-22T10:06:15.1423306Z",
  "status": "Succeeded"
}
```

Resync with `--no-wait` for asynchronous execution:

```Azure CLI
az networkfabric fabric resync-certificate --resource-group <resource-group-name> --resource-name <fabric-name> --no-wait
```

### Resync certificates on specific devices

```Azure CLI
az networkfabric device resync-certificate --resource-group <resource-group-name> --resource-name <device-name>
```

Sample response:
```json
{
  "endTime": "2026-04-22T10:31:03.7090686Z",
  "id": "/subscriptions/1234abcd-0000-1234-5678-abcdef123456/providers/Microsoft.ManagedNetworkFabric/locations/WESTUS3/operationStatuses/a1b2c3d4-5678-9abc-def0-123456789abc*A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2",
  "name": "a1b2c3d4-5678-9abc-def0-123456789abc*A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2C3D4E5F6A1B2",
  "resourceId": "/subscriptions/1234abcd-0000-1234-5678-abcdef123456/resourceGroups/example-rg/providers/Microsoft.ManagedNetworkFabric/networkDevices/example-device",
  "startTime": "2026-04-22T10:27:43.7739143Z",
  "status": "Succeeded"
}
```

Resync with `--no-wait` for asynchronous execution:
```Azure CLI
az networkfabric device resync-certificate --resource-group <resource-group-name> --resource-name <device-name> --no-wait
```

### Get device certificate rotation status

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
