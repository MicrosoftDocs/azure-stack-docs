---
title: Deploy SQL Server on Azure Local Version 23H2
description: This article provides guidance on how to deploy SQL Server on Azure Local, version 23H2.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 10/10/2025
ms.subservice: hyperconverged
---

# Deploy SQL Server on Azure Local version 23H2

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article provides guidance on how to deploy SQL Server on Azure Local, version 23H2.

## Solution overview

Azure Local provides a flexible platform to run SQL Server and Storage Spaces Direct. The platform is cost efficient and highly available. Azure Local can run:

- Online transaction processing (OLTP) workloads.
- Data warehouse and business intelligence.
- AI and advanced analytics over big data.

The platform's flexibility is especially important for mission-critical databases. You can run SQL Server on virtual machines (VMs) that use either Windows Server or Linux. You can consolidate multiple database workloads and add more VMs to your Azure Local environment as needed. You can also use Azure Local to integrate SQL Server with Azure Site Recovery. You gain a cloud-based solution that supports migration, restoration, and protection for your organization's data.

## Deploy SQL Server

This section describes at a high level how to acquire hardware for SQL Server on Azure Local. Information is included on how to:

- Set up SQL Server.
- Perform monitoring and performance tuning.
- Use high availability (HA) and Azure hybrid services.

### Step 1: Acquire hardware from the Azure Local catalog

First, you need to procure hardware. Locate your preferred Microsoft hardware partner in the [Azure Local catalog](https://azurestackhcisolutions.azure.microsoft.com/). Then, purchase an integrated system or premium solution with the Azure Stack HCI operating system preinstalled. In the catalog, you can filter to see vendor hardware that's optimized for this type of workload.

Otherwise, use a validated system from the catalog and deploy it on that hardware.

For details on Azure Local deployment options, see [Deploy the Azure Stack HCI operating system](deployment-install-os.md).

Next, [deploy Azure Local, version 23H2, by using the Azure portal](deploy-via-portal.md). You can also [deploy Azure Local, version 23H2, by using an Azure Resource Manager deployment template](deployment-azure-resource-manager-template.md).

### Step 2: Install SQL Server on Azure Local

You can install SQL Server on VMs running either Windows Server or Linux depending on your requirements.

For instructions on how to install SQL Server, see:

- [SQL Server installation guide for Windows](/sql/database-engine/install-windows/install-sql-server)
- [Installation guidance for SQL Server on Linux](/sql/linux/sql-server-linux-setup)

For information on licensing and billing for SQL Server, see [Manage licensing and billing of SQL Server](/sql/sql-server/azure-arc/manage-license-billing).

### Step 3: Monitor and performance tune SQL Server

Microsoft provides a comprehensive set of tools that you can use to monitor events in SQL Server and tune the physical database design. Tool choice depends on the type of monitoring or tuning that you want to perform.

To ensure the performance and health of your SQL Server instances on Azure Local, see [Performance monitoring and tuning tools](/sql/relational-databases/performance/performance-monitoring-and-tuning-tools).

For tuning SQL Server 2017 and SQL Server 2016, see [Recommended updates and configuration options for SQL Server 2017 and 2016 with high-performance workloads](/troubleshoot/sql/database-engine/performance/recommended-updates-configuration-workloads).

### Step 4: Use SQL Server high-availability features

Azure Local uses [Windows Server failover clustering with SQL Server](/sql/sql-server/failover-clusters/windows/windows-server-failover-clustering-wsfc-with-sql-server) to support SQL Server running in VMs if hardware fails. SQL Server also offers [Always On availability groups](/sql/database-engine/availability-groups/windows/overview-of-always-on-availability-groups-sql-server) to provide database-level HA to help with application and software faults. In addition to Windows Server failover clustering and availability groups, Azure Local can use [Always On failover cluster instance](/sql/sql-server/failover-clusters/windows/always-on-failover-cluster-instances-sql-server). Failover cluster instance is based on [Storage Spaces Direct](/windows-server/storage/storage-spaces/storage-spaces-direct-overview) technology for shared storage.

These options all work with the [Azure Cloud witness](/windows-server/failover-clustering/deploy-cloud-witness) for quorum control. We recommend that you use cluster [AntiAffinity](/windows-server/failover-clustering/cluster-affinity) rules in Windows Server failover clustering for VMs that are placed on different physical nodes. These rules help to maintain uptime for SQL Server if the host fails when you configure Always On availability groups.

### Step 5: Set up Azure hybrid services

Several Azure hybrid services help you keep your SQL Server data and applications secure. [Azure Site Recovery](https://azure.microsoft.com/products/site-recovery/) is a disaster recovery solution. For more information about how to use this service to protect the SQL Server back end of an application to help keep workloads online, see [Set up disaster recovery for SQL Server](/azure/site-recovery/site-recovery-sql).

[Azure Backup](https://azure.microsoft.com/products/backup/) lets you define backup policies to protect enterprise workloads and supports backing up and restoring SQL Server consistency. For more information about how to back up your on-premises SQL data, see:

- [Install Azure Backup Server](/azure/backup/backup-azure-microsoft-azure-backup)
- [Back up Azure Local VMs with Microsoft Azure Backup Server](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines)

Alternatively, you can use [SQL Server managed backup to Azure](/sql/relational-databases/backup-restore/sql-server-managed-backup-to-microsoft-azure) in SQL Server to manage Azure Blob Storage backups.

For more information about how to use this option for off-site archiving, see:

- [Tutorial: Use Azure Blob Storage with SQL Server](/sql/relational-databases/tutorial-use-azure-blob-storage-service-with-sql-server-2016)
- [Quickstart: SQL backup and restore to Azure Blob Storage](/sql/relational-databases/tutorial-sql-server-backup-and-restore-to-azure-blob-storage-service)

In addition to these backup scenarios, you can set up other database services that SQL Server offers, including:

- [Azure Data Factory](/azure/architecture/data-science-process/overview)
- [Azure feature pack for SQL Server Integration Services (SSIS)](/sql/integration-services/azure-feature-pack-for-integration-services-ssis)

## Related content

- For more information about working with SQL Server, see [Tutorial: Get started with the Database Engine](/sql/relational-databases/tutorial-getting-started-with-the-database-engine).
