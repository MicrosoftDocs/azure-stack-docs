---
title: App Service on Azure Stack Hub update 6 release notes 
description: Update 6 release notes for App Service on Azure Stack Hub, including new features, fixes, and known issues.
author: apwestgarth
manager: stefsch
ms.topic: article
ms.date: 06/24/2019
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 08/20/2019

# Intent: As an Azure Stack Hub operator, I want the release notes for update 6 of App Service on Azure Stack Hub so I can know the new features, fixes, and known issues.
# Keyword: app service azure stack hub update 6 release notes

---

# App Service on Azure Stack Hub update 6 release notes

These release notes describe new features, fixes, and known issues in Azure App Service on Azure Stack Hub update 6. Known issues are divided into two sections: issues related to the upgrade process and issues with the build (post-installation).

> [!IMPORTANT]
> Apply the 1904 update to your Azure Stack Hub integrated system or deploy the latest Azure Stack Development Kit (ASDK) before deploying Azure App Service 1.6.

## Build reference

The App Service on Azure Stack Hub update 6 build number is **82.0.1.50**.

## Prerequisites

See [Prerequisites for deploying App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md) before you begin deployment.

Before you begin the upgrade of Azure App Service on Azure Stack Hub to 1.6:

- Ensure all roles are ready in Azure App Service administration in the Azure Stack Hub administrator portal.

- Backup App Service Secrets using the App Service Administration in the Azure Stack Hub Admin Portal

- Back up the App Service and master Databases:
  - AppService_Hosting;
  - AppService_Metering;
  - master

- Back up the tenant app content file share.

  > [!Important]
  > Cloud operators are responsible for the maintenance and operation of the File Server and SQL Server.  The resource provider does not manage these resources.  The cloud operator is responsible for backing up the App Service databases and tenant content file share.

- Syndicate the **Custom Script Extension** version **1.9.1** from the Azure Stack Hub Marketplace.

## New features and fixes

Azure App Service on Azure Stack Hub update 6 includes the following improvements and fixes:

- Updates to **App Service tenant, admin, functions portals, and Kudu tools**. Consistent with Azure Stack Hub portal SDK version.

- Updates **Azure Functions runtime** to **v1.0.12299**.

- Updates to core service to improve reliability and error messaging enabling easier diagnosis of common issues.

- **Updates to the following app frameworks and tools**:

  - ASP.NET Core 2.2.4
  - NodeJS 10.15.2
  - Zulu OpenJDK 8.36.0.1
  - Tomcat 7.0.81
  - Tomcat 8.5.37
  - Tomcat 9.0.14
  - PHP 5.6.39
  - PHP 7.0.33
  - PHP 7.1.25
  - PHP 7.2.13
  - Updated Kudu to 81.10329.3844

- **Updates to underlying operating system of all roles**:
  - [2019-04 Cumulative Update for Windows Server 2016 for x64-based Systems (KB4493473)](https://support.microsoft.com/help/4493473/windows-10-update-kb4493473)

## Post-deployment Steps

> [!IMPORTANT]
> If you've provided the App Service resource provider with a SQL Always On Instance, you MUST [add the appservice_hosting and appservice_metering databases to an availability group](/sql/database-engine/availability-groups/windows/availability-group-add-a-database) and synchronize the databases to prevent any loss of service in the event of a database failover.

## Known issues (post-installation)

- Workers are unable to reach file server when App Service is deployed in an existing virtual network and the file server is only available on the private network,  as called out in the Azure App Service on Azure Stack Hub deployment documentation.

If you chose to deploy into an existing virtual network and an internal IP address to connect to your file server, you must add an outbound security rule, enabling SMB traffic between the worker subnet and the file server. Go to the WorkersNsg in the administrator portal and add an outbound security rule with the following properties:

* Source: Any
* Source port range: *
* Destination: IP Addresses
* Destination IP address range: Range of IPs for your file server
* Destination port range: 445
* Protocol: TCP
* Action: Allow
* Priority: 700
* Name: Outbound_Allow_SMB445

## Known issues for cloud admins operating Azure App Service on Azure Stack Hub

Refer to the documentation in the [Azure Stack Hub 1908 release notes](./release-notes.md?view=azs-1908&preserve-view=true).

## Known issues for tenants deploying applications on Azure App Service on Azure Stack Hub

- Deployment Center is greyed out/unavailable.

    Tenants can't yet make use of Deployment Center, which is a feature that was released in the public cloud in late 2018. Tenants can still use the standard deployment methods (FTP, Web Deploy, Git, and so on) via the portal, CLI, and PowerShell.

- Deployment options (classic) UX and deployment credentials portal options not available.

    To reach the deployment options and deployment credentials user experience in the Azure Stack Hub deployment, tenants should access the portal using this URL format: `https://portal.&lt;*region*&gt;.&lt;*FQDN*&gt;/?websitesExtension_oldvsts=true` - which, for the ASDK would be `https://portal.local.azurestack.external/?websitesExtension_oldvsts=true`, and then navigate to their apps.

- Azure function monitoring continually shows "Loading" in the portal.

    When you attempt to monitor individual functions in the user portal, you'll see no invocation log, success count, or error count. To re-enable this functionality, go to your **Function App**, go to **Platform Features**, and go to **Application settings**.  Add a new app setting called **AzureWebJobsDashboard** and set the value to the same value as set in AzureWebJobsStorage. Then go to the monitor view on your function and you'll see the monitoring information.

## Next steps

- For an overview of Azure App Service, see [Azure App Service and Azure Functions on Azure Stack Hub overview](azure-stack-app-service-overview.md).
- For more information about how to prepare to deploy App Service on Azure Stack, see [Prerequisites for deploying App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md).
