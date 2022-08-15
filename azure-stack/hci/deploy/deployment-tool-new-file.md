---
title: Deploy Azure Stack HCI version 22H2 using using a new config file
description: Learn how to deploy Azure Stack HCI version 22H2 using a new config file
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Deploy Azure Stack HCI version 22H2

> Applies to: Azure Stack HCI, version 22H2 (preview)

After you have successfully installed the operating system, you ready to set up and run the deployment tool. This method of deployment uses Windows Admin Center to create a configuration (answer) file that is saved. The deployment tool can be thought of as the new Create Cluster wizard.

> [!NOTE]
> Only the first (staging) server requires the deployment tool to be installed and set up on.

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
> Deploying a single-node cluster can only be done [using PowerShell](deployment-tool-powershell.md) or using an existing configuration file in this preview release.

1. Open a web browser from a computer that has network connectivity to the staging server.

1. In the URL field, enter *https://* followed by the IP address of your staging server.

1. Accept the security warning displayed by your browser - this is shown because we’re using a self-signed certificate.

1. Authenticate using the local administrator credentials of your staging server.

1. In Windows Admin Center, on the **Get started deploying Azure Stack** page, select **Create a new config file**

      :::image type="content" source="media/deployment-tool/deployment-wizard-1.png" alt-text="Deployment wizard step 1" lightbox="media/deployment-tool/deployment-wizard-1.png":::

1. On step **1.1 Configure privacy**, set the privacy settings as they apply to your organization.

    :::image type="content" source="media/deployment-tool/deployment-wizard-2.png" alt-text="Deployment wizard step 2" lightbox="media/deployment-tool/deployment-wizard-2.png":::

1. On **step 1.2 Add servers**, enter the IP address of each server.  Add the servers in the right sequence, beginning with the first server.

    :::image type="content" source="media/deployment-tool/deployment-wizard-3.png" alt-text="Deployment wizard step 3" lightbox="media/deployment-tool/deployment-wizard-3.png":::

1. On Step **1.3 Set cluster security**, no changes are needed. Select **Next** to continue.

    :::image type="content" source="media/deployment-tool/deployment-wizard-4.png" alt-text="Deployment wizard step 4" lightbox="media/deployment-tool/deployment-wizard-4.png":::

1. On step **1.4 Configure the internal domain**, specify the settings used by the internal domain used for cluster authentication and management. When specifying a username, omit the domain name (don't use *domain\username*). The "Administrator" username isn’t supported.

    :::image type="content" source="media/deployment-tool/deployment-wizard-5.png" alt-text="Deployment wizard step 5" lightbox="media/deployment-tool/deployment-wizard-5.png":::

1. On step **2 Networking**, consult with your network administrator to ensure you enter the correct network details. When defining the network intents, for this preview release, only the following two sets of network intents are supported:
    - one management+compute intent, 1 storage intent
    - one fully converged intent  (management+compute+storage intent)

1. On step **3.1 Create cluster**, enter the cluster name.

    :::image type="content" source="media/deployment-tool/deployment-wizard-6.png" alt-text="Deployment wizard step 6" lightbox="media/deployment-tool/deployment-wizard-6.png":::

1. On step **4.1 Set up cluster storage**, select **Set up with empty drives**.

    :::image type="content" source="media/deployment-tool/deployment-wizard-7.png" alt-text="Deployment wizard step 7" lightbox="media/deployment-tool/deployment-wizard-7.png":::

1. On step **5.1 Add services**, no changes are needed. Select **Next** to continue.

    :::image type="content" source="media/deployment-tool/deployment-wizard-8.png" alt-text="Deployment wizard step 8" lightbox="media/deployment-tool/deployment-wizard-8.png":::

1. On step **5.2 Set Arc management details**, no changes are needed. Select **Next** to continue.

    :::image type="content" source="media/deployment-tool/deployment-wizard-9.png" alt-text="Deployment wizard step 9" lightbox="media/deployment-tool/deployment-wizard-9.png":::

1. On step **6.1 Deploy the cluster**, select **Download the config file for your deployment**, and then select **Deploy to start the deployment**.

    > [!IMPORTANT]
    > The staging server will restart shortly after the deployment starts.

    :::image type="content" source="media/deployment-tool/deployment-wizard-10.png" alt-text="Deployment wizard step 10" lightbox="media/deployment-tool/deployment-wizard-10.png":::

1. To monitor your deployment, log in to the staging server and watch the orchestration engine process. Due to a known issue, you must monitor the deployment progress using the deployment log file stored in *C:\clouddeployment\logs* until the staging server restarts.

    :::image type="content" source="media/deployment-tool/monitor-deployment.png" alt-text="Monitor-deployment" lightbox="media/deployment-tool/monitor-deployment.png":::

1. Remove the Windows Admin Center instance that the deployment tool used. Log in to the staging server and run the following command:

    ```powershell
    Get-CimInstance -ClassName Win32_Product|Where-object {$_name -like “Windows Admin Center”}| Invoke-CimMethod -MethodName Uninstall
    ```

Congratulations, you have deployed Azure Stack HCI, version 22H2 Preview.

## Next step

If needed, [troubleshoot deployment](deployment-tool-troubleshooting.md).