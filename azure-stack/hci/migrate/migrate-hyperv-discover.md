--- 
title: Discover Hyper-V VM migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the discovery process for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 08/11/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Discover Hyper-V VM migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the discovery process for Hyper-V virtual machine (VM) migration to Azure Stack HCI using Azure Migrate.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Before you begin

Before the discovery process takes place, make sure you have satisfied all requirements and [prerequisites](migrate-hyperv-discover.md).

## Step 1: Generate source appliance key and download the appliance

In this step, you generate a key and download the .zip file for the source appliance.

1. Go to the [Azure portal](https://aka.ms/HCIMigratePP)  and select **Azure Migrate**.

    :::image type="content" source="media/project-get-started.png" alt-text="Screenshot of the Get Started page in Azure Migrate portal." lightbox="media/project-get-started.png":::

1. Select **Servers, databases and web apps** and then select the migrate project you previously created.

    :::image type="content" source="media/project-assessment-tools.png" alt-text="Screenshot of the Servers, databases and web apps page in Azure Migrate portal." lightbox="media/project-assessment-tools.png":::

1. Under **Migration tools > Migration and modernization**, select **Discover**.

1. On the **Discover** page, select **Discover using appliance** and then select the **Yes, with Hyper-V** option.

    :::image type="content" source="media/download-source-appliance.png" alt-text="Screenshot of Download source appliance step." lightbox="media/download-source-appliance.png":::

1. Under **Step 1: Generate project key**, enter a name for your appliance and then select **Generate key**. This may take a few minutes.

1. Copy and paste the key to Notepad (or other text editor) after it is generated for easy future reference.

1. Under **Step 2: Download Azure Migrate appliance**, select **.zip file**, and then select **Download**.

## Step 2: Install source appliance VM OS

In this step, you download the operating system (OS) ISO for the source appliance virtual machine (VM) on the source cluster.

1. Go to the [Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2016), then select and download the applicable Windows Server 2016 ISO for the VM.

    :::image type="content" source="media/source-os-download.png" alt-text="Screenshot of Download source VM OS page  ." lightbox="media/source-os-download.png":::

    > [!NOTE]
    > It is not a requirement to use the evaluation OS version - you can use you own corporate ISO images as long as the OS version is Windows Server 2016.

1. On the source Hyper-V server, open **Hyper-V Manager** and select your source cluster.

1. Under **Actions** on the right, select **New > Virtual machine**.

1. Select the install OS from **image file** option and select the downloaded ISO.

1. Create the new appliance VM in the source cluster using the ISO just downloaded. Step through the **New Virtual Machine Wizard** with the following configuration:

    - VM name
    - VM location
    - **Memory**: 16GB min
    - **VM type**: `Standalone` (non-High Availability type)
    - **Operating System**: Windows Server 2016
    - **vCPU**: 8
    - **Disk**: >80GB
    - **Memory**: 16GB min
 
1. Create a virtual hard disk and specify a location for it.

    > [!NOTE]
    > An appliance VM shouldn’t be migrated if you create it as a High Availability VM. Azure Migrate will discover this VM type to be migrated and display it during the discovery process.

1. Once the VM is created, sign in to it using **Virtual Machine Connection**.

1. Select the OS you just downloaded (Windows Server 2016) and begin OS set up.

1. Once the OS is finished installing, enter your local administrative credentials, then sign in using them.

1. Open **Hyper-V Manager** and select the VM just created.

1. Under **Hyper-V settings**, select **Enhanced Session Mode Policy** and ensure **Allow enhanced session mode** is enabled.

## Step 3: Install source appliance bits

1. On the Hyper-V server, open Server Manager.

1. Copy and paste the downloaded .zip file in **Step 2: Create source appliance VM** to the VM that you just created and extract it.

1. As an administrator, run the following PowerShell script from the folder of the extracted .zip file:

  ```PowerShell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted .\AzureMigrateInstaller.ps1 - DisableAutoUpdate -Scenario HyperV -Cloud Public -PrivateEndpoint:$false -EnableAzureStackHCITarget
  ``````

1. When prompted, select **Y** to do the following:
    - Install source appliance bits.
    - Install the Edge browser.
    - Remove Internet Explorer.

1. Restart and sign into the VM.

## Step 4: Configure source appliance and discover VMs

1. Open **Server Manager** and sign on to the source appliance VM.

1. Open **Azure Migrate Appliance Configuration Manager** from the desktop shortcut created after installation.

1. Locate the source key that you previously generated, paste it in the field under **Verification of Azure Migrate project key**, then select **Verify**.

    :::image type="content" source="media/paste-key.png" alt-text="Screenshot of Appliance Configuration Manager showing pasted source key." lightbox="media/paste-key.png":::

1. Once verified, select **Log in** and sign in to your Azure account using those account credentials.

    :::image type="content" source="media/key-verified.png" alt-text="Screenshot showing source key has been verified." lightbox="media/key-verified.png":::

1. When prompted, enter the code that is displayed in your mobile device for MFA authentication.

    :::image type="content" source="media/enter-code.png" alt-text="Screenshot showing Enter code popup." lightbox="media/key-verified.png":::

1. Sign in to Microsoft Azure PowerShell using the code displayed in your Authenticator (or similar) app.

    :::image type="content" source="media/enter-code2.png" alt-text="Screenshot showing device code field for sign in." lightbox="media/key-verified.png":::

1. It can up to 10 minutes for the appliance to be registered. Once registered, select **Add credentials** and enter your Hyper-V source host credentials to allow discovery of your source VMs.

1. Select **Add discovery source** and enter discovery source, IP address, and Map credentials.

1. Select **Add cluster information** and enter cluster FQDN, domain,username, and password information for each cluster that you want to discover VMs from.

    :::image type="content" source="media/add-cluster-info2.png" alt-text="Screenshot showing device code field for sign in." lightbox="media/key-verified.png":::

1. Enter the name and credentials of the target (HCI) cluster.

1. Disable the slider under **Step 4: Provide server credentials to perform software inventory...**.

1. Select **Start Discovery**.

1. Wait until you have a green checkmark indicating discovery is completed successfully, then go to the Azure portal to review inventory.

## Next steps

- Start [Replication](migrate-hyperv-discover.md).
