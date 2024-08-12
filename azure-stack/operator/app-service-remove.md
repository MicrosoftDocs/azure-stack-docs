---
title: Remove Azure App Service from Azure Stack Hub 
description: Learn how to remove Azure App Service from Azure Stack Hub.
author: sethmanheim
ms.topic: article
ms.date: 08/12/2024
ms.author: sethm
ms.reviewer: anwestg
ms.lastreviewed: 04/17/2020

---

# Remove Azure App Service from Azure Stack Hub

This article describes how to remove the Azure App Service resource provider and related components from Azure Stack Hub.

## Remove resource provider

> [!IMPORTANT]
> This operation removes all tenant resources, removes the service and quotas from all plans, and removes the Azure App Service resource provider in its entirety. If you have deployed the App Service Highly Available File Server and SQL Server Quickstart template, these resources are also removed, as they are deployed in the same resource group as Azure App Service on Azure Stack Hub.

To remove Azure App Service from Azure Stack Hub, follow this one step:

- Delete the resource group that holds the Azure App Service on Azure Stack Hub Resources; for example, **AppService.local**.

## Remove databases and file share content

You only need to follow this section if your SQL Server and/or File Server is deployed off-stamp or in a different resource group, otherwise continue to the next section.

### Remove databases and logins

1. If using **SQL Server Always On**, remove the **AppService_Hosting** and **AppService_Metering** databases from the Availability Group:

1. Execute the following SQL Script to remove the databases and logins

   ```sql
   --******************************************************************
   /*
   Script to clean up App Service objects (databases and logins).
   */
   USE [master]
   GO

   DROP DATABASE [appservice_hosting]
   GO

   DROP DATABASE [appservice_metering]
   GO

   DECLARE @sql NVARCHAR(MAX) = N'';    
 
   SELECT @sql += '
   DROP LOGIN [' + name + '];' 
   from master.sys.sql_logins
   WHERE name LIKE  '%_hosting_%' OR 
   name LIKE  '%_metering_%' OR
   name LIKE  '%WebWorker_%';

   PRINT @sql;
   EXEC sp_executesql @sql;
   PRINT 'Completed';

   --******************************************************************
   ```

### Remove the application file content from the file server

Remove the content fileshare from your file server.

## Next steps

To reinstall, return to the [Prerequisites for deploying App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md) article.
