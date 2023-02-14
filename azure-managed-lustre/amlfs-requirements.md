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


An Azure Managed Lustre file system has the following requirements for accounts, networks, storage, access, and client software.<!--Placeholder.-->

## Account requirements

IN DEVELOPMENT


## Network requirements

Each Azure Managed Lustre system you create must have its own unique subnet within an Azure Virtual Network. You can't move an Azure Managed Lustre file system from one network or subnet to another after you create the file system.

### Subnet size

The size of subnet that you need depends on the size of the file system you create. The following table gives a rough estimate of the minimum subnet size for an Azure Managed Lustre file system based on the storage capacity of the file system.

| Storage capacity | Recommended CIDR prefix value |
|------------------|-------------------------------|
| 4 to 16 TiB      | /27 or larger                 |
| 20 to 40 TiB     | /26 or larger                 |
| 44 to 92 TiB     | /25 or larger                 |
| 96 to 196 TiB    | /24 or larger                 |
| 200 to 400 TiB   | /23 or larger                 |

### Other subnet size considerations

When you plan your virtual network and subnet, take into account the requirements of any other services you will locate within the Azure Managed Lustre subnet or virtual network:

* If you're using an Azure Managed Lustre file system with an Azure Kubernetes Service (AKS) cluster:

  * You can locate the AKS cluster in the same subnet as the managed Lustre file system. In that case, you must provide enough IP addresses for the AKS nodes and pods in addition to the address space for the Lustre file system.

  * If you use more than one AKS cluster within the virtual network, make sure the virtual network has enough capacity for all resources in all of the clusters.

  To learn more about network strategies for Azure Managed Lustre and AKS, see [AKS subnet access](use-csi-driver-kubernetes.md#provide-subnet-access-between-aks-and-azure-managed-lustre).

* If you plan to use another resource to host your compute VMs in the same virtual network, check the requirements for that process before you create the virtual network and subnet for your Azure Managed Lustre system.<!--Assumption: The compute VMs may not be associated with AKS.-->

### Access and permissions for the subnet

XXX

## Storage requirements

To provide storage for an Azure Managed Lustre file system, you must use an Azure storage account and configure the roles and access permissions needed to authorize storage access for the file system.

## Supported storage account types

The following storage account types can be used with Azure Managed Lustre file systems.

| Storage account type  | Redundancy                          |
|-----------------------|-------------------------------------|
| Standard              | Locally redundant storage (LRS), geo-redundant storage (GRS)<br><br>Zone-redundant storage (ZRS), read-access-geo-redundant storage (RAGRS), geo-zone-redundant storage (GZRS), read-access-geo-zone-redundant storage (RA-GZRS) |
| Premium - Block blobs | LRS, ZRS |

For more information about storage account types, see [Types of storage accounts](/azure/storage/common/storage-account-overview#types-of-storage-accounts).

<!--Do we need to provide sizing or pricing advice?-->

## Azure storage access

- Storage accounts used with an Azure Managed Lustre file system must be configured with a public endpoint. However, you can restrict the endpoint to only accept traffic from the file system subnet.<!--Give an example setting?--> This configuration is needed because agents and copying tools are hosted in an infrastructure subscription, not within the customer's subscription.<!--Link to instructions. How do they restrict access to accept only traffic from the file system subnet? Specifics should be in "Prerequisites."-->

- To authorize access to your Azure storage by the Azure Managed Lustre file system, the following roles and access must be configured.

  |Object type     | Role/access |
  |----------------|-------------|
  |storage account |[Storage Account Contributor](/azure/role-based-access-control/built-in-roles#storage-account-contributor)<br>
[Storage Blob Data Contributor](/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor)|
  |service principle | Assign access to: **HPC Cache Resource Provider**|

### Supported client software

Each client that connects to the Azure Managed Lustre file system must have a Lustre client package that's compatible with the file system's Lustre version (currently 2.15). Pre-built and tested client packages for Azure Managed Lustre can be downloaded from the Linux Software Repository for Microsoft Products - GET A LINK.

Packages and kernel modules are available for the following Linux operating systems.

|Client operating system | Supported versions |
|------------------------|--------------------|
|Red Hat                 |Red Hat Enterprise Linux (RHEL) 8<br>Red Hat Enterprise Linux (RHEL) 7|
|Ubuntu                  |Ubuntu 22.04<br>Ubuntu 20.04<br>Ubuntu 18.04|

To find out how to install a Lustre client, update a client to the current release, and mount a client to the Azure Managed Lustre file system, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md).

### Compatible Kubernetes versions

The following container images are compatible with Azure Managed Lustre file systems.

| CSI driver version | Container image                                             | Supported Kubernetes version | Lustre client version |
|--------------------|-------------------------------------------------------------|------------------------------|-----------------------|
| main branch        | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:latest | 1.21 or later | 2.15.1 |
| v0.1.5             | mcr.microsoft.com/oss/kubernetes-csi/azurelustre-csi:v0.1.5 | 1.21 or later | 2.15.1 |

## Next steps

- [Complete prerequisites for an Azure Managed Lustre file system](amlfs-prerequisites.md)
- [Learn about network strategies for Azure Managed Lustre and AKS](use-csi-driver-kubernetes.md#provide-subnet-access-between-aks-and-azure-managed-lustre)
