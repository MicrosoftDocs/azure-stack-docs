---
title: Use Azure Blob storage with an Azure Managed Lustre file system
description: Understand storage concepts for using Azure Blob storage with an Azure Managed Lustre file system. 
ms.topic: conceptual
author: pauljewellmsft
ms.author: pauljewell
ms.date: 05/30/2024
ms.lastreviewed: 06/05/2023
ms.reviewer: brianl

# Intent: As an IT Pro, I want to be able to seamlessly use Azure Blob Storage for long-term storage of files in my Azure Managed Lustre file system.
# Keyword: Lustre Blob Storage

---

# Use Azure Blob Storage with Azure Managed Lustre

Azure Managed Lustre integrates with Azure Blob Storage to simplify the process of importing data from a blob container to a file system. You can also export data from the file system to a blob container for long-term storage. This article explains concepts for using blob integration with Azure Managed Lustre file systems.

To understand the requirements and configuration needed for a compatible blob container, see [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites-optional).

## Blob integration overview

You can configure blob integration during [cluster creation](create-file-system-portal.md#blob-integration), and you can [create an import job](create-import-job.md) any time after the cluster is created. Once the data is imported, you can work with the data as you would with other file system data. As new files are created or existing files are modified in the file system, you can export these files back to the storage account by running Lustre CLI commands on the client, or by [exporting the data using export jobs](export-with-archive-jobs.md).

When you import data from a blob container to an Azure Managed Lustre file system, only the file names (namespace) and metadata are imported into the Lustre namespace. The actual contents of a blob are imported when first accessed by a client. There's a slight delay when first accessing data while the Lustre Hierarchical Storage Management (HSM) feature pulls in the blob contents to the corresponding file in the file system.

You can prefetch the contents of blobs using Lustre's `lfs hsm_restore` command from a mounted client with sudo capabilities. To learn more, see [Restore data from Blob Storage](#restore-data-from-blob-storage).

Azure Managed Lustre works with storage accounts that have hierarchical namespace enabled and storage accounts with a non-hierarchical, or flat, namespace. The following minor differences apply:

- For a storage account with hierarchical namespace enabled, Azure Managed Lustre reads POSIX attributes from the blob header.
- For a storage account that *does not* have hierarchical namespace enabled, Azure Managed Lustre reads POSIX attributes from the blob metadata. A separate, empty file with the same name as your blob container contents is created to hold the metadata. This file is a sibling to the actual data directory in the Azure Managed Lustre file system.

## Import from Blob Storage

You can configure integration with Blob Storage during [cluster creation](create-file-system-portal.md#blob-integration), and you can [create an import job](create-import-job.md) any time after the cluster is created.

### Blob container requirements

When configuring blob integration during cluster creation, you must identify two separate blob containers: the container to import and the logging container. The container to import contains the data that you want to import into the Azure Managed Lustre file system. The logging container is used to store logs for the import job. These two containers must be in the same storage account. To learn more about the requirements for the blob container, see [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites-optional).

### Import prefix

When importing data from a blob container, you can optionally specify one or more prefixes to filter the data imported into the Azure Managed Lustre file system. File names in the blob container that match one of the prefixes are added to a metadata record in the file system. When a client first accesses a file, its contents are retrieved from the blob container and stored in the file system.

In the Azure portal, use the **Import prefix** fields on the **Advanced** tab during cluster creation to specify the data to be imported from your blob container. These fields only apply to the initial import job. You can't change the import prefix after the cluster is created.

For an import job, you can specify import prefixes when you create the job. From the Azure portal, you can specify import prefixes in the **Import prefix** fields. You can also specify the import prefix when you use the REST API to create an import job.

Keep the following considerations in mind when specifying import prefixes:

- The default import prefix is `/`. This default behavior imports the contents of the entire blob container.
- If you specify multiple prefixes, the prefixes must be non-overlapping. For example, if you specify `/data` and `/data2`, the import job fails because the prefixes overlap.
- If the blob container is in a storage account with hierarchical namespace enabled, you can think of the prefix as a file path. Items under the path are included in the Azure Managed Lustre file system.
- If the blob container is in a storage account with a non-hierarchical (or flat) namespace, you can think of the import prefix as a search string that is compared with the beginning of the blob name. If the name of a blob in the container starts with the string you specified as the import prefix, that file is made accessible in the file system. Lustre is a hierarchical file system, and `/` characters in blob names become directory delimiters when stored in Lustre.

### Conflict resolution mode

When importing data from a blob container, you can specify how to handle conflicts between the blob container and the file system. This option only applies to import jobs that are run for existing clusters. The following table shows the available conflict resolution modes and their descriptions:

| Mode | Description |
|------|-------------|
| `fail` | The import job fails immediately with an error if a conflict is detected. |
| `skip` | The import job skips the file if a conflict is detected. |
| `overwrite-dirty` | The import job evaluates a conflicting path to see if it should be deleted and reimported. To learn more, see [overwrite-dirty mode](#overwrite-dirty-mode). |
| `overwrite-always` | The import job evaluates a conflicting path and always deletes/re-imports if it's dirty, or releases if it's clean. To learn more, see [overwrite-always mode](#overwrite-always-mode). |

#### Overwrite-dirty mode

The `overwrite-dirty` mode evaluates a conflicting path to see if it should be deleted and reimported. At a high level, `overwrite-dirty` mode checks the HSM state. If the HSM state is **Clean** and **Archived**, meaning its data is in sync with the blob container as far as Lustre can tell, then only the attributes are updated, if needed. Otherwise, the file is deleted and reimported from the blob container.

Checking the HSM state doesn't guarantee that the file in Lustre matches the file in the blob container. If you must ensure that the file in Lustre matches the file in the blob container as closely as possible, use the `overwrite-always` mode.

#### Overwrite-always mode

The `overwrite-always` mode evaluates a conflicting path and always deletes/re-imports if it's dirty, or releases if it's clean. This mode is useful when you want to ensure that the file system is always in sync with the blob container. It's also the most expensive option, as every previously restored file is either released or deleted/re-imported upon first access.

### Error tolerance

When importing data from a blob container, you can specify the error tolerance. The error tolerance level determines how the import job handles transient errors that occur during the import process, for example, operating system errors or network interruptions. It's important to note that errors in this context don't refer to file conflicts, which are handled by the conflict resolution mode.

The following error tolerance options are available for import jobs:

- **Do not allow errors** (default): The import job fails immediately if any error occurs during the import. This is the default behavior.
- **Allow errors**: The import job continues if an error occurs, and the error is logged. After the import job completes, you can view errors in the logging container.

### Considerations for blob import jobs

The following items are important to consider when importing data from a blob container:

- Only one import or export action can run at a time. For example, if an import job is in progress, attempting to start another import job returns an error.
- Import jobs can be canceled. You can cancel an import job started on an existing cluster, or an import job initiated during cluster creation.
- Cluster deployment can return successfully before the corresponding import job is complete. The import job continues to run in the background. You can monitor the import job's progress in the following ways:
  - **Azure portal**: The Azure portal displays the status of the import job. Navigate to the file system and select **Blob integration** to view the import job status.
  - **Lustre file in root directory**: A file named similar to `/lustre/IMPORT_<state>.<timestamp_start>` is created in the Lustre root directory during import. The `<state>` placeholder changes as the import progresses. The file is deleted when the import job completes successfully.
- To view details about a completed import job, you can check the logging container. The logging container contains logs for the import job, including any errors or conflicts that occurred during the import.
- If the import job fails for any reason, you might not have complete statistics about the import job, such as the number of files imported or number of conflicts.

## Restore data from Blob Storage

By default, the contents of a blob are imported to a file system the first time the corresponding file is accessed by a client. For certain workloads and scenarios, you might prefer to restore the data from a blob container before it's first accessed. You can choose to prefetch the contents of blobs to avoid the initial delay when the blob is accessed for the first time after import. To prefetch the contents of blobs, you can use Lustre's `lfs hsm_restore` command from a mounted client with sudo capabilities. The following command will prefetch the contents of the blobs into the file system:

```bash
nohup find local/directory -type f -print0 | xargs -0 -n 1 sudo lfs hsm_restore &
```

This command tells the metadata server to asynchronously process a restoration request. The command line doesn't wait for the restore to complete, which means that the command line has the potential to queue up a large number of entries for restore at the metadata server. This approach can overwhelm the metadata server and degrade performance for restores.

To avoid this potential performance issue, you can create a basic script that attempts to walk the path and issues restore requests in batches of a specified size. To achieve reasonable performance and avoid overwhelming the metadata server, it's recommended to use batch sizes anywhere from 1,000 to 5,000 requests.

### Example: Create a batch restore script

The following example shows how to create a script to restore data from a blob container in batches. Create a file named `file_restorer.bash` with the following contents:

```bash
#!/bin/bash
set -feu
set -o pipefail
main()
{
    if [ $# -lt 2 ]; then
        echo "$0 <path_to_fully_restore> <max_restores_at_a_time>"
        echo "Missing parameters"
        exit 1
    fi
    local RESTORE_PATH=$1
    local MAX_RESTORES=$2
    local FILES_LIST="/tmp/files_to_restore"
    find "$RESTORE_PATH" -type f > "$FILES_LIST"
    local TOTAL_FILES
    TOTAL_FILES=$(wc -l "$FILES_LIST")
    local RESTORE_TOTAL=0
    local RESTORE_COUNT=0
    while IFS="" read -r p || [ -n "$p" ]; do
        printf '%s\n' "$p"
        lfs hsm_restore "$p"
        ((RESTORE_COUNT++)) || true
        ((RESTORE_TOTAL++)) || true
        if (( RESTORE_COUNT >= MAX_RESTORES )); then
            while true; do
                local STATE
                STATE=$(lfs hsm_state "$p")
                RELEASED=') released exists archived'
                if ! [[ $STATE =~ $RELEASED ]]; then
                    echo "Restored $RESTORE_TOTAL / $TOTAL_FILES"
                    break
                fi
                sleep 0.2
            done
            RESTORE_COUNT=0
        fi
    done < "$FILES_LIST"
}
main "$@"
```

The following example shows how to run the script along with the sample output:

```bash
root@vm:~# time ~azureuser/file_restorer.bash /lustre/client/ 5000
Finding all files to restore beneath: /lustre/client/
Found 78100 to restore
Initiating restores in batches of 5000...
Restored 5000 / 78100
Restored 10000 / 78100
Restored 15000 / 78100
Restored 20000 / 78100
Restored 25000 / 78100
Restored 30000 / 78100
Restored 35000 / 78100
Restored 40000 / 78100
Restored 45000 / 78100
Restored 50000 / 78100
Restored 55000 / 78100
Restored 60000 / 78100
Restored 65000 / 78100
Restored 70000 / 78100
Restored 75000 / 78100
Restored 78100 / 78100
real	6m59.633s
user	1m20.273s
sys	0m37.960s
```

> [!NOTE]
> At this time, Azure Managed Lustre restores data from Blob Storage at a maximum throughput rate of ~7.5GiB/second.

## Export data to Blob Storage using an export job

You can copy data from your Azure Managed Lustre file system to long-term storage in Azure Blob Storage by [creating an export job](export-with-archive-jobs.md).

### Which files are exported during an export job?

When you export files from your Azure Managed Lustre system, not all files are copied to the blob container that you specified when you created the file system. The following rules apply to export jobs:

- Export jobs only copy files that are new or whose contents are modified. If the file that you imported from the blob container during file system creation is unchanged, the export job doesn't export the file.
- Files with metadata changes only aren't exported. Metadata changes include: owner, permissions, extended attributes, and name changes (renamed).
- Files deleted in the Azure Managed Lustre file system aren't deleted in the original blob container during the export job. The export job doesn't delete files in the blob container.

### Running export jobs in active file systems

In active file systems, changes to files during the export job can result in failure status. This failure status lets you know that not all data in the file system could be exported to Blob Storage. In this situation, you can retry the export by [creating a new export job](export-with-archive-jobs.md#create-an-export-job). The new job copies only the files that weren't copied in the previous job.

In file systems with a lot of activity, retries may fail multiple times because files are frequently changing. To verify that a file has been successfully exported to Blob Storage, check the timestamp on the corresponding blob. After the job completes, you can also view the logging container configured at deployment time to see detailed information about the export job. The logging container provides diagnostic information about which files failed, and why they failed.

If you're preparing to decommission a cluster and want to perform a final export to Blob Storage, you should make sure that all I/O activities are halted before initiating the export job. This approach helps to guarantee that all data is exported by avoiding errors due to file system activity.

### Metadata for exported files

When files are exported from the Azure Managed Lustre file system to the blob container, additional metadata is saved to simplify reimporting the contents to a file system.

The following table lists POSIX attributes from the Lustre file system that are saved in the blob metadata as key-value pairs:

| POSIX attribute | Type |
|-----------------|------|
| `owner` | int |
| `group` | int |
| `permissions` | octal or rwxrwxrwx format; sticky bit is supported |

Directory attributes are saved in an empty blob. This blob has the same name as the directory path and contains the following key-value pair in the blob metadata: `hdi_isfolder : true`.

You can modify the POSIX attributes manually before using the container to hydrate a new Lustre cluster. Edit or add blob metadata by using the key-value pairs described earlier.

### Considerations for export jobs

The following items are important to consider when exporting data with an export job:

- Only one import or export action can run at a time. For example, if an export job is in progress, attempting to start another export job returns an error.

## Copy a Lustre blob container with AzCopy or Storage Explorer

You can move or copy the blob container Lustre uses by using AzCopy or Storage Explorer.

For AzCopy, you can include directory attributes by adding the following flag:

 `--include-directory-stub`

Including this flag preserves directory POSIX attributes during a transfer, for example, `owner`, `group`, and `permissions`. If you use `azcopy` on the storage container without this flag, or with the flag set to `false`, then the data and directories are included in the transfer, but the directories don't retain their POSIX attributes.

In Storage Explorer, you can enable this flag in **Settings** by selecting **Transfers** and checking the box for **Include Directory Stubs**.

:::image type="content" source="./media/blob-integration/blob-integration-storage-explorer.png" alt-text="Screenshot showing how to include directory stubs during a transfer in Storage Explorer." lightbox="media/blob-integration/blob-integration-storage-explorer.png":::

## Next steps

- [Prerequisites for blob storage integration](amlfs-prerequisites.md#blob-integration-prerequisites-optional)
- [Create an import job from Blob Storage to Azure Managed Lustre](create-import-job.md)
- [Create an export job to export data from Azure Managed Lustre](export-with-archive-jobs.md)