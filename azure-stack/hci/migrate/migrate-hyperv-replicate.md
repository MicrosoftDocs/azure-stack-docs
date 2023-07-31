--- 
title: Replicate Hyper-V migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the replication process for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 07/31/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Replicate Hyper-V migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes the replication process for Hyper-V migration to Azure Stack HCI using Azure Migrate.

## Start Replication Wizard and Generate Target Appliance Key

Complete the following tasks before you proceed with migration:

:::image type="content" source="../media/create-project.png" alt-text="Screenshot showing project creation." lightbox="../media/create-project.png":::

1. Go to the [Azure portal](https://aka.ms/HCIMigratePP). Make sure that you see the number of **Discovered servers** in **Azure Migrate: Discovery and assessment**.

1. Under **Migration tools** card, select **Replicate**.

1. In **Specify intent** select:
    - Servers or virtual machines (VM)
    - Azure Stack HCI
    - Hyper-V
    - <name of  your source appliance> (should pre-populate)

1. Select **Download and configure** in the information bubble.

1. Provide a name for the target appliance, then select **Generate key**.

1. Once the target key is generated save it to Notepad or other text editor for future use.

## Create the Target Appliance VM

Next you create a new VM on the target Azure Stack HCI cluster.

To connect to the target appliance VM on the Azure Stack HCI server, add the HCI cluster to Hyper-V Manager on your source cluster using the option **Connect to Server**, or use Windows Admin Center.

To copy and paste the .zip file to the VM, enable **Enhanced Session Mode** under **Hyper-V settings**.

1. Make sure the following are true:
    - **Operating System**: Windows Server 2022 (downloaded eval version)1
    - **vCPU**: 8
    - **Disk**: >80GB
    - **Memory**: 16GB

1. Sign on to the newly created VM.

## Install target appliance bits

The target appliance and the source appliance use the same .zip file, so no need to download it again.

1. Copy and paste the .zip file locally to the target appliance VM and extract it.

1. Open PowerShell in Administrative mode.

1. Navigate to the extracted folder.

1. Run the following PowerShell command:

    ```PowerShell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted .\AzureMigrateInstaller.ps1 -DisableAutoUpdate -Scenario AzureStackHCI -Cloud Public -PrivateEndpoint:$false -EnableAzureStackHCITarget
    ```

1. Follow the instructions to install the target appliance and to uninstall Internet Explorer.

1. Restart the VM.

1. Log on to the VM once restarted.

## Configure and register the target appliance

1. On the target appliance VM, open **Azure Migrate Configuration Manager** from your desktop shortcut.

1. Paste the target appliance key that you generated previously and select **Verify**.

1. Once verified, select **Login** and sign on with your credentials.

1. Wait until you see **The appliance has been successfully registered** message.

1. Scroll down and enter the Azure Stack HCI target cluster credentials. Provide the cluster name in FQDN format (*clustername.domain.com*)

1. Select **Configure**.

1. Wait until you see **Successfully configured Azure Migrate project** message indicating that configuration completed successfully.

## Complete Replication Wizard and start replication

1. Go to the [Azure portal](https://aka.ms/HCIMigratePP).

1. Open Azure Migrate and select **Servers, databases and web apps**.

1. Under **Migration tools** select **Replicate**.

1. In the **Specify intent** blade, select **Azure Stack HCI, Hyper-V** and then select **Continue**.

1. Under **Tab#1 Basics**, complete these steps:
	1. Select **Cluster resource** (HCI server).
	1. Verify there is a green check under the HCI server name. This indicates that Arc Resource Bridge configuration is detected on this server.

1. Under **Tab#2 Target appliance**, verify that the target appliance has been configured. You should see a green check.

1. Under **Tab#3 Virtual machines**, verify the VMs have been discovered.

1. Under **Tab#4 Target settings**, complete these steps:
	1. Select the resource group that you want these VMs to be created.
	1. Select the storage account that you created previously.
	1. Select the virtual switch these VMs are connected to.
	1. Select the storage path where these VMs are created.

1. Under **Tab#5 Compute**, complete these steps:
	1. Correct new names if needed.
	1. Select the OS disks for the VMs from the dropdown list.
    1. Customize any other VM as applicable.

1. (Optional) Under **Tab#6 Disks**, select which disks you would like to replicate and migrate.

1. Under **Tab#7**, review and then select **Replicate**.

Stay on this page until request is complete. Once complete you are taken to the **Replications** page (this may take 5-10 minutes).

## Next steps

- Complete [Hyper-V VM Migration](migrate-hyperv-migrate.md).
