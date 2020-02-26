---
title: App Service on Azure Stack Hub update 6 release notes 
description: Learn about what's in update six for App Service on Azure Stack Hub, the known issues, and where to download the update.
author: apwestgarth
manager: stefsch

ms.topic: article
ms.date: 06/24/2019
ms.author: anwestg
ms.review

# Intent: Notdone: As a < type of user >, I want < what? > so that < why? >
# Keyword: Notdone: keyword noun phrase

---

# App Service on Azure Stack Hub update 6 release notes

These release notes describe the improvements and fixes in Azure App Service on Azure Stack Hub Update 6 and any known issues. Known issues are divided into issues directly related to the deployment, update process, and issues with the build (post-installation).

> [!IMPORTANT]
> Apply the 1904 update to your Azure Stack Hub integrated system or deploy the latest Azure Stack Development kit before deploying Azure App Service 1.6.


## Build reference

The App Service on Azure Stack Hub Update 6 build number is **82.0.1.50**

### Prerequisites

Refer to the [Before You Get Started documentation](azure-stack-app-service-before-you-get-started.md) before beginning deployment.

Before you begin the upgrade of Azure App Service on Azure Stack Hub to 1.6:

- Ensure all roles are Ready in the Azure App Service Administration in the Azure Stack Hub Admin Portal

- Back up the App Service and Master Databases:
  - AppService_Hosting;
  - AppService_Metering;
  - Master

- Back up the Tenant App content file share

- Syndicate the **Custom Script Extension** version **1.9.1** from the Marketplace

### New features and fixes

Azure App Service on Azure Stack Hub Update 6 includes the following improvements and fixes:

- Updates to **App Service Tenant, Admin, Functions portals and Kudu tools**. Consistent with Azure Stack Hub Portal SDK version.

- Updates **Azure Functions runtime** to **v1.0.12299**.

- Updates to core service to improve reliability and error messaging enabling easier diagnosis of common issues.

- **Updates to the following application frameworks and tools**:
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

### Post-deployment Steps

> [!IMPORTANT]
> If you have provided the App Service resource provider with a SQL Always On Instance you MUST [add the appservice_hosting and appservice_metering databases to an availability group](https://docs.microsoft.com/sql/database-engine/availability-groups/windows/availability-group-add-a-database) and synchronize the databases to prevent any loss of service in the event of a database failover.

### Known issues (post-installation)

- Workers are unable to reach file server when App Service is deployed in an existing virtual network and the file server is only available on the private network,  as called out in the Azure App Service on Azure Stack Hub deployment documentation.

If you chose to deploy into an existing virtual network and an internal IP address to connect to your file server, you must add an outbound security rule, enabling SMB traffic between the worker subnet and the file server. Go to the WorkersNsg in the Admin Portal and add an outbound security rule with the following properties:
 * Source: Any
 * Source port range: *
 * Destination: IP Addresses
 * Destination IP address range: Range of IPs for your file server
 * Destination port range: 445
 * Protocol: TCP
 * Action: Allow
 * Priority: 700
 * Name: Outbound_Allow_SMB445

### Known issues for Cloud Admins operating Azure App Service on Azure Stack Hub

Refer to the documentation in the [Azure Stack Hub 1908 Release Notes](/azure-stack/operator/release-notes?view=azs-1908)

### Known issues for Tenants deploying applications on Azure App Service on Azure Stack Hub

- Deployment Center is greyed out

Tenants cannot yet make use of Deployment Center, which is a feature that was released in the public cloud in late 2018.  Tenants can still use the standard deployment methods (FTP, Web Deploy, Git, etc.) via the portal, CLI, and PowerShell.

- Deployment options (Classic) UX and Deployment credentials portal options not available

In order to reach the deployment options and deployment credentials user experiences in the Azure Stack Hub deployment, tenants should access the portal using this URL format - https://portal.&lt;*region*&gt;.&lt;*FQDN*&gt;/?websitesExtension_oldvsts=true - which, for the ASDK would be [https://portal.local.azurestack.external/?websitesExtension_oldvsts=true](https://portal.local.azurestack.external/?websitesExtension_oldvsts=true) , and then navigate to their applications normally.

- Azure Function Monitoring continually shows "Loading" in the portal

When you attempt to monitor individual Functions, in the user portal, you will see no invocation log, success count, or error count.  To re-enable this functionality, go to your **Function App**, go to **Platform Features**, and go to **Application settings**.  Add a new app setting - name **AzureWebJobsDashboard** and set the value to the same value as set in AzureWebJobsStorage.  Then go to the Monitor view on your function and you will see the monitoring information.

## Next steps

- For an overview of Azure App Service, see [Azure App Service on Azure Stack Hub overview](azure-stack-app-service-overview.md).
- For more information about how to prepare to deploy App Service on Azure Stack Hub, see [Before you get started with App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md).
