--- 
title: Replicate Hyper-V migration to Azure Stack HCI using Azure Migrate (preview) 
description: Learn the replication process for Hyper-V migration to Azure Stack HCI using Azure Migrate (preview).
author: alkohli
ms.topic: how-to
ms.date: 08/11/2023
ms.author: alkohli
ms.subservice: azure-stack-hci
---

# Replicate Hyper-V migration to Azure Stack HCI using Azure Migrate (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2-21h2.md)]

This article describes the replication process for Hyper-V virtual machine (VM) migration to Azure Stack HCI using Azure Migrate.

## Step 1: Generate target appliance key

Complete the following tasks before you proceed with replication:

1. Go to the [Azure portal](https://aka.ms/HCIMigratePP).

1. Select **Azure Migrate**.

1. Select **Servers, databases and web apps**. Verify that you see a number for **Discovered servers** under **Assessment tools**.

1. Under **Migration tools**, select **Replicate**.

1. On the **Specify intent** page, select the following from the dropdown lists:
    - **Servers or virtual machines (VM)**.
    - **Azure Stack HCI**.
    - **Hyper-V**.
    - *name_of_source_appliance* (should be populated).

1. Select **Download and configure** in the information block.

1. On the **Deploy and configure the target appliance** pop-up, provide a name for the target appliance and then select **Generate key**.

1. Save the generated target key to Notepad or other text editor for future use.

1. (Optional) Select **Download installer** to download the .zip file. Since the same bits are used for both source and target appliance, you can copy and reuse the .zip file you downloaded previously for the source appliance.

## Step 2: Create connection between source and target appliances

This step creates a connection between the source and target appliance and facilitates VM creation on the target appliance.

1. Open **Hyper-V Manager** on the source appliance.

1. Select **Connect to Server**, then select **Another computer**.

1. Select from the dropdown, or browse for, the first node of the target Azure Stack HCI cluster, and then select **OK**.

1. Repeat steps 2 and 3 for each node in the target Azure Stack HCI cluster.

## Step 3: Install target appliance VM OS

In this step, you download the operating system (OS) VHD for the target appliance VMs on the target Azure Stack HCI cluster.

1. Go to the [Evaluation Center](https://www.microsoft.com/en-us/evalcenter/download-windows-server-2022), then select and download the applicable Windows Server 2022 VHD for the VM.

    > [!NOTE]
    > It is not a requirement to use the evaluation OS version. You can use your own corporate images as long as the OS version is Windows Server 2022.

1. Open **Hyper-V Manager** on a node in the target cluster and then select the target cluster from the list.

1. Under **Actions** on the right, select **New > Virtual machine**.

1. Step through the **New Virtual Machine Wizard**, specifying the following:

    - VM name
    - VM location
    - **Memory**: 16GB min
    - **Connection**: ExternalSwitch
    - **VM type**: `Standalone`
    - **Operating System**: Windows Server 2022
    - **vCPU**: 8
    - **Disk**: >80GB
 
1. Create a virtual hard disk and specify a location for it.

1. Select the install OS from **image file** option and select the downloaded VHD.

1. Create a new appliance virtual machine (VM) in the target cluster using the VHD just downloaded. Complete the **New Virtual Machine Wizard** with the following configuration:

    - **VM type**: `Standalone`
    - **Operating System**: Windows Server 2022
    - **vCPU**: 8
    - **Disk**: >80GB
    - **Memory**: 16GB min
    
1. Once the VM is created, sign in to it using **Virtual Machine Connection**.

1. Select the OS you just downloaded and begin OS set up.

1. Once the OS is finished installing, enter the local administrative credentials, then sign in using them.

1. Open **Hyper-V Manager** again and select the VM just created.

1. Under **Hyper-V settings**, select **Enhanced Session Mode Policy** and ensure the **Allow enhanced session mode** option is enabled.

1. Sign on to the new VM.

## Step 4: Install target appliance bits

The target appliance and the source appliance use the same .zip file, so no need to download it again.

1. Open **Server Manager**.

1. Copy and paste the downloaded .zip file to the target VM virtual hard disk location that you created and extract it.

1. As an administrator, run the following PowerShell script from the folder of the extracted .zip file:

    ```PowerShell
    Set-ExecutionPolicy -ExecutionPolicy Unrestricted .\AzureMigrateInstaller.ps1 -DisableAutoUpdate -Scenario AzureStackHCI -Cloud Public -PrivateEndpoint:$false -EnableAzureStackHCITarget
    ```

1. When prompted, select **Y** to remove Internet Explorer.

1. Restart and sign into the VM.

## Step 5: Configure and register target appliance

1. Open **Server Manager** and sign on to the target appliance VM.

1. Open **Azure Configuration Manager** from the desktop shortcut.

1. Locate the target key that you previously generated, paste it in the field under **Verification of Azure Migrate project key**, then select **Verify**.

1. Once verification is complete, select **Log in** and sign in to your Azure account.

1. Enter the code that is displayed in your Authenticator (or similar) app for MFA authentication.

1. Wait until you see **The appliance has been successfully registered** message.

1. Sign in to Microsoft Azure PowerShell using the code displayed in your Authenticator app. It can take up to 10 minutes for the appliance to be registered.

1. After the appliance is registered, scroll down and select **Add cluster information**.

1. Enter cluster FQDN, domain, username, and password information, and then select **Configure**.

## Step 6: Start replication

1. Go to the [Azure portal](https://aka.ms/HCIMigratePP).

1. Select **Azure Migrate** and then select **Servers, databases and web apps**.

1. Select the **Replicate** tile

    :::image type="content" source="./media/step1-replicate.png" alt-text="Screenshot showing the Replicate tile." lightbox="./media/step1-replicate.png":::

1. On the **Specify intent** page, select **Azure Stack HCI**, select **Hyper-V**, and then select **Continue**.

    :::image type="content" source="./media/replicate-specify-intent.png" alt-text="Screenshot showing the Specify intent page." lightbox="./media/replicate-specify-intent.png":::

1. On the **Basics** tab, complete these steps:

    :::image type="content" source="./media/replicate-1-basics.png" alt-text="Screenshot showing the Basics tab." lightbox="./media/replicate-1-basics.png":::

	1. For **Cluster resource**, select the applicable HCI server resource.
	1. Verify there is a green check for the HCI server name. This indicates that the Arc Resource Bridge is configured on this server.
    1. Select **Next**.
    

1. On the **Target appliance** tab, verify that the target appliance is connected - you should see a green check. Select **Next**.

    :::image type="content" source="./media/replicate-2-target.png" alt-text="Screenshot showing the Target applicance tab." lightbox="./media/replicate-2-target.png":::

1. On the **Virtual machines** tab, verify the VMs have been discovered and are listed. Select **Next**.

    :::image type="content" source="./media/replicate-3-vm.png" alt-text="Screenshot showing the Virtual machines tab." lightbox="./media/replicate-3-vm.png":::

1. On the **Target settings** tab, complete these steps:

    :::image type="content" source="./media/replicate-4-target2.png" alt-text="Screenshot showing the Target settings tab." lightbox="./media/replicate-4-target.png":::

	1. For **Cache storage account**, select the storage account that you created previously in the [Prerequisites](migrate-hyperv-replicate.md) article, and then select **Confirm**.

    :::image type="content" source="./media/replicate-4-target.png" alt-text="Screenshot showing the Cache storage account popup." lightbox="./media/replicate-4-target.png":::

    1. Select the resource group that you want these VMs to be associated with.
	1. Select the virtual switch these VMs are connected to.
	1. Select the storage path where these VMs are created.
    1. Select **Next**.

1. On the **Compute** tab, complete these steps:

    :::image type="content" source="./media/replicate-5-compute.png" alt-text="Screenshot showing the Compute tab." lightbox="./media/replicate-5-compute.png":::

	1. Rename target VMs as needed.
	1. Select the OS disk for each VM from the dropdown lists.
    1. Adjust values for vCPU and RAM for each VM as needed.
    1. Select **Next**.

1. On the **Disks** tab, select which disks you would like to replicate, then select **Next**.

    :::image type="content" source="./media/replicate-6-disks.png" alt-text="Screenshot showing the Disks tab." lightbox="./media/replicate-6-disks.png":::

1. On the  **Review + Start replication** tab, stay on the page until the process is complete (this may take 5-10 minutes). Then select **Replicate**.

    :::image type="content" source="./media/replicate-7-review.png" alt-text="Screenshot showing the Review + Start replication tab." lightbox="./media/replicate-7-review.png":::

 1. On the **Replications** page, review the replication status. Select **Refresh** to see all the VMs.
 
    :::image type="content" source="./media/replications-page2.png" alt-text="Screenshot showing the Replications page." lightbox="./media/replications-page2.png":::

## Next steps

- Complete [Hyper-V VM Migration](migrate-hyperv-replicate.md).
