---
title: Prerequisites for Azure Managed Lustre file systems (Preview)
description: Network and storage prerequisites to complete before you create an Azure Managed Lustre file system.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/14/2023
ms.reviewer: mayabishop
ms.date: 02/09/2023

# Intent: As an IT Pro, I  need to understand network and storage requirements for using an Azure Managed Lustre file system, and I need to configure what I need.
# Keyword: 

---

# Azure Managed Lustre file system prerequisites (Preview)

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

Also read [Additional network size requirements](#additional-network-size-requirements), below, to learn about other services that can share the capacity of your virtual network and subnet.

The subnet for the Azure Managed Lustre file system needs the following access and permissions:

* The file system must be able to create NICs on its subnet.<!--Is this a reference to a "virtual NIC"? What setting is required?-->

* Azure Managed Lustre supports IPv4 only.<!--Placement: More protocol than access and permissions?-->

| Access type | Required network settings |
|-------------|---------------------------|
|Create NICs  |The file system must be able to create network interface cards (NICs) on its subnet. <!--Role or permission? Where is it set? 2) Link to more info about NIC requirements for the Azure Managed Lustre file system.-->|
| DNS access  |You can use the default Azure-based DNS server.<!--Will customers want to use their own DNS server?-->|
| Azure Queue Storage service access |Azure Managed Lustre uses the Azure Queue Storage service to communicate configuration and state information. You can configure access in two ways:<br><br>Option 1: Add a private endpoint for Azure Storage to your subnet. LINK TO PROCEDURE.<br><br>Option 2: Configure firewall rules to allow the following access:<br>- TCP port 443, for secure traffic to any host in the queue.core.windows.net domain (`*.queue.core.windows.net`)<br>- TCP port 80, for access to the certificate revocation list (CRL) and online certificate status protocol (OCSP) servers.<br><br>Contact your Azure Managed Lustre team if you need help with this requirement.|
|Azure cloud service access | Configure your network security group to permit the Azure Managed Lustre file system to access Azure cloud services from within the file system subnet.<br><br>Add an outbound security rule with the following properties:<br>- **Source**: Service tag<br>- **Source service tag**: AzureCloud<br><br>For more information, see [Virtual network service tags](/azure/virtual-network/service-tags-overview).|
|Lustre network port access| Your network security group must allow inbound and outbound access on port 988.<br>The default rules `65000 AllowVnetInBound` and `65000 AllowVnetOutBound` meet this requirement.|
|Storage access |If you use Microsoft Azure Blob Storage integration with your Azure Managed Lustre file system, configure an Azure Storage endpoint so the file system can access the storage.<!--Where to configure this?-->
| Customer-managed encryption keys |If you use customer-managed encryption keys for you Azure Managed Lustre files, the file system must be able to access the associated Azure key vault.<!--What to configure?-->|

After you create your Azure Managed Lustre file system, several new network interfaces appear in the file system's resource group. Their names start with **amlfs-** and end with **-snic**. Don't change any settings on these interfaces. Specifically, leave the default value, **enabled**, for the **Accelerated networking** setting. Disabling accelerated networking on these network interfaces degrades your file system's performance.<!--Placement? This is a verification step for a successful Azure Managed Lustre file system deployment. Move to the quickstart?-->

### Additional network size requirements

When planning your VNet and subnet, take into account the requirements for any other services you want to locate within the Azure Managed Lustre subnet or VNet. For example, consider these factors:

* If using an Azure Kubernetes Service (AKS) cluster with your Azure Managed Lustre file system, you can locate the AKS cluster in the same subnet as the managed Lustre system. In that case, you must provide enough IP addresses for the AKS nodes and pods in addition to the address space for the Lustre file system.

  To learn more about network strategies for Azure Managed Lustre and AKS, see [AKS subnet access](use-csi-driver-kubernetes.md#provide-subnet-access-between-aks-and-azure-managed-lustre).

* If you use more than one AKS cluster within the VNet, make sure the VNet has enough capacity for all resources in all of the clusters.

* If you plan to use another resource to host your compute VMs in the same VNet, check the requirements for that process before creating the VNet and subnet for your Azure Managed Lustre system.

## Storage prerequisites

This section explains prerequisites for integrating Microsoft Azure Blob Storage containers with Azure Managed Lustre.

An integrated blob container can automatically import files to the Azure Managed Lustre system when you create the file system. You can then create archive jobs to export changed files from your Azure Managed Lustre file system to that container.

If you don't add an integrated blob container when you create your Lustre system, you can write your own client scripts or commands to move files between your Azure Managed Lustre file system and other storage.

It's also important to understand the differences in how metadata is handled in hierarchical and non-hierarchical blob storage. For more information, see [Understand hierarchical and non-hierarchical storage schemas](blob-integration.md#understand-hierarchical-and-non-hierarchical-storage-schemas).<!--Why is this important? Advanced feature? Explain why in full procedrues.-->

Create these items before you create an Azure-Managed Lustre file system:

* A storage account that meets the following requirements:

  * A compatible storage account type. See [storage account types](amlfs-requirements.md#supported-storage-account-types) for more information.
  * [A public endpoint](#account-access).
  * [Access roles](#set-access-roles) that permit the Azure Managed Lustre system to modify data.

* A data container in the storage account that contains the files you want to use in the Azure Managed Lustre file system.

  You can add files to the file system later from clients. However, files added to the original blob container after you create the file system won't be imported to the Azure Managed Lustre file system.

* A logging container for import/export logs in the storage account. The import/export logs must be stored in a different container from the data container.<!--Is there a special type of container called a "logging container," or is this just a separate container for logs?-->

### Supported storage account types

The following storage account types can be used with Azure Managed Lustre.

| Performance | Redundancy |
|-----|-----|
| Standard | LRS, GRS, ZRS, RAGRS, GZRS, RA-GZRS |
| Premium - Block blobs | LRS, ZRS|

### Storage account access

Storage accounts used with an Azure Managed Lustre file system must be configured with a public endpoint. However, you can restrict the endpoint to only accept traffic from the file system subnet. This configuration is needed because agents and copying tools are hosted in an infrastructure subscription, not within the customer's subscription.

> [!TIP]
> If you create the subnet before you create the storage account, you can configure restricted access when you create the storage account.

### Set access roles

Azure Managed Lustre needs authorization to access your storage account. Use [Azure role-based access control (Azure RBAC)](/azure/role-based-access-control/) to give the file system access to your blob storage.

A storage account owner must add these roles before creating the file system:

* [Storage Account Contributor](/azure/role-based-access-control/built-in-roles#storage-account-contributor)
* [Storage Blob Data Contributor](/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor)

> [!IMPORTANT]
> You must add these roles before you create your Azure Managed Lustre file system. If the file system can't access your blob container, file system creation fails. Validation performed before the file system is created can't detect container access permission problems. It can take up to five minutes for the role settings to propagate through the Azure environment.

To add the roles for the service principal **HPC Cache Resource Provider**, do these steps:

1. Open **Access control (IAM)** for your storage account.

1. Select **Add** > **Add role assignment** to open the **Add role assignment** page.

1. Assign each of the following roles, and grant access to the **HPC Cache Resource Provider**. For detailed steps, see [Assign Azure roles using the Azure portal](/azure/role-based-access-control/role-assignments-portal).

    | Setting             | Values                      |
    |---------------------|-----------------------------|
    | **Roles**           | [Storage Account Contributor](/azure/role-based-access-control/built-in-roles#storage-account-contributor)<br>[Storage Blob Data Contributor](/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor) |
    | **Assign access to** | HPC Cache Resource Provider<br>TIP: If you can't find the HPC Cache Resource Provider, search for **storagecache** instead. **storagecache Resource Provider** was the service principal name before general availability of the product.|

## Azure Key Vault integration requirements (optional)

<!--Exclude from Quickstart guide.-->

If you want to create and manage the encryption keys used on your Azure Managed Lustre files, you can add customer-managed keys to an Azure Key Vault before or during file system creation. You can create a new key vault and key when you create the file system, but you should be familiar with these requirements ahead of time. To add a key vault and keys when you create the file system, you must have permissions to manage key vault access.

Using customer-managed keys is optional. All data stored in Azure is encrypted with Microsoft-managed keys by default. For more information, see [Azure storage encryption](/azure/storage/common/storage-service-encryption).

For more information about requirements for using customer-managed encryption keys with an Azure Managed Lustre file system, including prerequisites, see [Use customer-managed encryption keys with Azure Managed Lustre](customer-managed-encryption-keys.md).

If you plan to use customer-managed encryption keys with your Azure Managed Lustre file system, complete the following prerequisites:

* Create an Azure key vault that meets the following requirements, either before or during file system creation:

  * The key vault must be in the same subscription and Azure region as the Azure Managed Lustre file system.
  * Enable **soft delete** and **purge protection** on the key vault.
  * Provide network access between the key vault and the Azure Managed Lustre file system.<!--How do they do this? They have to have configured the subnet for the file system before they do this?-->
  * Keys must be 2048-bit RSA keys.

  For more Azure Key Vault requirements, see [Use customer-managed encryption keys with Azure Managed Lustre](customer-managed-encryption-keys.md).

* Create a user-assigned managed identity for the file system to use when accessing the key vault. For more information, see [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview)

* Assign the [Key Vault contributor role](/azure/role-based-access-control/built-in-roles#key-vault-contributor) to the person who will create the Azure Managed Lustre file system. The Key vault contributor role is required in order to manage key vault access. For more information, see [Use customer-managed encryption keys with Azure Managed Lustre](customer-managed-encryption-keys.md).

## Next steps

* [Create an Azure Managed Lustre file system in the Azure portal](create-file-system-portal.md)
* [Create an Azure Managed Lustre file system using Azure Resource Manager templates](create-file-system-resource-manager.md)
