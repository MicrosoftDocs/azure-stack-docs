--- 
title: Migrate a cluster to Azure Stack HCI 
description: Learn how to migrate a cluster to Azure Stack HCI 
author: v-dasis 
ms.topic: how-to 
ms.date:10/29/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Migrate a cluster to Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2

This topic describes how to migrate a cluster from Windows Server 2016/2019 to Azure Stack HCI. Make sure you have domain credentials with administrator permissions for both source and destination clusters.

## Before you begin

1. Check if Azure Stack HCI supports your version of VM to import. Azure Stack HCI supports all version from v5.0 (2012 R2) up to v9.0 (2019/20H2). Use the `Get-VMHostSupportedVersion` cmdlet to show you this information. `Get-VM` will show you the VM version.

2. Shutdown all virtual machines (VMs) on the existing Windows Server cluster. This is required to ensure version control and state are maintained through the migration process.

3. Backup all VMs on the existing cluster. Specifically, complete a crash-consistent backup of all applications and data and an application-consistent backup of all databases.

## Create the new cluster

Use Windows Admin Center or Windows PowerShell to create the new cluster.

## Copy stuff to new cluster

Robocopy supports multi-threaded copies over SMB, so it can leverage RDMA and greatly reduce the time to copy the VMs; for this reason it is recommended to connect both clusters to the same top of rack switch with dual 10gbe/25Gbe connections.

Configure RDMA storage networks so these are routeable between the source and destination cluster.

If the RDMA type is different between clusters (ROCE vs. iWARP), then leverage TCP-IP/SMB over dual 25Gb connections for migration/copy of VMs.

Ensure the maximum jumbo frame sizes are the same between the cluster storage networks (typically 9014).

The following PowerShell script uses Robocopy to copy files from the source cluster to the destination cluster. Script will create folder (called ISO) on the C: (root) drive of the destination node. There are a few simple variables you will need to change. Robocopy is a robust method for copying files from one server to another. It will also resume if disconnected and continue to work from its last known state.

```powershell
<#
#===========================================================================  
# Script: Robocopy_Remote_Server_.ps1
#===========================================================================  
.DESCRIPTION: make sure to change these variables to align with your Source Virtual Machine path and Destination Cluster Node and Virtual machine path
Run this PowerShell script on each source cluster node CSV owner and ensure destination cluster node is set to the CSV owner for the destination CSV.

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
