---
title: Prerequisites for Azure Managed Lustre file systems (Preview)
description: TK
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/09/2023
ms.reviewer: sethm
ms.date: 02/09/2023

# Intent: As an IT Pro, XXX.
# Keyword: 

---

# Azure Managed Lustre file system prerequisites (Preview)

<!--Text imported as is from "Prerequisites" for private preview. Links haven't been updated. Requirements will move to new Requirements doc for public preiew.-->

This article explains prerequisites that you must configure before creating an Azure Managed Lustre file system.

* [Network prerequisites](#network-prerequisites)
* [Storage prerequisites](#storage-prerequisites)

## Network prerequisites

Azure Managed Lustre file systems exist in a virtual network subnet. The subnet contains the Lustre Management Service (MGS) and handles all of the client interactions with the virtual Lustre cluster.

Each file system you create must have its own unique subnet.

The size of the subnet depends on the size of the file system you create. As a rough estimate, consider these values as minimum subnet sizes for an Azure Managed Lustre file system with the listed storage capacity:

| Capacity in TiB | Recommended CIDR prefix value |
|---|---|
| 4 to 16 TiB | /27 or larger |
| 20 to 40 TiB | /26 or larger |
| 44 to 92 TiB | /25 or larger |
| 96 to 196 TiB | /24 or larger |
| 200 to 400 TiB | /23 or larger |

Also read [Additional network size requirements](#additional-network-size-requirements), below, to learn about other services that can share the capacity of your VNet and subnet.

The subnet also needs the following access and permissions:

* The file system must be able to create NICs on its subnet.

* **DNS access** - You can use the default Azure-based DNS server.

* **Azure Queue Storage service access** - Azure Managed Lustre uses the queues service to communicate configuration and state information. There are two ways to configure access:

  * Option 1: Add a private endpoint for Azure Storage in your subnet

  * Option 2: Individually configure firewall rules to allow the following access:

    * TCP port 443 for secure traffic to any host in the domain queue.core.windows.net (``*.queue.core.windows.net``), and
    * TCP port 80 - for access to certificate revocation list (CRL) and online certificate status protocol (OCSP) servers.

    Contact your Azure Managed Lustre team if you need help with this requirement.

* **Azure cloud service access** - Configure your network security group to permit the Azure Managed Lustre file system to access Azure cloud services from within the file system subnet.

  Add an outbound security rule with the following properties:
  * **Source**: Service tag
  * **Source service tag**: AzureCloud

  [Read about Virtual network service tags](https://docs.microsoft.com/azure/virtual-network/service-tags-overview) to learn more.

* **Lustre network port access** - Make sure your network security group allows inbound and outbound access on port 988. The default rules ``65000
AllowVnetInBound`` and ``65000 AllowVnetOutBound`` meet this requirement.

* **Storage access** - If you use Azure Blob storage integration, an Azure Storage endpoint is required so that file system can access the storage.

* If using customer-managed encryption keys, the file system must be able to access the associated Azure Key Vault.

Azure Managed Lustre supports IPv4 only.

After you create your Azure Managed Lustre file system, several new network interfaces appear in the file system's resource group. Their names start with amlfs- and end with -snic. Don't change settings on these interfaces - specifically, leave the **Accelerated networking** setting at its default value, ``enabled``. Disabling accelerated networking on these network interfaces degrades your file system's performance. <!-- possible future move to an about "system elements" feature along with the disk redundancy info? also system size information for choosing sku -->

### Additional network size requirements

When planning your VNet and subnet, take into account the requirements for any other services you want to locate within the Azure Managed Lustre subnet or VNet. For example, consider these factors:

* If using an Azure Kubernetes Service (AKS) cluster with your Azure Managed Lustre file system, you can locate the AKS cluster in the same subnet as the managed Lustre system. In that case, you need to provide sufficient IP addresses for the AKS nodes and pods in addition to the address space for the Lustre file system.

  Read [AKS subnet access](csi-driver-overview.md#provide-subnet-access-between-aks-and-azure-managed-lustre) to learn more about network strategies for Azure Managed Lustre and AKS.

* If you use more than one AKS cluster within the VNet, make sure the VNet has sufficient capacity for all of the resources in all of the clusters.

* If you plan to use another resource to host your compute VMs in the same VNet, check the requirements for that process before creating the VNet and subnet for your Azure Managed Lustre system.

You cannot move an Azure Managed Lustre file system from one network or subnet to another after you create it.

## Storage prerequisites

This section explains prerequisites for integrating Azure Blob storage containers with Azure Managed Lustre.

An integrated blob container can automatically import files to the Azure Managed Lustre system at create time. You can create archive jobs to export changed files from your Lustre system to that container.

If you don't add an integrated blob container when you create your Lustre system, you can write your own client scripts or commands to move files between your Azure Managed Lustre file system and other storage.

It's also important to understand the differences in how metadata is handled in hierarchical and non-hierarchical blob storage. [Read Understand hierarchical and non-hierarchical storage schemas](blob-integration.md#understand-hierarchical-and-non-hierarchical-storage-schemas) to learn more.

Create these items before you start to create an Azure-Managed Lustre file system:

* A storage account that meets these requirements:

  * A compatible [storage account type](#supported-storage-account-types)
  * [Public endpoint](#account-access)
  * [Access roles](#set-access-roles) that permit the Azure Managed Lustre system to modify data

* A data container in the storage account, populated with the files that you want to use in the Azure Managed Lustre system. (You can add files to the Lustre file system later from clients, but files added to the original blob container after creation aren't imported to the Azure Managed Lustre file system.)

* A logging container in the storage account, for import/export logs. This must be a different container than the data container.

[//]: # (Test of user-invisible comment!)  

### Supported storage account types

To use a storage account with Azure Managed Lustre, it must be one of these types.

| Performance | Redundancy |
|-----|-----|
| Standard | LRS, GRS, ZRS, RAGRS, GZRS, RA-GZRS |
| Premium - Block blobs | LRS, ZRS|

### Account access

Storage accounts must be configured with a public endpoint, but you can restrict it to only accept traffic from the file system subnet.

> **TIP:**
> Create the subnet first so that you can configure the restricted access when you create the storage account.

This configuration is needed because copying tools and agents currently are hosted in an infrastructure subscription, not within the customer's subscription.

### Set access roles

Azure Managed Lustre needs authorization to access your storage account. Use [Azure role-based access control (Azure RBAC)](https://docs.microsoft.com/azure/role-based-access-control/) to give the file system access to your blob storage.

A storage account owner must explicitly add these roles:

* [Storage Account Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#storage-account-contributor)
* [Storage Blob Data Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor)

Add the roles for the service principal "HPC Cache Resource Provider". Specific steps are below.

You must add the roles before you create your Lustre file system. If the file system can't access your blob container, the creation task will fail. The validation done before creating the file system can't detect container access permission problems.

Keep in mind that it can take up to five minutes for the role settings to propagate through the Azure environment.

1. Open **Access control (IAM)** for your storage account.

1. Select **Add** > **Add role assignment** to open the Add role assignment page.

1. Assign the following roles, one at a time. For detailed steps, see [Assign Azure roles using the Azure portal](https://docs.microsoft.com/azure/role-based-access-control/role-assignments-portal).

    | Setting | Value |
    | --- | --- |
    | Roles | [Storage Account Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#storage-account-contributor) <br/>  [Storage Blob Data Contributor](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor)|
    | Assign access to | HPC Cache Resource Provider |

   > **NOTE:**
   >
   > If you can't find the HPC Cache Resource Provider, try a search for the string "storagecache" instead. "storagecache Resource Provider" was a pre-GA name for the service principal.

## Azure Key Vault integration requirements (optional)

If you want to control the encryption keys that are used on your Azure Managed Lustre files, there are some items you should prepare before you create the file system.

Using customer-managed keys is optional; all data stored in Azure is encrypted with Microsoft-managed keys by default. Read [Azure storage encryption](<https://learn.microsoft.com/azure/storage/common/storage-service-encryption>) to learn more.

Read [Use customer-managed encryption keys with Azure Managed Lustre](customer-keys-amlfs.md) for more information, including complete prerequisites.

Customer-managed keys must be provided in an Azure Key Vault. Prepare these requirements before you create your Azure Managed Lustre system:

* Create an Azure Key Vault. You can create a new key vault and keys when you create the file system, but you should at least familiarize yourself with these requirements ahead of time:

  * The key vault must be in the same subscription and region as the Azure Managed Lustre file system.
  * Enable soft delete and purge protection on the key vault.
  * Provide network access between the key vault and the Azure Managed Lustre file system.
  * Keys must be 2048-bit RSA keys.

  Refer to [Use customer-managed encryption keys with Azure Managed Lustre](customer-keys-amlfs.md) for additional Azure Key Vault requirements.

* Create a user-assigned managed identity for the file system to use when accessing the key vault. Read [What are managed identities for Azure resources?](<https://learn.microsoft.com/azure/active-directory/managed-identities-azure-resources/overview>) to learn more.

* Make sure that the user who creates the Azure Managed Lustre file system has sufficient privileges to manage the key vault ([Key Vault contributor role](<https://learn.microsoft.com/azure/role-based-access-control/built-in-roles#key-vault-contributor>).) Read more about key vault access in [Use customer-managed encryption keys with Azure Managed Lustre](customer-keys-amlfs.md).
