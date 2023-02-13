---
title: Requirements for Azure Managed Lustre file systems (Preview)
description: Review requirements for accounts, networks, storage, access, and clients for Azure Managed Lustre file systems.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/13/2023
ms.reviewer: sethm
ms.date: 02/10/2023

# Intent: As an IT Pro, XXX.
# Keyword: 

---

# Requirements for Azure Managed Lustre file systems (Preview)

<!--SOURCE: Sort out requirements from Prerequisites. See amlfs-prerequisites.md for source.-->

An Azure Managed Lustre file system has the following requirements for accounts, networks, storage, access, and client software.<!--Placeholder.-->

## Account requirements

In development.


## Network requirements


### Subnet size

Each Azure Managed Lustre system you create must have its own unique subnet. You can't move an Azure Managed Lustre file system from one network or subnet to another after you create the file system.

The size of subnet that you need depends on the size of the file system you create. The following table gives a rough estimate of the minimum subnet size for an Azure Managed Lustre file system based on the storage capacity of the file system.

| Storage capacity | Recommended CIDR prefix value |
|------------------|-------------------------------|
| 4 to 16 TiB      | /27 or larger                 |
| 20 to 40 TiB     | /26 or larger                 |
| 44 to 92 TiB     | /25 or larger                 |
| 96 to 196 TiB    | /24 or larger                 |
| 200 to 400 TiB   | /23 or larger                 |

### Access and permissions for the subnet

XXX

## Storage requirements



## Supported storage account types

The following storage account types can be used with Azure Managed Lustre file systems.

| Storage account type  | Redundancy                          |
|-----------------------|-------------------------------------|
| Standard              | Locally redundant storage (LRS), geo-redundant storage (GRS)<br><br>Zone-redundant storage (ZRS), read-access-geo-redundant storage (RAGRS), geo-zone-redundant storage (GZRS), read-access-geo-zone-redundant storage (RA-GZRS) <!--Spell out on first mention-->|
| Premium - Block blobs | LRS, ZRS                            |

For more information about storage account types, see [Types of storage accounts](/azure/storage/common/storage-account-overview#types-of-storage-accounts).

## Required access permissions

XXX

### Supported client software

XXX

### Compatible Kubernetes versions

The following container images are compatible with Azure Managed Lustre file systems.

| CSI driver version | Container image                                             | Supported Kubernetes version | Lustre client version |
|--------------------|-------------------------------------------------------------|------------------------------|-----------------------|
| main branch        | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:latest | 1.21 or later | 2.15.1 |
| v0.1.5             | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.5 | 1.21 or later | 2.15.1 |
