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

XXX

## Storage requirements



## Supported storage account types

The following storage account types can be used with Azure Managed Lustre.

| Performance           | Redundancy                          |
|-----------------------|-------------------------------------|
| Standard              | LRS, GRS, ZRS, RAGRS, GZRS, RA-GZRS <!--Spell out on first mention-->|
| Premium - Block blobs | LRS, ZRS                            |

## Required access permissions

XXX

### Supported client software

XXX

### Compatible Kubernetes versions

The following container images are compatible with the 

| CSI driver version | Container image                                             | Supported Kubernetes version | Lustre client version |
|--------------------|-------------------------------------------------------------|------------------------------|-----------------------|
| main branch        | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:latest | 1.21 or later | 2.15.1 |
| v0.1.5             | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.5 | 1.21 or later | 2.15.1 |
