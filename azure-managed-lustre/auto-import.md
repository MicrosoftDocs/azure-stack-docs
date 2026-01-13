---
title: Use Azure Managed Lustre Auto Import (Preview)
description: How to use the auto-import feature to copy data from your Azure Blob Storage container to an Azure Managed Lustre file system.
ms.topic: how-to
ms.date: 10/24/2025
author: pauljewellmsft
ms.author: brlepore
ms.reviewer: brianl

# Intent: As an IT Pro, I need to be able to auto import files from my Azure Blob Storage container to an Azure Managed Lustre file system.
# Keyword: 
---
# Use the auto-import feature in Azure Managed Lustre (preview)

The auto-import feature in Azure Managed Lustre enables seamless synchronization of data from an Azure Blob Storage container into an Azure Managed Lustre cluster. This functionality allows customers to treat Blob Storage as a cold tier and Azure Managed Lustre as a high-performance hot tier. This method automatically reflects changes made in Blob Storage within the Lustre namespace.

## How the auto-import feature works

The auto-import feature in Azure Managed Lustre operates by continuously monitoring changes in the associated Azure Blob Storage container via the [Azure Blob Storage change feed](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal) feature.

Based on the configured import policy, it updates the contents of the Azure Managed Lustre namespace to reflect these changes. The auto-import feature provides users with a seamless and automated data replication process.

Following creation, the auto-import process consists of two phases, full sync and blob sync:

1. The first phase is the full sync scan. The full sync scan compares the blob container namespace with the Azure Managed Lustre namespace and imports any new or modified files into the Azure Managed Lustre namespace.

1. The second phase is the blob sync scan. The blob sync scan begins after the full sync scan finishes. The blob sync scan continuously monitors change feed for updates, importing new or modified files and processing deletions into the Azure Managed Lustre namespace.

See [change feed documentation](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal#how-the-change-feed-works) for pricing details.

## Prerequisites

- An existing Azure Managed Lustre file system: You can create one by using the [Azure portal](/azure/azure-managed-lustre/create-file-system-portal), [Azure Resource Manager](/azure/azure-managed-lustre/create-file-system-resource-manager), or [Terraform](/azure/azure-managed-lustre/create-aml-file-system-terraform). To learn more about blob integration, see [Blob integration prerequisites](/azure/azure-managed-lustre/amlfs-prerequisites#blob-integration-prerequisites-optional).
- [Azure Blob Storage change feed](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal) **must be enabled** on the storage account associated with the Azure Managed Lustre file system.
  > [!NOTE]
  > Change feed [doesn't support](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal#enable-and-disable-the-change-feed) storage accounts with the hierarchical namespace feature enabled.
- The change feed retention period *must* be set to seven days or greater. When you enable the blob change feed, either select **Keep all logs** *or* set **Delete change feed logs after (in days)** to seven or greater.
- Concurrent blob integration jobs aren't permitted. You must disable the auto-export feature and any manual import or export jobs before enabling the auto-import feature.

## Configuration

The auto-import feature is enabled on an existing Azure Managed Lustre file system that has an associated Blob Storage container configured. Auto import is configured in the blob integration settings in the Azure portal.

To create a new auto-import job, follow these steps:

1. In the Azure portal, open your Azure Managed Lustre file system and select the **Blob integration** pane under **Settings**.

1. Select **+ Create new job**.

1. In the **Job Type** dropdown menu, select **Auto-Import**.

1. Enter a name for the import job in the **Job Name** field.

1. Select a value for the **Conflict resolution mode** field. This setting determines how the import job handles conflicts between existing files in the file system and files being imported. In this example, we select **Skip**. To learn more, see [Conflict resolution mode](/azure/azure-managed-lustre/blob-integration#conflict-resolution-mode).

1. To filter the data from Blob Storage, enter import prefixes. The Azure portal allows you to enter up to 10 prefixes. In this example, we specify the prefixes `/data` and `/logs`. To learn more, see [Import prefix](/azure/azure-managed-lustre/blob-integration#import-prefix).

1. Determine if you want to select **Enable deletions**, which enables propagation of deletions from Azure Blob Storage to Azure Managed Lustre.

1. After you configure the job, begin the import process by selecting **Start**.

## Monitoring and managing the auto-import feature

After the auto-import job is created, you can monitor its progress in the Azure portal.

The **Blob integration** pane displays details of import activities in the **Recent jobs** section, including the status of recent jobs and metrics related to automatic synchronization.

To cancel the job that's in progress, select the **Cancel** link for that job in the **Recent jobs** table. The **Cancel** link is available only for the current auto-import job.

To view the metrics of an auto-import job, select the name of the job. The **Metrics** pane appears on the right side of the portal.

## Metrics

Metrics are grouped into two main categories, **Full sync** and **Blob sync**.

Full sync statistics | Statistics for the initial full sync phase of auto import
--- | ---
**Imported Files** | Count of files successfully imported to the Lustre namespace from the associated blob container during the initial full sync phase.
**Imported Directories** | Count of directories successfully imported to the Lustre namespace from the associated blob container during the initial full sync phase.
**Imported Symlinks** | Count of symbolic links successfully imported to the Lustre namespace from the associated blob container during the initial full sync phase.
**Preexisting Files** | Count of files with the same path and name that already exist in the Lustre namespace. Files already contain expected data and metadata as the corresponding blob.
**Preexisting Directories** | Count of directories encountered in the Lustre namespace during the initial full sync phase that already contain expected metadata as the corresponding blob.
**Preexisting Symlinks** | Count of symbolic links encountered in the Lustre namespace during the initial full sync phase that already contain expected metadata and target as the corresponding blob.
**Total Blobs Imported** | Count of blobs imported into the Lustre namespace from the blob container during the initial full sync phase. The number is a superset of imported files, directories, and symbolic links.
**Rate of Blob Import** | The per-second count of blobs imported from blob to Lustre during the initial full sync phase.
**Total Blobs Walked** | Count of blobs scanned during the full sync phase.
**Rate of Blob Walk** | The per-second count of blobs scanned during the full sync phase.
**Total Conflicts** | Count of encounters with blobs that have the same path and name of an existing object in the Lustre namespace, but that differ in terms of one or more areas, including type of object, data, and metadata.
**Total Errors** | The total number of errors that failed to import blobs to the Lustre file system during the initial full sync phase. Select this link to go to the **Logging Container** page to view the logs associated with this auto-import job.

Blob sync statistics | Statistics about activity related to monitoring the change feed
--- | ---
**Imported Files** | Count of files successfully imported to the Lustre namespace from the associated blob container after the initial full sync phase.
**Imported Directories** | Count of directories successfully imported to the Lustre namespace from the associated blob container after the initial full sync phase.
**Imported Symlinks** | Count of symbolic links successfully imported to the Lustre namespace from the associated blob container after the initial full sync phase.
**Preexisting Files** | Count of files with the same path and name that already exist in the Lustre namespace after the initial full sync phase that already contain expected data and metadata as the corresponding blob.
**Preexisting Directories** | Count of directories encountered in the Lustre namespace after the initial full sync phase that already contain expected metadata as the corresponding blob.
**Preexisting Symlinks** | Count of symbolic links encountered in the Lustre namespace after the initial full sync phase that already contain expected metadata and target as the corresponding blob.
**Total Blobs Imported** | Count of blobs imported into the Lustre namespace from the blob container after the initial full sync phase. The number is a superset of imported files, directories, and symbolic links.
**Rate of Blob Import** | Per-second count of blobs imported from blob to the Lustre file system after the initial full sync phase.
**Deletions** | Count of files deleted during the blob Sync phase.
**Total Conflicts** | Count of encounters with blobs that have the same path and name of an existing object in the Lustre namespace after the initial full sync phase, but that differ in terms of one or more areas. For example, the type of object, data, and metadata.
**Total Errors** | The total number of import failures after the initial full sync phase. Select this link to go to the **Logging Container** page to view the logs associated with this auto-import job.
**Last Change Feed Event Consumed Time** | Time stamp of the last change feed event processed for this auto-import job.
**Last Time Fully Synchronized** | Most recent time stamp when all change feed events were processed for this auto-import job.

## Considerations and best practices

When you use auto import, consider the following best practices to ensure smooth operation:

- It's important to review the behavior of the change feed feature, specifically the [specifications](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal#specifications).
- You **must** set the change feed retention period to seven days or greater. When you enable the blob change feed, select either **Keep all logs** *or* set **Delete change feed logs after (in days)** to seven or greater.
- Auto import is dependent on the change feed. It's limited to the timeliness of events published to the change feed. The change feed currently suggests that events are published "within minutes."
- Auto import can typically import changes at a rate of 2,000 per second.
- You can't run multiple blob integration jobs at the same time. After auto import is enabled, you can't create more import or export jobs (either manual or automatic).
- `lfs hsm_*` commands aren't supported during the use of auto import as it can cause consistency issues between the blob and the Lustre file system.

Here are best practices for deletions:

- Deletions are one way (blob > Lustre) and only apply going forward.
- The auto-import process always begins with a manual (full sync) scan. That scan doesn't compute a bidirectional map or attempt to detect if the "blob was deleted, file still exists in Lustre." *As a result, deletions that occurred before enablement aren't removed during the scan.*
- During the initial scan, changes (including deletions) are delayed. Any change feed events, including deletions, that occur while the initial scan runs are applied **after** the scan completes. Expect a temporary period where the Lustre file system might still show files that were deleted in the blob container during the scan.
- Deletion behavior is explicitly tied to the selected conflict mode. The following table demonstrates the behavior for each mode when **Enable deletions** is enabled:

  **File previously modified in Lustre?** | **Conflict resolution mode** | **Perform Deletion?**
  --- | --- | ---
  Yes | Overwrite if dirty | Yes.
  Yes | Skip | No. File remains in Lustre.
  No | Overwrite if dirty | Yes.
  No | Skip | Yes.

## Related content

- Learn more about [Azure Blob Storage integration with Azure Managed Lustre file systems](/azure/azure-managed-lustre/blob-integration).
