---
title: Use archive jobs to export data from Azure Managed Lustre (Preview)
description: TK
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/09/2023
ms.reviewer: sethm
ms.date: 02/09/2023

# Intent: As an IT Pro, XXX.
# Keyword: 

---

# Use archive jobs to export data from Azure Managed Lustre (Preview)

<!--STATUS: Imported as is from private preview. Title only updated.-->

Create an archive job when you want to copy data from your Azure Managed Lustre file system to long-term storage in Azure Blob.

> [!NOTE]
> The archive system only writes to the blob container that you defined when you created the Azure Managed Lustre system. If you did not integrate a blob container, use client filesystem commands directly to copy the data without creating an archive job.

## Understand which files are exported

When you archive files from your Azure Managed Lustre system, not all of the files are copied:

* Only *new* or *changed* data is copied in an archive job. If you imported a file from the blob container and it hasn't changed, it **will not be exported** in the archive job.
* Files with metadata changes only (owner, permissions, extended attributes) will not be exported unless the file content was also modified.
* If you delete a file in the Azure Managed Lustre file system, it **will not be deleted** from the original source by an archive job.

## Create an archive job

Archiving data is a manual, user-driven process that can be accomplished in one of two ways:
1. Using the Blob integration page in the Azure Portal
2. Using the native Lustre client CLI commands

### Creating an archive job using the Blob Integration page ###

Use the **Blob integration** page to export changed files to the integrated blob container.

Click the **Create job** button at the top of the page to export files.

Fill in the **File system path** field to specify what will be exported in this archive job.

* All new or changed files that begin with this string in the Azure Managed Lustre file system will be exported.

* Files are written to the blob container with the same file path (or prefix) that they have in the Lustre system. If you want to avoid overwriting existing files on the blob container, make sure their path on your Lustre system does not overlap the existing files' path on the blob container.

### Monitor or cancel a Blob Integration archive job ###

An archive job managed by the Blob Integration feature in the Azure Portal can be monitored or cancelled on that Azure Portal blade. 

The activity table shows job status.

Only one archive job can run at a time. If you want to cancel the job, click the **Cancel** button at the top of the page.

### Creating an archive job using the native Lustre client CLI commands ###

Run the following to archive a single file:

```bash
sudo lfs hsm_archive path/to/export/file
```

In order to archive all files in a directory, you can run something like this:
```bash
nohup find local/directory -type f -print0 | xargs -0 -n 1 sudo lfs hsm_archive &
```

### Monitor an archive using the native Lustre client CLI ###

To check on the status of an archive job, you can run: 
```bash
find path/to/export/file -type f -print0 | xargs -0 -n 1 -P 8 sudo lfs hsm_action | grep "ARCHIVE" | wc -l
```

Each file has a *state* associated with it, reflecting its relationship between the Lustre file system and Blob. To check the state of a file, you can run:
```bash
sudo lfs hsm_state path/to/export/file
```

The state command shows you whether or not a file’s data is in Blob-only ((0x0000000d) released exists archived), in both Lustre and Blob ((0x00000009) exists archived), is changed and not archived to Blob ((0x0000000b) exists dirty archived), or is new and only exists in Lustre ((0x00000000)).
