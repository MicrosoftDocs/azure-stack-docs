---
title: Use customer-managed encryption keys with Azure Managed Lustre
description: Use an Azure Key Vault to create and manage your own encryption keys for Azure Managed Lustre file systems.
ms.topic: overview
author: pauljewellmsft
ms.author: pauljewell
ms.date: 06/28/2023

---

# Use customer-managed encryption keys with Azure Managed Lustre

You can use Azure Key Vault to control ownership of the keys used to encrypt your data stored in an Azure Managed Lustre file system. This article explains how to use customer-managed keys for data encryption with Azure Managed Lustre.

> [!NOTE]
> All data stored in Azure is encrypted at rest using Microsoft-managed keys by default. You only need to follow the steps in this article if you want to manage the keys used to encrypt your data when it's stored in your Azure Managed Lustre cluster.

[VM host encryption](/azure/virtual-machines/disk-encryption#encryption-at-host---end-to-end-encryption-for-your-vm-data) protects all information on the managed disks that hold your data in an Azure Managed Lustre file system, even if you add a Customer Key for the Lustre disks. Adding a customer-managed key gives an extra level of security for high security needs. Fo more information, see [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption).

There are three steps to enable customer-managed key encryption for Azure Managed Lustre:

1. [Set up an Azure Key Vault](#create-a-key-vault-and-key) to store the keys.
1. [Create a managed identity](#create-a-user-assigned-managed-identity) that can access that key vault.
1. When creating the file system, [choose customer-managed key encryption](#create-the-azure-managed-lustre-file-system-with-customer-managed-encryption-keys) and specify the key vault, key, and managed identity to use.

This article explains these steps in more detail.

After you create the file system, you can't change between customer-managed keys and Microsoft-managed keys.

## Prerequisites

You can use either a pre-existing key vault and key, or you can create new ones to use with Azure Managed Lustre. See the following required settings to ensure you have a properly configured key vault and key. 

### Create a key vault and key

Set up an Azure key vault to store your encryption keys. The key vault and key must meet these requirements to work with Azure Managed Lustre.

#### Key vault properties

The following settings are required for use with Azure Managed Lustre. You can configure options that aren't listed as needed.

Basics:

* **Subscription** - Use the same subscription that is used for the Azure Managed Lustre cluster.
* **Region** - The key vault must be in the same region as the Azure Managed Lustre cluster.
* **Pricing tier** - Standard tier is sufficient for use with Azure Managed Lustre.
* **Soft delete** - Azure Managed Lustre enables soft delete if it isn't already configured on the key vault.
* **Purge protection** - Enable purge protection.

Access policy:

* **Access Configuration** - Set to Azure role-based access control.

Networking:

* **Public Access** - Must be enabled.
* **Allow Access** - Must be set to "all networks"

> [!NOTE]
> If you are using an existing key vault, you can review the network settings section to confirm that **Allow access from** is set to **Allow public access from all networks**, or make changes if necessary.

#### Key properties

* **Key type** - RSA
* **RSA key size** - 2048
* **Enabled** - Yes

Key vault access permissions:

* The user that creates the Azure Managed Lustre system must have permissions equivalent to the [Key Vault contributor role](/azure/role-based-access-control/built-in-roles#key-vault-contributor). The same permissions are needed to set up and manage Azure Key Vault.

  For more information, see [Secure access to a key vault](/azure/key-vault/general/security-features).

Learn more [Azure Key Vault basics](/azure/key-vault/general/basic-concepts).

### Create a user-assigned managed identity

The Azure Managed Lustre file system needs a user-assigned managed identity to access the key vault.

Managed identities are standalone identity credentials that take the place of user identities when accessing Azure services through Microsoft Entra ID. Like other users, they can be assigned roles and permissions. [Learn more about managed identities](/azure/active-directory/managed-identities-azure-resources/).

Create this identity before you create the file system, and give it access to the key vault.

> [!NOTE]
> If you supply a managed identity that can't access the key vault, you won't be able to create the file system.

For more information, see the managed identities documentation:

* [Create a user-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities)
* [Assign resource access](/azure/active-directory/managed-identities-azure-resources/howto-assign-access-portal?source=recommendations)

## Create the Azure Managed Lustre file system with customer-managed encryption keys

When you create your Azure Managed Lustre file system, use the **Disk encryption keys** tab to select **Customer managed** in the **Disk encryption key type** setting. Other sections appear for **Customer Key settings** and **Managed identities**.

:::image type="content" source="media/customer-managed-encryption-keys/portal-encryption-keys.png" alt-text="Screenshot of the Azure portal interface for creating a new Azure Managed Lustre system, with customer managed selected." lightbox="media/customer-managed-encryption-keys/portal-encryption-keys.png":::

Remember that you can only set up customer managed keys at creation time. You can't change the type of encryption keys used for an existing Azure Managed Lustre file system.

### Customer Key settings

Select the link in **Customer Key settings** to select the key vault, key, and version settings. You can also create a new Azure Key Vault from this page. If you create a new key vault, remember to give your managed identity access to it.

If your Azure Key Vault doesn't appear in the list, check these requirements:

* Is the file system in the same subscription as the key vault?
* Is the file system in the same region as the key vault?
* Is there network connectivity between the Azure portal and the key vault?

After selecting a vault, select the individual key from the available options, or create a new key. The key must be a 2048-bit RSA key.

Specify the version for the selected key. For more information about versioning, see the [Azure Key Vault documentation](/azure/key-vault/general/about-keys-secrets-certificates#objects-identifiers-and-versioning).

### Managed identities settings

Select the link in **Managed identities** and select the identity that the Azure Managed Lustre file system uses for key vault access.

After you configure these encryption key settings, proceed to the **Review + create** tab and finish creating the file system as usual.

## Next steps

These articles explain more about using Azure Key Vault and customer-managed keys to encrypt data in Azure:

* [Azure storage encryption overview](/azure/storage/common/storage-service-encryption)
* [Disk encryption with customer-managed keys](/azure/virtual-machines/disk-encryption#customer-managed-keys)
