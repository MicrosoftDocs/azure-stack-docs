---
title: Use local web UI to register Azure Stack HCI servers with Azure Arc (preview).
description: Learn how to use the web UI to bootstrap and Arc register the Azure Stack HCI servers (preview).
ms.topic: article
author: alkohli
ms.author: alkohli
ms.date: 07/08/2024
---

# Register your Azure Stack HCI, version 23H2 servers via the local UI (preview)

Applies to: Azure Stack HCI, software version 2405.1 and later

<!--[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]-->

This article describes how to use a local web-based UI to bootstrap and register the servers that you intend to cluster as an Azure Stack HCI system. 

You can use the local UI or Azure CLI to register your servers.

Use the local web-based UI method if you intend to deploy some sites with a few servers per site.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

After you have procured the hardware that you intend to use to set up your Azure Stack HCI system, you bootstrap the hardware using a local web-based UI. Before you begin, make sure that you satisfy the following server and Azure prerequisites:

### Server prerequisites

1. You have the servers that you intend to cluster as an Azure Stack HCI system. The servers must be powered on and connected to the network.
1. [Complete prerequisites for your environment](../deploy/deployment-prerequisites.md)
1. [Prepare Active Directory](../deploy/deployment-prep-active-directory.md).
1. [Download the English Preview ISO](../deploy/download-azure-stack-hci-23h2-software.md) to install the preview version of Azure Stack HCI, 23H2.
1. Use the English Preview ISO that you downloaded in the previous step and follow these instructions for OS installation: [Install the Azure Stack HCI, version 23H2 software](../deploy/deployment-install-os.md).
1. For your servers, note down the:
   1. Serial number of the servers.
   1. Local administrator credentials to sign into the server.

### Azure prerequisites

- Make sure that your subscription is registered against the following resource providers. You need to be an owner or contributor on your subscription to register. You can also ask an administrator to register. Run the following [PowerShell commands](/azure/azure-resource-manager/management/resource-providers-and-types#azure-powershell) to register:

   ```powershell
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.HybridCompute"
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.GuestConfiguration"
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.HybridConnectivity"
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.AzureStackHCI"
   ```

- [Create a resource group](/azure/azure-resource-manager/management/manage-resource-groups-portal#create-resource-groups) where you want to register your servers. Make a note of the resource group name and the associated subscription ID.
- [Get the tenant ID of your Microsoft Entra tenant through the Azure portal](/azure/azure-portal/get-subscription-tenant-id).
  - In the Azure portal, go to **Microsoft Entra ID** > **Properties**.
  - Scroll down to the Tenant ID section and copy the **Tenant ID** value. You use this information later.
- If you [Set up an Azure Arc gateway](../deploy/deployment-azure-arc-gateway-overview.md#create-the-arc-gateway-resource-in-azure), get the resource ID of the Arc gateway. This is also referred to as the `ArcGatewayID`.
  - To get the `ArcGatewayID`, run the following command:
     `az connectedmachine gateway list`

  - Make a note of the Arc gateway ID. You need this information later.

  If you didn't set up an Azure Arc gateway, you can skip this step.

- As you are registering the servers as Arc resources, make sure that you're either the resource group owner or have the following permissions on the resource group where the servers were provisioned:

  - Azure Connected Machine Onboarding.
  - Azure Connected Machine Resource Administrator.

   To verify that you have these roles, follow these steps in the Azure portal:

   1. Go to the subscription that you use for the Azure Stack HCI deployment.
   1. Go to the resource group where you're planning to register the servers.
   1. In the left-pane, go to **Access Control (IAM)**.
   1. In the right-pane, go the **Role assignments**. Verify that you have the **Azure Connected Machine Onboarding** and **Azure Connected Machine Resource Administrator** roles assigned.

<!--1. To create a service principal, your Microsoft Entra tenant must allow users to register applications. If it doesn't, your account must be a member of the **Application Administrator** or **Cloud Application Administrator** administrative role.

1. To assign Arc-enabled server roles, your account must be a member of the **Owner** or **User Access Administrator** role in the subscription that you want to use for onboarding.-->

## Step 1: Configure the network and connect to Azure

Follow these steps to configure the network settings and connect the servers to Azure.

1. Open a browser window and access the local web UI of the device at: *https://\<device-serial-number\>.local*. This action may take a few minutes after you've turned on the server.

1. You see an error or a warning indicating that there’s a problem with the website's security certificate. Select *Proceed to https://\<device-serial-number\>.local*.

   > [!NOTE]
   > You can find the device serial number on the sticker affixed to your hardware. If the device serial number is longer than the supported maximum of 15 characters, the serial number is transformed by picking up the first 15 alphanumeric characters of the serial number.

1. Sign in to the server with the local administrator credentials.

   <!--:::image type="content" source="media/deployment-arc-register-local-ui/admin-logon-dialog.png" alt-text="Screenshot that shows the Azure Stack HCI local UI sign in dialog." lightbox="media/deployment-arc-register-local-ui/admin-logon-dialog.png":::-->

   <!--:::image type="content" source="media/deployment-arc-register-local-ui/admin-password-dialog.png" alt-text="Screenshot that shows the Azure Stack HCI local UI password dialog." lightbox="media/deployment-arc-register-local-ui/admin-password-dialog.png":::-->

1. On the Azure agent setup page, select **Start**.

   :::image type="content" source="media/deployment-arc-register-local-ui/setup-start.png" alt-text="Screenshot that shows the Azure Stack HCI Arc Agent Setup dialog with Start called out." lightbox="media/deployment-arc-register-local-ui/setup-start.png":::

1. On the **Basics** tab, configure one network interface that is connected to the internet. Select the pencil icon to modify the network interface settings.

   :::image type="content" source="media/deployment-arc-register-local-ui/setup-basics-tab.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup page with the pencil icon called out." lightbox="media/deployment-arc-register-local-ui/setup-basics-tab.png":::

1. Provide the interface name, IP allocation as static or DHCP, IP address, subnet, gateway, and preferred DNS servers. Optionally enter an alternate DNS server.

   > [!IMPORTANT]
   > Make sure that the IPs you assign are free and not in use.

   :::image type="content" source="media/deployment-arc-register-local-ui/setup-network-settings.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup page with the network settings with static allocation."lightbox="media/deployment-arc-register-local-ui/setup-network-settings.png":::

1. Provide more details. Select **Enter additional details**.

   :::image type="content" source="media/deployment-arc-register-local-ui/setup-network-settings-details-button.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup Enter Additional details selected."lightbox="media/deployment-arc-register-local-ui/setup-network-settings-details-button.png":::

1. On the **Additional details** blade, provide the following inputs.

   1. Enable Remote desktop protocol.
   1. Choose **Public endpoint** or **Proxy server** as the connectivity method. If selecting a proxy server, provide the proxy URL and the bypass list.
   1. Select a time zone.
   1. Specify a preferred and an alternate NTP server to act as a time server or accept **Default**. The default is *time.windows.com*.
   1. Set the hostname for your server to what you specified during the preparation of Active Directory. Changing the hostname automatically reboots the system.

1. Select **Apply**.

   :::image type="content" source="media/deployment-arc-register-local-ui/setup-network-settings-details-blade.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup page with the additional details configured."lightbox="media/deployment-arc-register-local-ui/setup-network-settings-details-blade.png":::

1. Select **Next** on the **Basics** tab.

1. On the **Arc agent setup** tab, under **Arc agent details**, provide the following inputs.

   1. Enter a **Subscription ID** that you use to register the server.
   1. Provide a **Resource group** name. This resource group contains the server and the cluster resources that you create.
   1. Specify the **Region** where you want to create the resources. The region should be the same as the region where you want to deploy the Azure Stack HCI cluster. 
      > [!IMPORTANT]
      > The region is specified with the spaces removed. For example, **East US** is specified as **EastUS**.
   1. The **Cloud type** is populated automatically as **AzureCloud**.
   1. Provide a **Tenant ID**. The tenant ID is the directory ID of your Microsoft Entra tenant. To get the tenant ID, see [Find your Microsoft Entra tenant](/azure/azure-portal/get-subscription-tenant-id).
   1. If you set up an Azure Arc gateway, provide the Arc gateway ID. This is the resource ID of the Arc gateway that you set up. For more information, see [About Azure Arc gateways](./deployment-azure-arc-gateway-overview.md).

      :::image type="content" source="media/deployment-arc-register-local-ui/setup-arc-agent-details.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup page." lightbox="media/deployment-arc-register-local-ui/setup-arc-agent-details.png":::

   > [!IMPORTANT]
   > Make sure to verify all the inputs before you proceed. Any incorrect inputs here could lead to a setup failure.  

1. On the **Arc agent setup** tab, select **Next**.

1. On the **Review and apply** tab, verify the server details. To modify any settings, go back. If satisfied with the current settings, select **Finish**. If you changed the hostname, your servers boot up automatically at this point and you must sign in again.

   :::image type="content" source="media/deployment-arc-register-local-ui/setup-review-and-apply.png" alt-text="Screenshot that shows the Review and apply tab on Azure Stack HCI Azure Arc agent setup page."lightbox="media/deployment-arc-register-local-ui/setup-review-and-apply.png":::

1. Wait for the configuration to complete. First, the device details are uploaded, followed by registration of the server to Azure and, finally, the mandatory Arc extensions are installed.

   > [!NOTE]
   > The entire process may take 15 to 30 minutes.

   :::image type="content" source="media/deployment-arc-register-local-ui/setup-configuration-details.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup, configuration details." lightbox="media/deployment-arc-register-local-ui/setup-configuration-details.png":::

   During the Arc registration process, you need to authenticate with your Azure account. The local UI displays a code that you need to enter in the URL displayed in the local UI to authenticate. Follow the instructions to complete the authentication process.

   :::image type="content" source="media/deployment-arc-register-local-ui/setup-configuration-authentication.png" alt-text="Screenshot that shows the authentication with your Azure account." lightbox="media/deployment-arc-register-local-ui/setup-configuration-authentication.png":::

1. Once the configuration is complete, status for Arc configuration should turn to **Success (Open in Azure portal)**.  

1. Repeat all the steps on the other servers until the Arc configuration succeeds. Select the **Open in Azure portal** link.

   :::image type="content" source="media/deployment-arc-register-local-ui/setup-configuration-open-in-azure-portal.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup configuration status, open in Azure portal option." lightbox="media/deployment-arc-register-local-ui/setup-configuration-open-in-azure-portal.png":::

## Step 2: Verify servers are connected to Arc

1. In the Azure portal, go to the resource group for bootstrapping.

1. On the resource group used to bootstrap, you should see your Arc-enabled servers. In this example, you see a single server.

   :::image type="content" source="media/deployment-arc-register-local-ui/setup-arc-enabled-servers.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent Arc-enabled servers in Azure portal." lightbox="media/deployment-arc-register-local-ui/setup-arc-enabled-servers.png":::

1. Select and drill down into the server. Go to **Settings** > **Extension**. Make sure that all the mandatory extensions are installed successfully.

   :::image type="content" source="media/deployment-arc-register-local-ui/arc-agent-extensions-installed-successfully.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent extensions installed successfully." lightbox="media/deployment-arc-register-local-ui/arc-agent-extensions-installed-successfully.png":::

   If an extension fails to install, see how to [Install an Azure Arc extension](../manage/arc-extension-management.md#install-an-extension).

## Troubleshooting

You might need to collect the logs or diagnose the problems if you encounter any issues while configuring the server with the local UI. You can use the following resources to troubleshoot:

1. Get local UI logs from the server.
1. Run diagnostic tests.
1. Collect a Support package.

### Get local UI logs if UI is inaccessible

If you can't access the local UI, you can get the local UI logs from the server. The logs are stored in the following location: `C:\Windows\System32\Bootstrap\Logs`. You can access the logs by connecting to the server via Remote Desktop Protocol (RDP). 

If you can access the local UI, follow the instructions in [Run diagnostic tests](#run-diagnostic-tests-from-the-local-ui) to troubleshoot the issue and then [Collect a Support package](#collect-a-support-package-from-the-local-ui) if needed.


### Run diagnostic tests from the local UI

To diagnose and troubleshoot any device issues related to hardware, time server, and network, you can run the diagnostics tests. Follow these steps to run the diagnostic tests from the local UI:

1. Select the help icon in the top-right corner of the local UI to open the **Support + troubleshooting** pane.
1. Select **Run diagnostic tests**. The diagnostic tests check the health of the server hardware, time server, and the network connectivity. The tests also check the status of the Azure Arc agent and the extensions.

   :::image type="content" source="media/deployment-arc-register-local-ui/run-diagnostics-tests-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Run diagnostic tests selected."lightbox="media/deployment-arc-register-local-ui/run-diagnostics-tests-1.png":::

1. After the tests are completed, the results are displayed. Here's a sample output of the diagnostic tests when there's a device issue:

   :::image type="content" source="media/deployment-arc-register-local-ui/run-diagnostics-tests-2.png" alt-text="Screenshot that shows the error output after the diagnostic tests were run."lightbox="media/deployment-arc-register-local-ui/run-diagnostics-tests-1.png":::

Here's a table that describes the diagnostic tests:

| Test Name                        | Description                                                               |
|----------------------------------|-----------------------------------------------------------------------|
| Internet connectivity            | This test validates the internet connectivity of the device. |
| Web proxy (if configured)        | This test validates the web proxy configuration of the device.  |
| Time sync                        | This test validates the device time settings and checks that the time server configured on the device is valid and accessible.                   |
| Azure Arc agent                  | This test validates the Azure Arc agent is installed and running on the device. |
| Environment checker              | The Environment Checker tool runs a series of tests to evaluate the deployment readiness of your environment for Azure Stack HCI deployment including those for connectivity, hardware, Active Directory, network, and Arc integration. For more information, see [Evaluate the deployment readiness of your environment for Azure Stack HCI, version 23H2](../manage/use-environment-checker.md#about-the-environment-checker-tool) |

### Collect a Support package from the local UI

A log package is composed of all the relevant logs that can help Microsoft Support troubleshoot any device issues. You can generate a log package via the local web UI. Follow these steps to collect a Support package from the local UI:

1. Select the help icon in the top-right corner of the local UI to open the **Support + troubleshooting** pane. Select **Create** to begin support package collection. The package collection could take several minutes.

   :::image type="content" source="media/deployment-arc-register-local-ui/collect-support-package-1.png" alt-text="Screenshot that shows the Support and troubleshooting pane with Create selected." lightbox="media/deployment-arc-register-local-ui/collect-support-package-1.png":::

1. After the Support package is created, select **Download**. A zipped package is downloaded on your local system. You can unzip the package and view the system log files.


## Next steps

- After your servers are registered with Azure Arc, proceed to deploy your Azure Stack HCI cluster via one of the following options:
  - [Via the Azure portal](../deploy/deploy-via-portal.md).
  - [Via the ARM template](../deploy/deployment-azure-resource-manager-template.md).
