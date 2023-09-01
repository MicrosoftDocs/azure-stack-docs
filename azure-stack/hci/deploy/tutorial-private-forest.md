---
title: Tutorial on creating a private forest environment and virtual machines for an Azure Stack HCI cluster
description: Tutorial on how to create a private forest environment for Azure Stack HCI evaluation and testing using MSLab scripts
author: jasongerend
ms.author: jgerend
ms.topic: tutorial
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 07/20/2023
---

# Tutorial: Create a VM-based lab for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2

In this tutorial, you use MSLab PowerShell scripts to automate the process of creating a private forest to run Azure Stack HCI on virtual machines (VMs) using [nested virtualization](../concepts/nested-virtualization.md).

> [!IMPORTANT]
> Because Azure Stack HCI is intended as a virtualization host where you run all of your workloads in VMs, nested virtualization is not supported in production environments. Use nested virtualization for testing and evaluation purposes only.

You'll learn how to:

> [!div class="checklist"]
> * Create a private forest with a domain controller and a Windows Admin Center server
> * Deploy multiple VMs running Azure Stack HCI for clustering

Once completed, you'll be able to create an Azure Stack HCI cluster using the VMs you've deployed and use the private lab for prototyping, testing, troubleshooting, or evaluation.

## Prerequisites

To complete this tutorial, you need:

- Admin privileges on a Hyper-V host server running Windows Server 2022, Windows Server 2019, or Windows Server 2016
- At least 8 GB RAM
- CPU with nested virtualization support
- Solid state drives (SSD)
- 40 GB of free space on the Hyper-V host server
- An Azure account to register Windows Admin Center and your cluster

## Prepare the lab

Carefully prepare the lab environment following these instructions.

### Connect to the virtualization host

Connect to the physical server on which you'll create the VM-based lab. If you're using a remote server, connect via Remote Desktop.

### Download Azure Stack HCI

You can download the Azure Stack HCI OS from the Azure portal. For download instructions, see [Download Azure Stack HCI operating system](./download-azure-stack-hci-software.md).

### Download Windows Server

You'll also need a copy of Windows Server 2022, Windows Server 2019, or Windows Server 2016 for the domain controller and Windows Admin Center VMs. You can use evaluation media, or if you have access to either a VL or Visual Studio Subscription, you can use those. For this tutorial, we'll [download an evaluation copy](https://www.microsoft.com/evalcenter/evaluate-windows-server-2019).

### Create a folder for the lab files

Create a **Lab** folder at the root of your C drive (or wherever you prefer), and use File Explorer to copy the OS files you downloaded to the **C:\Lab\Isos** folder.

### Download MSLab scripts

Using the web browser on your server, [download MSLab scripts](https://aka.ms/mslab/download). The zip file **wslab_vxx.xx.x.zip** should automatically download to your hard drive. Copy the zip file to the hard drive location (C:\Lab) and extract the scripts.

### Edit the LabConfig script

MSLab VMs are defined in the LabConfig.ps1 PowerShell script as a simple hash table. You'll need to customize the script to create a private forest with Azure Stack HCI VMs. 

To edit the script, use File Explorer to navigate to C:\Lab\wslab_xxx\ and then right-click on **LabConfig.ps1**. Select **Edit**, which will open the file using Windows PowerShell ISE.

   > [!TIP]
   > Save the original version of **LabConfig.ps1** as **Original_LabConfig.ps1**, so it's easy to start over if you need to.

Notice that most of the script is commented out; you will only need to execute a few lines. Follow these steps to customize the script so it produces the desired output. Alternatively, you can simply copy the code block at the end of this section and replace the appropriate lines in LabConfig.

To customize the script:

1. Add the following to the first uncommented line of **LabConfig.ps1** to tell the script where to find the ISOs, enable the guest service interface, and enable DNS forwarding on the host: **ServerISOFolder="C:\lab\isos" ; EnableGuestServiceInterface=$true ; UseHostDnsAsForwarder=$true**

2. Change the admin name and password, if desired.

3. If you plan to create multiple labs on the same server, change **Prefix = 'MSLab-'** to use a new Prefix name, such as **Lab1-**. We'll stick with the default **MSLab-** prefix for this tutorial.

4. Comment out the default **ForEach-Object** line for Windows Server and remove the hashtag before the **ForEach-Object** line for Azure Stack HCI so that the script will create Azure Stack HCI VMs instead of Windows Server VMs for the cluster nodes.

5. By default, the script creates a four-node cluster. If you want to change the number of VMs in the cluster, replace **1..4** with **1..2** or **1..8**, for example. Remember, the more VMs in your cluster, the greater the memory requirements on your host server.

6. Add **NestedVirt=$true ; AdditionalNetworks=$True** to the **ForEach-Object** command and set **MemoryStartupBytes** to **4GB**.

7. Add an AdditionalNetworksConfig line: **$LabConfig.AdditionalNetworksConfig += @{ NetName = 'Converged'; NetAddress='10.0.1.'; NetVLAN='0'; Subnet='255.255.255.0'}**

8. Add the following line to configure a Windows Admin Center management server running the Windows Server Core operating system to add a second NIC so you can connect to Windows Admin Center from outside the private network: **$LabConfig.VMs += @{ VMName = 'AdminCenter' ; ParentVHD = 'Win2019Core_G2.vhdx'; MGMTNICs=2}**

9. Be sure to save your changes to **LabConfig.ps1**.

The changes to **LabConfig.ps1** made in the steps above are reflected in this code block:

```PowerShell
$LabConfig=@{ DomainAdminName='LabAdmin'; AdminPassword='LS1setup!'; Prefix = 'MSLab-' ; DCEdition='4'; Internet=$true ; AdditionalNetworksConfig=@(); VMs=@() ; ServerISOFolder="C:\lab\isos" ; EnableGuestServiceInterface=$true ; UseHostDnsAsForwarder=$true }
# Windows Server 2019
#1..4 | ForEach-Object {$VMNames="S2D"; $LABConfig.VMs += @{ VMName = "$VMNames$_" ; Configuration = 'S2D' ; ParentVHD = 'Win2019Core_G2.vhdx'; SSDNumber = 0; SSDSize=800GB ; HDDNumber = 12; HDDSize= 4TB ; MemoryStartupBytes= 512MB }}
# Or Azure Stack HCI 
1..4 | ForEach-Object {$VMNames="AzSHCI"; $LABConfig.VMs += @{ VMName = "$VMNames$_" ; Configuration = 'S2D' ; ParentVHD = 'AzSHCI21H2_G2.vhdx'; SSDNumber = 0; SSDSize=800GB ; HDDNumber = 12; HDDSize= 4TB ; MemoryStartupBytes= 4GB ; NestedVirt=$true ; AdditionalNetworks=$true }}
# Or Windows Server 2022
#1..4 | ForEach-Object {$VMNames="S2D"; $LABConfig.VMs += @{ VMName = "$VMNames$_" ; Configuration = 'S2D' ; ParentVHD = 'Win2022Core_G2.vhdx'; SSDNumber = 0; SSDSize=800GB ; HDDNumber = 12; HDDSize= 4TB ; MemoryStartupBytes= 512MB }}

$LabConfig.AdditionalNetworksConfig += @{ NetName = 'Converged'; NetAddress='10.0.1.'; NetVLAN='0'; Subnet='255.255.255.0'}

$LabConfig.VMs += @{ VMName = 'AdminCenter' ; ParentVHD = 'Win2019Core_G2.vhdx'; MGMTNICs=2}
```

## Run MSLab scripts and create parent disks

MSLab scripts automate much of the lab setup process and convert ISO images of the operating systems to VHD files.

### Run the Prereq script

Navigate to C:\Lab\wslab_xxx\ and run the **1_Prereq.ps1** script by right-clicking on the file and selecting **Run With PowerShell**. The script will download necessary files. Some example files will be placed into the **ToolsDisk** folder, and some scripts will be added to the **ParentDisks** folder. When the script is finished, it will ask you to press **Enter** to continue.

   > [!NOTE]
   > You might need to change the script execution policy on your system to allow unsigned scripts by running this PowerShell cmdlet as administrator: `Set-ExecutionPolicy -ExecutionPolicy Unrestricted`

### Create the Windows Server parent disks

The **2_CreateParentDisks.ps1** script prepares virtual hard disks (VHDs) for Windows Server and Server Core from the operating system ISO file, and also prepares a domain controller for deployment with all required roles configured. Run **2_CreateParentDisks.ps1** by right-clicking on the file and selecting **Run with PowerShell**.

You'll be asked to select telemetry levels; choose **B** for **Basic** or **F** for **Full**. The script will also ask for the ISO file for Windows Server 2019. Point it to the location you copied the file to (C:\Labs\Isos). If there are multiple ISO files in the folder, you'll be asked to select the ISO that you want to use. Select the Windows Server ISO. If you're asked to format a drive, select **N**.

   > [!WARNING]
   > **Don't select the Azure Stack HCI ISO** - you'll create the Azure Stack HCI parent disk (VHD) in the next section.

Creating the parent disks can take as long as 1-2 hours, although it can take much less time. When complete, the script will ask you if unnecessary files should be removed. If you select **Y**, it will remove the first two scripts because they're no longer needed. Press **Enter** to continue.

### Create the Azure Stack HCI parent disk

Download the [Convert-WindowsImage.ps1 function](https://raw.githubusercontent.com/microsoft/MSLab/master/Tools/Convert-WindowsImage.ps1) to the C:\Lab\wslab_xxx\ParentDisks folder as **Convert-WindowsImage.ps1**. Then run **CreateParentDisk.ps1** as administrator. Choose the Azure Stack HCI ISO from C:\Labs\Isos, and accept the default name and size.

Creating the parent disk will take a while. When the operation is complete, you'll be prompted to start the VMs. Don't start them yet - type **N**.

### Deploy the VMs

Run **Deploy.ps1** by right-clicking and selecting **Run with PowerShell**. The script will take 10-15 minutes to complete.

## Install operating system updates and software

Now that the VMs are deployed, you'll need to install security updates and the software needed to manage your lab.

### Update the domain controller and Windows Admin Center VMs

Log on to your virtualization host and launch Hyper-V Manager. The domain controller in your private forest should already be running (MSLab-DC). Go to **Virtual Machines**, select the domain controller, and connect to it. Sign in with the username and password you specified, or if you didn't change them, use the defaults: LabAdmin/LS1setup!

Install any required security updates and restart the domain controller VM if needed. This may take a while, and you may need to restart the VM multiple times.

In Hyper-V Manager, start the Windows Admin Center VM (MSLab-AdminCenter), which is running Server Core. Connect to it, log in, and type **sconfig**. Select **download and install security updates**, and reboot if needed. This may take a while, and you may need to restart the VM and type **sconfig** multiple times.

### Install Microsoft Edge on the domain controller

You'll need a web browser on the domain controller VM in order to use Windows Admin Center in your private forest. It's likely that Internet Explorer will be blocked for security reasons, so use Microsoft Edge instead. If Edge isn't already installed on the domain controller VM, you'll need to install it.

To install Microsoft Edge, connect to the domain controller VM from Hyper-V Manager and launch a PowerShell session as administrator. Then run the following code to install and start Microsoft Edge.

```PowerShell
#Install Edge
Start-BitsTransfer -Source "https://aka.ms/edge-msi" -Destination "$env:USERPROFILE\Downloads\MicrosoftEdgeEnterpriseX64.msi"
#Start install
Start-Process -Wait -Filepath msiexec.exe -Argumentlist "/i $env:UserProfile\Downloads\MicrosoftEdgeEnterpriseX64.msi /q"
#Start Edge
start microsoft-edge:
```

### Install Windows Admin Center in gateway mode

Using Microsoft Edge on the domain controller VM, download [this script](https://github.com/microsoft/MSLab/tree/master/Scenarios/AzSHCI%20and%20Cluster%20Creation%20Extension#install-windows-admin-center-in-gw-mode) to the domain controller VM and save it with a .ps1 file extension.

Right-click on the file, choose **Edit with PowerShell**, and change the value of **$GatewayServerName** in the first line to match the name of your AdminCenter VM without the prefix (for example, AdminCenter). Save the script and run it by right-clicking on the file and selecting **Run with PowerShell**.

### Log on to Windows Admin Center

You should now be able to access Windows Admin Center from Edge on the DC: **http://admincenter**

Your browser may warn you that it's an unsafe or insecure connection, but it's OK to proceed.

### Add an externally accessible network adapter (optional)

If your lab is on a private network, you might want to add an externally accessible NIC to the AdminCenter VM so that you can connect to it and manage your lab from outside the private forest. To do this, use Windows Admin Center to connect to your virtualization host (**not** the domain controller) and go to **Virtual machines > MSLab-AdminCenter > Settings > Networks**. Make sure that you have a virtual switch connected to the appropriate network. Look for Switch Type = External (such as MSLab-LabSwitch-External). Then add/bind a VM NIC to this external virtual switch. Be sure to select the "Allow management OS to share these network adapters" checkbox.

Take note of the IP addresses of the network adapters on the AdminCenter VM. Append :443 to the IP address of the externally accessible NIC, and you should be able to log on to Windows Admin Center and create and manage your cluster from an external web browser, such as: **`https://10.217.XX.XXX:443`**

### Install operating system updates on the Azure Stack HCI VMs

Start the Azure Stack HCI VMs using Hyper-V Manager on the virtualization host. Connect to each VM, and download and install security updates using Sconfig on each of them. You may need to restart the VMs multiple times. (You can skip this step if you'd rather install the OS updates later as part of the cluster creation wizard).

### Enable the Hyper-V role on the Azure Stack HCI VMs

If your cluster VMs are running Azure Stack HCI 20H2, you'll need to run a script to enable the Hyper-V role on the VMs. Save [this script](https://github.com/Azure/AzureStackHCI-EvalGuide/blob/main/archive/steps/3a_AzSHCINodesGUI.md#enable-the-hyper-v-role-on-your-azure-stack-hci-node) to **C:\Lab** on your virtualization host as PreviewWorkaround.ps1.


Right-click on the PreviewWorkaround.ps1 file and select **Edit with PowerShell**. Change the **$domainName**, **$domainAdmin**, and **$nodeName** variables if they don't match, such as:

```PowerShell
$domainName = "corp.contoso.com"
$domainAdmin = "$domainName\labadmin"
$nodeName = "MSLab-AzSHCI1","MSLab-AzSHCI2","MSLab-AzSHCI3","MSLab-AzSHCI4"
```

Save your changes, then open a PowerShell session as administrator and run the script:

```PowerShell
PS C:\Lab> ./PreviewWorkaround.ps1
```

The script will take some time to run, especially if you've created lots of VMs. You should see the message "MSLab-AzSHCI1 MSLab-AzSHCI2 is now online. Proceeding to install Hyper-V PowerShell." If the script appears to freeze after displaying the message, press Enter to wake it up. When it's done, you should see: "MSLab-AzSHCI1 MSLab-AzSHCI2 is now online. Proceed to the next step ..."

### Add additional network adapters (optional)

Depending on how you intend to use the cluster, you may want to add a couple more network adapters to each Azure Stack HCI VM for more versatile testing. To do this, connect to your host server using Windows Admin Center and go to **Virtual machines > MSLab-(node) > Settings > Networks**. Make sure to select **Advanced > Enable MAC Address Spoofing**. If this setting isn't enabled, you may encounter failed connectivity tests when trying to create a cluster.

### Register Windows Admin Center with Azure

Connect to Windows Admin Center in your private forest using either the external URL or using Edge on the domain controller, and [Register Windows Admin Center with Azure](../manage/register-windows-admin-center.md).

## Clean up resources

If you selected **Y** to cleanup unnecessary files and folders, then cleanup is already done. If you prefer to do it manually, navigate to C:\Labs and delete any unneeded files.

## Next steps

You're now ready to proceed to the Cluster Creation Wizard.

> [!div class="nextstepaction"]
> [Create an Azure Stack HCI cluster](create-cluster.md)
