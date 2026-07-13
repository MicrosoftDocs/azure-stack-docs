--- 
title: Migrate VMs to Azure Local with Azure Migrate using PowerShell
description: Learn how to migrate VMs to Azure Local with Azure Migrate using PowerShell.
author: ronmiab
ms.topic: how-to
ms.date: 07/10/2026
ms.author: robess
ms.subservice: hyperconverged
---

# Migrate VMs to Azure Local with Azure Migrate using PowerShell, Azure CLI (Preview), or Terraform (Preview)

[!INCLUDE [hci-applies-to-2503](../includes/hci-applies-to-2503.md)]

This article describes how to migrate virtual machines (VMs) to Azure Local with Azure Migrate using PowerShell, Azure CLI (Preview), or Terraform (Preview). This article applies to migration of Hyper-V VMs (Preview) and VMware VMs.


## Prerequisites

Before you begin, ensure that the following prerequisites are met:

1. Complete the following prerequisites for the Azure Migrate project:
    - For a Hyper-V source environment, complete the [Hyper-V prerequisites](migrate-hyperv-prerequisites.md) and [configure the source and target appliances](migrate-hyperv-replicate.md#step-1-create-and-configure-the-source-appliance).
    - For a VMware source environment, complete the [VMware prerequisites](migrate-vmware-prerequisites.md) and [configure the source and target appliances](migrate-vmware-replicate.md#step-1-create-and-configure-the-source-vmware-appliance).

2. An Azure subscription with **Contributor**, **Storage Contributor**, and **User Access Administrator** roles.

3. A configured Azure Migrate project with source appliance (VMware or Hyper-V) and target Azure Local appliance registered.

4. Arc Resource Bridge running on your Azure Local instance.

5. Network connectivity between the source and target environments.

# [PowerShell](#tab/powershell)

1. Install the [PowerShell Az module](/powershell/azure/install-azure-powershell). Ensure you are running [PowerShell version 7 or higher](/powershell/scripting/install/install-powershell).

<!-- Update version to 2.X.X in this paragraph-->
2. Verify the Azure Migrate PowerShell module is installed and **version is 2.9.0 or later**. Azure Migrate PowerShell is available as part of the PowerShell `Az` module. Run the following command to check if Azure Migrate PowerShell is installed on your computer and verify the version is 2.9.0 or later:

    ```powershell
    Get-InstalledModule -Name Az.Migrate
    ```

    To update the Azure Migrate PowerShell module to the latest version, run the following command and ensure the updated module is imported into your PowerShell session with the `Import-Module` cmdlet:

    ```powershell 
    Update-Module -Name Az.Migrate
    ```

# [Azure CLI (Preview)](#tab/azurecli)

1. Install [Azure CLI version 2.75.0 or later](/cli/azure/install-azure-cli).

2. Install the Azure CLI migrate extension by running the following command:

    ```azurecli
    az extension add --name migrate --allow-preview true
    ```

# [Terraform (Preview)](#tab/terraform)

1. Install [Terraform version 1.9 or later](https://developer.hashicorp.com/terraform/install).

1. Configure the [AzAPI provider](https://registry.terraform.io/providers/Azure/azapi/latest) (version 2.4 or later) and add the Azure Migrate module to your Terraform configuration:

    ```terraform
    terraform {
      required_version = ">= 1.9"

      required_providers {
        azapi = {
          source  = "Azure/azapi"
          version = "~> 2.4"
        }
      }
    }

    provider "azapi" {}

    module "migrate" {
      source  = "Azure/avm-ptn-azure-local-migrate/azurerm"
      version = "<version>" # Pin to the latest version from the Terraform Registry.

      # Set the operation_mode input for each migration step, as shown in the following sections.
    }
    ```

    Pin `version` to the latest release of the [Azure Migrate to Azure Local Terraform module](https://registry.terraform.io/modules/Azure/avm-ptn-azure-local-migrate/azurerm/latest). Each migration step is a separate module invocation that sets a different `operation_mode` value.

---

## Sign in and set subscription

# [PowerShell](#tab/powershell)

1. Sign in to your Azure subscription using the following cmdlet:

```powershell
Connect-AzAccount
```

2. Use the `Get-AzSubscription` cmdlet to get the list of Azure subscriptions you have access to. Select the Azure subscription that hosts your Azure Migrate project using the `Set-AzContext` cmdlet:

```powershell
Set-AzContext -SubscriptionId "00000000-0000-0000-0000-000000000000"
```

You can view the full list of Azure Migrate PowerShell cmdlets by visiting the [Azure Migrate PowerShell reference](/powershell/module/az.migrate) or by running the command:

```powershell
Get-Command -Module Az.Migrate
```

### Sample Azure Migrate PowerShell script

You can view a sample script that demonstrates how to use Azure Migrate PowerShell cmdlets to migrate VMs to Azure Local in the [Migrate VMs to Azure Local with Azure Migrate using PowerShell sample script](https://aka.ms/azlocal-migrate-ps-script).

# [Azure CLI (Preview)](#tab/azurecli)

Authenticate with your Azure account and set the subscription:

```azurecli
az login
az account set --subscription "<subscriptionId>"
```

# [Terraform (Preview)](#tab/terraform)

The AzAPI provider uses your Azure CLI sign-in for authentication. Sign in and set the subscription that hosts your Azure Migrate project:

```azurecli
az login
az account set --subscription "<subscriptionId>"
```

For more information, see the [AzAPI provider documentation](https://registry.terraform.io/providers/Azure/azapi/latest/docs).

---

## Retrieve discovered VMs

Retrieve the discovered VMs in your Azure Migrate project.

# [PowerShell](#tab/powershell)

Use the `Get-AzMigrateDiscoveredServer` cmdlet to retrieve the list of VMs discovered by the source appliance. `SourceMachineType` can be either `HyperV` or `VMware`, depending on your source VM environment.
For more information, see the [`Get-AzMigrateDiscoveredServer`](/powershell/module/az.migrate/get-azmigratediscoveredserver) cmdlet.

**Example 1**: Get all VMs discovered by an Azure Migrate source appliance in an Azure Migrate project:

```powershell
$DiscoveredServers = Get-AzMigrateDiscoveredServer `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -SourceMachineType <'HyperV' or 'VMware'> 
    
Write-Output $DiscoveredServers | Format-List *
```

**Example 2**: List VMs and filter by source VM display names that contain a specific string (like 'test'):

```powershell
$DiscoveredServers = Get-AzMigrateDiscoveredServer `
    -ProjectName $ProjectName `
    -ResourceGroupName $ResourceGroupName `
    -DisplayName 'test' `
    -SourceMachineType <'HyperV' or 'VMware'> 

Write-Output $DiscoveredServers | Format-List *
```

# [Azure CLI (Preview)](#tab/azurecli)

Use the `az migrate get-discovered-server` command to identify servers available for migration:

```azurecli
az migrate get-discovered-server \
    --project-name <projectName> \
    --resource-group <resourceGroup>
```

For more information, see the [`az migrate get-discovered-server`](/cli/azure/migrate#az-migrate-get-discovered-server) command.

# [Terraform (Preview)](#tab/terraform)

Use the `discover` operation mode to list the VMs discovered by the source appliance. Set `source_machine_type` to `VMware` or `HyperV` to match your source environment:

```terraform
module "discover" {
  source  = "Azure/avm-ptn-azure-local-migrate/azurerm"
  version = "<version>"

  name                = "discover"
  parent_id           = "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>"
  operation_mode      = "discover"
  project_name        = "<projectName>"
  source_machine_type = "VMware"
}
```

This operation is read-only. Its key outputs include:

- `discovered_servers`: A filtered list of discovered VMs. Each entry includes the machine name, IP addresses, operating system, boot type, and OS disk ID.
- `discovered_servers_count`: The number of discovered servers that have discovery data.
- `total_machines_count`: The total number of machines, including those without discovery data.

Use the source machine ID (`sdsArmId`) and OS disk ID from this output as the `machine_id` and `os_disk_id` inputs in the [Replicate a VM](#replicate-a-vm) step. For more information, see the [Azure Migrate to Azure Local Terraform module](https://registry.terraform.io/modules/Azure/avm-ptn-azure-local-migrate/azurerm/latest).

---

## Initialize replication infrastructure

Initialize the replication infrastructure for your Azure Migrate project. This sets up the infrastructure and metadata storage account needed to replicate VMs from the source appliance to the target appliance. You can safely run this command multiple times, it checks whether the replication infrastructure is already initialized before running again.

You can use a default or custom storage account to store the replication metadata. To find the source and target appliance names, go to your Azure Migrate project in the Azure portal, then select Appliances > Registered appliances.

:::image type="content" source="./media/migrate-via-powershell/migrate-appliances.png" alt-text="Screenshot showing Appliances in Azure Migrate project page." lightbox="./media/migrate-via-powershell/migrate-appliances.png":::

# [PowerShell](#tab/powershell)

For more information, see the [`Initialize-AzMigrateLocalReplicationInfrastructure`](/powershell/module/az.migrate/initialize-azmigratelocalreplicationinfrastructure) cmdlet.

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

Ensure that the storage account uses Standard tier and blob storage kind, these are the only supported types for Azure Migrate metadata storage accounts. Also ensure that Public network access is enabled on the storage account. If you disable public network access, replication fails.

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

```powershell
$StorageAccountName = <default_storage_account_name_from_previous_step>
Get-AzStorageAccount `
    -ResourceGroupName $ResourceGroupName `
    -Name $StorageAccountName
```

# [Azure CLI (Preview)](#tab/azurecli)

**Option 1**: Initialize replication infrastructure with the default storage account:

```azurecli
az migrate local replication init \
    --resource-group <resourceGroup> \
    --project-name <projectName> \
    --source-appliance-name <sourceAppliance> \
    --target-appliance-name <targetAppliance>
```

**Option 2**: Initialize replication infrastructure with a custom storage account by providing the storage account ARM ID using the `--cache-storage-account-id` parameter. The custom storage account only needs to be specified during the first initialization. Subsequent runs of the command detect the existing storage account and don't require it to be specified again:

```azurecli
az migrate local replication init \
    --resource-group <resourceGroup> \
    --project-name <projectName> \
    --source-appliance-name <sourceAppliance> \
    --target-appliance-name <targetAppliance> \
    --cache-storage-account-id "<storageAccountARMID>"
```

For more information, see the [`az migrate local replication init`](/cli/azure/migrate/local/replication#az-migrate-local-replication-init) command.

> [!NOTE]
> The storage account used for metadata must be **Standard Performance** tier and use Azure Blob storage. The storage account must also have **Public network access** enabled. If public network access is disabled, replication fails.

# [Terraform (Preview)](#tab/terraform)

Use the `initialize` operation mode to set up the replication vault, policy, extension, and cache storage account. Provide the source and target appliance names, and the module discovers the corresponding replication fabrics automatically. You can safely run this operation multiple times. If the infrastructure already exists, the module validates it instead of recreating it.

```terraform
module "initialize" {
  source  = "Azure/avm-ptn-azure-local-migrate/azurerm"
  version = "<version>"

  name                  = "initialize"
  parent_id             = "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>"
  operation_mode        = "initialize"
  project_name          = "<projectName>"
  source_machine_type   = "VMware"
  source_appliance_name = "<sourceAppliance>"
  target_appliance_name = "<targetAppliance>"
}
```

To use a custom cache storage account, set `cache_storage_account_id` to its ARM ID. The storage account must use the Standard performance tier and Azure Blob storage, with public network access enabled.

This operation's key outputs include:

- `replication_vault_id`: The replication vault ARM ID.
- `replication_policy_id`: The replication policy ARM ID.
- `replication_extension_id` and `replication_extension_name`: The replication extension ARM ID and name.
- `cache_storage_account_id` and `cache_storage_account_name`: The cache storage account.
- `source_fabric_id` and `target_fabric_id`: The resolved replication fabric ARM IDs.
- `replication_vault_identity`: The managed identity principal ID of the vault.

Later steps resolve these resources automatically from the project and appliance names, so you don't usually set them manually. The outputs are useful for verification and troubleshooting. For more information, see the [Azure Migrate to Azure Local Terraform module](https://registry.terraform.io/modules/Azure/avm-ptn-azure-local-migrate/azurerm/latest).

---

## Replicate a VM

Start replication for a discovered VM by specifying the target logical network, storage path, resource group, VM name, and other target VM settings.

# [PowerShell](#tab/powershell)

You can replicate a VM using the `New-AzMigrateLocalServerReplication` cmdlet. This cmdlet allows you to create a replication job for a discovered VM.
You can specify the target logical network, storage path, resource group, VM name, and target VM settings like OS disk, CPU, memory, and more. For more information, see the [`New-AzMigrateLocalServerReplication`](/powershell/module/az.migrate/new-azmigratelocalserverreplication) cmdlet.

To further customize the replication job, you can define local disk and NIC mappings ahead of time using `New-AzMigrateLocalDiskMappingObject` and `New-AzMigrateLocalNicMappingObject` (see **Create a local disk mapping** and **Create a local NIC mapping object** sections). These allow you to customize the disks and network interfaces are included during replication.


### (Option 1) Start Replication without disk and NIC mapping

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

### (Option 2) Start Replication with disk and NIC mapping

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


### Start Replication with disk and NIC mappings
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

# [Azure CLI (Preview)](#tab/azurecli)

Create a new replication for a selected machine by specifying the machine ID, storage path, resource group, VM name, source and target appliances, OS disk, and target virtual switch. You can use the output of `az migrate get-discovered-server` to get the machine ID and OS disk ID that correspond to the server you want to replicate.

```azurecli
az migrate local replication new \
    --machine-id "<machineARMID>" \
    --target-storage-path-id "<storagePathARMID>" \
    --target-resource-group-id "<resourceGroupARMID>" \
    --target-vm-name "<targetVMName>" \
    --source-appliance-name <sourceAppliance> \
    --target-appliance-name <targetAppliance> \
    --os-disk-id "<osDiskID>" \
    --target-virtual-switch-id "<logicalNetworkARMID>"
```

For more information, see the [`az migrate local replication new`](/cli/azure/migrate/local/replication#az-migrate-local-replication-new) command.

# [Terraform (Preview)](#tab/terraform)

Use the `replicate` operation mode to start replication for a discovered VM by creating a protected item in the replication vault.

### Default mode (single OS disk and NIC)

For a VM with a single OS disk and a single NIC, provide the source machine ID (`sdsArmId`) and OS disk ID from the `discover` output, along with the target settings:

```terraform
module "replicate" {
  source  = "Azure/avm-ptn-azure-local-migrate/azurerm"
  version = "<version>"

  name                = "replicate-vm"
  parent_id           = "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>"
  operation_mode      = "replicate"
  project_name        = "<projectName>"
  source_machine_type = "VMware"

  # Source VM and OS disk from the discover output.
  machine_id = "<machineARMID>"
  os_disk_id = "<osDiskID>"

  # Target VM configuration.
  target_vm_name           = "<targetVMName>"
  target_virtual_switch_id = "<logicalNetworkARMID>"
  target_resource_group_id = "<resourceGroupARMID>"
  target_storage_path_id   = "<storagePathARMID>"
  target_hci_cluster_id    = "<clusterARMID>"
  custom_location_id       = "<customLocationARMID>"

  # Appliance names.
  source_appliance_name = "<sourceAppliance>"
  target_appliance_name = "<targetAppliance>"
}
```

### Power user mode (multiple disks or NICs)

For a VM with multiple disks or NICs, use the `disks_to_include` and `nics_to_include` inputs instead of `os_disk_id` and `target_virtual_switch_id`. Keep the same common and target configuration as the default mode, and add the disk and NIC lists:

```terraform
module "replicate" {
  source  = "Azure/avm-ptn-azure-local-migrate/azurerm"
  version = "<version>"

  # Include the same common and target configuration as the default mode,
  # but omit os_disk_id and target_virtual_switch_id.

  disks_to_include = [
    {
      disk_id          = "<osDiskID>"
      disk_size_gb     = 40
      disk_file_format = "VHDX"
      is_os_disk       = true
      is_dynamic       = true
    },
    {
      disk_id          = "<dataDiskID>"
      disk_size_gb     = 100
      disk_file_format = "VHDX"
      is_os_disk       = false
      is_dynamic       = true
    }
  ]

  nics_to_include = [
    {
      nic_id            = "<nicID>"
      target_network_id = "<logicalNetworkARMID>"
      selection_type    = "SelectedByUser"
    }
  ]
}
```

Add one object to `disks_to_include` for each disk to replicate, and one object to `nics_to_include` for each NIC:

- Disk objects set `disk_id` (the disk UUID for VMware or the instance ID for Hyper-V), `disk_size_gb`, `disk_file_format` (`VHDX` or `VHD`), `is_os_disk`, and `is_dynamic`.
- NIC objects set `nic_id`, `target_network_id` (the target logical network ARM ID), and `selection_type` (for example, `SelectedByUser`).

When `disks_to_include` is set, it takes precedence over `os_disk_id`. Likewise, `nics_to_include` takes precedence over `target_virtual_switch_id`.

### Key outputs

- `protected_item_id`: The ARM ID of the created protected item. Use this value as the `target_object_id` input in the [Migrate a VM](#migrate-a-vm) and [Complete migration (clean up)](#complete-migration-clean-up) steps.
- `protected_item_name`: The name of the protected item.
- `replication_state`: The current replication health.

For more information, see the [Azure Migrate to Azure Local Terraform module](https://registry.terraform.io/modules/Azure/avm-ptn-azure-local-migrate/azurerm/latest).

---

## Monitor replications

View active replications to monitor their status.

# [PowerShell](#tab/powershell)

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

# [Azure CLI (Preview)](#tab/azurecli)

### List all replications

List all ongoing replications for your Azure Migrate project:

```azurecli
az migrate local replication list \
    --resource-group <resourceGroup> \
    --project-name <projectName>
```

For more information, see the [`az migrate local replication list`](/cli/azure/migrate/local/replication#az-migrate-local-replication-list) command.

### Get details for a specific replication

```azurecli
az migrate local replication get \
    --id "<protectedItemARMID>"
```

For more information, see the [`az migrate local replication get`](/cli/azure/migrate/local/replication#az-migrate-local-replication-get) command.

### Monitor migration jobs

Track the progress and status of migration jobs for your project:

```azurecli
az migrate local replication get-job \
    --resource-group <resourceGroup> \
    --project-name <projectName>
```

For more information, see the [`az migrate local replication get-job`](/cli/azure/migrate/local/replication#az-migrate-local-replication-get-job) command.

# [Terraform (Preview)](#tab/terraform)

Use the `jobs` operation mode to track replication job status. To view protected items, use the `list` and `get` operation modes.

```terraform
module "jobs" {
  source  = "Azure/avm-ptn-azure-local-migrate/azurerm"
  version = "<version>"

  name           = "replication-jobs"
  parent_id      = "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>"
  operation_mode = "jobs"
  project_name   = "<projectName>"
}
```

- To list all protected (replicating) items in the vault, set `operation_mode` to `list`.
- To get the detailed status of a specific protected item, set `operation_mode` to `get` and provide `protected_item_id` or `protected_item_name`.

For more information, see the [Azure Migrate to Azure Local Terraform module](https://registry.terraform.io/modules/Azure/avm-ptn-azure-local-migrate/azurerm/latest).

---

## Migrate a VM 

Start the migration (planned failover) for a protected item that has completed replication.

# [PowerShell](#tab/powershell)

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

# [Azure CLI (Preview)](#tab/azurecli)

Use the `az migrate local start-migration` command to initiate the migration (planned failover) for a protected item. You can use the `--turn-off-source-server` parameter to turn off the source server after migration completes:

```azurecli
az migrate local start-migration \
    --protected-item-id "<protectedItemARMID>" \
    --turn-off-source-server
```

For more information, see the [`az migrate local start-migration`](/cli/azure/migrate/local#az-migrate-local-start-migration) command.

> [!NOTE]
> **Known bug:** When running `az migrate local start-migration`, you may see the warning *"Could not verify Arc Resource Bridge status via Resource Graph query."* This warning displays incorrectly even when the Arc Resource Bridge status is healthy. Migration is not affected and can still succeed even if the warning is shown.

# [Terraform (Preview)](#tab/terraform)

Use the `migrate` operation mode to perform the planned failover, which creates the VM on the target Azure Local cluster. Set `shutdown_source_vm` to `true` to shut down the source VM before failover, which is recommended for data consistency.

```terraform
module "migrate" {
  source  = "Azure/avm-ptn-azure-local-migrate/azurerm"
  version = "<version>"

  name               = "migrate-vm"
  parent_id          = "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>"
  operation_mode     = "migrate"
  target_object_id   = "<protectedItemARMID>"
  shutdown_source_vm = true
}
```

> [!IMPORTANT]
> Before you migrate, the protected item must be in the `Protected` state with `PlannedFailover` in its allowed jobs. Use the `get` operation mode to verify readiness.

For more information, see the [Azure Migrate to Azure Local Terraform module](https://registry.terraform.io/modules/Azure/avm-ptn-azure-local-migrate/azurerm/latest).

---

## Complete migration (clean up)

After migration succeeds, remove the replication to clean up resources.

# [PowerShell](#tab/powershell)

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

# [Azure CLI (Preview)](#tab/azurecli)

Remove completed replications by specifying the protected item ID. You can use the `--force-remove` parameter to force remove a replication if the standard removal fails:

```azurecli
az migrate local replication remove \
    --target-object-id "<protectedItemARMID>"
```

To force remove a replication:

```azurecli
az migrate local replication remove \
    --target-object-id "<protectedItemARMID>" \
    --force-remove
```

For more information, see the [`az migrate local replication remove`](/cli/azure/migrate/local/replication#az-migrate-local-replication-remove) command.

# [Terraform (Preview)](#tab/terraform)

After migration succeeds, use the `remove` operation mode to disable and remove replication for the protected item. Don't remove replication until you verify that the migration succeeded and you no longer need the protected item in Azure Migrate.

```terraform
module "remove" {
  source  = "Azure/avm-ptn-azure-local-migrate/azurerm"
  version = "<version>"

  name             = "remove-replication"
  parent_id        = "/subscriptions/<subscriptionId>/resourceGroups/<resourceGroup>"
  operation_mode   = "remove"
  target_object_id = "<protectedItemARMID>"
  force_remove     = false # Set to true only if normal removal fails.
}
```

> [!CAUTION]
> Setting `force_remove` to `true` can leave resources in an inconsistent state. Use it only as a last resort.

For more information, see the [Azure Migrate to Azure Local Terraform module](https://registry.terraform.io/modules/Azure/avm-ptn-azure-local-migrate/azurerm/latest).

---


## Next steps

- Alternatively, you can [replicate and migrate using the Azure portal](migration-options-overview.md).
