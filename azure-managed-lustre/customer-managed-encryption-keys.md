---
title: Use customer-managed encryption keys with Azure Managed Lustre (Preview)
description: Use an Azure Key Vault to create and manage your own encryption keys for Azure Managed Lustre file systems.
ms.topic: overview
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 02/09/2023
ms.reviewer: sethm
ms.date: 02/09/2023

# Intent: As an IT Pro, XXX.
# Keyword: 

---
# Use customer-managed encryption keys with Azure Managed Lustre (Preview)

<!--Imported from Requirements. These settings are optional. Will integrate this content with the existing content.-->

===========================
BEGIN "Requirements" IMPORT

## Azure Key Vault integration requirements (optional)

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

END "Requirements" IMPORT
=========================

You can use Azure Key Vault to control ownership of the keys used to encrypt your data while it's stored in the Azure Managed Lustre file system. This article explains how to use customer-managed keys for data encryption with Azure Managed Lustre.

> [!NOTE]
> All data stored in Azure is encrypted at rest using Microsoft-managed keys by default. You only need to follow the steps in this article if you want to manage the keys used to encrypt your data when it's stored in your Azure Managed Lustre cluster.

All information in an Azure Managed Lustre file system also is protected by [VM host encryption](/azure/virtual-machines/disk-encryption#encryption-at-host---end-to-end-encryption-for-your-vm-data) on the managed disks that hold your data, even if you add a customer key for the Lustre disks. Adding a customer-managed key gives an extra level of security for customers with high security needs. Read [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption) for details.

There are three steps to enable customer-managed key encryption for Azure Managed Lustre:

1. [Set up an Azure Key Vault](#create-a-key-vault-and-key) to store the keys.
1. [Create a managed identity](#create-a-user-assigned-managed-identity) that can access that key vault.
1. When creating the file system, [choose customer-managed key encryption](#create-the-azure-managed-lustre-file-system-with-customer-managed-encryption-keys) and specify the key vault, key, and managed identity to use.

These steps are explained in more detail below.

After you create the file system, you can't change between customer-managed keys and Microsoft-managed keys.<!-- However, if you use customer-managed keys you can [change](#update-key-settings) the encryption key, the key version, and the key vault as needed. ***[? - The update option doesn't seem to be in Azure Managed Lustre yet -?]*** -->

## Prerequisites

Do these steps before you create the Azure Managed Lustre system.

### Create a key vault and key

Set up an Azure Key Vault to store your encryption keys.

The key vault and key must meet these requirements to work with Azure Managed Lustre.

Key vault properties:

* **Subscription** - Use the same subscription that is used for the Azure Managed Lustre file system.
* **Region** - The key vault must be in the same region as the file system.
* **Pricing tier** - Standard tier is sufficient for use with Azure Managed Lustre.
* **Soft delete** - Azure Managed Lustre will enable soft delete if it is not already configured on the key vault.
* **Purge protection** - Purge protection must be enabled.
* **Access policy** - Default settings are sufficient.
* **Network connectivity** - Azure Managed Lustre must be able to access the key vault, regardless of the endpoint settings you choose.

Key properties:

* **Key type** - RSA
* **RSA key size** - 2048
* **Enabled** - Yes

Key vault access permissions:

* The user that creates the Azure Managed Lustre system must have permissions equivalent to the [Key Vault contributor role](/azure/role-based-access-control/built-in-roles#key-vault-contributor). The same permissions are needed to set up and manage Azure Key Vault.

  Read [Secure access to a key vault](/azure/key-vault/general/security-features) for more information.

Learn more [Azure Key Vault basics](/azure/key-vault/general/basic-concepts)

### Create a user-assigned managed identity
<!-- check for cross-references from here and create -->

The Azure Managed Lustre file system needs a user-assigned managed identity to access the key vault.

Managed identities are standalone identity credentials that take the place of user identities when accessing Azure services through Azure Active Directory. Like other users, they can be assigned roles and permissions. [Learn more about managed identities](/azure/active-directory/managed-identities-azure-resources/)

Create this identity before you create the file system, and give it access to the key vault.

> [!NOTE]
> If you supply a managed identity that can't access the key vault, you won't be able to create the file system.

Read the managed identities documentation to learn more:

* [Create a user-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities)
* [Assign resource access](/azure/active-directory/managed-identities-azure-resources/howto-assign-access-portal?source=recommendations)

## Create the Azure Managed Lustre file system with customer-managed encryption keys

When you create your Azure Managed Lustre file system, use the **Disk encryption keys** tab to select **Customer managed** in the **Disk encryption key type** setting. Additional sections appear for **Customer key settings** and **Managed identities**.

![Screenshot of the Azure Portal interface for creating a new Azure Managed Lustre system, with customer managed selected on the Disk encryption keys tab. The page shows a Customer key settings section with a clickable link (text: "Select or create a key vault, key, or version"). Below that is a 'Managed identities' header with a link that has the text "Add user assigned managed identities".](media/customer-managed-encryption-keys/portal-encryption-keys.png)<!--Reformat alt-text for complex illustration.-->

Remember that you can only set up customer managed keys at creation time. You can't change the type of encryption keys used for an existing Azure Managed Lustre file system.

### Customer key settings

Click the link in **Customer key settings** to select the key vault, key, and version settings. You can also create a new Azure Key Vault from this page. If you create a new key vault, remember to give your managed identity access to it.

<!-- GUI is significantly different from HPC Cache at least the version in doc -->

If your Azure Key Vault does not appear in the list, check these requirements:

* Is the file system in the same subscription as the key vault?
* Is the file system in the same region as the key vault?
* Is there network connectivity between the Azure portal and the key vault?

After selecting a vault, select the individual key from the available options, or create a new key. The key must be a 2048-bit RSA key.

Specify the version for the selected key. Learn more about versioning in the [Azure Key Vault documentation](/azure/key-vault/general/about-keys-secrets-certificates#objects-identifiers-and-versioning).
<!-- 
***[? - From HPC Cache GUI - this isn't an option in Lustre, should it be? - ?]***
*Optionally, check the **Always use current key version** box if you want to use [automatic key rotation](<https://learn.microsoft.com/azure/virtual-machines/disk-encryption#automatic-key-rotation-of-customer-managed-keys>).* -->

### Managed identities settings

Click the link in **Managed identities** and select the identity that the Azure Managed Lustre file system will use for key vault access.

After you configure these encryption key settings, proceed to the **Review + create** tab and finish creating the file system as usual.

<!--
## Update key settings

***[? - is this an option in Azure Managed Lustre? I didn't find any systems with an "encryption" settings page to check. HPC Cache version is documented here: https://learn.microsoft.com/azure/hpc-cache/customer-keys#update-key-settings - ?]***

After your Azure Managed Lustre file system is up and running, you can change the encryption key settings.

You can change the key vault, key, or key version for your file system from the Azure portal. Click the **Encryption** settings link in the portal to open the **Customer key settings** page.

You cannot change a file system between customer-managed keys and system-managed keys.

<!-- ![Screenshot of "Customer keys settings" page, reached by clicking Settings > Encryption from the *cache* page in the Azure portal.](media/change-key-click.png) -->
<!-- Click the **Change key** link, then click **Change the key vault, key, or version** to open the key selector.

<!-- ![Screenshot of "select key from Azure Key Vault" page with three drop-down selectors to choose key vault, key, and version.](media/select-new-key.png) -->
<!--Key vaults in the same subscription and same region as this Azure Managed Lustre file system are shown in the list.

After you choose the new encryption key values, click **Select**. A confirmation page appears with the new values. Click **Save** to finalize the selection. -->

## Read more about customer-managed keys in Azure

These articles explain more about using Azure Key Vault and customer-managed keys to encrypt data in Azure:

* [Azure storage encryption overview](/azure/storage/common/storage-service-encryption)
* [Disk encryption with customer-managed keys](/azure/virtual-machines/disk-encryption#customer-managed-keys)
