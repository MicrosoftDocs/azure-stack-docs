---
title: App Service on Azure Stack Hub 2022 H1 release notes
description: Learn about whats new in the 2022 H1 release for App Service on Azure Stack Hub, the known issues, and where to download the update.
author: sethmanheim
ms.topic: release-notes
ms.date: 07/09/2026
ms.author: sethm
ms.reviewer: anwestg

---

# App Service on Azure Stack Hub 2022 H1 release notes

These release notes describe the improvements and fixes in App Service on Azure Stack Hub 2022 H1 and any known issues. Known issues are divided into issues directly related to the deployment, update process, and issues with the build (post-installation).

[!INCLUDE [Azure Stack Hub update reminder](../includes/app-service-hub-update-banner.md)]

## Build reference

The App Service on Azure Stack Hub 2022 H1 build number is **98.0.1.699**.

## What's new?

App Service on Azure Stack Hub 2022 H1 brings many new capabilities to Azure Stack Hub.

- All roles now use Windows Server 2022 Datacenter.
- Administrators can isolate the platform image for use by App Service on Azure Stack Hub by setting the SKU to AppService. 
- Network design update for all worker Virtual Machine Scale Sets, addressing customers faced with SNAT port exhaustion problems.
- Increased number of outbound addresses for all applications. You can discover the updated list of outbound addresses in the properties of an application in the Azure Stack Hub portal.
- Administrators can set a three-character deployment prefix for the individual instances in each Virtual Machine Scale Set that they deploy, useful when managing multiple Azure Stack Hub instances.
- Deployment Center is now enabled for tenants, replacing the Deployment Options experience.  **IMPORTANT**: Operators need to [reconfigure their deployment sources](azure-stack-app-service-configure-deployment-sources.md?pivots=version-2022h1) as the Redirect URLs changed with this update. In addition, tenants need to reconnect their apps to their source control providers.
- As of this update, the letter K is now a reserved SKU letter. If you define a custom SKU that uses the letter K, contact support to help resolve this situation before upgrading.


## Prerequisites

Refer to the [Before You Get Started documentation](azure-stack-app-service-before-you-get-started.md) before beginning deployment.

Before you begin the upgrade of App Service on Azure Stack to 2022 H1:

- Ensure your **Azure Stack Hub** is updated to **1.2108.2.127** or **1.2206.2.52**.

- Ensure all roles are Ready in the App Service Administration in the Azure Stack Hub Admin Portal.

- Backup App Service Secrets by using the App Service Administration in the Azure Stack Hub Admin Portal.

- Back up the App Service and SQL Server Master Databases:
  - AppService_Hosting;
  - AppService_Metering;
  - Master

- Back up the Tenant App content file share.

  > [!Important]
  > Cloud operators are responsible for the maintenance and operation of the File Server and SQL Server. The resource provider doesn't manage these resources. The cloud operator is responsible for backing up the App Service databases and tenant content file share.

- Syndicate the **Custom Script Extension** version **1.9.3** from the Marketplace.

## Updates

App Service on Azure Stack Update 2022 H1 includes the following improvements and fixes:

- Updates to **App Service Tenant, Admin, Functions portals, and Kudu tools**. Consistent with Azure Stack Portal SDK version.

- Updates **Azure Functions runtime** to **v1.0.13154**.

- Updates to core service to improve reliability and error messaging, enabling easier diagnosis of common issues.

- **Updates to the following application frameworks and tools**:
  - 2022-09 Cumulative Update for .NET Framework 3.5 and .NET Framework 4.8 for Microsoft server operating system version 21H2 for x64 (KB5017028).
  - ASP.NET Core 
    - 3.1.18
    - 3.1.23
    - 6.0.2
    - 6.0.3
  - Eclipse Temurin OpenJDK 8
    - 8u302
    - 8u312
    - 8u322
  - Microsoft OpenJDK 11
    - 11.0.12.7.1
    - 11.0.13.8
    - 11.0.14.1
    - 17.0.1.12
    - 17.0.2.8
  - MSBuild 
    - 16.7.0
    - 17.1.0
  - MSDeploy 3.5.100608.567
  - NodeJS
    - 14.18.1
    - 16.9.1
    - 16.13.0
  - npm
    - 6.14.15
    - 7.21.1
    - 8.1.0
  - Tomcat
    - 8.5.69
    - 8.5.72
    - 8.5.78
    - 9.0.52
    - 9.0.54
    - 9.0.62
    - 10.0.12
    - 10.0.20
  - Updated Kudu to 97.40427.5713.


- **Updates to the underlying operating system of all roles**:
  - [2022-09 Cumulative Update for Windows Server 2022 for x64-based Systems (KB5017316)](https://support.microsoft.com/help/5017316).
  - Microsoft Defender Definition 1.373.353.0

- **Cumulative Updates for Windows Server are now applied to Controller roles as part of deployment and upgrade**.

## Issues fixed in this release

- The update automatically cleans up the **SiteDataRecord** and **TraceMessages** tables within the App Service Resource Provider databases.
- The private certificate now appears in sites with deployment slots.
- The upgrade process is more reliable because it verifies that all roles are ready.

## Pre-update steps

App Service on Azure Stack Hub 2022 H1 is a significant update. The update can take multiple hours to complete because the whole deployment is updated and all roles are recreated with the Windows Server 2022 Datacenter OS. Inform your end customers about the planned update before you apply the update.

- Starting with App Service on Azure Stack Hub 2022 H1 Update, the letter K is a reserved SKU letter. If you define a custom SKU that uses the letter K, contact support to resolve this situation before upgrading.

Review the [known issues for update](#known-issues-update) and take any action prescribed.

## Post-deployment steps

> [!IMPORTANT]
> If you provide the App Service resource provider with a SQL Always On Instance, you must [add the appservice_hosting and appservice_metering databases to an availability group](/sql/database-engine/availability-groups/windows/availability-group-add-a-database) and synchronize the databases to prevent any loss of service in the event of a database failover.

## Known issues (update)

- Upgrade might fail if you convert the App Service hosting and App Service metering databases to contained databases but don't migrate logins to contained users.

If you convert the App Service hosting and App Service metering databases to contained databases after deployment but don't migrate the database logins to contained users, you might experience upgrade failures.  

Before upgrading your App Service on Azure Stack Hub installation to 2020 Q3, run the following script against the SQL Server hosting appservice_hosting and appservice_metering databases.  **This script is non-destructive and doesn't cause downtime**.

Run this script under the following conditions:

- By a user that has the system administrator privilege, such as the SQL SA Account;
- If you're using SQL Server Always On, ensure you run the script from the SQL Server instance that contains all App Service logins in the form:

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

- Tenant applications can't bind certificates to applications after upgrade.

  This problem happens because of a missing feature on front-ends after upgrade to Windows Server 2022.  Operators must follow this procedure to resolve the problem.

  1. In the Azure Stack Hub admin portal, go to **Network Security Groups** and view the **ControllersNSG** Network Security Group.

  1. By default, remote desktop is disabled to all App Service infrastructure roles. Change the **Inbound_Rdp_2289** rule action to **Allow** access.

  1. Go to the resource group containing the App Service Resource Provider deployment. By default, the name is **AppService.\<region\>**. Connect to **CN0-VM**.
  1. Return to the **CN0-VM** remote desktop session.
  1. In an Administrator PowerShell session, run:
      
      > [!IMPORTANT] 
      > During the execution of this script, there's a pause for each instance in the Front End scale set.  If there's a message indicating the feature is being installed,
      > that instance is rebooted. Use the pause in the script to maintain Front End availability.  Operators must ensure at least one Front End instance is "Ready" at all times
      > to ensure tenant applications can receive traffic and don't experience downtime.

      ```powershell
      $c = Get-AppServiceConfig -Type Credential -CredentialName FrontEndCredential
      $spwd = ConvertTo-SecureString -String $c.Password -AsPlainText -Force
      $cred = New-Object System.Management.Automation.PsCredential ($c.UserName, $spwd)

      Get-AppServiceServer -ServerType LoadBalancer | ForEach-Object {
          $lb = $_
          $session = New-PSSession -ComputerName $lb.Name -Credential $cred

          Invoke-Command -Session $session {
            $f = Get-WindowsFeature -Name Web-CertProvider
            if (-not $f.Installed) {
                Write-Host Install feature on $env:COMPUTERNAME
                Install-WindowsFeature -Name Web-CertProvider

                Read-Host -Prompt "If installing the feature, the machine will reboot. Wait until there's enough frontend availability, then press ENTER to continue"
                Shutdown /t 5 /r /f 
            }
      }

      Remove-PSSession -Session $session     
      ```

  1. In the Azure Stack admin portal, go back to the **ControllersNSG** Network Security Group.

  1. Change the **Inbound_Rdp_3389** rule to deny access. 

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

- To remove latency when workers communicate with the file server, add the following rule to the **Worker NSG** to allow outbound LDAP and Kerberos traffic to your Active Directory Controllers if you're securing the file server by using Active Directory. For example, if you used the Quickstart template to deploy a HA File Server and SQL Server.

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

- Tenant applications can't bind certificates to applications after upgrade.

  This problem happens because of a missing feature on front-ends after upgrade to Windows Server 2022.  Operators must follow this procedure to resolve the problem.

  1. In the Azure Stack Hub admin portal, go to **Network Security Groups** and view the **ControllersNSG** Network Security Group.

  1. By default, remote desktop is disabled to all App Service infrastructure roles. Change the **Inbound_Rdp_2289** rule action to **Allow** access.

  1. Go to the resource group containing the App Service Resource Provider deployment. By default, the name is **AppService.\<region\>**. Connect to **CN0-VM**.
  1. Return to the **CN0-VM** remote desktop session.
  1. In an Administrator PowerShell session, run:
      
      > [!IMPORTANT] 
      > During the execution of this script, there's a pause for each instance in the Front End scale set.  If there's a message indicating the feature is being installed,
      > that instance is rebooted. Use the pause in the script to maintain Front End availability.  Operators must ensure at least one Front End instance is "Ready" at all times
      > to ensure tenant applications can receive traffic and don't experience downtime.

      ```powershell
      $c = Get-AppServiceConfig -Type Credential -CredentialName FrontEndCredential
      $spwd = ConvertTo-SecureString -String $c.Password -AsPlainText -Force
      $cred = New-Object System.Management.Automation.PsCredential ($c.UserName, $spwd)

      Get-AppServiceServer -ServerType LoadBalancer | ForEach-Object {
          $lb = $_
          $session = New-PSSession -ComputerName $lb.Name -Credential $cred

          Invoke-Command -Session $session {
            $f = Get-WindowsFeature -Name Web-CertProvider
            if (-not $f.Installed) {
                Write-Host Install feature on $env:COMPUTERNAME
                Install-WindowsFeature -Name Web-CertProvider

                Shutdown /t 5 /r /f 
            }
      }

      Remove-PSSession -Session $session

      Read-Host -Prompt "If installing the feature, the machine will reboot. Wait until there's enough frontend availability, then press ENTER to continue"
      ```

  1. In the Azure Stack admin portal, go back to the **ControllersNSG** Network Security Group.

  1. Change the **Inbound_Rdp_3389** rule to deny access. 

### Known issues for cloud admins operating App Service on Azure Stack

- Custom domains aren't supported in disconnected environments.

  App Service verifies domain ownership through public DNS endpoints. Because of this verification method, custom domains aren't supported in disconnected scenarios.

- Virtual network integration isn't supported for web and function apps.

  The Azure Stack Hub portal shows the option to add virtual network integration to web and function apps. If a tenant attempts to configure this feature, they receive an internal server error. App Service on Azure Stack Hub doesn't support this feature.

## Next steps

- For an overview of App Service, see [Azure App Service on Azure Stack overview](azure-stack-app-service-overview.md).
- For more information about how to prepare to deploy App Service on Azure Stack, see [Before you get started with App Service on Azure Stack](azure-stack-app-service-before-you-get-started.md).
