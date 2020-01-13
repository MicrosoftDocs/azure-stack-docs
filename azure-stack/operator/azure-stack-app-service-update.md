---
title: Update Azure App Service on Azure Stack Hub | Microsoft Docs
description: Learn how to update Azure App Service on Azure Stack Hub.
services: azure-stack
documentationcenter: ''
author: BryanLa
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: app-service
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 01/13/2019
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 01/13/2019

---
# Update Azure App Service on Azure Stack Hub

*Applies to: Azure Stack integrated systems and Azure Stack Hub Development Kit*

> [!IMPORTANT]
> Apply the 1910 update to your Azure Stack Hub integrated system or deploy the latest Azure Stack Hub Development Kit (ASDK) before deploying Azure App Service 1.8.

In this article, we show you how to upgrade the [Azure App Service resource provider](azure-stack-app-service-overview.md) deployed in an internet-connected Azure Stack Hub environment.

> [!IMPORTANT]
> Prior to running the upgrade, make sure that you've already completed the [deployment of the Azure App Service on Azure Stack Hub](azure-stack-app-service-deploy.md). You should also read the [release notes](azure-stack-app-service-release-notes-update-eight.md) which accompany the 1.8 release so you can learn about new functionality, fixes, and any known issues that could affect your deployment.

## Run the Azure App Service resource provider installer

During this process, the upgrade will:

* Detect prior deployment of Azure App Service.
* Prepare all update packages and new versions of all OSS Libraries to be deployed.
* Upload to storage.
* Upgrade all Azure App Service roles (Controllers, Management, Front-End, Publisher, and Worker roles).
* Update Azure App Service scale set definitions.
* Update Azure App Service resource provider manifest.

> [!IMPORTANT]
> The Azure App Service installer must be run on a machine which can reach the Azure Stack Hub admin Azure Resource Manager endpoint.

To upgrade your deployment of Azure App Service on Azure Stack Hub, follow these steps:

1. Download the [Azure App Service Installer](https://aka.ms/appsvcupdate8installer).

2. Run appservice.exe as an admin.

    ![Azure App Service Installer][1]

3. Click **Deploy Azure App Service or upgrade to the latest version.**

4. Review and accept the Microsoft Software License Terms and then click **Next**.

5. Review and accept the third-party license terms and then click **Next**.

6. Make sure that the Azure Stack Hub Azure Resource Manager endpoint and Active Directory Tenant info is correct. If you used the default settings during ASDK deployment, you can accept the default values here. However, if you customized the options when you deployed Azure Stack Hub, you must edit the values in this window. For example, if you use the domain suffix *mycloud.com*, your Azure Stack Hub Azure Resource Manager endpoint must change to *management.region.mycloud.com*. After you confirm your info, click **Next**.

    ![Azure Stack Hub Cloud Information][2]

7. On the next page:

    1. Select the connection method you wish to use - **Credential** or **Service Principal**
        - **Credential**
            - If you're using Azure Active Directory (Azure AD), enter the Azure AD admin account and password that you provided when you deployed Azure Stack Hub. Select **Connect**.
            - If you're using Active Directory Federation Services (AD FS), provide your admin account. For example, cloudadmin@azurestack.local. Enter your password, and then select **Connect**.
        - **Service Principal**
            - The service principal which you use **must** have **Owner** rights on the **Default Provider Subscription**
            - Provide the **Service Principal ID**, **Certificate File** and **Password** and select **Connect**.

    1. In **Azure Stack Hub Subscriptions**, select the **Default Provider Subscription**.    Azure App Service on Azure Stack Hub **must** be deployed in the **Default Provider Subscription**.

    1. In the **Azure Stack Hub Locations**, select the location that corresponds to the region you're deploying to. For example, select **local** if you're deploying to the ASDK.

    1. If an existing Azure App Service deployment is detected, then the resource group and storage account are populated and unavailable.

      ![Azure App Service Installation Detected][3]

8. On the summary page:
   1. Verify the selections you made. To make changes, use the **Previous** buttons to visit previous pages.
   2. If the configurations are correct, select the check box.
   3. To start the upgrade, click **Next**.

       ![Azure App Service Upgrade Summary][4]

9. Upgrade progress page:
    1. Track the upgrade progress. The duration of the upgrade of Azure App Service on Azure Stack Hub varies depending on the number of role instances deployed.
    2. After the upgrade successfully completes, click **Exit**.

        ![Azure App Service Upgrade Progress][5]

<!--Image references-->
[1]: ./media/azure-stack-app-service-update/app-service-exe.png
[2]: ./media/azure-stack-app-service-update/app-service-azure-resource-manager-endpoints.png
[3]: ./media/azure-stack-app-service-update/app-service-installation-detected.png
[4]: ./media/azure-stack-app-service-update/app-service-upgrade-summary.png
[5]: ./media/azure-stack-app-service-update/app-service-upgrade-complete.png

## Next steps

Prepare for additional admin operations for Azure App Service on Azure Stack Hub:

* [Plan for additional capacity](azure-stack-app-service-capacity-planning.md)
* [Add additional capacity](azure-stack-app-service-add-worker-roles.md)
