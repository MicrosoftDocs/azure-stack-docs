---
title: App Service on Azure Stack Hub update 7 release notes | Microsoft Docs
description: Learn about what's in update seven for App Service on Azure Stack Hub, the known issues, and where to download the update.
author: apwestgarth
manager: stefsch

ms.service: azure-stack
ms.topic: article
ms.date: 10/11/2019
ms.author: anwestg
ms.reviewer:

---
# App Service on Azure Stack Hub update 7 release notes

These release notes describe the improvements and fixes in Azure App Service on Azure Stack Hub Update 7 and any known issues. Known issues are divided into issues directly related to the deployment, update process, and issues with the build (post-installation).

> [!IMPORTANT]
> Apply the 1907 update to your Azure Stack Hub integrated system or deploy the latest Azure Stack Development kit before deploying Azure App Service 1.7.


## Build reference

The App Service on Azure Stack Hub Update 7 build number is **84.0.2.10**

### Prerequisites

Refer to the [Before You Get Started documentation](azure-stack-app-service-before-you-get-started.md) before beginning deployment.

Before you begin the upgrade of Azure App Service on Azure Stack Hub to 1.7:

- Ensure all roles are Ready in the Azure App Service Administration in the Azure Stack Hub Admin Portal

- Back up the App Service and Master Databases:
  - AppService_Hosting;
  - AppService_Metering;
  - Master

- Back up the Tenant App content file share

- Syndicate the **Custom Script Extension** version **1.9.3** from the Marketplace

### New features and fixes

Azure App Service on Azure Stack Hub Update 7 includes the following improvements and fixes:

- Resolution for [CVE-2019-1372](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2019-1372) Remote Code Execution Vulnerability

- Updates to **App Service Tenant, Admin, Functions portals and Kudu tools**. Consistent with Azure Stack Hub Portal SDK version.

- Updates **Azure Functions runtime** to **v1.0.12582**.

- Updates to core service to improve reliability and error messaging enabling easier diagnosis of common issues.

- **Updates to the following application frameworks and tools**:
  - ASP.NET Core 2.2.46
  - Zul OpenJDK 8.38.0.13
  - Tomcat 7.0.94
  - Tomcat 8.5.42
  - Tomcat 9.0.21
  - PHP 5.6.40
  - PHP 7.3.6
  - Updated Kudu to 82.10503.3890

- **Updates to underlying operating system of all roles**:
  - [2019-08 Cumulative Update for Windows Server 2016 for x64-based Systems (KB4512495)](https://support.microsoft.com/help/4512495)

- **Access Restrictions now enabled in User Portal**:
  - As of this release Users can configure Access Restrictions for their Web/Api/Functions applications according to the documentation published - [Azure App Service Access Restrictions](https://docs.microsoft.com/azure/app-service/app-service-ip-restrictions), **NOTE**: Azure App Service on Azure Stack Hub does not support Service Endpoints.

- **Deployment Options (Classic) Functionality Restored**:
  - Users can once again use the Deployment Options (Classic) to configure deployment of their apps from GitHub, Bitbucket, Dropbox, OneDrive, Local and External Repositories, and to set the Deployment Credentials for their applications.

- **Azure Function Monitoring** configured correctly.

- **Windows Update Behavior**:
  Based on customer feedback we have changed the way in which Windows Update is configured on App Service roles from Update 7:
  - Three modes:
    - **Disabled** - Windows Update service disabled, Windows will be updated with the KB that is shipped with Azure App Service on Azure Stack Hub releases;
    - **Automatic** - Windows Update service enabled and Windows Update will determine how and when to update;
    - **Managed** - Windows Update service is disabled, Azure App Service will perform a Windows Update cycle during OnStart of the individual role.

  **New** Deployments - Windows Update service is disabled by default.

  **Existing** Deployments - If you have modified the setting on the Controller, the value will now change from **False** to **Disabled** and a previous value of **true** will become **Automatic**

### Post-deployment steps

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

Refer to the documentation in the [Azure Stack Hub 1907 Release Notes](azure-stack-release-notes-1907.md)

## Next steps

- For an overview of Azure App Service, see [Azure App Service on Azure Stack Hub overview](azure-stack-app-service-overview.md).
- For more information about how to prepare to deploy App Service on Azure Stack Hub, see [Before you get started with App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md).
