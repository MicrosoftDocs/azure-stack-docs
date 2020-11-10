--- 
title: Migrate a cluster to Azure Stack HCI 
description: Learn how to migrate a cluster to Azure Stack HCI 
author: v-dasis 
ms.topic: how-to 
ms.date: 11/11/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Migrate a cluster to Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2

This topic describes how to migrate a cluster from Windows Server to Azure Stack HCI using a Windows PowerShell script and Robocopy. Robocopy is a robust method for copying files from one server to another. It will also resume if disconnected and continue to work from its last known state. Robocopy supports multi-threaded file copy over Server Message Block (SMB).

For more information on Robocopy, see [Robocopy](https://docs.microsoft.com/windows-server/administration/windows-commands/robocopy).

## Before you begin

There are several requirements and things to consider before you begin migration:

- Make sure you have domain credentials with administrator permissions for both source and destination clusters.

- Check if Azure Stack HCI supports your version of VMs to import. Azure Stack HCI supports all versions from Windows Server 2012 R2 version 5 through version 9 of Azure Stack HCI version 20H2. Use the Windows PowerShell `Get-VMHostSupportedVersion` and `Get-VM` cmdlets to get this information.

- Backup all VMs on your Windows Server cluster. Complete a crash-consistent backup of all applications and data and an application-consistent backup of all databases.

- Make note of the virtual switch names used for your Windows Server nodes. You will need to use the same names for the Azure Stack HCI cluster virtual switches.

- Ensure the maximum Jumbo frame sizes are the same between source and destination cluster storage networks - this is typically 9014.

- Remove reference to all ISOs on your source VMs. 

- Shutdown all virtual machines (VMs) on the existing Windows Server cluster. This is required to ensure version control and state are maintained throughout the migration process.

## RDMA recommendations

If you are using Remote Direct Memory Access (RDMA), Robocopy can leverage it for migration of your virtual machines (VMs). Here are some recommendations for using RDMA:

- Configure RDMA storage networks so they are routable between the source and destination clusters.

- Connect both clusters to the same top of rack (ToR) switch with dual 10Gbe/25Gbe connections.

If the RDMA standard is different between clusters (ROCE vs iWARP), Robocopy will leverage TCP IP/SMB over dual 25Gbe networks for migration of the VMs.

## Create the new cluster

Before you can create the cluster, you need to install the Azure Stack HCI OS on each server that will be in the new cluster. For information on how to do this, see [Deploy the Azure Stack HCI operating system](operating-system.md).

Use Windows Admin Center or Windows PowerShell to create the new Azure Stack HCI cluster. For information on how to do this, see [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md) and [Create an Azure Stack HCI cluster using Windows PowerShell](create-cluster-powershell.md).

> [!NOTE]
> Make sure during virtual switch creation that the names match the switch names on the source cluster.

## Run the migration script

The following PowerShell script `Robocopy_Remote_Server_.ps1` uses Robocopy to copy files from the source cluster to the destination cluster.

The script creates a folder named `ISO` on the `C:` drive of each destination cluster server node. The script also copies all VHD, VHDX, and VMCX files from the source cluster to your destination cluster for each Cluster Shared Volume (CSV).

1. Run the script on each source cluster node.

1. Make sure each destination cluster node is set to the CSV owner for the destination CSV.

1. change the following three variables to match your source cluster VM path with your destination cluster VM path:

    - `$Dest_PC = "destination_cluster_server_node"`
    - `$source  = "C:\Clusterstorage\Volume01"`
    - `$dest = "\\$Dest_PC\C$\Clusterstorage\Volume01"`

1. Run the script in a Powershell session window:

```powershell
<#
#===========================================================================  
# Script: Robocopy_Remote_Server_.ps1
#===========================================================================  
.DESCRIPTION:
Change the following variables to match your source cluster VM path with the destination cluster VM path. Then run this script on each source Cluster Node CSV owner and make sure the destination cluster node is set to the CSV owner for the destination CSV.

        Change $Dest_PC = "destination_cluster_server_node"
        Change $source  = "C:\Clusterstorage\Volume01"
        Change $dest = "\\$Dest_PC\C$\Clusterstorage\Volume01"
#>

$Space       = Write-host ""
$Dest_PC     = "Destination Cluster Node"
$source      = "C:\ClusterStorage\Volume01"
$dest        = "\\$Dest_PC\c$\clusterstorage\volume01"
$Logfile     = "c:\temp\Robocopy1-$date.txt"
$date        = Get-Date -UFormat "%Y%m%d"
$cmdArgs     = @("$source","$dest",$what,$options)  
$what        = @("/COPYALL")
$options     = @("/E","/MT:32","/R:0","/W:1","/NFL","/NDL","/LOG:$logfile","/xf")
 
## Get Start Time
$startDTM = (Get-Date)
 
$Dest_PC     = "Destination Cluster Node"
$TARGETDIR   = \\$Dest_PC\c$\clusterstorage\volume01
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
Write-host " Copy Virtual Machines to $Dest_PC has been completed......" -fore Green -back black
Write-host " Copy Virtual Machines to $Dest_PC took $Time        ......" -fore Cyan
```

## Post-migration tasks

After the script has completed for each CSV, you will have an even distribution of CSVs to a node by default. After a few minutes, these will balance on each server node. For example, with four nodes and four CSVs, each node will own one CSV.

1. Run the following cmdlet to show all CSVs and node owners:

    ```powershell
    Get-ClusterSharedVolume
    ```

1. For each node, go to `C:\Clusterstorage\Volume` and set the path for all VMs, for example `C:\ClusterStorage\volume01`.

1. Run the following cmdlet on each CSV owner node to ensure the path is found to all VMCX files per volume. Modify the path to match your environment.

    ```powershell
    Get-ChildItem -Path "c:\clusterstorage\volume01\*.vmcx"-Recurse
    ```

1. Run the following cmdlet to import and register all VMs and make them highly available on each CSV owner node. This ensures an even distribution of VMs for optimal processor and memory:

    ```powershell
    Get-ChildItem -Path "c:\clusterstorage\volume01\*.vmcx" -Recurse    | Import-VM -Register | Get-VM | Add-ClusterVirtualMachineRole 
    ```

## Next steps

Validate the cluster after migration. See [Validate an Azure Stack HCI cluster](validate.md).