---
title: Use Azure Migrate to move Hyper-V VMs to Azure Stack HCI (preview)
description: Learn about how to use Azure Migrate to migrate Windows and Linux VMs to your Azure Stack HCI cluster (preview).
author: alkohli
ms.topic: overview
ms.date: 08/31/2023
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Overview of Azure Migrate based migration for Azure Stack HCI (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article provides an overview of how to migrate Hyper-V virtual machines (VMs) to your Azure Stack HCI cluster using Azure Migrate.

Azure Migrate is a simplified, unified platform that is used to assess, migrate, and modernize your on-premises VM workloads. Azure Stack HCI is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads in a hybrid environment. You can use the Azure Migrate platform to move on-premises Hyper-V VMs to your Azure Stack HCI cluster.

For more information on Azure Migrate platform, see [About Azure Migrate](/azure/migrate/migrate-services-overview).

[!INCLUDE [important](../../includes/hci-preview.md)]

## Benefits

Here are the benefits of using Azure Migrate to migrate your on-premises VMs to Azure Stack HCI:

- This solution requires little or no preparation. You don't need to prep your source VMs or install agents on them prior to migration.
- This solution results in a minimal downtime for the VM-based applications running on your on-premises servers.
- This solution keeps the application data on-premises only. The data flows from on-premises Hyper-V VMs to VMs running on on-premises target Azure Stack HCI cluster. 
- This solution provides the control plane via the Azure portal. You can use the portal to start, run, and track your migration to Azure.


## Migration components

With Azure Migrate, you can choose to migrate your data from your on-premises setup to Azure or to your Azure Stack HCI cluster. In this case, the VMs and their related data are migrated to your on-premises Azure Stack HCI cluster.

The following diagram shows the migration process:

:::image type="content" source="./media/migration-azure-migrate-hci-overview/azure-migrate-workflow-1.png" alt-text="Diagram that shows a high-level workflow for migration using Azure Migrate.":::

The migration process requires the following components:

- Azure migrate appliance running on your on-premises source Hyper-V servers. The source servers host the VMs that you want to migrate.
- Target appliance running on your on-premises Azure Stack HCI cluster. The Azure Migrate project is used to discover the source VMs and replicate them to the target Azure Stack HCI cluster.
- An Azure Migrate project in Azure that contains an Azure Storage account. This account serves as a cache to store the metadata and the replication data. Both the source and target appliances are registered with this Migrate project.

The data flows from your on-premises Hyper-V VMs to VMs running on your on-premises Azure Stack HCI cluster.

## Migration phases

Here are the key phases of the migration process:


|#  |Phase  |Description  |
|---------|---------|---------|
|1.     |**Prepare**        |Review the migration requirements to identify if your source servers are supported for migration. Prepare to migrate by completing the migration prerequisites. Deploy, configure, and register your Azure Stack HCI cluster. This cluster is the migration target. Create an Azure Migrate project and an Azure Storage account in Azure.<br><br> For more information, see [Review prerequisites for Azure Migrate](../index.yml).         |
|2.     |**Discover**       |Create and configure an Azure Migrate source appliance. Use this appliance to discover your on-premises source Hyper-V servers. <br><br> For more information, see [Discover Hyper-V VMs](../index.yml).          |
|3.     |**Replicate**      |Create and configure the target appliance on your Azure Stack HCI. Select and replicate the VMs that were discovered in the previous step. <br><br> For more information, see [Replicate Hyper-V VMs](../index.yml).         |
|4.     |**Migrate, verify**|Once the replication is complete, select and migrate VMs to your Azure Stack HCI. After the migration is complete, verify that the VMs have booted successfully and the data has migrated properly. You can now pause the replication and decommission the source VMs. <br><br> For more information, see [Migrate and verify Hyper-V VMs](./migrate-azure-migrate.md#verify-migration).         |



## Next steps

To prepare for migration, see the following articles:

- [Review the requirements](../index.yml) for Hyper-V VM migration to Azure Stack HCI.
- [Complete the prerequisites](../index.yml) for Hyper-V VM migration to Azure Stack HCI.
