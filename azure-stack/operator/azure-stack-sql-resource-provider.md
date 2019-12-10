---
title: Use SQL databases
titleSuffix: Azure Stack
description: Learn how to use the SQL Server resource provider to offer SQL databases as a service on Azure Stack.
services: azure-stack
documentationCenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/02/2019
ms.author: mabrigg
ms.reviewer: xiaofmao
ms.lastreviewed: 10/25/2018
---

# Use SQL databases on Azure Stack

Use the SQL resource provider to offer SQL databases as a service on [Azure Stack](azure-stack-overview.md). After you install the resource provider and connect it to one or more SQL Server instances, you and your users can create:

- Databases for cloud-native apps.
- Websites that use SQL.
- Workloads that use SQL.

There are several limitations to consider, before installing the MySQL resource provider:

- Users can only create and manage individual databases. Database Server instance is not accessible to end users. This may limit compatibility with on-premises database applications that need access to master, Temp DB, or to dynamically manage databases.
- Your Azure Stack operator is responsible for deploying, updating, securing, configuring and maintaining the SQL database servers and hosts. The RP service does not provide any host and database server instance management functionality. 
- Databases from different users in different subscriptions may be located on the same database server instance. The RP does not provide any mechanism for isolating databases on different hosts or database server instances.
- The RP do not provide any reporting on tenant usage of databases.

## SQL resource provider adapter architecture

The resource provider consists of the following components:

- **The SQL resource provider adapter virtual machine (VM)**, which is a Windows Server VM that runs the provider services.
- **The resource provider**, which processes requests and accesses database resources.
- **Servers that host SQL Server**, which provide capacity for databases called hosting servers.

You must create at least one instance of SQL Server or provide access to external SQL Server instances.

> [!NOTE]
> Hosting servers that are installed on Azure Stack integrated systems must be created from a tenant subscription. They can't be created from the default provider subscription. They must be created from the tenant portal or by using PowerShell with the appropriate sign-in. All hosting servers are billable VMs and must have licenses. The service admin can be the owner of the tenant subscription.

## Next steps

[Deploy the SQL Server resource provider](azure-stack-sql-resource-provider-deploy.md)
