--- 
title: Migrate Azure Stack HCI, version 23H2 using Azure PowerShell (preview) 
description: Learn how to migrate Azure Stack HCI, version 23H2 using Azure PowerShell (preview).
author: alkohli
ms.topic: how-to
ms.date: 01/22/2024
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

With a new Azure Migrate project and associated appliance setup, initialize replication infrastructure, create and update replications of desired VMs, and migrate them to your desired target location using Azure PowerShell.

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
$SourceMachineType = <enter 'HyperV' or 'VMware'>

# Get VM(s) that match with $SourceMachineDisplayName, could return multiple

$DiscoveredServers = Get-AzMigrateDiscoveredServer `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -DisplayName $SourceMachineDisplayNameToMatch `  
    -ApplianceName $SourceApplianceName `
-SourceMachineType $SourceMachineType

### storage container ARM Id, i.e., "/subscriptions/XXX/resourceGroups/XXX/providers/Microsoft.AzureStackHCI/storageContainers/XXX"

$TargetStoragePathId = <storage_container_ARM_ID>
# target resource group ARM Id, i.e., "/subscriptions/XXX/resourceGroups/XXX"
$TargetResourceGroupId = <target_resource_group_ARM_ID>

# Assuming OS disk can be found at $DiscoverServer.Disk[0]:

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

## Next steps

- Alternatively, you can [migrate using Azure portal](migrate-via-powershell.md).
