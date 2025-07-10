---
title: Azure Stack Hub managed disks differences and considerations 
description: Learn about differences and considerations when working with managed disks and managed images in Azure Stack Hub.
author: sethmanheim
ms.topic: how-to
ms.custom:
  - devx-track-azurepowershell
ms.date: 01/24/2025
ms.author: sethm
ms.lastreviewed: 11/22/2020

# Intent: As an Azure Stack user, I want to know the differences between managed disks for Azure and managed disks for Azure Stack so I can simplify disk management for IaaS.
# Keyword: managed disks azure stack
---


# Azure Stack Hub managed disks: differences and considerations

This article summarizes the differences between [*managed disks* in Azure Stack Hub](azure-stack-manage-vm-disks.md) and [managed disks in Azure](/azure/virtual-machines/windows/managed-disks-overview). To learn about high-level differences between Azure Stack Hub and Azure, see the [Key considerations](azure-stack-considerations.md) article.

Managed disks simplify disk management for IaaS virtual machines (VMs) by managing the [storage accounts](../operator/azure-stack-manage-storage-accounts.md) associated with the VM disks. Managed disks are enabled by default when you create VMs using the Azure Stack Hub portal.
  
## Cheat sheet: managed disk differences

| Feature | Azure (global) | Azure Stack Hub |
| --- | --- | --- |
|Backup options | Azure Backup service |Not yet supported |
|Disaster recovery options | Azure Site Recovery |Azure Site Recovery on Azure Stack Hub|
|Disks performance analytic |Aggregate metrics and per disk metrics supported. |Not yet supported |
|Disk size  |Azure Premium Disk: P4 (32 GiB) to P80 (32 TiB)<br>Azure Standard SSD Disk: E10 (128 GiB) to E80 (32 TiB)<br>Azure Standard HDD Disk: S4 (32 GiB) to S80 (32 TiB) |M4: 32 GiB<br>M6: 64 GiB<br>M10: 128 GiB<br>M15: 256 GiB<br>M20: 512 GiB<br>M30: 1023 GiB |
|Disks snapshot copy|Snapshot Azure managed disks attached to a running VM supported.|Supported through backup vendors. Check with your vendor to verify support. |
|Disk types     |Premium SSD, Standard SSD, and Standard HDD. |Premium SSD, Standard HDD |
|Encryption for data at rest |Azure Storage Service Encryption (SSE), Azure Disk Encryption (ADE).     |BitLocker 128-bit AES encryption      |
|Expand disk – managed disk     |Supported  |Supported<br>[Windows](/azure/virtual-machines/windows/expand-os-disk)<br>[Linux](/azure/virtual-machines/linux/expand-disks)|
|Image          | Managed custom image |Supported|
|Migration      |Provide tool to migrate from existing unmanaged Azure Resource Manager VMs without the need to recreate the VM.  |Not yet supported |
|Premium disks  |Fully supported. |Can be provisioned, but no performance limit or guarantee  |
|Premium disks IOPs  |Depends on disk size.  |2300 IOPs per disk |
|Premium disks throughput |Depends on disk size. |145 MB/second per disk |

> [!NOTE]  
> Managed disks IOPs and throughput in Azure Stack Hub is a cap number instead of a provisioned number, which can be impacted by hardware and workloads running in Azure Stack Hub.

## Metrics

There are also differences with storage metrics:

- With Azure Stack Hub, the transaction data in storage metrics does not differentiate internal or external network bandwidth.
- Azure Stack Hub transaction data in storage metrics does not include virtual machine access to the mounted disks.

## API versions

Azure Stack Hub managed disks support the following API versions:

::: moniker range=">=azs-2102"
- 2019-07-01
::: moniker-end

::: moniker range=">=azs-2008"
- 2019-03-01
- 2018-09-30
- 2018-06-01
- 2018-04-01
- 2017-03-30
::: moniker-end

::: moniker range="<=azs-2005"

- 2017-03-30
- 2017-12-01 (Managed images only, no disks, no snapshots)
::: moniker-end

## Convert to managed disks

> [!NOTE]  
> The Azure PowerShell cmdlet `ConvertTo-AzVMManagedDisk` cannot be used to convert an unmanaged disk to a managed disk in Azure Stack Hub. Azure Stack Hub does not currently support this cmdlet.

You can use the following script to convert a currently provisioned VM from unmanaged to managed disks. Replace the placeholders with your own values.

```powershell
$SubscriptionId = "SubId"

# The name of your resource group where your VM to be converted exists.
$ResourceGroupName ="MyResourceGroup"

# The name of the managed disk to be created.
$DiskName = "mngddisk"

# The size of the disks in GB. It should be greater than the VHD file size.
$DiskSize = "50"

# The URI of the VHD file that will be used to create the managed disk.
# The VHD file can be deleted as soon as the managed disk is created.
$VhdUri = "https://rgmgddisks347.blob.local.azurestack.external/vhds/unmngdvm20181109013817.vhd"

# The storage type for the managed disk: PremiumLRS or StandardLRS.
$AccountType = "StandardLRS"

# The Azure Stack Hub location where the managed disk is to be located.
# The location should be the same as the location of the storage account in which VHD file is stored.
# Configure the new managed VM point to the old unmanaged VM configuration (network config, VM name, location).
$Location = "local"
$VirtualMachineName = "unmngdvm"
$VirtualMachineSize = "Standard_D1"
$PIpName = "unmngdvm-ip"
$VirtualNetworkName = "unmngdrg-vnet"
$NicName = "unmngdvm"

# Set the context to the subscription ID in which the managed disk will be created.
Select-AzSubscription -SubscriptionId $SubscriptionId

# Delete old VM, but keep the OS disk.
Remove-AzVm -Name $VirtualMachineName -ResourceGroupName $ResourceGroupName

# Create the managed disk configuration.
$DiskConfig = New-AzDiskConfig -AccountType $AccountType -Location $Location -DiskSizeGB $DiskSize -SourceUri $VhdUri -CreateOption Import

# Create managed disk.
New-AzDisk -DiskName $DiskName -Disk $DiskConfig -ResourceGroupName $resourceGroupName
$Disk = Get-AzDisk -DiskName $DiskName -ResourceGroupName $ResourceGroupName
$VirtualMachine = New-AzVMConfig -VMName $VirtualMachineName -VMSize $VirtualMachineSize

# Use the managed disk resource ID to attach it to the virtual machine.
# Change the OS type to "-Windows" if the OS disk has the Windows OS.
$VirtualMachine = Set-AzVMOSDisk -VM $VirtualMachine -ManagedDiskId $Disk.Id -CreateOption Attach -Linux

# Create a public IP for the VM.
$PublicIp = Get-AzPublicIpAddress -Name $PIpName -ResourceGroupName $ResourceGroupName

# Get the virtual network where the virtual machine will be hosted.
$VNet = Get-AzVirtualNetwork -Name $VirtualNetworkName -ResourceGroupName $ResourceGroupName

# Create NIC in the first subnet of the virtual network.
$Nic = Get-AzNetworkInterface -Name $NicName -ResourceGroupName $ResourceGroupName

$VirtualMachine = Add-AzVMNetworkInterface -VM $VirtualMachine -Id $Nic.Id

# Create the virtual machine with managed disk.
New-AzVM -VM $VirtualMachine -ResourceGroupName $ResourceGroupName -Location $Location
```

## Managed images

Azure Stack Hub supports *managed images*, which enable you to create a managed image object on a generalized VM (both unmanaged and managed) that can only create managed disk VMs going forward. Managed images enable the following two scenarios:

- You have generalized unmanaged VMs and want to use managed disks going forward.
- You have a generalized managed VM and want to create multiple, similar managed VMs.

### Step 1: Generalize the VM

For Windows, follow the [Generalize the Windows VM using Sysprep](/azure/virtual-machines/windows/capture-image-resource#generalize-the-windows-vm-using-sysprep) section. For Linux, follow step 1 [here](/azure/virtual-machines/linux/capture-image#step-1-deprovision-the-vm).

> [!NOTE]
> Make sure to generalize your VM. Creating a VM from an image that hasn't been properly generalized can produce a **VMProvisioningTimeout** error.

### Step 2: Create the managed image

You can use the portal, PowerShell, or Azure CLI to create the managed image. Follow the steps in [Create a managed image](/azure/virtual-machines/windows/capture-image-resource).

### Step 3: Choose the use case

#### Case 1: Migrate unmanaged VMs to managed disks

Make sure to generalize your VM correctly before doing this step. After generalization, you can no longer use this VM. Creating a VM from an image that hasn't been properly generalized produces a **VMProvisioningTimeout** error.

Follow the instructions in [Create an image from a VM that uses a storage account](/azure/virtual-machines/windows/capture-image-resource#create-an-image-from-a-vm-that-uses-a-storage-account) to create a managed image from a generalized VHD in a storage account. You can use this image in the future to create managed VMs.

#### Case 2: Create managed VM from managed image using PowerShell

After you create an image from an existing managed disk VM using the script in [Create an image from a managed disk using PowerShell](/azure/virtual-machines/windows/capture-image-resource#create-an-image-from-a-managed-disk-using-powershell), use the following example script to create a similar Linux VM from an existing image object.

Azure Stack Hub PowerShell module 1.7.0 or later: Follow the instructions in [Create a VM from a managed image](/azure/virtual-machines/windows/create-vm-generalized-managed).

Azure Stack Hub PowerShell module 1.6.0 or earlier:

```powershell
# Variables for common values
$ResourceGroupName = "MyResourceGroup"
$Location = "local"
$VirtualMachineName = "MyVM"
$ImageRG = "managedlinuxrg"
$ImageName = "simplelinuxvmm-image-2019122"

# Create credential object
$Cred = Get-Credential -Message "Enter a username and password for the virtual machine."

# Create a resource group
New-AzResourceGroup -Name $ResourceGroupName -Location $Location

# Create a subnet configuration
$SubnetConfig = New-AzVirtualNetworkSubnetConfig -Name "MySubnet" -AddressPrefix "192.168.1.0/24"

# Create a virtual network
$VNet = New-AzVirtualNetwork -ResourceGroupName $ResourceGroupName -Location $Location `
  -Name "MyVNet" -AddressPrefix "192.168.0.0/16" -Subnet $SubnetConfig

# Create a public IP address and specify a DNS name
$PIp = New-AzPublicIpAddress -ResourceGroupName $ResourceGroupName -Location $Location `
  -Name "mypublicdns$(Get-Random)" -AllocationMethod Static -IdleTimeoutInMinutes 4

# Create an inbound network security group rule for port 3389
$NsgRuleSSH = New-AzNetworkSecurityRuleConfig -Name "MyNetworkSecurityGroupRuleSSH"  -Protocol Tcp `
  -Direction Inbound -Priority 1000 -SourceAddressPrefix * -SourcePortRange * -DestinationAddressPrefix * `
  -DestinationPortRange 22 -Access Allow

# Create a network security group
$Nsg = New-AzNetworkSecurityGroup -ResourceGroupName $ResourceGroupName -Location $Location `
  -Name "MyNetworkSecurityGroup" -SecurityRules $NsgRuleSSH

# Create a virtual network card and associate with public IP address and NSG
$Nic = New-AzNetworkInterface -Name "MyNic" -ResourceGroupName $ResourceGroupName -Location $Location `
  -SubnetId $VNet.Subnets[0].Id -PublicIpAddressId $PIp.Id -NetworkSecurityGroupId $Nsg.Id

$Image = Get-AzImage -ResourceGroupName $ImageRG -ImageName $ImageName

# Create a virtual machine configuration
$VmConfig = New-AzVMConfig -VMName $VirtualMachineName -VMSize "Standard_D1" | `
Set-AzVMOperatingSystem -Linux -ComputerName $VirtualMachineName -Credential $Cred | `
Set-AzVMSourceImage -Id $Image.Id | `
Set-AzVMOSDisk -VM $VmConfig -CreateOption FromImage -Linux | `
Add-AzVMNetworkInterface -Id $Nic.Id

# Create a virtual machine
New-AzVM -ResourceGroupName $ResourceGroupName -Location $Location -VM $VmConfig
```

You can also use the portal to create a VM from a managed image. For more information, see the Azure managed image articles [Create a managed image of a generalized VM in Azure](/azure/virtual-machines/windows/capture-image-resource) and [Create a VM from a managed image](/azure/virtual-machines/windows/create-vm-generalized-managed).

## Configuration

After applying the 1808 update or later, you must make the following configuration change before using managed disks:

- If a subscription was created before the 1808 update, follow below steps to update the subscription. Otherwise, deploying VMs in this subscription might fail with an error message "Internal error in disk manager."
   1. In the Azure Stack Hub user portal, go to **Subscriptions** and find the subscription. Click **Resource Providers**, then click **Microsoft.Compute**, and then click **Re-register**.
   1. Under the same subscription, go to **Access Control (IAM)**, and verify that **Azure Stack Hub - Managed Disk** is listed.
- If you use a multi-tenant environment, ask your cloud operator (who may be in your own organization, or from the service provider) to reconfigure each of your guest directories following the steps in [Configure multi-tenancy in Azure Stack Hub](../operator/enable-multitenancy.md#configure-guest-directory). Otherwise, deploying VMs in a subscription associated with that guest directory might fail with the error message "Internal error in disk manager."

## Next steps

- Learn about [Azure Stack Hub virtual machines](azure-stack-compute-overview.md).
- See also [Azure Stack Hub managed disks differences and considerations](azure-stack-managed-disk-considerations.md#convert-to-managed-disks).
- How to [Expand unmanaged virtual hard disks attached to a virtual machine](/azure/virtual-machines/expand-unmanaged-disks).
