---
title: App Service on Azure Stack Hub 2021 Q3 release notes
description: Learn about whats new in the 2021 Q3 release for App Service on Azure Stack Hub, the known issues, and where to download the update.
author: sethmanheim
ms.topic: release-notes
ms.date: 07/09/2026
ms.author: sethm
ms.reviewer: anwestg

---

# App Service on Azure Stack Hub 2021 Q3 release notes

These release notes describe the improvements and fixes in App Service on Azure Stack Hub 2021 Q3 and any known issues. The known issues are divided into two categories: issues directly related to the deployment and update process, and issues with the build (post-installation).

[!INCLUDE [Azure Stack Hub update reminder](../includes/app-service-hub-update-banner.md)]

## Build reference

The App Service on Azure Stack Hub 2021 Q3 build number is **95.1.1.539**.

## Prerequisites

Refer to the [Before You Get Started documentation](azure-stack-app-service-before-you-get-started.md) before beginning deployment.

Before you begin the upgrade of App Service on Azure Stack to 2021 Q3:

- Ensure your Azure Stack Hub is updated to 2108.

- Ensure all roles are Ready in the App Service Administration in the Azure Stack Hub Admin Portal.

- Back up App Service secrets by using the App Service Administration in the Azure Stack Hub Admin Portal.

- Back up the App Service and SQL Server Master Databases:
  - AppService_Hosting;
  - AppService_Metering;
  - Master

- Back up the tenant App content file share.

  > [!Important]
  > Cloud operators are responsible for the maintenance and operation of the File Server and SQL Server. The resource provider doesn't manage these resources. The cloud operator is responsible for backing up the App Service databases and tenant content file share.

- Syndicate the **Azure Custom Script Extension** version **1.9.3** from the Marketplace.

## Updates

App Service on Azure Stack Update 2021 Q3 includes the following improvements and fixes:

- Updates to **App Service Tenant, Admin, Azure Functions portals, and Kudu tools**. Consistent with Azure Stack Portal SDK version.

- Updates **Azure Functions runtime** to **v1.0.13154**.

- Updates to core service to improve reliability and error messaging, enabling easier diagnosis of common issues.

- **Updates to the following application frameworks and tools**:
  - ASP.NET Core 
    - 3.1.16
    - 5.0.7
    - 6.0.0
  - Azul OpenJDK
    - 8.52.0.23
    - 11.44.13
  - Git 2.33.1.1
  - MSBuild 16.8.3
  - MSDeploy 3.5.100419.17
  - NodeJS
    - 10.15.2
    - 10.16.3
    - 10.19.0
    - 12.21.0
    - 14.15.1
    - 14.16.0
  - NPM
    - 6.14.11
  - PHP
    - 7.2.34
    - 7.3.27
    - 7.4.15
  - Tomcat
    - 8.5.58
    - 9.0.38
  - Wordpress 4.9.18
  - Updated Kudu to 94.30524.5227

- **Updates to the underlying operating system of all roles**:
  - [2021-11 Cumulative Update for Windows Server 2016 for x64-based Systems (KB5007192)](https://support.microsoft.com/help/5007192)
  - [2021-09 Servicing Stack Update for Windows Server 2016 for x64-based Systems (KB5005698)](https://support.microsoft.com/help/5005698)
  - Microsoft Defender Definition 1.353.743.0

- **Cumulative Updates for Windows Server are now applied to Controller roles as part of deployment and upgrade**

- TLS Cipher Suites updated to maintain consistency with Azure Service.

- Added support for 2020-09-01-hybrid profile.

## Issues fixed in this release

- You can now deploy App Service when running the installer from a FIPS-compliant client machine.

- The process automatically checks App Service Role Health before completing App Service secret rotation procedures. If any roles aren't in a ready state, secret rotation is blocked.

- The outbound IP address for sites now appears in the properties and Custom Domains blades within the tenant portal.

- The release notes include further details on the event of Custom Domain verification failure.

- Customers can successfully upload and delete private certificates in the tenant portal.

- Resolved an issue where FrontEnd role instances can remain in an Auto Repair loop because of a missing dependency in Functions scaling components.

- Resolved Single Sign On failures to SCM Site because of changes in Azure AD endpoints.


- Updated Azure Load Balancer health probes on Front-End roles and Management roles to be in alignment with Azure implementation. Traffic is blocked from reaching Front-End role instances when they're not in a Ready state.

- Aligned per site temporary directory quota size with Azure. The limit on Dedicated Workers is 10 GB, and Shared Workers is 500 MB.

- Added an algorithm to Log Scavenger routines to prevent workers from entering a repair loop when generated HTTP logs exceed available space on worker.

## Pre-update steps

Review the [known issues for update](#known-issues-update) and take any action prescribed.

## Post-deployment steps

> [!IMPORTANT]
> If you provide the App Service resource provider with a SQL Server Always On Instance, you must [add the appservice_hosting and appservice_metering databases to an availability group](/sql/database-engine/availability-groups/windows/availability-group-add-a-database) and synchronize the databases to prevent any loss of service in the event of a database failover.

## Known issues (update)

- In situations where you convert the appservice_hosting and appservice_metering databases to contained databases, upgrade might fail if you don't successfully migrate logins to contained users.

If you convert the appservice_hosting and appservice_metering databases to contained databases after deployment and don't successfully migrate the database logins to contained users, you might experience upgrade failures.  

Before upgrading your App Service on Azure Stack Hub installation to 2020 Q3, run the following script against the SQL Server hosting appservice_hosting and appservice_metering databases.  **This script is non-destructive and doesn't cause downtime**.

Run this script under the following conditions:

- By a user that has the system administrator privilege, such as the SQL SA Account;
- If you're using SQL Server Always On, ensure you run the script from the SQL instance that contains all App Service logins in the form:

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

- Workers can't reach the file server when you deploy App Service in an existing virtual network and the file server is only available on the private network, as described in the [Azure App Service and Azure Functions on Azure Stack Hub overview](azure-stack-app-service-overview.md).

  If you choose to deploy into an existing virtual network and use an internal IP address to connect to your file server, you must add an outbound security rule that enables SMB traffic between the worker subnet and the file server. Go to the **WorkersNsg** in the Admin Portal and add an outbound security rule with the following properties:
  - Source: Any
  - Source port range: *
  - Destination: IP Addresses
  - Destination IP address range: Range of IPs for your file server
  - Destination port range: 445
  - Protocol: TCP
  - Action: Allow
  - Priority: 700
  - Name: Outbound_Allow_SMB445

- To remove latency when workers communicate with the file server, add the following rule to the Worker NSG to allow outbound LDAP and Kerberos traffic to your Active Directory Controllers if you're securing the file server by using Active Directory. For example, if you use the Quickstart template to deploy a HA File Server and SQL Server.

  Go to the **WorkersNsg** in the Admin Portal and add an outbound security rule with the following properties:
  - Source: Any
  - Source port range: *
  - Destination: IP Addresses
  - Destination IP address range: Range of IPs for your AD Servers. For example, with the Quickstart template use `10.0.0.100, 10.0.0.101`.
  - Destination port range: 389,88
  - Protocol: Any
  - Action: Allow
  - Priority: 710
  - Name: Outbound_Allow_LDAP_and_Kerberos_to_Domain_Controllers


### Known issues for cloud admins operating App Service on Azure Stack

- Custom domains aren't supported in disconnected environments

App Service verifies domain ownership through public DNS endpoints. Therefore, custom domains aren't supported in disconnected scenarios.

## Next steps

- For an overview of App Service, see [Azure App Service on Azure Stack overview](azure-stack-app-service-overview.md).
- For more information about how to prepare to deploy App Service on Azure Stack, see [Before you get started with App Service on Azure Stack](azure-stack-app-service-before-you-get-started.md).
