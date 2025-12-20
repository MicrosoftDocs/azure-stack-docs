---
title: Use Azure Managed Lustre Auto-Export (Preview)
description: Learn how to use an auto-export job to copy data from your Azure Managed Lustre file system to long-term storage in Azure Blob Storage.
ms.topic: how-to
ms.date: 06/06/2024
author: pauljewellmsft
ms.author: brlepore
ms.reviewer: brianl

# Intent: As an IT Pro, I need to be able to auto-export files from my Azure Managed Lustre file system to long-term Azure Blob Storage.
# Keyword: 
---
# Azure Managed Lustre Auto-Export (Preview)

The Auto-Export feature for Azure Managed Lustre is a capability that automatically synchronizes changes in your Azure Managed Lustre file system with a linked Azure Blob Storage Container. Using this feature can help ensure that new and modified files in the file system are reflected in the associated Blob Storage Container without manual intervention. This streamlines data management and improves synchronization for long-term storage.

## How Auto-Export works

Auto-Export operates by continuously monitoring changes in the Azure Managed Lustre file system. Based on the configured export policy, it updates the contents of the associated Blob Storage Container to reflect these changes. This feature provides users with a seamless and automated process for replicating data.

### Configuration

Auto-Export is enabled on an existing Azure Managed Lustre file system that has an associated Blob Storage Container configured. You can configure Auto-Export by using the **Blob Integration** settings in the Azure portal.

To create a new Auto-Export job, follow these steps:

1. In the Azure portal, open your Azure Managed Lustre file system and select the **Blob integration** pane under **Settings**.
1. Select **+ Create new job**.
1. In the **Job Type** dropdown, select **Auto-Export**.
1. In the **File system path** field, you can specify a directory path by entering a string.

All new or changed files in the file system under this path (prefix) are continually exported. Files are written to the blob container with the same file path (or prefix) that they have in the Lustre system. To avoid overwriting existing files in the blob container, ensure that the path of the file in your Lustre system doesn't overlap with the existing path of the file in the blob container. (The only exception is if your Lustre file was imported from that path in the blob container.)

 :::image type="content" source="media/auto-export/auto-export-create-job.png" alt-text="Screenshot of the blob integration page for Azure Managed Lustre that shows how to create an import/export job." lightbox="media/auto-export/auto-export-create-job.png":::

### Auto-Export behavior

Here's how Auto-Export handles different types of changes:

- New file creation, new directory, and file content changes: The blob integration process identifies new files and directories and data that changed. It starts an export job automatically. Auto-Export ensures that the latest version of the file is transferred to Blob Storage.
- Metadata changes: Changes such as renames, ownership updates, or permission adjustments are currently *not synchronized*.
- Deletion: When files, directories, or symbolic links are deleted in the file system, they are *not removed* from the Blob Storage container.

No more than one blob integration job (like Manual Export, Auto Export, and Import) can run at a time.

Auto-Export works via continuous export iterations. When an iteration finishes, the blob integration process scans the filesystem for any new files, directories, or content changes. It starts a new iteration of an export job.

Logs that you create in your configured logging container can help identify synchronization issues and help you understand the reasons why operations fail.

## Monitoring and managing auto-export

You can monitor Auto-Export activities and manage configurations by using the Azure portal:

The **Blob Integration** pane displays details of export activities in the **Recent jobs** section, including the status of recent jobs and metrics related to automatic synchronization.

To cancel an in-process job, select the **Cancel** link for that job in the **Recent jobs** table. The **Cancel** link is only available for the current job.

To view the metrics of an Auto-Export job, select the **Name** of the job. The **Metrics blade** appears on the side panel in the portal.

:::image type="content" source="media/auto-export/auto-export-job-details.png" alt-text="Screenshot that shows the Blob integration page with job details." lightbox="media/auto-export/auto-export-job-details.png":::

### Auto-Export job monitoring

The **Blob Integration** pane displays details of export activities in the **Recent jobs** section, including the status of recent jobs and metrics related to automatic synchronization.

To cancel the job that's in progress, select the **Cancel** link for that job in the **Recent jobs** table. The **Cancel** link is only available for the current job.

To view the metrics of an Auto-Export job, select the **Name** of the job. The **Metrics** pane appears on the side panel in the portal.

### Metrics

In the portal, metrics are grouped into two main categories: **Overall** and **Current Iteration**.

:::row:::
   :::column span="":::
      **Overall statistics**
   :::column-end:::
   :::column span="2":::
      **Statistics after enabling Auto-Export**
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      **Total Files Exported**
   :::column-end:::
   :::column span="2":::
      The number of files successfully copied to the associated blob container after enabling Auto-Export.
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      Total MiB Exported
   :::column-end:::
   :::column span="2":::
      Aggregate file size (in MiB) successfully copied to the associated blob container after enabling Auto-Export.
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      **Iterations Completed**
   :::column-end:::
   :::column span="2":::
      The number of times the blob integration process identified new or changed data and initiated a new export job.
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      **Last Successful Iteration**
   :::column-end:::
   :::column span="2":::
      The finish timestamp of the last iteration that successfully exported all data to the associated blob container.
   :::column-end:::
:::row-end:::

:::row:::
   :::column span="":::
      **Current Iteration statistics**
   :::column-end:::
   :::column span="2":::
      **Statistics about the current activity**
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      **Files Discovered**
   :::column-end:::
   :::column span="2":::
      The number of files that the export job is currently exporting, including files already successfully copied to the associated blob container in this iteration.*
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      **MiB Discovered**
   :::column-end:::
   :::column span="2":::
      Aggregate file size (in MiB) that the export job is currently exporting, including files already successfully copied to the associated blob container in this iteration.*
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      **Files Exported**
   :::column-end:::
   :::column span="2":::
      The number of files in the new and changed data successfully copied to the associated blob container.
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      **MiB Exported**
   :::column-end:::
   :::column span="2":::
      The aggregate file size (in MiB) of new and changed data successfully copied to the associated blob container.
   :::column-end:::
:::row-end:::
:::row:::
   :::column span="":::
      **Files Failed**
   :::column-end:::
   :::column span="2":::
      Total number of files that failed to copy during the current iteration. Select this link to go to the **Logging Container** page to view the logs associated with this Auto-Export job.
   :::column-end:::
:::row-end:::
\* The metrics for the current ongoing iteration should be read as *so far*. For example, **Files Discovered** is the number of the files discovered for exporting at the moment of reporting. The next stats reporting cycle might show that more files are discovered.

## Considerations and best practices

When you use the Auto-Export feature, consider the following best practices to ensure it goes smoothly:

- **Conflict Management**: If a file is modified in both the file system and Blob Storage, there's a risk of overwrite. Use application-level coordination to prevent conflicting edits.
- **Disable Auto-Export Before Deletion**: Before deleting a file system or its blob integration process, ensure that all queued updates are synchronized. Verify that the **Last Successful Iteration Time** is recent and the **Files Failed** metric is zero to avoid data loss. Then, disable Auto-Export.

## Related content

- Learn more about [Azure Blob Storage integration with Azure Managed Lustre file systems](blob-integration.md).
