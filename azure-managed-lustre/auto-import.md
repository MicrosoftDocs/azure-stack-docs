---
title: Use Azure Managed Lustre Auto-Import (Preview)
description: How to use the Auto-Import feature to copy data from your Azure Blob Storage container to an Azure Managed Lustre file system.
ms.topic: how-to
ms.date: 10/24/2025
author: pauljewellmsft
ms.author: brlepore
ms.reviewer: brianl

# Intent: As an IT Pro, I need to be able to auto-import files from my Azure Blob Storage container to an Azure Managed Lustre file system.
# Keyword: 
---
# Azure Managed Lustre Auto-Import (preview)

The Auto-Import feature in Azure Managed Lustre enables seamless synchronization of data from an Azure Blob Storage Container into an Azure Managed Lustre cluster. This functionality allows customers to treat Blob Storage as a cold tier and Azure Managed Lustre as a high-performance hot tier, automatically reflecting changes made in Blob Storage within the Lustre namespace.

## How the Auto-Import feature works

The Auto-Import feature in Azure Managed Lustre operates by continuously monitoring changes in the associated Azure Blob Storage Container via the [Azure Blob Storage Change Feed](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal) feature.

Based on the configured import policy, it updates the contents of the Azure Managed Lustre namespace to reflect these changes. The Auto-Import feature provides users with a seamless and automated data replication process.

Following creation, the Auto-Import process consists of two phases, Full Sync and Blob Sync:

1. The first phase is the Full Sync scan. The Full Sync scan compares the blob container namespace with the Azure Managed Lustre namespace and imports any new or modified files into the Azure Managed Lustre namespace.
1. The second phase is the Blob Sync scan. The Blob Sync scan begins after the Full Sync scan finishes. The Blob Sync scan continuously monitors Change Feed for updates, importing new or modified files and processing deletions into the Azure Managed Lustre namespace.

See [Change Feed documentation](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal#how-the-change-feed-works) for pricing details.

## Prerequisites

- An existing Azure Managed Lustre file system: You can create one by using the [Azure portal](/azure/azure-managed-lustre/create-file-system-portal), [Azure Resource Manager](/azure/azure-managed-lustre/create-file-system-resource-manager), or [Terraform](/azure/azure-managed-lustre/create-aml-file-system-terraform). To learn more about blob integration, see [Blob integration prerequisites](/azure/azure-managed-lustre/amlfs-prerequisites#blob-integration-prerequisites-optional).
- [Azure Blob Storage Change Feed](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal) **must be enabled** on the storage account associated with the Azure Managed Lustre file system.
  > [!NOTE]
  > Change Feed [doesn't support](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal#enable-and-disable-the-change-feed) storage accounts with the Hierarchical Namespace feature enabled.
- The Change Feed retention period *must* be set to seven days or greater. When you enable the blob change feed, either select **Keep all logs** *or* set **Delete change feed logs after (in days)** to seven or greater.
- Concurrent blob integration jobs aren't permitted. You must disable the Auto-Export feature and any manual import or export jobs before enabling the Auto-Import feature.

## Configuration

The Auto-Import feature is enabled on an existing Azure Managed Lustre file system that has an associated Blob Storage Container configured. Auto-Import is configured in the blob integration settings in the Azure portal.

To create a new Auto-Import job, follow these steps:

1. In the Azure portal, open your Azure Managed Lustre file system and select the **Blob integration** pane under **Settings**.
1. Select **+ Create new job**.
1. In the **Job Type** dropdown menu, select **Auto-Import**.
1. Enter a name for the import job in the **Job Name** field.
1. Select a value for the **Conflict resolution mode** field. This setting determines how the import job handles conflicts between existing files in the file system and files being imported. In this example, we select **Skip**. To learn more, see [Conflict resolution mode](/azure/azure-managed-lustre/blob-integration#conflict-resolution-mode).
1. To filter the data from Blob Storage, enter import prefixes. The Azure portal allows you to enter up to 10 prefixes. In this example, we specify the prefixes `/data` and `/logs`. To learn more, see [Import prefix](/azure/azure-managed-lustre/blob-integration#import-prefix).
1. Determine if you'd like to select **Enable deletions**, which enables propagation of deletions from Azure Blob Storage to Azure Managed Lustre.
1. After you configure the job, begin the import process by selecting **Start**.

## Monitoring and managing the Auto-Import feature

After the Auto-Import job is created, you can monitor its progress in the Azure portal.

The **Blob Integration** pane displays details of import activities in the **Recent jobs** section, including the status of recent jobs and metrics related to automatic synchronization.

To cancel the job that's in progress, select the **Cancel** link for that job in the **Recent jobs** table. The **Cancel** link is only available for the current Auto-Import job.

To view the metrics of an Auto-Import job, select the name of the job. The **Metrics** pane appears on the right side of the portal.

## Metrics

Metrics are grouped into two main categories, **Full Sync** and **Blob Sync**.

Full Sync statistics | Statistics for the initial Full Sync phase of auto-import
--- | ---
**Imported Files** | The number of files successfully imported to the Lustre namespace from the associated blob container during the initial Full Sync phase.
**Imported Directories** | The number of directories successfully imported to the Lustre namespace from the associated blob container during the initial Full Sync phase.
**Imported Symlinks** | The number of symbolic links successfully imported to the Lustre namespace from the associated blob container during the initial Full Sync phase.
**Preexisting Files** | The number of files with the same path and name that already exist in the Lustre namespace. Files already contain expected data and metadata as the corresponding blob.
**Preexisting Directories** | The number of directories encountered in the Lustre namespace during the initial Full Sync phase that already contain expected metadata as the corresponding blob.
**Preexisting Symlinks** | The number of symbolic links encountered in the Lustre namespace during the initial Full Sync phase that already contain expected metadata and target as the corresponding blob.
**Total Blobs Imported** | The number of blobs imported into the Lustre namespace from the blob container during the initial Full Sync phase. The number is a superset of imported files, directories, and symbolic links.
**Rate of Blob Import** | The per-second count of blobs imported from blob to Lustre during the initial Full Sync phase.
**Total Blobs Walked** | The number of blobs scanned during the Full Sync phase.
**Rate of Blob Walk** | The per-second count of blobs scanned during the Full Sync phase.
**Total Conflicts** | The number of encounters with blobs that have the same path and name of an existing object in the Lustre namespace, but that differ in terms of one or more areas, including type of object, data, and metadata.
**Total Errors** | The total number of errors that failed to import blobs to Lustre during the initial Full Sync phase. Select this link to go to the **Logging Container** page to view the logs associated with this Auto-Import job.

Blob sync statistics | Statistics about activity related to monitoring Change Feed
--- | ---
**Imported Files** | The number of files successfully imported to the Lustre namespace from the associated blob container after the initial Full Sync phase.
**Imported Directories** | The number of directories successfully imported to the Lustre namespace from the associated blob container after the initial Full Sync phase.
**Imported Symlinks** | The number of symbolic links successfully imported to the Lustre namespace from the associated blob container after the initial Full Sync phase.
**Preexisting Files** | The number of files with the same path and name that already exist in the Lustre namespace after the initial Full Sync phase that already contain expected data and metadata as the corresponding blob.
**Preexisting Directories** | The number of directories encountered in the Lustre namespace after the initial Full Sync phase that already contain expected metadata as the corresponding blob.
**Preexisting Symlinks** | The number of symbolic links encountered in the Lustre namespace after the initial Full Sync phase that already contain expected metadata and target as the corresponding blob.
**Total Blobs Imported** | The number of blobs imported into the Lustre namespace from the blob container after the initial Full Sync phase. The number is a superset of imported files, directories, and symbolic links.
**Rate of Blob Import** | Per-second count of blobs imported from blob to Lustre after the initial Full Sync phase.
**Deletions** | The number of files deleted during the blob Sync phase.
**Total Conflicts** | The number of encounters with blobs that have the same path and name of an existing object in the Lustre namespace after the initial Full Sync phase, but that differ in terms of one or more areas. For example, the type of object, data, and metadata.
**Total Errors** | The total number of import failures after the initial Full Sync phase. Select this link to go to the **Logging Container** page to view the logs associated with this Auto-Import job.
**Last Change Feed Event Consumed Time** | Timestamp of the last Change Feed event processed for this Auto-Import job.
**Last Time Fully Synchronized** | Most recent timestamp when all Change Feed events were processed for this Auto-Import job.

## Considerations and best practices

When you use Auto-Import, consider the following best practices to ensure it goes smoothly:

- It's important to review the behavior of the Change Feed feature, specifically the [specifications](/azure/storage/blobs/storage-blob-change-feed?tabs=azure-portal#specifications).
- You **must** set the Change Feed retention period to seven days or greater. When you enable the blob Change Feed, select either **Keep all logs** *or* set **Delete change feed logs after (in days)** to seven or greater.
- Auto-Import is dependent on the Change Feed. It's limited to the timeliness of events published to the Change Feed. The Change Feed currently suggests that events are published "within minutes."
- Auto-Import can typically import changes at a rate of 2,000 per second.
- You can't run multiple blob integration jobs at the same time. After Auto-Import is enabled, you can't create additional import or export jobs (either manual or auto).
- `lfs hsm_*` commands aren't supported during the use of Auto-Import as it can cause consistency issues between the blob and the Lustre file system.

Here are best practices when you enable deletions:

- Deletions are one way (blob > Lustre) and only apply going forward.
- The Auto-Import process always begins with a manual (Full Sync) scan. That scan doesn't compute a bidirectional map or attempt to detect if the "blob was deleted, file still exists in Lustre." *As a result, deletes that occurred before enablement aren't removed during the scan.*
- During the initial scan, changes (including deletes) are delayed. Any Change Feed events, including deletes, that occur while the initial scan runs are applied **after** the scan completes. Expect a temporary period where Lustre might still show files that were deleted in the blob container during the scan.
- Deletion behavior is explicitly tied to the selected conflict mode. The following table demonstrates the behavior for each mode when **Enable deletions** is enabled:

**File previously modified in Lustre?** | **Conflict resolution mode** | **Perform Deletion?**
--- | --- | ---
Yes | Overwrite if dirty | Yes.
Yes | Skip | No. File remains in Lustre.
No | Overwrite if dirty | Yes.
No | Skip | Yes.

## Related content

- Learn more about [Azure Blob Storage integration with Azure Managed Lustre file systems](/azure/azure-managed-lustre/blob-integration).
