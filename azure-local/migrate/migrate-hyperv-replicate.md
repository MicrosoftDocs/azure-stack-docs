--- 
title: Discover and replicate Hyper-V VMs for migration to Azure Local using Azure Migrate (preview) 
description: Learn the discovery and replication process for Hyper-V VMs to Azure Local using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 10/01/2025
ms.author: alkohli
ms.custom: sfi-image-nochange
---

# Discover and replicate Hyper-V VMs for migration to Azure Local using Azure Migrate (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the discovery and replication phase for Hyper-V virtual machine (VM) migration to Azure Local using Azure Migrate.

[!INCLUDE [important](../includes/hci-preview.md)]

For more information on appliances for Azure Migrate and how to manage them, see [Azure Migrate appliance](/azure/migrate/migrate-appliance).

## Before you begin

For both the source and target appliance, make sure that your hardware has sufficient resource to support the creation of a Windows Server 2022 VM with 16 GB RAM, 80 GB of disk storage, 8 vCPUs, and an external virtual switch.

Ensure all VMs that you wish to migrate are powered on and have [Hyper-V integration services](/windows-server/virtualization/hyper-v/manage/manage-hyper-v-integration-services) installed. Migration will fail if the VMs are not powered on and do not have Hyper-V integration services installed.

## Step 1: Create and configure the source appliance

### Generate the project key

1. In the Azure portal, go to the **All projects** page and select your project from the list.

1. On the **Overview** tab, under **Inventory**, select **Start discovery** > **Using appliance** > **For Azure Local**.

    :::image type="content" source="./media/migrate-hyperv-replicate/generate-source-appliance-project-key-1.png" alt-text="Screenshot of going to Discover page from Migration tools tile for your source appliance." lightbox="./media/migrate-hyperv-replicate/generate-source-appliance-project-key-1.png":::

1. On the **Discover** page, select **Azure Local** under **Where do you want to migrate to** and then select **Yes, with Hyper-V** under **Are your machines virtualized** in Azure Migrate.
1. Enter a name for your source appliance and generate the key for the source Hyper-V appliance. For detailed steps, see [Generate the project key](/azure/migrate/how-to-set-up-appliance-vmware#generate-the-project-key).

1. Copy the **Project key** (to a text editor such as Notepad) and save it for later use.
1. You can now **Download the Azure Migrate source appliance** using either a .VHD or a *.zip* file. The detailed steps are provided in the subsequent sections.

    :::image type="content" source="./media/migrate-hyperv-replicate/generate-source-appliance-project-key-2.png" alt-text="Screenshot of going to Discover page." lightbox="./media/migrate-hyperv-replicate/generate-source-appliance-project-key-2.png":::

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

Ensure that all VMs you want to migrate are powered on and have [Hyper-V integration services](/windows-server/virtualization/hyper-v/manage/manage-hyper-v-integration-services) installed before or during the discovery process.

## Step 2: Create and configure the target appliance

### Generate target appliance key

Complete the following tasks to generate the target appliance key:

1. In the Azure portal, go to your Azure Migrate project and select **Servers, databases and web apps**.

1. Verify that you see a non-zero value for **Discovered servers** under **Migration tools**.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-discovered-servers.png" alt-text="Screenshot showing the discovered servers." lightbox="./media/migrate-hyperv-replicate/replicate-discovered-servers.png":::

1. Under **Migration and modernization**, select **Replicate**.

1. On the **Specify intent** page, provide the following inputs:
    - For **What do you want to migrate?**, select **Servers or virtual machines (VM)**.
    - For **Where do you want to migrate?**, select **Azure Local**.
    - For **Virtualization Type**, select **Hyper-V**.
    - For the **On-premises appliance**, the source appliance is pre-populated. IF you have more than one source appliance, select the applicable one from the dropdown list.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-specify-intent.png" alt-text="Screenshot showing the Specify intent page." lightbox="./media/migrate-hyperv-replicate/replicate-specify-intent.png":::

1. Select **Download and configure** in **Before you start replication to Azure Local** from the information block.

1. On the **Deploy and configure the target appliance** pane, provide a name for the target appliance and then select **Generate key**.

    :::image type="content" source="./media/migrate-hyperv-replicate/generate-target-key.png" alt-text="Screenshot showing the Generate key popup." lightbox="./media/migrate-hyperv-replicate/generate-target-key.png":::

1. Copy and paste the project key to a text editor (for example, Notepad) after it is generated for future use.

### Create the target appliance

You can download the appliance using either a .VHD file or a .zip file.

Under **Step 2: Download Azure Migrate appliance**, select either **.VHD** or **.zip**, and then select **Download installer**.

:::image type="content" source="media/migrate-hyperv-replicate/download-target-appliance.png" alt-text="Screenshot of download target appliance step 2." lightbox="media/migrate-hyperv-replicate/download-target-appliance.png":::

#### Install using a template (.VHD file)

This step applies only if you downloaded the .VHD zipped file. 

1. Check that the zipped file is secure, before you deploy it. 

1. On the machine where you downloaded the file, open an administrator PowerShell window. 

1. Run the following command to generate the hash for the VHD. 

    ```powershell
    C:\>Get-FileHash -Path <Path to downloaded VHD zip>  -Algorithm SHA256
    ```

1. Verify the latest appliance versions and hash values: 
    
    |**Scenario**  |**Download**  |**SHA256**  |
    |---------|---------|---------|
    |Azure Local appliance     |Latest version: `https://go.microsoft.com/fwlink/?linkid=2246416`         |6ae1144b026efb2650f5e11c007a457c351a752f942c2db827dd2903f468dccb         |

1. Extract the zipped file to a folder. 

Now you can install the appliance using the .VHD file.

1. Using local tools, such as Hyper-V Manager or Failover Cluster, install the target appliance from the downloaded .VHD file on your Azure Local instance. 

1. Once the VM has finished provisioning and has booted, open the **Azure Migrate Target Appliance Configuration Manager** shortcut from the desktop. 

#### Install using a script (.zip file)

This step applies to using a .zip file.

1. Create a VM in Azure Local with the following configuration: 
    - Operating system: Windows Server 2022 
    - vCPU: 8 
    - Disk: >80 GB 
    - Memory: 16 GB 

1. Once the VM is created, sign into the VM as an administrator. 

1. You can download the appliance from a .zip file. Under  **Step 2: Download and install the target appliance**, select **.zip**, and then select  **Download**. 

1. Copy the downloaded zip file to the new VM that you created on the Azure Local instance. Extract the zip to a folder and go where the `AzureMigrateInstaller.ps1` PowerShell script resides in the extracted folder. 

1. Open a PowerShell window as an administrator and run the following:

    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted 
    .\AzureMigrateInstaller.ps1 -Scenario AzureStackHCI -Cloud Public -PrivateEndpoint:$false
    ``` 

1. Restart the VM after the installation is complete. Sign in to the VM. 

### Register the target appliance

1. Sign in to the target appliance VM.

1. Open **Azure Migrate Target Appliance Configuration Manager** from the desktop shortcut.

1. Locate the target key that you previously generated, paste it in the field under **Verification of Azure Migrate project key**, and then select **Verify**.

1. Once the verification is complete, select **Log in** and sign in to your Azure account.

1. Enter the code that is displayed in your Authenticator (or similar) app for MFA authentication.

    :::image type="content" source="./media/migrate-hyperv-replicate/enter-code.png" alt-text="Screenshot showing the authenticate code popup." lightbox="./media/migrate-hyperv-replicate/enter-code.png":::

1. Wait until you see **The appliance has been successfully registered** message.

1. Sign in to Microsoft Azure PowerShell using the code displayed in your Authenticator app. It can take up to 10 minutes for the appliance to be registered.

    :::image type="content" source="./media/migrate-hyperv-replicate/enter-code-2.png" alt-text="Screenshot showing the Azure Login popup." lightbox="./media/migrate-hyperv-replicate/enter-code-2.png":::

1. After the appliance is registered, under **Provide Azure Local instance information**, select **Add system information**.

    :::image type="content" source="./media/migrate-hyperv-replicate/add-cluster-info.png" alt-text="Screenshot showing Add cluster information button." lightbox="./media/migrate-hyperv-replicate/add-cluster-info.png":::

1. For your target Azure Local instance, enter the fully qualified domain name (FQDN), domain name, username, and password, and then select **Save**.

    :::image type="content" source="./media/migrate-hyperv-replicate/add-cluster-info-2.png" alt-text="Screenshot showing Add cluster information popup." lightbox="./media/migrate-hyperv-replicate/add-cluster-info-2.png":::

1. Once the credentials are accepted, the status changes to **Validated**. Select **Configure**.

1. Wait until the configuration is complete and you see this message: **Successfully configured Azure Migrate project.**


## Step 3: Start replication

1. In the Azure portal, go to your Azure Migrate project and select **Servers, databases and web apps**.

1. Under **Migration and modernization**, select **Replicate**.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-start.png" alt-text="Screenshot showing the Replicate start process." lightbox="./media/migrate-hyperv-replicate/replicate-start.png":::

1. On the **Specify intent** page:
    1. **What do you want to migrate** is automatically populated as **Servers or virtual machines (VM)**.
    1. Select **Azure Local** for **Where do you want to migrate to ?**
    1. Select **Hyper-V** for the **Virtualization type**.
    1. Select the source appliance as the **On-premises appliance** (source) used for discovery.
    1. When finished, select **Continue**.

    :::image type="content" source="./media/migrate-hyperv-replicate/replication-screen.png" alt-text="Screenshot showing the replication Specify intent page." lightbox="./media/migrate-hyperv-replicate/replication-screen.png":::

1. On the **Replicate** page, on the **Basics** tab:

    1. This field is automatically populated. If this is not the subscription that has your target Azure Local instance, choose the Azure subscription that has the system.
    1. Select the resource group associated with your target system.
	1. For **Target system**, select the Azure Local resource.
	1. Verify there is a green check for the system. A green check indicates that all the prerequisites such as Azure Arc resource bridge are configured on this system.
    1. When finished, select **Next**.
    
    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-1-basics.png" alt-text="Screenshot showing the Basics tab." lightbox="./media/migrate-hyperv-replicate/replicate-1-basics.png":::
    

1. On the **Target appliance** tab, verify that the target appliance is connected - you should see a green checkmark.

    > [!NOTE]
    > A green checkmark indicates that the target appliance is successfully registered and configured. If you haven't configured your target appliance yet, you will see the configuration page here instead.

1. Select **Next**.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-2-target.png" alt-text="Screenshot showing the Target appliance tab." lightbox="./media/migrate-hyperv-replicate/replicate-2-target.png":::

1. On the **Virtual machines** tab, verify the VMs have been discovered and are listed. You can select up to 10 VMs from the list to migrate at one time. Select **Next**.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-3-vm.png" alt-text="Screenshot showing the Virtual machines tab." lightbox="./media/migrate-hyperv-replicate/replicate-3-vm.png":::

1. On the **Target settings** tab, complete these tasks:

    1. The **Storage account subscription** is automatically populated. If this is not the subscription where you want to create the storage account, choose another subscription.
        
        > [!NOTE]
        > Migration requires a storage account to be created. This account must reside in the same subscription as your Azure project.

    1. Select the **Resource group** to associate with your storage account.
    
    1. The VM subscription is automatically populated.
    
    1. For your **Cache storage account**, select an existing storage account. You can also select **(New) Storage account** to create a new storage account with a randomly generated name.

        > [!NOTE]
        > We recommend that you create new a storage account to be used as your cache storage account. Once created, the storage account location can't be changed.

    1. Select a resource group to associate with your migrated VMs.
   
	1. Select the logical network that you created as a [prerequisite](./migrate-hyperv-prerequisites.md#prerequisites-for-hyper-v-vm-migration-to-azure-local-using-azure-migrate-preview). The VMs will be connected to this network. If you don't see a logical network in the dropdown list, [create a logical network](../manage/create-logical-networks.md) and select **Reload logical network**.

	1. Select the storage path that you created as a [prerequisite](./migrate-hyperv-prerequisites.md#prerequisites-for-hyper-v-vm-migration-to-azure-local-using-azure-migrate-preview). The VMs will be created at this storage path. If you don't see a storage path in the dropdown list, [create a storage path](../manage/create-storage-path.md) and select **Reload storage path**.

    1. When finished, select **Next**.
    
        :::image type="content" source="./media/migrate-hyperv-replicate/replicate-4-target-2.png" alt-text="Screenshot showing the Target settings tab." lightbox="./media/migrate-hyperv-replicate/replicate-4-target-2.png":::

1. On the **Compute** tab:

	1. Rename target VMs as needed.
	1. Select the OS disk for each VM from the dropdown lists.
    1. Configure number of vCPUs and RAM including selecting dynamic RAM for each VM, as needed.
    1. When finished, select **Next**.
    
        :::image type="content" source="./media/migrate-hyperv-replicate/replicate-5-compute.png" alt-text="Screenshot showing the Compute tab." lightbox="./media/migrate-hyperv-replicate/replicate-5-compute.png":::

1. On the **Disks** tab, select which disks you would like to replicate.

    > [!NOTE]
    > Once selected, the OS disks can't be unselected.
 
1. Change the disk type if needed and select **Next**.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-6-disks.png" alt-text="Screenshot showing the Disks tab." lightbox="./media/migrate-hyperv-replicate/replicate-6-disks.png":::

1. On the  **Review + Start replication** tab, make sure that all the values are correct and then select **Replicate**. 

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-7-review.png" alt-text="Screenshot showing the Review + Start replication tab." lightbox="./media/migrate-hyperv-replicate/replicate-7-review.png":::

1. Stay on this page until the process is complete (this might take 5-10 minutes). If you move away from this page, the replication artifacts won't be created fully leading to a failure in replication and eventually migration.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-77-review.png" alt-text="Screenshot showing the warning on the Review + Start replication tab." lightbox="./media/migrate-hyperv-replicate/replicate-77-review.png":::

1. You are automatically taken to **Servers, databases and web apps** page. On the **Migration tools** tile, select **Overview**.

1. Go to **Azure Local migration > Replications**. Review the replication status. Select **Refresh** to see the replicated VMs appear.
 
1. As the replication continues, replication status shows progress. Continue refreshing periodically. After the initial replication is complete, hourly delta replications begin. The **Migration status** changes to **Ready to migrate**. The VMs can be migrated. 
 
    :::image type="content" source="./media/migrate-hyperv-replicate/migrate-replicated-virtual-machine-1-a.png" alt-text="Screenshot Azure Migrate: Migration and modernization > Replications in Azure portal with migration status Ready to migrate." lightbox="./media/migrate-hyperv-replicate/migrate-replicated-virtual-machine-1-a.png":::


## Next steps

- Complete [Hyper-V VM Migration](migrate-azure-migrate.md).
