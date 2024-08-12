---
title: Create an Azure Managed Lustre file system by using the Azure portal
description: Learn how to create an Azure Managed Lustre file system from the Azure portal.
ms.topic: how-to
author: pauljewellmsft
ms.author: pauljewell
ms.date: 06/13/2024
ms.lastreviewed: 06/06/2023
ms.reviewer: mayabishop

#customer intent: As an IT pro, I want to use a Lustre file system to process files that involve a heavy computation load.

---

# Create an Azure Managed Lustre file system by using the Azure portal

In this article, you learn how to create an Azure Managed Lustre file system by using the Azure portal.

If you prefer to use an Azure Resource Manager template to create a file system, see [Create an Azure Managed Lustre file system by using Azure Resource Manager templates](create-file-system-resource-manager.md).

## Prerequisites

Plan the following configuration options carefully, because you can't change them after you create your file system:

- Size of the file system, in terms of storage capacity and throughput
- Encryption key management, whether Microsoft-managed keys or customer-managed keys

## Sign in to the Azure portal

1. Sign in to [the Azure portal](https://portal.azure.com).

1. Enter **lustre** in the search box, and then select the **Azure Managed Lustre** service in the search results.

1. On the **Azure Managed Lustre** page, select **+ Create**.

## Basics tab

On the **Basics** tab, provide the following essential information about your Azure Managed Lustre file system:

| Section | Field | Description |
|---------|-------|-------------|
| **Project details** | **Subscription** | Select the subscription to use for the Azure Managed Lustre file system. |
| **Project details** | **Resource group** | Select an existing resource group, or create a new resource group for this deployment. |
| **Project details** | **Region** | Select the Azure region for your file system. For optimal performance, create the file system in the same region and availability zone as your client machines. |
| **Project details** | **Availability zone** | Select the availability zone for your file system. |
| **File system details** | **File system name** | Enter a name to identify this file system in your list of resources. This name isn't the name of the file system used in `mount` commands. |
| **File system details** | **File system type** | The value is **Durable, SSD** by default. |
| **File system details** | **Storage and throughput** | Enter the storage capacity of your file system in tebibytes (TiB), or enter the maximum throughput in megabytes per second (MBps).</br></br>Two factors determine your file system size: the amount of storage allocated for your data (storage capacity) and the maximum data transfer rate (throughput). When you select one of these options, the other values are calculated based on the **Throughput per TiB** setting for your file system type. To set the file system size, select either **Storage capacity** or **Maximum throughput**, and then enter a value in the corresponding box.</br></br> Note that these values are rounded up to meet incremental size requirements. The values are never rounded down, so check the final configuration to make sure that it's cost-effective for your workload. For more information, see [Throughput configurations](#throughput-configurations). |
| **Networking** | **Virtual network** | Select an existing virtual network to use for the file system, or create a new virtual network. For more information about network sizing and other configuration options, see [Network prerequisites](amlfs-prerequisites.md#network-prerequisites). |
| **Networking** | **Subnet** | Select an existing subnet or create a new one. </br></br>The Azure Managed Lustre file system uses a dedicated virtual network and one subnet. The subnet contains the Lustre Management Service (MGS), which handles all of the client interaction with the Azure Managed Lustre system. </br></br>You can open the **Manage subnet configuration** link to make sure that the subnet meets your network requirements. The network should have enough available IP addresses to handle the file system's load and any additional IP addresses required by other services that are colocated with the file system. Make sure that you complete all access settings to enable the subnet to access the needed Azure services. |
| **Maintenance window** | **Day of the week** | Provide a preferred day of the week and time for the Azure team to perform maintenance and troubleshooting with minimal impact. This maintenance is infrequent and performed only as needed. To learn more, see [Maintenance window](#maintenance-window). |
| **Maintenance window** | **Start time** | Provide the time that the maintenance window can begin. Time should be in 24-hour format (*HH*:*MM*). |

The following screenshot shows an example of the **Basics** tab for creating an Azure Managed Lustre file system in the Azure portal:

:::image type="content" source="./media/create-file-system-portal/basics-tab.png" alt-text="Screenshot that shows the Basics tab for creating an Azure Managed Lustre file system in the Azure portal." lightbox="./media/create-file-system-portal/basics-tab.png":::

When you finish entering details on the **Basics** tab, select **Next: Advanced** to continue.

> [!NOTE]
> Moving an Azure Virtual Network Manager instance is not currently supported. Instead, you can delete the existing Virtual Network Manager instance and create another instance in a new location by using the Azure Resource Manager template.

### Throughput configurations

Currently, the following throughput configurations are available:

| Throughput per TiB storage | Storage minimum | Storage maximum | Increment |
|-----------|-----------|-----------|-----------|
| 40 MBps | 48 TiB | 768 TiB | 48 TiB |
| 125 MBps | 16 TiB | 128 TiB | 16 TiB |
| 250 MBps | 8 TiB | 128 TiB | 8 TiB |
| 500 MBps | 4 TiB | 128 TiB | 4 TiB |

> [!NOTE]
> Upon request, Azure Managed Lustre can support larger storage capacities up to 2.5 petabytes (PB). To make a request for a larger storage capacity, [open a support ticket](https://ms.portal.azure.com/#view/Microsoft_Azure_Support/HelpAndSupportBlade/~/overview).
>
> If you need cluster sizes greater than 2.5 PB, you can open a support ticket to discuss additional options.

### Maintenance window

Use the **Maintenance window** setting to control the day and time when system updates can occur.

System updates are typically applied to the service once every two months. The service might be temporarily unavailable during the maintenance window when system updates are being applied. System updates include, but aren't limited to, security updates, Lustre code fixes, and service enhancements.

During the maintenance window, user workloads that access the file system will temporarily pause if a system update is being applied. User workloads resume when the system updates are complete. If you have multiple Azure Managed Lustre deployments, consider spacing out their maintenance windows for availability when updates are necessary.

## Advanced tab

Use the **Advanced** tab to optionally enable and configure Azure Blob Storage integration. You can use this integration to import and export data between the file system and a blob container.

### Blob integration

If you want to integrate data from Azure Blob Storage with your Azure Managed Lustre file system, you can specify the details in the **Blob integration** section when you create the file system.

Configuring blob integration during cluster creation is optional, but it's the only way to use [Lustre Hierarchical Storage Management (HSM)](https://doc.lustre.org/lustre_manual.xhtml#lustrehsm) features. If you don't want the benefits of Lustre HSM, you can import and export data for the Azure Managed Lustre file system by using client commands directly.

To configure blob integration, follow these steps:

1. Create or configure a storage account and blob containers for integration with the file system. To learn more about the requirements for these resources, see [Blob integration prerequisites](amlfs-prerequisites.md#blob-integration-prerequisites-optional). The storage account doesn't need to be in the same subscription as the Azure Managed Lustre file system.
1. Select the **Import/export data from blob** checkbox.
1. Specify the **Subscription**, **Storage account**, and **Container** values to use with your Lustre file system.
1. In the **Logging container** box, select the container where you want to store import/export logs. The logs must be stored in a separate container from the data container, but the containers must be in the same storage account.
1. In the **Import Prefix(es)** boxes, you can optionally supply one or more prefixes to filter the data that's imported into the Azure Managed Lustre file system. The default import prefix is `/`, and the default behavior imports the contents of the entire blob container. For more information, see [Import prefix](blob-integration.md#import-prefix).

:::image type="content" source="./media/create-file-system-portal/advanced-blob-integration.png" alt-text="Screenshot that shows blob integration settings on the Advanced tab for creating an Azure Managed Lustre file system." lightbox="./media/create-file-system-portal/advanced-blob-integration.png":::

When you finish entering details on the **Advanced** tab, you can optionally select **Next: Disk encryption keys** to enter details about managing your own encryption keys. If you don't want to manage your own encryption keys, select **Review + create**.

## Disk encryption keys tab

You can optionally manage the encryption keys for your Azure Managed Lustre file system storage by supplying your Azure Key Vault information on the **Disk encryption keys** tab. The key vault must be in the same region and in the same subscription as the cache.

If you don't need customer-managed keys, you can skip this section. Azure encrypts data with Microsoft-managed keys by default. For more information, see [Azure Storage encryption](/azure/storage/common/storage-service-encryption).

> [!NOTE]
> You can't change between Microsoft-managed keys and customer-managed keys after you create the file system.

For a complete explanation of the encryption process for customer-managed keys, see [Use customer-managed encryption keys with Azure Managed Lustre](customer-managed-encryption-keys.md).

To use customer-managed encryption keys with your Azure Managed Lustre file system, follow these steps:

1. For **Disk encryption key type**, select **Customer managed**. The fields for specifying a key vault appear.

1. Under **Customer key settings**, open the **Select or create a key vault, key, or version** link.

    :::image type="content" source="./media/create-file-system-portal/customer-key-settings.png" alt-text="Screenshot that shows customer key settings for creating an Azure Managed Lustre file system." lightbox="./media/create-file-system-portal/customer-key-settings.png":::

1. On the **Select a key** pane, select the **Key vault**, **Key**, and **Version** values for the key that you're using for this file system. Then choose **Select**.

   You can create a new key vault, key, and key version from this pane. The key must be a 2048-bit RSA key, and it must be stored in Azure Key Vault.

    :::image type="content" source="./media/create-file-system-portal/key-vault-key-version.png" alt-text="Screenshot that shows the pane for selecting a key while creating an Azure Managed Lustre file system." lightbox="./media/create-file-system-portal/key-vault-key-version.png":::

   The **Customer key settings** area now displays your key vault, key, and version.

    :::image type="content" source="./media/create-file-system-portal/keys-summary.png" alt-text="Screenshot that shows an example of customer key settings." lightbox="./media/create-file-system-portal/keys-summary.png":::

1. In **Managed identities**, specify one or more user-assigned managed identities to use for this file system. Each identity must have access to the key vault in order to successfully create the Azure Managed Lustre file system.

   > [!NOTE]
   > You can't change the assigned identity after you create the file system.

   To learn more, see [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview).

When you finish entering customer key settings and managed identities, select **Review + create** to continue.

## Review + create tab

When you go to the **Review + create** tab, Azure runs validation on your settings for the Azure Managed Lustre file system. If validation passes, you can proceed to create the file system.

If validation fails, the portal indicates which settings you need to modify.

The following screenshot shows an example of the **Review + create** tab before the creation of a new file system:

:::image type="content" source="./media/create-file-system-portal/review-create-tab.png" alt-text="Screenshot that shows the tab for reviewing settings and creating an Azure Managed Lustre file system." lightbox="./media/create-file-system-portal/review-create-tab.png":::

Select **Create** to begin deployment of the Azure Managed Lustre file system.

## Next step

> [!div class="nextstepaction"]
> [Connect clients to an Azure Managed Lustre file system](connect-clients.md)
