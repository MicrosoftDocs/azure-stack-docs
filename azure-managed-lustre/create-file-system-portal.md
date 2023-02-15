---
title: Create an Azure Managed Lustre file system in the Azure portal (Preview)
description: Create an Azure Managed Lustre file system from the Azure portal.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/15/2023
ms.reviewer: mayabishop
ms.date: 02/10/2023

# Intent: As an IT Pro, XXX.
# Keyword: 

---

# Create an Azure Managed Lustre file system (Preview)
<!--Dale's  is in progress. 2/22-->

Use the Azure portal to create an Azure Managed Lustre file system.

To find the **Create** wizard, search for **Azure Managed Lustre** or follow the link provided by your preview onboarding team.

To learn about using Azure Resource Manager templates for programmatic creation, see [Create a file system using Azure Resource Manager templates](create-file-system-resource-manager.md).

## Prerequisites

Before you start to create an Azure Managed Lustre file system:

1. Contact the Azure Managed Lustre team to sign up for the preview. FORM LINK WILL BE AVAILABLE ON 2/22.
1. Complete the prerequisites in [Azure Managed Lustre prerequisites](amlfs-prerequisites.md).

   After you create the file system, you can't change these items:

   * The size of the file system
   * The option to use an integrated Azure Blob Storage container
   * The choice between customer-managed or system-generated encryption keys for storage

   Plan these items carefully, and configure them correctly when you create your Azure Managed Lustre file system.

## Sign in to the Azure portal

1. Sign in to the [Azure portal](https://aka.ms/azureLustrePrivatePreview).
1. Select **+ Create a Resource**.
1. Type "azure managed lustre file system" in the search box, and press **Enter**. 
1. Select **Azure Managed Lustre File system (preview)**. Then select **Create**.
1. If you have signed up for the Azure Managed Lustre public preview, **Plan** will show **Azure Managed Lustre File System**. Click **Create** to continue.

## Basics

On the **Basics** tab, enter the following information.

### Project details

1. Select a subscription. <!--Subscription requirements?-->
1. In **Resource group**, select a resource group, or create a new one to use for this installation.
1. **Region** and **Availability zone** - Set the Azure region and zone (if supported) for your file system.

   For the public preview, Azure Managed Lustre is supported in these regions: Australia East, Canada Central, East US, East US 2, South Central US, UK South, West Europe, West US 2, and West US 3.<!--Update list for the public preview.-->

   For best performance, create your Azure Managed Lustre file system in the same region and availability zone where your client machines will be.

### File system details

Set the name and capacity of the Azure Managed Lustre file system.

* **File system name** - Choose a name to identify this file system in your list of resources.

* **File system type** - Select the type of infrastructure to use for the file system. For this preview, the file system type will be **Durable, SSD**.

* **Storage and throughput** - These settings set the size of your file system.

  Your file system size is determined by two factors: the amount of storage allocated for your data (storage capacity), and the maximum data transfer rate (throughput). You'll select one of these options. The other values are calculated based on the  **Throughput per TiB** setting for your file system type.

  To set your Azure Managed Lustre file system size, do these steps:
  
  1. Choose either **Storage capacity** or **Maximum throughput**.

  1. Enter your value in the writeable field - either your desired storage capacity (in TiB) or desired maximum throughput (in MB/second).

     > [!NOTE]
     > These values are rounded up to meet incremental size requirements. They are never rounded down, so make sure you check the final configuration to make sure it's cost-effective for your workload.

<!-- hpc cache text: 
capacity is a combination of two values:
- The maximum data transfer rate for the cache (throughput), in GB/second
- The amount of storage allocated for cached data, in TB -->

### Networking

In the **Networking** section:

1. Enter the virtual network and subnet that you configured earlier in [Network prerequisites](amlfs-prerequisites.md#network-prerequisites):

   * **Virtual network** - Select or create the network that will hold your Azure Managed Lustre file system.
   * **Subnet** - Select or create the subnet to use for file system interaction.

   The Azure Managed Lustre file system uses a dedicated virtual network (VNet) and one subnet. The subnet contains the Lustre Management Service (MGS), which handles all of the client interaction with the Azure Managed Lustre system.

1. Before proceeding, make sure the subnet has [enough IP addresses](amlfs-prerequisites.md#network-prerequisites) to handle the file system's load. When sizing the VNet and subnet, you also should consider the IP address requirements for any other services that you want to colocate with your Azure Managed Lustre file system. Also make sure you completed all access settings to enable the subnet to access the needed Azure services. To review networking requirements, see [Network prerequisites](amlfs-prerequisites.md#network-prerequisites) for more information about network sizing and other requirements.

1. After you enter your network settings, select <>

> [!NOTE]
> An earlier preview version required two subnets instead of one. Any references to a *management subnet* are remainders from that obsolete design.<!--Is note still needed?-->

## Advanced

Use the **Advanced** tab to set up blob storage integration and customize the maintenance window.

### Blob integration

Azure Managed Lustre is customized to work seamlessly with Azure Blob Storage. You can specify a populated blob container to make its data accessible from your Azure Managed Lustre file system, or specify an empty container that you populate with data or use to store your output. All of the setup and maintenance is done for you - you just need to specify the blob container to use.

Integrating blob storage at creation time is optional, but it's the only way to use Lustre Hierarchical Storage Management (HSM) features. If you don't want the benefits of Lustre HSM, you can import and export data for the Azure Managed Lustre file system by using client commands directly.

Read the [Lustre HSM documentation](https://doc.lustre.org/lustre_manual.xhtml#lustrehsm) to learn more about how Lustre HSM works.

> [!NOTE]
> If you want to use integrated Azure Blob storage with your Azure Managed Lustre file system, you must specify it in the **Blob integration** section when you create the file system. You can't add an HSM-integrated blob container after the file system exists.

To learn which types of accounts are compatible and what access settings need to be configured, see [Storage account prerequisites](amlfs-prerequisites.md#storage-prerequisites).

The storage account does not need to be in the same subscription that you use for the Azure Managed Lustre file system.

To configure blob integration:

1. Check the box marked **Import/export data from blob**.

1. Specify the subscription, storage account, and container to use with your Lustre file system.

1. In the **Logging container** field, select a container that the system will use to store import/export logs. This container must be different from the data container, but in the same storage account.

1. Optionally, specify a path for the import prefix, described below in [Understand the import prefix](#understand-the-import-prefix).

If you *only want to export* files from your Azure Managed Lustre system, set an import prefix that doesn't match any existing files in your blob container. Later, you can use archive jobs to move files into the blob container you specify here. Read [Use archive jobs to export data from Azure Managed Lustre](export-with-archive-jobs.md) for details.

#### Understand the import prefix
<!-- later problem because this is an aka link - needs to be a header for the anchor - but Microsoft docs won't allow H4's -->

The **import prefix** field determines what data is imported from your blob container when the system is created. This field can't be changed after you create the Azure Managed Lustre file system.

* In **import prefix**, supply a file path that matches data files in your container.

  When you create the Azure Managed Lustre file system, contents that match this prefix are added to a metadata record in the file system. When clients request a file, its contents are retrieved from the blob container and stored in the file system.
  
  If you use a hierarchical blob storage service (like NFSv3-mounted blob storage), you can think of the prefix as a file path. Items under the path are included in the Azure Managed Lustre file system.

  If you use your blob container as a non-hierarchical object store, you can also think of the import prefix as a search string that is compared with the beginning of your blob object name. If the name of a file in your blob container starts with the string you specified as the import prefix, that file will be made accessible in the file system. (Note that Lustre is a hierarchical file system, and '/' characters in blob file names will become directory delimiters when stored in Lustre.)
  
  Read more about [Azure Managed Lustre with hierarchical or non-hierarchical blob containers](blob-integration.md#understand-hierarchical-and-non-hierarchical-storage-schemas).

  The default import prefix is ``/``, which imports the entire contents of the blob container.

  If you don't want to import files from the blob container, you can set an import prefix that does not match any files in the container.

### Maintenance window

> [!NOTE]
> The maintenance window configuration is not supported during the private preview. Maintenance tasks might be done at any time.

To allow Azure staff to maintain your Azure Managed Lustre file system, they need access to the file system to run diagnostics, update software, and troubleshoot any problems. Use the **Maintenance window** setting to set a time when the system can be disrupted for routine service.

Tasks that are active during this service might fail, or might only be delayed. Testing is ongoing to determine this behavior.

After the general availability (GA) release, maintenance is expected to be done less than once a month. Routine software upgrades will happen about six times a year, and approximately five other update tasks might be needed to address vulnerabilities or critical bugs over the same time.

## Customize encryption keys (optional)
<!-- update aka link if you change this header -->
[//]: # (Test 2 of user-invisible comment!)

If you want to manage the encryption keys used for your Azure Managed Lustre file system storage, supply your Azure Key Vault information on the **Disk encryption keys** page. The key vault must be in the same region and in the same subscription as the cache.

You can skip this section if you do not need customer-managed keys. Azure encrypts data with Microsoft-managed keys by default. Read [Azure storage encryption](/azure/storage/common/storage-service-encryption) to learn more.

> [!NOTE]
> You cannot change between Microsoft-managed keys and customer-managed keys after creating the file system.

For a complete explanation of the customer-managed key encryption process, read [Use customer-managed encryption keys with Azure Managed Lustre](customer-managed-encryption-keys.md).

Select **Customer managed** to choose customer-managed key encryption. The key vault specification fields appear. Select the Azure Key Vault to use, then select the key and version to use for this file system. The key must be a 2048-bit RSA key. You can create a new key vault, key, or key version from this page.

Check the **Always use current key version** box if you want to use [automatic key rotation](/azure/virtual-machines/disk-encryption#automatic-key-rotation-of-customer-managed-keys).

In the **Managed identities** section, specify a user-assigned managed identity to use for this file system. The identity must have access to the key vault in order to successfully create the Azure Managed Lustre file system.

> [!NOTE]
> You cannot change the assigned identity after you create the file system.

To learn more, see [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview).

## Review settings and create the file system

After you are finished configuring the options for your Azure Managed Lustre file system, click the **Create** button on the last tab.

Your Azure Managed Lustre file system should appear in your portal **Resources** page within thirty minutes.

## Next steps

* Learn how to [connect clients to your new Azure Managed Lustre file system](connect-clients.md)
