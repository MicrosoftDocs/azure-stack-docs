---
title: Install and Register Azure Local Machines using Simplified Machine Provisioning (preview)
description: Install and register Azure Local machines using simplified machine provisioning (preview).
author: sipastak
ms.author: sipastak
ms.topic: how-to
ms.date: 02/24/2026
ms.subservice: hyperconverged
---

# Install and register Azure Local machines by using simplified machine provisioning (preview)

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article describes how to use simplified machine provisioning to set up machines for an Azure Local instance. You can install the OS on your Azure Local machines in two distinct ways: you can manually install the OS using ISO images, or you can use the simplified machine provisioning process. 

This article covers only the installation and registration process by using simplified machine provisioning, which is currently in preview. To see the manual process, see [Install OS on your Azure Local machines using ISO images](./deployment-install-os.md).


## About simplified machine provisioning process

At a high level, there are three key stages:

:::image type="content" source="media/simplified-machine-provisioning/simplified-machine-provisioning-stages.png" alt-text="Diagram showing the three stages of simplified machine provisioning." border="true" lightbox="media/simplified-machine-provisioning/simplified-machine-provisioning-stages.png":::

1. **Prepare the machines**: Preparation ends with two artifacts: simplified machine provisioning software components installed on the machine and generating an ownership voucher, which meets [FIDO Device Onboarding (FDO)](https://fidoalliance.org/machine-onboarding-overview/) standards. Send both artifacts to the end customer. Anyone can prepare the machines, whether you're a machine manufacturer, an integrator, or even an end customer, but the approach is most valuable when someone other than the on-site staff prepares the machines.

    Once the on-site staff has the prepared machines, the machines securely connect to the call-home URL and are automatically configured after provisioning from Azure, including OS setup and network configuration, so they’re ready to use. Optionally, the staff can monitor installation and configure machines by using the Configurator app.

1. **Provision the machines from the Azure portal**:

    1. Set up site-level configuration: This configuration applies to all new machines under a site. This configuration includes settings like time zone, time server, proxy server, Azure Arc-gateway, Key vault for administrator credentials, and more. Site-level configuration eliminates the need for manual configuration for each machine.

    1. Provision the machines: Once the site configurations are done, claim machine ownership by using the ownership voucher generated while preparing the machine. Select the operating system profile for each machine.

1. **Deploy the cluster by using the provisioned machines**: You can now create an Azure Local instance using the provisioned machines.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

### Hardware prerequisites

- Microsoft-validated hardware SKUs:
  - Lenovo ThinkAgile MX650 V3 and MX650 V4
  - HPE ProLiant DL360 Gen11
  - Dell AX-750 and AX-650
- USB port on the machines.
- Windows 11 computer with a reliable internet connection and a USB port.
- USB flash drive with at least 8 GB of space.

### On-site prerequisites

- Satisfy the [Deployment prerequisites](./deployment-prerequisites.md).

- [Prepare your Active Directory](deployment-prep-active-directory.md) environment.

- Download software to your Windows 11 computer. 
    - Go to **Azure Arc** > **Azure Local** > **Get started**. 
    - On the **Get started** page, in the banner at the top of the page, select **Try provisioning (preview)**. 
    - On the **Machine provisioning (preview)** page, go to the **Download and install** tile and select **View Downloads** to download the software to your Windows 11 computer.
        
        The software includes the maintenance environment ISO image, USB preparation tool, and the Configurator app. A maintenance environment is a secure bootable OS that prepares a machine for provisioning by generating the device ID and voucher.

    :::image type="content" source="media/simplified-machine-provisioning/view-downloads.png" alt-text="Screenshot of the Azure portal showing how to view downloads." border="true" lightbox="media/simplified-machine-provisioning/view-downloads.png":::

- Use the Configurator app to download the ownership voucher, configure static IP address, and track the progress of machine setup.

### Azure prerequisites

- Register the machine provisioning feature for your subscription by using the following command:

    ```azurecli
    az feature register --subscription <subcriptionid> --namespace Microsoft.DeviceOnboarding --name AzureLocalZTP
    ```

- After you register the machine provisioning feature, ensure the following [resource providers](/azure/azure-resource-manager/management/resource-providers-and-types#azure-portal) are registered with your subscription:

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

- Ensure that you're either the [resource group owner](/azure/role-based-access-control/built-in-roles#owner) or you have the [Contributor](/azure/role-based-access-control/built-in-roles#contributor) and [Role Based Access Control Administrator](/azure/role-based-access-control/built-in-roles#role-based-access-control-administrator) permissions on the resource group where you provision the servers.

- In this preview release, only the **East US** region supports provisioning resource. You can create your resource group in your preferred region.

## Step 1: Create USB installation media

Use the USB tool to create a bootable USB drive that contains the required installation and provisioning content needed to start the machine. It provides a Microsoft-supported, repeatable way to generate install-ready media for a more secure and reliable USB creation experience.

> [!NOTE]
> The tool erases all the data on the USB. Make sure to either use an empty USB or back up USB data.

Follow these steps to create a USB installation media from your Windows 11 PC:

1. [Download and extract the software package](#on-site-prerequisites) for the maintenance environment and the USB preparation tool. Attach the USB flash drive to your laptop.

1. Open the terminal. You need to be an administrator to run this tool.

1. Pre-approve the `usb_prep.exe` in Windows Security.

    1. Go to **Windows Security** > **Virus & threat protection** and select **Manage settings**. Scroll to **Exclusions** > **Add an Exclusion** > **File** and select `usb_prep.exe`.

    1. Alternately, run the command: `Add-MpPreference -ExclusionPath "{PATH_TO_EXTRACTED_FOLDER}\usb_prep.exe`

1. Run the USB preparation tool from the downloaded software package.

    1. When prompted, enter the full path to the folder that contains the maintenance environment image ISO, and press **Enter**.  
    
    1. Select the USB drive to use from the list of available machines.

    1. Press 'Y' to confirm and begin creating a bootable USB drive. The process deletes any content on the flash drive.

    1. Wait for the tool to complete the media creation process.

1. When finished, safely eject and disconnect the USB flash drive.

## Step 2: Prepare machines

Follow the steps to prepare machines for simplified provisioning. Repeat this step for each machine.

1. Attach the USB flash drive to the server machine and power on the machine where you want to install Azure Local. 

    1. If your server machine doesn't automatically boot from the USB, you might need to open a boot menu or change the boot order in your server machine's BIOS or UEFI settings.

    1. To open a boot menu or change the boot order, press a key (such as F2, F12, Delete, or Esc) immediately after you turn on your machine. For instructions on accessing the boot menu or changing the boot order for your machine, check the documentation that came with your machine or go to the manufacturer's website.

    1. Additionally, ensure that Secure Boot and Trusted Platform Module (TPM) are enabled.

1. Wait for the maintenance environment setup to complete. The console shows **Maintenance environment setup completed successfully**. Expect the machine to reboot twice. This process usually takes up to 30 minutes.

1. You can safely detach the USB flash drive after the maintenance environment setup is complete.

1. Repeat all the preceding steps on other machines.

1. Collect the ownership voucher for each of the machines by using either of the two options:

    - **Download voucher via Configurator App**:  

        1. Open the **Start** menu and search for Configurator App. Select **Configurator App for Azure Local V2**, and then select **Run as administrator**.

        1. Connect to the machine. Use the `<machine serial number>.local` or IP address. Enter the local administrator credentials. The default username is *edgeuser*. The default password is *Password1*.

        1. Download the ownership voucher and share it with your Azure IT administrator to continue machine setup.

    - Or **copy voucher from USB flash drive**:

        1. Attach the same USB flash drive from step 1 to the Windows 11 PC, open the USB drive folder, and check for the following files under the USB drive folder.

        1. Collect the ownership voucher, a small `.pem` file named after the machine’s serial number from `\vouchers\<serial-number>\` folder. Share the ownership voucher with the Azure portal IT administrator.

    Disable the USB in BIOS after setting up the machine.

## Step 3: Provision machines from Azure

1. Go to **Azure Arc** > **Azure Local** > **Get started**. On the banner, select **Try provisioning (preview)**. On the **Machine provisioning (preview)** page, select **Provision** to provision Azure Local machines.

    :::image type="content" source="media/simplified-machine-provisioning/provision-machines.png" alt-text="Screenshot of the Azure portal showing where to select the Provision option." border="true" lightbox="media/simplified-machine-provisioning/provision-machines.png":::

1. Create site. Make a note of the resource group name.

1. After creating the site, set up the provisioning configuration for your site. This configuration applies to all new machines under the site.

    |Parameter  |Description  |
    |---------|---------|
    |Time zone     | Select the common time zone for all the machines under the site. You can change it later. New machines use this time zone, but existing ones don't.       |
    |Time server    |  Enter the common time server for synchronized system time for all the machines under the site. You can change it later. New machines use this time server, but existing ones don't. |
    |Azure Arc gateway | Either create or select your Azure Arc gateway resource instance. Azure Arc gateway enables minimal endpoints connections to Azure Arc. For more information, see [How to simplify network configuration requirements through Azure Arc gateway](/azure/azure-arc/servers/arc-gateway). |

1. Select the site, add vouchers from [Prepare machines](#step-2-prepare-machines), software version, and local administrator credentials. The password must have at least 12 characters including lower and upper-case characters, a digit, and a special character. Once you add machines, select the pencil button to edit. Provide the machine name as the Arc resource name.

    :::image type="content" source="media/simplified-machine-provisioning/provision-machines-portal.png" alt-text="Screenshot of the Azure portal showing the Provision new machines pane." border="true" lightbox="media/simplified-machine-provisioning/provision-machines-portal.png":::

1. On **Review + create**, review details and select **Create**.

In the Azure portal, go to **Azure Arc** > **Operations** > **Provisioning (preview)**. On the **Provisioned machines** tab, you see your machine provisioning status.

:::image type="content" source="media/simplified-machine-provisioning/machine-stages.png" alt-text="Screenshot of the Azure portal showing machine status." border="true" lightbox="media/simplified-machine-provisioning/machine-stages.png":::

Ensure that your on-site staff keeps the machine connected to the network and powered on. The machine automatically connects securely to a call-home URL, then gets fully configured from Azure. This configuration includes download of the Azure Stack HCI operating system, setting up the operating system, connecting the machine to Azure Arc, and installing all the mandatory Azure Arc extensions. The machine is ready for clustering.

This process reduces setup time and expertise needed at remote sites. All the configuration is done from Azure. Use Azure Resource Manager templates to provision servers at many remote sites. This makes the process quicker, repeatable, and scalable.

## Step 4: Monitor machine set up via app (optional)

Follow these steps to track the installation progress from your Windows 11 PC.

1. Open the **Start** menu, type **Configurator App**, and select **Configurator App for Azure Local V2**.

1. Connect to the machine. Use the `<machine serial number>.local` or IP address. Enter the local administrator credentials. The default username is *edgeuser*. The default password is *Password1*.

1. Wait for the Azure Arc configuration to finish on maintenance environment. After this step, the Azure Stack HCI operating system from [Provision machines from Azure](#step-3-provision-machines-from-azure) installs.

After installing the Azure Stack HCI operating system, use the `<machine serial number>.local` or IP address. Use the administrator credentials you configured while provisioning the machine. Wait for the configuration to finish and repeat all the steps on the other servers until the Arc configuration succeeds.

## Step 5: Verify Azure Arc connectivity

Confirm your machines connect to Azure. To monitor the provisioning machine status, follow these steps:

1. In the Azure portal, go to **Azure Arc** > **Operations** > **Provisioning (preview)** > select the **Provisioned machines** tab.

1. Check your machine's status in the provisioned machines list. Select a machine’s status to view progress details.

1. Wait for the machine status to show **Ready to cluster**.

:::image type="content" source="media/simplified-machine-provisioning/machine-status-details.png" alt-text="Screenshot of the Azure portal showing machine status details." border="true" lightbox="media/simplified-machine-provisioning/machine-status-details.png":::


## Next steps

- Set up [subscription permissions](deployment-arc-register-server-permissions.md) prior to deployment.
- Skip registration as this step already registered your Azure Local machines.
- Once you set up the permissions, deploy your Azure Local instance by using one of the following options:
  - [Deploy via Azure portal](../deploy/deploy-via-portal.md)
  - [Deploy via Azure Resource Manager (ARM) template](../deploy/deployment-azure-resource-manager-template.md)
