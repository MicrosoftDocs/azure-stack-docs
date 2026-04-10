---
title: Create and Restore Data Disk Snapshots of Azure Local
description: Learn how to create snapshots from a data disk and restore a new disk from a snapshot on multi-rack deployments of Azure Local.
author: alkohli
ms.author: alkohli
ms.reviewer: dramasamy
ms.date: 03/11/2026
ms.topic: how-to
ms.subservice: multi-rack
#customer intent: As an Azure Local administrator for multi-rack deployments, I want to create and restore data disk snapshots so that I can back up and recover data disks.
---

# Create and restore data disk snapshots on Azure Local

Disk snapshots let you capture a point-in-time copy of a data disk so that you can recover data or quickly provision new disks from a known-good state. This article shows you how to create a snapshot from an existing data disk and restore a new disk from that snapshot on Azure Local.

> [!NOTE]
> This article covers data disk snapshots only. This release doesn't include OS disk snapshot and restore.

## Prerequisites

Before you begin, make sure you have the following prerequisites in place:

- A custom location for your Azure Local instance. The custom location also appears on the **Overview** page for Azure Local.
- A data disk to use as the source for creating a snapshot.

## Supported and unsupported data disk snapshot scenarios

- Only crash-consistent disk snapshots are supported.
- Live VM state (memory/CPU) and app-consistent snapshots aren't supported.
- Full VM snapshot with all disks in a single operation isn't supported. Snapshots are disk-level, not VM-level.

## Install or verify the Azure CLI extension

The `az stack-hci-vm` commands come from the `stack-hci-vm` Azure CLI extension.

1. Verify your Azure CLI version (the extension metadata requires Azure CLI core version 2.15.0 or later):

   ```azurecli
   az version
   ```

1. Install the extension (or update it if it's already installed):

   ```azurecli
   az extension add --name stack-hci-vm
   ```

1. Verify the extension is installed:

   ```azurecli
   az extension show --name stack-hci-vm
   ```

## Sign in and set subscription

Before running any commands, sign in to Azure and select the subscription that contains your Azure Local resources.

1. Sign in:

   ```azurecli
   az login --use-device-code
   ```

1. Set your subscription:

   ```azurecli
   az account set --subscription <Subscription ID>
   ```

## Create a snapshot from a data disk

Use `az stack-hci-vm snapshot create` to create a snapshot from a source disk.

```azurecli
az stack-hci-vm snapshot create --resource-group <resource-group> --custom-location <custom-location-arm-id> --location <location> --name <snapshot-name> --source-resource-id </subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.AzureStackHCI/virtualHardDisks/{diskName}>
```

## List existing snapshots

To view snapshots in a specific resource group, run the following command:

```azurecli
az stack-hci-vm snapshot list --resource-group <resource-group>
```

To list snapshots in the subscription, run the following command:

```azurecli
az stack-hci-vm snapshot list
```

## View snapshot details

To view the properties of a specific snapshot, run the following command:

```azurecli
az stack-hci-vm snapshot show --resource-group <resource-group> --name <snapshot-name>
```

Here is an example output:

```bash
{
  "extendedLocation": {
    "name": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/app-snapshots-HostedResources/providers/Microsoft.ExtendedLocation/customLocations/app-snapshots-cstm-loc",
    "type": "CustomLocation"
  },
  "id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/app-snapshots/providers/Microsoft.AzureStackHCI/snapshots/staticweb01",
  "location": "eastus",
  "name": "staticweb01",
  "properties": {
    "creationData": {
      "createOption": "Copy",
      "sourceResourceId": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/app-snapshots/providers/Microsoft.AzureStackHCI/virtualHardDisks/staticweb01-osdisk"
    },
    "provisioningState": "Succeeded"
  },
  "systemData": {
    "createdAt": "2026-02-24T23:13:07.6240709Z",
    "createdBy": "user@contoso.com",
    "createdByType": "User",
    "lastModifiedAt": "2026-02-26T18:58:48.0421777Z",
    "lastModifiedBy": "user@contoso.com",
    "lastModifiedByType": "User"
  },
  "tags": {
    "test": "copilot-tag"
  },
  "type": "microsoft.azurestackhci/snapshots"
}
```

## Update snapshot tags

After a snapshot is created, only its tags can be updated. Use tags to organize and categorize your snapshots.

```azurecli
az stack-hci-vm snapshot update --resource-group <resource-group> --name <snapshot-name> --tags <key>=<value> <key>=<value>
```

## Restore a new data disk from a snapshot

To restore a disk from a snapshot, create a new disk by specifying the snapshot ARM ID in `--source-resource-id`.

> [!IMPORTANT]
> Due to a known issue, you must include the `--size-gb` parameter when restoring a disk from a snapshot, even though the parameter is listed as optional. The value must be equal to or greater than the original snapshot size. If `--size-gb` is omitted, the disk creation could fail.


To determine the minimum size in GB, query the snapshot's `diskSizeBytes` property and round up:

```azurecli
az stack-hci-vm snapshot show --name <snapshot-name> --resource-group <resource-group> --query "properties.diskSizeBytes" -o tsv
```

Then convert bytes to GB (round up to the nearest whole number). For example, if the snapshot reports `30,000,000,000` bytes (~28 GB), use `--size-gb 28` or larger.

To restore a disk from a snapshot, run the following command:

```azurecli
az stack-hci-vm disk create --resource-group <resource-group> --custom-location <custom-location-arm-id> --location <location> --name <new-disk-name> --source-resource-id </subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.AzureStackHCI/snapshots/{snapshotName}> --size-gb <size-in-gb>
```

## Validate the restored disk

After the disk restore completes, verify that the new disk was created successfully and is available in your resource group.

```azurecli
az stack-hci-vm disk show --resource-group <resource-group> --name <new-disk-name>
```

You can also list disks in the resource group:

```azurecli
az stack-hci-vm disk list --resource-group <resource-group>
```

## Clean up resources

If you no longer need a snapshot, you can delete it to free up resources. Deleting a snapshot doesn't affect any disks that were already restored from it.

```azurecli
az stack-hci-vm snapshot delete --resource-group <resource-group> --name <snapshot-name>
```

<!--## Related content

- [Troubleshoot Azure Local VM issues]()-->
