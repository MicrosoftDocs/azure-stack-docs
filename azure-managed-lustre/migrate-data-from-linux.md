---
title: Migrate Data from On-Premises POSIX File Systems to Azure Managed Lustre
description: Learn how to migrate data from an on-premises POSIX file system to Azure Managed Lustre by using AzCopy and Azure Blob Storage as an intermediary.
ms.topic: how-to
ms.date: 03/27/2026
author: wolfgang-desalvador
ms.author: wdesalvador
ms.reviewer: rohogue

# Intent: As an IT Pro, I want to migrate data from my on-premises POSIX file system to Azure Managed Lustre while preserving POSIX attributes.
# Keyword: Lustre data migration POSIX AzCopy

---

# Migrate data from an on-premises POSIX file system to Azure Managed Lustre

In this article, you'll learn how to migrate data from an on-premises POSIX file system to Azure Managed Lustre by using Azure Blob Storage as an intermediary. This approach uses AzCopy to upload data to a blob container while preserving POSIX properties, and then imports the data from the blob container into your Azure Managed Lustre file system.

## Overview

Azure Managed Lustre integrates with Azure Blob Storage, which makes Blob Storage useful as a staging area when migrating data from on-premises environments.

### Use Azure Blob Storage as an intermediary

Using Azure Blob Storage as an intermediary for data migration offers several advantages over copying data directly to a file system using traditional POSIX protocols such as NFS or SMB:

- **REST API-based access from outside Azure**: Azure Blob Storage exposes REST APIs that are accessible from any network with internet connectivity. This simplifies data transfers from on-premises environments without requiring VPN or ExpressRoute connectivity for the initial data upload, and provides fine-grained access control through shared access signatures (SAS) tokens or Microsoft Entra ID. If your security requirements don't allow public internet access, you can also configure [private endpoints](/azure/storage/common/storage-private-endpoints) and use a VPN or Azure ExpressRoute to keep all traffic on a private network.
- **Better performance under high-latency conditions**: AzCopy is optimized for transferring data over high-latency connections. It uses parallel connections, automatic retries, and resumable transfers that significantly outperform traditional POSIX-based protocols like NFS or SMB, which are sensitive to network latency and can experience severe throughput degradation over long distances.
- **Decoupled staging and import**: Uploading data to Blob Storage first allows you to stage data independently of the Azure Managed Lustre file system, validate the transfer, and then import at a convenient time.

### Migration steps

The migration process consists of two main steps:

1. **Upload data to Azure Blob Storage**: Use AzCopy to copy data from your on-premises POSIX file system to an Azure Blob Storage container. AzCopy preserves POSIX properties such as ownership, permissions, and timestamps during the transfer.
1. **Import data into Azure Managed Lustre**: Use an import job to bring data from the blob container into your Azure Managed Lustre file system. POSIX attributes stored in the blob metadata are applied automatically during import.

## Prerequisites

Before you start the migration, make sure you have the following resources and configurations in place:

- **Azure Managed Lustre file system**: An existing file system with blob integration configured. Blob integration must be configured at file system creation time and can't be added later. If you don't have a file system yet, see [Create an Azure Managed Lustre file system](create-file-system-portal.md) and make sure to enable blob integration during the creation process. For more information, see [Azure Blob Storage integration](amlfs-overview.md#azure-blob-storage-integration).
- **Azure Blob Storage account**: A storage account with a blob container configured for use with Azure Managed Lustre. For more information, see [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites).
- **AzCopy**: Install version 10.32.2 or later on your on-premises system. To download and install AzCopy, see [Get started with AzCopy](/azure/storage/common/storage-use-azcopy-v10).
- **Authentication**: AzCopy must be authorized to access the storage account. You can use Microsoft Entra ID or a shared access signature (SAS) token. For more information, see [Authorize AzCopy](/azure/storage/common/storage-use-azcopy-v10#authorize-azcopy).

## Step 1: Upload data to Azure Blob Storage with POSIX properties

Use AzCopy to upload data from your on-premises POSIX file system to an Azure Blob Storage container. To preserve POSIX properties during the transfer, use the `--preserve-posix-properties` and `--posix-properties-style amlfs` flags.

The `--preserve-posix-properties` flag instructs AzCopy to preserve POSIX properties, including owner, group, permissions, and timestamps. The `--posix-properties-style amlfs` flag ensures that the POSIX properties are stored in the format that Azure Managed Lustre expects. The `--include-directory-stub` flag instructs AzCopy to create a directory stub (a zero-length blob) for each directory during the upload. These directory stubs store directory-level POSIX metadata so that Azure Managed Lustre can correctly reconstruct the directory permissions during import.

### Use azcopy copy

The `azcopy copy` command copies data from a source to a destination. Use `azcopy` 10.32.2 or later to perform a full data transfer from your on-premises file system to the blob container.

```bash
# Requires AzCopy v10.32.2 or later. Verify with: azcopy --version
azcopy copy '/path/to/local/directory' 'https://<storage-account>.blob.core.windows.net/<container>/<path>' \
    --preserve-posix-properties \
    --posix-properties-style amlfs \
    --include-directory-stub \
    --recursive
```

Replace the following values:

- `/path/to/local/directory`: The path to the source data on your on-premises POSIX file system.
- `<storage-account>`: The name of your Azure Storage account.
- `<container>`: The name of the blob container.
- `<path>`: The optional destination path within the blob container.

For example, to copy the `/data/hpc-workload` directory to a container named `lustre-data`:

```bash
# Requires AzCopy v10.32.2 or later. Verify with: azcopy --version
azcopy copy '/data/hpc-workload' 'https://mystorageaccount.blob.core.windows.net/lustre-data/' \
    --preserve-posix-properties \
    --posix-properties-style amlfs \
    --include-directory-stub \
    --recursive
```

> [!IMPORTANT]
> By default, `azcopy copy` creates the source directory name as a subdirectory at the destination. In the previous example, the data is uploaded to `lustre-data/hpc-workload/`. You can control this behavior in two ways:
>
> - **Use the `--as-subdir=false` flag**: This flag tells AzCopy to copy only the *contents* of the source directory to the destination without creating the parent directory. For example:
>
>   ```bash
>   # Requires AzCopy v10.32.2 or later. Verify with: azcopy --version
>   azcopy copy '/data/hpc-workload' 'https://mystorageaccount.blob.core.windows.net/lustre-data/' \
>       --preserve-posix-properties \
>       --posix-properties-style amlfs \
>       --include-directory-stub \
>       --recursive \
>       --as-subdir=false
>   ```
>
>   In this case, files and subdirectories inside `hpc-workload` are uploaded directly under `lustre-data/`.
>
> - **Use a wildcard as source** (for example, `/data/hpc-workload/*`): AzCopy copies only the *contents* of the directory without creating the parent directory at the destination, similar to using `--as-subdir=false`.
>
> Choose the appropriate approach based on the directory structure you want in the blob container. This structure is replicated when you import the data into Azure Managed Lustre.

### Use azcopy sync

The `azcopy sync` command synchronizes data between a source and a destination. Use this command for ongoing or incremental transfers where you want to keep the blob container synchronized with changes in your on-premises file system.

```bash
# Requires AzCopy v10.32.2 or later. Verify with: azcopy --version
azcopy sync '/path/to/local/directory' 'https://<storage-account>.blob.core.windows.net/<container>/<path>' \
    --preserve-posix-properties \
    --posix-properties-style amlfs \
    --include-directory-stub
```

For example, to synchronize the `/data/hpc-workload` directory with a container named `lustre-data`:

```bash
# Requires AzCopy v10.32.2 or later. Verify with: azcopy --version
azcopy sync '/data/hpc-workload' 'https://mystorageaccount.blob.core.windows.net/lustre-data/' \
    --preserve-posix-properties \
    --posix-properties-style amlfs \
    --include-directory-stub
```

> [!NOTE]
> The `azcopy sync` command compares file names and last modified timestamps to determine which files need to be transferred. Only new or updated files are transferred, which makes sync operations faster for incremental updates.

> [!IMPORTANT]
> Unlike `azcopy copy`, the `azcopy sync` command always synchronizes the *contents* of the source directory to the destination without creating a parent directory. For example, `azcopy sync '/data/hpc-workload' 'https://...blob.core.windows.net/lustre-data/'` uploads the contents of `hpc-workload` directly into `lustre-data/`, not into `lustre-data/hpc-workload/`. Make sure the destination path in the blob container reflects the directory structure you want in Azure Managed Lustre. For more information, see [Synchronize with Azure Blob storage by using AzCopy](/azure/storage/common/storage-use-azcopy-blobs-synchronize).

### Verify the upload

After the upload finishes, you can verify that the data was uploaded with the correct POSIX properties by listing the contents of the blob container:

```bash
# Requires AzCopy v10.32.2 or later. Verify with: azcopy --version
azcopy list 'https://<storage-account>.blob.core.windows.net/<container>/<path>' --properties
```

## Step 2: Import data into Azure Managed Lustre

After the data is uploaded to Azure Blob Storage with POSIX properties preserved, import the data into your Azure Managed Lustre file system by creating an import job. Azure Managed Lustre reads the POSIX attributes from the blob metadata and applies them to the files in the Lustre namespace.

You can create an import job at any time by following the steps in [Create an import job from Azure Blob Storage to a file system](create-import-job.md). If you configured blob integration during cluster creation, you can also import data during the initial setup.

For automated and continuous data synchronization from Blob Storage into Azure Managed Lustre, consider using the [auto-import feature](auto-import.md).

## Limitations

- **Symbolic links aren't preserved**: Azure Blob Storage doesn't support symbolic links (symlinks). Symlinks in the source POSIX file system are skipped during the AzCopy transfer and aren't migrated to the blob container or to Azure Managed Lustre. If your data relies on symlinks, you must restructure the data before migration or re-create the symlinks manually after the data is imported into the Azure Managed Lustre file system. For more information, see [Use Azure Blob Storage with Azure Managed Lustre](blob-integration.md).

## Tips and best practices

- **Test with a small dataset first**: Before migrating your full dataset, test the process with a small subset of files to verify that POSIX properties are preserved correctly.
- **Optimize transfer performance**: AzCopy automatically uses multiple concurrent connections. You can further tune performance by setting the `AZCOPY_CONCURRENCY_VALUE` environment variable based on your network bandwidth. For more information, see [Optimize the performance of AzCopy with Azure Storage](/azure/storage/common/storage-use-azcopy-optimize).
- **Use incremental sync for ongoing migrations**: If your on-premises data changes frequently, use `azcopy sync` for incremental updates instead of copying the entire dataset each time.
- **Monitor import jobs**: After creating an import job, monitor its progress in the Azure portal. For more information, see [Create an import job](create-import-job.md).

## Related content

- [Use Azure Blob Storage with Azure Managed Lustre](blob-integration.md)
- [Create an import job from Azure Blob Storage to a file system](create-import-job.md)
- [Use the auto-import feature in Azure Managed Lustre](auto-import.md)
- [Get started with AzCopy](/azure/storage/common/storage-use-azcopy-v10)
