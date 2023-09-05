--- 
title: Discover Hyper-V VMs for migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the discovery phase for Hyper-V VM migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 09/05/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Discover Hyper-V VMs for migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the discovery phase for Hyper-V virtual machine (VM) migration to Azure Stack HCI using Azure Migrate.

[!INCLUDE [important](../../includes/hci-preview.md)]

For more information on appliances for Azure Migrate and how to manage them, see [Azure Migrate appliance](/azure/migrate/migrate-appliance).

## Step 1: Generate source appliance key

In this step, you generate a source key and download either a .zip file or .VHD file for the source appliance.

1. In the Azure portal, select **Servers, databases and webapps**, then select the migrate project you previously created.

1. On the **Servers, databases and webapps** page, under **Assessment tools > Azure Migrate Discovery and assessment**, select **Discover**.

    :::image type="content" source="media/discover/project-assessment-tools.png" alt-text="Screenshot of the Servers, databases and web apps page in Azure Migrate portal." lightbox="media/discover/project-assessment-tools.png":::

1. On the **Discover** page, select **Discover using appliance**, and then select the **Yes, with Hyper-V** option.

    :::image type="content" source="media/discover/download-source-appliance.png" alt-text="Screenshot of Download source appliance step." lightbox="media/discover/download-source-appliance.png":::

1. Under **Step 1: Generate project key**, enter a name for your appliance and then select **Generate key**. This may take a few minutes to generate the source key.

1. Copy and paste the key to Notepad (or other text editor) after it is generated for future use.

## Step 2: Download the appliance

You can download the appliance using either a .zip file or a .VHD file.

Under **Step 2: Download Azure Migrate appliance**, select either **.VHD file** or **.zip file**, and then select **Download**.

### Step 2a: Download using the .VHD file

This step applies only if you downloaded the .VHD file. You download the operating system (OS) VHD for the source appliance virtual machine (VM) to the source Hyper-V server. The source appliance is then installed for you.

1. Go to the [Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022), then select and download the Windows Server 2022 VHD file.

    :::image type="content" source="media/discover/source-os-download.png" alt-text="Screenshot of Download source VM OS VHD page." lightbox="media/discover/source-os-download.png":::

    > [!NOTE]
    > It is not a requirement to use the evaluation OS version - you can use your own VHD as long as the OS version is Windows Server 2022.

1. Create the appliance VM on the Hyper-V server using the ISO just downloaded. Complete the **New Virtual Machine Wizard** using the following configuration:

    - VM name
    - VM location
    - **VM type**: `Standalone` (non-High Availability type)
    - **Operating System**: Windows Server 2022
    - **Disk**: 80GB (min)
    - **Memory**: 16GB (min)
    
    For more information on using Hyper-V Manager to create a VM , see [Create a virtual machine](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine).

1. In **Hyper-V Manager**, on the **Settings** page, set the **Number of virtual processors** to `8`.
    
    :::image type="content" source="media/discover/vcpu-settings.png" alt-text="Screenshot of vCPU Settings dialog." lightbox="media/discover/vcpu-settings.png":::

1. Create a virtual hard disk for the VM and specify a location for it.

    > [!NOTE]
    > Make sure that you create the appliance VM as a non-high availability VM.

1. Once the VM is created, sign in to it using **Virtual Machine Connection**.

1. In  **Hyper-V Manager**, select the host.

1. Under **Hyper-V settings**, select **Enhanced Session Mode Policy** and ensure **Allow enhanced session mode** is enabled.

    :::image type="content" source="media/discover/enhanced-session-mode.png" alt-text="Screenshot of Enhanced Session Mode dialog." lightbox="media/discover/enhanced-session-mode.png":::

    For more information on Enhanced Session Mode, see [Turn on enhanced session mode on a Hyper-V host](/windows-server/virtualization/hyper-v/learn-more/use-local-resources-on-hyper-v-virtual-machine-with-vmconnect#turn-on-enhanced-session-mode-on-a-hyper-v-host)

### Step 2b: Download using the .zip file

This step applies only if you downloaded the .zip file. You download the operating system (OS) ISO for the source appliance virtual machine (VM) to the source Hyper-V server. Then you use a PowerShell script to install the source appliance.

1. Go to the [Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022), then select and download the Windows Server 2022 ISO file.

    :::image type="content" source="media/discover/source-os-download.png" alt-text="Screenshot of Download source VM OS page." lightbox="media/discover/source-os-download.png":::

    > [!NOTE]
    > It is not a requirement to use the evaluation OS version - you can use your own ISO image as long as the OS version is Windows Server 2022.

1. On the source Hyper-V server, open **Hyper-V Manager** and select the server listed.

1. Under **Actions** on the right, select **New > Virtual machine**.

1. Select the install OS from **image file** option and select the downloaded ISO.

1. Create the new appliance VM on the Hyper-V server using the ISO just downloaded. Complete the **New Virtual Machine Wizard** using the following configuration:

    - VM name
    - VM location
    - **VM type**: `Standalone` (non-High Availability type)
    - **Operating System**: Windows Server 2022
    - **Disk**: 80GB (min)
    - **Memory**: 16GB (min)
    
    For more information on using Hyper-V Manager to create a VM , see [Create a virtual machine](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine).

1. In **Hyper-V Manager**, on the **Settings** page, set the **Number of virtual processors** to `8`.
    
    :::image type="content" source="media/discover/vcpu-settings.png" alt-text="Screenshot of vCPU Settings dialog." lightbox="media/discover/vcpu-settings.png":::

1. Create a virtual hard disk for the VM and specify a location for it.

    > [!NOTE]
    > Make sure that you create the appliance VM as a non-high availability VM.

1. Once the VM is created, sign in to it using **Virtual Machine Connection**.

1. Select the OS you just downloaded (Windows Server 2022) and begin OS set up.

1. Once the OS is finished installing, enter your local administrative credentials, then sign in using them.

1. In  **Hyper-V Manager**, select the host.

1. Under **Hyper-V settings**, select **Enhanced Session Mode Policy** and ensure **Allow enhanced session mode** is enabled.

    :::image type="content" source="media/discover/enhanced-session-mode.png" alt-text="Screenshot of Enhanced Session Mode dialog." lightbox="media/discover/enhanced-session-mode.png":::

    For more information on Enhanced Session Mode, see [Turn on enhanced session mode on a Hyper-V host](/windows-server/virtualization/hyper-v/learn-more/use-local-resources-on-hyper-v-virtual-machine-with-vmconnect#turn-on-enhanced-session-mode-on-a-hyper-v-host)

1. Open **Server Manager** on the Hyper-V server.

1. Copy and paste the downloaded .zip file to the VM virtual disk that you created and extract it as needed.

1. As an administrator, run the following PowerShell script from the folder of the downloaded file to install the source appliance:

  ```PowerShell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    .\AzureMigrateInstaller.ps1 -Scenario HyperV -Cloud Public -PrivateEndpoint:$false
  ``````

1. When prompted, select **Y** to do the following:
    - Install the source appliance bits.
    - Install the Edge browser.
    - Remove Internet Explorer.

1. Restart and sign into the VM.

## Step 3: Configure source appliance and discover VMs

1. In **Server Manager**, sign in to the source appliance VM.

1. Open **Azure Migrate Appliance Configuration Manager** from the desktop shortcut created after installation.

1. Locate the source key that you previously generated, paste it in the field under **Verification of Azure Migrate project key**, then select **Verify**.

    :::image type="content" source="media/discover/paste-key.png" alt-text="Screenshot of Appliance Configuration Manager showing pasted source key." lightbox="media/discover/paste-key.png":::

1. Once verified, select **Log in** and sign in to your Azure account using those account credentials.

    :::image type="content" source="media/discover/key-verified.png" alt-text="Screenshot showing source key has been verified." lightbox="media/discover/key-verified.png":::

1. When prompted, enter the code that is displayed in your mobile device for multi-factor authentication (MFA).

    :::image type="content" source="media/discover/enter-code.png" alt-text="Screenshot showing Enter code popup." lightbox="media/discover/key-verified.png":::

1. Sign in to Microsoft Azure PowerShell using the code displayed in your Authenticator (or similar) app.

    :::image type="content" source="media/discover/enter-code2.png" alt-text="Screenshot showing device code for PowerShell sign in." lightbox="media/discover/key-verified.png":::

1. The appliance may take up to 10 minutes to be registered. Once registered, select **Add credentials** and enter your Hyper-V source host credentials to allow discovery of your source VMs.

1. Select **Add discovery source** and enter discovery source, IP address, and Map credentials.

1. Select **Add cluster information** and enter the fully-qualified domain name (FQDN), domain name, username, and password information for each server or cluster node that you want to discover VMs from.

    :::image type="content" source="media/discover/add-cluster-info2.png" alt-text="Screenshot showing cluster information popup." lightbox="media/discover/key-verified.png":::

1. Enter the name and credentials of the target Azure Stack HCI cluster.

1. Disable the slider under **Step 4: Provide server credentials to perform software inventory...**.

1. Select **Start Discovery**.

1. Wait until you have a green checkmark indicating discovery is completed successfully, then go to the Azure portal to review inventory.

## Next steps

- Start [Replication](migrate-hyperv-discover.md).
