---
title: Use Azure Blob Storage with an Azure Managed Lustre File System
description: Learn how Azure Managed Lustre integrates with Azure Blob Storage for data import and export.
ms.topic: overview
ms.date: 10/06/2026
author: akashdubey
ms.author: akashdubey
ms.reviewer: brianl
---

# Use Azure Blob Storage with Azure Managed Lustre

Azure Managed Lustre integrates with Azure Blob Storage so that you can import data into a file system and export file system data for long-term storage. Configure a compatible blob container when you create the file system. For requirements and configuration details, see [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites).

## How blob integration works

You can import data from the configured blob container after the file system is created. An import creates the Lustre namespace and imports file metadata. When a client first accesses a file, Lustre Hierarchical Storage Management (HSM) retrieves the corresponding blob contents. This first access can introduce a delay. If your workload needs data before first access, you can prefetch it. For instructions, see [Restore data from Azure Blob Storage](restore-data.md).

You can also export new and changed files from the file system to the configured blob container. You can run an export job on demand or use auto-export to continuously export changes. For details, see [Export data to Azure Blob Storage](export-data.md).

Azure Managed Lustre supports storage accounts with either hierarchical namespace enabled or a flat namespace. For a hierarchical namespace, Azure Managed Lustre reads POSIX attributes from the blob header. For a flat namespace, it reads POSIX attributes from blob metadata and creates a separate empty file to hold the metadata.

## Import and export data

- [Import data from Azure Blob Storage](import-data.md) explains manual import jobs and auto-import.
- [Export data to Azure Blob Storage](export-data.md) explains manual export jobs and auto-export.

## Related content

- [Prerequisites for Blob Storage integration](amlfs-prerequisites.md#blob-integration-prerequisites)
- [Import data from Azure Blob Storage](import-data.md)
- [Export data to Azure Blob Storage](export-data.md)
- [Restore data from Azure Blob Storage](restore-data.md)
