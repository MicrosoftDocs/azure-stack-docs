---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 09/03/2025
---

With Azure Migrate, you can choose to migrate your data from your on-premises environment to Azure or to your on-premises Azure Local instance.

The following diagram shows the migration process to your on-premises Azure Local instance using Azure Migrate:

:::image type="content" source="./media/migration-components/migration-components.png" alt-text="Diagram showing the key migration components involved in migrating VMs to your Azure Local instance." lightbox="./media/migration-components/migration-components.png":::

[!INCLUDE [important](../includes/azure-local-jumpstart-gems.md)]

The migration process includes the following key components, organized into two layers:

**Azure layer:**
- Azure Migrate project. Central to the migration process, used to orchestrate discovery of source VMs and replication of VMs. Both the source and target appliances must register with this project.
- Storage Accounts and Key Vault. Used for storing metadata and replication state data.
- Azure Resource Manager (ARM). Orchestrates and manages resources across Azure and Azure Local by interacting with the Azure Local Resource Provider.

**On-premises layer:**
- Source servers (VMware/Hyper-V). Host the VMs to be migrated.
- Azure Migrate source appliance. Runs on the on-premises VMware or Hyper-V cluster to discover and prepare VMs for migration.
- Azure Migrate target appliance. Runs on the Azure Local instance, which receives the migrated VMs.
- Arc Resource Bridge (ARB) and Hyper-V Failover Cluster Manager. Used for orchestration and VM provisioning.

> [!NOTE]
> The disks and data of VMs (VMware/Hyper-V) being migrated aren't stored in the associated Azure Storage account. Only metadata and replication data are stored in the Azure Storage account.