--- 
title: Migrate VMs to Azure Local with Azure Migrate using PowerShell
description: Learn how to migrate VMs to Azure Local with Azure Migrate using PowerShell.
author: alkohli
ms.topic: how-to
ms.date: 08/05/2025
ms.author: alkohli
---

# Migrate VMs to Azure Local with Azure Migrate using PowerShell

This article describes how to migrate VMs to Azure Local with Azure Migrate using PowerShell.

## Prerequisites

Before you begin, you should complete the following tasks:

1. Complete the following prerequisites for the Azure Migrate project:
    - For a Hyper-V source environment, complete the [Hyper-V prerequisites](migrate-hyperv-prerequisites.md) and [configure the source and target appliances](migrate-hyperv-replicate.md#step-1-create-and-configure-the-source-appliance).
    - For a VMware source environment, complete the [VMware prerequisites](migrate-vmware-prerequisites.md) and [configure the source and target appliances](migrate-vmware-replicate.md#step-1-create-and-configure-the-source-vmware-appliance).

2. Install the [Azure PowerShell Az module](/powershell/azure/install-azure-powershell).

<!-- Update version to 2.X.X  in this paragraph-->
3. Verify the Azure Migrate PowerShell module is installed **and version is 2.8.0 or later**. Azure Migrate PowerShell is available as part of the Azure PowerShell Az module. Run the following command to check if Azure Migrate PowerShell is installed on your computer and verify the version is 2.8.0 or later:  

    ```powershell
    Get-InstalledModule -Name Az.Migrate
    ```

    To update the Azure Migrate PowerShell module to the latest version, run the following command and ensure the updated module is imported into your PowerShell session with the `Import-Module` cmdlet:

    ```powershell 
    Update-Module -Name Az.Migrate
    ```

4. Sign in to your Azure subscription using the following cmdlet:

    ```powershell
    Connect-AzAccount
    ```

5. Select your Azure subscription.
Use the `Get-AzSubscription` cmdlet to get the list of Azure subscriptions you have access to. Select the Azure subscription that hosts your Azure Migrate project using the `Set-AzContext` cmdlet as follows:

    ```powershell
    Set-AzContext -SubscriptionId "00000000-0000-0000-0000-000000000000"
    ```

You can view the full list of Azure Migrate PowerShell cmdlets by visiting the [Azure Migrate PowerShell reference](/powershell/module/az.migrate) or by running command `Get-Command -Module Az.Migrate`.

## Retrieve discovered VMs

You can retrieve the discovered VMs in your Azure Migrate project using the `Get-AzMigrateDiscoveredServer` cmdlet. This cmdlet retrieves the list of VMs discovered by the source appliance in your Azure Migrate project. SourceMachineType can be either `HyperV` or `VMware`, depending on your source VM environment.
For more information, see the `Get-AzMigrateDiscoveredServer`](/powershell/module/az.migrate/get-azmigratediscoveredserver).

**Example 1**: Get all VMs discovered by an Azure Migrate source appliance in an Azure Migrate project:

```powershell
$DiscoveredServers = Get-AzMigrateDiscoveredServer `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -SourceMachineType <'HyperV' or 'VMware'> 
    
Write-Output $DiscoveredServers | Format-List *
```

**Example 2**: List VMs and filter by source VM display names that contain a specific string (e.g., 'test'):

```powershell
$DiscoveredServers = Get-AzMigrateDiscoveredServer `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -DisplayName 'test' `
    -SourceMachineType <'HyperV' or 'VMware'> 

Write-Output $DiscoveredServers | Format-List *
```

## Initialize VM replications

You can initialize the replication infrastructure for your Azure Migrate project using the `Initialize-AzMigrateLocalReplicationInfrastructure` cmdlet. This cmdlet sets up the necessary infrastructure and metadata storage account needed to eventually replicate VMs from the source appliance to the target appliance. Running this cmdlet multiple times will not cause any issues, as it checks if the replication infrastructure is already initialized.
For more information, see the `Initialize-AzMigrateLocalReplicationInfrastructure`](/powershell/module/az.migrate/initialize-azmigratelocalreplicationinfrastructure).

You can use a default created storage account or a custom-created storage account that will store the replication metadata. You will need the source and target appliance names from the Azure Portal by going to your Azure Migrate project, then navigating to **Appliances > Registered appliances**.

:::image type="content" source="./media/migrate-via-powershell/migrate-appliances.png" alt-text="Screenshot showing Appliances in Azure Migrate project page." lightbox="./media/migrate-via-powershell/migrate-appliances.png":::

**Option 1**: Initialize replication infrastructure with the default storage account:

```powershell
Initialize-AzMigrateLocalReplicationInfrastructure `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -SourceApplianceName $SourceApplianceName `
    -TargetApplianceName $TargetApplianceName
```

**Option 2**: Initialize replication infrastructure with custom-created storage account.

First create a storage account and then get the custom-created storage account:

```powershell
$CustomStorageAccountName = <storage_account_name>
$ResourceGroupName = <resource_group_for_custom_storage_account>
$CustomStorageAccount = Get-AzStorageAccount `
    -ResourceGroupName $ResourceGroupName `
    -Name $CustomStorageAccountName
```

Next, initialize replication infrastructure with custom-created storage account:

```powershell
Initialize-AzMigrateLocalReplicationInfrastructure `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -CacheStorageAccountId $CustomStorageAccount.Id `
    -SourceApplianceName $SourceApplianceName `
    -TargetApplianceName $TargetApplianceName
```

### (Optional) Verify the storage account

Verify the creation of the storage account if using the default storage account with `Get-AzStorageAccount` cmdlet. If you used a custom storage account, you can skip this step as you already have the storage account information.

**Example**:

```powershell
$StorageAccountName = <default_storage_account_name_from_previous_step>
Get-AzStorageAccount `
    -ResourceGroupName $ResourceGroupName `
    -Name $StorageAccountName
```

## Replicate a VM

You can replicate a VM using the `New-AzMigrateLocalServerReplication` cmdlet. This cmdlet allows you to create a replication job for a discovered VM.
You can specify the target logical network, storage path, resource group, VM name, and target VM settings like OS disk, CPU, memory, and more. For more information, see the [`New-AzMigrateLocalServerReplication`](/powershell/module/az.migrate/new-azmigratelocalserverreplication) cmdlet.

To further customize the replication job, you can define local disk and NIC mappings ahead of time using `New-AzMigrateLocalDiskMappingObject` and `New-AzMigrateLocalNicMappingObject` (see **Create a local disk mapping** and **Create a local NIC mapping object** sections). These allow you to customize the disks and network interfaces are included during replication.


## (Option 1) Start Replication without disk and NIC mapping

```powershell

# Get VM(s) that match $SourceMachineDisplayNameToMatch. Could return multiple items.

$DiscoveredServers = Get-AzMigrateDiscoveredServer `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -DisplayName $SourceMachineDisplayNameToMatch `
    -SourceMachineType $SourceMachineType

# Storage Path ARM ID - for example: "/subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.AzureStackHCI/storageContainers/XXX"
$TargetStoragePathId = <storage_path_ARM_ID>

# Target virtual switch ARM ID - for example: "/subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.AzureStackHCI/logicalnetworks/XXX"
$TargetVirtualSwitchId = <target_virtual_network_ARM_ID>

# Migrated VM Target Resource Group ARM ID - for example: "/subscriptions/XXX/resourceGroups/XXX"
$TargetResourceGroupId = <target_resource_group_ARM_ID>

# Source Appliance Name - for example: "src-appliance"
$SourceApplianceName = <source_appliance_name>

# Target Appliance Name - for example: "tgt-appliance"
$TargetApplianceName = <target_appliance_name>

# Assuming the OS disk can be found at $DiscoverServer.Disk[0], the first disk in the discovered server's disk list is typically the OS disk.
# You can specify the target VM name to be the same as the source VM (assuming source VM name is valid for Azure Local VM names) by using $DiscoveredServer.DisplayName.
# You can also specify compute settings like CPU, memory, and more using parameters like `-TargetVMCPUCore`, '-IsDynamicMemoryEnabled', and '-TargetVMRam'.
# This will replicate all source VM disks by default.
# Use Uuid for VMware disks or InstanceId for Hyper-V disks.


foreach ($DiscoveredServer in $DiscoveredServers)
{
    Write-Output "Create replication for $($DiscoveredServer.DisplayName)" 
    $TargetVMName = <target_VM_name>
    $ReplicationJob = New-AzMigrateLocalServerReplication `  
        -MachineId $DiscoveredServer.Id `
        -OSDiskID $DiscoveredServer.Disk[0].Uuid `
        -TargetStoragePathId $TargetStoragePathId `
        -TargetVirtualSwitch $TargetVirtualSwitchId `
        -TargetResourceGroupId $TargetResourceGroupId `
        -TargetVMName $TargetVMName `
        -SourceApplianceName $SourceApplianceName `
        -TargetApplianceName $TargetApplianceName
    Write-Output $ReplicationJob.Property.State 
}
```

## (Option 2) Start Replication with disk and NIC mapping

### Create a local disk mapping object

Create a local disk mapping PS object using the `New-AzMigrateLocalDiskMappingObject` cmdlet. You can store multiple such objects in a list using `@()`.
You can customize the disk mapping object with parameters like `DiskID`, `IsOSDisk`, `IsDynamic`, `Format`, and `PhysicalSectorSize`. 
For more information, see the [`New-AzMigrateLocalDiskMappingObject`](/powershell/module/az.migrate/new-azmigratelocaldiskmappingobject) cmdlet.

>[!NOTE]
> If you are going to use the `-DiskToInclude` parameter in the `New-AzMigrateLocalServerReplication` cmdlet, you must create a local disk mapping object for **each** disk you want to include in the replication job.

**Example**

```powershell
# Use Uuid for VMware disks or InstanceId for Hyper-V disks
$DiskMappings = @()
$DiskMappings += New-AzMigrateLocalDiskMappingObject `
    -DiskID $DiscoveredServer.Disk[0].Uuid ` 
    -IsOSDisk 'true' `
    -IsDynamic 'false' `
    -Size 64 `
    -Format 'VHDX' `
    -PhysicalSectorSize 512

$DiskMappings += New-AzMigrateLocalDiskMappingObject `
    -DiskID $DiscoveredServer.Disk[1].Uuid `
    -IsOSDisk 'false' `
    -IsDynamic 'false' `
    -Size 128 `
    -Format 'VHDX' `
    -PhysicalSectorSize 4096

    .
    .
    . # Add more disks as needed

# Display the disk mappings
$DiskMappings | Format-List *
```

### Create a local NIC mapping object

Create a local NIC mapping PS object using the `New-AzMigrateLocalNicMappingObject`. You can store multiple such objects in a list using `@()`. 
For more information, see the [`New-AzMigrateLocalNicMappingObject`](/powershell/module/az.migrate/new-azmigratelocalnicmappingobject) cmdlet.

**Example**

```powershell
# Target virtual switch ARM ID - for example: "/subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.AzureStackHCI/virtualnetworks/XXX"

$TargetVirtualSwitchId = <target_virtual_network_ARM_ID>

$NicMappings = @()
$NicMappings += New-AzMigrateLocalNicMappingObject `
    -NicID $DiscoveredServer.NetworkAdapter[0].NicId `
    -TargetVirtualSwitchId $TargetVirtualSwitchId `
    -CreateAtTarget 'true'

$NicMappings += New-AzMigrateLocalNicMappingObject `
    -NicID $DiscoveredServer.NetworkAdapter[1].NicId `
    -TargetVirtualSwitchId $TargetVirtualSwitchId `
    -CreateAtTarget 'false'

    .
    .
    . # Add more NICs as needed

# Display the NIC mappings
$NicMappings | Format-List *
```


**Start Replication with Disk and NIC Mappings**
> [!NOTE]
> If you use the `-DiskToInclude` and `-NicToInclude` parameters, you must create both local disk and NIC mapping objects as shown in the **Create a Local Disk Mapping** and **Create a local NIC mapping object** sections. You cannot use one without the other.
> 
```powershell
# Get VM(s) that match $SourceMachineDisplayNameToMatch. Could return multiple items.
$DiscoveredServers = Get-AzMigrateDiscoveredServer `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -DisplayName $SourceMachineDisplayNameToMatch `
    -SourceMachineType $SourceMachineType

# Storage container ARM ID - for example: "/subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.AzureStackHCI/storageContainers/XXX"
$TargetStoragePathId = <storage_container_ARM_ID>
# Migrated VM Target Resource Group ARM ID - for example: "/subscriptions/XXX/resourceGroups/XXX"
$TargetResourceGroupId = <target_resource_group_ARM_ID>
# Target virtual switch ARM ID - for example: "/subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.AzureStackHCI/logicalnetworks/XXX"
$TargetVirtualSwitchId = <target_virtual_network_ARM_ID>

# Source Appliance Name - for example: "src-appliance"
$SourceApplianceName = <source_appliance_name>

# Target Appliance Name - for example: "tgt-appliance"
$TargetApplianceName = <target_appliance_name>


# Create disk mapping object for each disk you want to include in the replication job.
# Use Uuid for VMware disks or InstanceId for Hyper-V disks
$DiskMappings = @()
$DiskMappings += New-AzMigrateLocalDiskMappingObject `
    -DiskID $DiscoveredServer.Disk[0].Uuid ` 
    -IsOSDisk 'true' `
    -IsDynamic 'false' `
    -Size 64 `
    -Format 'VHD' `
    -PhysicalSectorSize 512



# Create NIC mappings object
$NicMappings = @()
$NicMappings += New-AzMigrateLocalNicMappingObject `
    -NicID $DiscoveredServer.NetworkAdapter[0].NicId `
    -TargetVirtualSwitchId $TargetVirtualSwitchId `
    -CreateAtTarget 'true'

foreach ($DiscoveredServer in $DiscoveredServers)
{
    Write-Output "Create replication for $($DiscoveredServer.DisplayName)" 
    $TargetVMName = <target_VM_name>
    $ReplicationJob = New-AzMigrateLocalServerReplication `
        -MachineId $DiscoveredServer.Id `
        -TargetStoragePathId $TargetStoragePathId `
        -TargetResourceGroupId $TargetResourceGroupId `
        -TargetVMName $TargetVMName `
        -DiskToInclude @($DiskMappings) `
        -NicToInclude @($NicMappings) `
        -SourceApplianceName $SourceApplianceName `
        -TargetApplianceName $TargetApplianceName 

    Write-Output $ReplicationJob.Property.State 
}
```


### Retrieve replication jobs

Use the `Get-AzMigrateLocalJob` cmdlet to retrieve jobs about creating, updating, migrating, and removing replications. For more information, see the [`Get-AzMigrateLocalJob`](/powershell/module/az.migrate/get-azmigratelocaljob) cmdlet.

**Example**

```powershell
$ReplicationJob = Get-AzMigrateLocalJob `
    -InputObject $ReplicationJob
$ReplicationJob.Property | Format-List *
```


To retrieve more information about any error messages or job details, you can examine the `$ReplicationJob.Property` output and specifically look for the `Error` property, which contains detailed error messages if any issues occurred during the replication job.

```powershell
$ReplicationJob.Property | Format-List *
$ReplicationJob.Property.Error | Format-List *
```


### Retrieve (get) a replication protected item

Use the `Get-AzMigrateLocalServerReplication` cmdlet to retrieve (get) protected item. For more information, see the [`Get-AzMigrateLocalServerReplication`](/powershell/module/az.migrate/get-azmigratelocalserverreplication) cmdlet.

**Example**

```powershell
$ProtectedItem = Get-AzMigrateLocalServerReplication `
    -DiscoveredMachineId $DiscoveredServer.Id
$ProtectedItem.Property | Format-List *
```


### Update a replication protected item

Use the `Set-AzMigrateLocalServerReplication` cmdlet to update a replication protected item.
For more information, see the [`Set-AzMigrateLocalServerReplication`](/powershell/module/az.migrate/set-azmigratelocalserverreplication) cmdlet.

**Example**

```powershell
$SetReplicationJob = Set-AzMigrateLocalServerReplication`
    -TargetObjectID $ProtectedItem.Id `
    -IsDynamicMemoryEnabled <'true' or 'false'>
$SerReplicationJob.Property | Format-List *
```

### (Optional) Delete a replicating protected item
Use the `Remove-AzMigrateLocalServerReplication` cmdlet to delete a replicating protected item. This is useful if you want to stop a VM from replicating or if you want to start fresh with a new replication job if protected item became corrupted.
For more information, see the [`Remove-AzMigrateLocalServerReplication`](/powershell/module/az.migrate/remove-azmigratelocalserverreplication) cmdlet.

**Example**
```powershell
Remove-AzMigrateLocalServerReplication `
    -TargetObjectID $ProtectedItem.Id `
Write-Output "Protected item removed successfully."
```

## Migrate a VM 

Use the `Start-AzMigrateLocalServerMigration` cmdlet to migrate a replication as part of planned failover.
You can use the `-TurnOffSourceServer` parameter to turn off the source VM after migration. This is useful for scenarios where you want to ensure that the source VM is no longer running after migration.
For more information, see the [`Start-AzMigrateLocalServerMigration`](/powershell/module/az.migrate/start-azmigratelocalservermigration) cmdlet.

> [!IMPORTANT]
> Before starting migration, verify replication succeeded by checking `$ProtectedItem.Property.AllowedJob` and ensuring it contains `PlannedFailover`.
> Additionally, you can verify the following conditions:
> 
> - `$ProtectedItem.Property.ProvisioningState` status must be `Succeeded`
> - `$ProtectedItem.Property.ProtectionState` status must be `Protected`.

If the above conditions are met, you can proceed with migration.

**Migration Example**

```powershell
$ProtectedItem = Get-AzMigrateLocalServerReplication -InputObject $ProtectedItem # Retrieve/update the latest protected item information
$MigrationJob = Start-AzMigrateLocalServerMigration `
    -InputObject $ProtectedItem `
    -TurnOffSourceServer
$MigrationJob.Property | Format-List *
```

## Complete migration (remove a protected item)

Use the `Remove-AzMigrateLocalServerReplication` cmdlet to remove a protected item to complete migration. 
Do not use this cmdlet until you have verified that the migration is successful and you no longer need the protected item in Azure Migrate.
For more information, see the [`Remove-AzMigrateLocalServerReplication`](/powershell/module/az.migrate/remove-azmigratelocalserverreplication) cmdlet.

**Example**

```powershell
$ProtectedItem = Get-AzMigrateLocalServerReplication -InputObject 
$RemoveJob = Remove-AzMigrateLocalServerReplication `
    -InputObject $ProtectedItem
$RemoveJob.Property | Format-List *
```



## Next steps

- Alternatively, you can [replicate and migrate using Azure portal](migration-options-overview.md).