---
title: Use an Arc script file to bootstrap Azure Stack HCI (preview).
description: Learn how to use an Arc script file to bootstrap servers on Azure Stack HCI systems (preview).
ms.topic: article
author: alkohli
ms.author: alkohli
ms.date: 06/11/2024
---

# Use an Arc script file to bootstrap Azure Stack HCI (preview)

## Bootstrap methods

After you have procured the hardware that you intend to use to set up your Azure Stack HCI system, you will bootstrap the hardware using one of the following methods:  

- **Site bootstrap key** - Use this method if you have many sites and servers to deploy Azure Stack HCI on - for example, hundreds or thousands of them. Make a site for all the deployments and prepare the physical devices. Then set up the devices so that they can access a home URL and get the configuration from Azure. Generate a site bootstrap key that is then distributed across all the deployments. Configure the devices via local web-based UI and connect to Arc and finally provision the devices.

- **Multi-server Arc script file** - Use this basic method if you intend to deploy a few sites with a small number of servers per site. Use a local web-based UI to configure the devices and to provide a bootstrap file with an Arc script for registration.

> [!NOTE]
> This guide only covers the bootstrapping for Azure Stack HCI via the Arc script file.

## Arc script bootstrap step-by-step

### Step 0: Complete the prerequisites

Before you begin, make sure that you:

1. [Complete prerequisites for your environment](../deploy/deployment-prerequisites.md).
1. [Prepare Active Directory](../deploy/deployment-prep-active-directory.md).
1. Download the customized ISO/VHD required for this testing from here:
    1. [VHD](https://aka.ms/ashci/vhd).
    1. [ISO](https://aka.ms/ashci/iso).
1. Use the customized ISO/VHD that you downloaded in the previous step and follow these instructions for OS installation: [Install the Azure Stack HCI, version 23H2 software](../deploy/deployment-install-os.md).
1. For your servers, note down the:
   1. Serial number of the servers.
   1. Local administrator credentials to sign into the server.

   You’ll need this information later.

1. Make sure that your subscription is registered against the following resource providers. Run the following PowerShell commands:

   ```powershell
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.HybridCompute"
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.GuestConfiguration"
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.HybridConnectivity"
   Register-ResourceProviderIfRequired -ProviderNamespace "Microsoft.AzureStackHCI"
   ```

1. To create a service principal, your Microsoft Entra tenant must allow users to register applications. If it does not, your account must be a member of the **Application Administrator** or **Cloud Application Administrator** administrative role.

1. To assign Arc-enabled server roles, your account must be a member of the **Owner** or **User Access Administrator** role in the subscription that you want to use for onboarding.

### Step 1: Generate Arc script for multiple servers

Make sure to use this Azure preview portal URL to test the feature described in this guide: [Azure preview portal](https://aka.ms/ashci/ltp/tryit).  

Follow these steps in the [Azure preview portal](https://aka.ms/ashci/ltp/tryit):

1. Go to **Azure Arc** > **Machines**.

1. Select **+ Add/Create** > **Add a machine**.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-a-machine.png" alt-text="Screenshot that shows Azure Arc option to add a machine." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-a-machine.png":::

1. Select **Add multiple servers** > **Generate script**.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-multiple-servers.png" alt-text="Screenshot that shows Azure Arc option to add multiple server." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-multiple-servers.png":::

1. On the **Add multiple servers with Azure Arc** blade, on the **Basics** tab, input the following:

   1. Choose the **Subscription** that you want to associate with the server to be managed.
   1. Select an existing or create a new resource group.
   1. From the dropdown list, select a **Region**. Only the East US and West Europe regions are supported.
   1. Select the Windows **Operating System**.
   1. Choose **Connectivity method** as **Public endpoint**.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-multiple-servers-details-blade.png" alt-text="Screenshot that shows Azure Arc details blade to add multiple servers." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-multiple-servers-details-blade.png":::

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-multiple-servers-details-blade-2.png" alt-text="Screenshot that shows the second Azure Arc details blade to add multiple servers." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-multiple-servers-details-blade-2.png":::

   f. Create a new **Service Principal** (SPN).<br>
   g. Choose if the SPN will have access to the **Subscription** or the **Resource group**.<br>
   h. Choose the subscription (and resource group) to which the SPN will have access.<br>
   i. Optionally enter a description for the client secret.<br>
   j. Select the expiry period for the client secret. Specify the duration for which you expect the client secret to be in use.<br>
   k. Assign these roles to the service principal:
      - **Azure Connected Machine Onboarding**.
      - **Azure Connected Machine Resource Administrator**.

1. Select Create.  

    :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-spn-details-blade.png" alt-text="Screenshot that shows the Azure Arc blade to add Azure Arc SPN details." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-spn-details-blade.png":::

1. Download service principal ID, also known as the client ID or SPN, and client secret.

    :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-download-spn-and-client-secret.png" alt-text="Screenshot that shows the Azure Arc dialog to download SPN and client secret." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-download-spn-and-client-secret.png":::

1. Select the SPN that you created. Select **Download and run script**.

    :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-download-and-run-script.png" alt-text="Screenshot that shows the Azure Arc dialog to download and run the SPN script." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-download-and-run-script.png":::

1. Select **Deployment method** as **Basic script**.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-spn-deploy-as-basic-script.png" alt-text="Screenshot that shows the Azure Arc dialog to download and deploy as a basic script." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-add-spn-deploy-as-basic-script.png":::

1. Download the *OnboardingScript.ps1*.
1. Open the script. Following is an example of the script. By default, the client secret isn’t populated and needs to be added in **Step 2: Configure the network and connect to Azure**.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-sample-spn-script.png" alt-text="Screenshot that shows an Azure Arc SPN sample script." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-sample-spn-script.png":::

### Step 2: Configure the network and connect to Azure

Follow these steps to configure the network settings and connect the servers to Azure.

1. Open a browser window and access the local web UI of the device at: *https://<device-serial-number>*. This action may take a few minutes after you've turned on the server.

1. You see an error or a warning indicating that there’s a problem with the website's security certificate. Select *Proceed to https://<device-serial-number>.local*.

   > [!NOTE]
   > You can find the device serial number on the sticker affixed to your hardware. If the device serial number is longer than the supported maximum of 15 characters, the serial number is transformed by picking up the first 15 alphanumeric characters of the serial number.

1. Sign in to the server with the local administrator credentials.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-admin-logon-dialog.png" alt-text="Screenshot that shows the Azure Stack HCI sign in dialog." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-admin-logon-dialog.png":::

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-admin-password-dialog.png" alt-text="Screenshot that shows the Azure Stack HCI password dialog." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-admin-password-dialog.png":::

1. On the Azure agent setup page, select **Set up manually**.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-manually.png" alt-text="Screenshot that shows the Azure Stack HCI Arc Agent Setup dialog." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-manually.png":::

1. On the **Basics** tab, configure one network interface that is connected to the internet. Select the pencil icon to modify the network interface settings.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-basics-tab.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup page with the pencil icon called out." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-basics-tab.png":::

1. Provide the interface name, IP allocation as static or DHCP, IP address, subnet, gateway, and preferred DNS servers. Optionally enter an alternate DNS server.

   > [!IMPORTANT]
   > Make sure that the IPs you assign are free and not in use.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-network-settings.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup page with the pencil icon called out."lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-network-settings.png":::

1. Provide additional details.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-network-settings-details-button.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup page with the "Enter additional details" button called out." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-network-settings-details-button.png":::

1. On the **Additional details** blade provide the following inputs.

   1. Enable Remote desktop protocol.
   1. Choose public endpoint as the connectivity method.
   1. Specify an NTP server to act as a time server or accept **Default**. The default is *times.windows.com*.
   1. Set the hostname for your server to what you specified during the preparation of Active Directory. Changing the hostname would automatically reboot the system.

1. Select **Apply**.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-network-settings-details-blade.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup page with the "Additional details" blade." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-network-settings-details-blade.png":::

1. On the **Arc agent setup** tab, under **Arc agent setup settings**, provide the following inputs.

   1. Choose **Arc agent setup file** as the Arc script file.
   1. Browse and point to the PowerShell script – *OnboardingScript.ps1* that you downloaded earlier.
   1. Once the script downloads, select **Edit**.

      :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-edit-the-script.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup page." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-edit-the-script.png":::

1. On the **Arc script contents** blade, replace the **client secret** with the client secret that you copied from the SPN creation step.

   > [!IMPORTANT]
   > Make sure to verify all the inputs before you proceed. Any incorrect inputs here could lead to a setup failure.  

1. Select **Apply**.

1. On the **Arc-agent setup** tab, select **Next**.

1. On the **Review and apply** tab, verify the server details. To modify any settings, go back. If satisfied with the current settings, select **Finish**. If you changed the hostname, your servers will boot up automatically at this point and you must sign in again.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-review-and-apply.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup page, "Review and apply" tab." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-review-and-apply.png":::

1. Wait for the configuration to complete. First, the device details will be uploaded, followed by registration of the server to Azure and, finally, the mandatory Arc extensions are installed.

   > [!NOTE]
   > The entire process may take 15 to 30 minutes.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-configuration-details.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup, configuration details." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-configuration-details.png":::

1. Once the configuration is complete, status for Arc configuration should turn to **Success (Open in Azure portal)**.  

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-configuration-status.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup configuration status." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-configuration-status.png":::

1. Repeat all the steps on the other servers until the Arc configuration has succeeded. Select the **Open in Azure portal** link.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-configuration-open-in-azure-portal.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent setup configuration status, open in Azure portal option." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-configuration-open-in-azure-portal.png":::

### Step 3: Verify servers are connected to Arc

1. In the Azure portal, go to the resource group for bootstrapping.

1. On the resource group used to bootstrap, you should see your Arc-enabled servers. In this example, you see two servers.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-arc-enabled-servers.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent Arc-enabled servers in Azure portal." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-setup-arc-enabled-servers.png":::

1. Select and drill down into a server. Go to **Settings** > **Extension**. Make sure that all the mandatory extensions are installed successfully.

   :::image type="content" source="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/azure-stack-hci-azure-arc-agent-extensions-installed-successfully.png" alt-text="Screenshot that shows the Azure Stack HCI Azure Arc agent extensions installed successfully." lightbox="media/azure-stack-hci-arc-script-bootstrap-guide-(preview)/extensions-installed-successfully.png":::

   If an extension fails to install, see how to [Install an Azure Arc extension](../manage/arc-extension-management?tabs=azurepowershell#install-an-extension).

## Next steps

- Use the steps in [Deploy your Azure Stack HCI, version 23H2 via Azure portal](../deploy/deploy-via-portal.md) to deploy your cluster.
