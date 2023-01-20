---
title: Deploy SQL Server on Azure Stack HCI (AKS-HCI)
description: This topic provides guidance on how to deploy SQL Server on Azure Stack HCI.
author: hsuzuki
ms.author: hsuzuki
ms.topic: how-to
ms.date: 01/11/2021
---

# Deploy SQL Server on Azure Stack HCI

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; SQL Server (all supported versions)

This topic provides guidance on how to plan, configure, and deploy SQL Server on the Azure Stack HCI operating system. The operating system is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment.

## Solution overview
Azure Stack HCI provides a highly available, cost efficient, flexible platform to run SQL Server and Storage Spaces Direct. Azure Stack HCI can run Online Transaction Processing (OLTP) workloads, data warehouse and BI, and AI and advanced analytics over big data.

The platform’s flexibility is especially important for mission critical databases. You can run SQL Server on virtual machines (VMs) that use either Windows Server or Linux, which allows you to consolidate multiple database workloads and add more VMs to your Azure Stack HCI environment as needed. Azure Stack HCI also enables you to integrate SQL Server with Azure Site Recovery to provide a cloud-based migration, restoration, and protection solution for your organization’s data that is reliable and secure.

## Deploy SQL Server
This section describes at a high level how to acquire hardware for SQL Server on Azure Stack HCI, and use Windows Admin Center to manage the operating system on your servers. Information on setting up SQL Server, monitoring and performance tuning, and using High Availability (HA) and Azure hybrid services is included.

### Step 1: Acquire hardware from the Azure Stack HCI Catalog
First, you'll need to procure hardware. The easiest way to do that is to locate your preferred Microsoft hardware partner in the [Azure Stack HCI Catalog](https://aka.ms/AzureStackHCICatalog) and purchase an integrated system with the Azure Stack HCI operating system preinstalled. In the catalog, you can filter to see vendor hardware that is optimized for this type of workload.

Otherwise, you'll need to deploy the Azure Stack HCI operating system on your own hardware. For details on Azure Stack HCI deployment options and installing Windows Admin Center, see [Deploy the Azure Stack HCI operating system](./operating-system.md).

Next, use Windows Admin Center to [create an Azure Stack HCI cluster](./create-cluster.md).

### Step 2: Install SQL Server on Azure Stack HCI
You can install SQL Server on VMs running either Windows Server or Linux depending on your requirements.

For instructions on installing SQL Server, see:
- [SQL Server installation guide for Windows](/sql/database-engine/install-windows/install-sql-server?preserve-view=true&view=sql-server-ver15).
- [Installation guidance for SQL Server on Linux](/sql/linux/sql-server-linux-setup?preserve-view=true&view=sql-server-ver15).

### Step 3: Monitor and performance tune SQL Server
Microsoft provides a comprehensive set of tools for monitoring events in SQL Server and for tuning the physical database design. Tool choice depends on the type of monitoring or tuning that you want to perform.

To ensure the performance and health of your SQL Server instances on Azure Stack HCI, see [Performance Monitoring and Tuning Tools](/sql/relational-databases/performance/performance-monitoring-and-tuning-tools?preserve-view=true&view=sql-server-ver15).

For tuning SQL Server 2017 and SQL Server 2016, see [Recommended updates and configuration options for SQL Server 2017 and 2016 with high-performance workloads](https://support.microsoft.com/help/4465518/recommended-updates-and-configurations-for-sql-server).

### Step 4: Use SQL Server high availability features
Azure Stack HCI leverages [Windows Server Failover Clustering with SQL Server](/sql/sql-server/failover-clusters/windows/windows-server-failover-clustering-wsfc-with-sql-server) (WSFC) to support SQL Server running in VMs in the event of a hardware failure. SQL Server also offers [Always On availability groups](/sql/database-engine/availability-groups/windows/always-on-availability-groups-sql-server) (AG) to provide database-level high availability that is designed to help with application and software faults. In addition to WSFC and AG, Azure Stack HCI can use [Always On Failover Cluster Instance](/sql/sql-server/failover-clusters/windows/always-on-failover-cluster-instances-sql-server) (FCI), which is based on [Storage Spaces Direct](/windows-server/storage/storage-spaces/storage-spaces-direct-overview) technology for shared storage.

These options all work with the Microsoft Azure [Cloud witness](/windows-server/failover-clustering/deploy-cloud-witness) for quorum control. We recommend using cluster [AntiAffinity](/windows-server/failover-clustering/cluster-affinity) rules in WSFC for VMs placed on different physical nodes to maintain uptime for SQL Server in the event of host failures when you configure Always On availability groups.

### Step 5: Set up Azure hybrid services
There are several Azure hybrid services that you can use to help keep your SQL Server data and applications secure. [Azure Site Recovery](https://azure.microsoft.com/services/site-recovery/) is a disaster recovery as a service (DRaaS). For more information about using this service to protect the SQL Server back end of an application to help keep workloads online, see [Set up disaster recovery for SQL Server](/azure/site-recovery/site-recovery-sql).

[Azure Backup](https://azure.microsoft.com/services/backup/) lets you define backup policies to protect enterprise workloads and supports backing up and restoring SQL Server consistency. For more information about how to back up your on-premises SQL data, see [Install Azure Backup Server](/azure/backup/backup-azure-microsoft-azure-backup).

Alternatively, you can use the [SQL Server Managed Backup](/sql/relational-databases/backup-restore/sql-server-managed-backup-to-microsoft-azure?preserve-view=true&view=sql-server-ver15) feature in SQL Server to manage Azure Blob Storage backups.

For more information about using this option that is suitable for off-site archiving, see: 

- [Tutorial: Use Azure Blob storage service with SQL Server 2016](/sql/relational-databases/tutorial-use-azure-blob-storage-service-with-sql-server-2016?preserve-view=true&view=sql-server-ver15)
- [Quickstart: SQL backup and restore to Azure Blob storage service](/sql/relational-databases/tutorial-sql-server-backup-and-restore-to-azure-blob-storage-service?preserve-view=true&tabs=SSMS&view=sql-server-ver15)

In addition to these backup scenarios, you can set up other database services that SQL Server offers, including [Azure Data Factory](/azure/machine-learning/team-data-science-process/move-sql-azure-adf) and [Azure Feature Pack for Integration Services (SSIS)](/sql/integration-services/azure-feature-pack-for-integration-services-ssis?preserve-view=true&view=sql-server-ver15).

## Next steps
For more information about working with SQL Server, see:
- [Tutorial: Getting Started with the Database Engine](/sql/relational-databases/tutorial-getting-started-with-the-database-engine?preserve-view=true&view=sql-server-ver15)