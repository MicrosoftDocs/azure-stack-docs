---
title: Deploy Azure Stack HCI version 22H2 (preview) interactively
description: Learn how to deploy Azure Stack HCI version 22H2 (preview) interactively using a new configuration file
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Deploy Azure Stack HCI version 22H2 (preview) interactively

> Applies to: Azure Stack HCI, version 22H2 (preview)

After you have successfully installed the operating system, you are ready to set up and run the deployment tool. This method of deployment uses Windows Admin Center interactively to create a configuration (answer) file that is saved. The deployment tool provides an interactive, guided experience that helps you deploy and register the cluster.

> [!IMPORTANT]
 > Please review the [Terms of Use](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) and agree to the terms before you deploy this solution.

## Prerequisites

Before you begin, make sure you have done the following:

- Read the [prerequisites for Azure Stack HCI version 22H2](deployment-tool-prerequisites.md).
- From a local VHDX file, [install Azure Stack HCI version 22H2](deployment-tool-install-os.md) on each server.

<!---## Configure the servers

After you have installed the Azure Stack HCI version 22H2 OS, there are a couple of steps needed to configure your servers before using the deployment tool.

1. Sign in to the first server. In Windows Admin Center, select **Azure Stack HCI Initial Configuration** from the top drop-down menu.

1. On the **Update local password** page, enter the old password and new chosen password for the server.

    :::image type="content" source="media/deployment-tool/deployment-post-update-password.png" alt-text="Update local password page" lightbox="media/deployment-tool/deployment-post-update-password.png":::

1. On the **Set IP address** page, select either dynamic (DHCP) or a static IP address for the server.

    :::image type="content" source="media/deployment-tool/deployment-post-set-ip-address.png" alt-text="Set IP address page" lightbox="media/deployment-tool/deployment-post-set-ip-address.png":::

1. On the **Review summary** page, review the settings of the server.

    :::image type="content" source="media/deployment-tool/deployment-post-review-summary.png" alt-text="Review summary page" lightbox="media/deployment-tool/deployment-post-review-summary.png":::

1. Repeat this process for each server in your cluster.--->

## Set up the deployment tool

> [!NOTE]
> You need to install and set up the deployment tool only on the first server in the cluster.

The Azure Stack HCI version 22H2 preview deployment tool requires the following parameters to run:

|Parameters|Description|
|----|----|
|`-RegistrationCloudName`|Specify the Azure Cloud that should be used.|
|`-RegistrationSubscriptionID`|Provide the Azure Subscription ID used to register the cluster with Arc. Make sure that you are a [user access administrator](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#user-access-administrator) on this subscription. This will allow you to manage access to Azure resources, specifically to Arc-enable each server of an Azure Stack HCI cluster.|
|`-RegistrationAccountCredential`|Specify credentials to access your Azure Subscription. **Note**: This preview release does not support Multi-factor Authentication (MFA) or admin consent.|

1. In Windows Admin Center, select the first server listed for the cluster to act as a staging server during deployment.

1. Log on to the staging server using local administrative credentials.

1. Copy content from the *Cloud* folder you downloaded previously to any drive other than the C:\ drive.

1. Enter your Azure subscription ID, AzureCloud name and run the following PowerShell commands from an administrative prompt:

    ```PowerShell
    $SubscriptionID="your_subscription_ID"
    $AzureCred=get-credential
    $AzureCloud="AzureCloud"
    ```

1. Run the following command to install the deployment tool:

   ```PowerShell
    .\BootstrapCloudDeploymentTool.ps1 -RegistrationCloudName $AzureCloud -RegistrationSubscriptionID $SubscriptionID         -RegistrationAccountCredential $AzureCred
    ```

    This step takes several minutes to complete.

    > [!NOTE]
    > If you manually extracted deployment content from the ZIP file previously, you must run `BootstrapCloudDeployment-Internal.ps1` instead.

## Run the deployment tool

This procedure collects deployment parameters from you and saves them to a configuration file as you step through the wizard.

If you want to use an existing configuration file you have previously created, see [Deploy using a configuration file](deployment-tool-existing-file.md).

For more information on the custom security settings you can specify, see **ADD Security Docs LINK**.

1. Open a web browser from a computer that has network connectivity to the staging server.

1. In the URL field, enter *https://your_staging-server-IP-address*.

1. Accept the security warning displayed by your browser - this is shown because we’re using a self-signed certificate.

1. Authenticate using the local administrator credentials of your staging server.

1. In Windows Admin Center, on the **Get started deploying Azure Stack** page, select **Create a new config file**, then select either **One server** or **Multiple servers**.

      :::image type="content" source="media/deployment-tool/deploy-new-get-started.png" alt-text="Deployment Get Started page" lightbox="media/deployment-tool/deploy-new-get-started.png":::

1. On step **1.1 Configure privacy**, set the privacy settings as they apply to your organization.

    :::image type="content" source="media/deployment-tool/deploy-new-step-1.1-privacy.png" alt-text="Deployment step 1.1" lightbox="media/deployment-tool/deploy-new-step-1.1-privacy.png":::

1. On **step 1.2 Add servers**, enter the IP address of each server.  Add the servers in the right sequence, beginning with the first server.

    :::image type="content" source="media/deployment-tool/deploy-new-step-1.2-add-servers.png" alt-text="Deployment step 1.2" lightbox="media/deployment-tool/deploy-new-step-1.2-add-servers.png":::

1. On **step 1.3 Join a domain**, enter your Active Directory domain name, object profile, organizational unit (OU), account credentials, and NTP time server.

    :::image type="content" source="media/deployment-tool/deploy-new-step-1.3-join-domain.png" alt-text="Deployment step 1.3" lightbox="media/deployment-tool/deploy-new-step-1.3-join-domain.png":::

1. On Step **1.4 Set cluster security**, select **Recommended security settings** to use the recommended default settings:

    :::image type="content" source="media/deployment-tool/deploy-new-step-1.4-security-default.png" alt-text="Deployment step 1.4 default" lightbox="media/deployment-tool/deploy-new-step-1.4-security-default.png":::

    or select **Customized security settings:**

    :::image type="content" source="media/deployment-tool/deploy-new-step-1.4-security-custom.png" alt-text="Deployment step 1.4 custom" lightbox="media/deployment-tool/deploy-new-step-1.4-security-custom.png":::

1. On step **2 Networking**, consult with your network administrator to ensure you enter the correct network details. When defining the network intents, for this preview release, only the following two sets of network intents are supported. The networking intent should match how you have cabled your system.
    - one management+compute intent, 1 storage intent
    - one fully converged intent  (management+compute+storage intent)

1. On step **2.1 Check network adapters**, consult with your network administrator to ensure you enter the correct network details.

    :::image type="content" source="media/deployment-tool/deploy-new-step-2.1-network-adapters.png" alt-text="Deployment step 2.1" lightbox="media/deployment-tool/deploy-new-step-2.1-network-adapters.png":::

1. On step **2.2 Define network intents**, consult with your network administrator to ensure you enter the correct network details.

    :::image type="content" source="media/deployment-tool/deploy-new-step-2.2-network-intents.png" alt-text="Deployment step 2.2" lightbox="media/deployment-tool/deploy-new-step-2.2-network-intents.png":::

1. On step **2.3 Provide storage network details**, consult with your network administrator to ensure you enter the correct network details.

    :::image type="content" source="media/deployment-tool/deploy-new-step-2.3-network-storage.png" alt-text="Deployment step 2.3" lightbox="media/deployment-tool/deploy-new-step-2.3-network-storage.png":::

1. On step **2.4 Provide management network details**, consult with your network administrator to ensure you enter the correct network details.

    :::image type="content" source="media/deployment-tool/deploy-new-step-2.4-network-management.png" alt-text="Deployment step 2.4" lightbox="media/deployment-tool/deploy-new-step-2.4-network-management.png":::

1. On step **3.1 Create cluster**, enter the cluster name.

    :::image type="content" source="media/deployment-tool/deploy-new-step-3.1-create-cluster.png" alt-text="Deployment step 3.1" lightbox="media/deployment-tool/deploy-new-step-3.1-create-cluster.png":::

1. On step **4.1 Set up cluster storage**, select **Set up with empty drives**.

    :::image type="content" source="media/deployment-tool/deploy-new-step-4.1-storage.png" alt-text="Deployment step 4.1" lightbox="media/deployment-tool/deploy-new-step-4.1-storage.png":::

1. On step **5.1 Add services**, no changes are needed. Select **Next** to continue.

    :::image type="content" source="media/deployment-tool/deployment-step-5.1-add-services.png" alt-text="Deployment step 5.1" lightbox="media/deployment-tool/deployment-step-5.1-add-services.png":::

1. On step **5.2 Set Arc management details**, no changes are needed. Select **Next** to continue.

    :::image type="content" source="media/deployment-tool/deploy-new-step-5.2-arc.png" alt-text="Deployment step 5.2" lightbox="media/deployment-tool/deploy-new-step-5.2-arc.png":::

1. On step **6.1 Deploy the cluster**, select **Download the config file for your deployment**, and then select **Deploy to start the deployment**.

    > [!IMPORTANT]
    > The staging server will restart after the deployment starts.

    :::image type="content" source="media/deployment-tool/deployment-step-6.1-deploy-cluster.png" alt-text="Deployment step 6.1" lightbox="media/deployment-tool/deployment-step-6.1-deploy-cluster.png":::

1. It can take up to 3 hours for deployment to complete. You can monitor your deployment progress in near realtime.

    :::image type="content" source="media/deployment-tool/deployment-progress.png" alt-text="Monitor-deployment" lightbox="media/deployment-tool/deployment-progress.png":::

## Post deployment

After deployment of your cluster has successfully completed, remove the Windows Admin Center instance that the deployment tool used. Log in to the staging server and run the following Powershell command:

```powershell
Get-CimInstance -ClassName Win32_Product|Where-object {$_name -like “Windows Admin Center”}| Invoke-CimMethod -MethodName Uninstall
 ```

## Next step

If needed, [troubleshoot deployment](deployment-tool-troubleshooting.md).