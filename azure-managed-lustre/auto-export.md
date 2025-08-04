---
title: Use Azure Managed Lustre Auto-Export (Preview)
description: How to use auto-export job to copy data from your Azure Managed Lustre file system to long-term storage in Azure Blob Storage.
ms.topic: how-to
ms.date: 06/06/2024
author: pauljewellmsft
ms.author: brlepore
ms.reviewer: brianl

# Intent: As an IT Pro, I need to be able to auto-export files from my Azure Managed Lustre file system to long-term Azure Blob Storage.
# Keyword: 
---
# Azure Managed Lustre auto-export (preview)

The Auto-Export feature for Azure Managed Lustre is a capability that automatically synchronizes changes in your Azure Managed Lustre file system with a linked Azure Blob Storage Container. This feature ensures that new and modified files in the file system are reflected in the associated Blob Storage Container without manual intervention. This streamlines data management and improves synchronization for long-term storage.

## How auto-export works

Auto-Export operates by continuously monitoring changes in the Azure Managed Lustre file system. Based on the configured export policy, it updates the contents of the associated Blob Storage Container to reflect these changes. This feature provides users with a seamless and automated data replication process.

### Configuration

Auto-Export is enabled on an existing Azure Managed Lustre file system that has an associated Blob Storage Container configured. Auto-Export is configured in the Blob Integration settings in the Azure portal.

To create a new Auto-Export job, follow these steps:

1. In the Azure portal, open your Azure Managed Lustre file system and select the **Blob integration** pane under **Settings**.
1. Select **+ Create new job**.
1. In the **Job Type** dropdown, select **Auto-Export**.
1. In the **File system path** field, you can enter a string to specify a directory path. All new or changed files in the file system under this path (prefix) are continually exported. Files are written to the blob container with the same file path (or prefix) that they have in the Lustre system. To avoid overwriting existing files in the blob container, ensure that the path of the file in your Lustre system doesn't overlap with the existing path of the file in the blob container unless your Lustre file was imported from that path in the Blob Container.

 :::image type="content" source="media/auto-export/auto-export-create-job.png" alt-text="Screenshot of the Blob integration page for Azure Managed Lustre showing Create import/export job." lightbox="media/auto-export/auto-export-create-job.png":::

### Auto-Export Behavior

Auto-Export handles different types of changes as follows:

- **New File Creation, New Directory, and File Content Changes**: Blob Integration identifies new files and directories and changed data and starts an export job automatically. Auto-Export ensures that the latest version of the file is transferred to Blob Storage.
- **Metadata Changes**: Changes such as renames, ownership updates, or permission adjustments are **not synchronized** currently.
- **Deletion**: When files, directories, or symlinks are deleted in the file system, they are **not removed** from the Blob Storage Container.

No more than one Blob Integration job (Manual Export, Auto Export, Import) can be run at a time.
Auto-Export is implemented as continuous export iterations. Upon completion of an iteration, Blob Integration scans the filesystem for any new files, directories, or content changes and starts a new iteration of an export job.
Logs created in your configured Logging container can help identify synchronization issues and understand the reasons behind failed operations.

## Monitoring and Managing Auto-Export

You can monitor Auto-Export activities and manage configurations using the Azure portal:

The Blob Integration pane displays details of export activities in the **Recent jobs** section, including the status of recent jobs and metrics related to automatic synchronization.

To cancel the job that's in progress, select the **Cancel** link for that job in the **Recent jobs** table. The **Cancel** link is only available for the current auto-export.

To view the metrics of an Auto-Export job, click on the **Name** of the job, and the **Metrics blade** appears on the side panel in the Portal.

:::image type="content" source="media/auto-export/auto-export-job-details.png" alt-text="Screenshot of the Blob integration page for Azure Managed Lustre showing Job details." lightbox="media/auto-export/auto-export-job-details.png":::

### Auto-Export Job Monitoring

The Blob Integration pane displays details of export activities in the **Recent jobs** section, including the status of recent jobs and metrics related to automatic synchronization.
To cancel the job that's in progress, select the **Cancel** link for that job in the **Recent jobs** table. The **Cancel** link is only available for the current auto-export.
To view the metrics of an Auto-Export job, click on the **Name** of the job, and the **Metrics blade** appears on the side panel in the Portal.

### Metrics

Metrics are grouped into two main categories, *Overall* and *Current Iteration*.

:::row:::
   :::column span="":::
      **Overall Statistics**
   :::column-end:::
   :::column span="2":::
      **Statistics since enabling Auto-Export**
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      Total Files Exported
   :::column-end:::
   :::column span="2":::
      Count of files successfully copied to the associated Blob Container since enabling Auto-Export
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      Total MiB Exported
   :::column-end:::
   :::column span="2":::
      Aggregate file size (in MiB) successfully copied to the associated Blob Container since enabling Auto-Export
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      Iterations Completed
   :::column-end:::
   :::column span="2":::
      Count of times Blob Integration has identified new or changed data and initiated a new Export job
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      Last Successful Iteration
   :::column-end:::
   :::column span="2":::
      Finish timestamp  of the last iteration that successfully exported all data to the associated Blob Container at the time
   :::column-end:::
:::row-end:::

:::row:::
   :::column span="":::
      **Current Iteration Statistics**
   :::column-end:::
   :::column span="2":::
      **Statistics about the current activity**
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      Files Discovered
   :::column-end:::
   :::column span="2":::
      Count of files that the Export job is currently exporting, including files already successfully copied to the associated Blob Container in this Iteration*
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      MiB Discovered
   :::column-end:::
   :::column span="2":::
      Aggregate file size (in MiB) that the Export job is currently exporting, including files already successfully copied to the associated Blob Container in this Iteration*
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      Files Exported
   :::column-end:::
   :::column span="2":::
      Count of files of new and changed data successfully copied to the associated Blob Container
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      MiB Exported
   :::column-end:::
   :::column span="2":::
      Aggregate file size (in MiB) of new and changed data successfully copied to the associated Blob Container
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      Files Failed
   :::column-end:::
   :::column span="2":::
      Total number of files that failed to copy during the current iteration. Click on this link to be taken to the Logging Container page to view the logs associated with this Auto-Export job.
   :::column-end:::
:::row-end:::
\* The metrics for the current ongoing iteration should be read as “so far.” For example, Files Discovered is the number of the files discovered for exporting at the moment of reporting. The next stats reporting cycle may show that more files are discovered.

## Considerations and Best Practices

While using Auto-Export, consider the following best practices to ensure smooth operation:

- **Conflict Management**: If a file is modified in both the file system and Blob Storage, there is a risk of overwrite. Use application-level coordination to prevent conflicting edits.
- **Disable Auto-Export Before Deletion**: Before deleting a file system or its Blob Integration, ensure that all queued updates are synchronized. Verify that the **Last Successful Iteration Time** is recent and the **Files Failed** metric is zero to avoid data loss. Then, disable Auto-Export.

## Next step

- Learn more about [Azure Blob Storage integration with Azure Managed Lustre file systems](blob-integration.md).
