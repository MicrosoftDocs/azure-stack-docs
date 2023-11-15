---
title: Update Azure App Service on Azure Stack Hub 
description: Learn how to update Azure App Service on Azure Stack Hub.
author: sethmanheim

ms.topic: article
ms.date: 10/2/2022
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 10/28/2020
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

# [Azure App Service on Azure Stack 2022 H1](#tab/22h1)

1. Download the [Azure App Service Installer](https://aka.ms/appsvcupdate21q1installer).

2. Run appservice.exe as an admin.

    ![Screenshot that shows how to start the deployment or upgrade process in the App Service installer.][1]

3. Select **Deploy Azure App Service or upgrade to the latest version.**

4. Review and accept the Microsoft Software License Terms and then select **Next**.

5. Review and accept the third-party license terms and then select **Next**.

6. Make sure that the Azure Stack Hub Azure Resource Manager endpoint and Active Directory Tenant info is correct. If you used the default settings during ASDK deployment, you can accept the default values here. However, if you customized the options when you deployed Azure Stack Hub, you must edit the values in this window. For example, if you use the domain suffix *mycloud.com*, your Azure Stack Hub Azure Resource Manager endpoint must change to *management.region.mycloud.com*. After you confirm your info, select **Next**.

    ![Screenshot that shows where to configure the ARM endpoints in the App Service installer.][2]

7. On the next page:

    1. Select the connection method you wish to use - **Credential** or **Service Principal**
        - **Credential**
            - If you're using Microsoft Entra ID, enter the Microsoft Entra admin account, and password that you provided when you deployed Azure Stack Hub. Select **Connect**.
            - If you're using Active Directory Federation Services (AD FS), provide your admin account. For example, cloudadmin@azurestack.local. Enter your password, and then select **Connect**.
        - **Service Principal**
            - The service principal that you use **must** have **Owner** rights on the **Default Provider Subscription**
            - Provide the **Service Principal ID**, **Certificate File**, and **Password** and select **Connect**.

    1. In **Azure Stack Hub Subscriptions**, select the **Default Provider Subscription**.    Azure App Service on Azure Stack Hub **must** be deployed in the **Default Provider Subscription**.

    1. In the **Azure Stack Hub Locations**, select the location that corresponds to the region you're deploying to. For example, select **local** if you're deploying to the ASDK.

    1. If an existing Azure App Service deployment is detected, then the resource group and storage account are populated and unavailable.
    
    1. **NEW**: Administrators can specify a three character **Deployment Prefix** for the individual instances in each Virtual Machine Scale Set that are deployed.  This is useful if managing multiple Azure Stack Hub instances.

      ![Screenshot showing Azure App Service on Azure Stack Hub installation detected.][9]

1. In the next screen, you'll see the results of a status check performed against the App Service Resource Provider.  This status check has been added to verify the deployment is in the correct state to be upgraded.  The status check verifies that all roles are ready, all worker tiers are valid, all virtual machine scale sets are healthy and verifies access to the App Service secrets.

    ![Screenshot showing Azure App Service on Azure Stack Hub pre-upgrade status check.][10]

1. The Platform Image and SKU screen gives Administrators the opportunity to choose the correct [Windows 2022 Platform](azure-stack-app-service-before-you-get-started.md#download-items-from-the-azure-marketplace) image to be used to deploy the new role instances.
    1. **Select** the correct Platform Image
    1. Over time the minimum recommended spec of VM/VM Scale Set instance SKUs has changed and here you see the details of what is currently deployed and the new recommended SKU.


8. On the summary page:
   1. Verify the selections you made. To make changes, use the **Previous** buttons to visit previous pages.
   2. If the configurations are correct, select the check box.
   3. To start the upgrade, select **Next**.

       ![Screenshot that shows the App Service upgrade summary in the installer.][4]

9. Upgrade progress page:
    1. Track the upgrade progress. The duration of the upgrade of Azure App Service on Azure Stack Hub varies depending on the number of role instances deployed.
    2. After the upgrade successfully completes, select **Exit**.

        ![Screenshot that shows the deployment progress in the App Service installer.][5]

> [!NOTE]
> Upgrading to 2022.H1 can take a considerable amount of time dependent on the number of role instances deployed within the App Service on Azure Stack Hub Resource Provider deployment.
>

# [Previous Versions](#tab/previous)

1. Download the [Azure App Service Installer](https://aka.ms/appsvcupdate21q1installer).

2. Run appservice.exe as an admin.

    ![Screenshot that shows how to start the deployment or upgrade process in the App Service installer.][1]

3. Select **Deploy Azure App Service or upgrade to the latest version.**

4. Review and accept the Microsoft Software License Terms and then select **Next**.

5. Review and accept the third-party license terms and then select **Next**.

6. Make sure that the Azure Stack Hub Azure Resource Manager endpoint and Active Directory Tenant info is correct. If you used the default settings during ASDK deployment, you can accept the default values here. However, if you customized the options when you deployed Azure Stack Hub, you must edit the values in this window. For example, if you use the domain suffix *mycloud.com*, your Azure Stack Hub Azure Resource Manager endpoint must change to *management.region.mycloud.com*. After you confirm your info, select **Next**.

    ![Screenshot that shows where to configure the ARM endpoints in the App Service installer.][2]

7. On the next page:

    1. Select the connection method you wish to use - **Credential** or **Service Principal**
        - **Credential**
            - If you're using Microsoft Entra ID, enter the Microsoft Entra admin account, and password that you provided when you deployed Azure Stack Hub. Select **Connect**.
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
   3. To start the upgrade, select **Next**.

       ![Screenshot that shows the App Service upgrade summary in the installer.][4]

9. Upgrade progress page:
    1. Track the upgrade progress. The duration of the upgrade of Azure App Service on Azure Stack Hub varies depending on the number of role instances deployed.
    2. After the upgrade successfully completes, select **Exit**.

        ![Screenshot that shows the deployment progress in the App Service installer.][5]

::: zone-end

::: zone pivot="state-disconnected"
In this article, you learn how to upgrade the [Azure App Service resource provider](azure-stack-app-service-overview.md) deployed in an Azure Stack Hub environment that is **disconnected** from the Internet and secured by **Active Directory Federation Services (AD FS)**.

> [!IMPORTANT]
> Prior to running the upgrade, you must complete [deployment of Azure App Service on Azure Stack Hub in an disconnected environment](./azure-stack-app-service-deploy.md?pivots=state-disconnected). 

## Run the App Service resource provider installer

To upgrade the App Service resource provider in an Azure Stack Hub environment, you must complete these tasks:

1. Download the [Azure App Service Installer](https://aka.ms/appsvcupdate21q1installer).
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

    ![Screenshot that shows the Azure App Service on Azure Stack Hub installer.][6]

2. Select **Advanced** > **Create offline package**

    ![Screenshot showing the Azure App Service on Azure Stack Hub installer advanced options.][7]

3. The Azure App Service installer creates an offline upgrade package and displays the path to it.  You can select **Open folder** to open the folder in your file explorer.

4. Copy the installer (AppService.exe) and the offline installation package to a machine that has connectivity to your Azure Stack Hub.

## Complete the upgrade of App Service on Azure Stack Hub

> [!IMPORTANT]
> The Azure App Service installer must be run on a machine which can reach the Azure Stack Hub Administrator Azure Resource Manager Endpoint.

# [Azure App Service on Azure Stack 2022 H1](#tab/22h1)

1. Run appservice.exe as an administrator.

    ![Screenshot that shows the Azure App Service on Azure Stack Hub installer.][6]

1. Select **Advanced** > **Complete offline installation or upgrade**.

    ![Screenshot showing the Azure App Service on Azure Stack Hub installer advanced options.][7]

1. Browse to the location of the offline upgrade package you previously created and then select **Next**.

1. Review and accept the Microsoft Software License Terms and then select **Next**.

1. Review and accept the third-party license terms and then select **Next**.

1. Make sure that the Azure Stack Hub Azure Resource Manager endpoint and Active Directory Tenant information is correct. If you used the default settings during Azure Stack Development Kit deployment, you can accept the default values here. However, if you customized the options when you deployed Azure Stack Hub, you must edit the values in this window. For example, if you use the domain suffix *mycloud.com*, your Azure Stack Hub Azure Resource Manager endpoint must change to *management.region.mycloud.com*. After you confirm your information, select **Next**.

    ![Screenshot showing Azure Stack Hub Cloud Information.][2]

1. On the next page:

   1. Select the connection method you wish to use - **Credential** or **Service Principal**
        - **Credential**
            - If you're using Microsoft Entra ID, enter the Microsoft Entra admin account, and password that you provided when you deployed Azure Stack Hub. Select **Connect**.
            - If you're using Active Directory Federation Services (AD FS), provide your admin account. For example, cloudadmin@azurestack.local. Enter your password, and then select **Connect**.
        - **Service Principal**
            - The service principal that you use **must** have **Owner** rights on the **Default Provider Subscription**
            - Provide the **Service Principal ID**, **Certificate File**, and **Password** and select **Connect**.

   1. In **Azure Stack Hub Subscriptions**, select the **Default Provider Subscription**.  Azure App Service on Azure Stack Hub **must** be deployed in the **Default Provider Subscription**.

   1. In the **Azure Stack Hub Locations**, select the location that corresponds to the region you're deploying to. For example, select **local** if you're deploying to the ASDK.

   1. If an existing App Service deployment is detected, then the resource group and storage account will be populated and greyed out.

   1. **NEW**: Administrators can specify a three character **Deployment Prefix** for the individual instances in each Virtual Machine Scale Set that are deployed.  This is useful if managing multiple Azure Stack Hub instances.

      ![Screenshot showing Azure App Service on Azure Stack Hub installation detected.][9]

1. In the next screen, you'll see the results of a status check performed against the App Service Resource Provider.  This status check has been added to verify the deployment is in the correct state to be upgraded.  The status check verifies that all roles are ready, all worker tiers are valid, all virtual machine scale sets are healthy and verifies access to the App Service secrets.

    ![Screenshot showing Azure App Service on Azure Stack Hub pre-upgrade status check.][10]

1. The Platform Image and SKU screen gives Administrators the opportunity to choose the correct [Windows 2022 Platform](azure-stack-app-service-before-you-get-started.md#download-items-from-the-azure-marketplace) image to be used to deploy the new role instances.
    1. **Select** the correct Platform Image
    1. Over time the minimum recommended spec of VM/VM Scale Set instance SKUs has changed and here you see the details of what is currently deployed and the new recommended SKU.

1. On the summary page:
   1. Verify the selections you made. To make changes, use the **Previous** buttons to visit previous pages.
   1. If the configurations are correct, select the check box.
   1. To start the upgrade, select **Next**.

       ![Screenshot showing Azure App Service on Azure Stack Hub upgrade summary.][4]

> [!NOTE]
> Upgrading to 2022.H1 can take a considerable amount of time dependent on the number of role instances deployed within the App Service on Azure Stack Hub Resource Provider deployment.
>

1. Upgrade progress page:
    1. Track the upgrade progress. The duration of the upgrade of App Service on Azure Stack Hub varies dependent on number of role instances deployed.
    1. After the upgrade successfully completes, select **Exit**.

        ![Screenshot showing Azure App Service on Azure Stack Hub upgrade progress.][5]

# [Previous Versions](#tab/previous)

1. Run appservice.exe as an administrator.

    ![Screenshot showing the Azure App Service on Azure Stack Hub installer.][6]

2. Select **Advanced** > **Complete offline installation or upgrade**.

    ![Screenshot showing the Azure App Service on Azure Stack Hub installer advanced options.][7]

3. Browse to the location of the offline upgrade package you previously created and then select **Next**.

4. Review and accept the Microsoft Software License Terms and then select **Next**.

5. Review and accept the third-party license terms and then select **Next**.

6. Make sure that the Azure Stack Hub Azure Resource Manager endpoint and Active Directory Tenant information is correct. If you used the default settings during Azure Stack Development Kit deployment, you can accept the default values here. However, if you customized the options when you deployed Azure Stack Hub, you must edit the values in this window. For example, if you use the domain suffix *mycloud.com*, your Azure Stack Hub Azure Resource Manager endpoint must change to *management.region.mycloud.com*. After you confirm your information, select **Next**.

    ![Screenshot showing the Azure Stack Hub Cloud information.][2]

7. On the next page:

   1. Select the connection method you wish to use - **Credential** or **Service Principal**
        - **Credential**
            - If you're using Microsoft Entra ID, enter the Microsoft Entra admin account, and password that you provided when you deployed Azure Stack Hub. Select **Connect**.
            - If you're using Active Directory Federation Services (AD FS), provide your admin account. For example, cloudadmin@azurestack.local. Enter your password, and then select **Connect**.
        - **Service Principal**
            - The service principal that you use **must** have **Owner** rights on the **Default Provider Subscription**
            - Provide the **Service Principal ID**, **Certificate File**, and **Password** and select **Connect**.

   1. In **Azure Stack Hub Subscriptions**, select the **Default Provider Subscription**.  Azure App Service on Azure Stack Hub **must** be deployed in the **Default Provider Subscription**.

   1. In the **Azure Stack Hub Locations**, select the location that corresponds to the region you're deploying to. For example, select **local** if you're deploying to the ASDK.

   1. If an existing App Service deployment is detected, then the resource group and storage account will be populated and greyed out.

      !Screenshot showing details of detected installation of Azure App Service on Azure Stack Hub.][3]
8. On the summary page:
   1. Verify the selections you made. To make changes, use the **Previous** buttons to visit previous pages.
   2. If the configurations are correct, select the check box.
   3. To start the upgrade, select **Next**.

       ![Screenshot showing Azure App Service on Azure Stack Hub upgrade summary.][4]

9. Upgrade progress page:
    1. Track the upgrade progress. The duration of the upgrade of App Service on Azure Stack Hub varies dependent on number of role instances deployed.
    2. After the upgrade successfully completes, select **Exit**.

        ![Screenshot of installer showing Azure App Service on Azure Stack Hub upgrade progress.][5]
::: zone-end

## Next steps

Prepare for other admin operations for Azure App Service on Azure Stack Hub:

* [Plan for extra capacity](azure-stack-app-service-capacity-planning.md)
* [Add extra capacity](azure-stack-app-service-add-worker-roles.md)

<!--Image references-->
[1]: ./media/azure-stack-app-service-update/app-service-installer.png
[2]: ./media/azure-stack-app-service-update/app-service-azure-stack-arm-endpoints.png
[3]: ./media/azure-stack-app-service-update/app-service-azure-stack-subscription-information.png
[4]: ./media/azure-stack-app-service-update/app-service-azure-stack-deployment-summary.png
[5]: ./media/azure-stack-app-service-update/app-service-upgrade-summary-complete.png

[6]: ./media/azure-stack-app-service-update/app-service-installer-exe.png
[7]: ./media/azure-stack-app-service-update/app-service-exe-advanced-create-package.png
[8]: ./media/azure-stack-app-service-update/app-service-exe-advanced-complete-offline.png
[9]: ./media/azure-stack-app-service-update/azure-app-service-22h1-upgrade-connection-details.png
[10]: ./media/azure-stack-app-service-update/azure-app-service-22h1-upgrade-farm-status-check.png
