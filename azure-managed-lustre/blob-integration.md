---
title: Use Azure Blob storage with an Azure Managed Lustre file system (preview)
description: Understand storage concepts for using Azure Blob storage with an Azure Managed Lustre file system. 
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/17/2023
ms.reviewer: brianl
ms.date: 02/09/2023

# Intent: As an IT Pro, I want to be able to seamlessly use Azure Blob Storage for long-term storage of files in my Azure Managed Lustre file system.
# Keyword: Lustre Blob Storage

---

# Use Azure Blob storage with Azure Managed Lustre (preview)

This article explains concepts for using the Azure blob integration with Azure Managed Lustre file systems.

Read [Storage account prerequisites](amlfs-prerequisites.md#storage-prerequisites) to learn the requirements and pre-configuration needed for a compatible blob container.

## Understand hierarchical and non-hierarchical storage schemas

Since Azure Blob containers are native object storage, you can choose whether or not to impose a hierarchical file system structure on them.

When the Azure Managed Lustre file system imports files from your blob container, it can read POSIX file access attributes from the original container. But the attributes are handled differently depending on whether they came from a hierarchical namespace or from a flat object storage system.

- With a hierarchical namespace container, Azure Managed Lustre reads POSIX attributes from the blob header.
- With a non-hierarchical container, Azure Managed Lustre reads POSIX attributes from the blob metadata. A separate empty file with the same name as your blob container contents is created to hold the metadata. This file is a sibling to the actual data directory in the Azure Managed Lustre file system.

Here are some examples of Azure services that impose a file system hierarchy on blob storage:

- [Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-namespace)
- [NFS v3-mounted blob storage](/azure/storage/blobs/network-file-system-protocol-support-how-to)

## Filtering blob imports

When you create the Azure Managed Lustre file system, you can specify a prefix to filter the data that's imported into the Azure Managed Lustre file system. Contents that match the prefix are added to a metadata record in the file system. When clients request a file, its contents are retrieved from the blob container and stored in the file system. 

Use the **Import prefix** option on the **Advanced** tab to determine what data is imported from your blob container when the system is created. This field can't be changed after you create the Azure Managed Lustre file system.

The default import prefix, **/**, imports the entire contents of the blob container.

If you don't want to import files from the blob container, you can set an import prefix that does not match any files in the container.

If you use a hierarchical blob storage service (like NFSv3-mounted blob storage), you can think of the prefix as a file path. Items under the path are included in the Azure Managed Lustre file system.

If you use your blob container as a non-hierarchical object store, you can also think of the import prefix as a search string that is compared with the beginning of your blob object name. If the name of a file in your blob container starts with the string you specified as the import prefix, that file will be made accessible in the file system. Lustre is a hierarchical file system, and **/** characters in blob file names will become directory delimiters when stored in Lustre.

For more information about using Azure Managed Lustre with hierarchical or non-hierarchical blob containers, see [Understand hierarchical and non-hierarchical storage schemas](blob-integration.md#understand-hierarchical-and-non-hierarchical-storage-schemas).

### Metadata for exported files

When files are archived from the Azure Managed Lustre system to the blob container, additional metadata is saved to simplify re-importing the contents to an Azure Managed Lustre file system.

- The following POSIX attributes from the Lustre file system are saved in the blob metadata as key-value pairs (value type in parentheses):

  - ``owner:`` (int)
  - ``group:`` (int)
  - ``permissions:`` (octal or rwxrwxrwx format; sticky bit is supported)

- Directory attributes are saved in an empty blob with the same name as the directory path and the following additional key-value pair in the blob metadata:

  ``hdi_isfolder : true``

You can modify these POSIX attributes manually before using the container to hydrate a new Lustre cluster. Edit or add blob metadata by using the key-value pairs described above.
