---
title: Migrate to Azure Local on same hardware
description: Learn how to migrate a system to Azure Local on the same hardware
author: alkohli 
ms.topic: how-to 
ms.date: 01/16/2025
ms.author: alkohli 
ms.reviewer: kerimha 
---

# Migrate to Azure Local on same hardware

> Applies to: Azure Local 2311.2 and later; Windows Server 2022, Windows Server 2019, Windows Server 2016, Windows Server 2012 R2, Windows Server 2008 R2

[!INCLUDE [azure-local-banner-22h2](../includes/azure-local-banner-22h2.md)]

This topic describes how to migrate a Windows Server failover cluster to Azure Local using your existing machine hardware. This process installs the new operating system for Azure Local and retains your existing system settings and storage, and imports your VMs.

The following diagram depicts migrating your Windows Server cluster in-place using the same machine hardware. After shutting down your system, Azure Local is installed, storage is reattached, and your VMs are imported and made highly available (HA).

:::image type="content" source="media/migrate-cluster-same-hardware/migrate-cluster-same-hardware.png" alt-text="Migrate system to Azure Local on the same hardware" lightbox="media/migrate-cluster-same-hardware/migrate-cluster-same-hardware.png":::

To migrate your VMs to new Azure Local hardware, see [Migrate to Azure Local on new hardware](migrate-cluster-new-hardware.md).

> [!NOTE]
> Migrating stretched clusters is not covered in this article.

## Before you begin

There are several requirements and things to consider before you begin migration:

- All Windows PowerShell commands must be run As Administrator.

- You must have domain credentials with administrator permissions for Azure Local.

- Back up all VMs on your source system. Complete a crash-consistent backup of all applications and data and an application-consistent backup of all databases.  To back up to Azure, see [Use Azure Backup](/azure/backup/back-up-azure-stack-hyperconverged-infrastructure-virtual-machines).

- Collect inventory and configuration of all machines and system naming, network configuration, Cluster Shared Volume (CSV) resiliency and capacity, and quorum witness.

- Shut down your system VMs, offline CSVs, offline storage pools, and the system service.
- Disable the Cluster Name Object (CNO) (it's reused later) and:
    - Check that the CNO has Create Object rights to its own Organizational Unit (OU)
    - Check that the block inherited policy has been set on the OU
    - Set the required policy for Azure Local on this OU

## VM version support and update

The following table lists supported Windows Server OS versions and their VM versions for in-place migration on the same hardware.

Regardless of the OS version a VM may be running on, the minimum VM version supported for migration to Azure Local is version 5.0. So any VMs running at version 2.0, 3.0, or 4.0 on your Windows Server 2016 or later system must be updated to version 5.0 before migration.

|OS version|VM version|
|---|---|
|Windows Server 2008 SP1|2.0|
|Windows Server 2008 R2|3.0|
|Windows Server 2012|4.0|
|Windows Server 2012 R2|5.0|
|Windows Server 2016|8.0|
|Windows Server 2019|9.0|
|Windows Server 2022| |
|Azure Local|9.0|

For VMs on Windows Server 2008 SP1, Windows Server 2008 R2-SP1, and Windows 2012 systems, direct migration to Azure Local is not supported. In these cases, you have two options:

- Migrate these VMs to Windows Server 2012 R2 or later first, update the VM version, then begin the migration process.

- Use Robocopy to copy all VM VHDs to Azure Local. Then create new VMs and attach the copied VHDs to their respective VMs in Azure Local. This bypasses the VM version limitation for these older VMs.

## Updating the VM version

Use the following command to show all VM versions on a single node:

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

## Updating the machines and system

Migration consists of running Azure Local setup on your Windows Server deployment for a clean OS install with your VMs and storage intact. This replaces the current operating system with Azure Local. For detailed information, see [Deploy the OS for Azure Local](../deploy/operating-system.md). Afterwards, you create a new Azure Local instance, reattach your storage and import the VMs over.

1. Shut down your existing system VMs, offline CSVs, offline storage pools, and the system service.

1. Go to the location where you downloaded the Azure Local bits, then run Azure Local setup on each Windows Server node.

1. During setup, select **Custom: Install the newer version of Azure Local only (Advanced)**. Repeat for each server.

1. Create the new Azure Local instance. You can use Windows Admin Center or Windows PowerShell for this task, as shown in the following sections.  

> [!IMPORTANT]
> Hyper-V virtual switch (`VMSwitch`) name must be the same name captured in the system configuration inventory. Make sure the virtual switch name used on the Azure Local instance matches the original source virtual switch name before you import the VMs.

> [!NOTE]
> You must register the Azure Local instance with Azure before you can create new VMs on it. For more information, see [Register with Azure](../deploy/register-with-azure.md).

### Using Windows Admin Center

If using Windows Admin Center to create the Azure Local instance, the Create Cluster wizard automatically installs all required roles and features on each machine.

For detailed information on how to create the system, see [Create an Azure Local instance using Windows Admin Center](../deploy/create-cluster.md).

> [!IMPORTANT]
> Skip step **4.1 Clean drives** in the Create system wizard. Otherwise you will delete your existing VMs and storage.

1. Start the Create Cluster wizard. When you get to **Step 4: Storage**:

1. Skip step **4.1 Clean drives**. Don't do this.

1. Step away from the wizard.

1. Open PowerShell, and run the following cmdlet to create the new `Storagesubsystem Object` ID, rediscover all storage enclosures, and assign SES drive numbers:

    ```powershell
    Enable-ClusterS2D -Verbose
    ```

    If migrating from Windows Server 2016, this also creates a new `ClusterperformanceHistory` ReFS volume and assigns it to the SDDC Cluster Resource Group.

    If migrating from Windows Server 2019, this also adds the existing `ClusterperformanceHistory` ReFS volume and assigns it to the SDDC Cluster Resource Group.

1. Go back to the wizard. In step **4.2 Verify drives**, verify that all drives are listed without warnings or errors.

1. Complete the wizard.

### Using Windows PowerShell

If using PowerShell to create the Azure Local instance, the following roles and features must be installed on each Azure Local machine using this cmdlet:

```powershell
Install-WindowsFeature -Name Hyper-V, Failover-Clustering, FS-Data-Deduplication, Bitlocker, Data-Center-Bridging, RSAT-AD-PowerShell -IncludeAllSubFeature -IncludeManagementTools -Verbose
```

For more information on how to create the system using PowerShell, see [Create an Azure Local instance using Windows PowerShell](../deploy/create-cluster-powershell.md).

> [!NOTE]
> Re-use the same name for the previously disabled Cluster Name Object.

1. Run the cmdlet to create the system:

    ```powershell
    New-cluster –name "systemname" –server Server01,Server02 –staticaddress xx.xx.xx.xx –nostorage
    ```

1. Run the cmdlet to create the new `Storagesubsystem Object` ID, rediscover all storage enclosures, and assign SES drive numbers:

    ```powershell
    Enable-ClusterS2D -Verbose
    ```

1. If migrating from Windows Server 2016, this also creates a new `ClusterperformanceHistory` ReFS volume and assigns it to the SDDC Cluster Resource Group.

    > [!NOTE]
    > If a storage pool shows Minority Disk errors (viewable in Cluster Manager), re-run the `Enable-ClusterS2D -verbose` cmdlet.

1. Using Cluster Manager, enable every CSV except the `ClusterperformanceHistory` volume, which is a ReFS volume (make sure this is not an ReFS CSV).

1. If migrating from Windows Server 2019, re-run the `Enable-ClusterS2D -verbose` cmdlet. This associates the `ClusterperformanceHistory` ReFS volume with the SDDC Cluster Resource Group.

1. Determine your current storage pool name and version by running the cmdlet:

    ```powershell
    Get-StoragePool | ? IsPrimordial -eq $false | ft FriendlyName,Version
    ```

1. Now determine your new storage pool name and version:

    ```powershell
    Get-StoragePool | ? IsPrimordial -eq $false | ft FriendlyName,Version
    ```

1. Create the quorum witness. For information on how, see [Set up a system witness](../manage/witness.md).

1. Verify that storage repair jobs are completed using the cmdlet:

    ```powershell
    Get-StorageJob
    ```

    > [!NOTE]
    >This could take considerable time depending on the number of VMs running during the upgrade.

1. Verify that all disks are healthy:

    ```powershell
    Get-VirtualDisk
    ```

1. Determine the machine version, which displays `ClusterFunctionalLevel` and `ClusterUpgradeVersion`. Run the cmdlet to get this:

    ```powershell
    Get-ClusterNodeSupportedVersion
    ```

    > [!NOTE]
    > `ClusterFunctionalLevel` is automatically set to `10` and does not require updating due to new the operating system and cluster creation.

1. Update your storage pool as follows:

    ```powershell
    Get-StoragePool | Update-StoragePool
    ```

## ReFS volumes

If migrating from Windows Server 2016, Resilient File System (ReFS) volumes are supported, but such volumes don't benefit from performance enhancements in Azure Local from using mirror-accelerated parity (MAP) volumes. This enhancement requires a new ReFS volume to be created using the PowerShell `New-Volume` cmdlet.

For Windows Server 2016 MAP volumes, ReFS compaction wasn't available, so re-attaching these volumes is OK but will be less performant compared to creating a new MAP volume in an Azure Local instance.

## Import the VMs

A best practice is to create at least one Cluster Shared Volume (CSV) per machine to enable an even balance of VMs for each CSV owner for increased resiliency, performance, and scale of VM workloads. By default, this balance occurs automatically every five minutes and needs to be considered when using Robocopy between source and destination machines to ensure source and destination CSV owners match to provide the most optimal transfer path and speed.

Perform the following steps on your Azure Local instance to import the VMs, make them highly available, and start them:

1. Run the cmdlet to show all CSV owner nodes:

    ```powershell
    Get-ClusterSharedVolume
    ```

1. For each machine, go to `C:\Clusterstorage\Volume` and set the path for all VMs - for example `C:\Clusterstorage\volume01`.

1. Run the cmdlet on each CSV owner machine to display the path to all VM VMCX files per volume prior to VM import. Modify the path to match your environment:

    ```powershell
    Get-ChildItem -Path "C:\Clusterstorage\Volume01\*.vmcx" -Recurse
    ```

1. Run the cmdlet for each machine to import and register all VMs and make them highly available on each CSV owner node. This ensures an even distribution of VMs for optimal processor and memory allocation:

    ```powershell
    Get-ChildItem -Path "C:\Clusterstorage\Volume01\*.vmcx" -Recurse | Import-VM -Register | Get-VM | Add-ClusterVirtualMachineRole
    ```

1. Start each destination VM on each machine:

    ```powershell
    Start-VM -Name
    ```

1. Login and verify that all VMs are running and that all your apps and data are there:

    ```powershell
    Get-VM -ComputerName Server01 | Where-Object {$_.State -eq 'Running'}
    ```

1. Lastly, update your VMs to the latest Azure Local version to take advantage of all the advancements:

    ```powershell
    Get-VM | Update-VMVersion -Force
    ```

## Next steps

- Validate the system after migration. See [Validate an Azure Local instance](../deploy/validate.md).
- To migrate Windows Server VMs to new Azure Local hardware, see [Migrate to Azure Local on new hardware](migrate-cluster-new-hardware.md).