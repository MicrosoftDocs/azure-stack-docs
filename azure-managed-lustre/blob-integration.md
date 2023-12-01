---
title: Use Azure Blob storage with an Azure Managed Lustre file system
description: Understand storage concepts for using Azure Blob storage with an Azure Managed Lustre file system. 
ms.topic: overview
author: pauljewellmsft
ms.author: pauljewell
ms.date: 12/01/2023
ms.lastreviewed: 06/05/2023
ms.reviewer: brianl

# Intent: As an IT Pro, I want to be able to seamlessly use Azure Blob Storage for long-term storage of files in my Azure Managed Lustre file system.
# Keyword: Lustre Blob Storage

---

# Use Azure Blob storage with Azure Managed Lustre

This article explains concepts for using the Azure blob integration with Azure Managed Lustre file systems.

To learn the requirements and configuration needed for a compatible blob container, [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites-optional).

Azure Managed Lustre supports both hierarchical and non-hierarchical namespaces for blobs with the following minor differences:

- With a hierarchical namespace container, Azure Managed Lustre reads POSIX attributes from the blob header.
- With a non-hierarchical container, Azure Managed Lustre reads POSIX attributes from the blob metadata. A separate empty file with the same name as your blob container contents is created to hold the metadata. This file is a sibling to the actual data directory in the Azure Managed Lustre file system.

## Filter blob imports

When you create the Azure Managed Lustre file system, you can specify a prefix to filter the data imported into the Azure Managed Lustre file system. Contents that match the prefix are added to a metadata record in the file system. When clients request a file, its contents are retrieved from the blob container and stored in the file system.

Use the **Import prefix** option on the **Advanced** tab to determine what data is imported from your blob container when the system is created. This field can't be changed after you create the Azure Managed Lustre file system.

- The default import prefix, **/**, imports the entire contents of the blob container.

- If you don't want to import files from the blob container, you can set an import prefix that doesn't match any files in the container.

- If you use a hierarchical blob storage service (like NFSv3-mounted blob storage), you can think of the prefix as a file path. Items under the path are included in the Azure Managed Lustre file system.

- If you use your blob container as a non-hierarchical object store, you can also think of the import prefix as a search string that is compared with the beginning of your blob object name. If the name of a file in your blob container starts with the string you specified as the import prefix, that file is made accessible in the file system. Lustre is a hierarchical file system, and **/** characters in blob file names become directory delimiters when stored in Lustre.

## Metadata for exported files

When files are archived from the Azure Managed Lustre system to the blob container, additional metadata is saved to simplify reimporting the contents to an Azure Managed Lustre file system.

- The following POSIX attributes from the Lustre file system are saved in the blob metadata as key-value pairs (value type in parentheses):

  - `owner:` (int)
  - `group:` (int)
  - `permissions:` (octal or rwxrwxrwx format; sticky bit is supported)

- Directory attributes are saved in an empty blob. This blob has the same name as the directory path and contains the following key-value pair in the blob metadata:

  `hdi_isfolder : true`

You can modify the POSIX attributes manually before using the container to hydrate a new Lustre cluster. Edit or add blob metadata by using the key-value pairs described earlier.

## Copy a Lustre blob container with AzCopy or Storage Explorer

You can move or copy the blob container Lustre uses by using AzCopy or Storage Explorer.

For AzCopy, you can include directory attributes by adding the following flag:

 `--include-directory-stub`

Including this flag preserves directory POSIX attributes during a transfer, for example, `owner`, `group`, and `permissions`. If you use `azcopy` on the storage container without this flag, or with the flag set to `false`, then the data and directories are included in the transfer, but the directories don't retain their POSIX attributes.

In Storage Explorer, you can enable this flag in **Settings** by selecting **Transfers** and checking the box for **Include Directory Stubs**.

:::image type="content" source="./media/blob-integration/blob-integration-storage-explorer.png" alt-text="Screenshot showing how to include directory stubs during a transfer in Storage Explorer." lightbox="media/blob-integration/blob-integration-storage-explorer.png":::

## Next steps

- [Prepare prerequisites for blob storage integration](amlfs-prerequisites.md#blob-integration-prerequisites-optional)
