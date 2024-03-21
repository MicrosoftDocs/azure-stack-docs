---
title: Use Azure Blob storage with an Azure Managed Lustre file system
description: Understand storage concepts for using Azure Blob storage with an Azure Managed Lustre file system. 
ms.topic: conceptual
author: pauljewellmsft
ms.author: pauljewell
ms.date: 12/01/2023
ms.lastreviewed: 06/05/2023
ms.reviewer: brianl

# Intent: As an IT Pro, I want to be able to seamlessly use Azure Blob Storage for long-term storage of files in my Azure Managed Lustre file system.
# Keyword: Lustre Blob Storage

---

# Use Azure Blob storage with Azure Managed Lustre

Azure Managed Lustre integrates with Azure Blob Storage to simplify the process of importing data from a blob container to a file system. You can also export data from the file system to a blob container for long-term storage. This article explains concepts for using blob integration with Azure Managed Lustre file systems.

To understand the requirements and configuration needed for a compatible blob container, see [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites-optional).

## Blob integration overview

Azure Managed Lustre works with storage accounts that have hierarchical namespace enabled and storage accounts with a non-hierarchical, or flat, namespace. The following minor differences apply:

- For a storage account with hierarchical namespace enabled, Azure Managed Lustre reads POSIX attributes from the blob header.
- For a storage account that *does not* have hierarchical namespace enabled, Azure Managed Lustre reads POSIX attributes from the blob metadata. A separate empty file with the same name as your blob container contents is created to hold the metadata. This file is a sibling to the actual data directory in the Azure Managed Lustre file system.

## Import data from Blob Storage

You can configure integration with Blob Storage during [cluster creation](create-file-system-portal.md#blob-integration), or you can [manually create an import job](create-manual-import-job.md) any time after the cluster is created.

### Blob container requirements

When configuring an import job, you must identify two separate blob containers: the container to import and the logging container. The container to import contains the data that you want to import into the Azure Managed Lustre file system. The logging container is used to store logs for the import job. These two containers must be in the same storage account. To learn more about the requirements for the blob container, see [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites-optional).

### Import prefix

When importing data from a blob container, you can specify one or more prefixes to filter the data imported into the Azure Managed Lustre file system. Contents that match one of the prefixes are added to a metadata record in the file system. When a client requests a file, its contents are retrieved from the blob container and stored in the file system.

During cluster creation, use the **Import prefix** fields on the **Advanced** tab to specify the data to be imported from your blob container. These fields only apply to the initial import job. You can't change the import prefix after the cluster is created.

For a manual import job, you can specify import prefixes when you create the import job. From the Azure portal, you can specify the import prefix in the **Import prefix** field. You can also specify the import prefix when you use the REST API to create an import job.

Keep the following considerations in mind when specifying import prefixes:

- The default import prefix, **/**, imports the contents of the entire blob container.
- If you specify multiple prefixes, the prefixes must be non-overlapping. For example, if you specify `/data` and `/data2`, the import job fails because the prefixes overlap.
- If the blob container is in a storage account with hierarchical namespace enabled, you can think of the prefix as a file path. Items under the path are included in the Azure Managed Lustre file system.
- If the blob container is in a storage account with a non-hierarchical (or flat) namespace, you can think of the import prefix as a search string that is compared with the beginning of the blob name. If the name of a blob in the container starts with the string you specified as the import prefix, that file is made accessible in the file system. Lustre is a hierarchical file system, and **/** characters in blob names become directory delimiters when stored in Lustre.

### Conflict resolution mode

When importing data from a blob container, you can specify how to handle conflicts between the blob container and the file system. The following options are available:

### Error tolerance

When importing data from a blob container, you can specify the error tolerance level. The error tolerance level determines how the import job handles errors that occur during the import process. The following error tolerance levels are available:

### Considerations for blob import jobs

The following items are important to consider when importing data from a blob container:

- Only one import or export action can run at a time. For example, if an import job is in progress, attempting to start another import job returns an error.
- Import jobs can be cancelled. You can cancel an import started manually on an existing cluster, or an import initiated during cluster creation.
- Cluster deployment can return successfully before the corresponding import job is complete. The import job continues to run in the background. You can monitor the import job's progress in the following ways:
  - **Azure portal**: 
  - **REST API**: 
  - **Lustre file in root directory**: A file named similar to `/lustre/IMPORT_<state>.<timestamp_start>` is created in the Lustre root directory during import. The `<state>` placeholder changes as the import progresses. The file is deleted when the import job completes successfully.

## Export data to Blob Storage using an archive job

You can copy data from your Azure Managed Lustre file system to long-term storage in Azure Blob Storage by creating an archive job.

### Metadata for exported files

When files are archived from the Azure Managed Lustre system to the blob container, additional metadata is saved to simplify reimporting the contents to an Azure Managed Lustre file system.

- The following POSIX attributes from the Lustre file system are saved in the blob metadata as key-value pairs (value type in parentheses):

  - `owner:` (int)
  - `group:` (int)
  - `permissions:` (octal or rwxrwxrwx format; sticky bit is supported)

- Directory attributes are saved in an empty blob. This blob has the same name as the directory path and contains the following key-value pair in the blob metadata:

  `hdi_isfolder : true`

You can modify the POSIX attributes manually before using the container to hydrate a new Lustre cluster. Edit or add blob metadata by using the key-value pairs described earlier.

### Considerations for archive jobs

The following items are important to consider when exporting data with an archive job:

- Only one import or export action can run at a time. For example, if an import job is in progress, attempting to start an archive job returns an error.

## Copy a Lustre blob container with AzCopy or Storage Explorer

You can move or copy the blob container Lustre uses by using AzCopy or Storage Explorer.

For AzCopy, you can include directory attributes by adding the following flag:

 `--include-directory-stub`

Including this flag preserves directory POSIX attributes during a transfer, for example, `owner`, `group`, and `permissions`. If you use `azcopy` on the storage container without this flag, or with the flag set to `false`, then the data and directories are included in the transfer, but the directories don't retain their POSIX attributes.

In Storage Explorer, you can enable this flag in **Settings** by selecting **Transfers** and checking the box for **Include Directory Stubs**.

:::image type="content" source="./media/blob-integration/blob-integration-storage-explorer.png" alt-text="Screenshot showing how to include directory stubs during a transfer in Storage Explorer." lightbox="media/blob-integration/blob-integration-storage-explorer.png":::

## Next steps

- [Prepare prerequisites for blob storage integration](amlfs-prerequisites.md#blob-integration-prerequisites-optional)
