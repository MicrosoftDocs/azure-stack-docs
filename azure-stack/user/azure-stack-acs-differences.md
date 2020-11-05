---
title: Azure Stack Hub storage differences and considerations
titleSuffix: Azure Stack Hub
description: Understand the differences between Azure Stack Hub storage and Azure storage, along with Azure Stack Hub deployment considerations.
author: mattbriggs

ms.topic: conceptual
ms.date: 5/27/2020
ms.author: mabrigg
ms.reviwer: jiahan
ms.lastreviewed: 08/12/2020

# Intent: As a < type of user >, I want < what? > so that < why? >
# Keyword: Azure Stack keyword

---

# Azure Stack Hub storage: Differences and considerations

Azure Stack Hub storage is the set of storage cloud services in Microsoft Azure Stack Hub. Azure Stack Hub storage provides blob, table, queue, and account management functionality with Azure-consistent semantics.

This article summarizes the known Azure Stack Hub Storage differences from Azure Storage services. It also lists things to consider when you deploy Azure Stack Hub. To learn about high-level differences between global Azure and Azure Stack Hub, see the [Key considerations](azure-stack-considerations.md) article.

## Cheat sheet: Storage differences

| Feature | Azure (global) | Azure Stack Hub |
| --- | --- | --- |
|File storage|Cloud-based SMB file shares supported. | Not yet supported.
|Azure storage service encryption for data at Rest|256-bit AES encryption. Support encryption using customer-managed keys in Key Vault.|BitLocker 128-bit AES encryption. Encryption using customer-managed keys isn't supported.
|Storage account type|General-purpose V1, V2, and Blob storage accounts. |General-purpose V1 only.
|Replication options|Locally redundant storage, geo-redundant storage, read-access geo-redundant storage, and zone-redundant storage. |Locally redundant storage.
|Premium storage|Provide high-performance and low-latency storage. Only support page blobs in premium storage accounts.|Can be provisioned, but no performance limit or guarantee. Wouldn't block using block blobs, append blobs, tables, and queues in premium storage accounts.
|Managed disks|Premium and standard supported. |Supported when you use version 1808 or later.
|Blob name|1,024 characters (2,048 bytes). |880 characters (1,760 bytes).
|Block blob max size|4.75 TB (100 MB X 50,000 blocks). |4.75 TB (100 MB x 50,000 blocks) for the 1802 update or newer version. 50,000 X 4 MB (approximately 195 GB) for previous versions.
|Page blob snapshot copy|Backup Azure unmanaged VM disks attached to a running VM supported. |Not yet supported.
|Page blob incremental snapshot copy|Premium and standard Azure page blobs supported. |Not yet supported.
|Page blob billing|Charges are incurred for unique pages, whether they're in the blob or in the snapshot. Wouldn't incur additional charges for snapshots associated with a blob until base blob being updated.|Charges are incurred for base blob and associated snapshots. Would incur additional charges for each individual snapshot.
|Storage tiers for blob storage|Hot, cool, and archive storage tiers.|Not yet supported.
|Soft delete for blob storage|General available. |Not yet supported.
|Page blob max size|8 TB. |1 TB. 
|Page blob page size|512 bytes. |4 KB. 
|Table partition key and row key size|1,024 characters (2,048 bytes).|400 characters (800 bytes).
|Blob snapshot|The max number of snapshots of one blob isn't limited.|The max number of snapshots of one blob is 1,000.
|Azure AD Authentication for storage|In preview. |Not yet supported.
|Immutable Blobs|General available. |Not yet supported.
|Firewall and virtual network rules for storage|General available. |Not yet supported.|

There are also differences with storage metrics:

* The transaction data in storage metrics doesn't differentiate internal or external network bandwidth.
* The transaction data in storage metrics doesn't include virtual machine access to the mounted disks.

## API version

The following versions are supported with Azure Stack Hub Storage:

Azure Storage services APIs:

2005 update or newer versions:

- [2019-02-02](/rest/api/storageservices/version-2019-02-02)
- [2018-11-09](/rest/api/storageservices/version-2018-11-09)
- [2018-03-28](/rest/api/storageservices/version-2018-03-28)
- [2017-11-09](/rest/api/storageservices/version-2017-11-09)
- [2017-07-29](/rest/api/storageservices/version-2017-07-29)
- [2017-04-17](/rest/api/storageservices/version-2017-04-17)
- [2016-05-31](/rest/api/storageservices/version-2016-05-31)
- [2015-12-11](/rest/api/storageservices/version-2015-12-11)
- [2015-07-08](/rest/api/storageservices/version-2015-07-08)
- [2015-04-05](/rest/api/storageservices/version-2015-04-05)

Previous versions:

- [2017-11-09](/rest/api/storageservices/version-2017-11-09)
- [2017-07-29](/rest/api/storageservices/version-2017-07-29)
- [2017-04-17](/rest/api/storageservices/version-2017-04-17)
- [2016-05-31](/rest/api/storageservices/version-2016-05-31)
- [2015-12-11](/rest/api/storageservices/version-2015-12-11)
- [2015-07-08](/rest/api/storageservices/version-2015-07-08)
- [2015-04-05](/rest/api/storageservices/version-2015-04-05)

Azure Storage services management APIs:

1811 update or newer versions:

- [2017-10-01](/rest/api/storagerp/)
- [2017-06-01](/rest/api/storagerp/)
- [2016-12-01](/rest/api/storagerp/)
- [2016-05-01](/rest/api/storagerp/)
- [2016-01-01](/rest/api/storagerp/)
- [2015-06-15](/rest/api/storagerp/)
- [2015-05-01-preview](/rest/api/storagerp/)

Previous versions:

- [2016-01-01](/rest/api/storagerp/)
- [2015-06-15](/rest/api/storagerp/)
- [2015-05-01-preview](/rest/api/storagerp/)

## PowerShell version

For the storage module PowerShell, be aware of the version that's compatible with the REST API.

| Module | Supported version | Usage |
|---|---|---|
| Azure.Storage | [4.5.0](https://www.powershellgallery.com/packages/Azure.Storage/4.5.0) | Manages blobs, queues, tables in Azure Stack Hub storage accounts. |
| AzureRM.Storage | [5.0.4](https://www.powershellgallery.com/packages/AzureRM.Storage/5.0.4) | Creates and manages storage accounts in Azure Stack Hub. |

For more information about Azure Stack Hub supported storage client libraries, see: [Get started with Azure Stack Hub storage development tools](azure-stack-storage-dev.md).

## Next steps

* [Get started with Azure Stack Hub Storage development tools](azure-stack-storage-dev.md)
* [Use data transfer tools for Azure Stack Hub storage](azure-stack-storage-transfer.md)
* [Introduction to Azure Stack Hub Storage](azure-stack-storage-overview.md)
