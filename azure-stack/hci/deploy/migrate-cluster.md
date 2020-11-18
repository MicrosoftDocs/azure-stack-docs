--- 
title: Migrate a cluster to Azure Stack HCI 
description: Learn how to migrate a cluster to Azure Stack HCI 
author: v-dasis 
ms.topic: how-to 
ms.date: 11/17/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Migrate a cluster to Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2

This topic describes how to migrate a cluster from Windows Server 2016 or Windows Server 2019 to Azure Stack HCI using Windows PowerShell and Robocopy. Robocopy is a robust method for copying files from one server to another. It resumes if disconnected and continues to work from its last known state. Robocopy also supports multi-threaded file copy over Server Message Block (SMB). For more information, see [Robocopy](https://docs.microsoft.com/windows-server/administration/windows-commands/robocopy).

The following diagram shows a Windows Server source cluster and an Azure Stack HCI destination cluster:

:::image type="content" source="media/migrate/migrate-cluster.png" alt-text="Migrate cluster to Azure Stack HCI" lightbox="media/migrate/migrate-cluster.png":::

In terms of expected downtime, using a single NIC with a dual 40 GB RDMA East-West network between clusters, and Robocopy configured for 32 multithreads, transfer speeds of 1.9 TB per hour can be realized.

> [!NOTE]
> Migrating stretched clusters is not covered in this article.

## Before you begin

There are several requirements and things to consider before you begin migration:

- You must have domain credentials with administrator permissions for both source and destination clusters, with full rights to the source and destination Organizational Unit (OU) that contains both clusters.

- Both clusters must be in the same Active Directory forest and domain to facilitate Kerberos authentication between clusters for migration of virtual machines (VMs).

- Both clusters must reside in an Active Directory OU with Group Policy Object (GPO) Block inheritance set on this OU. This ensures no domain-level GPOs and security policies can impact the migration.

- Both clusters must be connected to the same time source to support consistent Kerberos authentication between clusters.

- Make note of the Hyper-V virtual switch name used by VMs on the source cluster. You must create the same virtual switch name for the Azure Stack HCI destination cluster "virtual machine network" prior to importing VMs.

- You must shutdown all VMs on the source cluster. This is required to ensure version control and state are maintained throughout the migration process.

- Check if Azure Stack HCI supports your version of VMs to import. Use the PowerShell `Get-VMHostSupportedVersion` and `Get-VM` cmdlets to get your VM version information.

- Backup all VMs on your source cluster. Complete a crash-consistent backup of all applications and data and an application-consistent backup of all databases.

- Ensure the maximum Jumbo frame sizes are the same between source and destination cluster storage networks, specifically the RDMA network adapters and their respective switch network ports to provide the most efficient end-to-end transfer packet size.

- Remove any ISO image files for your source VMs. This is done using Hyper-V Manager in **VM Properties** in the **Hardware section**. Click **Remove** for any virtual CD/DVD drives.

- Take a checkpoint snapshot of your source cluster VMs and domain controller in case you have to roll back to a prior state. This is not applicable for physical servers.

- If possible, physically locate the source and destination clusters as close together as possible to facilitate the fastest transfer of VMs.

## RDMA recommendations

If you are using Remote Direct Memory Access (RDMA), Robocopy can leverage it for copying your VMs between clusters. Here are some recommendations for using RDMA:

- Connect both clusters to the same top of rack (ToR) switch to use the fastest network path between source and destination clusters. For the storage network path this typically supports 10Gbe/25Gbe or higher speeds and leverages RDMA.

- If the RDMA adapter or standard is different between source and destination clusters (ROCE vs iWARP), Robocopy will instead leverage SMB over TCP/IP via the fastest available network. This will typically be a dual 10Gbe/25Gbe or higher speed for the East-West network, providing the most optimal way to copy VM VHDX files between clusters.

- To ensure Robocopy can leverage RDMA between clusters (East-West network), configure RDMA storage networks so they are routable between the source and destination clusters.

## Create the destination cluster

Before you can create the destination cluster, you need to install the Azure Stack HCI OS on each server that will be in the new cluster. For information on how to do this, see [Deploy the Azure Stack HCI operating system](operating-system.md).

Use Windows Admin Center or Windows PowerShell to create the new cluster. For information on how to do this, see [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md) and [Create an Azure Stack HCI cluster using Windows PowerShell](create-cluster-powershell.md).

> [!NOTE]
> Make sure the Hyper-V virtual switch name created on the destination cluster matches the Hyper-V virtual switch name on the source cluster.

## Run the migration script

The following PowerShell script `Robocopy_Remote_Server_.ps1` uses Robocopy to copy VM files and their dependent directories and metadata from the source cluster to the destination cluster. This script has been modified from  from the original script on TechNet at: [Robocopy Files to Remote Server Using PowerShell and RoboCopy](https://gallery.technet.microsoft.com/scriptcenter/Robocoy-Files-to-Remote-bdfc5154).

The script creates a folder named `ISO` on the `C:` drive of each destination cluster server node, then copies all VM VHD, VHDX, and VMCX files to your destination cluster for each Cluster Shared Volume (CSV). One CSV is migrated at a time.

The migration script is run locally on each source cluster node to leverage the benefit of RDMA and fast network transfer. Let's begin:

1. Run the following script on each Windows Server source cluster node.

1. Make sure each destination cluster node is set to the CSV owner for the destination CSV.

1. Change the following three variables to match the source cluster VM path with the destination cluster VM path:

    - `$Dest_Server = "Node01"`
    - `$source  = "C:\Clusterstorage\Volume01"`
    - `$dest = "\\$Dest_Server\C$\Clusterstorage\Volume01"`

Here is the script:

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

## Post-migration tasks

A best practice is to create at least one Cluster Shared Volume (CSV) per cluster node to enable an even balance of VMs for each CSV owner for increased resiliency, performance, and scale of VM workloads. By default, this balance occurs automatically every five minutes and needs to be considered when using Robocopy between a source cluster node and the destination cluster node to ensure source and destination CSV owners match to provide the most optimal transfer path and speed.

Perform the following steps on your Azure Stack HCI cluster to import, register, and start the VMs:

1. Run the following cmdlet to show all CSV owner nodes:

    ```powershell
    Get-ClusterSharedVolume
    ```

1. For each server node, go to `C:\Clusterstorage\Volume` and set the path for all VMs - for example `C:\Clusterstorage\volume01`.

1. Run the following cmdlet on each CSV owner node to display the path to all VM VMCX files per volume prior to VM import. Modify the path to match your environment:

    ```powershell
    Get-ChildItem -Path "C:\Clusterstorage\Volume01\*.vmcx" -Recurse
    ```

1. Run the following cmdlet for each server node to import and register all VMs and make them highly available on each CSV owner node. This ensures an even distribution of VMs for optimal processor and memory allocation:

    ```powershell
    Get-ChildItem -Path "C:\Clusterstorage\Volume01\*.vmcx" -Recurse | Import-VM -Register | Get-VM | Add-ClusterVirtualMachineRole
    ```

1. Start each destination VM on each node:

    ```powershell
    Start-VM -Name
    ```

1. Login and verify that all VMs are running and that all your apps and data are there:

    ```powershell
    Get-VM -ComputerName Server01 | Where-Object {$_.State -eq 'Running'}
    ```

1. Update your VMs to the latest version to take advantage of all the advancements:

    ```powershell
    Get-VM | Update-VMVersion -Force
    ```

1. After the script has completed, check the Robocopy log file for any errors listed and to verify that all VMS are copied successfully.

## Next steps

Validate the cluster after migration. See [Validate an Azure Stack HCI cluster](validate.md).