---
title: Migrate SQL Server  
description: Migrate SQL Server.
author: apwestgarth
manager: stefsch

ms.topic: article
ms.date: 05/27/2022
ms.author: anwestg
ms.reviewer: 
ms.lastreviewed: 

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

---

# Migrate SQL Server

This document provides instructions on how to migrate to new SQL Server infrastructure for hosting the Azure App Service on Azure Stack Hub Resource Provider databases - appservice_hosting and appservice_metrics.

## Back up App Service secrets
When preparing to migrate, you must backup the App Service keys used by the initial deployment. 

Use the administration portal to back up app service secrets by following these steps: 

1. Sign in to the Azure Stack Hub administrator portal as the service admin.

2. Browse to **App Service** -> **Secrets**. 

3. Select **Download Secrets**.

   ![Download secrets in Azure Stack Hub administrator portal](./media/app-service-migrate-sql-server/download-secrets.png)

4. When secrets are ready for downloading, click **Save** and store the App Service secrets (**SystemSecrets.JSON**) file in a safe location. 

   ![Save secrets in Azure Stack Hub administrator portal](./media/app-service-migrate-sql-server/save-secrets.png)

# Backup the App Service databases from the current server

To restore App Service, you need the **Appservice_hosting** and **Appservice_metering** database backups. We recommend using SQL Server maintenance plans or Azure Backup Server to ensure these databases are backed up and saved securely on a regular basis. However, any method of ensuring regular SQL backups are created can be used.

To manually back up these databases while logged into the SQL Server, use the following PowerShell commands:

  ```powershell
  $s = "<SQL Server computer name>"
  $u = "<SQL Server login>" 
  $p = read-host "Provide the SQL admin password"
  sqlcmd -S $s -U $u -P $p -Q "BACKUP DATABASE appservice_hosting TO DISK = '<path>\hosting.bak'"
  sqlcmd -S $s -U $u -P $p -Q "BACKUP DATABASE appservice_metering TO DISK = '<path>\metering.bak'"
  ```

> [!NOTE]
> If you need to back up SQL AlwaysOn databases, follow [these instructions](/sql/database-engine/availability-groups/windows/configure-backup-on-availability-replicas-sql-server?view=sql-server-2017&preserve-view=true). 

After all databases have been successfully backed up, copy the .bak files to a safe location along with the App Service secrets info.

## Restore the App Service databases on a new production ready SQL Server instance

The App Service SQL Server databases should be restored on a production ready SQL Server instance. 

After [preparing the SQL Server instance](azure-stack-app-service-before-you-get-started.md#prepare-the-sql-server-instance) to host the App Service databases, use these steps to restore databases from backup:

1. Sign in to the SQL Server that will host the recovered App Service databases with admin permissions.
2. Use the following commands to restore the App Service databases from a command prompt running with admin permissions:
    ```dos
    sqlcmd -U <SQL admin login> -P <SQL admin password> -Q "RESTORE DATABASE appservice_hosting FROM DISK='<full path to backup>' WITH REPLACE"
    sqlcmd -U <SQL admin login> -P <SQL admin password> -Q "RESTORE DATABASE appservice_metering FROM DISK='<full path to backup>' WITH REPLACE"
    ```
3. Verify that both App Service databases have been successfully restored and exit SQL Server Management Studio.

## Update connection strings

1. In the Azure Stack Administration Portal navigate to the **ControllersNSG** Network Security Group
1. By default remote desktop access is disabled to all App Service infrastructure roles.  Modify the **Inbound_Rdp_3389** rule action to **Allow** access.
1. Navigate to the resource group containing the App Service Resource Provider Deployment, by default this is AppService.<region> and connect to **CN0-VM**.
1. Stop the **WebFarmService** on all active controllers.  You may need to change the failure actions on the service to "Take no action and manually kill the process" - Note if you take this action you must restore the original behavior of the service once this process is complete.
1. Repeat the steps [Update Hosting Connection string]() and [Update Metering Connection String]() for all controllers within the App Service deployment.
1. [Update the connection strings inside the database]()
1. [Update role instances]()
1. [Update Virtual Machine Scale Set Definitions]()
1. In the Azure Stack Administration Portal navigate back to the **ControllersNSG** Network Security Group
1. Modify the **Inbound_Rdp_3389** rule to deny access.

### Update App Service Hosting Database connection string

1. Open PowerShell as administrator
1. Execute the following script, replacing **<SQL-SERVER_OLD>** and **<SQL-SERVER-NEW>** references accordingly:
```PowerShell
Import-Module AppService
 
$hcnstr = Get-AppServiceConnectionString -Type Hosting
$hbuilder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder($hcnstr)
$hbuilder.'Data Source' = $builder.DataSource.Replace("<SQL-SERVER-OLD>", "<SQL-SERVER-NEW>"))
$hbuilder.ConnectionString
Set-AppServiceConnectionString -Type Hosting -ConnectiongString $hbuilder.ConnectionString
```

1. Close PowerShell session to clear cached variables.

### Update App Service Metering Database connection string

1. Open PowerShell as administrator
1. Execute the following script, replacing **<SQL-SERVER_OLD>** and **<SQL-SERVER-NEW>** references accordingly:
```PowerShell
Import-Module AppService
 
$mcnstr = Get-AppServiceConnectionString -Type Metering
$mbuilder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder($mcnstr)
$mbuilder.'Data Source' = $builder.DataSource.Replace("<SQL-SERVER-OLD>", "<SQL-SERVER-NEW>")
$mbuilder.ConnectionString
set-AppServiceConnectionString -Type Metering -ConnectiongString $mbuilder.ConnectionString -ServerName "<IPv4-OF-CURRENT-CONTROLLER>"
```
1. Close PowerShell session to clear cached variables.

### Update connection strings inside the database

1. Open PowerShell as administrator
1. List the connection contexts retrieved from the database, this command will list the connection contexts
```PowerShell
Import-Module AppService
$manager = New-Object Microsoft.Web.Hosting.SiteManager
$manager.ConnectionContexts | Format-Table ConnectionName, ConnectionString –Wrap
```
1. Update the connection string for each context.  Replace **<CONNECTION-CONTEXT-NAME>** with the context name indicated in step 1.  Replace **<SQL-SERVER-OLD>** and **<SQL-SERVER-NEW>** references:
```PowerShell
$cnstr = $connectio.ConnectionContexts["<CONNECTION-CONTEXT-NAME>"].ConnectionString
$builder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder($cnstr)
$builder.'Data Source' = $builder.DataSource.Replace("<SQL-SERVER-OLD>", "<SQL-SERVER-NEW>")
$builder.ConnectionString
$manager.ConnectionContexts["<CONNECTION-CONTEXT-NAME>"].ConnectionString = $builder.ConnectionString
$manager.CommitChanges()
```
1. Close PowerShell session to clear cached variables.

### Update role instances

1. Start the WebFarmService on the primary controller.
1. Repair all roles to make sure the changes are propogated to every role instance.
1. Wait for all roles to become ready
1. Start WebFarmService on the secondary controller.

### Update Virtual Machine Scale Set Definitions

1. Open PowerShell as administrator and execute the following script:
```PowerShell
Import-Module AppService
Restore-AppServiceRoles
```
1. Close PowerShell session to clear cached variables
1. Check the status of Virtual Machine Scale Sets in the Admin Portal and wait until the status for all App Service scale sets are marked as **succeeded**

