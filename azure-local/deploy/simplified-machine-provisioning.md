---
title: Simplified Machine Provisioning for Azure Local (preview)
description: Lean how to use simplified machine provisioning for Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.topic: how-to
ms.date: 02/03/2026
ms.subservice: hyperconverged
---

# Simplified machine provisioning for Azure Local (preview)

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

Azure Local provides hyperconverged infrastructure that hosts container workloads and storage. It's a hybrid product that connects the on-premises system to Azure for cloud services, monitoring, and management.  

This article describes how to use simplified machine provisioning to bootstrap and register the machines that you intend to form as an Azure Local instance.

At a high level, there are three key stages:

:::image type="content" source="media/simplified-machine-provisioning/simplified-machine-provisioning-stages.png" alt-text="Diagram showing the three stages of simplified machine provisioning." border="false" lightbox="media/simplified-machine-provisioning/simplified-machine-provisioning-stages.png":::

1. **Prepare the machines**: Preparation ends with two artifacts: simplified machine provisioning software components installed on the device and generating an ownership voucher. Both artifacts need to be sent to the end customer. Anyone can prepare the devices, whether you're a device manufacturer, an integrator, or even an end customer, but the approach is most valuable when someone other than the end customer prepares the devices.

2. **Provision the machines from the Azure portal**: 

    1. Set up site-level configuration: This configuration applies to all new machines under a site. This configuration includes settings like time zone, time server, machine IP address, proxy server, Azure Arc-gateway, Key vault for administrator credentials, and more. Site-level configuration eliminates the need for manual configuration for each machine.

    1. Provision the machines: Once the site configurations are done, claim device ownership using the ownership voucher generated while preparing the device. Select the operating system profile for each machine.

3. **On-site setup**: When the devices arrive, the on-site staff only needs to connect them to the network and power them on. The device then automatically connects securely to a call home URL and gets fully configured from Azure. This configuration includes setting up the operating system and network settings, making the device ready for use. Optionally, on-site staff track the installation and configure the device by using the Configurator app.


## Prerequisites

### Hardware prerequisites:

- Supported hardware SKUs: Lenovo 650v3 and 650v4, HPE DL360 Gen 11, Dell AX-750/650.
- USB port on the server machine.
- Windows 11 PC with a reliable internet connection and a USB port.
- USB flash drive with at least 8 GB of space. Use a blank USB because the process deletes any existing content on the drive.

### On-site prerequisites:

- Go to **Azure Arc** > **Operations** > **Machine provisioning (preview)**. On the **Get started** page, select **View Downloads** to download the software to your Windows 11 PC. The software includes the maintenance environment ISO image, USB prep tool, and a configurator app. Use the app to download the ownership voucher and configure static IP address. On-site staff won't track the progress of machine setup.

### Azure prerequisites:

- Ensure the following resource providers are registered with your subscription:
  - *Microsoft.HybridCompute*
  - *Microsoft.GuestConfiguration*
  - *Microsoft.HybridConnectivity*
  - *Microsoft.Kubernetes*
  - *Microsoft.KubernetesConfiguration*
  - *Microsoft.ExtendedLocation*
  - *Microsoft.EdgeOrder*
  - *Microsoft.Edge*
  - *Microsoft.DeviceOnboarding*
  - *Microsoft.AzureStackHCI*
  - *Microsoft.HybridContainerService*
  - *Microsoft.ContainerService*

- In this preview release, only the **East US** region supports provisioning resource. You can create your resource group in your preferred region.

## Step 1: Create USB installation media

> [!NOTE]
> The tool erases all the data on the USB. Make sure to either use an empty USB or back up USB data.

Follow these steps to create a USB installation media from your Windows 11 PC:

1. Download and extract the software package for maintenance environment and USB prep tool.

1. Attach the USB flash drive with at least 8 GB of space. The process deletes any content on the flash drive.

1. Open the USB prep tool. This tool is included in the maintenance environment package that you download.  

1. Enter the full path that contains the ROE and press Enter.

1. When prompted, select which USB to use. Press 'Y' to erase and install ROE on the USB or press another key to abort the setup.

    > [!NOTE]
    > If you see the **Access is denied** error after USB selection, open **Windows Security settings**, located the blocked operation, and unblock it.

1. Wait for the media creation. <!--insert image-->

1. Eject and detach the USB flash drive.

## Step 2: Prepare server machines

Follow the steps to prepare server machines for simplified provisioning. Repeat this step for each machine.

1. Attach the USB flash drive to the server machine and power on the machine where you want to install Azure Local. 

    1. If your server machine doesn't automatically boot from the USB, you might need to open a boot menu or change the boot order in your server machine's BIOS or UEFI settings.

    1. To open a boot menu or change the boot order, press a key (such as F2, F12, Delete, or Esc) immediately after you turn on your machine. For instructions on accessing the boot menu or changing the boot order for your machine, check the documentation that came with your machine or go to the manufacturer's website.

    1. Additionally, ensure that Secure Boot and TPM are enabled.

1. Wait for the operating system installation to be completed. Expect the device to reboot twice. This process usually takes up to 30 minutes.

1. Wait for the maintenance environment setup to be completed. The console shows **ROE setup completed successfully**.

1. Detach the USB flash drive.

1. Repeat the same steps 1 to 4 on other server machines. 

1. Collect the ownership voucher for each of the machines by using either of the two options: 

    - **Download voucher via Configurator App**:  

        1. Open the Start menu, type Configurator App, select Configurator App for Azure Local V2,  and then select Run as administrator. 

        1. Connect to the device. Use the `ROE-<device serial number>.local` or IP address. Enter the local administrator’s credentials. The default username is *edgeuser*. The default password is *Password1*. 

        1. Download the ownership voucher. 

    - Or **copy voucher from USB flash drive**:

        1. Attach the USB flash drive to the Windows 11 PC, open the USB drive folder, and check for the following files under the USB drive folder.
        
        1. Open the folder `\vouchers\\`, find log files like bootstrap, messages, and response, check for any errors, and troubleshoot. If errors are found, contact Microsoft team.

        1. Collect the ownership voucher, a small .pem file named after the device’s serial number from `\vouchers\<serial-number>\` folder. The .pem files are small enough (a few KBs) that you can email them or use any other trusted transfer mechanism. Consider zipping multiple files together for convenience.

1. Recommendation: After setting up the machine, disable USB in BIOS. Enter BIOS/UEFI interface, locate USB Configuration, and set these options to disabled. Menu names might vary by device and BIOS/UEFI version.

## Step 3: Provision machines from Azure

1. Go to **Azure Arc** > **Operations** > **Provisioning (preview)**. On **Get started**, select **Provision** > **Azure Local** to provision Azure Local machines.

1. Create site. Make a note of the resource group name. Make sure that you're either the resource group owner or have the [Contributor](/azure/role-based-access-control/built-in-roles#contributor) and [Role Based Access Control Administrator](/azure/role-based-access-control/built-in-roles#role-based-access-control-administrator) permissions on the resource group where you provision the servers.

1. After creating the site, set up the provisioning configuration for your site. This configuration applies to all new machines under the site.

|Onboarding service     |  The Onboarding Service (in private preview) helps with zero-touch provisioning of the servers. Servers register into Azure automatically without human intervention. When powered on for the first time, servers contact the Onboarding Service endpoint for secure onboarding into Azure. 
|Onboarding service     |  The Onboarding Service (in private preview) helps with zero-touch provisioning of the servers. Servers registers into Azure automatically without human intervention. When powered on for the first time, servers contact the Onboarding Service endpoint for secure onboarding into Azure. 

    |Parameter  |Description  |
    |---------|---------|
    |Onboarding service     |  If you select **(New)** in this section, the provisioning process creates a new Onboarding service in the chosen subscription, resource group, and region.<br><br>You can also select an existing Onboarding Service if you created one before. <br><br>**Important**: The Onboarding Service instance must be in the same region as the target Azure Arc machine.  |
    |Time zone     | Select the common time zone for all the machines under the site. You can change it later. New machines use this time zone, but existing ones don't.       |
    |Time server    |  Enter the common time server for synchronized system time for all the machines under the site. You can change it later. New machines will use this time server, but existing ones won't.        |
    |IP assignment | Select the IP address assignment type for all machines at the site. Choose between DHCP or static IP addresses. If static, define the IP range, subnet mask, and default gateway IP address.<br><br>Define the IP assignment at the site level. This configures each machine with one IP address. After connecting to the local network using the IP address, each device connects to Azure and downloads the configuration. Configuring IP assignment at a site level simplifies connecting machines to the local network, avoiding manual IP address configuration for each machine.   |
    |Azure Arc connectivity | Select whether to connect via a public endpoint or a proxy server. If you use a public endpoint, devices connect directly to Azure Arc endpoints. If you use a proxy server, configure the proxy server and the list of addresses to bypass the proxy.<br><br> This simplifies the configuration where all the machines associated with this site use the same Azure Arc connectivity settings ensuring consistency.  |
    |Local administrator credentials    | Provide a username (for example, Administrator) and a password. The password must have at least 12 characters, include lower and upper-case characters, and include a digit and a special character.  |

    > [!NOTE]
    >  Support for Azure Arc gateway, which enables minimal endpoints connections to Azure Arc isn't supported in this preview. 

1. Select the Site, Software version, Azure Key Vault, Local administrator credentials and add vouchers from step 2. If you have an existing onboarding service, select it. 

1. Once machines are added, select the pencil button to edit. Provide the machine name as the Arc resource name.

1. On the **Review + create** tab, review details and select **Create**. 

1. Ensure that your on-site staff have racked, cabled, and booted the machines. Wait 15 minutes for Arc-enabled servers to be created and mandatory extensions to install. 

1. In the Azure portal, go to **Azure Arc** > **Operations** > **Provisioning (preview)**. 

1. On the **Devices** tab, you should see your machine provisioning status.

1. Select the machine and drill down into the server. Check status and other details.

When devices arrive, connect them to the network and power on. The device will automatically connect securely to a call home URL. It will then get fully configured from Azure. This includes setting up the operating system and network settings. The device is ready for use.

This process reduces setup time and expertise needed at remote sites. Configuration is all done from Azure. Use Azure ARM templates to provision servers at many remote sites. This makes the process quicker, repeatable, and scalable.

## Step 4: Monitor machine set up via app (optional)

> [!IMPORTANT]
> Skip this step if you're not using a static IP or you're not tracking server installation remotely. Start these steps a few minutes after powering on the server and connecting it to the local network.

Follow these steps to track the installation progress from your Windows 11 PC.

1. Open the **Start** menu, type **Configurator App**, and select **Configurator App for Azure Local V2**.

1. Use the device serial number or IP address. Enter the local administrator’s credentials. The default username is *edgeuser*. The default password is *Password1*.

1. Wait for the Azure Arc configuration to finish on maintenance environment. Post this, the target operating system from Step 2.16 will also install.

1. After installing the target operating system, use the IP address or hostname. Use the administrator credentials from Step 2.16. Wait for the configuration to finish.

1. Repeat all the steps on the other servers until the Arc configuration succeeds.

## Step 5: Verify Azure Arc connectivity

Confirm your machines are successfully connected to Azure. During the provisioning, each machine performs these steps: 

1. **Connect maintenance environment to cloud**: Establish an initial Azure connection using the device identity created from the ownership voucher. The device must authenticate successfully before continuing.

1. **Install extensions on maintenance environment**: Install mandatory Azure Arc extensions on the maintenance environment.

1. **Download and install Azure Local operating system**: One of the mandatory Azure Arc extensions installed on the maintenance environment will download the Azure Local operating system image selected in Step 3.4 and install the operating system.

1. **Azure Arc connect the Azure Local operating system**: After setup completes, the machine reboots into the Azure Local operation system and gets automatically connected to Azure Arc.

To monitor the provisioning machine status, follow the below steps:

1. In the Azure portal, navigate to **Azure Arc** > **Operations** > **Provisioning (preview)** > select the **Provisioned machines** tab.

1. Verify your machine's status in the provisioned machines list. Select a machine’s status to view progress details.

1. Wait for the machine status to show **Ready to cluster**.

## Troubleshooting

You might need to collect the logs or diagnose the problems if you encounter any issues while configuring the machine. You can use the following resources to troubleshoot:

- Run diagnostic tests. 
- Collect a support package. 
- Collect logs from your Azure Subscription.

### Run diagnostic tests from the Configurator app

To diagnose and troubleshoot any device issues related to hardware, time server, and network, you can run the diagnostics tests. Follow these steps to run the diagnostic tests from the app:

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane.

2. Select **Run diagnostic tests**. The diagnostic tests check the health of the server hardware, time server, and the network connectivity. The tests also check the status of the Azure Arc agent and the extensions. 

3. After the tests are completed, the results are displayed. Resolve the issues and retry the operation. 

### Collect a support package from the app

A log package is composed of all the relevant logs that can help Microsoft Support troubleshoot any device issues. You can generate a log package via the local web UI. Follow these steps to collect a support package from the app: 

1. Select the help icon in the top-right corner of the app to open the **Support + troubleshooting** pane.

1. Select **Create** to begin support package collection. The package collection could take several minutes. 

1. After the support package is created, select **Download**. A zipped package is downloaded on your local system. You can unzip the package and view the system log files.

### Collect logs from your Azure subscription

If you can't access the machine using Configurator App, you can get the app logs from the server. The logs are stored in the following location: Access logs by connecting via SSH for Azure Linux or PowerShell for Azure Stack HCI. 


|Target operating system  |Log files |
|---------|---------|
|Azure Stack HCI    |`C:\Windows\System32\Bootstrap\Logs`|
|Maintenance environment    |`/var/log/bootstrap`<br>`/var/log/provisioningextension`<br>`/var/log/trident-full.log`<br>`/var/log/messages`<br>`/var/log/bootstraprestservice`   |

If you can access the app, follow the instructions in [Run diagnostic tests](#run-diagnostic-tests-from-the-configurator-app) to troubleshoot the issue and then [Collect a support package](#collect-a-support-package-from-the-app) if needed.

## Next steps

After your machines are registered with Azure Arc, proceed to deploy your Azure Local instance via one of the following options: 

- [Deploy via Azure portal](../deploy/deploy-via-portal.md)
- [Deploy via Azure Resource Manager (ARM) template ](../deploy/deployment-azure-resource-manager-template.md)
