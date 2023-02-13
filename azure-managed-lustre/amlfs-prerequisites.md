---
title: Prerequisites for Azure Managed Lustre file systems (Preview)
description: Network and storage prerequisites to complete before you create an Azure Managed Lustre file system.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/13/2023
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

Each file system you create must have its own unique subnet. You can't move a file system from one network or subnet to another after you create the file system.

The size of subnet that you need depends on the size of the file system you create. The following table gives a rough estimate of the minimum subnet size for an Azure Managed Lustre file system based on the storage capacity of the file system.

| Storage capacity | Recommended CIDR prefix value |
|------------------|-------------------------------|
| 4 to 16 TiB      | /27 or larger                 |
| 20 to 40 TiB     | /26 or larger                 |
| 44 to 92 TiB     | /25 or larger                 |
| 96 to 196 TiB    | /24 or larger                 |
| 200 to 400 TiB   | /23 or larger                 | 

Also read [Additional network size requirements](#additional-network-size-requirements), below, to learn about other services that can share the capacity of your VNet and subnet.

The subnet also needs the following access and permissions:

* The file system must be able to create NICs on its subnet.

* **DNS access** - You can use the default Azure-based DNS server.

* **Azure Queue Storage service access** - Azure Managed Lustre uses the queues service,<!--Get service name spelling.--> to communicate configuration and state information. There are two ways to configure access:

  * Option 1: Add a private endpoint for Azure Storage in your subnet.

  * Option 2: Configure firewall rules to allow the following access:

    * TCP port 443, for secure traffic to any host in the queue.core.windows.net domain (`*.queue.core.windows.net`)
    * TCP port 80, for access to the certificate revocation list (CRL) and online certificate status protocol (OCSP) servers.

    Contact your Azure Managed Lustre team if you need help with this requirement.

* **Azure cloud service access** - Configure your network security group to permit the Azure Managed Lustre file system to access Azure cloud services from within the file system subnet.

  Add an outbound security rule with the following properties:
  * **Source**: Service tag
  * **Source service tag**: AzureCloud

  For more information, see [Virtual network service tags](/azure/virtual-network/service-tags-overview).

* **Lustre network port access** - Make sure your network security group allows inbound and outbound access on port 988. The default rules `65000 AllowVnetInBound` and `65000 AllowVnetOutBound` meet this requirement.

* **Storage access** - If you use Microsoft Azure Blob Storage integration, an Azure Storage endpoint is required so that file system can access the storage.

* If you use customer-managed encryption keys, the file system must be able to access the associated Azure key vault.

* Azure Managed Lustre supports IPv4 only.

After you create your Azure Managed Lustre file system, several new network interfaces appear in the file system's resource group. Their names start with **amlfs-** and end with **-snic**. Don't change any settings on these interfaces. Specifically, leave the default value, **enabled**, for the **Accelerated networking** setting. Disabling accelerated networking on these network interfaces degrades your file system's performance.

### Additional network size requirements

When planning your VNet and subnet, take into account the requirements for any other services you want to locate within the Azure Managed Lustre subnet or VNet. For example, consider these factors:

* If using an Azure Kubernetes Service (AKS) cluster with your Azure Managed Lustre file system, you can locate the AKS cluster in the same subnet as the managed Lustre system. In that case, you must provide enough IP addresses for the AKS nodes and pods in addition to the address space for the Lustre file system.

  To learn more about network strategies for Azure Managed Lustre and AKS, see [AKS subnet access](use-csi-driver-kubernetes.md#provide-subnet-access-between-aks-and-azure-managed-lustre) .

* If you use more than one AKS cluster within the VNet, make sure the VNet has enough capacity for all resources in all of the clusters.

* If you plan to use another resource to host your compute VMs in the same VNet, check the requirements for that process before creating the VNet and subnet for your Azure Managed Lustre system.

## Storage prerequisites

This section explains prerequisites for integrating Microsoft Azure Blob Storage containers with Azure Managed Lustre.

An integrated blob container can automatically import files to the Azure Managed Lustre system when you create the file system. You can then create archive jobs to export changed files from your Azure Managed Lustre file system to that container.

If you don't add an integrated blob container when you create your Lustre system, you can write your own client scripts or commands to move files between your Azure Managed Lustre file system and other storage.

It's also important to understand the differences in how metadata is handled in hierarchical and non-hierarchical blob storage. For more information, see [Understand hierarchical and non-hierarchical storage schemas](blob-integration.md#understand-hierarchical-and-non-hierarchical-storage-schemas).

Create these items before you create an Azure-Managed Lustre file system:

* A storage account that meets the following requirements:

  * A compatible storage account type. For more information, see [storage account types](amlfs-requirements.md#supported-storage-account-types)
  * [Public endpoint](#account-access)
  * [Access roles](#set-access-roles) that permit the Azure Managed Lustre system to modify data

* A data container in the storage account, which contains the files that you want to use in the Azure Managed Lustre system. You can add files to the Lustre file system later from clients, but files added to the original blob container after the file system is created won't be imported to the Azure Managed Lustre file system.

* A logging container for import/export logs in the storage account. The import/export logs must be stored in a different container from the data container.

### Supported storage account types

The following storage account types can be used with Azure Managed Lustre.

| Performance | Redundancy |
|-----|-----|
| Standard | LRS, GRS, ZRS, RAGRS, GZRS, RA-GZRS |
| Premium - Block blobs | LRS, ZRS|

### Account access

Storage accounts must be configured with a public endpoint, but you can restrict the endpoint to only accept traffic from the file system subnet. This configuration is needed because copying tools and agents currently are hosted in an infrastructure subscription, not within the customer's subscription.

> [!TIP]
> Create the subnet first so that you can configure the restricted access when you create the storage account.

### Set access roles

Azure Managed Lustre needs authorization to access your storage account. Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/) to give the file system access to your blob storage.

A storage account owner must explicitly add these roles:

* [Storage Account Contributor](/azure/role-based-access-control/built-in-roles#storage-account-contributor)
* [Storage Blob Data Contributor](/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor)

Add the roles for the service principal **HPC Cache Resource Provider**:

> [!IMPORTANT]
> You must add these roles before you create your Lustre file system. If the file system can't access your blob container, file system creation fails. Validation done before the file system is created can't detect container access permission problems. It can take up to five minutes for the role settings to propagate through the Azure environment.

1. Open **Access control (IAM)** for your storage account.

1. Select **Add** > **Add role assignment** to open the Add role assignment page.

1. Assign the following roles, one at a time. For detailed steps, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

    | Setting          | Values                      |
    |------------------|-----------------------------|
    | Roles            | [Storage Account Contributor](/azure/role-based-access-control/built-in-roles#storage-account-contributor) <br/>  [Storage Blob Data Contributor](/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor) |
    | Assign access to | HPC Cache Resource Provider |

   > [!NOTE]
   > If you can't find the HPC Cache Resource Provider, search for **storagecache** instead. **storagecache Resource Provider** was the service principal name before general availability.

## Azure Key Vault integration requirements (optional)

If you want to control the encryption keys used on your Azure Managed Lustre files, you must add the keys to an Azure Key Vault before you create the file system.

Using customer-managed keys is optional. All data stored in Azure is encrypted with Microsoft-managed keys by default. For more information, see [Azure storage encryption](/azure/storage/common/storage-service-encryption).

For more information about requirements for using customer-managed encryption keys with an Azure Managed Lustre file system, including prerequisites, see [Use customer-managed encryption keys with Azure Managed Lustre](customer-managed-encryption-keys.md).

Customer-managed keys must be provided in an Azure Key Vault. You can create a new key vault and keys when you create the file system, but you should be familiar with these requirements ahead of time. To add a key vault and keys when you create the file system, you'll need the required permissions to manage key vault access.

If you plan to use customer-managed encryption keys with your Azure Managed Lustre file system, Prepare these requirements before you create your Azure Managed Lustre system:

* Create an Azure key vault that meets the following requirements, either before or during file system creation:

  * The key vault must be in the same subscription and Azure region as the Azure Managed Lustre file system.
  * Enable **soft delete** and **purge protection** on the key vault.
  * Provide network access between the key vault and the Azure Managed Lustre file system.<!--How do they do this? They have to have configured the subnet for the file system before they do this?-->
  * Keys must be 2048-bit RSA keys.

  For more Azure Key Vault requirements, see [Use customer-managed encryption keys with Azure Managed Lustre](customer-managed-encryption-keys.md).

<!--They have to add the key to the key vault? Not explicitly stated.-->

* Create a user-assigned managed identity for the file system to use when accessing the key vault. For more information, see [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview)

* Assign the [Key Vault contributor role](/azure/role-based-access-control/built-in-roles#key-vault-contributor) to the person who will create the Azure Managed Lustre file system. The Key vault contributor role is required in order to manage key vault access. For more information, see [Use customer-managed encryption keys with Azure Managed Lustre](customer-managed-encryption-keys.md).

## Next steps

* [Create an Azure Managed Lustre file system in the Azure portal](create-file-system-portal.md)
* [Create an Azure Managed Lustre file system using Azure Resource Manager templates](create-file-system-resource-manager.md)
