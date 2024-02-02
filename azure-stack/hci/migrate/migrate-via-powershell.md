--- 
title: Migrate Azure Stack HCI, version 23H2 using Azure PowerShell (preview) 
description: Learn how to migrate Azure Stack HCI, version 23H2 using Azure PowerShell (preview).
author: alkohli
ms.topic: how-to
ms.date: 02/02/2024
ms.author: alkohli
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Migrate Azure Stack HCI, version 23H2 using Azure PowerShell (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how to migrate Azure Stack HCI, version 23H2 using Azure PowerShell.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, you should complete the following tasks:

1. Complete the following tutorials:
    - [Tutorial: Discover VMware VMs with Server Assessment](/azure/migrate/tutorial-discover-vmware) to prepare Azure for migration.
    - [Tutorial: Assess VMware VMs for migration to Azure VMs](/azure/migrate/tutorial-assess-vmware-azure-vm) before migrating them to Azure.

1. Install the [Azure PowerShell Az module](/powershell/azure/install-azure-powershell).

1. Verify the Azure Migrate PowerShell module is installed. Azure Migrate PowerShell is available as part of the Azure PowerShell Az module. Run the following command to check if Azure Migrate PowerShell is installed on your computer:

    ```azurepowershell
    Get-InstalledModule -Name Az.Migrate
    ```

1. Sign in to your Azure subscription using the following cmdlet:

    ```azurepowershell
    Connect-AzAccount
    ```

1. Select your Azure subscription.
Use the `Get-AzSubscription` cmdlet to get the list of Azure subscriptions you have access to. Select the Azure subscription that has your Azure Migrate project to work with using the `Set-AzContext` cmdlet as follows:

    ```azurepowershell
    Set-AzContext -SubscriptionId 00000000-0000-0000-0000-000000000000
    ```

## Initialize, replicate, and migrate

With a new Azure Migrate project and associated source and target appliance setup, initialize replication infrastructure, create and update replications of desired VMs, and migrate them to your desired target location using Azure PowerShell.

### Retrieve discovered VMs

Retrieve discovered VMs in the Azure Migrate project using the following cmdlet:

```azurepowershell
Get-AzMigrateDiscoveredServer
```

**Example 1**: Get all Hyper-V VMs discovered by an Azure Migrate appliance in an Azure Migrate project:

```azurepowershell
$DiscoveredServers = Get-AzMigrateDiscoveredServer `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -ApplianceName $SourceApplianceName `
    -SourceMachineType 'HyperV'
Write-Output $DiscoveredServers
```

**Example 2**: List Hyper-V VMs and filter by the word `test` in their display names:

```azurepowershell
Get-AzMigrateDiscoveredServer `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -DisplayName 'test' `
    -SourceMachineType 'VMware'
    dotnetcli
```

> [!NOTE]
> `-SourceMachineType` defaults to VMware, so always specify `HyperV` for the HyperVToAzStackHCI scenario and optionally specify `VMware` for the VMwareToAzStackHCI scenario.

### Retrieve replication fabrics

Run the following cmdlet to retrieve replication fabrics:

```azurepowershell
Get-AzMigrateHCIReplicationFabric
```

Here is an example script to get the fabrics in a resource group:

```azurepowershell
$Fabrics = Get-AzMigrateHCIReplicationFabric `
-ResourceGroupName $ResourceGroupName
Write-Output $Fabrics
```

### Initialize the replication infrastructure

Run the following cmdlet to initialize the replication infrastructure:

```azurepowershell
Initialize-AzMigrateHCIReplicationInfrastructure
```

**Option 1**: Initialize replication infrastructure with the default cache storage account:

```powershell
Initialize-AzMigrateHCIReplicationInfrastructure `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -SourceApplianceName $SourceApplianceName `
    -TargetApplianceName $TargetApplianceName
```

**Option 2**: Initialize replication infrastructure with custom-created cache storage account.

First create a storage account and then get the custom-created storage account:

```azurepowershell
$CustomStorageAccountName = <storage_account_name>
$CustomStorageAccount = Get-AzStorageAccount `
    -ResourceGroupName <resource_group_for_custom_storage_account> `
-Name $CustomStorageAccountName
```

Next, initialize replication infrastructure with custom-created storage account:

```powershell
Initialize-AzMigrateHCIReplicationInfrastructure `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -CacheStorageAccountId $CustomStorageAccount.Id `
    -SourceApplianceName $SourceApplianceName `
    -TargetApplianceName $TargetApplianceName
```

### (Optional) Verify the cache storage account

Verify the creation of the cache storage account if using the default. See the script output from previous step.

```azurepowershell
Get-AzStorageAccount
```

**Example**:

```azurepowershell
Get-AzStorageAccount `
    -ResourceGroupName $ResourceGroupName `
    -Name <default_storage_account_name_from_previous_step>
```

### Replicate a VM

Run the following command to replicate a VM and create a protected item:

```azurepowershell
New-AzMigrateHCIServerReplication
```

**Example**:

```azurepowershell
$SourceApplianceName = <source_appliance_name> 
$SourceMachineDisplayNameToMatch = <source_machine_display_name_to match_and_replicate>
$SourceMachineType = <'HyperV' or 'VMware'>

# Get VM(s) that match $SourceMachineDisplayName. Could return multiple items.

$DiscoveredServers = Get-AzMigrateDiscoveredServer `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -DisplayName $SourceMachineDisplayNameToMatch `  
    -ApplianceName $SourceApplianceName `
-SourceMachineType $SourceMachineType

### Storage container ARM ID - for example: "/subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.AzureStackHCI/storageContainers/XXX"

$TargetStoragePathId = <storage_container_ARM_ID>

$TargetResourceGroupId = <target_resource_group_ARM_ID>

# Assuming the OS disk can be found at $DiscoverServer.Disk[0]:

foreach ($DiscoveredServer in $DiscoveredServers)
{
    $TargetVMName = <target_VM_name>
    $ReplicationJob = New-AzMigrateHCIServerReplication `  
        -MachineId $DiscoveredServer.Id `
    	  -OSDiskID $DiscoveredServer.Disk[0].InstanceId `
    	  -TargetStoragePathId $TargetStoragePathId `
        -TargetVirtualSwitch $TargetVirtualSwitchId `
    	  -TargetResourceGroupId $TargetResourceGroupId `
        -TargetVMName $TargetVMName
    Write-Output $ReplicationJob.Property.State 
}
```

> [!NOTE]
> You can also try a different syntax that uses `-DiskToInclude` and `-NicToInclude` commands for better control of the OS and data disks and network interface to include. See sections "Create a local disk mapping object" and "Create a NIC mapping PS object" for specific usage. See also section "Retrieve replication jobs" for `$ReplicationJob` command usage.

### Create a local disk mapping object

Create a local disk mapping PS object using the `New-AzMigrateHCIDiskMappingObject` cmdlet. You can store multiple such objects in a list using `@()`.

**Example**

```azurepowershell
$diskMapping = New-AzMigrateHCIDiskMappingObject `
-DiskID $DiscoveredServer.Disk[?].InstanceId `
-IsOSDisk <'true' or 'false'> `
-IsDynamic <'true' or 'false'> `
-Size <target_disk_size> `
-Format <'VHD' or 'VHDX'>
```

### Create a local NIC mapping object

Create a local NIC mapping PS object using the `New-AzMigrateHCINicMappingObject`. You can store multiple such objects in a list using `@()`.

**Example**

```azurepowershell
# Target virtual switch ARM ID - for example: "/subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.AzureStackHCI/virtualnetworks/XXX"

$TargetVirtualSwitchId = <target_virtual_network_ARM_ID>

$nicMapping = New-AzMigrateHCINicMappingObject `
-NicID $DiscoveredServer.NetworkAdapter[?].NicId `
-TargetVirtualSwitchId $TargetVirtualSwitchId `
-CreateAtTarget <'true' or 'false'>
```

### Retrieve replication jobs

Use the `Get-AzMigrateHCIJob` cmdlet to retrieve jobs to create, update, migrate, and remove replications.

**Example**

```azurepowershell
$ReplicationJob = Get-AzMigrateHCIJob `
-InputObject $ReplicationJob
Write-Host $ReplicationJob.Property.State
```

### Retrieve (get) protected item

Use the `Get-AzMigrateHCIServerReplication` cmdlet to retrieve (get) protected item.

**Example**

```azurepowershell
$ProtectedItem = Get-AzMigrateHCIServerReplication `
-DiscoveredMachineId $DiscoveredServer.Id
```

### Update a replication protected item

Use the `Set-AzMigrateHCIServerReplication` cmdlet to update a replication protected item.

**Example**

```azurepowershell
$SetReplicationJob = Set-AzMigrateHCIServerReplication`
    -TargetObjectID $ProtectedItem.Id `
    -IsDynamicMemoryEnabled <'true' or 'false'>
Write-Output $SetReplicationJob.State
```

### Migrate a replication (planned failover)

Use the `Start-AzMigrateHCIServerMigration` cmdlet to migrate a replication as part of planned failover.

**Example**

```azurepowershell
$ProtectedItem = Get-AzMigrateHCIServerReplication -InputObject $ProtectedItem
$MigrationJob = Start-AzMigrateHCIServerMigration `
-InputObject $ProtectedItem `
-TurnOffSourceServer
Write-Output $MigrationJob.Property.State
```

### Complete migration (remove a protected item)

Use the `Remove-AzMigrateHCIServerReplication` cmdlet to remove a protected item and complete migration.

**Example**

```azurepowershell
$ProtectedItem = Get-AzMigrateHCIServerReplication -InputObject $ProtectedItem
$RemoveJob = Remove-AzMigrateHCIServerReplication `
    -InputObject $ProtectedItem `
-ForceRemove <'true' or 'false'>
Write-Output $RemoveJob.Property.State
```

## PS command summary

The following are *existing* supported commands for the scenarios in this article:

- `Get-AzMigrateProject`
- `Get-AzMigrateDiscoveredServer`

Non `-AzMigrateHCI` commands (ones that start with `-AzMigrate` instead of `-AzMigrateHCI`) are intended for Azure Migrate project scenarios, which could return unexpected results when used for the scenario(s) in this article.

The following are *new* supported PS commands for the scenarios in this article:

- `Get-AzMigrateHCIJob`
- `Get-AzMigrateHCIReplicationFabric`
- `Get-AzMigrateHCIServerReplication`
- `Initialize-AzMigrateHCIReplicationInfrastructure`
- `New-AzMigrateHCIDiskMappingObject`
- `New-AzMigrateHCINicMappingObject`
- `New-AzMigrateHCIServerReplication`
- `Remove-AzMigrateHCIServerReplication`
- `Set-AzMigrateHCIServerReplication`
- `Start-AzMigrateHCIServerMigration`


## Next steps

- Alternatively, you can [migrate using Azure portal](migrate-via-powershell.md).
