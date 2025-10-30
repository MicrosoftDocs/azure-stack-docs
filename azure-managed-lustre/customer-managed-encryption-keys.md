---
title: Use Customer-Managed Encryption keys with Azure Managed Lustre
description: Use Azure Key Vault to create and manage your own encryption keys for Azure Managed Lustre file systems.
ms.topic: overview
author: pauljewellmsft
ms.author: pauljewell
ms.date: 11/11/2024

---

# Use customer-managed encryption keys with Azure Managed Lustre

All data stored in Azure is encrypted at rest by default with Microsoft-managed keys. You can use Azure Key Vault to control ownership of the keys you use to encrypt your data stored in an Azure Managed Lustre file system. This article explains how to use customer-managed keys for data encryption with Managed Lustre.

[VM host encryption](/azure/virtual-machines/disk-encryption#encryption-at-host---end-to-end-encryption-for-your-vm-data) protects all information on the managed disks that hold your data in a Managed Lustre file system, even if you add a customer key for the Lustre disks. Adding a customer-managed key gives an extra level of security for high security needs. For more information, see [Server-side encryption of Azure disk storage](/azure/virtual-machines/disk-encryption).

To enable customer-managed key encryption for Managed Lustre:

1. [Set up a key vault](#create-a-key-vault-and-key) to store the keys.
1. [Create a managed identity](#create-a-user-assigned-managed-identity) that can access the key vault.
1. When you create the file system, [choose customer-managed key encryption](#create-the-managed-lustre-file-system-with-customer-managed-encryption-keys) and specify the key vault, key, and managed identity to use.

This article explains these steps in more detail.

After you create the file system, you can't change between customer-managed keys and Microsoft-managed keys.

## Prerequisites

You can either use an existing key vault and key, or create new ones to use with Managed Lustre. See the following required settings to ensure that you have a properly configured key vault and key.

### Create a key vault and key

Set up an Azure key vault to store your encryption keys. The key vault and key must meet the following requirements to work with Managed Lustre.

#### Key vault properties

You must use specific settings to use a key vault with Managed Lustre. You can configure other options as needed.

Basic settings:

- **Subscription**: Use the same subscription that you use for the Managed Lustre cluster.
- **Region**: The key vault must be in the same region as the Managed Lustre cluster.
- **Pricing tier**: The Standard tier is sufficient to use with Managed Lustre.
- **Soft delete**: Managed Lustre enables soft delete if you don't configure it on the key vault.
- **Purge protection**: Enable purge protection.

Access policy settings:

- **Access Configuration**: Set to Azure role-based access control.

Networking settings:

- **Public Access**: Must be enabled.
- **Allow Access**: Select **All networks**. If you need to restrict access, you can instead choose **Selected networks**. If you choose **Selected networks**, you must enable the **Allow trusted Microsoft services to bypass this firewall** option in the **Exception** section.

:::image type="content" source="./media/customer-managed-encryption-keys/keyvault-network-config.png" alt-text="Screenshot shows how to restrict key vault access to selected networks while allowing access to trusted Microsoft services." lightbox="./media/customer-managed-encryption-keys/keyvault-network-config.png":::

> [!NOTE]
> If you use an existing key vault, review the network settings section to confirm that **Allow access from** is set to **Allow public access from all networks**. You can also make other changes.

#### Key properties

- **Key type**: RSA
- **RSA key size**: 2048
- **Enabled**: Yes

Key vault access permissions:

- The user that creates the Managed Lustre system must have permissions equivalent to the [Key Vault contributor role](/azure/role-based-access-control/built-in-roles#key-vault-contributor). You need the same permissions to set up and manage Azure Key Vault.

  For more information, see [Secure access to a key vault](/azure/key-vault/general/security-features).

[Learn more Azure Key Vault basics](/azure/key-vault/general/basic-concepts).

### Create a user-assigned managed identity

The Managed Lustre file system needs a user-assigned managed identity to access the key vault.

A user-assigned managed identity is a standalone identity credential that takes the place of a user identity when a user accesses Azure services through Microsoft Entra ID. Like other user identities, managed identities can be assigned roles and permissions. [Learn more about managed identities](/azure/active-directory/managed-identities-azure-resources/).

Before you can create the file system, you must create this identity and give the identity access to the key vault.

For more information, see [Create a user-assigned managed identity](/azure/active-directory/managed-identities-azure-resources/how-manage-user-assigned-managed-identities).

## Create the Managed Lustre file system with customer-managed encryption keys

When you create your Managed Lustre file system, on the **Disk encryption keys** tab, under **Disk encryption key type**, select **Customer managed**. Then, other settings appear under **Customer Key settings** and **Managed identities**.

:::image type="content" source="media/customer-managed-encryption-keys/portal-encryption-keys.png" alt-text="Screenshot of the Azure portal interface for creating a new Azure Managed Lustre system, with customer managed selected." lightbox="media/customer-managed-encryption-keys/portal-encryption-keys.png":::

Remember that you can set up customer-managed keys only when you create the file system. You can't change the type of encryption keys used for an existing Managed Lustre file system.

### Customer key settings

In **Customer Key settings**, select the link to select the key vault, key, and version settings. You can also create a new key vault on this pane. If you create a new key vault, be sure to give your managed identity access to the key vault.

If your key vault doesn't appear in the list, check these requirements:

- Is the file system in the same subscription as the key vault?
- Is the file system in the same region as the key vault?
- Is there network connectivity between the Azure portal and the key vault?

After you select a vault, select the individual key from the available options, or create a new key. The key must be a 2,048-bit RSA key.

Specify the version for the selected key. For more information about versioning, see the [Azure Key Vault documentation](/azure/key-vault/general/about-keys-secrets-certificates#objects-identifiers-and-versioning).

### Managed identities settings

In **Managed identities**, select the link. Then select the identity that the Managed Lustre file system uses for key vault access.

After you configure these encryption key settings, select the **Review + create** tab and finish creating the file system for deployment.

## Related content

- [Azure storage encryption overview](/azure/storage/common/storage-service-encryption)
- [Disk encryption with customer-managed keys](/azure/virtual-machines/disk-encryption#customer-managed-keys)
