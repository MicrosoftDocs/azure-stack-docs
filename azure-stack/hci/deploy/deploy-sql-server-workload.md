---
title: Deploy SQL Server on Azure Stack HCI (AKS-HCI)
description: This topic provides guidance on how to deploy SQL Server on Azure Stack HCI.
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 12/15/2020
---

# Deploy SQL Server on Azure Stack HCI

>Applies to: Azure Stack HCI, version 20H2; SQL Server (all supported versions)

This topic provides guidance on how to plan, configure, and deploy SQL Server on the Azure Stack HCI operating system. The operating system is a hyperconverged infrastructure (HCI) cluster solution that hosts virtualized Windows and Linux workloads and their storage in a hybrid on-premises environment.

## Solution overview
Azure Stack HCI provides a highly available, cost efficient, flexible platform to run SQL Server and Storage Spaces Direct. Azure Stack HCI can run Online Transaction Processing (OLTP) workloads, data warehouse and BI, and AI and advanced analytics over big data.

The platform’s flexibility is especially important for mission critical databases. You can run SQL Server on virtual machines (VMs) that use either Windows Server or Linux, which allows you to consolidate multiple database workloads and add more VMs to your Azure Stack HCI environment as needed. Azure Stack HCI also enables you to integrate SQL Server with Azure Site Recovery to provide a cloud-based migration, restoration, and protection solution for your organization’s data that is reliable and secure.

## Deploy SQL Server
This section describes at a high level how to get hardware for SQL Server on Azure Stack HCI, and Windows Admin Center to manage the operating system on your servers. Information on setting up SQL Server, monitor and performance tuning, and using High Availability (HA) and Azure hybrid services is included.

### Step 1: Get hardware for SQL Server on Azure Stack HCI
Refer to your specific hardware instructions for this step. For more information, reference your preferred Microsoft hardware partner in the [Azure Stack HCI Catalog](https://azure.microsoft.com/products/azure-stack/hci/catalog/).

> [!NOTE]
> In the catalog, you can filter to see High performance Microsoft SQL Server hardware vendors.

For details on Azure Stack HCI deployment options and installing Windows Admin Center to manage your servers, see [Deploy the Azure Stack HCI operating system](operating-system.md).

### Step 2: Install SQL Server on Azure Stack HCI
You can install SQL Server on VMs running either Windows Server or Linux depending on your requirements.

For instructions on installing SQL Server, see:
- [SQL Server installation guide for Windows](https://docs.microsoft.com/sql/database-engine/install-windows/install-sql-server?view=sql-server-ver15).
- [Installation guidance for SQL Server on Linux](https://docs.microsoft.com/sql/linux/sql-server-linux-setup?view=sql-server-ver15).

### Step 3: Monitor and performance tune SQL Server
Microsoft provides a comprehensive set of tools for monitoring events in SQL Server and for tuning the physical database design. Tool choice depends on the type of monitoring or tuning that you want to perform.

To ensure the performance and health of your SQL Server instances on Azure Stack HCI, see [Performance Monitoring and Tuning Tools](https://docs.microsoft.com/sql/relational-databases/performance/performance-monitoring-and-tuning-tools?view=sql-server-ver15).

For tuning SQL Server 2017 and SQL Server 2016, see [Recommended updates and configuration options for SQL Server 2017 and 2016 with high-performance workloads](https://support.microsoft.com/help/4465518/recommended-updates-and-configurations-for-sql-server).

### Step 4: Use SQL Server high availability features


### Step 5: Set up Azure hybrid services


## Next steps
For more information about working with SQL Server, see:
- [Tutorial: Getting Started with the Database Engine](https://docs.microsoft.com/sql/relational-databases/tutorial-getting-started-with-the-database-engine?view=sql-server-ver15)
