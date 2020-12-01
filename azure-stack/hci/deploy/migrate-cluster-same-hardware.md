---
title: Migrate a cluster to Azure Stack HCI on the same hardware
description: Learn how to migrate a cluster to Azure Stack HCI on the same hardware
author: v-dasis 
ms.topic: how-to 
ms.date: 12/01/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Migrate a cluster to Azure Stack HCI on the same hardware

> Applies to Azure Stack HCI, version 20H2

This topic describes how to migrate a Windows Server 2016 or Windows Server 2019 cluster to Azure Stack HCI using your existing server hardware. This process installs the new Azure Stack HCI operating system and retains your existing cluster settings, storage, and VMs.

To migrate Windows Server VMs to new Azure Stack HCI hardware, see [Migrate VMs to new hardware]

> [!NOTE]
> Migrating stretched clusters is not covered in this article.

## Before you begin

There are several requirements and things to consider before you begin migration:

- Backup all VMs on your source cluster. Complete a crash-consistent backup of all applications and data and an application-consistent backup of all databases.
- Collect inventory and configuration of all cluster nodes and cluster naming, network configuration, Cluster Shared Volume (CSV) resiliency/capacity, and quorum witness.
- Shutdown your cluster VMs, offline CSVs, offline storage pools, and the cluster service.
- Disable the Cluster Name Object (CNO) (it is reused later) and:
    - Check that the CNO has Create Object rights to its own Organizational Unit (OU)
    - Check that the block inherited policy has been set on the OU
    - Set the required policy for Azure Stack HCI on this OU

## Update the servers and cluster

Install Azure Stack HCI on each Windows Server 2016/2019 server node that will be in the upgraded cluster. Select **Custom: Install the newer version of Azure Stack HCI only (Advanced)** during setup. This replaces your current operating system with Azure Stack HCI. For information on how to do this, see [Deploy the Azure Stack HCI operating system](operating-system.md).

> [!NOTE]
> Azure Stack HCI deployment does not enable advanced capabilities such as RDMA.

If using Windows Admin Center to create the cluster:

1. Skip step **4.1 Clean drives**. Otherwise you will delete your existing VMs and storage.
2. In step **4.2 Verify drives**, verify that all drives are listed without warnings.

If using Windows PowerShell to create the cluster, use the same ame for the previously disabled Cluster Name Object, then:

1. Run the following cmdlet to create the cluster:

    ```powershell
    New-cluster –name "clustername" –node Server01,Server02 –staticaddress xx.xx.xx.xx –nostorage
    ``
1. Create the quorum witness. For information on how, see [Set up a cluster witness](https://docs.microsoft.com/azure-stack/hci/deploy/witness)

1. Run the following cmdlet to to create the new ~Storagesubsystem~ Object ID, rediscover all storage enclosures, and assign SES drive numbers prior to verifying the drives :

    ```powershell
    Run Enable-ClusterS2D -Verbose
    ``

> [!NOTE]
> For Windows 2016, the ~ClusterperformanceHistory~ volume is automatically assigned to the Cluster Group.

1. Verify drives will pass this test as follows:
1. 
1. If a storage pool has minority errors, re-run the following:

    ```powershell
    Enable-ClusterS2D
    ```

1. Enable every CSV except the cluster performance history volume, which is a ReFS volume (make sure this is not an ReFS CSV).

> [!NOTE]
> For windows Server 2019, re-run ~Enable-ClusterS2D -verbose~ to associate the cluster performance history ReFS volume with the Cluster Group.

1. Verify that storage repair jobs are completed using the following:

    ```powershell
    Get-StorageJob
    ``

This could take considerable time depending on the number of VMs running during the 
upgrade.

1. Verify that all disks are healthy:

    ```powershell
    Get-VirtualDisk
    ``

1. Determine the cluster node version, which displays ~ClusterFunctionalLevel~ and ~ClusterUpgradeVersion":

    ```powershell
    Get-ClusterNodeSupportedVersion
    ``

> [!NOTE]
> ~ClusterFunctionalLevel~ is automatically set to 10 and does not require updating due to the new OS and new cluster creation.

1. Determine your current storage pool version by running the following:

    ```powershell
    Get-StoragePool | ? IsPrimordial -eq $false | ft FriendlyName,Version
    ``

1. Update your storage pool as follows:

    ```powershell
    Get-StoragePool | Update-StoragePool
    ``

1. Now determine your new storage pool version:

    ```powershell
    Get-StoragePool | ? IsPrimordial -eq $false | ft FriendlyName,Version
    ``

## ReFS volumes

If migrating from Windows Server 2016, Resilient File System (ReFS) volumes are supported, but not the following performance enhancements in Azure Stack HCI:

- Mirror-accelerated parity
- MAP log bypass

These enhancements require a new ReFS volume to be created using the ~New-Volume~ cmdlet:

## Post-migration tasks

A best practice is to create at least one Cluster Shared Volume (CSV) per cluster node to enable an even balance of VMs for each CSV owner for increased resiliency, performance, and scale of VM workloads. By default, this balance occurs automatically every five minutes and needs to be considered when using Robocopy between a source cluster node and the destination cluster node to ensure source and destination CSV owners match to provide the most optimal transfer path and speed.

Perform the following steps on your Azure Stack HCI cluster to import, make highly available, and start the VMs:

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

## Next steps

- Validate the cluster after migration. See [Validate an Azure Stack HCI cluster](validate.md).
- To migrate Windows Server VMs to new Azure Stack HCI hardware, see [Migrate VMs to new hardware].