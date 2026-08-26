---
title: Volume error messages
description: Reference for the validation and resource status error messages returned for Azure Operator Nexus volume operations.
author: gpenning
ms.author: gpenning
ms.service: azure-operator-nexus
ms.topic: reference
ms.date: 06/24/2026
ms.custom: template-reference
---

# Volume error message reference

This article lists the error messages that you might encounter when you create, update (expand), or delete an Azure Operator Nexus **volume**. Use it to understand what each error means and how to resolve it.

Volume errors are returned through two channels:

- **Validation errors** are returned immediately when you submit the request. They're produced by admission validation and indicate that the request was rejected before any provisioning started. The operation completes with `provisioningState: Failed` and the error is surfaced to the Azure CLI (`az networkcloud volume`) when it polls the long-running operation.
- **Resource status errors** appear after the request is accepted, while the platform reconciles the resource. They're reported in the resource's `detailedStatusMessage` field and, for terminal failures, the `provisioningState` becomes `Failed`. Many asynchronous conditions are transient and the platform retries them automatically.

## Validation errors

These errors are returned immediately and the request is rejected. No resource is provisioned.

### Error Message Format

Validation errors include a stable error **code**, a customer-facing **message** with remediation guidance, and a **target** that identifies the property that caused the failure. For example:

```
The specified volume size (20971521 MiB) exceeds the maximum allowed size (20971520 MiB). Specify a sizeMiB value between 1 and 20971520. For more information, see https://aka.ms/operatornexus/storage-errors.
```

| Field | Description |
|-------|-------------|
| Code | A stable identifier for the error, such as `InvalidVolumeSize`. |
| Message | A human-readable description of what's wrong and how to fix it. |
| Target | The property path that failed validation, such as `properties.sizeMiB`. |

### Error Message List

### Volume create

| Error code | Message | Target | Cause and recommended action |
|------------|---------|--------|------------------------------|
| `InvalidVolumeSize` | The specified volume size (*N* MiB) is below the minimum allowed size (1 MiB). Specify a sizeMiB value between 1 and 20971520. | `properties.sizeMiB` | The requested `sizeMiB` is less than the minimum. Specify a value between 1 and 20971520 MiB. |
| `InvalidVolumeSize` | The specified volume size (*N* MiB) exceeds the maximum allowed size (20971520 MiB). Specify a sizeMiB value between 1 and 20971520. | `properties.sizeMiB` | The requested `sizeMiB` is greater than the 20 TiB maximum. Specify a value between 1 and 20971520 MiB. |

### Volume update (expand)

| Error code | Message | Target | Cause and recommended action |
|------------|---------|--------|------------------------------|
| `VolumeShrinkNotAllowed` | Volume size cannot be decreased from *old* MiB to *new* MiB. Specify a size greater than or equal to the current size (*old* MiB). | `properties.sizeMiB` | You requested a smaller `sizeMiB` than the current size. Volumes can only be expanded. Specify a size greater than or equal to the current size. |
| `InvalidVolumeSize` | The specified volume size (*N* MiB) is below the minimum allowed size (1 MiB). Specify a sizeMiB value between 1 and 20971520. | `properties.sizeMiB` | The requested `sizeMiB` is less than the minimum. Specify a value between 1 and 20971520 MiB. |
| `InvalidVolumeSize` | The specified volume size (*N* MiB) exceeds the maximum allowed size (20971520 MiB). Specify a sizeMiB value between 1 and 20971520. | `properties.sizeMiB` | The requested `sizeMiB` is greater than the maximum. Specify a value between 1 and 20971520 MiB. |
| `StorageApplianceIdImmutable` | The storage appliance ID cannot be removed after it has been set. | `properties.storageApplianceId` | You attempted to clear `storageApplianceId` after it was set. The field is immutable after creation; leave it unchanged. |
| `StorageApplianceIdImmutable` | The storage appliance ID cannot be changed after it has been set. | `properties.storageApplianceId` | You attempted to change `storageApplianceId` to a different appliance. The field is immutable after creation; leave it unchanged. |
| `StorageApplianceIdImmutable` | The storage appliance ID does not match the currently assigned appliance. | `properties.storageApplianceId` | The supplied `storageApplianceId` doesn't match the appliance the volume is already assigned to. Use the appliance the volume was created on. |

### Volume delete

The delete operation performs no additional validation, so no validation errors are returned.

### Internal validation error

| Error code | Message | Cause and recommended action |
|------------|---------|------------------------------|
| `InternalValidationError` | An unexpected validation error occurred. If the issue persists, contact support. | An unexpected internal error occurred while validating the request. Retry the operation; if it continues to fail, contact support. |

## Resource Status Errors

These errors appear in `detailedStatusMessage` after the request is accepted, during reconciliation. Transient conditions are retried automatically.

### Error Message Format

Resource status errors are written to `detailedStatusMessage` in a consistent format:

```
<ErrorCode>; <description>; https://aka.ms/operatornexus/storage-errors
```

For example:

```
VolumeShrinkNotSupported; volumes cannot be reduced in size; https://aka.ms/operatornexus/storage-errors
```

When the description is `contact support if this persists`, the condition is typically a platform or connectivity issue rather than something you can fix by changing your request.

### Error Message List

| Error code | When it occurs | Recommended action |
|------------|----------------|--------------------|
| `VolumeSizeInvalid` | The requested `sizeMiB` is outside the supported range during create or resize (a secondary check beyond validation). | Specify a `sizeMiB` within the supported range and resubmit. |
| `VolumeShrinkNotSupported` | A resize request asked for a size smaller than the currently allocated size. | Volumes can't be reduced in size. Request a size greater than or equal to the current size. |
| `StorageApplianceNotResolved` | The storage appliance for the volume couldn't be resolved from the `storageApplianceId` or the volume's annotations. | Verify the referenced storage appliance exists and is healthy. Contact support if this persists. |
| `VolumeDefinitionFailed` | The platform couldn't define the underlying `PersistentVolume` or `PersistentVolumeClaim`, for example because of an invalid access mode or volume mode, or a storage appliance lookup failure. | Verify the volume specification is valid. Contact support if this persists. |
| `VolumeCreationFailed` | A fatal error occurred while creating the volume's `PersistentVolume` or `PersistentVolumeClaim`. | Contact support if this persists. |
| `VolumeResizeFailed` | A fatal error occurred while expanding the volume's `PersistentVolumeClaim`. | Contact support if this persists. |
| `VolumeDeletionFailed` | The platform couldn't delete the volume's `PersistentVolumeClaim`. | The operation is retried automatically. Contact support if this persists. |
| `VolumeSyncFailed` | Periodic reconciliation couldn't synchronize the volume with its underlying `PersistentVolumeClaim`. | The operation is retried automatically. Contact support if this persists. |
| `VolumeDataRefreshFailed` | The platform couldn't query the storage array for the volume's current allocated size, typically because of a connectivity issue. | The operation is retried automatically. Contact support if this persists. |

> [!NOTE]
> While a volume is expanding, the platform reports an informational status of `Volume Expansion In Progress`. This isn't an error; the volume returns to a succeeded state when the expansion completes.

## Related content

- [Storage appliance error messages](reference-storage-appliance-error-messages.md)
- [Near-edge Azure Operator Nexus storage appliance](reference-near-edge-storage.md)
- [Storage overview](concepts-storage.md)
