---
title: Use MySQL databases as PaaS on Azure Stack Hub | Microsoft Docs 
description: Learn how to deploy the MySQL Resource Provider and provide MySQL databases as a service on Azure Stack Hub. 
author: mattbriggs
ms.topic: article 
ms.date: 1/22/2020
ms.author: mabrigg
ms.reviewer: xiaofmao
ms.lastreviewed: 10/25/2018

---

# Use MySQL databases on Microsoft Azure Stack Hub

Use the MySQL resource provider to offer MySQL databases on [Azure Stack Hub](azure-stack-overview.md). After you deploy the resource provider and connect it to one or more MySQL server instances, you can create:

* MySQL databases for cloud-native apps.
* MySQL databases for web applications.  

There are several limitations to consider, before installing the MySQL resource provider:

- Users can only create and manage individual databases. Database Server instance is not accessible to end users. This may limit compatibility with on-premises database applications that need access to master, Temp DB, or to dynamically manage databases.
- Your Azure Stack Hub operator is responsible for deploying, updating, securing, configuring and maintaining the MySQL database servers and hosts. The RP service does not provide any host and database server instance management functionality. 
- Databases from different users in different subscriptions may be located on the same database server instance. The RP does not provide any mechanism for isolating databases on different hosts or database server instances.
- The RP does not provide any reporting on tenant usage of databases.

## MySQL resource provider adapter architecture

The resource provider has the following components:

* **The MySQL resource provider adapter virtual machine (VM)**, which is a Windows Server VM that's running the provider services.
* **The resource provider**, which processes requests and accesses database resources.
* **Servers that host MySQL Server**, which provide capacity for databases that are called hosting servers. You can create MySQL instances yourself, or provide access to external MySQL instances. The [Azure Stack Hub Quickstart Gallery](https://github.com/Azure/AzureStack-QuickStart-Templates/tree/master/mysql-standalone-server-windows) has an example template that you can use to:

  * Create a MySQL server for you.
  * Download and deploy a MySQL Server from Azure Marketplace.

> [!NOTE]
> Hosting servers that are installed on Azure Stack Hub integrated systems must be created from a tenant subscription. They can't be created from the default provider subscription. They must be created from the user portal or from a PowerShell session with an appropriate sign-in. All hosting servers are billable VMs and must have licenses. The service administrator can be the owner of the tenant subscription.

### Required privileges

The system account must have the following privileges:

* **Database:** create, drop
* **Login:** create, set, drop, grant, revoke  

## Next steps

[Deploy the MySQL resource provider](azure-stack-mysql-resource-provider-deploy.md)
