--- 
title: Discover and replicate Hyper-V VMs for migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the discovery and replication process for Hyper-V VMs to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 10/19/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Discover and replicate Hyper-V VMs for migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the discovery and replication phase for Hyper-V virtual machine (VM) migration to Azure Stack HCI using Azure Migrate.

[!INCLUDE [important](../../includes/hci-preview.md)]

For more information on appliances for Azure Migrate and how to manage them, see [Azure Migrate appliance](/azure/migrate/migrate-appliance).

## Before you begin

For both the source and target appliance, make sure your hardware supports VMs that run on the server with Windows Server 2022, 16 GB RAM, 80 GB of disk storage, 8 vCPUs, and an external virtual switch.

## Step 1: Create and configure the source appliance

### Generate the project key

In this step, you generate the key for the source appliance - see [Generate the project key](/azure/migrate/how-to-set-up-appliance-hyper-v#generate-the-project-key) for specific steps.

### Create the source appliance

You can install the appliance using either a template (.VHD file) or a script (.zip file) that you download to your Hyper-V server. For more information on appliances for Azure Migrate and how to manage them, see [Azure Migrate appliance](/azure/migrate/migrate-appliance).

#### Install using a template (.VHD file)

This step applies only if you are deploying the source appliance using a .VHD file template. The source appliance is installed for you using the .VHD file. For step-by-step information, see [Download the VHD](/azure/migrate/how-to-set-up-appliance-hyper-v#download-the-vhd).

#### Install using a script (.zip file)

This step applies only if you downloaded the .zip file. You use the *AzureMigrateInstaller.ps1* PowerShell script to install the source appliance. For specific information, see [Set up an appliance with a script](/azure/migrate/deploy-appliance-script).

### Configure the appliance and discover VMs

Once the source appliance is installed, you are ready to [Configure the appliance](/azure/migrate/how-to-set-up-appliance-hyper-v#configure-the-appliance).

After the appliance is configured, you start the VM discovery process.

Wait until you have a green checkmark indicating discovery is finished, then go to the Azure portal to review VM inventory.

## Step 2: Create and configure the target appliance

### Generate target appliance key

Complete the following tasks to generate the target appliance key:

1. In the Azure portal, go to your Azure Migrate project and select **Servers, databases and web apps**.

1. Verify that you see a non-zero value for **Discovered servers** under **Migration tools**.

    :::image type="content" source="./media/replicate/replicate-discovered-servers.png" alt-text="Screenshot showing the discovered servers." lightbox="./media/replicate/replicate-discovered-servers.png":::

1. Under **Migration and modernization**, select **Replicate**.

1. On the **Specify intent** page, select the following from the dropdown lists:
    - Servers or virtual machines (VM).
    - Azure Stack HCI.
    - Hyper-V.
    - Source appliance (pre-populated; select the applicable one from the dropdown if you have more than one).

    :::image type="content" source="./media/replicate/replicate-specify-intent.png" alt-text="Screenshot showing the Specify intent page." lightbox="./media/replicate/replicate-specify-intent.png":::

1. Select **Download and configure** in **Before you start replication...** from the information block, then select **Continue**.

1. On the **Deploy and configure the target appliance** pop-up, provide a name for the target appliance and then select **Generate key**.

    :::image type="content" source="./media/replicate/generate-target-key.png" alt-text="Screenshot showing the Generate key popup." lightbox="./media/replicate/generate-target-key.png":::

1. Copy and paste the key to Notepad (or other text editor) after it is generated for future use.

### Create the target appliance

You can download the appliance using either a .VHD file or a .zip file.

Under **Step 2: Download Azure Migrate appliance**, select either **.VHD file** or **.zip file**, and then select **Download**.

:::image type="content" source="media/replicate/download-target-appliance.png" alt-text="Screenshot of download target appliance step 2." lightbox="media/replicate/download-target-appliance.png":::

#### Install using a template (.VHD file)

This step applies only if you downloaded the .VHD file. Create a VM using the VHD you downloaded, then start and sign into the VM.

Verify that the VM is configured with the following settings:

- Standalone type (non-High Availability type).
- 16 GB memory.
- 8 vCPU.
- 80 GB disk storage.
- Enhanced Session Policy mode enabled.
- External virtual switch created.

#### Install using a script (.zip file)

This step applies only if you downloaded the .zip file. You use the *AzureMigrateInstaller.ps1* PowerShell script to install the target appliance.

1. Using **Hyper-V Manager**, create a `Standalone` (non-High Availability type) VM on the target Azure Stack HCI server running on Windows Server 2022 with 80 GB (min) disk storage, 16 GB (min) memory, and 8 virtual processors.

1. In  **Hyper-V Manager**, select the host.

1. Under **Hyper-V settings**, select **Enhanced Session Mode Policy** and ensure **Allow enhanced session mode** is enabled. For more information, see [Turn on enhanced session mode on a Hyper-V host](/windows-server/virtualization/hyper-v/learn-more/use-local-resources-on-hyper-v-virtual-machine-with-vmconnect#turn-on-enhanced-session-mode-on-a-hyper-v-host).

1. Sign into the VM as an administrator.

1. Copy and paste the downloaded .zip file to the VM virtual disk that you created and extract it as needed.

1. As an administrator, run the following PowerShell script from the folder of the extracted files to install the target appliance:

    ```PowerShell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    .\AzureMigrateInstaller.ps1 -Scenario AzureStackHCI -Cloud Public -PrivateEndpoint:$false
    ```

1. Restart and sign into the VM.

### Register the target appliance

1. Sign in to the target appliance VM.

1. Open **Azure Configuration Manager** from the desktop shortcut.

1. Locate the target key that you previously generated, paste it in the field under **Verification of Azure Migrate project key**, and then select **Verify**.

1. Once verification is complete, select **Log in** and sign in to your Azure account.

1. Enter the code that is displayed in your Authenticator (or similar) app for MFA authentication.

    :::image type="content" source="./media/replicate/enter-code.png" alt-text="Screenshot showing the authenticate code popup." lightbox="./media/replicate/enter-code.png":::

1. Wait until you see **The appliance has been successfully registered** message.

1. Sign in to Microsoft Azure PowerShell using the code displayed in your Authenticator app. It can take up to 10 minutes for the appliance to be registered.

    :::image type="content" source="./media/replicate/enter-code-2.png" alt-text="Screenshot showing the Azure Login popup." lightbox="./media/replicate/enter-code-2.png":::

1. After the appliance is registered, under **Provide Azure Stack HCI cluster information**, select **Add cluster information**.

    :::image type="content" source="./media/replicate/add-cluster-info.png" alt-text="Screenshot showing Add cluster information button." lightbox="./media/replicate/add-cluster-info.png":::

1. Enter cluster fully qualified domain name (FQDN), domain name, username, password, and then select **Save**.

    :::image type="content" source="./media/replicate/add-cluster-info-2.png" alt-text="Screenshot showing Add cluster information popup." lightbox="./media/replicate/add-cluster-info-2.png":::

## Step 3: Start replication

1. In the Azure portal, go to your Azure Migrate project and select **Servers, databases and web apps**.

1. Under **Migration and modernization**, select **Replicate**.

    :::image type="content" source="./media/replicate/replicate-start.png" alt-text="Screenshot showing the Replicate start process." lightbox="./media/replicate/replicate-start.png":::

1. On the **Specify intent** page:
    1. Select the target appliance.
    1. When finished, select **Continue**.

    :::image type="content" source="./media/replicate/replicate-specify-intent.png" alt-text="Screenshot showing the Specify intent page." lightbox="./media/replicate/replicate-specify-intent.png":::

1. On the **Replicate** page, on the **Basics** tab:

    1. Select the Azure subscription for this project.
    1. Select the resource group for this project.
	1. For **Cluster resource**, select the Azure Stack HCI cluster resource.
	1. Verify there is a green check for the cluster.
    1. When finished, select **Next**.
    
    :::image type="content" source="./media/replicate/replicate-1-basics.png" alt-text="Screenshot showing the Basics tab." lightbox="./media/replicate/replicate-1-basics.png":::
    

1. On the **Target appliance** tab, verify that the target appliance is connected - you should see a green checkmark. Select **Next**.

    :::image type="content" source="./media/replicate/replicate-2-target.png" alt-text="Screenshot showing the Target appliance tab." lightbox="./media/replicate/replicate-2-target.png":::

1. On the **Virtual machines** tab, verify the VMs have been discovered and are listed. Select **Next**.

    :::image type="content" source="./media/replicate/replicate-3-vm.png" alt-text="Screenshot showing the Virtual machines tab." lightbox="./media/replicate/replicate-3-vm.png":::

1. On the **Target settings** tab, complete these tasks:

    1. Select the resource group that you want these VMs to be associated with.

	1. Select the virtual network that you [created previously](migrate-hyperv-prerequisites.md) that these VMs will be connected to. If you don't see a virtual network in the dropdown list, [create a virtual network](./manage/create-virtual-networks) and select **Reload virtual switch**.

	1. Select the storage path where these VMs will be created. If you don't see a storage path in the dropdown list, [create a storage path](../index.yml) and select **Reload virtual switch**.

    1. When finished, select **Next**.
    
        :::image type="content" source="./media/replicate/replicate-4-target-2.png" alt-text="Screenshot showing the Target settings tab." lightbox="./media/replicate/replicate-4-target-2.png":::

1. On the **Compute** tab:

	1. Rename target VMs as needed.
	1. Select the OS disk for each VM from the dropdown lists.
    1. Adjust values for vCPU and RAM for each VM as needed.
    1. When finished, select **Next**.
    
        :::image type="content" source="./media/replicate/replicate-5-compute.png" alt-text="Screenshot showing the Compute tab." lightbox="./media/replicate/replicate-5-compute.png":::

1. On the **Disks** tab, select which disks you would like to replicate, then select **Next**.

    :::image type="content" source="./media/replicate/replicate-6-disks.png" alt-text="Screenshot showing the Disks tab." lightbox="./media/replicate/replicate-6-disks.png":::

1. On the  **Review + Start replication** tab, stay on the page until the process is complete (this may take 5-10 minutes). Then select **Replicate**.

    :::image type="content" source="./media/replicate/replicate-7-review.png" alt-text="Screenshot showing the Review + Start replication tab." lightbox="./media/replicate/replicate-7-review.png":::

 1. On the **Replications** page, review the replication status. Select **Refresh** to see the replicated VMs. When the initial replication is complete, the VM Migration status changes to **Ready to migrate**.
 
1. Verify **Migration status** shows **Ready to migrate**.


    :::image type="content" source="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-1a.png" alt-text="Screenshot Azure Migrate: Migration and modernization > Replications in Azure portal with migration status Ready to migrate." lightbox="./media/migrate-azure-migrate/migrate-replicated-virtual-machine-1a.png":::


## Next steps

- Complete [Hyper-V VM Migration](migrate-azure-migrate.md).
