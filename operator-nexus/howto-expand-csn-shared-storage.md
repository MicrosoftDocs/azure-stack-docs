---
title: Expand shared storage for an Azure Operator Nexus Cloud Services Network
description: Learn how to increase the capacity of the shared storage pool that backs nexus-shared persistent volumes.
author: matternst7258
ms.author: matthewernst
ms.service: azure-operator-nexus
ms.topic: how-to
ms.date: 09/17/2026
ms.custom: template-how-to
---

# Expand shared storage for an Azure Operator Nexus Cloud Services Network

The `nexus-shared` storage class uses a shared NFS storage pool managed by the Cloud Services Network (CSN). The pool is 1 TiB by default and can be expanded to a maximum of 20 TiB. Expansion increases the aggregate capacity available to all `nexus-shared` Persistent Volume Claims (PVCs) that use the CSN.

Expansion is an online operation and doesn't require a planned restart of the NFS service. Monitor affected workloads during the operation and don't perform concurrent storage appliance maintenance. Although the pool expands online, Azure Operator Nexus doesn't guarantee that workloads experience no change in I/O latency.

> [!IMPORTANT]
> A CSN shared storage pool can only be expanded. You can't reduce its capacity or move it to another storage appliance after it is created.

## Prerequisites

- Azure CLI with the latest `networkcloud` extension. For installation instructions, see [Install Azure CLI extensions](./howto-install-cli-extensions.md).
- The subscription ID, resource group, and name of the CSN.
- Sufficient free physical capacity on the storage appliance that hosts the CSN shared storage pool.
- A target size from the current allocated size through 20,971,520 MiB (20 TiB). The minimum pool size is 1,048,576 MiB (1 TiB).

## Check the current storage allocation

Set the variables for the CSN.

```azurecli
SUBSCRIPTION="<subscription-id>"
RESOURCE_GROUP="<resource-group>"
CSN_NAME="<cloud-services-network-name>"
```

Review the requested size, allocated size, status, status message, and backing volume.

```azurecli
az networkcloud cloudservicesnetwork show \
  --subscription "$SUBSCRIPTION" \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CSN_NAME" \
  --query "{requestedSizeMiB:storageOptions.sizeMiB, allocatedSizeMiB:storageStatus.sizeMiB, status:storageStatus.status, statusMessage:storageStatus.statusMessage, volumeId:storageStatus.volumeId}"
```

Use `storageStatus.sizeMiB` as the current allocated size. Select a target that is greater than or equal to this value and no more than 20,971,520 MiB.

## Expand the shared storage pool

The following example requests a total pool size of 2 TiB:

```azurecli
az networkcloud cloudservicesnetwork update \
  --subscription "$SUBSCRIPTION" \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CSN_NAME" \
  --storage-options "{sizeMiB:2097152}"
```

Specify the desired **total** pool size, not the amount to add. Always include `sizeMiB` when updating the storage options of a pool that has a custom size. Omitting a previously configured custom size isn't supported.

The request is asynchronous. During expansion, `storageStatus.status` reports `ExpandingVolume`.

## Verify the expansion

Run the following command until the status is `Available` and `allocatedSizeMiB` equals the requested size:

```azurecli
az networkcloud cloudservicesnetwork show \
  --subscription "$SUBSCRIPTION" \
  --resource-group "$RESOURCE_GROUP" \
  --name "$CSN_NAME" \
  --query "{requestedSizeMiB:storageOptions.sizeMiB, allocatedSizeMiB:storageStatus.sizeMiB, status:storageStatus.status, statusMessage:storageStatus.statusMessage, volumeId:storageStatus.volumeId}"
```

If the status reports `ExpansionFailed`, review `statusMessage`. Verify that the requested size is no smaller than the current allocation, doesn't exceed 20,971,520 MiB, and that the storage appliance has sufficient available capacity. If the failure persists, contact Microsoft Support.

Expanding the CSN pool doesn't change the requested capacity or consumption limit of an existing nexus-shared PVC. Update a PVC separately if its requested capacity must also increase.

## Related content

- [Azure Operator Nexus persistent storage for Kubernetes](./concepts-storage-kubernetes.md)
- [Multiple storage appliances](./concepts-storage-multiple-appliances.md)
