---
title: Storage appliance error messages
description: Reference for the validation and resource status error messages returned for Azure Operator Nexus storage appliance operations.
author: gpenning
ms.author: gpenning
ms.service: azure-operator-nexus
ms.topic: reference
ms.date: 06/24/2026
ms.custom: template-reference
---

# Storage appliance error message reference

This article lists the error messages that you might encounter when you manage an Azure Operator Nexus **storage appliance** or run one of its actions. Use it to understand what each error means and how to resolve it.

Storage appliance errors are returned through two channels:

- **Validation errors** are returned immediately when you submit the request. Only the **Run Read Command** action performs synchronous validation; the request is rejected before execution starts. The operation completes with `provisioningState: Failed` and the error is surfaced to the Azure CLI (`az networkcloud storageappliance`) when it polls the long-running operation.
- **Resource status errors** appear after the request is accepted, while the platform reconciles the resource or runs the action. They're reported in the resource's `detailedStatusMessage` field (or the action's status). Many asynchronous conditions are transient and the platform retries them automatically.


## Validation Errors

### Error format
These errors include a stable error **code**, a customer-facing **message** with remediation guidance, and a **target** that identifies the property that caused the failure. For example:

```
The command 'ls' is not supported. Supported commands include: purearray, purevol, purehw, puredrive, and others. For the full list of supported commands, see https://aka.ms/operatornexus/storage-errors.
```

| Field | Description |
|-------|-------------|
| Code | A stable identifier for the error, such as `UnsupportedCommand`. |
| Message | A human-readable description of what's wrong and how to fix it. |
| Target | The property path that failed validation, such as `properties.command`. |

### Error list

The **Run Read Command** action validates the command and its arguments before execution. The following errors are returned immediately, and the action is rejected.

| Error code | Message | Target | Cause and recommended action |
|------------|---------|--------|------------------------------|
| `InvalidCommandName` | The command name is too long (*N* characters). The maximum allowed length is *max* characters. Shorten the command name and retry. | `properties.command` | Shorten the command name to within the maximum length. |
| `InvalidCommandName` | The command name '*cmd*' contains forbidden characters. Command names must not contain shell metacharacters. | `properties.command` | Remove shell metacharacters (such as `;`, `\|`, `&`, `` ` ``, `$`) from the command name. |
| `UnsupportedCommand` | The command '*cmd*' is not supported. Supported commands include: purearray, purevol, purehw, puredrive, and others. | `properties.command` | Use one of the supported read-only diagnostic commands. |
| `TooManyArguments` | Too many arguments specified (*N*). The maximum allowed is *max*. Reduce the number of arguments and retry. | `properties.arguments` | Reduce the number of arguments to within the maximum. |
| `TooManyArguments` | The total arguments length is too long (*N* characters). The maximum allowed total length is *max* characters. Reduce the total length of all arguments and retry. | `properties.arguments` | Reduce the combined length of all arguments. |
| `InvalidArgument` | Argument *N* is null. Remove null entries from the arguments array and retry. | `properties.arguments[N]` | Remove null entries from the arguments array. |
| `InvalidArgument` | Argument *N* is too long (*N* characters). The maximum allowed length per argument is *max* characters. Shorten the argument and retry. | `properties.arguments[N]` | Shorten the argument to within the per-argument maximum. |
| `InvalidArgument` | Argument *N* contains a non-printable character at position *pos* (code: *code*). Remove non-printable characters from arguments and retry. | `properties.arguments[N]` | Remove non-printable control characters from the argument. |
| `InvalidArgument` | Argument *N* contains a DEL character at position *pos*. Remove non-printable characters from arguments and retry. | `properties.arguments[N]` | Remove the DEL (ASCII 127) character from the argument. |
| `InvalidArgument` | Arguments *[indices]* for command '*cmd*' contain forbidden characters. Arguments must not contain shell metacharacters. | `properties.arguments` | Remove shell metacharacters from the listed arguments. |
| `InvalidArgument` | Arguments *[indices]* for command '*cmd*' contain dangerous patterns. Arguments must not contain path traversal or command substitution patterns. | `properties.arguments` | Remove path traversal (such as `../`) and command substitution patterns from the listed arguments. |
| `InternalValidationError` | An unexpected validation error occurred. If the issue persists, contact support. | | An unexpected internal error occurred during validation. Retry the action; contact support if it persists. |

For more information about supported commands, see [Storage appliance run-read commands](howto-storage-run-read.md).

## Resource Status Errors

These errors appear in `detailedStatusMessage` (or the action status) after the request is accepted. Transient conditions are retried automatically.

### Error format
Resource status errors are written to `detailedStatusMessage` in a consistent format:

```
<ErrorCode>; <description>; https://aka.ms/operatornexus/storage-errors
```

For example:

```
ArrayConnectivityFailed; contact support if this persists; https://aka.ms/operatornexus/storage-errors
```

When the description is `contact support if this persists`, the condition is typically a platform, connectivity, or array-side issue rather than something you can fix by changing your request.

### Error lists

### Storage appliance create and configure

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

## Related content

- [Volume error messages](reference-volume-error-messages.md)
- [Storage appliance run-read commands](howto-storage-run-read.md)
- [Near-edge Azure Operator Nexus storage appliance](reference-near-edge-storage.md)
