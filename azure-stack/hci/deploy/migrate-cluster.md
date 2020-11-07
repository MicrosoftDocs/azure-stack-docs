--- 
title: Migrate a cluster to Azure Stack HCI 
description: Learn how to migrate a cluster to Azure Stack HCI 
author: v-dasis 
ms.topic: how-to 
ms.date: 11/06/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Migrate a cluster to Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2

This topic describes how to migrate a cluster from Windows Server 2016 and 2019 to Azure Stack HCI. Make sure you have domain credentials with administrator permissions for both source and destination clusters.

## Before you begin

1. Check if Azure Stack HCI supports your version of VMs to import. Azure Stack HCI supports all versions from version 5.0 (2012 R2) up to version 9.0 (20H2). Use the `Get-VMHostSupportedVersion` and `Get-VM` cmdlets to get this information.

1. Shutdown all virtual machines (VMs) on the existing Windows Server cluster. This is required to ensure version control and state are maintained throughout the migration process.

1. Backup all VMs on the existing Windows Server cluster. Specifically, complete a crash-consistent backup of all applications and data and an application-consistent backup of all databases.

## Create the new cluster

Use Windows Admin Center or Windows PowerShell to create the new Azure Stack HCI cluster. For information on how to do this, see [Create an Azure Stack HCI cluster using Windows Admin Center](create-cluster.md) and [Create an Azure Stack HCI cluster using Windows PowerShell](create-cluster-powershell.md).

## Copy VMs to the new cluster

A few things to consider before you migrate your VMs over:

We recommend using Robocopy to copy your VMs to the new cluster. Robocopy is a robust method for copying files from one server to another. It will also resume if disconnected and continue to work from its last known state.

Robocopy also supports multi-threaded copies over SMB, which uses RDMA, thus greatly reducing the time to copy your VMs. For this reason we recommend connecting both source and destination clusters to the same top of rack (ToR) switch with dual 10gbe/25Gbe connections.

Configure your RDMA storage networks so they are route-able between the source and destination clusters. If the RDMA type is different between clusters (say ROCE vs. iWARP), then use TCP-IP/SMB over dual 25Gb connections to copy your VMs.

Ensure the maximum jumbo frame sizes are the same between the cluster storage networks. Typically the size is 9014.

The following `Robocopy_Remote_Server_.ps1` PowerShell script uses Robocopy to copy files from the source cluster to the destination cluster. The script will create a folder named `ISO` on the C: drive of each destination cluster server node.

Run the script on each source cluster node CSV owner and make sure the destination cluster node is set to the CSV owner for the destination CSV.

You need to change the following variables to match your source cluster VM path with your destination cluster VM path:

- $Dest_PC = "destination_cluster_server_node"
- $source  = "C:\Clusterstorage\Volume01"
- $dest = "\\$Dest_PC\C$\Clusterstorage\Volume01"

```powershell
<#
#===========================================================================  
# Script: Robocopy_Remote_Server_.ps1
#===========================================================================  
.DESCRIPTION: make sure to change the variables to align with your source cluster VM path and destination cluster VM path
Run this PowerShell script on each Source Cluster Node CSV owner and ensure destination cluster node is set to the CSV owner for the destination CSV. to optimize 
The robocopy of virtual machines.

        Change $Dest_PC = "Destination Cluster Node"
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
