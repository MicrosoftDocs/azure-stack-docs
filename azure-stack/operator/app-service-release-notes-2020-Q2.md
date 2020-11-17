---
title: App Service on Azure Stack Hub 2002 Q2 release notes 
description: Learn about what's in the 2002 Q2 release for App Service on Azure Stack Hub, the known issues, and where to download the update.
author: apwestgarth
manager: stefsch

ms.topic: article
ms.date: 11/17/2020
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 04/30/2020

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

# App Service on Azure Stack Hub 2020 Q2 release notes

These release notes describe the improvements and fixes in Azure App Service on Azure Stack Hub 2020 Q2 and any known issues. Known issues are divided into issues directly related to the deployment, update process, and issues with the build (post-installation).

[!INCLUDE [Azure Stack Hub update reminder](../includes/app-service-hub-update-banner.md)]

## Build reference

The App Service on Azure Stack Hub 2020 Q2 build number is **87.0.2.10**

## Prerequisites

Refer to the [Before You Get Started documentation](azure-stack-app-service-before-you-get-started.md) before beginning deployment.

Before you begin the upgrade of Azure App Service on Azure Stack to 2020 Q2:

- Ensure all roles are Ready in the Azure App Service Administration in the Azure Stack Hub Admin Portal

- Backup App Service Secrets using the App Service Administration in the Azure Stack Hub Admin Portal

- Back up the App Service and Master Databases:
  - AppService_Hosting;
  - AppService_Metering;
  - Master

- Back up the Tenant App content file share

  > [!Important]
  > Cloud operators are responsible for the maintenance and operation of the File Server and SQL Server.  The resource provider does not manage these resources.  The cloud operator is responsible for backing up the App Service databases and tenant content file share.

- Syndicate the **Custom Script Extension** version **1.9.3** from the Marketplace



## Updates

Azure App Service on Azure Stack Update Q2 includes the following improvements and fixes:

- Updates to **App Service Tenant, Admin, Functions portals and Kudu tools**. Consistent with Azure Stack Portal SDK version.

- Updates **Azure Functions runtime** to **v1.0.13021**.

- Updates to core service to improve reliability and error messaging enabling easier diagnosis of common issues.

- **Updates to the following application frameworks and tools**:
  - ASP.NET Framework 4.7.2
  - ASP.NET Core 3.1.3
  - ASP.NET Core Module v2 13.1.19331.0
  - PHP 7.4.2
  - Updated Kudu to 86.20224.4450
  - NodeJS 
    - 8.17.0
    - 10.19.0
    - 12.13.0
    - 12.15.0
  - NPM
    - 5.6.0
    - 6.1.0
    - 6.12.0
    - 6.13.4
  
- **Updates to underlying operating system of all roles**:
  - [2020-04 Cumulative Update for Windows Server 2016 for x64-based Systems (KB4550929)](https://support.microsoft.com/help/4550929)
  - [2020-04 Servicing Stack Update for Windows Server 2016 for x64-based Systems (KB4550994)](https://support.microsoft.com/help/4550994)

- **Cumulative Updates for Windows Server are now applied to Controller roles as part of deployment and upgrade**

- **Updated default Virtual Machine and Scale set skus for new deployments**:
To maintain consistency with our public cloud service, new deployments of Azure App Service on Azure Stack Hub will use the following SKUs for the underlying machines and scale sets used to operate the resource provider
  
  | Role | Minimum SKU |
  | --- | --- |
  | Controller | Standard_A4_v2 - (4 cores, 8192 MB) |
  | Management | Standard_D3_v2 - (4 cores, 14336 MB) |
  | Publisher | Standard_A2_v2 - (2 cores, 4096 MB) |
  | FrontEnd | Standard_A4_v2 - (4 cores, 8192 MB) |
  | Shared Worker | Standard_A4_v2 - (4 cores, 8192 MB) |
  | Small dedicated worker | Standard_A1_v2 - (1 cores, 2048 MB) |
  | Medium dedicated worker | Standard_A2_v2 - (2 cores, 4096 MB) |
  | Large dedicated worker | Standard_A4_v2 - (4 cores, 8192 MB) |

For ASDK deployments, you can scale the instances down to lower SKUs to reduce the core and memory commit but you will experience a performance degradation.

## Issues fixed in this release

- Upgrades will now complete if SQL Always On Cluster has failed over to secondary node
- New deployments of Azure App Service on Azure Stack Hub no longer require databases to be manually converted to contained databases
- Adding additional workers or infrastructure role instances will complete correctly without manual intervention
- Adding custom worker tiers will complete correctly without manual intervention
- Removal of custom worker tiers now completes without portal errors
- Workers are no longer marked as ready if the local disk is out of space
- Time out increased for retrieving the Azure Resource Manager Certificate
- The number of messages retrieved, from server logs and displayed in the Admin Portal, is limited to stay underneath the max Azure Resource Manager Request size
- Time out issue causing usage service startup issues
- Resolved database deployment issue when creating Orchard CMS sites
- Controllers are now updated with Windows Cumulative Updates as part of deployment and upgrade
- App Service no longer locks operations when custom domain verification fails

## Pre-Update steps

Review the [known issues for update](#known-issues-update) and take any action prescribed.

## Post-deployment steps

> [!IMPORTANT]
> If you have provided the App Service resource provider with a SQL Always On Instance you MUST [add the appservice_hosting and appservice_metering databases to an availability group](/sql/database-engine/availability-groups/windows/availability-group-add-a-database) and synchronize the databases to prevent any loss of service in the event of a database failover.

## Known issues (update)

- In situations where a customer has converted the appservice_hosting and appservice_metering databases to contained database, upgrade may fail if logins have not been successfully migrated to contained users

Customers that have converted the appservice_hosting and appservice_metering databases to contained database post deployment, and have not successfully migrated the database logins to contained users, may experience upgrade failures.  

Customers must execute the following script against the SQL Server hosting appservice_hosting and appservice_metering before upgrading your Azure App Service on Azure Stack Hub installation to 2020 Q2.  **This script is non-destructive and will not cause downtime**.

This script must be run under the following conditions

- By a user that has the system administrator privilege, for example the SQL SA Account;
- If using SQL Always on, ensure the script is run from the SQL instance that contains all App Service logins in the form:

    - appservice_hosting_FileServer
    - appservice_hosting_HostingAdmin
    - appservice_hosting_LoadBalancer
    - appservice_hosting_Operations
    - appservice_hosting_Publisher
    - appservice_hosting_SecurePublisher
    - appservice_hosting_WebWorkerManager
    - appservice_metering_Common
    - appservice_metering_Operations
    - All WebWorker logins - which are in the form WebWorker_<instance ip address>

```sql
        USE appservice_hosting
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

        USE appservice_metering
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

## Known issues (post-installation)

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

### Known issues for Cloud Admins operating Azure App Service on Azure Stack

- Tenants unable to create App Service Plan using new on App Service Plan view in tenant portal

When creating a new application, tenants can create App Service Plans during the create app workflow, or when changing the App Service Plan for a current app, or via the App Service Plan marketplace item

- Custom domains are not supported in disconnected environments

App Service performs domain ownership verification against public DNS endpoints, as a result custom domains are not supported in disconnected scenarios.

- In some cases workers fail to satisfy health checks (insufficient disk space)

In some cases, where a high number of sites are allocated to a worker or a site is handling a large number of requests, the worker will generate a large number of runtime log files in C:\DWAS\LogFiles.  This is due to a bug in the cleanup logic for these log files.  This has been fixed in App Service on Azure Stack Hub 2020 Q3, we encourage customers to upgrade to the 2020 Q3 release as soon as possible.

> [!NOTE]
> In order to update to Azure App Service on Azure Stack Hub 2020 Q3 you **must** upgrade to Azure Stack Hub 2008

## Next steps

- For an overview of Azure App Service, see [Azure App Service on Azure Stack overview](azure-stack-app-service-overview.md).
- For more information about how to prepare to deploy App Service on Azure Stack, see [Before you get started with App Service on Azure Stack](azure-stack-app-service-before-you-get-started.md).
