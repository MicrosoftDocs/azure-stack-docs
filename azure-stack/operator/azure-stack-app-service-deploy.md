---
title: Deploy App Service in Azure Stack Hub 
description: Learn how to deploy App Service in Azure Stack Hub.
author: sethmanheim
ms.topic: install-set-up-deploy
ms.date: 06/26/2025
ms.author: anwestg
ms.reviewer: anwestg
ms.lastreviewed: 12/09/2021
zone_pivot_groups: 
ms.custom: sfi-image-nochange
# Intent: As an Azure Stack operator, I want to deploy App Service on Azure Stack.
# Keyword: deploy app service azure stack

---

# Deploy App Service in Azure Stack Hub

[!INCLUDE [Azure Stack hub update reminder](../includes/app-service-hub-update-banner.md)]

> [!IMPORTANT]
> Before you run the resource provider installer, you must complete the steps in [Before you get started](azure-stack-app-service-before-you-get-started.md)

In this article you learn how to deploy the [Azure App Service resource provider](azure-stack-app-service-overview.md) to an Azure Stack Hub environment that is:
- Connected or disconnected from the internet
- Secured by Entra ID or Active Directory Federation Services (AD FS).

To add the Azure App Service resource provider to your Azure Stack Hub deployment, you must complete these top-level tasks:

1. Complete the [prerequisite steps](azure-stack-app-service-before-you-get-started.md) (like purchasing certificates, which can take a few days to receive).
2. [Download and extract the installation and helper files](azure-stack-app-service-before-you-get-started.md).
3. Download the offline installation package.
4. Run the appservice.exe installer file.

## Complete the installation of Azure App Service on Azure Stack Hub

1. Run appservice.exe as an admin from a computer that can reach the Azure Stack Hub Admin Azure Resource Management endpoint.

1. Select **Advanced** > **Complete offline installation**.

    ![Complete offline installation in Azure App Service Installer][15]

1. Browse to the location of the offline installation package you previously downloaded, and then select **Next**.

    ![Specify offline installation package path im Azure App Service Installer][16]

1. Review and accept the Microsoft Software License Terms, and then select **Next**.

1. Review and accept the third-party license terms, and then select **Next**.

1. Make sure the Azure App Service cloud configuration info is correct. If you used the default settings during Azure Stack Development Kit deployment, you can accept the default values here. However, if you customized the options when you deployed Azure Stack Hub or are deploying on an integrated system, you must edit the values in this window to reflect those changes. For example, if you use the domain suffix mycloud.com, your Azure Stack Hub Tenant Azure Resource Manager endpoint must change to `management.<region>.mycloud.com`. After you confirm your info, select **Next**.

    ![Configure Azure App Service cloud in Azure App Service Installer][2]

1. On the next App Service Installer page you'll connect to your Azure Stack Hub:

    1. Select the connection method you wish to use - **Credential** or **Service Principal**
        - **Credential**
            - If you're using Microsoft Entra ID, enter the Microsoft Entra admin account and password that you provided when you deployed Azure Stack Hub. Select **Connect**.
            - If you're using Active Directory Federation Services (AD FS), provide your admin account. For example, cloudadmin@azurestack.local. Enter your password, and then select **Connect**.
        - **Service Principal**
            - The service principal that you use **must** have **Owner** rights on the **Default Provider Subscription**
            - Provide the **Service Principal ID**, **Certificate File**, and **Password** and select **Connect**.

    1. In **Azure Stack Hub Subscriptions**, select the **Default Provider Subscription**. Azure App Service on Azure Stack Hub **must** be deployed in the **Default Provider Subscription**.

    1. In the **Azure Stack Hub Locations**, select the location that corresponds to the region you're deploying to. For example, select **local** if you're deploying to the ASDK.

    1. Administrators can specify a three character **Deployment Prefix** for the individual instances in each Virtual Machine Scale Set that are deployed. The Deployment Prefix is useful if managing multiple Azure Stack Hub instances.

1. You can allow the Azure App Service installer to create a virtual network and associated subnets. Or, you can deploy into an existing virtual network, as configured through [these steps](azure-stack-app-service-before-you-get-started.md#virtual-network).
   - To use the Azure App Service installer method, select **Create VNet with default settings**, accept the defaults, and then select **Next**.
   - To deploy into an existing network, select **Use existing VNet and Subnets**, and then:
       1. Select the **Resource Group** option that contains your virtual network.
       2. Choose the **Virtual Network** name you want to deploy into.
       3. Select the correct **Subnet** values for each of the required role subnets.
       4. Select **Next**.

      ![Virtual network and subnet info in Azure App Service Installer][4]

1. Enter the info for your file share and then select **Next**. The address of the file share must use the Fully Qualified Domain Name (FQDN) or IP address of your file server. For example: \\\appservicefileserver.local.cloudapp.azurestack.external\websites, or \\\10.0.0.1\websites. If you're using a domain-joined file server, you must provide the full user name, including the domain. For example: `<myfileserverdomain>\<FileShareOwner>`.

    > [!NOTE]
    > The installer tries to test connectivity to the file share before proceeding. However, if you choose to deploy into an existing virtual network, the installer might be unable to connect to the file share and displays a warning asking whether you want to continue. Verify the file share info and continue if it's correct.

   ![File share info in Azure App Service Installer][5]

1. On the next page:
    1. In the **Identity Application ID** box, enter the GUID for the Identity application you created as part of the [prerequisites](azure-stack-app-service-before-you-get-started.md).
    1. In the **Identity Application certificate file** box, enter (or browse to) the location of the certificate file.
    1. In the **Identity Application certificate password** box, enter the password for the certificate. This password is the one that you made note of when you used the script to create the certificates.
    1. In the **Azure Resource Manager root certificate file** box, enter (or browse to) the location of the certificate file.
    1. Select **Next**.

    ![Enter app ID and certificate info in Azure App Service Installer][6]

1. For each of the three certificate file boxes, select **Browse** and navigate to the appropriate certificate file. You must provide the password for each certificate. These certificates are the ones that you created in [Prerequisites for deploying App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md). Select **Next** after entering all the information.

    | Box | Certificate file name example |
    | --- | --- |
    | **App Service default SSL certificate file** | \_.appservice.local.AzureStack.external.pfx |
    | **App Service API SSL certificate file** | api.appservice.local.AzureStack.external.pfx |
    | **App Service Publisher SSL certificate file** | ftp.appservice.local.AzureStack.external.pfx |

    If you used a different domain suffix when you created the certificates, your certificate file names don't use *local.AzureStack.external*. Instead, use your custom domain info.

    ![Enter SSL certificate info in Azure App Service Installer][7]

1. Enter the SQL Server details for the server instance used to host the Azure App Service resource provider databases, and then select **Next**. The installer validates the SQL connection properties. You **must** enter either the internal IP or the FQDN for the SQL Server name.

    > [!NOTE]
    > The installer tries to test connectivity to the computer running SQL Server  before proceeding. However, if you chose to deploy into an existing virtual network, the installer might not be able to connect to the computer running SQL Server and displays a warning asking whether you want to continue. Verify the SQL Server info and continue if it's correct.
    >
    > From Azure App Service on Azure Stack Hub 1.3 onward, the installer checks that the computer running SQL Server has database containment enabled at the SQL Server level. If it doesn't, you're prompted with the following exception:
    > ```sql
    >    Enable contained database authentication for SQL server by running below command on SQL server (Ctrl+C to copy)
    >    ***********************************************************
    >    sp_configure 'contained database authentication', 1;
    >    GO
    >    RECONFIGURE;
    >    GO
    >    ***********************************************************
    > ```

    ![Enter SQL Server info in Azure App Service Installer][8]

1. Review the role instance and SKU options. The defaults populate with the minimum number of instances and the minimum SKU for each role in a production deployment. For ASDK deployment, you can scale the instances down to lower SKUs to reduce the core and memory commit but you'll experience a performance degradation. A summary of vCPU and memory requirements is provided to help plan your deployment. After you make your selections, select **Next**.

     > [!NOTE]
     > For production deployments, follow the guidance in [Capacity planning for Azure App Service server roles in Azure Stack Hub](azure-stack-app-service-capacity-planning.md).
     >
     >

    
    | Role | Minimum instances | Minimum SKU | Notes |
    | --- | --- | --- | --- |
    | Controller | 2 | Standard_A4_v2 - (4 cores, 8192 MB) | Manages and maintains the health of the App Service cloud. |
    | Management | 1 | Standard_D3_v2 - (4 cores, 14336 MB) | Manages the App Service Azure Resource Manager and API endpoints, portal extensions (admin, tenant, Functions portal), and the data service. To support failover, increase the recommended instances to 2. |
    | Publisher | 1 | Standard_A2_v2 - (2 cores, 4096 MB) | Publishes content via FTP and web deployment. |
    | FrontEnd | 1 | Standard_A4_v2 - (4 cores, 8192 MB) | Routes requests to App Service apps. |
    | Shared Worker | 1 | Standard_A4_v2 - (4 cores, 8192 MB) | Hosts web or API apps and Azure Functions apps. You might want to add more instances. As an operator, you can define your offering and choose any SKU tier. The tiers must have a minimum of one vCPU. |

    ![Set role tiers and SKU options in Azure App Service Installer][9]

1. In the **Select Platform Image** box, choose your prepared Windows Server 2022 Datacenter virtual machine (VM) image from the images available on the compute resource provider for the Azure App Service cloud. Select **Next**.

    > [!NOTE]
    > Windows Server 2022 Core is *not* a supported platform image for use with Azure App Service on Azure Stack Hub. Don't use evaluation images for production deployments. Azure App Service on Azure Stack Hub requires that Microsoft .NET 3.5.1 SP1 is activated on the image used for deployment. Marketplace-syndicated Windows Server 2022 images don't have this feature enabled. Therefore, when deploying in offline environments, you must create and use a Windows Server 2022 image with this feature pre-enabled.
    >
    > See [Prerequisites for deploying App Service on Azure Stack Hub](azure-stack-app-service-before-you-get-started.md?tabs=2022H1-connected%2C2022H1-disconnected&pivots=state-disconnected#tabpanel_2_2022H1-disconnected) for details on creating a custom image and adding to Marketplace. Be sure to specify the following when adding the image to Marketplace:
    >
    >- Publisher = MicrosoftWindowsServer
    >- Offer = WindowsServer
    >- SKU = AppService
    >- Version = Specify the "latest" version

1. On the next page:
     1. Enter the Worker Role VM admin user name and password.
     2. Enter the Other Roles VM admin  user name and password.
     3. Select **Next**.

    ![Enter role VM admins in Azure App Service Installer][10]

1. On the summary page:
    1. Verify the selections you made. To make changes, use the **Previous** buttons to visit previous pages.
    2. If the configurations are correct, select the check box.
    3. To start the deployment, select **Next**.

    ![Summary of selections made in Azure App Service Installer][11]

1. On the next page:
    1. Track the installation progress. App Service on Azure Stack Hub can take up to 240 minutes to deploy based on the default selections and age of the base Windows 2016 Datacenter image.

    2. After the installer finishes running, select **Exit**.

    ![Track installation process in Azure App Service Installer][12]

## Post-deployment steps

> [!IMPORTANT]
> If you've provided the Azure App Service Resource Provider with a SQL Always On Instance, you **must** [add the appservice_hosting and appservice_metering databases to an availability group](/sql/database-engine/availability-groups/windows/availability-group-add-a-database). You must also synchronize the databases to prevent any loss of service in the event of a database failover.

If you chose to deploy into an existing virtual network and use an internal IP address to connect to your file server, you must add an outbound security rule, enabling SMB traffic between the worker subnet and the file server. In the administrator portal, go to the WorkersNsg Network Security Group and add an outbound security rule with the following properties:

- Source: Any
- Source port range: *
- Destination: IP addresses
- Destination IP address range: Range of IPs for your file server
- Destination port range: 445
- Protocol: TCP
- Action: Allow
- Priority: 700
- Name: Outbound_Allow_SMB445

To remove latency when workers are communicating with the file server we also advise adding the following rule to the Worker Network Security Group to allow outbound LDAP and Kerberos traffic to your Active Directory Controllers if securing the file server using Active Directory, for example if you have used the Quickstart template to deploy a HA File Server and SQL Server.

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

## Validate the Azure App Service on Azure Stack Hub installation

1. In the Azure Stack Hub administrator portal, go to **Administration - App Service**.

1. In the overview, under status, check to see that the **Status** displays **All roles are ready**.

    ![Overview in Azure App Service Administration](media/azure-stack-app-service-deploy/image12.png)

## Test drive Azure App Service on Azure Stack Hub

After you deploy and register the Azure App Service resource provider, test it to make sure that users can deploy web and API apps.

> [!NOTE]
> You must create an offer that has the Microsoft.Web namespace within the plan. Then, you need to have a tenant subscription that subscribes to this offer. For more info, see [Create offer](azure-stack-create-offer.md) and [Create plan](azure-stack-create-plan.md).
>
> You *must* have a tenant subscription to create apps that use Azure App Service on Azure Stack Hub. The only capabilities that a service admin can complete within the administrator portal are related to the resource provider administration of Azure App Service. These capabilities include adding capacity, configuring deployment sources, and adding Worker tiers and SKUs.
>
> As of the third technical preview, to create web, API, and Azure Functions apps, you must use the user portal and have a tenant subscription.

1. In the Azure Stack Hub user portal, select **+ Create a resource** > **Web + Mobile** > **Web App**.

1. On the **Web App** blade, type a name in the **Web app** box.

1. Under **Resource Group**, select **New**. Type a name in the **Resource Group** box.

1. Select **App Service plan/Location** > **Create New**.

1. On the **App Service plan** blade, type a name in the **App Service plan** box.

1. Select **Pricing tier** > **Free-Shared** or **Shared-Shared** > **Select** > **OK** > **Create**.

1. In less than a minute, a tile for the new web app appears on the dashboard. Select the tile.

1. On the **Web App** blade, select **Browse** to view the default website for this app.

## Deploy a WordPress, DNN, or Django website (optional)

1. In the Azure Stack Hub user portal, select **+**, go to Azure Marketplace, deploy a Django website, and wait for successful completion. The Django web platform uses a file system-based database. It doesn't require any other resource providers, such as SQL or MySQL.

1. If you also deployed a MySQL resource provider, you can deploy a WordPress website from Azure Marketplace. When you're prompted for database parameters, enter the user name as *User1\@Server1*, with the user name and server name of your choice.

1. If you also deployed a SQL Server resource provider, you can deploy a DNN website from Azure Marketplace. When you're prompted for database parameters, choose a database on the computer running SQL Server that's connected to your resource provider.

## Next steps

Prepare for other admin operations for App Service on Azure Stack Hub:

- [Capacity Planning](azure-stack-app-service-capacity-planning.md)
- [Configure Deployment Sources](azure-stack-app-service-configure-deployment-sources.md)

<!-- Connected image references-->
[1]: ./media/azure-stack-app-service-deploy/app-service-installer.png
[2]: ./media/azure-stack-app-service-deploy/app-service-azure-stack-arm-endpoints.png
[3]: ./media/azure-stack-app-service-deploy/app-service-azure-stack-subscription-information.png
[4]: ./media/azure-stack-app-service-deploy/app-service-default-VNET-config.png
[5]: ./media/azure-stack-app-service-deploy/app-service-fileshare-configuration.png
[6]: ./media/azure-stack-app-service-deploy/app-service-identity-app.png
[7]: ./media/azure-stack-app-service-deploy/app-service-certificates.png
[8]: ./media/azure-stack-app-service-deploy/app-service-sql-configuration.png
[9]: ./media/azure-stack-app-service-deploy/app-service-cloud-quantities.png
[10]: ./media/azure-stack-app-service-deploy/app-service-role-credentials.png
[11]: ./media/azure-stack-app-service-deploy/app-service-azure-stack-deployment-summary.png
[12]: ./media/azure-stack-app-service-deploy/app-service-deployment-progress.png
[13]: ./media/azure-stack-app-service-deploy/app-service-azure-stack-subscription-information-2022h1.png

<!-- Disconnected image references-->
[13]: ./media/azure-stack-app-service-deploy/app-service-exe-advanced-create-package.png
[14]: ./media/azure-stack-app-service-deploy/app-service-exe-advanced-create-package-complete.png
[15]: ./media/azure-stack-app-service-deploy/app-service-exe-advanced-complete-offline.png
[16]: ./media/azure-stack-app-service-deploy/app-service-exe-advanced-complete-offline-package-browse.png
