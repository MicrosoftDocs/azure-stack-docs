---
title: App Service on Azure Stack Hub 2021 Q1 release notes 
description: Learn about what's new in the 2021 Q1 release for App Service on Azure Stack Hub, the known issues, and where to download the update.
author: sethmanheim
ms.topic: release-notes
ms.date: 08/12/2024
ms.author: sethm
ms.reviewer: anwestg

---

# App Service on Azure Stack Hub 2021 Q1 release notes

These release notes describe the improvements and fixes in Azure App Service on Azure Stack Hub 2021 Q1 and any known issues. Known issues are divided into issues directly related to the deployment, update process, and issues with the build (post-installation).

[!INCLUDE [Azure Stack Hub update reminder](../includes/app-service-hub-update-banner.md)]

## Build reference

The App Service on Azure Stack Hub 2021 Q1 build number is **91.0.2.20**

## Prerequisites

Refer to the [Before You Get Started documentation](azure-stack-app-service-before-you-get-started.md) before beginning deployment.

Before you begin the upgrade of Azure App Service on Azure Stack to 2021 Q1:

- Ensure your Azure Stack Hub is updated to 2102.

- Ensure all roles are Ready in the Azure App Service Administration in the Azure Stack Hub Admin Portal

- Backup App Service Secrets using the App Service Administration in the Azure Stack Hub Admin Portal

- Back up the App Service and SQL Server Master Databases:
  - AppService_Hosting;
  - AppService_Metering;
  - Master

- Back up the Tenant App content file share

  > [!Important]
  > Cloud operators are responsible for the maintenance and operation of the File Server and SQL Server.  The resource provider does not manage these resources.  The cloud operator is responsible for backing up the App Service databases and tenant content file share.

- Syndicate the **Custom Script Extension** version **1.9.3** from the Marketplace

## Updates

Azure App Service on Azure Stack Update 2021 Q1 includes the following improvements and fixes:

- Updates to **App Service Tenant, Admin, Functions portals and Kudu tools**. Consistent with Azure Stack Portal SDK version.

- Addition of Full Screen Create experience for Web and Function Apps

- New Azure Functions Portal Experience to be consistent with Web Apps

- Updates **Azure Functions runtime** to **v1.0.13154**.

- Updates to core service to improve reliability and error messaging enabling easier diagnosis of common issues.

- **Updates to the following application frameworks and tools**:
  - ASP.NET Core 5.0.4
  - .NET Framework 4.8
  - NodeJS
    - 14.15.0
  - NPM
    - 1.1.37
    - 1.2.30
    - 1.3.11
  - Updated Kudu to 90.21106.4900

- **Updates to underlying operating system of all roles**:
  - [2021-06 Cumulative Update for Windows Server 2016 for x64-based Systems (KB5003638)](https://support.microsoft.com/help/5003638)
  - [2021-04 Servicing Stack Update for Windows Server 2016 for x64-based Systems (KB5001402)](https://support.microsoft.com/help/5001402)
  - Defender Definition 1.341.322.0

- **Cumulative Updates for Windows Server are now applied to Controller roles as part of deployment and upgrade**

- MMC-based management console replaced with WPF application for improved accessibility

- TLS Cipher Suites updated to maintain consistency with Azure Service.  From this release onwards, suites will be updated with each update

## Issues fixed in this release

- Custom Shared SKU tenant usage not showing in tenant usage reports

- Unable to select subscription and location when using Service Principal to deploy/upgrade

- Log scavenger on infrastructure roles

- Added step to wait for management

- If generated storage account names exceed 24 characters, installation fails as storage account names may not exceed 24 characters

- Remote git push error: Invalid Version: transformer

## Pre-Update steps

Review the [known issues for update](#known-issues-update) and take any action prescribed.

## Post-deployment steps

> [!IMPORTANT]
> If you have provided the App Service resource provider with a SQL Always On Instance you MUST [add the appservice_hosting and appservice_metering databases to an availability group](/sql/database-engine/availability-groups/windows/availability-group-add-a-database) and synchronize the databases to prevent any loss of service in the event of a database failover.

## Known issues (update)

- In situations where a customer has converted the appservice_hosting and appservice_metering databases to contained database, upgrade may fail if logins have not been successfully migrated to contained users

Customers that have converted the appservice_hosting and appservice_metering databases to contained database post deployment, and have not successfully migrated the database logins to contained users, may experience upgrade failures.  

Customers must execute the following script against the SQL Server hosting appservice_hosting and appservice_metering before upgrading your Azure App Service on Azure Stack Hub installation to 2020 Q3.  **This script is non-destructive and will not cause downtime**.

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
    - All WebWorker logins - which are in the form WebWorker_\<instance ip address\>

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

- To remove latency when workers are communicating with the file server we also advise adding the following rule to the Worker NSG to allow outbound LDAP and Kerberos traffic to your Active Directory Controllers if securing the file server using Active Directory, for example if you have used the Quickstart template to deploy a HA File Server and SQL Server.

  Go to the WorkersNsg in the Admin Portal and add an outbound security rule with the following properties:
  - Source: Any
  - Source port range: *
  - Destination: IP Addresses
  - Destination IP address range: Range of IPs for your AD Servers, for example with the Quickstart template 10.0.0.100, 10.0.0.101
  - Destination port range: 389,88
  - Protocol: Any
  - Action: Allow
  - Priority: 710
  - Name: Outbound_Allow_LDAP_and_Kerberos_to_Domain_Controllers

### Known issues for Cloud Admins operating Azure App Service on Azure Stack

- Custom domains are not supported in disconnected environments

App Service performs domain ownership verification against public DNS endpoints, as a result custom domains are not supported in disconnected scenarios.

## Next steps

- For an overview of Azure App Service, see [Azure App Service on Azure Stack overview](azure-stack-app-service-overview.md).
- For more information about how to prepare to deploy App Service on Azure Stack, see [Before you get started with App Service on Azure Stack](azure-stack-app-service-before-you-get-started.md).
