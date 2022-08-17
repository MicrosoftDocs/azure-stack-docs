---
title: Deploy Azure Stack HCI version 22H2 (preview) using a new config file
description: Learn how to deploy Azure Stack HCI version 22H2 (preview) using a new config file
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Deploy Azure Stack HCI version 22H2

> Applies to: Azure Stack HCI, version 22H2 (preview)

After you have successfully installed the operating system, you are ready to set up and run the deployment tool. This method of deployment uses Windows Admin Center to create a configuration (answer) file that is saved. The deployment tool provides an interactive, guided experience that helps you deploy and register the cluster.

> [!NOTE]
> Install and set up the deployment tool only on the first server in the cluster.

## Set up the deployment tool

The Azure Stack HCI version 22H2 preview deployment tool requires the following parameters to run:

|Parameters|Description|
|----|----|
|`-RegistrationCloudName`|Specify the Azure Cloud that should be used.|
|`-RegistrationSubscriptionID`|Provide the Azure Subscription ID used to register the cluster with Arc. Make sure that you are a [user access administrator](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#user-access-administrator) on this subscription. This will allow you to manage access to Azure resources, specifically to Arc-enable each server of an Azure Stack HCI cluster.|
|`-RegistrationAccountCredential`|Specify credentials to access your Azure Subscription. **Note**: This preview release does not support Multi-factor Authentication (MFA) or admin consent.|

1. In Windows Admin Center, select the first server listed for the cluster to act as a staging server during deployment.

1. Log on to the staging server using local administrative credentials.

1. Copy content from the *Cloud* folder you downloaded previously to any drive other than the C:\ drive.

1. Enter your Azure subscription ID, AzureCloud name and run the following PowerShell commands:

    ```PowerShell
    $SubscriptionID="your_subscription_ID"
    $AzureCred=get-credential
    $AzureCloud="AzureCloud"
    ```

1. Run the following command to launch the deployment tool:

   ```PowerShell
    .\BootstrapCloudDeploymentTool.ps1 -RegistrationCloudName $AzureCloud -RegistrationSubscriptionID $SubscriptionID         -RegistrationAccountCredential $AzureCred
    ```

    This step takes several minutes to complete.

    > [!NOTE]
    > If you manually extracted deployment content from the ZIP file previously, you must run `BootstrapCloudDeployment-Internal.ps1` instead.

## Run the deployment tool

The deployment tool "hooks" into, and displays additional pages in Windows Admin Center.

This procedure collects deployment parameters and saves them to a configuration file as you step through the wizard.

If you want to use an existing configuration file you have previously created, see [Deploy using a configuration file](deployment-tool-existing-file.md).

> [!NOTE]
> In this release, you can deploy a single-server cluster only by [using PowerShell](deployment-tool-powershell.md) or by an existing configuration file.

1. Open a web browser from a computer that has network connectivity to the staging server.

1. In the URL field, enter *https://your_staging-server-IP-address*.

1. Accept the security warning displayed by your browser - this is shown because we’re using a self-signed certificate.

1. Authenticate using the local administrator credentials of your staging server.

1. In Windows Admin Center, on the **Get started deploying Azure Stack** page, select **Create a new config file**, then select either **One server** or **Multiple servers**.

      :::image type="content" source="media/deployment-tool/deployment-get-started.png" alt-text="Deployment Get Started page" lightbox="media/deployment-tool/deployment-get-started.png":::

1. On step **1.1 Configure privacy**, set the privacy settings as they apply to your organization.

    :::image type="content" source="media/deployment-tool/deployment-step-1.1-set-privacy.png" alt-text="Deployment step 1.1" lightbox="media/deployment-tool/deployment-step-1.1-set-privacy.png":::

1. On **step 1.2 Add servers**, enter the IP address of each server.  Add the servers in the right sequence, beginning with the first server.

    :::image type="content" source="media/deployment-tool/deployment-step-1.2-add-servers.png" alt-text="Deployment step 1.2" lightbox="media/deployment-tool/deployment-step-1.2-add-servers.png":::

1. On **step 1.3 Join a domain**, enter the IP address of each server.  Add the servers in the right sequence, beginning with the first server.

    :::image type="content" source="media/deployment-tool/deployment-step-1.3-join-domain.png" alt-text="Deployment step 1.3" lightbox="media/deployment-tool/deployment-step-1.3-join-domain.png":::

1. On Step **1.4 Set cluster security**, select **Recommended security settings** to use the recommended default settings:

    :::image type="content" source="media/deployment-tool/deployment-step-1.4-cluster-security-default.png" alt-text="Deployment step 1.4 default" lightbox="media/deployment-tool/deployment-step-1.4-cluster-security-default.png":::

    or select **Customized security settings:**

    :::image type="content" source="media/deployment-tool/deployment-step-1.4-cluster-security-custom.png" alt-text="Deployment step 1.4 custom" lightbox="media/deployment-tool/deployment-step-1.4-cluster-security-custom.png":::

1. On step **1.4 Configure the internal domain**, specify the settings used by the internal domain used for cluster authentication and management. When specifying a username, omit the domain name (don't use *domain\username*). The "Administrator" username isn’t supported.

    :::image type="content" source="media/deployment-tool/deployment-wizard-5.png" alt-text="Deployment step 1.4" lightbox="media/deployment-tool/deployment-wizard-5.png":::

1. On step **2 Networking**, consult with your network administrator to ensure you enter the correct network details. When defining the network intents, for this preview release, only the following two sets of network intents are supported. The networking intent should match how you have cabled your system.
    - one management+compute intent, 1 storage intent
    - one fully converged intent  (management+compute+storage intent)

1. On step **2.1 Check network adapters**, consult with your network administrator to ensure you enter the correct network details.

    :::image type="content" source="media/deployment-tool/deployment-step-2.1-network-adapters.png" alt-text="Deployment step 2.1" lightbox="media/deployment-tool/deployment-step-2.1-network-adapters.png":::

1. On step **2.2 Define network intents**, consult with your network administrator to ensure you enter the correct network details.

    :::image type="content" source="media/deployment-tool/deployment-step-2.2-network-intents.png" alt-text="Deployment step 2.2" lightbox="media/deployment-tool/deployment-step-2.2-network-intents.png":::

1. On step **2.3 Provide storage network details**, consult with your network administrator to ensure you enter the correct network details.

    :::image type="content" source="media/deployment-tool/deployment-steps-2.3-storage-network.png" alt-text="Deployment step 2.3" lightbox="media/deployment-tool/deployment-steps-2.3-storage-network.png":::

1. On step **2.4 Provide management network details**, consult with your network administrator to ensure you enter the correct network details.

    :::image type="content" source="media/deployment-tool/deployment-step-2.4-management-network.png" alt-text="Deployment step 2.4" lightbox="media/deployment-tool/deployment-step-2.4-management-network.png":::

1. On step **3.1 Create cluster**, enter the cluster name.

    :::image type="content" source="media/deployment-tool/deployment-step-3.1-create-cluster.png" alt-text="Deployment step 3.1" lightbox="media/deployment-tool/deployment-step-3.1-create-cluster.png":::

1. On step **4.1 Set up cluster storage**, select **Set up with empty drives**.

    :::image type="content" source="media/deployment-tool/deployment-step-4.1-set-storage.png" alt-text="Deployment step 4.1" lightbox="media/deployment-tool/deployment-step-4.1-set-storage.png":::

1. On step **5.1 Add services**, no changes are needed. Select **Next** to continue.

    :::image type="content" source="media/deployment-tool/deployment-step-5.1-add-services.png" alt-text="Deployment step 5.1" lightbox="media/deployment-tool/deployment-step-5.1-add-services.png":::

1. On step **5.2 Set Arc management details**, no changes are needed. Select **Next** to continue.

    :::image type="content" source="media/deployment-tool/deployment-step-5.2-set-arc.png" alt-text="Deployment step 5.2" lightbox="media/deployment-tool/deployment-step-5.2-set-arc.png":::

1. On step **6.1 Deploy the cluster**, select **Download the config file for your deployment**, and then select **Deploy to start the deployment**.

    > [!IMPORTANT]
    > The staging server will restart after the deployment starts.

    :::image type="content" source="media/deployment-tool/deployment-step-6.1-deploy-cluster.png" alt-text="Deployment step 6.1" lightbox="media/deployment-tool/deployment-step-6.1-deploy-cluster.png":::

1. It can take up to 3 hours for deployment to complete. To monitor your deployment, log in to the staging server and watch the orchestration engine process. Due to a known issue, you must monitor the deployment progress using the deployment log file stored in *C:\clouddeployment\logs* until the staging server restarts.

    :::image type="content" source="media/deployment-tool/deployment-monitoring.png" alt-text="Monitor-deployment" lightbox="media/deployment-tool/deployment-monitoring.png":::

## Post deployment

Some tasks after deployment has finished:

1. Remove the Windows Admin Center instance that the deployment tool used. Log in to the staging server and run the following command:

    ```powershell
    Get-CimInstance -ClassName Win32_Product|Where-object {$_name -like “Windows Admin Center”}| Invoke-CimMethod -MethodName Uninstall
    ```

1. On the **Update local password** page, enter

    :::image type="content" source="media/deployment-tool/deployment-post-update-password.png" alt-text="Monitor-deployment" lightbox="media/deployment-post-update-password.png":::

1. On the **Set IP address** page, enter

    :::image type="content" source="media/deployment-tool/deployment-post-set-ip-address.png" alt-text="Monitor-deployment" lightbox="media/deployment-post-set-ip-address.png":::

1. On the **Review summary** page, enter

    :::image type="content" source="media/deployment-tool/deployment-post-review-summary.png" alt-text="Monitor-deployment" lightbox="media/deployment-post-review-summary.png":::

## Next step

If needed, [troubleshoot deployment](deployment-tool-troubleshooting.md).