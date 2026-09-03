---
title: App Service on Azure Stack Hub 2302 release notes
description: Learn about whats new in the 2302 release for App Service on Azure Stack Hub and where to download the update.
author: sethmanheim
ms.topic: release-notes
ms.date: 07/09/2026
ms.author: sethm
ms.reviewer: anwestg

---

# App Service on Azure Stack Hub 2302 release notes

These release notes describe the improvements and fixes in Azure App Service on Azure Stack Hub 2302, and any known issues. Known issues are divided into issues directly related to the deployment, update process, and issues with the build (post-installation).

[!INCLUDE [Azure Stack Hub update reminder](../includes/app-service-hub-update-banner.md)]

## Build reference

The App Service on Azure Stack Hub 2302 build number is **98.0.1.703**.

## What's new?

App Service on Azure Stack Hub 2302 release replaces the [2022 H1 release](app-service-release-notes-2022-h1.md) and includes fixes for the following issues:

- [CVE-2023-21703 Azure App Service on Azure Stack Hub Elevation of Privilege Vulnerability](https://go.microsoft.com/fwlink/?linkid=2225046).

- Unable to open Virtual Machine Scale Sets User Experience from the App Service Roles admin user experience in the Azure Stack Hub administration portal.

- All other updates are documented in the [Azure App Service on Azure Stack Hub 2022 H1 Update Release Notes](app-service-release-notes-2022-h1.md).

- As of the App Service on Azure Stack Hub 2022 H1 update, the letter **K** is now a reserved SKU letter. If you have a custom SKU defined that uses the letter K, contact support to assist with resolving this situation prior to upgrade.

## Prerequisites

Refer to the [Before You Get Started documentation](azure-stack-app-service-before-you-get-started.md) before beginning deployment.

Before you begin the upgrade of App Service on Azure Stack Hub to 2302:

- Ensure your **Azure Stack Hub** is updated to **1.2108.2.127** or **1.2206.2.52**.

- Ensure all roles are ready in the App Service administration in the Azure Stack Hub admin portal.

- Back up App Service secrets by using the App Service administration in the Azure Stack Hub admin portal.

- Back up the App Service and SQL Server master databases:
  - AppService_Hosting;
  - AppService_Metering;
  - Master

- Back up the tenant app content file share.

  > [!IMPORTANT]
  > Cloud operators are responsible for the maintenance and operation of the file server and SQL Server. The resource provider doesn't manage these resources. The cloud operator is responsible for backing up the App Service databases and tenant content file share.

- Syndicate the **Custom Script Extension** version **1.9.3** from the Marketplace.

## Pre-update steps

 > [!NOTE]
 > If you previously deployed App Service on Azure Stack Hub 2022 H1 to your Azure Stack Hub stamp, this release is a minor upgrade to 2022 H1 that addresses two issues.

App Service on Azure Stack Hub 2302 is a significant update that takes multiple hours to complete. The whole deployment is updated and all roles are recreated with the Windows Server 2022 Datacenter OS. Therefore, inform your end customers of a planned update before applying the update.

- As of the App Service on Azure Stack Hub 2022 H1 update, the letter **K** is now a reserved SKU letter. If you have a custom SKU defined that uses the letter K, contact support to assist with resolving this situation prior to upgrade.

Review the [known issues for update](#known-issues-update) and take any actions prescribed.

## Post-deployment steps

> [!IMPORTANT]
> If you provide the App Service resource provider with a SQL Always On instance, you must [add the appservice_hosting and appservice_metering databases to an availability group](/sql/database-engine/availability-groups/windows/availability-group-add-a-database) and synchronize the databases to prevent any loss of service in the event of a database failover.

## Known issues (update)

- In situations where you convert the appservice_hosting and appservice_metering databases to contained databases, the upgrade might fail if you don't successfully migrate logins to contained users.

  If you convert the appservice_hosting and appservice_metering databases to contained databases after deployment, and you don't successfully migrate the database logins to contained users, you might experience upgrade failures.  

  You must run the following script against the SQL Server hosting appservice_hosting and appservice_metering before upgrading your App Service on Azure Stack Hub installation to 2020 Q3. This script is non-destructive and doesn't cause downtime.

  Run this script under the following conditions:

  - By a user that has the system administrator privilege, such as the SQL SA Account.
  - If you're using SQL Always On, ensure you run the script from the SQL instance that contains all App Service logins in the form:
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

  This problem happens because of a missing feature on front-ends after the upgrade to Windows Server 2022. Operators must follow this procedure to resolve the problem.

  1. In the Azure Stack Hub admin portal, go to **Network Security Groups** and view the **ControllersNSG** Network Security Group.

  1. By default, remote desktop is disabled to all App Service infrastructure roles. Change the **Inbound_Rdp_3389** rule action to **Allow** access.

  1. Go to the resource group containing the App Service Resource Provider deployment. By default, the name is **AppService.\<region\>**. Connect to **CN0-VM**.
  1. Return to the **CN0-VM** remote desktop session.
  1. In an administrator PowerShell session, run:

      > [!IMPORTANT]
      > During the execution of this script, there's a pause for each instance in the front end scale set. If there's a message indicating the feature is being installed,
      > that instance is rebooted. Use the pause in the script to maintain front end availability. Operators must ensure at least one front end instance is "Ready" at all times
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
      }

      Remove-PSSession -Session $session

      Read-Host -Prompt "If installing the feature, the machine will reboot. Wait until there's enough frontend availability, then press ENTER to continue"
      ```

  1. In the Azure Stack admin portal, go back to the **ControllersNSG** Network Security Group.

  1. Change the **Inbound_Rdp_3389** rule to deny access.

## Known issues (post-installation)

- Workers can't reach the file server when you deploy App Service in an existing virtual network and the file server is only available on the private network, as described in the App Service on Azure Stack deployment documentation.

  If you choose to deploy into an existing virtual network and use an internal IP address to connect to your file server, you must add an outbound security rule that enables SMB traffic between the worker subnet and the file server. Go to the **WorkersNsg** in the admin portal and add an outbound security rule with the following properties:
  - Source: Any
  - Source port range: *
  - Destination: IP Addresses
  - Destination IP address range: Range of IPs for your file server
  - Destination port range: 445
  - Protocol: TCP
  - Action: Allow
  - Priority: 700
  - Name: Outbound_Allow_SMB445

- To remove latency when workers communicate with the file server, also add the following rule to the Worker NSG to allow outbound LDAP and Kerberos traffic to your Active Directory controllers if you're securing the file server by using Active Directory. For example, if you used the Quickstart template to deploy a HA file server and SQL Server.

  Go to the **WorkersNsg** in the admin portal and add an outbound security rule with the following properties:
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

  This problem happens because of a missing feature on front ends after the upgrade to Windows Server 2022. Operators must follow this procedure to resolve the problem:

  1. In the Azure Stack Hub admin portal, go to **Network Security Groups** and view the **ControllersNSG** Network Security Group.

  1. By default, remote desktop is disabled to all App Service infrastructure roles. Change the **Inbound_Rdp_3389** rule action to **Allow** access.

  1. Go to the resource group containing the App Service Resource Provider deployment. By default, the name is **AppService.\<region\>**. Connect to **CN0-VM**.
  1. Return to the **CN0-VM** remote desktop session.
  1. In an administrator PowerShell session, run:
      
      > [!IMPORTANT]
      > During the execution of this script, there's a pause for each instance in the front end scale set. If there's a message indicating the feature is being installed,
      > that instance is rebooted. Use the pause in the script to maintain front end availability. Operators must ensure at least one front end instance is "Ready" at all times
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
      }

      Remove-PSSession -Session $session      
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
