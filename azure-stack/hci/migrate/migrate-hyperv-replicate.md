--- 
title: Replicate Hyper-V VMs for migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the replication process for Hyper-V VMs to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 09/14/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Replicate Hyper-V VMs for migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes the replication phase for Hyper-V virtual machine (VM) migration to Azure Stack HCI using Azure Migrate.

[!INCLUDE [important](../../includes/hci-preview.md)]

For more information on appliances for Azure Migrate and how to manage them, see [Azure Migrate appliance](/azure/migrate/migrate-appliance).

## Step 1: Generate target appliance key

Complete the following tasks to generate the target appliance key:

1. In the Azure portal, go to your Azure Migrate project and select **Servers, databases and web apps**.

1. Verify that you see a non-zero value for **Discovered servers** under **Assessment tools > Azure Migrate: Discovery and assessment**.

    :::image type="content" source="./media/replicate/replicate-discovered-servers.png" alt-text="Screenshot showing the discovered servers." lightbox="./media/replicate/replicate-discovered-servers.png":::

1. Under **Azure Migrate: Migration tools**, select **Replicate**.

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

## Step 2: Download and install the appliance

You can download the appliance using either a .VHD file or a .zip file.

Under **Step 2: Download Azure Migrate appliance**, select either **.VHD file** or **.zip file**, and then select **Download**.

:::image type="content" source="media/replicate/download-source-appliance-2.png" alt-text="Screenshot of Download source appliance step 2." lightbox="media/replicate/download-source-appliance-2.png":::

### Step 2a: Download using the .VHD file option

This step applies only if you downloaded the .VHD file. The target appliance is installed for you using the .VHD file.

1. Install Windows Server 2022 from an ISO image on the source Hyper-V server.

1. Using **Hyper-V Manager**, create a new VM on the Hyper-V server using the following configuration:

    - **VM type**: `Standalone` (non-High Availability type)
    - **Operating System**: Windows Server 2022
    - **Disk**: 80GB (min)
    - **Memory**: 16GB (min)
    
1. Stop the VM if it is running. Then on the **Settings** page, set the **Number of virtual processors** to `8`.

1. In **Hyper-V Manager**, stop the VM if it is running. Then on the **Settings** page, set the **Number of virtual processors** to `8`.
    
    :::image type="content" source="media/replicate/vcpu-settings.png" alt-text="Screenshot of vCPU Settings dialog." lightbox="media/replicate/vcpu-settings.png":::

1. Create a virtual hard disk for the VM and specify a location for it.

    > [!NOTE]
    > Make sure that you create the appliance VM as a non-high availability VM.

1. Once the VM is created, sign in to it using **Virtual Machine Connection**.

1. In  **Hyper-V Manager**, select the host.

1. Under **Hyper-V settings**, select **Enhanced Session Mode Policy** and ensure **Allow enhanced session mode** is enabled.

    :::image type="content" source="media/replicate/enhanced-session-mode.png" alt-text="Screenshot of Enhanced Session Mode dialog box." lightbox="media/replicate/enhanced-session-mode.png":::

    For more information on Enhanced Session Mode, see [Turn on enhanced session mode on a Hyper-V host](/windows-server/virtualization/hyper-v/learn-more/use-local-resources-on-hyper-v-virtual-machine-with-vmconnect#turn-on-enhanced-session-mode-on-a-hyper-v-host).


### Step 2b: Download using the .zip file option

This step applies only if you downloaded the .zip file. You use the *AzureMigrateInstaller.ps1* PowerShell script to install the target appliance.

1. Install Windows Server 2022 from an ISO image on the source Hyper-V server.

1. Using **Hyper-V Manager**, create a new VM on the Hyper-V server using the following configuration:

    - **VM type**: `Standalone` (non-High Availability type)
    - **Operating System**: Windows Server 2022
    - **Disk**: 80GB (min)
    - **Memory**: 16GB (min)
    
1. Stop the VM if it is running. Then on the **Settings** page, set the **Number of virtual processors** to `8`.
    
    :::image type="content" source="media/replicate/vcpu-settings.png" alt-text="Screenshot of vCPU Settings dialog." lightbox="media/replicate/vcpu-settings.png":::

    For more information on using Hyper-V Manager to create a VM, see [Create a virtual machine](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine).

1. Create a virtual hard disk for the VM and specify a location for it.

    > [!NOTE]
    > Make sure that you create the appliance VM as a non-high availability VM.

1. Once the VM is created, sign in to it using **Virtual Machine Connection**.

1. Select the OS you just downloaded (Windows Server 2022) and begin OS setup.

1. Once the OS is finished installing, enter your local administrative credentials, then sign in using them.

1. In  **Hyper-V Manager**, select the host.

1. Under **Hyper-V settings**, select **Enhanced Session Mode Policy** and ensure **Allow enhanced session mode** is enabled.

    :::image type="content" source="media/replicate/enhanced-session-mode.png" alt-text="Screenshot of Enhanced Session Mode dialog." lightbox="media/replicate/enhanced-session-mode.png":::

    For more information on Enhanced Session Mode, see [Turn on enhanced session mode on a Hyper-V host](/windows-server/virtualization/hyper-v/learn-more/use-local-resources-on-hyper-v-virtual-machine-with-vmconnect#turn-on-enhanced-session-mode-on-a-hyper-v-host).

1. Open **Server Manager** on the Hyper-V server.

1. Copy and paste the downloaded .zip file to the VM virtual disk that you created and extract it as needed.

1. As an administrator, run the following PowerShell script from the folder of the downloaded file to install the target appliance:

    ```PowerShell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    .\AzureMigrateInstaller.ps1 -Scenario AzureStackHCI -Cloud Public -PrivateEndpoint:$false
    ```

1. Restart and sign into the VM.

## Step 3: Configure and register target appliance

1. Open **Server Manager** and sign in to the target appliance VM.

1. Open **Azure Configuration Manager** from the desktop shortcut.

1. Locate the target key that you previously generated, paste it in the field under **Verification of Azure Migrate project key**, and then select **Verify**.

1. Once verification is complete, select **Log in** and sign in to your Azure account.

1. Enter the code that is displayed in your Authenticator (or similar) app for MFA authentication.

    :::image type="content" source="./media/replicate/enter-code.png" alt-text="Screenshot showing the authenticate code popup." lightbox="./media/replicate/enter-code.png":::

1. Wait until you see **The appliance has been successfully registered** message.

1. Sign in to Microsoft Azure PowerShell using the code displayed in your Authenticator app. It can take up to 10 minutes for the appliance to be registered.

    :::image type="content" source="./media/replicate/enter-code-2.png" alt-text="Screenshot showing the Azure Login popup." lightbox="./media/replicate/enter-code-2.png":::

1. After the appliance is registered, scroll down and select **Add cluster information**.

    :::image type="content" source="./media/replicate/add-cluster-info.png" alt-text="Screenshot showing Add cluster information button." lightbox="./media/replicate/add-cluster-info.png":::

1. Enter cluster fully qualified domain name (FQDN), domain name, username, password, and then select **Save**.

    :::image type="content" source="./media/replicate/add-cluster-info-2.png" alt-text="Screenshot showing Add cluster information popup." lightbox="./media/replicate/add-cluster-info-2.png":::

## Step 4: Start replication

1. In the Azure portal, go to your Azure Migrate project and select **Servers, databases and web apps**.

1. On the **Migration and modernization** page, select **Step 1: Replicate** tile.

    :::image type="content" source="./media/replicate/step-1-replicate.png" alt-text="Screenshot showing the Replicate tile." lightbox="./media/replicate/step-1-replicate.png":::

1. On the **Specify intent** page:
    1. Select **Servers or virtual machines (VM)**.
    1. Select **Azure Stack HCI**.
    1. Select **Hyper-V**.
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
    

1. On the **Target appliance** tab, verify that the target appliance is connected - you should see a green check. Select **Next**.

    :::image type="content" source="./media/replicate/replicate-2-target.png" alt-text="Screenshot showing the Target appliance tab." lightbox="./media/replicate/replicate-2-target.png":::

1. On the **Virtual machines** tab, verify the VMs have been discovered and are listed. Select **Next**.

    :::image type="content" source="./media/replicate/replicate-3-vm.png" alt-text="Screenshot showing the Virtual machines tab." lightbox="./media/replicate/replicate-3-vm.png":::

1. On the **Target settings** tab, complete these tasks:

	1. For **Cache storage account**, select the storage account you created previously.

        :::image type="content" source="./media/replicate/replicate-4-target.png" alt-text="Screenshot showing the Cache storage account popup." lightbox="./media/replicate/replicate-4-target.png":::

    1. Select the resource group that you want these VMs to be associated with.
	1. Select the virtual switch these VMs are connected to. For more information, see [Create and configure a virtual switch with Hyper-V](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-switch-for-hyper-v-virtual-machines?tabs=hyper-v-manager).
	1. Select the storage path where these VMs are created.
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

- Complete the [Hyper-V VM Migration](migrate-azure-migrate.md) phase.
