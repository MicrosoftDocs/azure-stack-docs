--- 
title: Replicate Hyper-V VMs for migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the replication process for Hyper-V VMs to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 09/05/2023
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

1. Under **Azure Migrate: Discovery and assessment**, select **Assess**.

1. On the **Specify intent** page, select the following from the dropdown lists:
    - Servers or virtual machines (VM).
    - Azure Stack HCI.
    - Hyper-V.
    - Source appliance.

    :::image type="content" source="./media/replicate/replicate-specify-intent.png" alt-text="Screenshot showing the Specify intent page." lightbox="./media/replicate/replicate-specify-intent.png":::

1. Select **Download and configure** in the **Before you start replication...** information block, then select **Continue**.

1. On the **Deploy and configure the target appliance** pop-up, provide a name for the target appliance and then select **Generate key**.

    :::image type="content" source="./media/replicate/generate-target-key.png" alt-text="Screenshot showing the Generate key popup." lightbox="./media/replicate/generate-target-key.png":::

1. Copy and paste the key to Notepad (or other text editor) after it is generated for future use.

## Step 2: Download and install the appliance

You can download the appliance using either a .VHD file or a .zip file.

Under **Step 2: Download Azure Migrate appliance**, select either **.VHD file** or **.zip file**, and then select **Download**.

:::image type="content" source="media/replicate/download-source-appliance-2.png" alt-text="Screenshot of Download source appliance step 2." lightbox="media/replicate/download-source-appliance-2.png":::

### Step 2a: Download using the .VHD file option

This step applies only if you downloaded the .VHD file. You download the operating system (OS) VHD for the source appliance virtual machine (VM) to the source Hyper-V server. The source appliance is then installed for you.

1. Go to the [Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022), then select and download the Windows Server 2022 VHD file.

    :::image type="content" source="media/replicate/source-os-download-vhd.png" alt-text="Screenshot of Download source VM OS VHD page." lightbox="media/replicate/source-os-download-vhd.png":::

    > [!NOTE]
    > It is not a requirement to use the evaluation OS version - you can use your own VHD as long as the OS version is Windows Server 2022.

1. Create the appliance VM on the Hyper-V server using the ISO just downloaded. Complete the **New Virtual Machine Wizard** using the following configuration:

    - VM name
    - VM location
    - **VM type**: `Standalone` (non-High Availability type)
    - **Operating System**: Windows Server 2022
    - **Disk**: 80GB (min)
    - **Memory**: 16GB (min)
    
    For more information on using Hyper-V Manager to create a VM, see [Create a virtual machine](/windows-server/virtualization/hyper-v/get-started/create-a-virtual-machine-in-hyper-v?tabs=hyper-v-manager#create-a-virtual-machine).

1. In **Hyper-V Manager**, on the **Settings** page, set the **Number of virtual processors** to `8`.
    
    :::image type="content" source="media/replicate/vcpu-settings.png" alt-text="Screenshot of vCPU Settings dialog." lightbox="media/replicate/vcpu-settings.png":::

1. Create a virtual hard disk for the VM and specify a location for it.

    > [!NOTE]
    > Make sure that you create the appliance VM as a non-high availability VM.

1. Once the VM is created, sign in to it using **Virtual Machine Connection**.

1. In  **Hyper-V Manager**, select the host.

1. Under **Hyper-V settings**, select **Enhanced Session Mode Policy** and ensure **Allow enhanced session mode** is enabled.

    :::image type="content" source="media/replicate/enhanced-session-mode.png" alt-text="Screenshot of Enhanced Session Mode dialog box." lightbox="media/replicate/enhanced-session-mode.png.png":::

    For more information on Enhanced Session Mode, see [Turn on enhanced session mode on a Hyper-V host](/windows-server/virtualization/hyper-v/learn-more/use-local-resources-on-hyper-v-virtual-machine-with-vmconnect#turn-on-enhanced-session-mode-on-a-hyper-v-host).


### Step 2b: Download using the .zip file option

This step applies only if you downloaded the .zip file. You download the operating system (OS) ISO for the source appliance virtual machine (VM) to the source Hyper-V server. Then you use a PowerShell script to install the source appliance.

1. Go to the [Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022), then select and download the Windows Server 2022 ISO file.

    :::image type="content" source="media/replicate/source-os-download-iso.png" alt-text="Screenshot of Download source VM OS page." lightbox="media/replicate/source-os-download-iso.png":::

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
    
    :::image type="content" source="media/replicate/vcpu-settings.png" alt-text="Screenshot of vCPU Settings dialog." lightbox="media/replicate/vcpu-settings.png":::

1. Create a virtual hard disk for the VM and specify a location for it.

    > [!NOTE]
    > Make sure that you create the appliance VM as a non-high availability VM.

1. Once the VM is created, sign in to it using **Virtual Machine Connection**.

1. Select the OS you just downloaded (Windows Server 2022) and begin OS set up.

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

1. After the appliance is registered, scroll down and select **Add cluster information**.

    :::image type="content" source="./media/replicate/add-cluster-info.png" alt-text="Screenshot showing Add cluster information button." lightbox="./media/replicate/add-cluster-info.png":::

1. Enter cluster fully-qualified domain name (FQDN), domain name, username, password, and then select **Save**.

    :::image type="content" source="./media/replicate/add-cluster-info2.png" alt-text="Screenshot showing Add cluster information popup." lightbox="./media/replicate/add-cluster-info2.png":::

## Step 4: Start replication

1. In the Azure portal, go to your Azure Migrate project and select **Servers, databases and web apps**.

1. On the **Migration and modernization** page, select **Step 1: Replicate** tile.

    :::image type="content" source="./media/replicate/step1-replicate.png" alt-text="Screenshot showing the Replicate tile." lightbox="./media/replicate/step1-replicate.png":::

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
	1. Verify there is a green check for the cluster. This indicates that the Arc Resource Bridge is configured.
    1. When finished, select **Next**.
    
    :::image type="content" source="./media/replicate/replicate-1-basics.png" alt-text="Screenshot showing the Basics tab." lightbox="./media/replicate/replicate-1-basics.png":::
    

1. On the **Target appliance** tab, verify that the target appliance is connected - you should see a green check. Select **Next**.

    :::image type="content" source="./media/replicate/replicate-2-target.png" alt-text="Screenshot showing the Target appliance tab." lightbox="./media/replicate/replicate-2-target.png":::

1. On the **Virtual machines** tab, verify the VMs have been discovered and are listed. Select **Next**.

    :::image type="content" source="./media/replicate/replicate-3-vm.png" alt-text="Screenshot showing the Virtual machines tab." lightbox="./media/replicate/replicate-3-vm.png":::

1. On the **Target settings** tab, complete these tasks:

	1. For **Cache storage account**, create a storage account as described in the next section.

        :::image type="content" source="./media/replicate/replicate-4-target.png" alt-text="Screenshot showing the Cache storage account popup." lightbox="./media/replicate/replicate-4-target.png":::

    1. Select the resource group that you want these VMs to be associated with.
	1. Select the virtual switch these VMs are connected to.
	1. Select the storage path where these VMs are created.
    1. When finished, select **Next**.
    
        :::image type="content" source="./media/replicate/replicate-4-target2.png" alt-text="Screenshot showing the Target settings tab." lightbox="./media/replicate/replicate-4-target.png":::

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

 1. On the **Replications** page, review the replication status. Select **Refresh** to see the replicated VMs.
 
1. Verify **Migration status** shows **Ready to migrate**.

1. When finished, select **Migrate**.
 
    :::image type="content" source="./media/replicate/replications-page2.png" alt-text="Screenshot showing the Replications page." lightbox="./media/replicate/replications-page2.png":::

### Create a storage account

You next need to create a storage account in Azure portal:

1. On the Azure portal home page, select **Storage accounts**.

1. On the **Storage accounts** page, select **Create**.

1. On the **Basics** tab, under **Project details**, select the same subscription and resource group that you used to create the Azure Migrate project. If needed, select **Create new** to create a new resource group.

1. Under **Instance details**, follow these steps:
    1. Enter a name for the storage account.
    1. Select a geographical region.
    1. Choose either **Standard** or **Premium** performance.
    1. Select a redundancy level.
    
    :::image type="content" source="media/replicate/tab-basics.png" alt-text="Screenshot of Basic tab page in Azure portal." lightbox="media/replicate/tab-basics.png":::

1. When done, select **Review**.

    > [!NOTE]
    > Only fields on the **Basics** tab need to be filled out or altered. You can ignore the remaining tabs (and options therein) as the default options and values displayed on those tabs are recommended and are used.

1. Review all information on the **Review** tab of the **Create a storage account** page. If everything looks good, select **Create**.

    :::image type="content" source="media/replicate/tab-review.png" alt-text="Screenshot of Review tab page in Azure portal." lightbox="media/replicate/tab-review.png":::

1. The project template deployment will begin. When deployment is complete, select **Go to resource**.

    :::image type="content" source="media/replicate/deployment-complete.png" alt-text="Screenshot of deployment complete status display." lightbox="media/replicate/deployment-complete.png":::

1. On the resource group page, under **Resources**, verify there is a resource listed for each of the following:

    - Azure Stack HCI cluster resource
    - Arc Resource Bridge resource
    - Custom location resource
    - Storage path resource(s)

    :::image type="content" source="media/replicate/project-resources.png" alt-text="Screenshot Resources list." lightbox="media/replicate/project-resources.png":::

## Next steps

- Complete the [Hyper-V VM Migration](migrate-hyperv-replicate.md) phase.
