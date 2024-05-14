---
title: Create an Azure Managed Lustre file system in the Azure portal
description: Create an Azure Managed Lustre file system from the Azure portal.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.date: 05/14/2024
ms.lastreviewed: 06/06/2023
ms.reviewer: mayabishop

# Intent: As an IT Pro, I want to use a Lustre file system to process files that involve a heavy computation load.
# Keyword: 

---

# Create an Azure Managed Lustre file system

In this article, you learn how to create an Azure Managed Lustre file system using the Azure portal.

If you prefer to use an Azure Resource Manager template to create a file system, see [Create a file system using Azure Resource Manager templates](create-file-system-resource-manager.md).

## Prerequisites

Plan the following configuration options carefully, as they can't be changed after you create your file system:

- Size of the file system, in terms of storage capacity and throughput.
- Encryption key management, whether Microsoft-managed keys or customer-managed keys.

## Sign in to the Azure portal

1. Sign in to [the Azure portal](https://portal.azure.com).

1. Type **Azure Managed Lustre** in the search box, and press **Enter**.

1. On the **Azure Managed Lustre** page, select **+ Create**.

## Basics tab

On the **Basics** tab, you provide essential information about your Azure Managed Lustre file system. The following table describes the settings on the **Basics** tab:

| Section | Field | Required or optional | Description |
|---------|-------|----------------------|-------------|
| Project details | Subscription | Required | Select the subscription to use for the Azure Managed Lustre file system. |
| Project details | Resource group | Required | Select an existing resource group, or create a new resource to use for this deployment. |
| Project details | Region | Required | Select the Azure region for your file system. For optimal performance, create the file system in the same region and availability zone as your client machines. |
| Project details | Availability zone | Required | Select the availability zone for your file system. |
| File system details | File system name | Required | Enter a name to identify this file system in your list of resources. This name is not the name of the file system used in `mount` commands. |
| File system details | File system type | Required | Shows **Durable, SSD**. |
| File system details | Storage and throughput | Required | Enter the storage capacity of your file system in TiB, or the maximum throughput per TiB.<\br><\br>There are two factors that determine your file system size: The amount of storage allocated for your data (storage capacity), and the maximum data transfer rate (throughput). When you select one of these options, the other values are calculated based on the **Throughput per TiB** setting for your file system type.<\br><\br>To set the file system size, choose either **Storage capacity** or **Maximum throughput**. Enter a value in the corresponding field, either the desired storage capacity (in TiB) if you selected **Storage capacity**, or the desired maximum throughput (in MB/second) if you selected **Maximum throughput**.<\br><\br>Note: These values are rounded up to meet incremental size requirements. The values are never rounded down, so check the final configuration to make sure it's cost-effective for your workload.<\br><\br>To learn more about available throughput configurations, see [Throughput configurations](#throughput-configurations) |
| Networking | Virtual network | Required | Select an existing virtual network to use for the file system, or create a new virtual network. For more information about network sizing and other configuration options, see [Network prerequisites](amlfs-prerequisites.md#network-prerequisites). |
| Networking | Subnet | Required | Select an existing subnet or create a new one.<\br><\br>The Azure Managed Lustre file system uses a dedicated virtual network and one subnet. The subnet contains the Lustre Management Service (MGS), which handles all of the client interaction with the Azure Managed Lustre system.<\br><\br>You can open the **Manage subnet configuration** link to make sure the subnet meets your network requirements. The network should have enough available IP addresses to handle the file system's load and any additional IP addresses required by any other services that are co-located with the file system. Make sure you complete all access settings to enable the subnet to access the needed Azure services. |
| Maintenance window | Day of the week | Required | Provide a preferred day of the week for the Azure team to perform maintenance and troubleshooting with minimal impact. This is used infrequently and only as needed. To learn more, see [Maintenance window](#maintenance-window). |
| Maintenance window | Start time | Required | Provide the time that the maintenance window may begin. Time should be in 24-hour format (HH:MM). |

The following screenshot shows the **Basics** tab for creating an Azure Managed Lustre file system in the Azure portal:

:::image type="content" source="./media/create-file-system-portal/basics-tab.png" alt-text="A screenshot showing the Basics tab for creating an Azure Managed Lustre file system in the Azure portal." lightbox="./media/create-file-system-portal/basics-tab.png":::

When you finish entering details on the **Basics** tab, select **Next: Advanced** to continue.

> [!NOTE]
> Moving an Azure Virtual Network Manager instance is not currently supported. The existing virtual network manager instance might be deleted and another created in a new location using the Azure Resource Manager template.

### Throughput configurations

Currently, the following throughput configurations are available:

| Throughput per TiB storage | Storage minimum | Storage maximum | Increment |
|-----------|-----------|-----------|-----------|
| 40 MB/second | 48 TiB | 768 TiB | 48 TiB |
| 125 MB/second | 16 TiB | 128 TiB | 16 TiB |
| 250 MB/second | 8 TiB | 128 TiB | 8 TiB |
| 500 MB/second | 4 TiB | 128 TiB | 4 TiB |

> [!NOTE]
> Upon request, Azure Managed Lustre can support larger storage capacities up to 2.5PB. To make a request for a larger storage capacity, please [open a support ticket](https://ms.portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview).
>
> If you need cluster sizes greater than 2.5PB, you can [open a support ticket](https://ms.portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview) to discuss additional options.

### Maintenance window

To allow the Azure team to maintain your Azure Managed Lustre file system, they need access to the file system to run diagnostics, update software, and troubleshoot any problems. Use the **Maintenance window** setting to set a time when the system can be disrupted for routine service. Tasks that are active during this service might fail or be delayed.

Maintenance is typically performed less than once a month. Routine software upgrades happen about six times a year, and approximately five other update tasks might be required to address vulnerabilities or critical bugs over the same time.

## Advanced tab

Use the **Advanced** tab to optionally set up Blob Storage integration.

### Blob integration

If you want to integrate data from Azure Blob Storage with your Azure Managed Lustre file system, you can specify the details in the **Blob integration** section when you create the file system. This integration allows you to import and export data between the file system and a blob container.

Configuring blob integration during cluster creation is optional, but it's the only way to use [Lustre Hierarchical Storage Management (HSM)](https://doc.lustre.org/lustre_manual.xhtml#lustrehsm) features. If you don't want the benefits of Lustre HSM, you can import and export data for the Azure Managed Lustre file system by using client commands directly.

To configure blob integration, follow these steps:

1. Create or configure a storage account and blob containers for integration with the file system. To learn more about the requirements for these resources, see [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites-optional). The storage account doesn't need to be in the same subscription as the Azure Managed Lustre file system.
1. Select the **Import/export data from blob** check box.
1. Specify the **Subscription**, **Storage account**, and **Container** to use with your Lustre file system.
1. In the **Logging container** field, select the container where you want to store import/export logs. The logs must be stored in a separate container from the data container, but the containers must be in the same storage account.
1. In the **Import prefix** fields, you can optionally supply one or more prefixes to filter the data imported into the Azure Managed Lustre file system. The default import prefix is `/`, and the default behavior imports the contents of the entire blob container. To learn more about import prefixes, see [Import prefix](blob-integration.md#import-prefix).

:::image type="content" source="./media/create-file-system-portal/advanced-blob-integration.png" alt-text="A screenshot showing blob integration settings on Advanced tab in Azure Managed Lustre create flow." lightbox="./media/create-file-system-portal/advanced-blob-integration.png":::


When you finish entering details on the **Advanced settings** tab, you can optionally select **Next: Disk encryption keys** to enter details about managing your own encryption keys. If you don't want to manage your own encryption keys, select **Review + create**.

> [!NOTE]
> You cannot change between Microsoft-managed keys and customer-managed keys after your create the file system.

## Disk encryption keys tab

You can optionally manage the encryption keys used for your Azure Managed Lustre file system storage by supplying your Azure Key Vault information on the **Disk encryption keys** tab. The key vault must be in the same region and in the same subscription as the cache.

If you don't need customer-managed keys, you can skip this section. Azure encrypts data with Microsoft-managed keys by default. For more information, see [Azure storage encryption](/azure/storage/common/storage-service-encryption).

> [!NOTE]
> You cannot change between Microsoft-managed keys and customer-managed keys after creating the file system.

For a complete explanation of the customer-managed key encryption process, see [Use customer-managed encryption keys with Azure Managed Lustre](customer-managed-encryption-keys.md).

To use customer-managed encryption keys with your Azure Managed Lustre file system, follow these steps:

1. For **Disk encryption key type**, select **Customer managed**. The key vault specification fields appear.

1. Under **Customer key settings**, open the **Select or create a key vault, key, or version** link.

    :::image type="content" source="./media/create-file-system-portal/customer-key-settings.png" alt-text="A screenshot showing Customer Key Settings for the Azure Managed Lustre create flow." lightbox="./media/create-file-system-portal/customer-key-settings.png":::

1. On the **Select a key** screen, select the **Key vault**, **Key**, and **Version** of the key to use for this file system. Then choose **Select**.

   You can create a new key vault, key, and key version from this page. The key must be a 2048-bit RSA key, and must be stored in Azure Key Vault.

    :::image type="content" source="./media/create-file-system-portal/key-vault-key-version.png" alt-text="A screenshot showing the Select a key screen while creating Azure Managed Lustre file system." lightbox="./media/create-file-system-portal/key-vault-key-version.png":::

   **Customer key settings** now displays your key vault, key, and version.

    :::image type="content" source="./media/create-file-system-portal/keys-summary.png" alt-text="A screenshot showing sample Customer key settings on Basics tab for an Azure Managed Lustre file system." lightbox="./media/create-file-system-portal/keys-summary.png":::

1. In **Managed identities**, specify one or more user-assigned managed identities to use for this file system. Each identity must have access to the key vault in order to successfully create the Azure Managed Lustre file system.

   > [!NOTE]
   > You cannot change the assigned identity after you create the file system.

   To learn more, see [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview).

When you finish entering customer key settings and managed identities, select **Review + create** to continue.

## Review + create tab

When you navigate to the **Review + create tab**, Azure runs validation on the Azure Managed Lustre file system settings that you've chosen. If validation passes, you can proceed to create the file system.

If validation fails, then the portal indicates which settings need to be modified.

The following image shows the Review tab data prior to the creation of a new file system:

:::image type="content" source="./media/create-file-system-portal/review-create-tab.png" alt-text="A screenshot showing the review and create tab in Azure Managed Lustre create flow." lightbox="./media/create-file-system-portal/review-create-tab.png":::

## Next steps

- Learn how to [connect clients to your new Azure Managed Lustre file system](connect-clients.md)
