---
title: Configurator App for Azure Local to Register Machines (Preview)
description: Learn how to use the Configurator app to bootstrap and quickly register your Azure Local machines with Azure Arc. (Preview)
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 05/29/2025
ms.service: azure-local
#CustomerIntent: As an IT Pro, I want to bootstrap and Arc register Azure Local machines via the Arc registration script.
---

# Register your Azure Local machines via the Configurator app (Preview)

> Applies to: Azure Local 2502 and later

This article explains how to use the Configurator app to quickly bootstrap and register machines in your Azure Local instance, enabling seamless Azure Arc integration.

You can use the Configurator app or [Azure CLI](./deployment-arc-register-server-permissions.md) to register your machines. If you plan to deploy a few machines per site, use the Configurator app.

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that you complete the following prerequisites:

### Azure Local machine prerequisites

[!INCLUDE [hci-registration-azure-local-machine-prerequisites](../includes/hci-registration-azure-local-machine-prerequisites.md)]

- Download the [Configurator App for Azure Local](https://aka.ms/ConfiguratorAppForHCI).

- Note down:

   - The serial number for each machine.
   - Local administrator credentials to sign into each machine.

### Azure prerequisites

[!INCLUDE [hci-registration-azure-prerequisites](../includes/hci-registration-azure-prerequisites.md)]

- **Get Arc gateway ID**. Skip this step if you didn't set up Azure Arc gateway. If you [Set up an Azure Arc gateway](../deploy/deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure), get the resource ID of the Arc gateway. This is also referred to as the `ArcGatewayID`.

   1. To get the `ArcGatewayID`, run the following command:  

       ```powershell
       az connectedmachine gateway list
       ```

   1. Make a note of the Arc gateway ID to use later.
   
## Step 1: Configure the network and connect to Azure

Follow these steps to configure network settings and connect the machines to Azure. Start this action a few minutes after you turn on the machine.

1. Open the Configurator app. Right-click the Configurator app exe and run as administrator. Wait a few minutes for the app to open up.

   :::image type="content" source="media/deployment-arc-register-configurator-app/open-app-1.png" alt-text="Screenshot of opening the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/open-app-1.png":::

1. Enter the machine serial number and select **Next**.

   :::image type="content" source="media/deployment-arc-register-configurator-app/access-the-device-1.png" alt-text="Screenshot of the machine serial number dialog in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/access-the-device-1.png":::

1. Sign in to the machine with local administrator credentials.

   :::image type="content" source="media/deployment-arc-register-configurator-app/access-the-device-2.png" alt-text="Screenshot of the password in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/access-the-device-2.png":::

1. On the **Azure Arc agent setup** page, select **Start**.

   :::image type="content" source="media/deployment-arc-register-configurator-app/start-setup-1.png" alt-text="Screenshot of the Azure Arc agent setup page with Start selected in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/start-setup-1.png":::

1. On the **Prerequisites** tab, verify that the minimum requirements are met and then select **Next**.

   :::image type="content" source="media/deployment-arc-register-configurator-app/prerequisites-1.png" alt-text="Screenshot of the Prerequisites tab in the Configurator app for Azure Local when all the prerequisites are met." lightbox="media/deployment-arc-register-configurator-app/prerequisites-1.png":::

   If a requirement isn't met, the app displays a warning or errors. You can't proceed if there are errors though warnings are ignored. Resolve the errors before you proceed. For more information, see [Troubleshooting](#troubleshooting).

   :::image type="content" source="media/deployment-arc-register-configurator-app/prerequisites-2.png" alt-text="Screenshot of the Prerequisites tab in the Configurator app for Azure Local when one of the prerequisites isn't met." lightbox="media/deployment-arc-register-configurator-app/prerequisites-2.png":::

1. On the **Basics** tab, configure one network interface that is connected to the internet. Select the **Pencil icon** to modify network interface settings.

   :::image type="content" source="media/deployment-arc-register-configurator-app/basics-tab-1.png" alt-text="Screenshot of the Basics tab in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/basics-tab-2.png":::

1. Provide the interface name, IP allocation as static or DHCP, IP address, subnet, gateway, and preferred DNS servers. Optionally, enter an alternate DNS server.

   :::image type="content" source="media/deployment-arc-register-configurator-app/basics-tab-2.png" alt-text="Screenshot of the Basics tab with Network settings configured in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/basics-tab-1.png":::

   > [!IMPORTANT]
   > Make sure that the IPs you assign are free and not in use.  

1. To specify more details, select **Enter additional details**.

1. On the **Additional details** page, provide the following inputs and then select **Apply**.

   :::image type="content" source="media/deployment-arc-register-configurator-app/basics-tab-additional-details-1.png" alt-text="Screenshot of the Basics tab with additional details configured in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/basics-tab-additional-details-1.png":::

   1. Select **ON** to enable **Remote desktop** protocol. Remote desktop protocol is disabled by default.

   1. Select **Public endpoint** or **Proxy server** as the connectivity method. If selecting a proxy server, provide the proxy URL and the bypass list. The bypass list is required and can be provided in a comma separated format.

   1. Select a time zone.

   1. Specify a preferred and an alternate NTP server to act as a time server or accept the **Default**. The default is `time.windows.com`.

   1. Set the hostname for your machine to what you specified during the preparation of Active Directory. Changing the hostname automatically reboots the system.

1. Select **Next** on the **Basics** tab.

1. On the **Arc agent setup** tab, provide the following inputs:

   :::image type="content" source="media/deployment-arc-register-configurator-app/arc-agent-setup-tab-1.png" alt-text="Screenshot of the Arc agent setup tab in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/arc-agent-setup-tab-1.png":::

   1. The **Cloud type** is populated automatically as `Azure`.
   
   1. Enter a **Subscription ID** to register the machine.

   1. Provide a **Resource group** name. This resource group contains the machine and system resources that you create.

   1. Specify the **Region** where you want to create the resources. The region should be the same as the region where you want to deploy the Azure Local instance.

      > [!IMPORTANT]
      > Specify the region with spaces removed. For example, specify the East US region as `EastUS`.

   1. Provide a **Tenant ID**. The tenant ID is the directory ID of your Microsoft Entra tenant. To get the tenant ID, see [Find your Microsoft Entra tenant](/azure/azure-portal/get-subscription-tenant-id).

   1. If you set up an Azure Arc gateway, specify the Arc gateway ID. This is the resource ID of the Arc gateway that you set up. For more information, see [About Azure Arc gateways](./deployment-azure-arc-gateway-overview.md).

   > [!IMPORTANT]
   > Make sure to verify all the inputs before you proceed. Any incorrect inputs here might result in a setup failure.

1. Select **Next**.

1. On the **Review and apply** tab, verify machine details. To modify any settings, go back. If satisfied with the current settings, select **Finish**. If you changed the hostname, your machines boot up automatically at this point and you must sign in again.

   :::image type="content" source="media/deployment-arc-register-configurator-app/review-apply-tab-1.png" alt-text="Screenshot of the Review and apply tab in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/review-apply-tab-1.png":::

## Step 2: Complete registration of machines to Azure

1. Wait for the configuration to complete. First, machine is configured with the basic details followed by registration of the machines to Azure.

1. During the Arc registration process, you must authenticate with your Azure account. The app displays a code that you must enter in the URL, displayed in the app, in order to authenticate. Follow the instructions to complete the authentication process.

   :::image type="content" source="media/deployment-arc-register-configurator-app/setup-configuration-authentication.png" alt-text="Screenshot of the Arc agent sign in and registration dialog in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/setup-configuration-authentication.png":::

1. Once the configuration is complete, status for Arc configuration should display **Success (Open in Azure portal)**.

1. Repeat all steps on the other machines until the Arc configuration succeeds. Select the **Open in Azure portal** link.

## Step 3: Verify machines are connected to Arc

1. In the Azure portal, go to the resource group that you used for bootstrapping.

1. On the resource group used to bootstrap, you should see your Arc-enabled machines. In this example, you see a single machine.

   :::image type="content" source="media/deployment-arc-register-configurator-app/setup-arc-enabled-servers.png" alt-text="Screenshot that shows the Azure Arc agent Arc-enabled servers in Azure portal for Azure Local." lightbox="media/deployment-arc-register-configurator-app/setup-arc-enabled-servers.png":::

## Troubleshooting

You might need to collect logs or diagnose problems if you encounter any issues while using the app to configure machines. You can use the following methods to troubleshoot:

- Get logs from a machine.
- Run diagnostic tests.
- Collect a Support package.
- Clean previous installation.

### Get logs if the app is inaccessible

If you can't access the app, you can get the logs from a machine. Logs are stored in the following location: `C:\Windows\System32\Bootstrap\Logs`. You can access the logs by connecting to the machine via Remote Desktop Protocol (RDP).

If you can access the app, follow the instructions in [Run diagnostic tests](#run-diagnostic-tests-from-the-app) to troubleshoot the issue and if needed, [Collect a support package](#collect-a-support-log-package-from-the-app).

### Run diagnostic tests from the app

To diagnose and troubleshoot any machine issues related to hardware, time server, and network, you can run the diagnostics tests. Use these steps to run the diagnostic tests from the app:

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane.

1. Select **Run tests**. The diagnostic tests check the health of the machine hardware, time server, and the network connectivity. The tests also check the status of the Azure Arc agent.

   :::image type="content" source="media/deployment-arc-register-configurator-app/run-diagnostics-tests-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Run diagnostic tests selected."lightbox="media/deployment-arc-register-configurator-app/run-diagnostics-tests-1.png":::

1. After the tests are completed, the results are displayed. Here's a sample output of the diagnostic tests when there's a machine issue:

   :::image type="content" source="media/deployment-arc-register-configurator-app/run-diagnostics-tests-2.png" alt-text="Screenshot that shows the error output after the diagnostic tests were run."lightbox="media/deployment-arc-register-configurator-app/run-diagnostics-tests-2.png":::

Here's a table that describes the diagnostic tests:

| Test Name                        | Description                                                               |
|----------------------------------|-----------------------------------------------------------------------|
| Internet connectivity            | This test validates the internet connectivity of the machine. |
| Web proxy (if configured)        | This test validates the web proxy configuration of the machine.  |
| Time sync                        | This test validates the machine time settings and checks that the time server configured on the machine is valid and accessible.                   |
| Azure Arc agent                  | This test validates the Azure Arc agent is installed and running on the machine. |
| Environment checker              | The Environment Checker tool runs a series of tests to evaluate the deployment readiness of your environment for Azure Local deployment including those for connectivity, hardware, Active Directory, network, and Arc integration. For more information, see [Evaluate the deployment readiness of your environment for Azure Local](../manage/use-environment-checker.md#about-the-environment-checker-tool). |

### Collect a Support log package from the app

A Support package is composed of all the relevant logs that can help Microsoft Support troubleshoot any machine issues. You can generate a Support package via the app.

#### Download the Support log package

Follow these steps to collect and download a Support package:

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane. Select **Create** to begin support package collection. The package collection could take several minutes.

   :::image type="content" source="media/deployment-arc-register-configurator-app/collect-support-package-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Create selected." lightbox="media/deployment-arc-register-configurator-app/collect-support-package-1.png":::

1. After the Support package is created, select **Download**. This action downloads two zipped packages corresponding to Support logs and Configurator logs on your local system. You can unzip the package and view the system log files.

#### Upload the Support log package

> [!IMPORTANT]
> - Make sure to run the Configurator app as an administrator to upload the Support log package.
> - Uploading the Support log package to Microsoft can take up to 20 minutes. Make sure to leave the app open and running to complete this process.

Follow these steps to upload the Support package to Microsoft:

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane. Select **Upload** to upload the Support package to Microsoft.

   :::image type="content" source="media/deployment-arc-register-configurator-app/upload-support-package-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Upload package selected." lightbox="media/deployment-arc-register-configurator-app/upload-support-package-1.png":::

1. Provide the required information in the **Upload Support package to Microsoft** dialog:

   :::image type="content" source="media/deployment-arc-register-configurator-app/upload-support-package-2.png" alt-text="Screenshot that shows the Upload Support Package dialog filled out." lightbox="media/deployment-arc-register-configurator-app/upload-support-package-2.png":::

    The fields in the dialog are prepopulated with the information you provided during [Step 1: Configure the network and connect to Azure](#step-1-configure-the-network-and-connect-to-azure). You can modify the fields as needed.

1. Select **Begin upload** to upload the Support log package.
1. Authenticate in the browser with the same account that you used to sign in to register with Azure Arc. The upload process might take several minutes. Leave the app open and running until the upload is complete.

   :::image type="content" source="media/deployment-arc-register-configurator-app/upload-support-package-3.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Upload selected and authentication guidance." lightbox="media/deployment-arc-register-configurator-app/upload-support-package-3.png":::

1. After the upload is complete, you receive a confirmation message. You can also view the upload status in the app.

### Clean previous installation

If you have more than one version of the app installed, when you try to open the app, an older version of the app might open. To fix this issue, clean the previous installation. Follow these steps to clean the previous installation:

1. Uninstall the Configurator app as you would any other app on the system.
1. Delete the `C:\Users\%USERNAME%\AppData\Roaming\microsoft.-azure.-edge.-oobe.-local-ui` directory.
1. Launch the app again. The app should open without any issues.

## Next steps

- After your machines are registered with Azure Arc, proceed to deploy your Azure Local system via one of the following options:
    - [Deploy via Azure portal](./deploy-via-portal.md).
    - [Deploy via ARM template](./deployment-azure-resource-manager-template.md).
