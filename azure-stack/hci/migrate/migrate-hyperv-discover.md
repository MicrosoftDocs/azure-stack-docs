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

:::image type="content" source="media/discover-placeholder.png" alt-text="Screenshot of Discover page in Azure portal." lightbox="media/discover-placeholder.png":::

1. Go to the [Azure Preview Portal](https://aka.ms/HCIMigratePP).

1. Select **Azure Migrate**, then select **Servers, databases and web apps**.

1. Under **Azure Migrate: Discovery and assessment**, select **Discover**.

1. On the **Discover** page, select **Yes, with Hyper-V**.

1. Under **Generate project key**, enter a name for your appliance and select **Generate key**. This may take a few minutes.

1. Copy and paste the key to Notepad (or other text editor) after it is generated.

1. Under **Download Azure Migrate appliance**, select **.zip file**, and then select **Download**.

> [!NOTE]
> The actual size is ~500MB - there is a known issue that it is shown as 120MB in Azure portal.

## Step 2: Create source appliance VM

1. Go to the [Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2016) and download the applicable Windows Server 2016 operating system ISO.

1. Open **Hyper-V Manager** and select the applicable source cluster.

1. Create a new appliance virtual machine (VM) in the source cluster using the ISO just downloaded. Complete the **New Virtual Machine Wizard** with the following configuration:

    - **VM type**: `Standalone` (non-HA)
    - **Operating System**: Windows Server 2016
    - **vCPU**: 8
    - **Disk**: >80GB
    - **Memory**: 16GB min

2. Once created, sign in to the new VM using **Virtual Machine Connection** and verify everything is set up correctly.

> [!NOTE]
> Appliance VM shouldn’t be migrated if you create it as an HA-VM. Azure Migrate will discover this VM as a potential VM to be migrated and display in discovery.

> [!NOTE]
> It is not a requirement to use the evaluation version - you can use you own corporate ISO images as long as the OS version is Windows Server 2016.


## Step 3: Download source appliance bits and install

1. Open Server Manager.

1. Copy and paste the downloaded .zip file in **Step 2: Create source appliance VM** to the VM that you just created and extract it.

1. As an administrator, run the following PowerShell command from the folder of the extracted .zip file:

    ~~~PowerShell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted .\AzureMigrateInstaller.ps1 - DisableAutoUpdate -Scenario HyperV -Cloud Public -PrivateEndpoint:$false -EnableAzureStackHCITarget
    ~~~

1. When prompted, select **Y** to do the following:
    - Install the source appliance
    - Install the Edge browser
    - Remove Internet Explorer

1. Restart and sign into the VM.

## Step 4: Configure source appliance and discover VMs

1. Open **Server Manager** and sign on to the source appliance VM.

1. Open **Azure Configuration Manager** from the desktop shortcut.

1. Locate the key that you previously generated and enter it for verification.

1. Once verified, select **Log in** and sign on with your credentials.

1. Once the appliance is registered, select ***Add credentials** and enter your Hyper-V source host credentials to allow discovery of your source VMs.

1. Select **Add discovery source** and enter discovery source, IP address, and Map credentials.

1. Select **Add cluster information** and enter cluster FQDN, domain,username, and password information for each cluster that you want to discover VMs from.

1. Enter the name and credentials of the target (HCI) cluster.

1. Disable the slider under **Step 4: Provide server credentials to perform software inventory...**.

1. Select **Start Discovery**.

1. Wait until you have a green checkmark indicating discovery is completed successfully.

## Next steps

- Start [Replication](migrate-prerequisites.md).
