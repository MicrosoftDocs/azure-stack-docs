---
title: Storage appliance error messages
description: Reference for the validation and resource status error messages returned for Azure Local Multi-Rack Storage Appliance operations.
author: gpenning
ms.author: gpenning
ms.service: azure-local
ms.subservice: multi-rack
ms.topic: reference
ms.date: 06/24/2026
ms.custom: template-reference
---

# Storage appliance error message reference

This article lists the error messages that you might encounter when you manage an Azure Local Multi-Rack **storage appliance**. Use it to understand what each error means and how to resolve it.

Storage appliance errors appear after the request is accepted, while the platform reconciles the resource. They're reported in the resource's `detailedStatusMessage` field. Many asynchronous conditions are transient and the platform retries them automatically.

## Resource Status Errors

These errors appear in `detailedStatusMessage` after the request is accepted. Transient conditions are retried automatically.

### Error format
Resource status errors are written to `detailedStatusMessage` in a consistent format:

```
<ErrorCode>; <description>; https://aka.ms/azurelocal/multirack/storage-errors
```

For example:

```
ArrayConnectivityFailed; contact support if this persists; https://aka.ms/azurelocal/multirack/storage-errors
```

When the description is `contact support if this persists`, the condition is typically a platform, connectivity, or array-side issue rather than something you can fix by changing your request.

## Error lists

### Storage appliance onboard

| Error code | When it occurs | Recommended action |
|------------|----------------|--------------------|
| `ManagementServiceUnavailable` | The storage management service for the appliance isn't yet present or ready in the cluster. | Wait for reconciliation to retry. Contact support if this persists. |
| `TlsCertificateUpdateFailed` | The TLS certificate couldn't be retrieved from the certificate secret or applied to the array. | The operation is retried automatically. Contact support if this persists. |
| `ArrayConnectivityFailed` | The platform couldn't establish a management connection to the storage array (credential or connectivity issue). | Verify the appliance is powered on and reachable. Contact support if this persists. |
| `NetworkDataUnavailable` | The platform network data needed to configure storage couldn't be retrieved or isn't yet populated. | The operation is retried automatically. Contact support if this persists. |
| `StorageNetworkMissing` | The platform network data doesn't contain a `storage` network entry. | Contact support if this persists. |
| `StorageNetworkIncomplete` | The storage network configuration is incomplete. | Contact support if this persists. |
| `StorageNetworkMissingRequiredField` | The storage network is missing a required field (such as an IP range, prefix, or VLAN). | Contact support if this persists. |
| `NetworkConfigFailed` | The platform couldn't calculate or apply the array's network configuration (for example, an invalid subnet or VLAN). | Contact support if this persists. |
| `ArrayConfigFailed` | Day-1 array configuration failed (network, users, NTP, syslog, or proxy setup). | Contact support if this persists. |
| `StorageClassCreationFailed` | The Kubernetes storage class for the appliance couldn't be created, which blocks volume provisioning. | The operation is retried automatically. Contact support if this persists. |
| `ArrayDataRefreshFailed` | The platform couldn't query the array for capacity, serial, or firmware information after configuration. | The operation is retried automatically. Contact support if this persists. |

### Storage appliance update and actions

This covers errors that may occur when the Storage Appliance is being updated, for example enable/disable remote vendor management on a Pure device.

| Error code | When it occurs | Recommended action |
|------------|----------------|--------------------|
| `ActionRequestInvalid` | The requested action couldn't be processed because the request was malformed or invalid. | Verify the action request and resubmit. |
| `ActionExecutionFailed` | The requested action couldn't be completed (for example, the array rejected the request, or another action is already in progress). | Confirm no other action is running on the appliance, then retry. Contact support if this persists. |

> [!NOTE]
> The Enable and Disable Remote Vendor Management actions are rejected if the feature isn't supported on the appliance, if another action is already in progress on the same appliance, or if the appliance becomes unreachable (the action times out after 30 minutes). Only one action runs on an appliance at a time.

### Storage appliance normal operations (active)

| Error code | When it occurs | Recommended action |
|------------|----------------|--------------------|
| `StorageClassUnavailable` | The appliance's storage class was removed; the platform recreates it on the next successful reconcile. | No action needed unless the condition persists. Contact support if this persists. |
| `SnapshotClassUnavailable` | The appliance's volume snapshot class was removed; the platform recreates it. | No action needed unless the condition persists. Contact support if this persists. |
| `CredentialMigrationFailed` | A legacy credential migration for the appliance failed. | The operation is retried automatically. Contact support if this persists. |
| `CredentialReconcileFailed` | Reconciliation of the appliance's credentials failed. | The operation is retried automatically. Contact support if this persists. |
| `StorageMaintenanceFailed` | A periodic storage maintenance task failed (for example, volume cleanup or host group reconciliation). | The operation is retried automatically. Contact support if this persists. |
| `ArrayConnectivityFailed` | The platform lost its management connection to the storage array. | Verify the appliance is reachable. Contact support if this persists. |
| `ArrayDataRefreshFailed` | The platform couldn't refresh the array's capacity, serial, or firmware information. | The operation is retried automatically. Contact support if this persists. |
| `TlsCertificateUpdateFailed` | A rotated TLS certificate couldn't be applied to the array. | The operation is retried automatically. Contact support if this persists. |

### Storage appliance delete

| Error code | When it occurs | Recommended action |
|------------|----------------|--------------------|
| `StorageClassDeletionFailed` | The appliance's storage class couldn't be deleted. | The operation is retried automatically. Contact support if this persists. |
| `SnapshotClassDeletionFailed` | The appliance's volume snapshot class couldn't be deleted. | The operation is retried automatically. Contact support if this persists. |
| `ArrayCleanupFailed` | The array couldn't be deconfigured during decommissioning (for example, user removal, network teardown, or volume cleanup). | The operation is retried automatically. Contact support if this persists. |
