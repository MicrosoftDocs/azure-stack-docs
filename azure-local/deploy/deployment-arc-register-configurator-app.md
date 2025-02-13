---
title: Configurator application for Azure Local (Preview)
description: Learn how to use the Configurator application to bootstrap and Arc register the Azure Local machines. (Preview)
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.date: 02/12/2025
ms.service: azure-local
#CustomerIntent: As an IT Pro, I want to bootstrap and Arc register Azure Local machines via the Arc registration script.
---

# Register your Azure Local machines via the Configurator app (Preview)

> Applies to: Azure Local 2502 and later

This article describes how to use the Configurator app to bootstrap and register the machines you plan to include in your Azure Local instance.

You can use the Configurator app or [Azure CLI](./deployment-arc-register-server-permissions.md) to register your machines. If you plan to deploy a few machines per site, use the Configurator app.

[!INCLUDE [important](../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure that you complete the following prerequisites:

### Azure Local machine prerequisites

1. Procure the hardware that you intend to use as an Azure Local system. Turn on these machines and connect them to the network.

1. Complete [prerequisites for your environment](../deploy/deployment-prerequisites.md).

1. [Prepare Active Directory](../deploy/deployment-prep-active-directory.md).

1. [Download the English-language Preview ISO](https://aka.ms/HCIReleaseImage).

1. Use the downloaded Preview ISO and follow the steps for operating system installation in [Install Azure Stack HCI Operating System, version 23H2](../deploy/deployment-install-os.md).

1. Download the [Configurator App for Azure Local](https://aka.ms/ConfiguratorAppForHCI).

1. Note down:

   - The serial number for each machine.
   - Local administrator credentials to sign into each machine.

### Azure prerequisites

1. **Register required resource providers.** Make sure that your Azure subscription is registered against the required resource providers. To register, you must be an owner or contributor on your subscription. You can also ask an administrator to register.

   Run the following [PowerShell commands](/azure/azure-resource-manager/management/resource-providers-and-types#azure-powershell) to register:

   ```powershell
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.HybridCompute" 
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.GuestConfiguration" 
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.HybridConnectivity" 
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.AzureStackHCI" 
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.Kubernetes" 
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.KubernetesConfiguration" 
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.ExtendedLocation" 
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.ResourceConnector" 
   Register-ResourceProviderIfRequired -ProviderNamespace "HybridContainerService" 
   ```

1. **Create a resource group**. Follow the steps to [Create a resource group](/azure/azure-resource-manager/management/manage-resource-groups-portal#create-resource-groups) where you want to register your machines. Make a note of the resource group name and the associated subscription ID.

1. **Get the tenant ID**. Follow the steps in [Get the tenant ID of your Microsoft Entra tenant through the Azure portal](/azure/azure-portal/get-subscription-tenant-id):

   1. In the Azure portal, go to **Microsoft Entra ID** > **Properties**.

   1. Scroll down to the Tenant ID section and copy the **Tenant ID** value to use later.

1. **Get Arc gateway ID**. Skip this step if you didn't set up Azure Arc gateway. If you [Set up an Azure Arc gateway](../deploy/deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure), get the resource ID of the Arc gateway. This is also referred to as the `ArcGatewayID`.

   1. To get the `ArcGatewayID`, run the following command:  

       ```powershell
       az connectedmachine gateway list
       ```

   1. Make a note of the Arc gateway ID to use later.

1. **Verify permissions**. As you register machines as Arc resources, make sure that you're either the resource group owner or have the following permissions on the resource group where the machines are provisioned:

   - `Azure Connected Machine Onboarding`.
   - `Azure Connected Machine Resource Administrator`.

   To verify that you have these roles, follow these steps in the Azure portal:
    
   1. Go to the subscription you used for the Azure Local deployment.

   1. Go to the resource group where you plan to register the machine.

   1. In the left-pane, go to **Access Control (IAM)**.

   1. In the right-pane, go to **Role assignments**. Verify that you have `Azure Connected Machine Onboarding` and `Azure Connected Machine Resource Administrator` roles assigned.
    
## Step 1: Configure the network and connect to Azure

Follow these steps to configure network settings and connect the machines to Azure. Start this action a few minutes after you turn on the machine.

1. Open the Configurator app. Enter the machine serial number and select **Next**.

   :::image type="content" source="media/deployment-arc-register-configurator-app/access-the-device-1.png" alt-text="Screenshot of the machine serial number dialog in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/access-the-device-1.png":::

1. Sign in to the machine with local administrator credentials.

   :::image type="content" source="media/deployment-arc-register-configurator-app/access-the-device-2.png" alt-text="Screenshot of the password in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/access-the-device-2.png":::

1. On the **Azure Arc agent setup** page, select **Start**.

   :::image type="content" source="media/deployment-arc-register-configurator-app/start-setup-1.png" alt-text="Screenshot of the Azure Arc agent setup page with Start selected in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/start-setup-1.png":::

1. On the **Prerequisites** tab, verify that the minimum requirements are met and then select **Next**.

   :::image type="content" source="media/deployment-arc-register-configurator-app/prerequisites-1.png" alt-text="Screenshot of the Prerequisites tab in the Configurator app for Azure Local when all the prerequisites are met." lightbox="media/deployment-arc-register-configurator-app/prerequisites-1.png":::

   If a requirement isn't met, the app displays a warning icon. Resolve the issue before you proceed. For more information, see [Troubleshooting](#troubleshooting).

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

   1. Select **Off** to enable **Remote desktop** protocol.

   1. Select **Public endpoint** or **Proxy server** as the connectivity method. If selecting a proxy server, provide the proxy URL and the bypass list.

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

### Step 2: Complete registration of machines to Azure

1. Wait for the configuration to complete. First, machine details are uploaded followed by registration of the machines to Azure.

1. During the Arc registration process, you must authenticate with your Azure account. The app displays a code that you must enter in the URL, displayed in the app, in order to authenticate. Follow the instructions to complete the authentication process.

   <!--:::image type="content" source="media/deployment-arc-register-configurator-app/arc-agent-registration-6.png" alt-text="Screenshot of the Arc agent sign in and registration dialog in the Configurator app for Azure Local." lightbox="media/deployment-arc-register-configurator-app/arc-agent-registration-6.png":::-->

1. Once the configuration is complete, status for Arc configuration should display **Success (Open in Azure portal)**.

1. Repeat all steps on the other machines until the Arc configuration succeeds. Select the **Open in Azure portal** link.

## Step 3: Verify machines are connected to Arc

1. In the Azure portal, go to the resource group for bootstrapping.

1. On the resource group used to bootstrap, you should see your Arc-enabled machines. <!--In this example, you see a single machine.-->

## Troubleshooting

You might need to collect logs or diagnose problems if you encounter any issues while using the app to configure machines. You can use the following methods to troubleshoot:

- Get logs from a machine.
- Run diagnostic tests.
- Collect a Support package.

### Get logs if the app is inaccessible

If you can't access the app, you can get the logs from a machine. Logs are stored in the following location: `C:\Windows\System32\Bootstrap\Logs`. You can access the logs by connecting to the machine via Remote Desktop Protocol (RDP).

If you can access the app, follow the instructions in [Run diagnostic tests](#run-diagnostic-tests-from-the-app) to troubleshoot the issue and if needed, [Collect a support package](#collect-a-support-package-from-the-app).

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

### Collect a Support package from the app

A Support package is composed of all the relevant logs that can help Microsoft Support troubleshoot any machine issues. You can generate a Support package via the app. Follow these steps to collect a Support package:

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane. Select **Create** to begin support package collection. The package collection could take several minutes.

   :::image type="content" source="media/deployment-arc-register-configurator-app/collect-support-package-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Create selected." lightbox="media/deployment-arc-register-configurator-app/collect-support-package-1.png":::

1. After the Support package is created, select **Download**. This action downloads two zipped packages corresponding to Support logs and Configurator logs on your local system. You can unzip the package and view the system log files.

## Next steps

- After your machines are registered with Azure Arc, proceed to deploy your Azure Local system via one of the following options:
    - [Deploy via Azure portal](./deploy-via-portal.md).
    - [Deploy via ARM template](./deployment-azure-resource-manager-template.md).
