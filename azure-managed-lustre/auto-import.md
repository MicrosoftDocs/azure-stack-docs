---
title: Use Azure Managed Lustre Auto-Import (Preview)
description: How to use auto-import job to copy data from your Azure Blob storage to Azure Managed Lustre file system.
ms.topic: how-to
ms.date: 10/24/2025
author: pauljewellmsft
ms.author: brlepore
ms.reviewer: brianl

# Intent: As an IT Pro, I need to be able to auto-import files from my Azure Blob storage to Azure Managed Lustre file system.
# Keyword: 
---
# Azure Managed Lustre auto-import (preview)

The Auto-Import feature in Azure Managed Lustre (AMLFS) enables seamless synchronization of data from an Azure Blob Storage Container into an AMLFS cluster. This functionality allows customers to treat Blob as a cold tier and AMLFS as a high-performance hot tier, automatically reflecting changes made in Blob within the Lustre namespace.

## How auto-import works

The Auto-Import feature in Azure Managed Lustre (AMLFS) operates by continuously monitoring changes in the associated Azure Blob Storage Container via the [Azure Blob Storage Change Feed](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal).

Based on the configured import policy, it updates the contents of the AMLFS namespace to reflect these changes. This provides users with a seamless and automated data replication process.

Following creation, the Auto-Import process consists of two phases, Full Sync and Blob Sync:

1. The first phase is the Full Sync scan. Full Sync compares the Blob Container namespace with the AMLFS namespace and imports any new or modified files into the AMLFS namespace.
1. The second phase is the Blob Sync scan. The Blob Sync scan begins after the Full Sync completes. Blob Sync continuously monitors the Change Feed for updates, importing new or modified files and processing deletions into the AMLFS namespace.

See [Change Feed documentation](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal#how-the-change-feed-works) for pricing details.

## Prerequisites

- Existing Azure Managed Lustre file system - create one using the [Azure portal](/azure/azure-managed-lustre/create-file-system-portal), [Azure Resource Manager](/azure/azure-managed-lustre/create-file-system-resource-manager), or [Terraform](/azure/azure-managed-lustre/create-aml-file-system-terraform). To learn more about blob integration, see [Blob integration prerequisites](/azure/azure-managed-lustre/amlfs-prerequisites#blob-integration-prerequisites-optional).
- [Azure Blob Storage Change Feed](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal) **must be enabled** on the Storage Account associated with the AMLFS file system. **NOTE**: Change Feed [does not support](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal#enable-and-disable-the-change-feed) Storage Accounts with a Hierarchical Namespace (HNS) enabled.
  - Change Feed retention period MUST be set to 7 days or greater. When enabling the blob change feed, select to either: **Keep all logs** OR set **Delete change feed logs after (in days)** to 7 or greater.
- Concurrent Blob Integration jobs are not permitted. It is necessary to disable Auto-Export prior to enabling Auto-Import.

## Configuration

Auto-Import is enabled on an existing Azure Managed Lustre file system that has an associated Blob Storage Container configured. Auto-Import is configured in the Blob Integration settings in the Azure portal.

To create a new Auto-Export job, follow these steps:

1. In the Azure portal, open your Azure Managed Lustre file system and select the **Blob integration** pane under **Settings**.
1. Select **+ Create new job**.
1. In the **Job Type** dropdown, select **Auto-Import**.
1. Enter a name for the import job in the **Job Name** field.
1. Choose a value for the **Conflict resolution mode** field. This setting determines how the import job handles conflicts between existing files in the file system and files being imported. In this example, we select **Skip**. To learn more, see [Conflict resolution mode](/azure/azure-managed-lustre/blob-integration#conflict-resolution-mode).
1. Enter import prefixes to filter the data imported from Blob Storage. Azure portal allows you to enter up to 10 prefixes. In this example, we specify the prefixes */data* and */logs*. To learn more, see [Import prefix](/azure/azure-managed-lustre/blob-integration#import-prefix).
1. Determine if you’d like to **Enable deletions** which enables propagation of deletions from Azure Blob Storage to Azure Managed Lustre.
1. Once the job is configured, select **Start** to begin the import process.

## Monitoring and Managing Auto-Import

After the auto-import job is created, you can monitor its progress in the Azure portal.

The **Blob Integration** pane displays details of import activities in the **Recent jobs** section, including the status of recent jobs and metrics related to automatic synchronization.

To cancel the job that's in progress, select the **Cancel** link for that job in the **Recent jobs** table. The **Cancel** link is only available for the current auto-import.

To view the metrics of an Auto-Import job, click on the **Name** of the job and the Metrics blade will appear on the right-hand side panel in the Portal.

## Metrics

Metrics are grouped into two main categories, *Full Sync* and *Blob Sync*.

**Full Sync Statistics** | **Statistics for the initial Full Sync phase of Auto-Import**
--- | ---
Imported Files | Count of files successfully imported to the Lustre namespace from the associated Blob Container during the initial Full Sync phase.
Imported Directories | Count of directories successfully imported to the Lustre namespace from the associated Blob Container during the initial Full Sync phase.
Imported Symlinks | Count of symlinks successfully imported to the Lustre namespace from the associated Blob Container during the initial Full Sync phase.
Pre-existing Files | Count of files with the same path and name found to already exist in the Lustre namespace when attempted to be imported by the initial Full Sync phase that already have expected data and metadata as the corresponding Blob.
Pre-existing Directories | Count of directories encountered in the Lustre namespace during the initial Full Sync phase that already have expected metadata as the corresponding Blob.
Pre-existing Symlinks | Count of symbolic links encountered in the Lustre namespace during the initial Full Sync phase that already have expected metadata and target as the corresponding Blob.
Total Blobs Imported | Count of Blobs imported into the Lustre namespace from the Blob Container during the initial Full Sync phase. A superset of imported files, directories, and symlinks listed above.
Rate of Blob Import | Per-second count of Blobs imported from Blob to Lustre during the initial Full Sync phase
Total Blobs Walked | Count of Blobs scanned during the Full Sync phase
Rate of Blob Walk | Per-second count of Blobs scanned during the Full Sync phase
Total Conflicts | Count of encounters with Blobs that have the same path and name of an existing object in the Lustre namespace during the initial Full Sync phase, but that differ in terms of type of object, data, and/or metadata.
Total Errors | Total number of errors encountered, failing to import Blobs to Lustre, during the initial Full Sync phase. Click on this link to be taken to the Logging Container page to view the logs associated with this Auto-Import job.

**Blob Sync Statistics** | **Statistics about activity related to monitoring Change Feed**
--- | ---
Imported Files | Count of files successfully imported to the Lustre namespace from the associated Blob Container after the initial Full Sync phase
Imported Directories | Count of directories successfully imported to the Lustre namespace from the associated Blob Container after the initial Full Sync phase
Imported Symlinks | Count of symlinks successfully imported to the Lustre namespace from the associated Blob Container after the initial Full Sync phase
Pre-existing Files | Count of files with the same path and name found to already exist in the Lustre namespace after the initial Full Sync phase that already have expected data and metadata as the corresponding Blob.
Pre-existing Directories | Count of directories encountered in the Lustre namespace after the initial Full Sync phase that already have expected metadata as the corresponding Blob.
Pre-existing Symlinks | Count of symbolic links encountered in the Lustre namespace after the initial Full Sync phase that already have expected metadata and target as the corresponding Blob.
Total Blobs Imported | Count of Blobs imported into the Lustre namespace from the Blob Container after the initial Full Sync phase. A superset of imported files, directories, and symlinks listed above.
Rate of Blob Import | Per-second count of Blobs imported from Blob to Lustre after the initial Full Sync phase
Deletions | Count of files deleted during the Blob Sync phase
Total Conflicts | Count of encounters with Blobs that have the same path and name of an existing object in the Lustre namespace after the initial Full Sync phase, but that differ in terms of type of object, data, and/or metadata.
Total Errors | Total number of errors encountered, failing to import Blobs to Lustre, after the initial Full Sync phase. Click on this link to be taken to the Logging Container page to view the logs associated with this Auto-Import job.
Last Change Feed Event Consumed Time | Timestamp of the last Change Feed event processed for this Auto-Import job
Last Time Fully Synchronized | Most recent timestamp when all Change Feed events were processed for this Auto-Import job

## Considerations and Best Practices

While using Auto-Import, consider the following best practices to ensure smooth operation:

- It is highly recommended to review the behavior of the Change Feed feature, specifically the [specifications](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal#specifications).
- Change Feed retention period MUST be set to 7 days or greater. When enabling the blob change feed, select to either: **Keep all logs** OR set **Delete change feed logs after (in days)** to 7 or greater.
- Auto-Import is dependent on the Change Feed and is, thus, limited to the timeliness of events published to the Change Feed. The Change Feed currently suggests that events are published “within minutes”.
- Auto-Import can typically import changes at a rate of 2000 per second.
- No Blob Integration jobs can be run at the same time. Once Auto-Import is enabled, manual import and export jobs (both manual and auto) cannot be used.
- Lfs hsm_* commands are not supported during the use of Auto-Import.

Best practices for enabling Deletions:

- Deletions are one way (Blob ➜ Lustre) and only apply going forward.
- AutoImport always begins with a manual (full sync) scan. That scan does not compute a bidirectional map or attempt to detect “blob was deleted, file still exists in Lustre.” **Deletes that occurred before enablement therefore won’t be removed during the scan.**
- During the initial scan, changes (including deletes) are delayed. Any Change Feed events, including deletes, that occur while the initial scan runs are applied **after** the scan completes. Expect a temporary period where Lustre may still show files that were deleted in Blob during the scan.
- Deletion behavior is explicitly tied to the selected conflict mode. The table below demonstrates the behavior for each mode when “Enable deletions” is selected:

**Conflict resolution mode** | **Delete File?** | **Effect if encountered**
--- | --- | ---
Overwrite – If Dirty | Yes | File deleted from Lustre
Skip | No | File remains in Lustre

## Next Steps

- Learn more about [Azure Blob Storage integration with Azure Managed Lustre file systems](/blob-integration).
