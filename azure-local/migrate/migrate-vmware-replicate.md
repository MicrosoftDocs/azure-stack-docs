--- 
title: Discover and replicate VMware VMs for migration to Azure Local using Azure Migrate (preview) 
description: Learn the discovery and replication process for VMware VMs to Azure Local using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 05/15/2025
ms.author: alkohli
---

# Discover and replicate VMware VMs for migration to Azure Local using Azure Migrate (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the discovery and replication phase for VMware virtual machine (VM) migration to Azure Local using Azure Migrate.

[!INCLUDE [important](../includes/hci-preview.md)]

For more information on appliances for Azure Migrate and how to manage them, see [Azure Migrate appliance](/azure/migrate/migrate-appliance).

## Before you begin

For both the source VMware vCenter Server and target Azure Local appliances, make sure that the underlying hardware has sufficient resources to support the creation of a Windows Server 2022 VM with a minimum of 16 GB RAM, 80 GB of disk storage (HDD), 8 vCPUs, and an external virtual switch.

Ensure all VMs that you wish to migrate are powered on and have VMware tools installed. Migration will fail if the VMs are not powered on and do not have VMware tools installed.

## Step 1: Create and configure the source VMware appliance

### Generate the project key

1. In the Azure portal, go to your Azure Migrate project and then go to **Servers, databases and webapps**.
1. On the **Migration tools** tile, select **Discover**. Make sure to use the **Migration and Modernization Discover** page for Azure Local. If you use the **Discovery and Assessment Discover** page, Azure Local migrations will be blocked.


    :::image type="content" source="./media/migrate-vmware-replicate/generate-source-appliance-project-key-1.png" alt-text="Screenshot of going to Discover page from Migration tools tile for your source appliance." lightbox="./media/migrate-vmware-replicate/generate-source-appliance-project-key-1.png":::
1. On the **Discover** page, select **Azure Local** under **Where do you want to migrate to** and then select **Yes, with VMware vSphere Hypervisor** under **Are your machines virtualized** in Azure Migrate.
1. Enter a name for your source appliance and generate the key for the source VMware appliance. For detailed steps, see [Generate the project key](/azure/migrate/how-to-set-up-appliance-vmware#generate-the-project-key).

1. Copy the **Project key** (to a text editor such as Notepad) and save it for later use.
1. You can now **Download the Azure Migrate source appliance** using either a *.ova* file or a *.zip* file. The detailed steps are provided in the subsequent sections.

    :::image type="content" source="./media/migrate-vmware-replicate/generate-source-appliance-project-key-2.png" alt-text="Screenshot of going to Discover page." lightbox="./media/migrate-vmware-replicate/generate-source-appliance-project-key-2.png":::

### Create the source appliance

You can install the appliance using either an *.ova* file or a *.zip* file that you download to your VMware host server. <!-- REMOVE For more information on appliances for Azure Migrate and how to manage them, see [Azure Migrate appliance](/azure/migrate/migrate-appliance).-->

#### Install using an .OVA file

This step applies only if you are deploying the source VMware appliance using an *.OVA* file.

1. Once you have downloaded the **.OVA** file, [Verify that the file is secure](/azure/migrate/how-to-set-up-appliance-vmware#verify-security). 
1. [Create the source VMware appliance](/azure/migrate/tutorial-discover-vmware#create-the-appliance-server). 
1. [Verify that the appliance can access Azure](/azure/migrate/tutorial-discover-vmware#verify-appliance-access-to-azure). <!--check if this is needed-->


#### Install using a .zip file

This step applies only if you downloaded the .zip file. You use the *AzureMigrateInstaller.ps1* PowerShell script to install the source appliance.
For specific information, see [Set up an appliance with a script](/azure/migrate/deploy-appliance-script).

1. Create a VM in the VMware vCenter with the following configuration:
    - Operating system: Windows Server 2022
    - vCPU: 8
    - Disk: >80 GB
    - Memory: 16 GB
    <!--For detailed steps, see [Creating a VM in vSphere](https://docs.vmware.com/en/VMware-vSphere/6.5/com.vmware.vsphere.html.hostclient.doc/GUID-FBEED81C-F9D9-4193-BDCC-CC4A60C20A4E.html?hWord=N4IghgNiBcIMICcCmYAuSAEA3Alg1ArpBgLZgDGAFjgHZIgC+QA).-->
1. Once the VM is created, sign into the VM as an administrator.
1. Copy the downloaded zip file to the new VM that you created in the vCenter. Extract the zip to a folder and go where the  *AzureMigrateInstaller.ps1* PowerShell script resides in the extracted folder.
1. Open a PowerShell window as an administrator and run the following command:

    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    
    .\AzureMigrateInstaller.ps1 -Scenario VMware -Cloud Public -PrivateEndpoint:$false -EnableAzureStackHCITarget
    ```

1. Select option 1 as the desired configuration: **Primary appliance to discover, assess and migrate servers**.
1. Follow the rest of the onscreen instructions to install the source appliance and uninstall Internet Explorer.
1. Restart the VM after the installation is complete. Sign in to the VM.

### Configure the source appliance and discover VMs

Once the source appliance is installed, follow these steps:

1. [Configure the source appliance](/azure/migrate/tutorial-discover-vmware#configure-the-appliance). Complete these steps.
    1.  [Set up the prerequisites and register the source appliance](/azure/migrate/tutorial-discover-vmware#set-up-prerequisites-and-register-the-appliance).

        :::image type="content" source="./media/migrate-vmware-replicate/setup-prereq-register-source-appliance-1.png" alt-text="Screenshot of registration of source appliance completed." lightbox="./media/migrate-vmware-replicate/setup-prereq-register-source-appliance-1.png":::

    1. Make sure that the VMware Virtual Disk Development Kit (VDDK) is installed. Download and extract the **VMware Virtual Disk Development Kit** in zip format to the provided folder path. Versions 8.0.0, 8.0.1, and 8.0.2 are currently supported. Version 6.7.0 is also supported but the package is deprecated, hence the new deployments are unable to use this version. 

        > [!IMPORTANT]
        > Do not use VDDK 7.0.X. These versions have known issues and result in errors during migration.

    1. Select **Verify** to make sure that the VMware VDDK is successfully installed.

        :::image type="content" source="./media/migrate-vmware-replicate/verify-vddk-installation-1.png" alt-text="Screenshot of verification of VDDK installation." lightbox="./media/migrate-vmware-replicate/verify-vddk-installation-1.png":::

    1. Provide vCenter server credentials for the discovery of VMware VMs.
        1. Select **Add credentials**.
        1. Select the **Source type** as vCenter Server.
        1. Provide a **Friendly name** for the credentials.
        1. Enter the **Username** and the **Password** for the vCenter server.
        1. **Save** the credentials.
    1. Add discovery sources.
        1. Add the vCenter discovery source.
        1. Enter the IP address or FQDN of the vCenter server.
        1. Enter the friendly name for the credentials used when discovering the VMware VMs.
        1. Select **Save**. Select **Add more** to repeat this step for each vCenter server. The discovery source table is updated.

        :::image type="content" source="./media/migrate-vmware-replicate/manage-credentials-discovery-sources-1.png" alt-text="Screenshot of credentials and discovery sources configured." lightbox="./media/migrate-vmware-replicate/manage-credentials-discovery-sources-1.png":::

    1. Disable the slider under the **Applications discovery and agentless dependency analysis** section, as this is currently not supported in VMware to Azure Local migrations.
    1. Select **Start Discovery**. The discovery may take several minutes to finish.

You'll next onboard to the target Azure Local instance.

### Onboard to Azure Local

You now add information to onboard the discovered VMs.

1. Select **Add information**.
1. Enter the **Domain** for your target Azure Local system.
1. Provide the **Username** and the **Password** for the target Azure Local system.
1. Select **Save**.

:::image type="content" source="./media/migrate-vmware-replicate/add-target-cluster-information-11.png" alt-text="Screenshot showing Add information popup for source appliance." lightbox="./media/migrate-vmware-replicate/add-target-cluster-information-1.png":::

The information table is updated and the status changes to **Validated**.

:::image type="content" source="./media/migrate-vmware-replicate/add-target-cluster-information-2.png" alt-text="Screenshot showing Add system information is added to the table." lightbox="./media/migrate-vmware-replicate/add-target-cluster-information-2.png":::

### Wait for the discovery to complete

Wait until you have a green checkmark indicating that the discovery is finished. The migration readiness checks are also completed successfully. After the discovery is complete, go to the Azure portal to review the VM inventory.

Ensure that all VMs you want to migrate are powered on and have VMware tools installed before or during the discovery process.

:::image type="content" source="./media/migrate-vmware-replicate/discovery-complete-1.png" alt-text="Screenshot showing that discovery is complete." lightbox="./media/migrate-vmware-replicate/discovery-complete-1.png":::

## Step 2: Create and configure the target appliance

### Generate target appliance key

Complete the following tasks to generate the target appliance key:

1. In the Azure portal, go to your Azure Migrate project and select **Servers, databases and web apps**.

1. Verify that you see a nonzero value for **Discovered servers** under **Migration tools**.

    :::image type="content" source="./media/migrate-vmware-replicate/replicate-discovered-servers.png" alt-text="Screenshot showing the discovered servers." lightbox="./media/migrate-vmware-replicate/replicate-discovered-servers.png":::

1. Under **Migration and modernization**, select **Replicate**.

1. On the **Specify intent** page, provide the following inputs:

    - Select Servers or virtual machines (VM) for **What do you want to migrate?**.
    - Select **Azure Local** for **Where do you want to migrate?**.
    - Select **VMware vSphere** for **Virtualization type**.
    - For the **On-premises appliance** the source appliance is pre-populated. If you have more than one source appliance, select the applicable one from the dropdown list.

    :::image type="content" source="./media/migrate-vmware-replicate/replicate-specify-intent.png" alt-text="Screenshot showing the Specify intent page." lightbox="./media/migrate-vmware-replicate/replicate-specify-intent.png":::

1. Select **Download and configure** in **Before you start replication to Azure Local** from the information block.

1. On the **Deploy and configure the target appliance** pane, provide a name for the target appliance and then select **Generate key**.

    :::image type="content" source="./media/migrate-vmware-replicate/generate-target-key-1.png" alt-text="Screenshot showing the Generate key popup." lightbox="./media/migrate-vmware-replicate/generate-target-key-1.png":::

1. Copy the **Project key** (to a text editor such as Notepad) and save it for later use.

### Create the target appliance

:::image type="content" source="./media/migrate-vmware-replicate/deploy-target-appliance-zip.png" alt-text="Screenshot showing the Download using zip option." lightbox="./media/migrate-vmware-replicate/deploy-target-appliance-zip.png":::

<!--#### Install using a .VHD file

This step applies only if you downloaded the *.VHD* file.

1. On the machine where you downloaded the file, open an administrator command window.
1. Run the following command to generate the hash for the VHD.
    
    ```powershell
    C:\>Get-FileHash -Path <file_location> -Algorithm <Hashing Algorithm>
    ```

    Here's an example output.

    ```output
    C:\>Get-FileHash -Path ./AzureMigrateAppliance_v3.20.09.25.zip -Algorithm SHA256
    ```

1. Verify the latest appliance versions and hash values for Azure public cloud:

    
    |**Scenario**  |**Download**  |**SHA256**  |
    |---------|---------|---------|
    |Azure Local appliance     |Latest version: `https://go.microsoft.com/fwlink/?linkid=2191847`         |07783a31d1e66be963349b5553dc1f1e94c70aa149e11ac7d8914f4076480731         |

1. Extract the zip file to a folder.

Now you can install the appliance using the .VHD file.

1. On a Hyper-V server, go to the Hyper-V Manager. Select **Hyper-V Manager > Connect to server**.

1. On the **Select Computer** dialog box, select **Another computer**. Browse to the Azure Local machine, and then select **OK**.

1. Map the drive on your Azure Local machine where you downloaded the VHD. Connect to this drive using File Explorer. Verify that you can access the location where the VHD was downloaded on your Azure Local machine.

1. On your Hyper-V server, from the **Actions** pane, select **Import Virtual Machine**. This starts a wizard. Go through the steps of the wizard. Accept the defaults except on the following:

    1. On the **Locate Folder** page, point to the folder that has the VHD (folder name is AzureMigrateAppliance.zip) that you downloaded on your Azure Local machine.
    1. On the **Connect Network** page, select a switch from the dropdown list for **Connection**. Create a VM using the VHD you downloaded, then start and sign into the VM. Make sure the VM has access to the internet.
    1. Finally review the settings and select **Finish**.

1. In the Hyper-V Manager, under **Virtual Machines**, you see the VM you created. Select and start the VM.

1. Once the VM starts, accept the license terms and conditions. On the **Customize settings** page, provide and confirm a password for the administrator account and then select **Finish**.

1. After the VM has started up, sign in to the VM as an administrator. Enter the password you provided in the previous step.-->


#### Install using a script (.zip file)

This step applies to using a .zip file.

1. You can download the appliance from a .zip file. Under  **Step 2: Download and install the target appliance**, select **.zip** and then select **Download**.

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

1. Open **Azure Migrate Target Appliance Configuration Manager** from the desktop shortcut. Read and accept the **Terms of Use**.

    :::image type="content" source="./media/migrate-vmware-replicate/terms-of-use-1.png" alt-text="Screenshot showing the terms of use on launching Azure Migrate Target Appliance Configuration Manager." lightbox="./media/migrate-vmware-replicate/terms-of-use-1.png":::

1. Locate the target key that you previously generated, paste it in the field under **Verification of Azure Migrate project key**, and then select **Verify**.

    :::image type="content" source="./media/migrate-vmware-replicate/verify-target-appliance-project-key-1.png" alt-text="Screenshot showing Verify selected under Verification of Azure Migrate project key." lightbox="./media/migrate-vmware-replicate/verify-target-appliance-project-key-1.png":::


1. After the verification is complete, select **Log in** and sign in to your Azure account.

1. Enter the code that is displayed in your Authenticator (or similar) app for MFA authentication.

    :::image type="content" source="./media/migrate-vmware-replicate/enter-code-1.png" alt-text="Screenshot showing the Authenticate code popup." lightbox="./media/migrate-vmware-replicate/enter-code.png":::

1. Wait until you see **The appliance has been successfully registered** message.

    :::image type="content" source="./media/migrate-vmware-replicate/target-appliance-registered-1.png" alt-text="Screenshot showing the Azure Migrate Target Appliance successfully registered." lightbox="./media/migrate-vmware-replicate/target-appliance-registered-1.png":::

1. Sign in to Microsoft Azure PowerShell using the code displayed in your Authenticator app. It can take up to 10 minutes for the appliance to be registered.

    :::image type="content" source="./media/migrate-vmware-replicate/enter-code-2.png" alt-text="Screenshot showing the Azure Login popup." lightbox="./media/migrate-vmware-replicate/enter-code-22.png":::

1. After the appliance is registered, under **Manage Azure Local instance information**, select **Add system information**.

    :::image type="content" source="./media/migrate-vmware-replicate/add-target-appliance-information-1.png" alt-text="Screenshot showing Add system information button." lightbox="./media/migrate-vmware-replicate/add-target-appliance-information-1.png":::

1. For your target Azure Local instance, enter the system FQDN (example format is *systemname.domain.com*), domain name, username, and password, and then select **Save**.

    :::image type="content" source="./media/migrate-vmware-replicate/add-target-appliance-information-2.png" alt-text="Screenshot showing Add cluster information popup." lightbox="./media/migrate-vmware-replicate/add-target-appliance-information-22.png":::

1. After the credentials are accepted, the status changes to **Validated**. Select **Configure**.

1. Wait until the configuration is complete and you see this message: **Successfully configured Azure Migrate project.**


## Step 3: Start replication

1. In the Azure portal, go to your Azure Migrate project and select **Servers, databases and web apps**.

1. Under **Migration tools**, select **Replicate**.

    :::image type="content" source="./media/migrate-vmware-replicate/replicate-start-1.png" alt-text="Screenshot showing the Replicate start process." lightbox="./media/migrate-vmware-replicate/replicate-start-1.png":::

1. On the **Specify intent** page:
    1. **What do you want to migrate** is automatically populated as **Servers or virtual machines (VM)**.
    1. Select **Azure Local** for **Where do you want to migrate to ?**
    1. Select **VMware vSphere** for the **Virtualization type**.
    1. Select the source appliance as the **On-premises appliance** used for discovery.
    1. When finished, select **Continue**.

    :::image type="content" source="./media/migrate-vmware-replicate/replication-specify-intent-1.png" alt-text="Screenshot showing the replication Specify intent page." lightbox="./media/migrate-vmware-replicate/replication-specify-intent-1.png":::

1. On the **Replicate** page, on the **Basics** tab:

    1. The subscription field is automatically populated. If this isn't the subscription that has your target Azure Local instance, choose the Azure subscription that has the system.
    1. Select the resource group associated with your target system.
	1. For **Target system**, select the Azure Local resource.
	1. Verify there's a green check for the system. A green check indicates that all the prerequisites such as Azure Arc resource bridge are configured on this system.
    1. When finished, select **Next**.
    
    :::image type="content" source="./media/migrate-vmware-replicate/replicate-1-basics.png" alt-text="Screenshot showing the Basics tab." lightbox="./media/migrate-vmware-replicate/replicate-1-basics.png":::
    

1. On the **Target appliance** tab, look for a green checkmark to verify that the target appliance is connected.

    > [!NOTE]
    > A green checkmark indicates that the target appliance is successfully registered and configured. If you haven't configured your target appliance yet, you will see the configuration page here instead.

1. Select **Next**.

    :::image type="content" source="./media/migrate-vmware-replicate/replicate-2-target.png" alt-text="Screenshot showing the Target appliance tab." lightbox="./media/migrate-vmware-replicate/replicate-2-target.png":::

1. On the **Virtual machines** tab, verify the VMs were discovered and are listed. You can select up to 10 VMs from the portal list to replicate at one time. Select **Next**.

    :::image type="content" source="./media/migrate-vmware-replicate/replicate-3-vm.png" alt-text="Screenshot showing the Virtual machines tab." lightbox="./media/migrate-vmware-replicate/replicate-3-vm.png":::

1. On the **Target settings** tab, complete these tasks:

    1. The **Storage account subscription** is automatically populated. If this isn't the subscription where you want to create the storage account, choose another subscription.
        
        > [!NOTE]
        > Migration requires a storage account to be created. This account must reside in the same subscription as your Azure project.

    1. Select the **Resource group** to associate with your storage account.
    
    1. The VM subscription is automatically populated.
    
    1. For your **Cache storage account**, select an existing storage account. You can also select **(New) Storage account** to create a new storage account with a randomly generated name.

        > [!NOTE]
        > We recommend that you create a new storage account to be used as your cache storage account.

    1. Select a resource group to associate with your migrated VMs. This resource group can be different than the resource group associated with your storage account.
   
	1. Select the logical network that you created as a [prerequisite](./migrate-vmware-prerequisites.md#prerequisites-for-vmware-migration-to-azure-local-using-azure-migrate-preview). The VMs are connected to this network. 

        If you don't see a logical network in the dropdown list, [Create a logical network](../manage/create-logical-networks.md) and select **Reload logical network**.

	1. Select the storage path that you created as a [prerequisite](./migrate-vmware-prerequisites.md#prerequisites-for-vmware-migration-to-azure-local-using-azure-migrate-preview). The VMs are created at this storage path.

        If you don't see a storage path in the dropdown list, [Create a storage path](../manage/create-storage-path.md) and select **Reload storage path**.

    1. When finished, select **Next**.

        :::image type="content" source="./media/migrate-vmware-replicate/replicate-4-target-2.png" alt-text="Screenshot showing the Target settings tab." lightbox="./media/migrate-vmware-replicate/replicate-4-target-2.png":::

1. On the **Compute** tab:

	1. Rename target VMs as needed. Make sure that the VM names conform to the [Azure naming conventions](/azure/azure-resource-manager/management/resource-name-rules#microsoftcompute).
	1. Select the OS disk for each VM from the dropdown lists.
    1. Configure number of vCPUs and RAM including selecting dynamic RAM for each VM, as needed.
    1. When finished, select **Next**.
    
        :::image type="content" source="./media/migrate-vmware-replicate/replicate-5-compute.png" alt-text="Screenshot showing the Compute tab." lightbox="./media/migrate-vmware-replicate/replicate-5-compute.png":::

1. On the **Disks** tab, select which disks you would like to replicate.

    > [!NOTE]
    > Once selected, the OS disks can't be unselected.
 
1. Change the disk type if needed and select **Next**.

    :::image type="content" source="./media/migrate-vmware-replicate/replicate-6-disks.png" alt-text="Screenshot showing the Disks tab." lightbox="./media/migrate-vmware-replicate/replicate-6-disks.png":::

1. On the  **Review + Start replication** tab, make sure that all the values are correct and then select **Replicate**.

    :::image type="content" source="./media/migrate-vmware-replicate/replicate-7-review.png" alt-text="Screenshot showing the Review + Start replication tab." lightbox="./media/migrate-vmware-replicate/replicate-7-review.png":::

1. Stay on this page until the process is complete (this might take 5-10 minutes). If you move away from this page, the replication artifacts won't be created fully leading to a failure in replication and eventually migration.

    :::image type="content" source="./media/migrate-vmware-replicate/replicate-77-review.png" alt-text="Screenshot showing the warning on the Review + Start replication tab." lightbox="./media/migrate-vmware-replicate/replicate-77-review.png":::

1. You're automatically taken to **Servers, databases and web apps** page. On the **Migration tools** tile, select **Overview**.

1. Go to **Azure Local migration > Replications**. Review the replication status. Select **Refresh** to see the replicated VMs appear.
 
1. As the replication continues, replication status shows progress. Continue refreshing periodically. After the initial replication is complete, hourly delta replications begin. The **Migration status** changes to **Ready to migrate**. The VMs can be migrated.

    :::image type="content" source="./media/migrate-vmware-replicate/migrate-replicated-virtual-machine-1-a.png" alt-text="Screenshot showing Replications page in Azure portal with migration status Ready to migrate." lightbox="./media/migrate-vmware-replicate/migrate-replicated-virtual-machine-1-a.png":::


## Next steps

- Complete [VMware VM Migration](migrate-vmware-migrate.md).
