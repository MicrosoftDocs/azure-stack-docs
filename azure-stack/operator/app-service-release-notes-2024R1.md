---
title: App Service on Azure Stack Hub 24R1 release notes 
description: Learn about what's new and updated in the App Service on Azure Stack Hub 24R1 release.
author: apwestgarth
ms.topic: release-notes
ms.date: 02/07/2025
ms.author: anwestg
ms.reviewer:
---

# App Service on Azure Stack Hub 24R1 release notes

These release notes describe the improvements and fixes in Azure App Service on Azure Stack Hub 24R1 release notes and any known issues. Known issues are divided into issues directly related to the deployment, update process, and issues with the build (post-installation).

[!INCLUDE [Azure Stack Hub update reminder](../includes/app-service-hub-update-banner.md)]

## Build reference

The App Service on Azure Stack Hub 24R1 build number is **102.0.2.5**

## What's new?

Azure App Service on Azure Stack Hub 24 R1 brings new updates to Azure Stack Hub.

- Kestrel and [YARP (Yet Another Reverse Proxy)](https://microsoft.github.io/reverse-proxy/) now power App Service on Azure Stack Hub front ends in alignment with investments made in public cloud. For more information on what this means and how it impacted the public cloud service, read the detailed information on the App Service Team Blog - ["A Heavy Lift: Bringing Kestrel + YARP to Azure App Services"](https://azure.github.io/AppService/2022/08/16/A-Heavy-Lift.html)
- Updates to many application stacks, bringing latest Long Term Support (LTS) releases of .NET, Java, Tomcat, and more.
- Tenants can make use of the [Health check feature](/azure/app-service/monitor-instances-health-check) for monitoring of instance health 

## Prerequisites

See the [Before You Get Started documentation](azure-stack-app-service-before-you-get-started.md) before beginning deployment.

Before you begin the upgrade of Azure App Service on Azure Stack to 24R1:

- Ensure your Azure Stack Hub is updated to **1.2311.1.22** or later.
- Ensure all roles are **Ready** in the Azure App Service Administration in the Azure Stack Hub admin portal.
- Back up App Service Secrets using the App Service Administration in the Azure Stack Hub admin portal.
- Back up the App Service and SQL Server master databases:
  - AppService_Hosting;
  - AppService_Metering;
  - Master

- Back up the Tenant App content file share.

  > [!IMPORTANT]
  > Cloud operators are responsible for the maintenance and operation of the File Server and SQL Server. The resource provider does not manage these resources. The cloud operator is responsible for backing up the App Service databases and tenant content file share.

- Syndicate the Custom Script Extension version **1.9.3** from the Marketplace.

## Updates

Azure App Service on Azure Stack Update 24R1 includes the following improvements and fixes:

- Updates to App Service Tenant, Admin, Functions portals and Kudu tools. Consistent with the Azure Stack portal SDK version.
- Updates Azure Functions runtime to **v1.0.21719**.
- Updates to core service to improve reliability and error messaging enabling easier diagnosis of common issues.
- Updates to the following application frameworks and tools:
  - .NET Framework 4.8.1
  - ASP.NET Core 
    - 8.0.7
    - 8.0.8
    - 6.0.29
  - Eclipse Temurin OpenJDK 8
    - 8u302
    - 8u312
    - 8u322
    - 8u332
    - 8u345
    - 8u362
    - 8u392
    - 8u412
    - 8u422
  - Microsoft OpenJDK 11
    - 11.0.12.7.1
    - 11.0.13.8
    - 11.0.14.1
    - 11.0.15.10
    - 11.0.16.1
    - 11.0.18.10
    - 11.0.21.9
    - 11.0.23.9
    - 11.0.24.8
  - Microsoft OpenJDK 17
    - 17.0.11.9
    - 17.0.1.12
    - 17.0.2.8
    - 17.0.3.7
    - 17.0.4.1
    - 17.0.6.1
    - 17.0.9.8
    - 17.0.12.7
  - Microsoft OpenJDK 21
    - 21.0.1.12
    - 21.0.3.9
    - 21.0.4.7
  - MSBuild 
    - 15.9.21.664
    - 16.4.0
    - 16.7.0
    - 16.11.2
    - 17.11.2
  - MSDeploy 
    - 3.5.120530.385
    - 2.5.1270717.34
  - NodeJS
    - 10.24.1
    - 12.22.12
    - 14.20.0
    - 16.16.0
    - 18.12.1
    - 18.19.1
    - 20.9.0
  - npm
    - 6.4.1
    - 6.13.4
    - 6.14.11
    - 6.14.12
    - 6.14.15
    - 6.14.16
    - 6.14.17
    - 7.21.1
    - 8.1.0
    - 8.19.2
    - 10.1.0
    - 10.2.4

  - Tomcat
    - 8.5.20
    - 8.5.57
    - 8.5.58
    - 8.5.79
    - 8.5.82
    - 8.5.85
    - 8.5.96
    - 8.5.100
    - 9.0.0
    - 9.0.27
    - 9.0.31
    - 9.0.37
    - 9.0.63
    - 9.0.65
    - 9.0.71
    - 9.0.83
    - 9.0.91
    - 9.0.96
    - 10.0.21
    - 10.0.23
    - 10.0.27
    - 10.1.5
    - 10.1.16
    - 10.1.25
    - 10.1.31
    - 11.0.0
  - Git 2.43.0
  - Updated Kudu to 102.10502.001.
  - Continual accessibility and usability updates

- **Updates to underlying operating system of all roles**:
  - [2024-10 Cumulative Update for Microsoft server operating system version 21H2 for x64-based Systems (KB5044281)](https://support.microsoft.com/help/5044281)
  - [2024-10 Cumulative Update for .NET Framework 3.5 and 4.8.1 for Microsoft server operating system version 21H2 for x64 (KB5044035)](https://support.microsoft.com/help/5044035)
  - Defender Definition 1.419.510.0

- **Cumulative Updates for Windows Server are now applied to Controller roles as part of deployment and upgrade**.

- Synchronization of Cipher Suites in place and preserves any modifications performed as result of customer intervention with support.

## Issues fixed in this release

- Some customers experienced database performance issues relating to locking of App Service Hosting tables, performance improvements are included this release.

- Ownership improvements in usage records service, to harden service when working with multiple roles and large number of workers

- Stuck windows updates due to continually attempting to apply Windows Server 2016 updates to Windows Server 2022 and vice versa

- Resolved issue whereby Windows Update KB5034439 would never complete and prevents roles moving to Ready state

- Installer failures resolved when customers using newer versions of the Custom Script Extension

- Trace messages from App Service roles were reviewed and trimmed to improve the quality of the information provided and to reduce the burden on the database

- Centralized SSL Certificate Support feature is installed on Front Ends as part of deployment and Tenants can bind certificates without Operator intervention

- Virtual Network Integration options are now disabled in portal by default.

- Resolved issues enabling blob storage for application logging

- Improved swap experience when swapping slots to prevent time-outs

- Change of description from Management Server to Management/Controller Roles in the choices for credential rotation to be more explicit about action being taken

## Pre-Update steps

- As of Azure App Service on Azure Stack Hub 2022 H1 Update, the letter K is now a reserved SKU Letter, if you have a custom SKU defined utilizing the letter K, contact support to assist resolving this situation before upgrading.

Review the [known issues for update](#known-issues-update) and take any action prescribed.

## Post-deployment steps

> [!IMPORTANT]
> If you have provided the App Service resource provider with a SQL Always On Instance you MUST [add the appservice_hosting and appservice_metering databases to an availability group](/sql/database-engine/availability-groups/windows/availability-group-add-a-database) and synchronize the databases to prevent any loss of service in the event of a database failover.

## Known issues (update)

- **Application downtime should be expected during Upgrade.**

  > [!IMPORTANT]
  >
  > Due to a change in communication format within the Web Farm, during the upgrade all roles move into repair mode until they match the same version as the controller. Due to this, we advise you to declare a maintenance window during this upgrade and prepare for application downtime during the upgrade.

- In situations where you converted the appservice_hosting and appservice_metering databases to contained database, upgrade might fail if logins weren't successfully migrated to contained users.

  Customers that converted the appservice_hosting and appservice_metering databases to contained database post deployment, and didn't successfully migrate the database logins to contained users, might experience upgrade failures.  

  Customers must execute the following script against the SQL Server hosting appservice_hosting and appservice_metering before upgrading your Azure App Service on Azure Stack Hub installation to 2020 Q3. This script is non-destructive and does not cause downtime.

  This script must be run under the following conditions:

  - By a user that has the system administrator privilege, for example the SQL SA (System Administrator) Account;
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

- A new Redirect URL must be added to the identity application created in order to support Single Sign On(SSO) Scenarios (for example Kudu)

# [Entra ID](#tab/EntraID)

## Retrieve the Identity Application Client ID

1. In the Azure Stack admin portal, navigate to the **ControllersNSG** Network Security Group.
1. By default, remote desktop access is disabled to all App Service infrastructure roles. Modify the **Inbound_Rdp_3389** rule action to **Allow** access.
1. Navigate to the resource group containing the App Service Resource Provider deployment. By default, the resource group is named with the format `AppService.<region>`, and connected to **CN0-VM**.
1. Launch the **Web Cloud Management Console**.
1. Check the **Web Cloud Management Console -> Web Cloud** screen and verify that both **Controllers** are **Ready**.
1. Select **Settings**.
1. Find the **ApplicationClientId** setting. Retrieve the value.
1. In the Azure Stack admin portal, navigate back to the **ControllersNSG** Network Security Group.
1. Modify the **Inbound_Rdp_3389** rule to deny access.

## Update the Entra ID Application with new Redirect URI
  
1. Sign into the Azure portal to access the Entra ID tenant you connected your Azure Stack Hub to at deployment time.
1. Using the Azure portal and navigate to **Microsoft Entra ID**.
1. Search your tenant for the `ApplicationClientId` you retrieved earlier.
1. Select the application.
1. Select **Authentication**.
1. Add another **Redirect URI** to the existing list: `https://azsstamp.sso.appservice.<region>.<DomainName>.<extension>`.

# [ADFS](#tab/ADFS)

## Retrieve the identity application

1. Open a [session to the Privileged Endpoint](azure-stack-privileged-endpoint.md).
1. Run the following command to retrieve the AD FS Graph applications:

   ``` PowerShell
   Get-GraphApplication
   ```

1. Find the identifier for the **AzureStack-AppService** application.
1. Update the `RedirectURIs` for the application:

   ``` PowerShell
   $RedirectURIs = "@("https://appservice.sso.appservice.<region>.<DomainName>.<extension>", "https://azsstamp.sso.appservice.<region>.<DomainName>.<extension>", "https://api.appservice.<region>.<DomainName>.<extension>:44300/manage")
   Set-GraphApplication -ApplicationIdentifier <insert Identifier value> -ClientRedirectUris $RedirectURIs
   ```

1. Close the Privileged Endpoint session.

---

## Known issues (post-installation)

- Workers are unable to reach file server when App Service is deployed in an existing virtual network, and the file server is only available on the private network, as called out in the Azure App Service on Azure Stack deployment documentation.

  If you chose to deploy into an existing virtual network and an internal IP address to connect to your file server, you must add an outbound security rule, enabling SMB (Server Message Block) traffic between the worker subnet and the file server. Go to the WorkersNsg in the Admin Portal and add an outbound security rule with the following properties:
  - Source: Any
  - Source port range: *
  - Destination: IP Addresses
  - Destination IP address range: Range of IPs for your file server
  - Destination port range: 445
  - Protocol: TCP
  - Action: Allow
  - Priority: 700
  - Name: Outbound_Allow_SMB445

- To remove latency when workers are communicating with the file server, we also advise adding the following rule to the Worker NSG (Network Security Group) to allow outbound LDAP (Lightweight Directory Access Protocol) and Kerberos traffic to your Active Directory Controllers when securing the file server using Active Directory. For example, if you have used the Quickstart template to deploy a HA File Server and SQL Server.

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

- Custom domains aren't supported in disconnected environments.

  App Service performs domain ownership verification against public DNS (Domain Name System) endpoints. As a result, custom domains aren't supported in disconnected scenarios.

- Virtual Network integration for Web and Function Apps isn't supported.

  The ability to add virtual network integration to Web and Function apps shows in the Azure Stack Hub portal and if a tenant attempts to configure, they receive an internal server error. This feature isn't supported in Azure App Service on Azure Stack Hub.

## Next steps

- For an overview of Azure App Service, see [Azure App Service on Azure Stack overview](azure-stack-app-service-overview.md).
- For more information about how to prepare to deploy App Service on Azure Stack, see [Before you get started with App Service on Azure Stack](azure-stack-app-service-before-you-get-started.md).
