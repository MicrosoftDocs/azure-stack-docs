--- 
title: Migrate a cluster to Azure Stack HCI 
description: Learn how to migrate a cluster to Azure Stack HCI 
author: v-dasis 
ms.topic: how-to 
ms.date: 11/13/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Migrate a cluster to Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2

This topic describes how to migrate a cluster from Windows Server to Azure Stack HCI using Windows PowerShell and Robocopy. Robocopy is a robust method for copying files from one server to another. It resumes if disconnected and continues to work from its last known state. Robocopy also supports multi-threaded file copy over Server Message Block (SMB). For more information, see [Robocopy](https://docs.microsoft.com/windows-server/administration/windows-commands/robocopy).

## Before you begin

There are several requirements and things to consider before you begin migration:

- Make sure you have domain credentials with administrator permissions for both source and destination clusters.

- Check if Azure Stack HCI supports your version of virtual machines (VMs) to import. Azure Stack HCI supports all versions of VMs from Windows Server 2012 R2 (Hyper-V version 5.0) to Azure Stack HCI version 20H2 (Hyper-V version 9.0). Use the PowerShell `Get-VMHostSupportedVersion` and `Get-VM` cmdlets to get VM version information.

- Backup all VMs on your Windows Server cluster. Complete a crash-consistent backup of all applications and data and an application-consistent backup of all databases.

- Make note of the virtual switch names used for your Windows Server nodes. You will need to use the same names for the Azure Stack HCI cluster virtual switches.

- Ensure the maximum Jumbo frame sizes are the same between source and destination cluster storage networks - this is typically 9014.

- Remove any references to ISOs for your source VMs.

- Take a checkpoint snapshot of your source cluster (VMs and domain controller) in case you have to roll back to a prior state.

- Shutdown all virtual machines (VMs) on the Windows Server cluster. This is required to ensure version control and state are maintained throughout the migration process.

## RDMA recommendations

If you are using Remote Direct Memory Access (RDMA), Robocopy can leverage it for migration of your VMs. Here are some recommendations for using RDMA:

- Configure RDMA storage networks so they are routable between the source and destination clusters.

- Connect both clusters to the same top of rack (ToR) switch with dual 10Gbe/25Gbe connections.

If the RDMA standard is different between clusters (ROCE vs iWARP), Robocopy will leverage TCP IP/SMB over dual 25Gbe networks for migration of the VMs.

## Create the new cluster

Before you can create the new cluster, you need to install the Azure Stack HCI OS on each server that will be in the new cluster. For information on how to do this, see [Deploy the Azure Stack HCI operating system](operating-system.md).

Use Windows Admin Center or Windows PowerShell to create the new cluster. For information on how to do this, see [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md) and [Create an Azure Stack HCI cluster using Windows PowerShell](create-cluster-powershell.md).

> [!NOTE]
> Make sure during virtual switch creation that the names specified match the switch names on the source cluster.

## Run the migration script

The following PowerShell script `Robocopy_Remote_Server_.ps1` uses Robocopy to copy files from the source cluster to the destination cluster. This script has been modified from  from the original script on TechNet at: [Robocopy Files to Remote Server Using PowerShell and RoboCopy](https://gallery.technet.microsoft.com/scriptcenter/Robocoy-Files-to-Remote-bdfc5154).

The script creates a folder named `ISO` on the `C:` drive of each destination cluster server node. The script also copies all VHD, VHDX, and VMCX files from the source cluster to your destination cluster for each Cluster Shared Volume (CSV).

1. Run the following script on each Windows Server source cluster node.

1. Make sure each destination cluster node is set to the CSV owner for the destination CSV.

1. Change the following three variables to match the source cluster VM path with the destination cluster VM path:

    - `$Dest_PC = "destination_cluster_server_node"`
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

        Change $Dest_Server = "destination_cluster_server_node"
        Change $source  = "C:\Clusterstorage\Volume01"
        Change $dest = "\\$Dest_Server\C$\Clusterstorage\Volume01"
#>

$Space       = Write-host ""
$Dest_Server = "Destination Cluster Node"
$source      = "C:\Clusterstorage\Volume01"
$dest        = "\\$Dest_Server\c$\Clusterstorage\Volume01"
$Logfile     = "c:\temp\Robocopy1-$date.txt"
$date        = Get-Date -UFormat "%Y%m%d"
$cmdArgs     = @("$source","$dest",$what,$options)  
$what        = @("/COPYALL")
$options     = @("/E","/MT:32","/R:0","/W:1","/NFL","/NDL","/LOG:$logfile","/xf")
 
## Get Start Time
$startDTM = (Get-Date)
 
$Dest_PC     = "Destination Cluster Node"
$TARGETDIR   = \\$Dest_Server\c$\Clusterstorage\Volume01
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

After the script has completed for each server node, you will have an even distribution of CSVs by default. After a few minutes, these will balance on each destination server node. For example, with four nodes and four CSVs, each node will own one CSV. Perform the following steps on your Azure Stack HCI cluster:

1. Run the following cmdlet to show all CSV owner nodes:

    ```powershell
    Get-ClusterSharedVolume
    ```

1. For each server node, go to `C:\Clusterstorage\Volume` and set the path for all VMs - for example `C:\Clusterstorage\volume01`.

1. Run the following cmdlet on each CSV owner node to ensure the path is found to all VMCX files per volume. Modify the path to match your environment:

    ```powershell
    Get-ChildItem -Path "C:\Clusterstorage\Volume01\*.vmcx" -Recurse
    ```

1. Run the following cmdlet to import and register all VMs and make them highly available on each CSV owner node. This ensures an even distribution of VMs for optimal processor and memory allocation:

    ```powershell
    Get-ChildItem -Path "C:\Clusterstorage\Volume01\*.vmcx" -Recurse | Import-VM -Register | Get-VM | Add-ClusterVirtualMachineRole 
    ```

## Next steps

Validate the cluster after migration. See [Validate an Azure Stack HCI cluster](validate.md).