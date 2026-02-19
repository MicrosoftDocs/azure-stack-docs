---
title: Simplified Machine Provisioning for Azure Local (preview)
description: Lean how to use simplified machine provisioning for Azure Local (preview).
author: sipastak
ms.author: sipastak
ms.topic: how-to
ms.date: 02/03/2026
ms.subservice: hyperconverged
---

# Simplified machine provisioning for hyperconverged deployments of Azure Local (preview)

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

This article describes how to use simplified machine provisioning to set up machines for an Azure Local instance.

At a high level, there are three key stages:

:::image type="content" source="media/simplified-machine-provisioning/simplified-machine-provisioning-stages.png" alt-text="Diagram showing the three stages of simplified machine provisioning." border="false" lightbox="media/simplified-machine-provisioning/simplified-machine-provisioning-stages.png":::

1. **Prepare the machines**: Preparation ends with two artifacts: simplified machine provisioning software components installed on the device and generating an ownership voucher. Both artifacts need to be sent to the end customer. Anyone can prepare the devices, whether you're a device manufacturer, an integrator, or even an end customer, but the approach is most valuable when someone other than the on-site staff prepares the devices.

    Once the on-site staff has the prepared machines, the machines securely connect to the call-home URL and are automatically configured after provisioning from Azure, including OS setup and network configuration, so they’re ready to use. Optionally, the staff can monitor installation and configure devices using the Configurator app.

2. **Provision the machines from the Azure portal**:

    1. Set up site-level configuration: This configuration applies to all new machines under a site. This configuration includes settings like time zone, time server, proxy server, Azure Arc-gateway, Key vault for administrator credentials, and more. Site-level configuration eliminates the need for manual configuration for each machine.

    1. Provision the machines: Once the site configurations are done, claim machine ownership using the ownership voucher generated while preparing the machine. Select the operating system profile for each machine.

3. **Deploy the cluster using the provisioned machines**: You can now create an Azure Local instance using the provisioned machines.

## Prerequisites

### Hardware prerequisites

- Supported hardware SKUs:
  - Lenovo ThinkAgile MX650 V3 and MX650 V4
  - HPE ProLiant DL360 Gen11
  - Dell AX-750 and AX-650
- USB port on the server machine.
- Windows 11 PC with a reliable internet connection and a USB port.
- USB flash drive with at least 8 GB of space. Use a blank USB because the process deletes any existing content on the drive.

### On-site prerequisites

- Go to **Azure Arc** > **Operations** > **Machine provisioning (preview)**. On the **Get started** page, select **View Downloads** to download the software to your Windows 11 PC. The software includes the maintenance environment ISO image, USB prep tool, and a configurator app. A maintenance environment is a secure bootable OS that prepares a device for provisioning by generating the device ID and voucher for [FDO (Fido Device Onboard)](https://fidoalliance.org/device-onboarding-overview/).

- Use the Configurator app to download the ownership voucher, configure static IP address, and track the progress of machine setup.

### Azure prerequisites

- Register the MachineProvision feature for your subscription using the following command:

    ```azurecli
    az feature register --subscription <subcriptionid> --namespace Microsoft.DeviceOnboarding --name AzureLocalZTP
    ```

- After you've registered the MachineProvision feature, ensure the following [resource providers](/azure/azure-resource-manager/management/resource-providers-and-types#azure-portal) are registered with your subscription:

  - *Microsoft.HybridCompute*
  - *Microsoft.AzureStackHCI*
  - *Microsoft.DeviceOnboarding*
  - *Microsoft.Edge*
  - *Microsoft.GuestConfiguration*
  - *Microsoft.HybridCompute*
  - *Microsoft.HybridConnectivity*
  - *Microsoft.KeyVault*
  - *Microsoft.ManagedIdentity*
  - *Microsoft.PolicyInsights*
  - *Microsoft.Storage*
  - *Microsoft.Insights*

- In this preview release, only the **East US** region supports provisioning resource. You can create your resource group in your preferred region.

## Step 1: Create USB installation media

The USB tool is used to create a bootable USB drive that contains the required installation and provisioning content needed to start the device. It provides a Microsoft-supported, repeatable way to generate install-ready media for a more secure and reliable USB creation experience.

> [!NOTE]
> The tool erases all the data on the USB. Make sure to either use an empty USB or back up USB data.

Follow these steps to create a USB installation media from your Windows 11 PC:

1. [Download and extract the software package](#on-site-prerequisites) for the maintenance environment and USB prep tool. Attach the USB flash drive to your laptop.

1. Open the terminal. You need to be an administrator to run this tool.

1. Pre-approve the 'usb_prep.exe' in Windows Security.

    1. Open **Windows Security** > go to **Virus & threat protection** > select **Manage settings** > scroll to **Exclusions** > **Add an Exclusion** > **File** > select 'usb_prep.exe'.

    1. Or you can run the command: `Add-MpPreference -ExclusionPath "{PATH_TO_EXTRACTED_FOLDER}\usb_prep.exe`

1. Run the USB Preparation Tool from the downloaded software package.

    1. When prompted, enter the full path to the folder that contains the maintenance environment image ISO, then press the Enter key.

    1. Select the USB drive to use from the list of available devices.

    1. Press 'Y' to confirm and begin creating a bootable USB drive. Any content on the flash drive will be deleted.

    1. Wait for the tool to complete the media creation process.

1. When finished, safely eject and disconnect the USB flash drive.

## Step 2: Prepare server machines

Follow the steps to prepare server machines for simplified provisioning. Repeat this step for each machine.

1. Attach the USB flash drive to the server machine and power on the machine where you want to install Azure Local. 

    1. If your server machine doesn't automatically boot from the USB, you might need to open a boot menu or change the boot order in your server machine's BIOS or UEFI settings.

    1. To open a boot menu or change the boot order, press a key (such as F2, F12, Delete, or Esc) immediately after you turn on your machine. For instructions on accessing the boot menu or changing the boot order for your machine, check the documentation that came with your machine or go to the manufacturer's website.

    1. Additionally, ensure that Secure Boot and TPM are enabled.

1. Wait for the operating system installation to complete. Expect the device to reboot twice. This process usually takes up to 30 minutes.

1. Wait for the maintenance environment setup to be completed. The console shows **Maintenance environment setup completed successfully**.

1. You can safely detach the USB flash drive after the maintenance environment setup is complete.

1. Repeat the same steps 1 to 4 on other server machines. 

1. Collect the ownership voucher for each of the machines by using either of the two options: 

    - **Download voucher via Configurator App**:  

        1. Open the Start menu, type Configurator App, select **Configurator App for Azure Local V2**, and then select **Run as administrator**. 

        1. Connect to the machine. Use the `ROE-<device serial number>.local` or IP address. Enter the local administrator’s credentials. The default username is *edgeuser*. The default password is *Password1*.

        1. Download the ownership voucher and share it with your Azure IT administrator to continue machine setup.

    - Or **copy voucher from USB flash drive**:

        1. Attach the same USB flash drive from step 1 to the Windows 11 PC, open the USB drive folder, and check for the following files under the USB drive folder.
        
        1. Open the folder `\vouchers\<serial-number>\`, find log files, check for any errors, and troubleshoot. If errors are found, contact Microsoft Support.

        1. Collect the ownership voucher, a small .pem file named after the device’s serial number from `\vouchers\<serial-number>\` folder. Share the ownership voucher with the Azure portal IT administrator.

1. Recommendation: After setting up the machine, disable USB in BIOS. 

## Step 3: Provision machines from Azure

1. Go to **Azure Arc** > **Operations** > **Machine provisioning (preview)**. On **Get started**, select **Provision** to provision Azure Local machines.

1. Create site. Make a note of the resource group name. Make sure that you're either the [resource group owner](/azure/role-based-access-control/built-in-roles#owner) or have the [Contributor](/azure/role-based-access-control/built-in-roles#contributor) and [Role Based Access Control Administrator](/azure/role-based-access-control/built-in-roles#role-based-access-control-administrator) permissions on the resource group where you provision the servers.

    > [!NOTE]
    > The Azure portal creates the resource group under the **East US** region by default. If you want to create the resource group under a different region, see [Create resource groups](/azure/azure-resource-manager/management/manage-resource-groups-portal#create-resource-groups), and then select the created resource group here.

1. After creating the site, set up the provisioning configuration for your site. This configuration applies to all new machines under the site.

    |Parameter  |Description  |
    |---------|---------|
    |Time zone     | Select the common time zone for all the machines under the site. You can change it later. New machines use this time zone, but existing ones don't.       |
    |Time server    |  Enter the common time server for synchronized system time for all the machines under the site. You can change it later. New machines use this time server, but existing ones don't. |
    |Azure Arc connectivity | Select whether to connect via a public endpoint or a proxy server. If you use a public endpoint, devices connect directly to Azure Arc endpoints. If you use a proxy server, configure the proxy server and the list of addresses to bypass the proxy.<br><br> This simplifies the configuration where all the machines associated with this site use the same Azure Arc connectivity settings ensuring consistency. |
    |Local administrator credentials | Provide a username (for example, Administrator) and a password. The password must have at least 12 characters, include lower and upper-case characters, and include a digit and a special character.  |

1. Select the site, add vouchers from Step 2, software version, and local administrator credentials. The password must have at least 12 characters including lower and upper-case characters, a digit, and a special character.

1. Once you add machines, select the pencil button to edit. Provide the machine name as the Arc resource name.

1. On **Review + create**, review details and select **Create**.

1. Ensure that your on-site staff racked, cabled, and booted the machines. Wait 15 minutes for Arc-enabled servers to be created and mandatory extensions to install. 

1. In the Azure portal, go to **Azure Arc** > **Operations** > **Provisioning (preview)**. On the **Provisioned machines** tab, you should see your machine provisioning status.

1. Select the machine and drill down into the server. Check status and other details.

Ensure your on-site staff keeps the machine connected to the network and powered on. The machine automatically connects securely to a call-home URL, then gets fully configured from Azure. This configuration includes download of the Azure Stack HCI operating system, setting up the operating system, connecting the machine to Azure Arc, and installing all the mandatory Azure Arc extensions. The machine is ready for clustering.

This process reduces setup time and expertise needed at remote sites. Configuration is all done from Azure. Use Azure ARM templates to provision servers at many remote sites. This makes the process quicker, repeatable, and scalable.

## Step 4: Monitor machine set up via app (optional)

Follow these steps to track the installation progress from your Windows 11 PC.

1. Open the **Start** menu, type **Configurator App**, and select **Configurator App for Azure Local V2**.

1. Connect to the machine. Use the `ROE-<device serial number>.local` or IP address. Enter the local administrator’s credentials. The default username is *edgeuser*. The default password is *Password1*. 

1. Wait for the Azure Arc configuration to finish on maintenance environment. After this step, the Azure Stack HCI operating system from step 2 installs.

1. After installing the Azure Stack HCI operating system, use the IP address or hostname. Use the administrator credentials you configured while provisioning the machine. Wait for the configuration to finish.

1. Repeat all the steps on the other servers until the Arc configuration succeeds.

## Step 5: Verify Azure Arc connectivity

Confirm your machines connect to Azure. During provisioning, each machine performs these steps:

1. **Connect maintenance environment to cloud**: Establish an initial Azure connection using the device identity created from the ownership voucher. The device must authenticate successfully before continuing.

1. **Install extensions on maintenance environment**: Install mandatory Azure Arc extensions on the maintenance environment.

1. **Download and install Azure Local operating system**: One of the mandatory Azure Arc extensions installed on the maintenance environment downloads the Azure Local operating system image selected in Step 3.4 and installs the operating system.

1. **Azure Arc connect the Azure Local operating system**: After setup completes, the machine reboots into the Azure Local operation system and gets automatically connected to Azure Arc.

To monitor the provisioning machine status, follow these steps:

1. In the Azure portal, go to **Azure Arc** > **Operations** > **Provisioning (preview)** > select the **Provisioned machines** tab.

1. Check your machine's status in the provisioned machines list. Select a machine’s status to view progress details.

1. Wait for the machine status to show **Ready to cluster**.

## Next steps

After your machines are registered with Azure Arc, proceed to deploy your Azure Local instance via one of the following options: 

- [Deploy via Azure portal](../deploy/deploy-via-portal.md)
- [Deploy via Azure Resource Manager (ARM) template ](../deploy/deployment-azure-resource-manager-template.md)
