--- 
title: Discovery for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the discovery process for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 07/26/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Discovery for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-21h2.md)]

This article describes the discovery process for Hyper-V migration to Azure Stack HCI using Azure Migrate.

## Step 1: Generate source appliance key and download the appliance

In this step, you generate a key and download the .zip file for the source appliance.

:::image type="content" source="media/discover-placeholder.png" alt-text="Screenshot of Discover page in Azure portal." lightbox="media/discover-placeholder.png":::

1. Go to the [Azure Preview Portal](https://aka.ms/HCIMigratePP).

1. Select **Azure Migrate**, then select **Servers, databases and web apps** on the **Get started** page.

On the **Servers, databases and web apps** on the **Get started** page, select the project you previously created.

1. Under **Azure Migrate: Discovery and assessment**, select **Discover**.

1. On the **Discover** page, select **Discover using appliance** and then select the **Yes, with Hyper-V** option.

1. Under **Generate project key**, enter a name for your appliance and then select **Generate key**. This may take a few minutes.

1. Copy and paste the key to Notepad (or other text editor) after it is generated for easy future reference.

1. Under **Download Azure Migrate appliance**, select **.zip file**, and then select **Download**.

> [!NOTE]
> The actual size of the .zip file is ~500MB - there is a known issue that it is shown as 120MB in Azure portal.

## Step 2: Install source appliance VM OS

In this step, you download the operating system (OS) ISO for the source appliance virtual machine (VM) on the source cluster.

1. Go to the [Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2016), then select and download the applicable Windows Server 2016 ISO for the VM.

    > [!NOTE]
    > It is not a requirement to use the evaluation OS version - you can use you own corporate ISO images as long as the OS version is Windows Server 2016.

1. Open **Hyper-V Manager** and select your source cluster.

1. Under **Actions** on the right, select **New > Virtual machine**.

1. Step through the **New Virtual Machine Wizard**, specifying the following:

    - VM name
    - VM location
    - **Memory**: 16GB min
    - **Connection**: ExternalSwitch
    - **VM type**: `Standalone` (non-HA)
    - **Operating System**: Windows Server 2016
    - **vCPU**: 8
    - **Disk**: >80GB
 
1. Create a virtual hard disk and specify a location for it.

1. Select the install OS from **image file** option and select the downloaded ISO.

1. Create a new appliance virtual machine (VM) in the source cluster using the ISO just downloaded. Complete the **New Virtual Machine Wizard** with the following configuration:

    - **VM type**: `Standalone` (non-HA type)
    - **Operating System**: Windows Server 2016
    - **vCPU**: 8
    - **Disk**: >80GB
    - **Memory**: 16GB min
    
    > [!NOTE]
    > Appliance VM shouldn’t be migrated if you create it as an HA VM. Azure Migrate will discover this VM type as a potential VM to be migrated and display it during the discovery process.

1. Once the VM is created, sign in to it using **Virtual Machine Connection**.

1. Select the OS you just downloaded and begin OS set up.

1. Once the OS is finished installing, specify the local administrative credentials, then sign in using them.

1. Open **Hyper-V Manager** and select the VM just created.

1. Under **Hyper-V settings**, select **Enhanced Session Mode Policy** and ensure **Allow enhanced session mode** is enabled.


## Step 3: Install source appliance bits

1. Open Server Manager.

1. Copy and paste the downloaded .zip file in **Step 2: Create source appliance VM** to the VM that you just created and extract it.

1. As an administrator, run the following PowerShell script from the folder of the extracted .zip file:

    ~~~PowerShell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted .\AzureMigrateInstaller.ps1 - DisableAutoUpdate -Scenario HyperV -Cloud Public -PrivateEndpoint:$false -EnableAzureStackHCITarget
    ~~~

1. When prompted, select **Y** to do the following:
    - Install source appliance bits
    - Install the Edge browser
    - Remove Internet Explorer

1. Restart and sign into the VM.

## Step 4: Configure source appliance and discover VMs

1. Open **Server Manager** and sign on to the source appliance VM.

1. Open the source appliance **Azure Configuration Manager** from the desktop shortcut.

1. Locate the source key that you previously generated, paste it in the field under **Verification of Azure Migrate project key**, then select **Verify**.

1. Once verified, select **Log in** and sign in to your Azure account using those account credentials. Enter the code that is displayed in your device for MFA authentication.

1. Sign in to Microsoft Azure PowerShell using the code displayed in your Authenticator (or similar) app.

1. It can up to 10 minutes for you appliance to be registered. Once the appliance is registered, select ***Add credentials** and enter your Hyper-V source host credentials to allow discovery of your source VMs.

1. Select **Add discovery source** and enter discovery source, IP address, and Map credentials.

1. Select **Add cluster information** and enter cluster FQDN, domain,username, and password information for each cluster that you want to discover VMs from.

1. Enter the name and credentials of the target (HCI) cluster.

1. Disable the slider under **Step 4: Provide server credentials to perform software inventory...**.

1. Select **Start Discovery**.

1. Wait until you have a green checkmark indicating discovery is completed successfully, then go to the Azure portal to review inventory

## Next steps

- Start [Replication](migrate-hyperv-discover.md).
