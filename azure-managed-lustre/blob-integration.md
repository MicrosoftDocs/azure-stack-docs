---
title: Use Azure Blob storage with an Azure Managed Lustre file system (Preview)
description: Understand storage concepts for using Azure Blob storage with an Azure Managed Lustre file system. 
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/09/2023
ms.reviewer: sethm
ms.date: 02/09/2023

# Intent: As an IT Pro, XXX.
# Keyword: 

---

# Use Azure Blob storage with Azure Managed Lustre (Preview)

<!--STATUS: Copied from private preview as is. Title updated. Metadata placeholder to be updated. Links updated to meet build requirements.-->

This article explains concepts for using the Azure blob integration with Azure Managed Lustre file systems.

Read [Storage account prerequisites](prerequisites-amlfs.md#storage-prerequisites) to learn the requirements and pre-configuration needed for a compatible blob container.

## Understand hierarchical and non-hierarchical storage schemas
<!-- update aka link if you change this header text -->

Since Azure Blob containers are native object storage, you can choose whether or not to impose a hierarchical file system structure on them.

When the Azure Managed Lustre file system imports files from your blob container, it can read POSIX file access attributes from the original container. But the attributes are handled differently depending on whether they came from a hierarchical namespace or from a flat object storage system.

- With a hierarchical namespace container, Azure Managed Lustre reads POSIX attributes from the blob header.
- With a non-hierarchical container, Azure Managed Lustre reads POSIX attributes from the blob metadata. A separate empty file with the same name as your blob container contents is created to hold the metadata. This file is a sibling to the actual data directory in the Azure Managed Lustre file system.

Here are some examples of Azure services that impose a file system hierarchy on blob storage:

- [Azure Data Lake Storage Gen2](/azure/storage/blobs/data-lake-storage-namespace)
- [NFS v3-mounted blob storage](/azure/storage/blobs/network-file-system-protocol-support-how-to)

### Metadata for exported files

When files are archived from the Azure Managed Lustre system to the blob container, additional metadata is saved to simplify re-importing the contents to an Azure Managed Lustre file system.

- The following POSIX attributes from the Lustre file system are saved in the blob metadata as key-value pairs (value type in parentheses):

  - ``owner:`` (int)
  - ``group:`` (int)
  - ``permissions:`` (octal or rwxrwxrwx format; sticky bit is supported)

- Directory attributes are saved in an empty blob with the same name as the directory path and the following additional key-value pair in the blob metadata:

  ``hdi_isfolder : true``

You can modify these POSIX attributes manually before using the container to hydrate a new Lustre cluster. Edit or add blob metadata by using the key-value pairs described above.
