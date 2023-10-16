--- 
title: Discover Hyper-V VMs for migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the discovery phase for Hyper-V VM migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 09/14/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Discover Hyper-V VMs for migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the discovery phase for Hyper-V virtual machine (VM) migration to Azure Stack HCI using Azure Migrate.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Step 1: Generate source appliance key

In this step, you generate a source key and download either a .zip file or .VHD file for the source appliance.

1. In the Azure portal, select **Servers, databases and webapps**, then select the migrate project you previously created.

1. On the **Servers, databases and webapps** page, under **Assessment tools > Azure Migrate Discovery and assessment**, select **Discover**.

    :::image type="content" source="media/migrate-discover/project-assessment-tools.png" alt-text="Screenshot of the Servers, databases and web apps page in Azure Migrate portal." lightbox="media/migrate-discover/project-assessment-tools.png":::

1. On the **Discover** page, select **Discover using appliance**, and then select the **Yes, with Hyper-V** option.

    :::image type="content" source="media/migrate-discover/download-source-appliance.png" alt-text="Screenshot of Download source appliance step." lightbox="media/migrate-discover/download-source-appliance.png":::

1. Under **Step 1: Generate project key**, enter a name for your appliance and then select **Generate key**. This may take a few minutes to generate the source key.

1. Copy and paste the key to Notepad or other text editor after it is generated for future use.

## Step 2: Download and install the appliance

You can download the appliance using either a .VHD file or a .zip file. For more information on appliances for Azure Migrate and how to manage them, see [Azure Migrate appliance](/azure/migrate/migrate-appliance).

Under **Step 2: Download Azure Migrate appliance**, select either **.VHD file** or **.zip file**, and then select **Download**.

:::image type="content" source="media/migrate-discover/download-source-appliance-2.png" alt-text="Screenshot of Download source appliance step 2." lightbox="media/migrate-discover/download-source-appliance-2.png":::

### Step 2a: Download using the .VHD file option

This step applies only if you downloaded the .VHD file. The source appliance is installed for you using the .VHD file.

1. Install Windows Server 2022 from an ISO image on the source Hyper-V server.

1. Using **Hyper-V Manager**, create a new VM on the Hyper-V server using the following configuration:

    - **VM type**: `Standalone` (non-High Availability type)
    - **Operating System**: Windows Server 2022
    - **Disk**: 80GB (min)
    - **Memory**: 16GB (min)
    
1. Stop the VM if it is running. Then on the **Settings** page, set the **Number of virtual processors** to `8`.

 
    :::image type="content" source="media/migrate-discover/virtual-central-processing-unit-settings.png" alt-text="Screenshot of vCPU Settings dialog." lightbox="media/migrate-discover/virtual-central-processing-unit-settings.png":::

1. Create a virtual hard disk for the VM and specify a location for it.

    > [!NOTE]
    > Make sure that you create the appliance VM as a non-high availability VM.

1. Once the VM is created, sign in to it using **Virtual Machine Connection**.

1. In  **Hyper-V Manager**, select the host.

1. Under **Hyper-V settings**, select **Enhanced Session Mode Policy** and ensure **Allow enhanced session mode** is enabled.

    :::image type="content" source="media/migrate-discover/enhanced-session-mode.png" alt-text="Screenshot of Enhanced Session Mode dialog." lightbox="media/migrate-discover/enhanced-session-mode.png":::

    For more information on Enhanced Session Mode, see [Turn on enhanced session mode on a Hyper-V host](/windows-server/virtualization/hyper-v/learn-more/use-local-resources-on-hyper-v-virtual-machine-with-vmconnect#turn-on-enhanced-session-mode-on-a-hyper-v-host).

### Step 2b: Download using the .zip file option

This step applies only if you downloaded the .zip file. You use the *AzureMigrateInstaller.ps1* PowerShell script to install the source appliance.

1. Install Windows Server 2022 from an ISO image on the source Hyper-V server.

1. Using **Hyper-V Manager**, create a new VM on the Hyper-V server using the following configuration:

    - **VM type**: `Standalone` (non-High Availability type)
    - **Operating System**: Windows Server 2022
    - **Disk**: 80GB (min)
    - **Memory**: 16GB (min)
    
1. Stop the VM if it is running. Then on the **Settings** page, set the **Number of virtual processors** to `8`.

    :::image type="content" source="media/migrate-discover/virtual-central-processing-unit-settings.png" alt-text="Screenshot of vCPU Settings dialog." lightbox="media/migrate-discover/virtual-central-processing-unit-settings.png":::

1. Create a virtual hard disk for the VM and specify a location for it.

    > [!NOTE]
    > Make sure that you create the appliance VM as a non-high availability VM.

1. Once the VM is created, sign in to it using **Virtual Machine Connection**.

1. Select the OS you just downloaded (Windows Server 2022) and begin OS setup.

1. Once the OS is finished installing, enter your local administrative credentials, then sign in using them.

1. In  **Hyper-V Manager**, select the host.

1. Under **Hyper-V settings**, select **Enhanced Session Mode Policy** and ensure **Allow enhanced session mode** is enabled.

    :::image type="content" source="media/migrate-discover/enhanced-session-mode.png" alt-text="Screenshot of Enhanced Session Mode dialog." lightbox="media/migrate-discover/enhanced-session-mode.png":::

    For more information on Enhanced Session Mode, see [Turn on enhanced session mode on a Hyper-V host](/windows-server/virtualization/hyper-v/learn-more/use-local-resources-on-hyper-v-virtual-machine-with-vmconnect#turn-on-enhanced-session-mode-on-a-hyper-v-host).

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

    :::image type="content" source="media/migrate-discover/paste-key.png" alt-text="Screenshot of Appliance Configuration Manager showing pasted source key." lightbox="media/migrate-discover/paste-key.png":::

1. Once verified, select **Log in** and sign in to your Azure account using those account credentials.

    :::image type="content" source="media/migrate-discover/key-verified.png" alt-text="Screenshot showing source key has been verified." lightbox="media/migrate-discover/key-verified.png":::

1. When prompted, enter the code that is displayed in your mobile device for multi-factor authentication (MFA).

    :::image type="content" source="media/migrate-discover/enter-code.png" alt-text="Screenshot showing Enter code popup." lightbox="media/migrate-discover/key-verified.png":::

1. Sign in to Microsoft Azure PowerShell using the code displayed in your Authenticator (or similar) app. It can take up to 10 minutes for the appliance to be registered.

    :::image type="content" source="media/migrate-discover/enter-code-2.png" alt-text="Screenshot showing device code for PowerShell sign in." lightbox="media/migrate-discover/enter-code-2.png":::

1. Select **Add discovery source** and enter discovery source, IP address, and credentials.

1. Disable the slider under **Step 4: Provide server credentials to perform software inventory...**.

1. Select **Start Discovery**.

1. Wait until you have a green checkmark indicating discovery is completed successfully, then go to the Azure portal to review inventory.

## Next steps

- Start [Replication](migrate-hyperv-replicate.md).
