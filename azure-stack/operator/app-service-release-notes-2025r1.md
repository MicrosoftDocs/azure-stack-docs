---
title: App Service on Azure Stack Hub 25R1 release notes 
description: Learn about what's new and updated in the App Service on Azure Stack Hub 25R1 release.
author: apwestgarth
ms.topic: article
ms.date: 08/20/2025
ms.author: anwestg
ms.reviewer:
---

# App Service on Azure Stack Hub 25R1 release notes

These release notes describe the improvements and fixes in Azure App Service on Azure Stack Hub 25R1 release notes and any known issues. Known issues are divided into issues directly related to the deployment, update process, and issues with the build (post-installation).

[!INCLUDE [Azure Stack Hub update reminder](../includes/app-service-hub-update-banner.md)]

## Build reference

The App Service on Azure Stack Hub 25R1 build number is **102.10.2.12**

## What's new?

Azure App Service on Azure Stack Hub 25 R1 brings new updates to Azure Stack Hub and builds on the previously released 24R1 ([24R1 Release Notes](app-service-release-notes-2024r1.md)). Customers can install 25R1 directly without deploying 24R1 first.

- Updates to .NET 8 and 9.
- Updates to App Service on Azure Stack Hub Resource Provider.
- Resolution to [issues customers encountered with 24R1](## Issues fixed in this release).

> [!IMPORTANT]
> With Azure App Service on Azure Stack Hub 25R1 operators must deploy or update via the **Complete offline installation or upgrade** pathway. Download links are provided in the [deploy](azure-stack-app-service-deploy.md) or [update](azure-stack-app-service-update.md) documentation to the installer, helper scripts, and the offline package zip file.

## Prerequisites

See the [Before You Get Started documentation](azure-stack-app-service-before-you-get-started.md) before beginning deployment.

Before you begin the upgrade of Azure App Service on Azure Stack to 25R1:

- Ensure your Azure Stack Hub is updated to **1.2311.1.22** or later.
- Ensure all roles are **Ready** in the Azure App Service Administration in the Azure Stack Hub admin portal.
- Back up App Service Secrets using the App Service Administration in the Azure Stack Hub admin portal.
- Back up the App Service and SQL Server master databases:
  - AppService_Hosting;
  - AppService_Metering;
  - Master

- Back up the Tenant App content file share.

  > [!IMPORTANT]
  > Cloud operators are responsible for the maintenance and operation of the File Server and SQL Server. The resource provider doesn't manage these resources. The cloud operator is responsible for backing up the App Service databases and tenant content file share.

- Syndicate the Custom Script Extension version **1.9.3** from the Marketplace.

## Updates

Azure App Service on Azure Stack Update 25R1 includes the following improvements and fixes:

- Updates to App Service Tenant, Admin, Functions portals and Kudu tools. Consistent with the Azure Stack portal SDK version.
- Updates Azure Functions runtime to **1.0.23001**.
- Updates to core service to improve reliability and error messaging enabling easier diagnosis of common issues.
- Updates to the following application frameworks and tools:
  - .NET Framework 3.5 and 4.8.1
  - ASP.NET Core 
    - 9.0.3
    - 9.0.201
    - 8.0.407
    - 8.0.14
  - MSBuild 
    - 17.12.0
  - MSDeploy 
    - 3.5.140404
    - 3.5.140521
  - NodeJS
    - 10.15.2
    - 14.20.0
    - 16.16.0
    - 18.20.4
    - 18.20.7
    - 20.9.0
    - 20.18.3
    - 22.5.1
    - 22.14.0
  - npm
    - 6.4.1
    - 10.7.0
    - 10.8.2
    - 10.9.2
  - Git 2.46.0
  - VC14 Redistributable 14.40.33810
  - SQL Native Client 11.0.2100.60
  - Updated Kudu to 103.0.1.100
  - Continual accessibility and usability updates

- **Updates to underlying operating system of all roles**:
  - [2025-06 Cumulative Update for Microsoft server operating system version 21H2 for x64-based Systems (KB5060526)](https://support.microsoft.com/help/5060526)
  - [2025-04 Cumulative Update for .NET Framework 3.5 and 4.8.1 for Microsoft server operating system version 21H2 for x64 (KB5054693)](https://support.microsoft.com/help/5054693)
  - Definition updates for Windows Defender Antivirus and other Microsoft anti-malware 1.429.494.0

- **Cumulative Updates for Windows Server are now applied to Controller roles as part of deployment and upgrade**.

- Synchronization of Cipher Suites in place and preserves any modifications performed as result of customer intervention with support.

## Issues fixed in this release

> [!IMPORTANT]
> 25R1 was updated to version **102.10.2.12**. This update resolves an issue in which TLS handshakes fail due to the Kyber key_share extension in Chromium browsers. If you already updated to 25R1 (102.10.2.11), we recommend updating to this new version to resolve this issue.

Newly fixed issues in this release:

- Application downtime should no longer be expected during Upgrade. In 24R1, an issue caused significant downtime due to a change in communication format within the Web Farm during upgrade. The handling of the communication change was modified in this update, and doesn't cause downtime in 25R1.

- Resolution to issues faced with Role Based Access Control and Single Sign on to Kudu and SCM sites

- Further process improvements in usage records service, to more effectively handle failures and outages during usage record commits

- Resolved issues in Kudu where new runs of Web Jobs can't be started due to stalled jobs running

- Resolved issue when worker limits weren't checked when scaling out an App Service Plan using a deployment template

- Resolved issue where an invalid Data Service endpoint is set in configuration when all names in management server certificate are of wildcard format

- Enforced tcp prefix on all connection strings for the Resource Provider data plane and ensured all roles receive updated connection string during rotation

- Enabled Health Check Feature in Tenant Portal

## Pre-Update steps

- As of Azure App Service on Azure Stack Hub 2022 H1 Update, the letter K is now a reserved SKU Letter, if you have a custom SKU defined utilizing the letter K, contact support to assist resolving this situation before upgrading.

Review the [known issues for update](#known-issues-update) and take any action prescribed.

## Post-deployment steps

> [!IMPORTANT]
> If App Service resource provider is configured with a SQL Always On Instance, you MUST [add the appservice_hosting and appservice_metering databases to an availability group](/sql/database-engine/availability-groups/windows/availability-group-add-a-database). Once added, you MUST synchronize the databases, to prevent any loss of service in the event of a database failover.

## Known issues (update)

- In situations where you converted the appservice_hosting and appservice_metering databases to contained database, upgrade might fail if logins weren't successfully migrated to contained users.

  Customers that converted the appservice_hosting and appservice_metering databases to contained database post deployment, and didn't successfully migrate the database logins to contained users, might experience upgrade failures.  

  Customers must execute the following script against the SQL Server hosting appservice_hosting and appservice_metering before upgrading your Azure App Service on Azure Stack Hub installation to 2020 Q3. This script is nondestructive and doesn't cause downtime.

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
1. Use the Azure portal, and navigate to **Microsoft Entra ID**.
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

- Worker instances are unable to reach file server when App Service is deployed in an existing virtual network. The file server is only available on the private network, as called out in the Azure App Service on Azure Stack deployment documentation.

  During initial deployment, if you chose to deploy into an existing virtual network and use an internal IP address to connect to your file server. You must add an outbound security rule, enabling SMB (Server Message Block) traffic between the worker subnet, and the file server. Go to the WorkersNsg in the Admin Portal and add an outbound security rule with the following properties:
  - Source: Any
  - Source port range: *
  - Destination: IP Addresses
  - Destination IP address range: Range of IPs for your file server
  - Destination port range: 445
  - Protocol: TCP
  - Action: Allow
  - Priority: 700
  - Name: Outbound_Allow_SMB445

- To remove latency when worker instances are communicating with the file server, we also advise adding the following rule to the Worker NSG (Network Security Group). This rule allows outbound LDAP (Lightweight Directory Access Protocol) and Kerberos traffic to your Active Directory Controllers when securing the file server using Active Directory. For example, if you used the Quickstart template to deploy a HA File Server and SQL Server.

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


