---
title: Monitor and troubleshoot SAN storage appliances for multi-rack deployments of Azure Local
description: Learn how to inspect SAN storage appliance status and capacity, monitor storage performance, and request support for multi-rack deployments of Azure Local.
author: perfectchaos
ms.author: chaoschhapi
ms.service: azure-local
ms.date: 10/13/2026
ms.topic: how-to
ms.subservice: multi-rack
---

# Monitor and troubleshoot SAN storage appliances for multi-rack deployments of Azure Local

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article describes how to inspect storage appliance status and capacity, monitor storage performance, and request assistance with storage issues.

For information about viewing Storage Appliance resources and platform-managed operations, see [Manage SAN storage appliances](multi-rack-manage-san-storage.md).

## Check appliance status and capacity

Review the Storage Appliance resource in Azure to check its provisioning state, operational status, detailed status message, and reported capacity.

To inspect these properties by using Azure CLI:

```azurecli
az networkcloud storageappliance show \
  --name "<storage-appliance-name>" \
  --resource-group "<resource-group>" \
  --subscription "<subscription-id>" \
  --query "{ProvisioningState:provisioningState,Status:detailedStatus,Message:detailedStatusMessage,CapacityGiB:capacity,UsedCapacityGiB:capacityUsed}"
```

The `capacity` and `capacityUsed` properties report total and used capacity in GiB. Monitor used capacity alongside workload growth to identify when usage is approaching total capacity. Contact Microsoft support if you need more capacity before available space is exhausted.

An appliance's reported status reflects the checks performed by Azure Local. It doesn't necessarily identify every hardware condition or storage data-path failure. If workloads can't provision or access storage, investigate the issue even if the appliance reports an available state.

## Monitor storage performance

In the Azure portal, open your multi-rack cluster and select **Metrics** under **Monitoring**. The following metrics report host-side storage activity:

| Metric | Description |
| --- | --- |
| Storage Read Bytes/Sec (Preview) | Number of bytes of data read per second from the SAN storage. |
| Storage Write Bytes/Sec (Preview) | Number of bytes of data written per second to the SAN storage. |
| Storage Read Operations/sec (Preview) | Number of read input/output operations per second performed by the SAN storage. |
| Storage Write Operations/sec (Preview) | Number of write input/output operations per second performed by the SAN storage. |

Filter or split the metrics by the **Node** and **Storage Endpoint** dimensions to distinguish activity by host and storage appliance.

For more information about using Azure Monitor metrics, see [Monitor multi-rack deployments with Azure Monitor metrics](multi-rack-monitor-cluster-with-metrics.md).

## Troubleshoot storage errors

Storage appliance errors can appear in the resource's `detailedStatusMessage` field after a request is accepted. Many transient conditions are retried automatically.

Use the [Storage appliance error-message reference](multi-rack-storage-appliance-error-messages.md) to interpret the error and follow its recommended action.

If an error persists, or storage access affects your workloads, contact Microsoft support.

## Appliance diagnostics

Diagnostic capabilities differ by storage vendor. NetApp and Dell PowerStore don't support the Storage Appliance `run-read` operation.

Contact the storage vendor for your appliance for support if you need appliance-level diagnostic assistance.

## Request support

When opening a Microsoft support request, include:

- The Storage Appliance resource ID.
- The reported status, error code, and detailed status message.
- When the issue started, including the time zone.
- The affected workloads and the impact on provisioning or storage access.
- Any relevant recent deployment, upgrade, or maintenance activity.
