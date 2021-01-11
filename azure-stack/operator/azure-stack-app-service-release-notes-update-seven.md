---
title: App Service on Azure Stack Hub update 7 release notes 
description: Update 7 release notes for App Service on Azure Stack Hub, including new features, fixes, and known issues.
author: apwestgarth
manager: stefsch
ms.topic: article
ms.date: 10/11/2019
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 08/20/2019

# Intent: As an Azure Stack Hub operator, I want the release notes for update 7 of App Service on Azure Stack Hub so I can know the new features, fixes, and known issues.
# Keyword: app service azure stack hub update 7 release notes

---

# App Service on Azure Stack Hub update 7 release notes

These release notes describe new features, fixes, and known issues in Azure App Service on Azure Stack Hub update 7. Known issues are divided into two sections: issues related to the upgrade process and issues with the build (post-installation).

> [!IMPORTANT]
> Apply the 1910 update to your Azure Stack integrated system or deploy the latest Azure Stack Development Kit (ASDK) before deploying Azure App Service 1.7.

## Build reference

The App Service on Azure Stack Hub Update 7 build number is **84.0.2.10**.

## Prerequisites

See [Prerequisites for deploying App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md) before beginning deployment.

Before you begin the upgrade of Azure App Service on Azure Stack Hub to 1.7:

- Ensure all roles are ready in Azure App Service administration in the Azure Stack Hub administrator portal.

- Backup App Service Secrets using the App Service Administration in the Azure Stack Hub Admin Portal

- Back up the App Service and master Databases:
  - AppService_Hosting;
  - AppService_Metering;
  - master

- Back up the tenant app content file share.

  > [!Important]
  > Cloud operators are responsible for the maintenance and operation of the File Server and SQL Server.  The resource provider does not manage these resources.  The cloud operator is responsible for backing up the App Service databases and tenant content file share.

- Syndicate the **Custom Script Extension** version **1.9.3** from the Azure Stack Hub Marketplace.

## New features and fixes

Azure App Service on Azure Stack Hub Update 7 includes the following improvements and fixes:

- Resolution for [CVE-2019-1372](https://portal.msrc.microsoft.com/en-US/security-guidance/advisory/CVE-2019-1372) Remote Code Execution Vulnerability.

- Updates to **App Service tenant, administrator, functions portals, and Kudu tools**. Consistent with Azure Stack Hub Portal SDK version.

- Updates **Azure Functions runtime** to **v1.0.12582**.

- Updates to core service to improve reliability and error messaging enabling easier diagnosis of common issues.

- **Updates to the following app frameworks and tools**:

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

- **Access restrictions now enabled in user portal**:
  - Users can now configure access restrictions for their web/API/functions apps according to the documentation published - [Azure App Service access restrictions](/azure/app-service/app-service-ip-restrictions).
  
  > [!NOTE]
  > Azure App Service on Azure Stack Hub does not support service endpoints.

- **Deployment options (classic) functionality restored**:
  - Users can once again use the deployment options (classic) to configure deployment of their apps from GitHub, Bitbucket, Dropbox, OneDrive, local and external repositories, and to set the deployment credentials for their apps.

- **Azure function monitoring** configured correctly.

- **Windows update behavior**:
  Based on customer feedback, we've changed the way Windows Update is configured on App Service roles from Update 7:
  - Three modes:
    - **Disabled** - Windows Update service disabled, Windows is updated with the KB that's shipped with Azure App Service on Azure Stack Hub releases;
    - **Automatic** - Windows Update service enabled and Windows Update determines how and when to update;
    - **Managed** - Windows Update service is disabled, Azure App Service performs a Windows Update cycle during OnStart of the individual role.

  **New** Deployments - Windows Update service is disabled by default.

  **Existing** Deployments - If you've modified the setting on the controller, the value will change from **False** to **Disabled** and a previous value of **true** will become **Automatic**.

## Post-deployment steps

> [!IMPORTANT]
> If you've provided the App Service resource provider with a SQL Always On Instance you MUST [add the appservice_hosting and appservice_metering databases to an availability group](/sql/database-engine/availability-groups/windows/availability-group-add-a-database) and synchronize the databases to prevent any loss of service in the event of a database failover.

## Known issues (post-installation)

- Workers are unable to reach file server when App Service is deployed in an existing virtual network and the file server is only available on the private network, as called out in the Azure App Service on Azure Stack Hub deployment documentation.

If you chose to deploy into an existing virtual network and an internal IP address to connect to your file server, you must add an outbound security rule, enabling SMB traffic between the worker subnet and the file server. Go to the WorkersNsg in the administrator portal and add an outbound security rule with the following properties:

* Source: Any
* Source port range: *
* Destination: IP addresses
* Destination IP address range: Range of IPs for your file server
* Destination port range: 445
* Protocol: TCP
* Action: Allow
* Priority: 700
* Name: Outbound_Allow_SMB445

## Known issues for cloud admins operating Azure App Service on Azure Stack Hub

Refer to the documentation in the [Azure Stack Hub 1907 release notes](./release-notes.md?view=azs-1907&preserve-view=true)

## Next steps

- For an overview of Azure App Service, see [Azure App Service and Azure Functions on Azure Stack Hub overview](azure-stack-app-service-overview.md).
- For more information about how to prepare to deploy App Service on Azure Stack Hub, see [Prerequisites for deploying App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md).
