--- 
title: Migrate to Azure Stack HCI on new hardware
description: Learn how to migrate to Azure Stack HCI on new hardware 
author: v-dasis 
ms.topic: how-to 
ms.date: 12/10/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Migrate to Azure Stack HCI on new hardware

> Applies to Azure Stack HCI, version 20H2; Windows Server 2019, Windows Server 2016, Windows Server 2012 R2, Windows Server 2008 R2

This topic describes how to migrate virtual machine (VM) files on Windows Server 2012 R2, Windows Server 2016, or Windows Server 2019 to new Azure Stack HCI server hardware using Windows PowerShell and Robocopy. Robocopy is a robust method for copying files from one server to another. It resumes if disconnected and continues to work from its last known state. Robocopy also supports multi-threaded file copy over Server Message Block (SMB). For more information, see [Robocopy](https://docs.microsoft.com/windows-server/administration/windows-commands/robocopy).

> [!NOTE]
> Hyper-V Live Migration and Hyper-V Replica from Windows Server to Azure Stack HCI is not supported.

If you have VMs on Windows 2012 R2 or older that you want to migrate, see [Migrating older VMs](#migrating-older-vms).

To migrate to Azure Stack HCI using the same hardware, see [Migrate to Azure Stack HCI on the same hardware](migrate-cluster-same-hardware.md).

The following diagram shows a Windows Server source cluster and an Azure Stack HCI destination cluster as an example. You can also migrate VMs on stand-alone servers as well.

:::image type="content" source="media/migrate/migrate-cluster.png" alt-text="Migrate cluster to Azure Stack HCI" lightbox="media/migrate/migrate-cluster.png":::

In terms of expected downtime, using a single NIC with a dual 40 GB RDMA East-West network between clusters, and Robocopy configured for 32 multithreads, you can realize transfer speeds of 1.9 TB per hour.

> [!NOTE]
> Migrating VMs for stretched clusters is not covered in this article.

## Before you begin

There are several requirements and things to consider before you begin migration:

- All Windows PowerShell commands must be run As Administrator.

- You must have domain credentials with administrator permissions for both source and destination clusters, with full rights to the source and destination Organizational Unit (OU) that contains both clusters.

- Both clusters must be in the same Active Directory forest and domain to facilitate Kerberos authentication between clusters for migration of VMs.

- Both clusters must reside in an Active Directory OU with Group Policy Object (GPO) Block inheritance set on this OU. This ensures no domain-level GPOs and security policies can impact the migration.

- Both clusters must be connected to the same time source to support consistent Kerberos authentication between clusters.

- Make note of the Hyper-V virtual switch name used by the VMs on the source cluster. You must use the same virtual switch name for the Azure Stack HCI destination cluster "virtual machine network" prior to importing VMs.

- Remove any ISO image files for your source VMs. This is done using Hyper-V Manager in **VM Properties** in the **Hardware section**. Select **Remove** for any virtual CD/DVD drives.

- Shutdown all VMs on the source cluster. This is required to ensure version control and state are maintained throughout the migration process.

- Check if Azure Stack HCI supports your version of the VMs to import and update your VMs as needed. See the [VM version support and update](#vm-version-support-and-update) section on how to do this.

- Backup all VMs on your source cluster. Complete a crash-consistent backup of all applications and data and an application-consistent backup of all databases. To backup to Azure, see [Use Azure Backup](https://docs.microsoft.com/azure-stack/hci/manage/use-azure-backup).

- Make a checkpoint of your source cluster VMs and domain controller in case you have to roll back to a prior state. This is not applicable for physical servers.

- Ensure the maximum Jumbo frame sizes are the same between source and destination cluster storage networks, specifically the RDMA network adapters and their respective switch network ports to provide the most efficient end-to-end transfer packet size.

- Make note of the Hyper-V virtual switch name on the source cluster. You will reuse it on the destination cluster.

- The Azure Stack HCI hardware should have at least equal capacity and configuration as the source hardware.

- Minimize the number of network hops or physical distance between the source and destination clusters to facilitate the fastest file transfer.

## VM version support and update

This table lists the Windows Server OS versions and their VM versions.

Regardless of the OS version a VM may be running on, the minimum VM version supported for direct migration to Azure Stack HCI is version 5.0. This represents the default version for VMs on Windows Server 2012 R2. So any VMs running at version 2.0, 3.0, or 4.0 for example must be updated to version 5.0 before migration.

|OS version|VM version|
|---|---|
|Windows Server 2008 SP1|2.0|
|Windows Server 2008 R2|3.0|
|Windows Server 2012|4.0|
|Windows Server 2012 R2|5.0|
|Windows Server 2016|8.0|
|Windows Server 2019|9.0|
|Azure Stack HCI|9.0|

For VMs on Windows Server 2012 R2, Windows Server 2016, and Windows Server 2019, update all VMs to the latest VM version supported on the source hardware first before running the Robocopy migration script. This ensures all VMs are at least at version 5.0 for a successful VM import.

For VMs on Windows Server 2008 SP1, Windows Server 2008 R2-SP1, and Windows 2012, the VM version will be less than version 5.0. These VMs also use an .xml file for configuration instead of an .vcmx file. As such, a direct import of the VM to Azure Stack HCI is not supported. In these cases, you have two options, as detailed in [Migrating older VMs](#migrating-older-vms).

### Updating the VM version

The following commands apply to Windows Server 2012 R2 and later. Use the following command to show all VM versions on a single server:

```powershell
Get-VM * | Format-Table Name,Version
```

To show all VM versions across all servers on a cluster:

```powershell
Get-VM –ComputerName (Get-ClusterNode)
```

To update all VMs to the latest supported version on all servers:

```powershell
Get-VM –ComputerName (Get-ClusterNode) | Update-VMVersion -Force
```

## RDMA recommendations

If you are using Remote Direct Memory Access (RDMA), Robocopy can leverage it for copying your VMs between clusters. Here are some recommendations for using RDMA:

- Connect both clusters to the same top of rack (ToR) switch to use the fastest network path between source and destination clusters. For the storage network path this typically supports 10GbE/25GbE or higher speeds and leverages RDMA.

- If the RDMA adapter or standard is different between source and destination clusters (ROCE vs iWARP), Robocopy will instead leverage SMB over TCP/IP via the fastest available network. This will typically be a dual 10Gbe/25Gbe or higher speed for the East-West network, providing the most optimal way to copy VM VHDX files between clusters.

- To ensure Robocopy can leverage RDMA between clusters (East-West network), configure RDMA storage networks so they are routeable between the source and destination clusters.

## Create the new cluster

Before you can create the Azure Stack HCI cluster, you need to install the Azure Stack HCI OS on each new server that will be in the cluster. For information on how to do this, see [Deploy the Azure Stack HCI operating system](operating-system.md).

Use Windows Admin Center or Windows PowerShell to create the new cluster. For detailed information on how to do this, see [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md) and [Create an Azure Stack HCI cluster using Windows PowerShell](create-cluster-powershell.md).

> [!IMPORTANT]
> Hyper-V virtual switch (`VMSwitch`) names between clusters must be the same. Make sure that virtual switch names created on the destination cluster match those used on the source cluster across all servers. This must be verified before you import the VMs.

> [!NOTE]
> You must register the Azure Stack HCI cluster with Azure before you can create new VMs on it. For more information, see [Register with Azure](register-with-azure.md).

## Run the migration script

The following PowerShell script `Robocopy_Remote_Server_.ps1` uses Robocopy to copy VM files and their dependent directories and metadata from the source to the destination cluster. This script has been modified from the original script on TechNet at: [Robocopy Files to Remote Server Using PowerShell and RoboCopy](https://gallery.technet.microsoft.com/scriptcenter/Robocoy-Files-to-Remote-bdfc5154).

Robocopy supports file copy over SMB with compression using the `/compress` switch for Windows Server 2019 and later. When compression is used, inline whitespace compression to file transfers is applied, reducing congestion and copy time. Depending on the file format and I/O pattern, the performance increase can be up to fourfold. For more information, see the [Windows Blogs](https://blogs.windows.com/windowsexperience/2020/09/02/announcing-windows-server-vnext-preview-build-20206/) post and [KB4571748](https://support.microsoft.com/help/4571748/windows-10-update-kb4571748).

The script copies all VM VHD, VHDX, and VMCX files to your destination cluster for a given Cluster Shared Volume (CSV). One CSV is migrated at a time.

The migration script is run locally on each source server to leverage the benefit of RDMA and fast network transfer. To do this:

1. Make sure each destination cluster node is set to the CSV owner for the destination CSV.

1. To determine the location of all VM VHD and VHDX files to be copied, use the following cmdlet. Review the `C:\vmpaths.txt` file to determine the topmost source file path for Robocopy to start from for step 4:

    ```powershell  
    Get-ChildItem -Path "C:\Clusterstorage\Volume01\*.vhd*" -Recurse > c:\vmpaths.txt
    ```

    > [!NOTE]
    > If your VHD and VHDX files are located in different paths on the same volume, you will need to run the migration script for each different path to copy them all.

1. Change the following three variables to match the source cluster VM path with the destination cluster VM path:

    - `$Dest_Server = "Node01"`
    - `$source  = "C:\Clusterstorage\Volume01"`
    - `$dest = "\\$Dest_Server\C$\Clusterstorage\Volume01"`

1. Run the following script on each Windows Server source server:

```powershell
<#
#===========================================================================  
# Script: Robocopy_Remote_Server_.ps1
#===========================================================================  
.DESCRIPTION:
Change the following variables to match your source cluster VM path with the destination cluster VM path. Then run this script on each source Cluster Node CSV owner and make sure the destination cluster node is set to the CSV owner for the destination CSV.

        Change $Dest_Server = "Node01"
        Change $source  = "C:\Clusterstorage\Volume01"
        Change $dest = "\\$Dest_Server\C$\Clusterstorage\Volume01"
#>

$Space       = Write-host ""
$Dest_Server = "Node01"
$source      = "C:\Clusterstorage\Volume01"
$dest        = "\\$Dest_Server\C$\Clusterstorage\Volume01"
$Logfile     = "c:\temp\Robocopy1-$date.txt"
$date        = Get-Date -UFormat "%Y%m%d"
$cmdArgs     = @("$source","$dest",$what,$options)  
$what        = @("/COPYALL")
$options     = @("/E","/MT:32","/R:0","/W:1","/NFL","/NDL","/LOG:$logfile","/xf")
 
## Get Start Time
$startDTM = (Get-Date)
 
$Dest_Server     = "Node01"
$TARGETDIR   = \\$Dest_Server\C$\Clusterstorage\Volume01
$Space
Clear
## Provide Information
Write-host ".....Copying Virtual Machines FROM $Source to $TARGETDIR ....................." -fore Green -back black
Write-Host "........................................." -Fore Green

## Kick off the copy with options defined  
robocopy @cmdArgs
 
## Get End Time
$endDTM = (Get-Date)
 
## Echo Time elapsed
$Time = "Elapsed Time: = $(($endDTM-$startDTM).totalminutes) minutes"  
## Provide time it took
Write-host ""
Write-host " Copy Virtual Machines to $Dest_Server has been completed......" -fore Green -back black
Write-host " Copy Virtual Machines to $Dest_Server took $Time        ......" -fore Cyan
```

## Import the VMs

A best practice is to create at least one Cluster Shared Volume (CSV) per cluster node to enable an even balance of VMs for each CSV owner for increased resiliency, performance, and scale of VM workloads. By default, this balance occurs automatically every five minutes and needs to be considered when using Robocopy between a source cluster node and the destination cluster node to ensure source and destination CSV owners match to provide the most optimal transfer path and speed.

Perform the following steps on your Azure Stack HCI cluster to import the VMs, make them highly available, and start them:

1. Run the following cmdlet to show all CSV owner nodes:

    ```powershell
    Get-ClusterSharedVolume
    ```

1. For each server node, go to `C:\Clusterstorage\Volume` and set the path for all VMs - for example `C:\Clusterstorage\volume01`.

1. Run the following cmdlet on each CSV owner node to display the path to all VM VMCX files per volume prior to VM import. Modify the path to match your environment:

    ```powershell
    Get-ChildItem -Path "C:\Clusterstorage\Volume01\*.vmcx" -Recurse
    ```

    > [!NOTE]
    > Windows Server 2012 R2 and older VMs use an XML file instead of a VCMX file. Fore more information, see the section **Migrating older VMs**.

1. Run the following cmdlet for each server node to import, register, and make the VMs highly available on each CSV owner node. This ensures an even distribution of VMs for optimal processor and memory allocation:

    ```powershell
    Get-ChildItem -Path "C:\Clusterstorage\Volume01\*.vmcx" -Recurse | Import-VM -Register | Get-VM | Add-ClusterVirtualMachineRole
    ```

1. Start each destination VM on each node:

    ```powershell
    Start-VM -Name
    ```

1. Log on and verify that all VMs are running and that all your apps and data are there:

    ```powershell
    Get-VM -ComputerName Server01 | Where-Object {$_.State -eq 'Running'}
    ```

1. Update your VMs to the latest version for Azure Stack HCI to take advantage of all the advancements:

    ```powershell
    Get-VM | Update-VMVersion -Force
    ```

1. After the script has completed, check the Robocopy log file for any errors listed and to verify that all VMs are copied successfully.

## Migrating older VMs

If you have Windows Server 2008 SP1, Windows Server 2008 R2-SP1, Windows Server 2012, or Windows Server 2012 R2 VMs, this section applies to you. You have two options for handling these VMs:

- Migrate these VMs to Windows Server 2012 R2, Windows Server 2016, or Windows Server 2019 first, update the VM version, then begin the migration process.

- Use Robocopy to copy all VM VHDs to Azure Stack HCI. Then create new VMs and attach the copied VHDs to the VMs in Azure Stack HCI. This bypasses the VM version limitation for these older VMs.

Windows Server 2012 R2 and older Hyper-V hosts use an XML file format for their VM configuration, which is different than the VCMX file format used for Windows Server 2016 and later Hyper-V hosts. This requires a different Robocopy command to copy these VMs to Azure Stack HCI.

### Option 1: Staged migration

This is a two-stage migration used for VMs hosted on Windows Server 2008 SP1, Windows Server 2008 R2-SP, and Windows Server 2012. Here is the process you use:

1. Discover the location of all VM VHD and VHDX files to be copied, then review the `vmpaths.txt` file to determine the topmost source file path for Robocopy to start from. Use the following cmdlet:

    ```powershell
    Get-ChildItem -Path "C:\Clusterstorage\Volume01\*.vhd*" -Recurse > c:\vmpaths.txt
    ```

1. Use the following example Robocopy command to copy VMs to Windows Server 2012 R2 first using the topmost path determined in step 1:

    `Robocopy \\2012R2-Clus01\c$\clusterstorage\volume01\Hyper-V\   \\20H2-Clus01\c$\clusterstorage\volume01\Hyper-V\ /Copyall /E /MT:32 /R:0 /w:1 /NFL /NDL /log:c:\log.txt /xf`

1. Verify the virtual switch (`VMSwitch`) name on used on the Windows Server 2012 R2 cluster is the same as the switch name used on the Windows 2008 R2 or Windows Server 2008 R2-SP1 source. To display the switch names used across all servers in a cluster, use this:

     ```powershell
    Get-VMSwitch -CimSession $Servers | Select-Object Name
    ```

    Rename the switch name on Windows Server 20212 R2 as needed. To rename the switch name across all servers in the cluster, use this:

    ```powershell
    Invoke-Command -ComputerName $Servers -ScriptBlock {rename-VMSwitch -Name $using:vSwitcholdName -NewName $using:vSwitchnewname}
    ```

1. Copy and import the VMs to Windows Server 2012 R2:

     ```powershell
    Get-ChildItem -Path "c:\clusterstorage\volume01\Hyper-V\*.xml"-Recurse
    ```

    ```powershell
    Get-ChildItem -Path "c:\clusterstorage\volume01\image\*.xml" -Recurse    | Import-VM -Register | Get-VM | Add-ClusterVirtualMachineRole  
    ```

1. On Windows Server 2012 R2, update the VM version to 5.0 for all VMs:

    ```powershell
    Get-VM | Update-VMVersion -Force
    ```

1. [Run the migration script](#run-the-migration-script) to copy VMs to Azure Stack HCI.

1. Follow the process in [Import the VMs](#import-the-vms), replacing Step 3 and Step 4 with the following to handle the XML files and to import the VMs to Azure Stack HCI:

    ```powershell
    Get-ChildItem -Path "c:\clusterstorage\volume01\Hyper-V\*.xml"-Recurse
    ```

    ```powershell
    Get-ChildItem -Path "c:\clusterstorage\volume01\image\*.xml" -Recurse    | Import-VM -Register | Get-VM | Add-ClusterVirtualMachineRole  
    ```

1. Complete the remaining steps in [Import the VMs](#import-the-vms).

### Option 2: Direct VHD copy

This method uses Robocopy to copy VM VHDs that are hosted on Windows 2008 SP1, Windows 2008 R2-SP1, and Windows 2012 to Azure Stack HCI. This bypasses the minimum supported VM version limitation for these older VMs. We recommend this option for VMs hosted on Windows Server 2008 SP1 and Windows Server 2008 R2-SP1.

VMs hosted on Windows 2008 SP1 and Windows 2008 R2-SP1 support only Generation 1 VMs with Generation 1 VHDs. As such, corresponding Generation 1 VMs need to be created on Azure Stack HCI so that the copied VHDs can be attached to the new VMs. Note that these VHDs cannot be upgraded to Generation 2 VHDs.

> [!NOTE]
> Windows Server 2012 supports both Generation 1 and Generation 2 VMs.

Here is the process you use:

1. Use the example Robocopy to copy VMs VHDs directly to Azure Stack HCI:

    `Robocopy \\2012R2-Clus01\c$\clusterstorage\volume01\Hyper-V\   \\20H2-Clus01\c$\clusterstorage\volume01\Hyper-V\ /Copyall /E /MT:32 /R:0 /w:1 /NFL /NDL /log:c:\log.txt /xf`

1. Create new Generation 1 VMs. For detailed information on how to do this, see [Manage VMs](https://docs.microsoft.com/azure-stack/hci/manage/vm).

1. Attach the copied VHD files to the new VMs. For detailed information, see [Manage Virtual Hard Disks (VHD)](https://docs.microsoft.com/windows-server/storage/disk-management/manage-virtual-hard-disks)

As an FYI, the following Windows Server guest operating systems support Generation 2 VMs:

- Windows Server 2019
- Windows Server 2016
- Windows Server 2012 R2
- Windows Server 2012
- Windows 10
- 64-bit versions of Windows 8.1 (64-bit)
- 64-bit versions of Windows 8 (64-bit)
- Linux (See [Supported Linux and FreeBSD VMs](https://docs.microsoft.com/windows-server/virtualization/hyper-v/Supported-Linux-and-FreeBSD-virtual-machines-for-Hyper-V-on-Windows))

## Next steps

- Validate the cluster after migration. See [Validate an Azure Stack HCI cluster](validate.md).

- To migrate to Azure Stack HCI in-place using the same hardware, see [Migrate to Azure Stack HCI on the same hardware](migrate-cluster-same-hardware.md).