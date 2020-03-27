---
title: App Service on Azure Stack Hub update 8 release notes 
description: Learn about what's in update eight for App Service on Azure Stack Hub, the known issues, and where to download the update.
author: apwestgarth
manager: stefsch

ms.topic: article
ms.date: 03/05/2020
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 03/25/2019

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

# App Service on Azure Stack Hub update 8 release notes

These release notes describe the improvements and fixes in Azure App Service on Azure Stack Hub Update 8 and any known issues. Known issues are divided into issues directly related to the deployment, update process, and issues with the build (post-installation).

> [!IMPORTANT]
> Apply the 1910 update to your Azure Stack integrated system or deploy the latest Azure Stack development kit before deploying Azure App Service 1.8.

## Build reference

The App Service on Azure Stack Hub Update 8 build number is **86.0.2.13**

### Prerequisites

Refer to the [Before You Get Started documentation](azure-stack-app-service-before-you-get-started.md) before beginning deployment.

Before you begin the upgrade of Azure App Service on Azure Stack to 1.8:

- Ensure all roles are Ready in the Azure App Service Administration in the Azure Stack Admin Portal

- Back up the App Service and Master Databases:
  - AppService_Hosting;
  - AppService_Metering;
  - Master

- Back up the Tenant App content file share

- Syndicate the **Custom Script Extension** version **1.9.3** from the Marketplace

### New features and fixes

Azure App Service on Azure Stack Update 8 includes the following improvements and fixes:

- Updates to **App Service Tenant, Admin, Functions portals and Kudu tools**. Consistent with Azure Stack Portal SDK version.

- Updates **Azure Functions runtime** to **v1.0.12615**.

- Updates to core service to improve reliability and error messaging enabling easier diagnosis of common issues.

- **Updates to the following application frameworks and tools**:
  - ASP.NET Core 3.1.0
  - ASP.NET Core 3.0.1
  - ASP.NET Core 2.2.8
  - ASP.NET Core Module v2 13.1.19331.0
  - Azul OpenJDK 8.38.0.13
  - Tomcat 7.0.94
  - Tomcat 8.5.42
  - Tomcat 9.0.21
  - PHP 7.1.32
  - PHP 7.2.22
  - PHP 7.3.9
  - Updated Kudu to 85.11024.4154
  - MSDeploy 3.5.80916.15
  - NodeJS 10.16.3
  - NPM 6.9.0
  - Git for Windows 2.19.1.0

- **Updates to underlying operating system of all roles**:
  - [2019-12 Cumulative Update for Windows Server 2016 for x64-based Systems (KB4530689)](https://support.microsoft.com/help/4530689)

- **Managed Disk support for new deployments**

All new deployments of Azure App Service on Azure Stack Hub will make use of managed disks for all Virtual Machines and Virtual Machine Scale Sets.  All existing deployments will continue to use unmanaged disks.

- **TLS 1.2 Enforced by Front End load balancers**

As of this update **TLS 1.2** will be enforced for all applications.

### Known issues (upgrade)

- Upgrade will fail if SQL Server Always On Cluster has failed over to secondary node

During upgrade, there is a call to check database existence using the master connection string that will fail because the login was on the previous master node.

Take one of the following actions and click retry within the installer.

- Copy the appservice_hostingAdmin login from the now secondary sql node;

**OR**

- Fail over the SQL Cluster to the previous active node.

### Post-deployment steps

> [!IMPORTANT]
> If you have provided the App Service resource provider with a SQL Always On Instance you MUST [add the appservice_hosting and appservice_metering databases to an availability group](https://docs.microsoft.com/sql/database-engine/availability-groups/windows/availability-group-add-a-database) and synchronize the databases to prevent any loss of service in the event of a database failover.

### Known issues (post-installation)

- Workers are unable to reach file server when App Service is deployed in an existing virtual network and the file server is only available on the private network,  as called out in the Azure App Service on Azure Stack deployment documentation.

  If you chose to deploy into an existing virtual network and an internal IP address to connect to your file server, you must add an outbound security rule, enabling SMB traffic between the worker subnet and the file server. Go to the WorkersNsg in the Admin Portal and add an outbound security rule with the following properties:
  - Source: Any
  - Source port range: *
  - Destination: IP Addresses
  - Destination IP address range: Range of IPs for your file server
  - Destination port range: 445
  - Protocol: TCP
  - Action: Allow
  - Priority: 700
  - Name: Outbound_Allow_SMB445

- New deployments of Azure App Service on Azure Stack Hub 1.8 require databases to be converted to contained databases

Due to a regression in this release, both App Service databases (appservice_hosting and appservice_metering) must be converted to contained databases when **newly** deployed.  This **DOES NOT** impact **upgraded** deployments.

> [!IMPORTANT]
> This procedure takes approximately 5-10 minutes. This procedure involves killing the existing database login sessions. Plan for downtime to migrate and validate Azure App Service on Azure Stack Hub post migration
>
>

1. Add [AppService databases (appservice_hosting and appservice_metering) to an Availability group](https://docs.microsoft.com/sql/database-engine/availability-groups/windows/availability-group-add-a-database).

1. Enable contained database.

    ```sql

        sp_configure 'contained database authentication', 1;
        GO
        RECONFIGURE;
            GO
    ```

1. Converting a database to partially contained. This step will incur downtime as all active sessions need to be killed.

    ```sql
        /******** [appservice_metering] Migration Start********/
            USE [master];

            -- kill all active sessions
            DECLARE @kill varchar(8000) = '';  
            SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
            FROM sys.dm_exec_sessions
            WHERE database_id  = db_id('appservice_metering')

            EXEC(@kill);

            USE [master]  
            GO  
            ALTER DATABASE [appservice_metering] SET CONTAINMENT = PARTIAL  
            GO  

        /********[appservice_metering] Migration End********/

        /********[appservice_hosting] Migration Start********/

            -- kill all active sessions
            USE [master];

            DECLARE @kill varchar(8000) = '';  
            SELECT @kill = @kill + 'kill ' + CONVERT(varchar(5), session_id) + ';'  
            FROM sys.dm_exec_sessions
            WHERE database_id  = db_id('appservice_hosting')

            EXEC(@kill);

            -- Convert database to contained
            USE [master]  
            GO  
            ALTER DATABASE [appservice_hosting] SET CONTAINMENT = PARTIAL  
            GO  

            /********[appservice_hosting] Migration End********/
    ```

1. Migrate logins to contained database users.

    ```sql
        IF EXISTS(SELECT * FROM sys.databases WHERE Name=DB_NAME() AND containment = 1)
        BEGIN
        DECLARE @username sysname ;  
        DECLARE user_cursor CURSOR  
        FOR
            SELECT dp.name
            FROM sys.database_principals AS dp  
            JOIN sys.server_principals AS sp
                ON dp.sid = sp.sid  
                WHERE dp.authentication_type = 1 AND dp.name NOT IN ('dbo','sys','guest','INFORMATION_SCHEMA');
            OPEN user_cursor  
            FETCH NEXT FROM user_cursor INTO @username  
                WHILE @@FETCH_STATUS = 0  
                BEGIN  
                    EXECUTE sp_migrate_user_to_contained
                    @username = @username,  
                    @rename = N'copy_login_name',  
                    @disablelogin = N'do_not_disable_login';  
                FETCH NEXT FROM user_cursor INTO @username  
            END  
            CLOSE user_cursor ;  
            DEALLOCATE user_cursor ;
            END
        GO
    ```

    **Validate**

1. Check if SQL Server has containment enabled.

    ```sql
        sp_configure  @configname='contained database authentication'
    ```

1. Check existing contained behavior.

    ```sql
        SELECT containment FROM sys.databases WHERE NAME LIKE (SELECT DB_NAME())
    ```

- Unable to scale out workers

  New workers are unable to acquire the required database connection string.  To remedy this situation, connect to one of your controller instances, for example CN0-VM and run the following PowerShell script:

    ```powershell
    
    [System.Reflection.Assembly]::LoadWithPartialName("Microsoft.Web.Hosting")
    $siteManager = New-Object Microsoft.Web.Hosting.SiteManager

    $builder = New-Object System.Data.SqlClient.SqlConnectionStringBuilder -ArgumentList (Get-AppServiceConnectionString -Type Hosting)
    $conn = New-Object System.Data.SqlClient.SqlConnection -ArgumentList $builder.ToString()

    $siteManager.RoleServers | Where-Object {$_.IsWorker} | ForEach-Object {
        $worker = $_
        $dbUserName = "WebWorker_" + $worker.Name

        if (!$siteManager.ConnectionContexts[$dbUserName]) {
            $dbUserPassword = [Microsoft.Web.Hosting.Common.Security.PasswordHelper]::GenerateDatabasePassword()

            $conn.Open()
            $command = $conn.CreateCommand()
            $command.CommandText = "CREATE USER [$dbUserName] WITH PASSWORD = '$dbUserPassword'"
            $command.ExecuteNonQuery()
            $conn.Close()
            
            $conn.Open()
            $command = $conn.CreateCommand()
            $command.CommandText = "ALTER ROLE [WebWorkerRole] ADD MEMBER [$dbUserName]"
            $command.ExecuteNonQuery()
            $conn.Close()
            
            $builder.Password = $dbUserPassword
            $builder["User ID"] = $dbUserName
            
            $siteManager.ConnectionContexts.Add($dbUserName, $builder.ToString())
        }
    }

    $siteManager.CommitChanges()
        
    ```

### Known issues for Cloud Admins operating Azure App Service on Azure Stack

Refer to the documentation in the [Azure Stack 1907 Release Notes](azure-stack-release-notes-1907.md)

## Next steps

- For an overview of Azure App Service, see [Azure App Service on Azure Stack overview](azure-stack-app-service-overview.md).
- For more information about how to prepare to deploy App Service on Azure Stack, see [Before you get started with App Service on Azure Stack](azure-stack-app-service-before-you-get-started.md).
