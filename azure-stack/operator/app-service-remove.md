---
title: Remove Azure App Service from Azure Stack Hub 
description: Learn how to remove Azure App Service from Azure Stack Hub
author: apwestgarth

ms.topic: article
ms.date: 04/17/2020
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 04/17/20207

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

# Remove Azure App Service from Azure Stack Hub

> [!Important]
> This operation will remove all tenant resources, remove the service and quotas from all plans and remove the Azure App Service resource provider in it's entirety.  If you have deployed the App Service Highly Available File Server and SQL Server Quickstart template, these resources will also be removed as they are deployed in the same resource group as Azure App Service on Azure Stack Hub.

To remove Azure App Service from Azure Stack Hub, follow this one simple step.

1. Delete the Resource Group which holds the Azure App Service on Azure Stack Hub Resources

## Additional steps if SQL Server and File Server is deployed Off stamp or in a different resource group

### Remove Databases and Logins

1. If you are using SQL Always On, remove the AppService_Hosting and AppService_Metering databases from the Availability Group

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

### Remove the application file content from the File Server

1. Remove the content fileshare from your file server.