---
title: Use archive jobs to export data from Azure Managed Lustre (Preview)
description: How to use an archive job to copy data from your Azure Managed Lustre file system to long-term storage in Azure Blob Storage.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/20/2023
ms.reviewer: brianl
ms.date: 02/09/2023

# Intent: As an IT Pro, I need to be able to export files from my Azure Managed Lustre file system to longterm Azure Blob Storage.
# Keyword: 

---

# Use archive jobs to export data from Azure Managed Lustre (Preview)

This article describes how to copy data from your Azure Managed Lustre file system to long-term storage in Azure Blob Storage by creating an archive job.

This export method is only available when you integrate Azure Blob Storage with your Azure Managed Lustre file system during file system creation. For more information, see [Azure Blob Storage integration](amlfs-overview.md#azure-blob-storage-integration). If you didn't integrate a blob container when you created the file system, use client filesystem commands directly to copy the data without creating an archive job.

## Understand which files are exported

When you archive files from your Azure Managed Lustre system, not all of the files are copied into the blob container that you specified when you created the file system:

* An archive job only copies new or changed data. If the file that you imported from the blob container during file system creation hasn't changed, the archive job doesn't export the file.

* Files with metadata changes only (owner, permissions, extended attributes) aren't exported.

* If you delete a file in the Azure Managed Lustre file system, the archive job won't delete the file from the original source.

Archiving data is a manual process that you can do in the Azure portal or using command in the native Lustre client CLI. With both methods, you can monitor the state of the archive job.

The following procedures tell how to:

* [Create archive job in Azure portal](#create-archive-job-in-azure-portal)
* [Monitor or cancel an archive job in the Azure portal](#monitor-or-cancel-archive-job-in-azure-portal)
* [Create an archive job with native Lustre CLI](#create-archive-job-using-native-lustre-client-cli)
* [Monitor archiving state for a file using the native Luster CLI](#monitor-archive-state-using-native-lustre-client-cli)

## Create archive job in Azure portal

To create an archive job to export changed data from an Azure Managed Lustre file system in the Azure portal, do the following steps:

1. Sign in to the Azure Managed Lustre preview portal using this URL: [https://aka.ms/azureLustrePrivatePreview](https://aka.ms/azureLustrePrivatePreview), and open your Azure Managed Lustre file system.

1. Under **Settings**,  open the **Blob integration** page to export changed files to the integrated blob container.

   ![Screenshot showing the Blob Integration menu item on the Overview pane for an Azure Managed Lustre file system.](media/export-with-archive-jobs/select-blob-integration-settings.png)

2. Select **+ Create archive job**.

   ![Screenshot showing the Create Archive Job button on the Blob Integration page of an Azure Managed Lustre file system.](media/export-with-archive-jobs/select-create-archive-job.png)

3. Enter the **File system path** to specify what to export in this archive job, and select **OK**.

   ![Screenshot showing the Create Archive Job pane for an Azure Managed Lustre file system.](media/export-with-archive-jobs/create-archive-job-options.png)

   * All new or changed files whose filenames begin with this string in the Azure Managed Lustre file system will be exported.

   * Files are written to the blob container with the same file path (or prefix) that they have in the Lustre system. If you want to avoid overwriting existing files in the blob container, make sure the files' path in your Lustre system doesn't overlap the existing files' path in the blob container.

## Monitor or cancel archive job in Azure portal

You can monitor or cancel an archive job that you created through the blob integration feature for your Azure Managed Lustre file system in the Azure portal. The **Arhive jobs** section of the **Blob integration** page shows that status of each job. In the list, use the **Cancel** link to cancel an archive job that's in progress.

   ![Screenshot showing the Blob Integration pane for an Azure Managed Lustre file system. The Archive Jobs heading and the Cancel button for a completed job are highlighted.](media/export-with-archive-jobs/archive-jobs.png)

Only one archive job runs at a time. To cancel the job that's in progress, select the **Cancel** button at the top of the page. Or select the **Cancel** link for that job in the **Archive jobs** table. The **Cancel** link isn't available for a completed job.

## Create archive job using native Lustre client CLI

To create an archive job to export changed data from an Azure Managed Lustre file system using native Lustre client CLI command, use one of the following commands:

* To archive a single file, run a command similar to this one:

  ```bash
  sudo lfs hsm_archive path/to/export/file
  ```

* To archive all files in a directory, run a command similar to this one:

  ```bash
  nohup find local/directory -type f -print0 | xargs -0 -n 1 sudo lfs hsm_archive &
  ```

## Monitor archive state using native Lustre client CLI

To check on the status of an archive job using the native Lustre client CLI, run the following command:

```bash
find path/to/export/file -type f -print0 | xargs -0 -n 1 -P 8 sudo lfs hsm_action | grep "ARCHIVE" | wc -l
```

Each file has an associated state, which indicates the relationship between the file data in the Lustre file system and the file data in Azure Blob Storage. To check the state of a file, run this command:

```bash
sudo lfs hsm_state path/to/export/file
```

The state command shows you whether a file's data is in Azure Blob Storage only (`(0x0000000d) released exists archived`), in both Lustre and Azure Blob Storage (`(0x00000009) exists archived`), has changes that haven't been archived to Azure Blob Storage (`(0x0000000b) exists dirty archived`), or is new and only exists in the Lustre file system (`(0x00000000)`).
