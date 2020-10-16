---
title: Update Azure App Service on Azure Stack Hub 
description: Learn how to update Azure App Service on Azure Stack Hub.
author: BryanLa

ms.topic: article
ms.date: 05/05/2019
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 01/13/2019
zone_pivot_groups: state-connected-disconnected
# Intent: As an Azure Stack operator, I want to update my App Service so I'm up to date.
# Keyword: update app service azure stack

---

# Update Azure App Service on Azure Stack Hub

[!INCLUDE [Azure Stack Hub update reminder](../includes/app-service-hub-update-banner.md)]

::: zone pivot="state-connected"
In this article, you learn how to upgrade the [Azure App Service resource provider](azure-stack-app-service-overview.md) deployed in an internet-connected Azure Stack Hub environment.

> [!IMPORTANT]
> Prior to running the upgrade, you must complete [deployment of Azure App Service on Azure Stack Hub](azure-stack-app-service-deploy.md). 

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

1. Download the [Azure App Service Installer](https://aka.ms/appsvcupdateQ2installer).

2. Run appservice.exe as an admin.

    ![Screenshot that shows how to start the deployment or upgrade process in the App Service installer.][1]

3. Click **Deploy Azure App Service or upgrade to the latest version.**

4. Review and accept the Microsoft Software License Terms and then click **Next**.

5. Review and accept the third-party license terms and then click **Next**.

6. Make sure that the Azure Stack Hub Azure Resource Manager endpoint and Active Directory Tenant info is correct. If you used the default settings during ASDK deployment, you can accept the default values here. However, if you customized the options when you deployed Azure Stack Hub, you must edit the values in this window. For example, if you use the domain suffix *mycloud.com*, your Azure Stack Hub Azure Resource Manager endpoint must change to *management.region.mycloud.com*. After you confirm your info, click **Next**.

    ![Screenshot that shows where to configure the ARM endpoints in the App Service installer.][2]

7. On the next page:

    1. Select the connection method you wish to use - **Credential** or **Service Principal**
        - **Credential**
            - If you're using Azure Active Directory (Azure AD), enter the Azure AD admin account and password that you provided when you deployed Azure Stack Hub. Select **Connect**.
            - If you're using Active Directory Federation Services (AD FS), provide your admin account. For example, cloudadmin@azurestack.local. Enter your password, and then select **Connect**.
        - **Service Principal**
            - The service principal that you use **must** have **Owner** rights on the **Default Provider Subscription**
            - Provide the **Service Principal ID**, **Certificate File**, and **Password** and select **Connect**.

    1. In **Azure Stack Hub Subscriptions**, select the **Default Provider Subscription**.    Azure App Service on Azure Stack Hub **must** be deployed in the **Default Provider Subscription**.

    1. In the **Azure Stack Hub Locations**, select the location that corresponds to the region you're deploying to. For example, select **local** if you're deploying to the ASDK.

    1. If an existing Azure App Service deployment is detected, then the resource group and storage account are populated and unavailable.

      ![Screenshot that shows where you specify the Azure Stack Hub subscription information in the App Service installer.][3]

8. On the summary page:
   1. Verify the selections you made. To make changes, use the **Previous** buttons to visit previous pages.
   2. If the configurations are correct, select the check box.
   3. To start the upgrade, click **Next**.

       ![Screenshot that shows the App Service upgrade summary in the installer.][4]

9. Upgrade progress page:
    1. Track the upgrade progress. The duration of the upgrade of Azure App Service on Azure Stack Hub varies depending on the number of role instances deployed.
    2. After the upgrade successfully completes, click **Exit**.

        ![Screenshot that shows the deployment progress in the App Service installer.][5]
::: zone-end

::: zone pivot="state-disconnected"
In this article, you learn how to upgrade the [Azure App Service resource provider](azure-stack-app-service-overview.md) deployed in an Azure Stack Hub environment that is:

* not connected to the Internet
* secured by Active Directory Federation Services (AD FS).

> [!IMPORTANT]
> Prior to running the upgrade, you must complete [deployment of Azure App Service on Azure Stack Hub in an disconnected environment](./azure-stack-app-service-deploy.md?pivots=state-disconnected&view=azs-2002). 

## Run the App Service resource provider installer

To upgrade the App Service resource provider in an Azure Stack Hub environment, you must complete these tasks:

1. Download the [Azure App Service Installer](https://aka.ms/appsvcupdate8installer).
2. Create an offline upgrade package.
3. Run the App Service installer (appservice.exe) and complete the upgrade.

During this process, the upgrade will:

* Detect prior deployment of App Service
* Upload to Storage
* Upgrade all App Service roles (Controllers, Management, Front-End, Publisher, and Worker roles)
* Update App Service scale set definitions
* Update App Service Resource Provider Manifest

## Create an offline upgrade package

To upgrade App Service in a disconnected environment, you must first create an offline upgrade package on a machine that's connected to the Internet.

1. Run appservice.exe as an administrator

    ![Screenshot that shows how to start an upgrade in a disconnect environment.][11]

2. Click **Advanced** > **Create offline package**

    ![Screenshot that shows how to create an offline package in the App Service installer.][12]

3. The Azure App Service installer creates an offline upgrade package and displays the path to it.  You can click **Open folder** to open the folder in your file explorer.

4. Copy the installer (AppService.exe) and the offline installation package to a machine that has connectivity to your Azure Stack Hub.

## Complete the upgrade of App Service on Azure Stack Hub

> [!IMPORTANT]
> The Azure App Service installer must be run on a machine which can reach the Azure Stack Hub Administrator Azure Resource Manager Endpoint.

1. Run appservice.exe as an administrator.

    ![Screenshot that shows how to start an upgrade.][11]

2. Click **Advanced** > **Complete offline installation or upgrade**.

    ![Screenshot that shows how to complete an offline installation or upgrade in the App Service installer.][12]

3. Browse to the location of the offline upgrade package you previously created and then click **Next**.

4. Review and accept the Microsoft Software License Terms and then click **Next**.

5. Review and accept the third-party license terms and then click **Next**.

6. Make sure that the Azure Stack Hub Azure Resource Manager endpoint and Active Directory Tenant information is correct. If you used the default settings during Azure Stack Development Kit deployment, you can accept the default values here. However, if you customized the options when you deployed Azure Stack Hub, you must edit the values in this window. For example, if you use the domain suffix *mycloud.com*, your Azure Stack Hub Azure Resource Manager endpoint must change to *management.region.mycloud.com*. After you confirm your information, click **Next**.

    ![Screenshot that shows where to configure the ARM endpoints in the installer.][13]

7. On the next page:

   1. Select the connection method you wish to use - **Credential** or **Service Principal**
        - **Credential**
            - If you're using Azure Active Directory (Azure AD), enter the Azure AD admin account and password that you provided when you deployed Azure Stack Hub. Select **Connect**.
            - If you're using Active Directory Federation Services (AD FS), provide your admin account. For example, cloudadmin@azurestack.local. Enter your password, and then select **Connect**.
        - **Service Principal**
            - The service principal that you use **must** have **Owner** rights on the **Default Provider Subscription**
            - Provide the **Service Principal ID**, **Certificate File**, and **Password** and select **Connect**.

   1. In **Azure Stack Hub Subscriptions**, select the **Default Provider Subscription**.  Azure App Service on Azure Stack Hub **must** be deployed in the **Default Provider Subscription**.

   1. In the **Azure Stack Hub Locations**, select the location that corresponds to the region you're deploying to. For example, select **local** if you're deploying to the ASDK.
   
   1. If an existing App Service deployment is detected, then the resource group and storage account will be populated and greyed out.

      ![Screenshot that shows where to configure the Azure Stack Hub subscriptions in the installer.][14]
8. On the summary page:
   1. Verify the selections you made. To make changes, use the **Previous** buttons to visit previous pages.
   2. If the configurations are correct, select the check box.
   3. To start the upgrade, click **Next**.

       ![Screenshot that shows the summary of the information collected in the installer.][15]

9. Upgrade progress page:
    1. Track the upgrade progress. The duration of the upgrade of App Service on Azure Stack Hub varies dependent on number of role instances deployed.
    2. After the upgrade successfully completes, click **Exit**.

        ![Screenshot that shows the upgrade completed successfully.][16]
::: zone-end

## Next steps

Prepare for additional admin operations for Azure App Service on Azure Stack Hub:

* [Plan for additional capacity](azure-stack-app-service-capacity-planning.md)
* [Add additional capacity](azure-stack-app-service-add-worker-roles.md)

<!--Image references-->
[1]: ./media/azure-stack-app-service-update/app-service-exe.png
[2]: ./media/azure-stack-app-service-update/app-service-azure-resource-manager-endpoints.png
[3]: ./media/azure-stack-app-service-update/app-service-installation-detected.png
[4]: ./media/azure-stack-app-service-update/app-service-upgrade-summary.png
[5]: ./media/azure-stack-app-service-update/app-service-upgrade-complete.png

[11]: ./media/azure-stack-app-service-update-offline/app-service-exe.png
[12]: ./media/azure-stack-app-service-update-offline/app-service-exe-advanced.png
[13]: ./media/azure-stack-app-service-update-offline/app-service-azure-resource-manager-endpoints.png
[14]: ./media/azure-stack-app-service-update-offline/app-service-installation-detected.png
[15]: ./media/azure-stack-app-service-update-offline/app-service-upgrade-summary.png
[16]: ./media/azure-stack-app-service-update-offline/app-service-upgrade-complete.png
