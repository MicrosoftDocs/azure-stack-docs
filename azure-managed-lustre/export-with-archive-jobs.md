---
title: Use manual export (archive) jobs to export data from Azure Managed Lustre
description: How to use a manual export (archive) job to copy data from your Azure Managed Lustre file system to long-term storage in Azure Blob Storage.
ms.topic: how-to
ms.date: 06/28/2023
author: pauljewellmsft
ms.author: pauljewell
ms.lastreviewed: 02/23/2023
ms.reviewer: brianl

# Intent: As an IT Pro, I need to be able to export files from my Azure Managed Lustre file system to longterm Azure Blob Storage.
# Keyword: 
---

# Create a manual export (archive) job to export data from Azure Managed Lustre

This article describes how to copy data from your Azure Managed Lustre file system to long-term storage in Azure Blob Storage by creating a manual export (archive) job, and explains what is exported from the file system.

This export method is only available when you integrate Azure Blob Storage with your Azure Managed Lustre file system during file system creation. For more information, see [Azure Blob Storage integration](amlfs-overview.md#azure-blob-storage-integration). If you didn't integrate a blob container when you created the file system, use client filesystem commands to copy the data without creating a manual export (archive) job.

## Which files does a manual export (archive) job export?

When you export files from your Azure Managed Lustre system, not all of the files are copied into the blob container that you specified when you created the file system:

- Manual export (archive) jobs only copy files that are new or whose contents have been modified. If the file that you imported from the blob container during file system creation is unchanged, the manual export (archive) job doesn't export the file.
- Files with metadata changes only aren't exported. Metadata changes include: owner, permissions, extended attributes, and name changes (renamed).
- If you delete a file in the Azure Managed Lustre file system, the manual export (archive) job doesn't delete the file from the original source.

Archiving data is a manual process that you can do in the Azure portal or by using commands in the native Lustre client CLI. With both methods, you can monitor the state of the manual export (archive) job.

The following procedures tell how to:

- [Create a manual export (archive) job in the Azure portal](#create-a-manual-export-archive-job-in-the-azure-portal)
- [Monitor or cancel a manual export (archive) job in the Azure portal](#monitor-or-cancel-a-manual-export-archive-job-in-the-azure-portal)
- [Create a manual export (archive) job using commands in the native Lustre CLI](#create-manual-export-archive-job-using-the-native-lustre-client-cli)
- [Monitor archive state for a file using native Lustre CLI commands](#monitor-archive-state-using-the-native-lustre-client-cli)

## Create a manual export (archive) job in the Azure portal

To create a manual export (archive) job to export changed data from an Azure Managed Lustre file system in the Azure portal, do the following steps:

1. In the Azure portal, open your Azure Managed Lustre file system and navigate to the **Blob integration** pane under **Settings**.
1. Select **+ Create new job**.

1. Specify what to export in the manual export (archive) job by entering a value in **File system path**.
   - All new or changed files whose filenames begin with this string in the Azure Managed Lustre file system are exported.
   - Files are written to the blob container with the same file path (or prefix) that they have in the Lustre system. If you want to avoid overwriting existing files in the blob container, make sure the path of the file in your Lustre system doesn't overlap the existing path of the file in the blob container.

The following screenshot shows the manual export (archive) job configuration settings in the Azure portal:

:::image type="content" source="./media/export-with-archive-jobs/create-archive-job-options.png" alt-text="Screenshot showing portal setup for creating a manual export (archive) job." lightbox="./media/export-with-archive-jobs/create-archive-job-options.png":::

## Monitor or cancel a manual export (archive) job in the Azure portal

You can monitor or cancel manual export (archive) jobs you created through blob integration with your Azure Managed Lustre file system in the Azure portal. The **Recent jobs** section of the **Blob integration** page shows the status of each job.

Only one archive job runs at a time. To cancel the job that's in progress, select the **Cancel** link for that job in the **Recent jobs** table. The **Cancel** link isn't available for a completed job.

## Create manual export (archive) job using the native Lustre client CLI

To create a manual export (archive) job to export changed data from an Azure Managed Lustre file system using native Lustre client CLI command, use one of the following commands:

- To export a single file, run a command similar to this one:

```bash
sudo lfs hsm_archive path/to/export/file
```

- To export all files in a directory, run a command similar to this one:

```bash
nohup find local/directory -type f -print0 | xargs -0 -n 1 sudo lfs hsm_archive &
```

## Monitor archive state using the native Lustre client CLI

To check on the status of a manual export (archive) job using the native Lustre client CLI, run the following command:

```bash
find path/to/export/file -type f -print0 | xargs -0 -n 1 -P 8 sudo lfs hsm_action | grep "ARCHIVE" | wc -l
```

Each file has an associated state, which indicates the relationship between the file data in the Lustre file system and the file data in Azure Blob Storage. To check the state of a file, run this command:

```bash
sudo lfs hsm_state path/to/export/file
```

The state command reports the state of changes to the file. The following table shows the possible file states:

|State|Description|
|-----|-----------|
|`(0x0000000d) released exists archived`|The file's contents (the data) exist in Blob Storage only. Only the metadata exists in Lustre. An export (archive) job doesn't update (overwrite) the file in Blob Storage.|
|`(0x00000009) exists archived`|An export (archive) job doesn't export the file to Blob Storage because Blob Storage already has the latest copy.|
|`(0x0000000b) exists dirty archived`|The file has changes that aren't archived. To send the changes in Lustre back to Blob Storage, run a manual export (archive) job. The manual export (archive) job overwrites the file in Blob Storage.|
|`(0x00000000)`|The file is new and only exists in the Lustre file system. A manual export (archive) job creates a new file in the blob container. If the file is updated again in Lustre, run another manual export (archive) job to copy those changes to Blob Storage.|
|`(0x00000001) exists`|The file is new and only exists in the Lustre file system. An manual export (archive) job has been started and hasn't completed for this file. |

## Next steps

- Learn more about [Azure Blob Storage integration with Azure Managed Lustre file systems](blob-integration.md)
