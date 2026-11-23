--- 
title: Discover and replicate Hyper-V VMs for migration to Azure Local using Azure Catalyst (preview)
description: Learn the discovery and replication process for Hyper-V VMs to Azure Local using Azure Catalyst (preview).
author: scompton1045
ms.topic: how-to
ms.date: 11/13/2026
ms.author: scompton
ms.custom: sfi-image-nochange
ms.subservice: hyperconverged
---

# Discover and replicate Hyper-V VMs for migration to Azure Local using Azure Catalyst (preview)

[!INCLUDE [hci-applies-to-2503](../includes/hci-applies-to-2503.md)]

This article describes the discovery and replication phase for Hyper-V virtual machine (VM) migration to Azure Local using Azure Catalyst.

[!INCLUDE [important](../includes/hci-preview.md)]

For more information about appliances for Azure Catalyst and how to manage them, see [Azure Migrate appliance](/azure/migrate/migrate-appliance).

If your Azure Local instance is in Azure Government, see [Migrate VMs to Azure Local in Azure Government](migrate-azure-government.md) for the steps that differ. To replicate and migrate VMs by using PowerShell, Azure CLI, or Terraform instead of the Azure portal, see [Migrate VMs to Azure Local using PowerShell, Azure CLI, or Terraform](migrate-via-powershell.md).

## Before you begin

For both the source and target appliance, make sure that your hardware has sufficient resource to support the creation of a Windows Server 2022 VM with 16 GB RAM, 80 GB of disk storage, 8 vCPUs, and an external virtual switch.

Ensure all VMs that you wish to migrate are powered on and have [Hyper-V integration services](/windows-server/virtualization/hyper-v/manage/manage-hyper-v-integration-services) installed. Migration will fail if the VMs are not powered on and do not have Hyper-V integration services installed.

## Step 1: Create and configure the source appliance

### Generate the project key

1. In the Azure portal, go to **Azure Migrate** > **All projects** and select your project from the list.

1. On the project **Overview**, under **Inventory**, select **Start discovery**.

    :::image type="content" source="./media/migrate-hyperv-replicate/generate-source-appliance-project-key-1.png" alt-text="Screenshot of the project Overview page with Start discovery highlighted." lightbox="./media/migrate-hyperv-replicate/generate-source-appliance-project-key-1.png":::

1. On **Start discovery**, for **How do you want to discover?**, select **Using appliance**, and then select **Continue**. Azure Local migrations support only appliance-based discovery.

    :::image type="content" source="./media/migrate-hyperv-replicate/start-discovery-using-appliance.png" alt-text="Screenshot of the Start discovery page with Using appliance selected." lightbox="./media/migrate-hyperv-replicate/start-discovery-using-appliance.png":::

1. On the **Discover** page, under **Are your servers virtualized?**, select **Yes, with Hyper-V**.
1. Under **1: Generate project key**, enter a name for your source appliance, and then select **Generate key**.

1. Copy the **Project key** (to a text editor such as Notepad) and save it for later use. You can also find the key later by selecting **Manage existing appliances**.
1. Under **2: Download Azure Migrate appliance**, download the source appliance by using either a .VHD or a *.zip* file. The detailed steps are provided in the subsequent sections.

    :::image type="content" source="./media/migrate-hyperv-replicate/generate-source-appliance-project-key-2.png" alt-text="Screenshot of the Discover page with Yes, with Hyper-V selected, the Generate project key step, and the appliance download options." lightbox="./media/migrate-hyperv-replicate/generate-source-appliance-project-key-2.png":::

### Create the source appliance

You can install the source appliance by using either a template (.VHD file) or a script (.zip file).

#### Install using a template (.VHD file)

This step applies only if you downloaded the .VHD file.

1. On the machine where you downloaded the file, open PowerShell as an administrator and run the following command to generate the hash for the file. Compare the hash with the latest value listed in [Verify security](/azure/migrate/migrate-appliance#verify-security).

    ```powershell
    Get-FileHash -Path <path to the downloaded file> -Algorithm SHA256
    ```

1. Extract the zipped file to a folder on the Hyper-V host that hosts the appliance. The zipped file contains three folders.

1. Open Hyper-V Manager. Under **Actions**, select **Import Virtual Machine**.

1. In the **Import Virtual Machine** wizard, complete these steps:

    1. On **Before You Begin**, select **Next**.
    1. On **Locate Folder**, select the folder that contains the extracted files, and then select **Next**.
    1. On **Select Virtual Machine**, select **Next**.
    1. On **Choose Import Type**, select **Copy the virtual machine (create a new unique ID)**, and then select **Next**.
    1. On **Choose Destination** and **Storage Folders**, keep the default settings, and then select **Next**.
    1. On **Choose Network**, select the virtual switch for the appliance. The switch needs internet connectivity to send data to Azure.
    1. On **Summary**, review the settings, and then select **Finish**.

1. In Hyper-V Manager, under **Virtual Machines**, start the appliance VM. Right-click the VM, and then select **Connect**.

1. Provide the language, time zone, and password for the appliance, and then sign in.

#### Install using a script (.zip file)

This step applies only if you downloaded the .zip file.

1. Create a VM on your Hyper-V host with the following configuration:

    - Operating system: Windows Server 2022 or Windows Server 2025
    - vCPU: 8
    - Disk: >80 GB
    - Memory: 16 GB
    - Network: An external virtual switch

1. After you create the VM, sign in to the VM as an administrator.

1. Copy the downloaded .zip file to the VM. Extract it to a folder, and then go to the folder that contains the `AzureMigrateInstaller.ps1` PowerShell script.

    > [!NOTE]
    > Don't run the script on a server that already has an Azure Migrate appliance. The script replaces the existing appliance configuration.

1. Open PowerShell as an administrator and run the following command:

    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted
    .\AzureMigrateInstaller.ps1 -Scenario HyperV -Cloud Public -PrivateEndpoint:$false
    ```

1. Follow the onscreen instructions to install the source appliance. If the installation fails, check the log at `C:\ProgramData\Microsoft Azure\Logs\AzureMigrateScenarioInstaller_<timestamp>.log`.

1. Restart the VM after the installation is complete. Sign in to the VM.

### Configure the appliance and discover VMs

1. Open the appliance configuration manager by using the shortcut on the appliance desktop. You can also open it from any machine that can reach the appliance at `https://<appliance-name-or-IP-address>:44368`. Accept the license terms.

1. Under **Set up prerequisites**, the appliance checks its connectivity to Azure and whether its time is in sync. If the appliance uses a proxy, select **Set up proxy**, enter the proxy address and port, and then select **Save**. Only HTTP proxy is supported.

1. Under **Check latest updates and register appliance**, paste the project key for the source appliance that you copied earlier, and then select **Verify**. The appliance updates its services to the latest versions.

1. Select **Login**, and then select **Copy code & Login**. In the new browser tab, paste the code and sign in to your Azure account. Return to the configuration manager and wait until you see **The appliance has been successfully registered**. Your Azure account needs the permissions in [Azure account permissions](migrate-hyperv-requirements.md#azure-account-permissions).

    If needed, you can use a preconfigured Microsoft Entra ID application to register the source appliance. For more information, see [Register an Azure Migrate appliance with a preconfigured Microsoft Entra ID application](./migrate-faq.yml).

    > [!NOTE]
    > Each preconfigured application can only be used with a single appliance. You must create a separate preconfigured application for the target appliance and for any additional appliances in other projects.

1. If the disks of the VMs that you want to migrate are on SMB shares, enable delegation of credentials from the appliance to the Hyper-V hosts. On the appliance, open PowerShell as an administrator and run the following command. Replace the example host names with the names of your Hyper-V hosts.

    ```powershell
    Enable-WSManCredSSP -Role Client -DelegateComputer HyperVHost1.contoso.com, HyperVHost2.contoso.com, HyperVHost1, HyperVHost2 -Force
    ```

1. Under **Provide Hyper-V host credentials**, select **Add credentials**. Enter a friendly name and the username and password that the appliance uses to connect to your Hyper-V hosts or cluster, and then select **Save**.

1. Under **Provide Hyper-V host/cluster details**, select **Add discovery source**. Enter the IP address or FQDN of each Hyper-V host or cluster and the friendly name of the credentials to use, and then select **Save**.

    The appliance validates the connection to each host or cluster and shows the result under **Validation status**. If validation fails, select **Validation failed** to see the error. Fix the issue, and then validate again.

1. Providing server credentials for software inventory and dependency analysis is optional. To skip it, turn off the slider under **Provide server credentials**.

### Onboard to Azure Local

1. After you add the discovery sources, onboard to the target Azure Local instance. This step validates connectivity between the source appliance and the target Azure Local instance, and provides the information needed about the target system for migration.
1. Toggle the slider to **Enable credentials for Azure Local**.

    :::image type="content" source="media/migrate-vmware-replicate/enable-azure-local-credentials.png" alt-text="Screenshot of how to enable credentials for Azure Local appliance.":::

1. Select **Add information** to provide the necessary information and credentials for the target Azure Local instance.
1. Select **Save**.

    :::image type="content" source="./media/migrate-vmware-replicate/add-target-cluster-information-11.png" alt-text="Screenshot showing Add information popup for source appliance." lightbox="./media/migrate-vmware-replicate/add-target-cluster-information-1.png":::

1. The information table is updated and the status changes to **Validated**.

    :::image type="content" source="./media/migrate-vmware-replicate/add-target-cluster-information-2.png" alt-text="Screenshot showing Add system information is added to the table." lightbox="./media/migrate-vmware-replicate/add-target-cluster-information-2.png":::

### Start discovery

1. Once the source appliance is configured and onboarded to Azure Local, you can start the discovery of Hyper-V VMs.
1. Select **Start Discovery**. The discovery may take several minutes to finish.

	:::image type="content" source="media/migrate-vmware-replicate/start-discovery.png" alt-text="Screenshot showing how to start the discovery source appliance." lightbox="media/migrate-vmware-replicate/start-discovery.png":::

1. Wait until you see green checkmarks to indicate that the discovery and migration readiness are complete.
1. Go to the Azure portal to review the VM inventory.
1. Ensure all the VMs you want to migrate are powered on and [Hyper-V integration services](/windows-server/virtualization/hyper-v/manage/manage-hyper-v-integration-services) is installed before or during the discovery process.

	:::image type="content" source="./media/migrate-vmware-replicate/discovery-complete-1.png" alt-text="Screenshot showing that discovery is complete." lightbox="./media/migrate-vmware-replicate/discovery-complete-1.png":::

## Step 2: Create and configure the target appliance

### Generate target appliance key

Generate the target appliance key from the **Replicate** wizard. Open the wizard from **Server replication**, the page in your project where you replicate, migrate, and track the VMs that you move to Azure Local.

1. In the Azure portal, go to your project and select **Overview**. Under **Inventory summary**, verify that **Workloads** shows a value greater than zero.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-discovered-servers.png" alt-text="Screenshot of the inventory summary on the project Overview page with the number of discovered workloads highlighted." lightbox="./media/migrate-hyperv-replicate/replicate-discovered-servers.png":::

1. In the left pane, under **Manage**, select **Server replication**.

    Until you replicate VMs to Azure Local, the page shows **No replicating items found** and columns that don't apply to Azure Local, such as **Test migration status**. After you replicate VMs, the page shows the Azure Local columns, and **Start replication** changes to **Replicate**.

1. Select **Start replication**.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-start.png" alt-text="Screenshot of the Server replication page with Server replication highlighted in the left pane and Start replication highlighted on the command bar." lightbox="./media/migrate-hyperv-replicate/replicate-start.png":::

1. On the **Specify intent** page:
    1. **What do you want to migrate?** is automatically populated as **Servers or Virtual machines (VM)**.
    1. For **Where do you want to migrate to?**, select **Azure Local (formerly Azure Stack HCI)**. **How will you select workloads?** is set to **From all inventory**.
    1. For **Discovery method**, select the source appliance that you used for discovery.
    1. When finished, select **Continue**.

    :::image type="content" source="./media/migrate-hyperv-replicate/replication-screen.png" alt-text="Screenshot of the Specify intent page with Azure Local selected." lightbox="./media/migrate-hyperv-replicate/replication-screen.png":::

1. On the **Basics** tab of the **Replicate** wizard, select the subscription, resource group, and target system for your Azure Local instance. Verify that the system shows a green check, and then select **Next**.

1. On the **Appliances** tab, select **Deploy and configure target appliance**.

1. On the **Deploy and configure the target appliance** pane, provide a name for the target appliance and then select **Generate key**.

    :::image type="content" source="./media/migrate-hyperv-replicate/generate-target-key.png" alt-text="Screenshot showing the Generate key popup." lightbox="./media/migrate-hyperv-replicate/generate-target-key.png":::

1. Copy and paste the project key to a text editor (for example, Notepad) after it is generated for future use. You can close the **Replicate** wizard. You start replication after you register the target appliance.

### Create the target appliance

You can download the appliance using either a .VHD file or a .zip file.

Under **Step 2: Download Azure Migrate appliance**, select either **.VHD** or **.zip**, and then select **Download installer**.

:::image type="content" source="media/migrate-hyperv-replicate/download-target-appliance.png" alt-text="Screenshot of download target appliance step 2." lightbox="media/migrate-hyperv-replicate/download-target-appliance.png":::

#### Install the appliance using a template (.vhd file)

This step applies only if you downloaded the .vhd zipped file. 

1. Check that the zipped file is secure, before you deploy it. 

1. On the machine where you downloaded the file, run PowerShell as an administrator.
1. To generate the hash for the VHD, run the following command.

    ```powershell
    C:\>Get-FileHash -Path <Path to downloaded VHD zip>  -Algorithm SHA256
    ```

1. Verify the latest appliance versions and hash values: 
    
    |**Scenario**  |**Download**  |**SHA256**  |
    |---------|---------|---------|
    |Azure Local appliance |Latest version: `https://go.microsoft.com/fwlink/?linkid=2191847` |6ae1144b026efb2650f5e11c007a457c351a752f942c2db827dd2903f468dccb |

1. Extract the zipped file to a folder. 

Now you can install the appliance using the .vhd file.

1. Use a local tool, such as Hyper-V Manager or Failover Cluster, and install the target appliance from the downloaded .vhd file on your Azure Local instance. 

1. After the VM has finished provisioning and has booted, open the **Azure Migrate Target Appliance Configuration Manager** shortcut from the desktop. 

#### Install using a script (.zip file)

This step applies to using a .zip file.

1. Create a VM in Azure Local with the following configuration: 
    - Operating system: Windows Server 2022 or Windows Server 2025
    - vCPU: 8 
    - Disk: >80 GB 
    - Memory: 16 GB 

1. Once the VM is created, sign into the VM as an administrator. 

1. Download the appliance from a .zip file. Refer to **Step 2: Download and install the target appliance**, select **.zip**, and then select **Download**. 

1. Copy the downloaded zip file to the new VM that you created on the Azure Local instance. Extract the zip to a folder and go to the `AzureMigrateInstaller.ps1` PowerShell script in the extracted folder. 

1. Open PowerShell as an administrator and run the following:

    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted 
    .\AzureMigrateInstaller.ps1 -Scenario AzureLocalTarget -Cloud Public -PrivateEndpoint:$false
    ``` 

1. Restart the VM after the installation is complete. Sign in to the VM. 

### Register the target appliance

1. Sign in to the target appliance VM.

1. Open **Azure Migrate Target Appliance Configuration Manager** from the desktop shortcut.

1. Locate the target key that you previously generated, paste it in the field under **Verification of Azure Migrate project key**, and then select **Verify**.

1. After the verification is complete, select **Log in** and sign in to your Azure account.
   
    - If needed, you can use a preconfigured Microsoft Entra ID application to register the target appliance. For more information, see [Register an Azure Migrate appliance with a preconfigured Microsoft Entra ID application](./migrate-faq.yml). 

   	> [!NOTE]
    > Each preconfigured application can only be used with a single appliance. You must create a separate preconfigured application for each appliance.

1. Enter the code that is displayed in your Authenticator (or similar) app for MFA authentication.

    :::image type="content" source="./media/migrate-hyperv-replicate/enter-code.png" alt-text="Screenshot showing the authenticate code popup." lightbox="./media/migrate-hyperv-replicate/enter-code.png":::

1. Wait until you see **The appliance has been successfully registered** message.

1. Sign in to Microsoft Azure PowerShell using the code displayed in your Authenticator app. It can take up to 10 minutes for the appliance to be registered.

    :::image type="content" source="./media/migrate-hyperv-replicate/enter-code-2.png" alt-text="Screenshot showing the Azure Login popup." lightbox="./media/migrate-hyperv-replicate/enter-code-2.png":::

1. After the appliance is registered, under **Provide Azure Local instance information**, select **Add system information**.

    :::image type="content" source="./media/migrate-hyperv-replicate/add-cluster-info.png" alt-text="Screenshot showing Add cluster information button." lightbox="./media/migrate-hyperv-replicate/add-cluster-info.png":::

1. For your target Azure Local instance, enter the fully qualified domain name (FQDN), domain name, username and password, and then select **Save**.

    :::image type="content" source="./media/migrate-hyperv-replicate/add-cluster-info-2.png" alt-text="Screenshot showing Add cluster information popup." lightbox="./media/migrate-hyperv-replicate/add-cluster-info-2.png":::

1. After the credentials are accepted, the status changes to **Validated**. Select **Configure**.

1. Wait until the configuration is complete and you see this message: **Successfully configured Azure Migrate project.**

## Step 3: Start replication

After you register the target appliance, return to **Server replication** to start replication.

1. In the Azure portal, go to your project. In the left pane, under **Manage**, select **Server replication**, and then select **Start replication**. If the project already has replicated VMs, select **Replicate** instead.

1. On the **Specify intent** page, select the same values that you used in [Generate target appliance key](#generate-target-appliance-key), and then select **Continue**.

1. On the **Replicate** page, on the **Basics** tab:

    1. The **Subscription** field is automatically populated. If it's not the subscription that has your target Azure Local instance, choose the Azure subscription that has the system.
    1. Select the **Resource group** associated with your target system.
	1. For **Target system**, select the Azure Local resource.
	1. Verify there's a green check for the system. A green check indicates that all prerequisites such as Azure Arc resource bridge are configured on this system.
    1. When finished, select **Next**.
    
    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-1-basics.png" alt-text="Screenshot showing the Basics tab." lightbox="./media/migrate-hyperv-replicate/replicate-1-basics.png":::
    
1. On the **Appliances** tab:

    1. **Source appliance** shows the appliance that you selected on the **Specify intent** page.
    1. For **Target appliance**, select the target appliance on your Azure Local instance.
    1. Verify that both appliances show a green checkmark. The message confirms that the appliance is connected and shows when its Azure Local credentials for the selected system were last verified.
    1. When finished, select **Next**.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-2-target.png" alt-text="Screenshot showing the Appliances tab with connected source and target appliances." lightbox="./media/migrate-hyperv-replicate/replicate-2-target.png":::

    > [!NOTE]
    > If an appliance is disconnected, or its Azure Local credentials are missing, no longer valid, or don't match the selected system, fix the issue on the appliance and then select the refresh button next to it. To update credentials, see [Onboard to Azure Local](#onboard-to-azure-local) for the source appliance and [Register the target appliance](#register-the-target-appliance) for the target appliance. If no target appliance is registered for the system, select **Deploy and configure target appliance** to set one up.

1. On the **Virtual machines** tab:

    1. For **Do you want to retain the Azure Arc-enabled server connected machine agents during migration?**, select **Yes** or **No**. You must select an option to continue.

        - **Yes**: Reuse the existing Azure Arc resources of Arc-enabled source VMs. After you select the VMs, select **Configure Arc-enabled server reuse**, choose the VMs to reuse, and then select **Save**. **Next** stays unavailable until you save this configuration.
        - **No**: Azure Catalyst creates a new Azure Local VM resource for every migrated VM. If any source VMs are Arc-enabled servers, uninstall the Azure Connected Machine agent on them before you migrate.

    1. Select up to 10 VMs to replicate. Use the search box to filter the list. VMs that can't be replicated are unavailable and show the reason next to the name, such as **already in replication** or **VM powered off**. After you fix the issue, it can take up to 30 minutes for the VM to become available.
    1. To review your selection or remove VMs from it, select **Selected virtual machines**.
    1. When finished, select **Next**.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-3-vm.png" alt-text="Screenshot showing the Virtual machines tab with the Arc reuse option and selected VMs." lightbox="./media/migrate-hyperv-replicate/replicate-3-vm.png":::

    > [!NOTE]
    > Arc reuse preserves each resource's tags, role assignments, Azure Policy assignments, and extensions, but locks the target resource group and VM name for every VM in the batch. You can't change the setting after replication starts. For more information, see [Reuse Azure Arc-enabled server resources when you migrate VMs to Azure Local](migrate-arc-reuse.md).

1. On the **Security** tab, choose the security settings for the migrated VMs. Only Generation 2 (UEFI) VMs, shown with a **Boot type** of **efi**, support Secure Boot and the Trusted launch security type. Generation 1 (BIOS) VMs are migrated with the **Standard** security type, and Secure Boot shows **Not available**.

    1. For each Generation 2 VM, select a **Security type**:

        - **Standard**: Migrates the VM with the basic level of security.
        - **Trusted Launch**: Creates the Azure Local VM with Secure Boot and a virtual Trusted Platform Module (vTPM) enabled. Trusted launch requires Secure Boot, so **Enable Secure Boot** is selected automatically and can't be cleared. For more information, see [Trusted launch for Azure Local VMs](../manage/trusted-launch-vm-overview.md).

    1. To enable Secure Boot on a Generation 2 VM that doesn't use it on the source, select **Enable Secure Boot** for that VM. To enable it on all of them at once, turn on **Enable Secure Boot on all Generation 2 VMs that don't currently use it**. Before you enable Secure Boot, make sure the guest OS supports it.

        If Secure Boot is enabled on the source VM, it shows **Enabled at source** and stays enabled after migration.

    1. When finished, select **Next**.

        :::image type="content" source="./media/migrate-hyperv-replicate/replicate-security.png" alt-text="Screenshot showing the Security tab with the security type and Secure Boot settings for each VM." lightbox="./media/migrate-hyperv-replicate/replicate-security.png":::

    > [!IMPORTANT]
    > - Choose the security type before you start replication. There's no supported way to convert a migrated Standard VM to Trusted launch later.
    > - Azure Catalyst doesn't migrate vTPM state or keys from the source VM. A Trusted launch VM gets a new vTPM on Azure Local. Guest attestation isn't enabled during migration.

1. On the **Target settings** tab, complete these tasks:

    1. The **Storage account subscription** populates automatically. If this isn't the subscription where you want to create the storage account, select a different subscription.

    1. Select the **Resource group** to associate with your storage account.

    1. For your **Storage account**, you can select an existing storage account from the dropdown list or create a new one by selecting **Create new**. The storage account is only used to store metadata during replication and migration. All migrated VM data and disks remain completely on-premises.

        > [!NOTE]
        > If you use an existing storage account, ensure the following:
        > - The storage account is **Standard Performance** tier and uses Azure Blob storage. Premium storage accounts aren't supported.
        > - The storage account has **Public network access** enabled. If public network access is disabled, replication fails.
        
    1. Select a resource group to associate with your migrated VMs.
   
	1. Select the logical network that you created as a [prerequisite](./migrate-hyperv-prerequisites.md). The VMs connect to this network. If you don't see a logical network in the dropdown list, [create a logical network](../manage/create-logical-networks.md) and select **Reload logical network**.

	1. Select the storage path that you created as a [prerequisite](./migrate-hyperv-prerequisites.md). The VMs are created at this storage path. Ensure that the storage path has sufficient space to accommodate the VMs being migrated.

        If you don't see a storage path in the dropdown list, [Create a storage path](../manage/create-storage-path.md) and select **Reload storage path**.

    1. When finished, select **Next**.
    
        :::image type="content" source="./media/migrate-hyperv-replicate/replicate-4-target-2.png" alt-text="Screenshot showing the Target settings tab." lightbox="./media/migrate-hyperv-replicate/replicate-4-target-2.png":::

1. On the **Compute** tab:

	1. Rename target VMs as needed.
	1. Select the OS disk for each VM from the dropdown lists.
    1. Configure the number of vCPUs and RAM including selecting dynamic RAM for each VM, as needed.
    1. When finished, select **Next**.
    
        :::image type="content" source="./media/migrate-hyperv-replicate/replicate-5-compute.png" alt-text="Screenshot showing the Compute tab." lightbox="./media/migrate-hyperv-replicate/replicate-5-compute.png":::

1. On the **Disks** tab, select which disks you want to replicate.

    > [!NOTE]
    > Once selected, the OS disks can't be unselected.
 
1. Change the disk type, if needed, and select **Next**.
    1. It is recommended to use **VHDX** format for the disks to ensure future expand and disk operations compatibility.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-6-disks.png" alt-text="Screenshot showing the Disks tab." lightbox="./media/migrate-hyperv-replicate/replicate-6-disks.png":::

1. On the **Review + Start replication** tab, ensure all the values are correct and then select **Replicate**. 

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-7-review.png" alt-text="Screenshot showing the Review + Start replication tab." lightbox="./media/migrate-hyperv-replicate/replicate-7-review.png":::

1. Stay on this page until the process is complete (this might take 5-10 minutes). If you move away from this page, the replication artifacts won't be created fully leading to a failure in replication and then migration.

    :::image type="content" source="./media/migrate-hyperv-replicate/replicate-77-review.png" alt-text="Screenshot showing the warning on the Review + Start replication tab." lightbox="./media/migrate-hyperv-replicate/replicate-77-review.png":::

1. When the process finishes, go to your project and select **Server replication**. Review the replication status. Select **Refresh** to see the replicated VMs appear.
 
1. As the replication continues, replication status shows progress. Refresh periodically.

1. After the initial replication is complete, hourly delta replications begin. The **Migration status** changes to **Ready to migrate**. The VMs can be migrated. 
 
    :::image type="content" source="./media/migrate-hyperv-replicate/migrate-replicated-virtual-machine-1-a.png" alt-text="Screenshot of the Server replication page with the migration status Ready to migrate highlighted." lightbox="./media/migrate-hyperv-replicate/migrate-replicated-virtual-machine-1-a.png":::

    To track replication operations, select **Jobs** in your project. Failed scheduled replication cycles appear on **Events**. For more information, see [Troubleshoot](migrate-troubleshoot.md#get-job-id-for-replication-or-migration).

> [!IMPORTANT]
> During initial replication, Azure Catalyst creates a temporary seed disk for each source disk on the selected Azure Local storage path. It writes the replicated source data and subsequent changes to the seed disk. During migration, Azure Catalyst uses the seed disk to create the final disk attached to the migrated VM.
>
> Don't rename, modify, or delete a seed disk. It remains part of the active replication and can be reused if migration is retried. Deleting it can cause replication or migration to fail and might require you to stop and enable replication again, which restarts initial replication. After you verify the migrated VM, use **Complete migration** to remove the protected item and its replication artifacts, including the seed disk. For more information, see the [Azure Catalyst FAQ](migrate-faq.yml).

## Next steps

- Complete [Hyper-V VM Migration](migrate-azure-migrate.md).
