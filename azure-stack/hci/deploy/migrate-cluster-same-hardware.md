---
title: Migrate to Azure Stack HCI on same hardware
description: Learn how to migrate a cluster to Azure Stack HCI on the same hardware
author: v-dasis 
ms.topic: how-to 
ms.date: 12/02/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Migrate to Azure Stack HCI on same hardware

> Applies to Azure Stack HCI, version 20H2; Windows Server 2019, Windows Server 2016, Windows Server 2008 R2

This topic describes how to migrate a Windows Server 2016 or Windows Server 2019 cluster to Azure Stack HCI using your existing server hardware. This process installs the new Azure Stack HCI operating system and retains your existing cluster settings and storage, and imports your VMs.

To migrate your VMs to new Azure Stack HCI hardware, see [Migrate to Azure Stack HCI on new hardware](migrate-cluster-new-hardware.md).

> [!NOTE]
> Migrating stretched clusters is not covered in this article.

## Before you begin

There are several requirements and things to consider before you begin migration:

- You must have domain credentials with administrator permissions for Azure Stack HCI.
- Backup all VMs on your source cluster. Complete a crash-consistent backup of all applications and data and an application-consistent backup of all databases.
- Collect inventory and configuration of all cluster nodes and cluster naming, network configuration, Cluster Shared Volume (CSV) resiliency and capacity, and quorum witness.
- Shutdown your cluster VMs, offline CSVs, offline storage pools, and the cluster service.
- Disable the Cluster Name Object (CNO) (it is reused later) and:
    - Check that the CNO has Create Object rights to its own Organizational Unit (OU)
    - Check that the block inherited policy has been set on the OU
    - Set the required policy for Azure Stack HCI on this OU

## VM version support and update

The following table lists supported Windows Server OS versions and their VM versions for in-place migration on the same hardware.

Regardless of the OS version a VM may be running on, the minimum VM version supported for migration to Azure Stack HCI is version 5.0. So any VMs running at version 2.0, 3.0, or 4.0 on your Windows Server 2016 or Windows Server 2019 cluster must be updated to version 5.0 before migration.

|OS version|VM version|
|---|---|
|Windows Server 2008 SP1|2.0|
|Windows Server 2008 R2|3.0|
|Windows Server 2012|4.0|
|Windows Server 2012 R2|5.0|
|Windows Server 2016 Technical Preview 3|6.2|
|Windows Server 2016 Technical Preview 4|7.0|
|Windows Server 2016 Technical Preview 5|7.1|
|Windows Server 2016|8.0|
|Windows Server 2019/1709|9.0|
|Azure Stack HCI|9.0|

For VMs on Windows Server 2008 SP1, Windows Server 2008 R2-SP1, and Windows 2012 clusters, direct migration to Azure Stack HCI is not supported. In these cases, you have two options:

- Migrate these VMs to Windows Server 2016 or Windows Server 2019 first, update the VM version, then begin the migration process.

- Use Robocopy to copy all VM VHDs to Azure Stack HCI. Then create new VMs and attach the copied VHDs to their respective VMs in Azure Stack HCI. This bypasses the VM version limitation for these older VMs.

Use the following command to show all VM versions on a single server:

```powershell
Get-VM * | Format-Table Name,Version
```

To show all VM versions across all nodes on your Windows Server cluster:

```powershell
Get-VM –ComputerName (Get-ClusterNode)
```

To update all VMs to the latest version on all Windows Server nodes:

```powershell
Get-VM –ComputerName (Get-ClusterNode) | Update-VMVersion -Force
```

## Update the servers and cluster

First, install the Azure Stack HCI operating system on each Windows Server node. You can use Windows Admin Center to do this. During setup, select **Custom: Install the newer version of Azure Stack HCI only (Advanced)**. This replaces your current operating system with Azure Stack HCI. For detailed information, see [Deploy the Azure Stack HCI operating system](operating-system.md).

Next, create the new Azure Stack HCI cluster. You can use Windows Admin Center or Windows PowerShell to do this, If using Windows Admin Center, start the [Create Cluster wizard](create-cluster.md). When you get to **Step 4: Storage**:

1. Skip step **4.1 Clean drives**. Otherwise you will delete your existing VMs and storage.
2. In step **4.2 Verify drives**, verify that all drives are listed without warnings or errors.

If using [Windows PowerShell](create-cluster-powershell.md) to create the cluster, use the same name for the previously disabled Cluster Name Object, then:

1. Run the following cmdlet to create the cluster:

    ```powershell
    New-cluster –name "clustername" –node Server01,Server02 –staticaddress xx.xx.xx.xx –nostorage
    ```

1. Create the quorum witness. For information on how, see [Set up a cluster witness](https://docs.microsoft.com/azure-stack/hci/deploy/witness)

1. Run the following cmdlet to to create the new `Storagesubsystem` Object ID, rediscover all storage enclosures, and assign SES drive numbers. Do this prior to verifying the drives:

    ```powershell
    Run Enable-ClusterS2D -Verbose
    ```

    > [!NOTE]
    > For Windows Server 2016, the `ClusterperformanceHistory` volume is automatically created and assigned to the Cluster group.

1. If a storage pool shows errors, re-run the following:

    ```powershell
    Enable-ClusterS2D
    ```

1. Enable every CSV except the cluster performance history volume, which is a ReFS volume (make sure this is not an ReFS CSV).

    > [!NOTE]
    > For windows Server 2019, re-run `Enable-ClusterS2D -verbose` to associate the cluster performance history ReFS volume with the Cluster group.

1. Verify that storage repair jobs are completed using the following:

    ```powershell
    Get-StorageJob
    ```

    This could take considerable time depending on the number of VMs running during the upgrade.

1. Verify that all disks are healthy:

    ```powershell
    Get-VirtualDisk
    ```

1. Determine the cluster node version, which displays `ClusterFunctionalLevel` and `ClusterUpgradeVersion`. Run the following to get this:

    ```powershell
    Get-ClusterNodeSupportedVersion
    ```

    > [!NOTE]
    > `ClusterFunctionalLevel` is automatically set to `10` and does not require updating due to new OS and cluster creation.

1. Determine your current storage pool version by running the following:

    ```powershell
    Get-StoragePool | ? IsPrimordial -eq $false | ft FriendlyName,Version
    ```

1. Update your storage pool as follows:

    ```powershell
    Get-StoragePool | Update-StoragePool
    ```

1. Now determine your new storage pool version:

    ```powershell
    Get-StoragePool | ? IsPrimordial -eq $false | ft FriendlyName,Version
    ```

## ReFS volumes

If migrating from Windows Server 2016, Resilient File System (ReFS) volumes are supported, but such volumes do not benefit from the following performance enhancements in Azure Stack HCI:

- Mirror-accelerated parity
- MAP log bypass

These enhancements require a new ReFS volume to be created using the `New-Volume` cmdlet.

> [!NOTE]
> For Windows Server 2016 Mirror Accelerated Parity Volumes, ReFS compaction, was not available, so re-attaching these volumes is OK but will be less performant compared to creating a new MAP volume on Azure Stack HCI cluster.

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

1. Lastly, update your VMs to the latest Azure Stack HCI version to take advantage of all the advancements:

    ```powershell
    Get-VM | Update-VMVersion -Force
    ```

## Next steps

- Validate the cluster after migration. See [Validate an Azure Stack HCI cluster](validate.md).
- To migrate Windows Server VMs to new Azure Stack HCI hardware, see [Migrate VMs to new hardware].