---
title: Create VM disk storage in Azure Stack | Microsoft Docs
description: Create disks for virtual machines in Azure Stack.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: conceptual
ms.date: 12/03/2019
ms.author: sethm
ms.reviewer: jiahan
ms.lastreviewed: 01/18/2019
---

# Create VM disk storage in Azure Stack

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

This article describes how to create virtual machine (VM) disk storage by using the Azure Stack portal or by using PowerShell.

## Overview

Beginning with version 1808, Azure Stack supports the use of managed disks and unmanaged disks in VMs, as both an operating system (OS) and a data disk. Before version 1808, only unmanaged disks are supported.

[Managed disks](/azure/virtual-machines/windows/managed-disks-overview) simplify disk management for Azure IaaS VMs by managing the storage accounts associated with the VM disks. You only have to specify the size of disk you need, and Azure Stack creates and manages the disk for you.

Unmanaged disks require that you create a storage account to store the disks. The disks you create are referred to as VM disks and are stored in containers in the storage account.

## Best practice guidelines

It is recommended that you use Managed Disks for VM for easier management and capacity balance. You don't have to prepare a storage account and containers before using Managed Disks. When creating multiple managed disks, the disks are distributed into multiple volumes, which helps to balance the capacity of volumes.  

For unmanaged disks, to improve performance and reduce the overall costs, we recommend that you place each unmanaged disk in a separate container. Although you can put both OS disks and data disks in the same container, the best practice is that one container should hold either an OS disk or a data disk, but not both at the same time.

If you add one or more data disks to a VM, use additional containers as a location to store these disks. The OS disk for additional VMs should also be in their own containers.

When you create VMs, you can reuse the same storage account for each new virtual machine. Only the containers you create should be unique.

## Adding new disks

The following table summarizes how to add disks by using the portal, and by using PowerShell:

| Method | Options
|-|-|
|User portal|- Add new data disks to an existing VM. New disks are created by Azure Stack. </br> </br> - Add an existing disk (.vhd) file to a  previously created VM. To do so, you must prepare the .vhd and then upload the file to Azure Stack. |
|[PowerShell](#use-powershell-to-add-multiple-disks-to-a-vm) | - Create a new VM with an OS disk, and at the same time add one or more data disks to that VM. |

## Use the portal to add disks to a VM

By default, when you use the portal to create a VM for most marketplace items, only the OS disk is created.

After you create a VM, you can use the portal to:

* Create a new data disk and attach it to the VM.
* Upload an existing data disk and attach it to the VM.

Each unmanaged disk you add should be put in a separate container.

>[!NOTE]  
>Disks created and managed by Azure are called [managed disks](/azure/virtual-machines/windows/managed-disks-overview).

### Use the portal to create and attach a new data disk

1. In the portal, select **All services**, then **Virtual machines**.
   ![Example: VM dashboard](media/azure-stack-manage-vm-disks/vm-dashboard.png)

2. Select a VM that has previously been created.
   ![Example: Select a VM in the dashboard](media/azure-stack-manage-vm-disks/select-a-vm.png)

3. For the VM, select **Disks**, then **Add data disk**.
   ![Example: Attach a new disk to the vm](media/azure-stack-manage-vm-disks/Attach-disks.png)

4. For the Data disk:
   * Enter the **LUN**. The LUN must be a valid number.
   * Select **Create disk**.
   ![Example: Attach a new disk to the vm](media/azure-stack-manage-vm-disks/add-a-data-disk-create-disk.png)

5. In the **Create managed disk** blade:
   * Enter the **Name** of the disk.
   * Select an existing **Resource group** or create a new one.
   * Select the **Location**. By default, the location is set to the same container that holds the OS disk.
   * Select the **Account type**.
      ![Example: Attach a new disk to the vm](media/azure-stack-manage-vm-disks/create-manage-disk.png)

      **Premium SSD**  
      Premium disks (SSD) are backed by solid-state drives and offer consistent, low-latency performance. They provide the best balance between price and performance, and are ideal for I/O-intensive apps and production workloads.

      **Standard HDD**  
      Standard disks (HDD) are backed by magnetic drives and are preferable for apps where data is accessed infrequently. Zone-redundant disks are backed by zone-redundant storage (ZRS) that replicates your data across multiple zones, ensuring your data is available even if a single zone is down.

   * Select the **Source type**.

     Create a disk from a snapshot of another disk, a blob in a storage account, or create an empty disk.

      **Snapshot**: Select a snapshot, if it's available. The snapshot must be in available in the VM's subscription and location.

      **Storage blob**:
     * Add the URI of the storage blob that contains the disk image.  
     * Select **Browse** to open the storage accounts blade. For instructions, see [Add a data disk from a storage account](#add-a-data-disk-from-a-storage-account).
     * Select the OS type of the image: **Windows**, **Linux**, or **None (data disk)**.

   * Select the **Size (GiB)**.

     Standard disk costs increase based on the size of the disk. Premium disk costs and performance increase based on the size of the disk. For more information, see [Managed Disks pricing](https://go.microsoft.com/fwlink/?linkid=843142).

   * Select **Create**. Azure Stack creates and validates the managed disk.

6. After Azure Stack creates the disk and attaches it to the VM, the new disk is listed in the VM disk settings under **DATA DISKS**.

   ![Example: View disk](media/azure-stack-manage-vm-disks/view-data-disk.png)

### Add a data disk from a storage account

For more information about working with storage accounts in Azure Stack, see [Introduction to Azure Stack storage](azure-stack-storage-overview.md).

1. Select the **Storage account** to use.
2. Select the **Container** where you want to put the data disk. From the **Containers** blade, you can create a new container if you want. You can then change the location for the new disk to its own container. When you use a separate container for each disk, you distribute the placement of the data disk which improves performance.
3. Choose **Select** to save the selection.

    ![Example: Select a container](media/azure-stack-manage-vm-disks/select-container.png)

## Attach an existing data disk to a VM

1. [Prepare a .vhd file](/azure/virtual-machines/windows/classic/createupload-vhd) for use as data disk for a VM. Upload that .vhd file to a storage account that you use with the VM to which you want to attach the .vhd file.

    - Plan to use a different container to hold the .vhd file than the container that holds the OS disk.  
    - Before uploading any VHD to Azure, you should follow [Prepare a Windows VHD or VHDX to upload to Azure](https://docs.microsoft.com/azure/virtual-machines/windows/prepare-for-upload-vhd-image?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json).
    - Review [Plan for the migration to Managed Disks](https://docs.microsoft.com/azure/virtual-machines/windows/on-prem-to-azure#plan-for-the-migration-to-managed-disks) before starting your migration to [Managed Disks](https://docs.microsoft.com/azure/virtual-machines/windows/managed-disks-overview).
    
    ![Example: Upload a VHD file](media/azure-stack-manage-vm-disks/upload-vhd.png)



2. After the .vhd file is uploaded, you're ready to attach the VHD to a VM. In the menu on the left, select  **Virtual machines**.  
 ![Example: Select a VM in the dashboard](media/azure-stack-manage-vm-disks/vm-dashboard.png)

3. Choose the VM from the list.

    ![Example: Select a VM in the dashboard](media/azure-stack-manage-vm-disks/select-a-vm.png)

4. On the page for the VM, select **Disks**, then select  **Attach existing**.

    ![Example: Attach an existing disk](media/azure-stack-manage-vm-disks/attach-disks2.png)

5. In the **Attach existing disk** page, select **VHD File**. The **Storage accounts** page opens.

    ![Example: Select a VHD file](media/azure-stack-manage-vm-disks/select-vhd.png)

6. Under **Storage accounts**, select the account to use, and then choose a container that holds the .vhd file you previously uploaded. Select the .vhd file, and then choose **Select** to save the selection.

    ![Example: Select a container](media/azure-stack-manage-vm-disks/select-container2.png)

7. Under **Attach existing disk**, the file you selected is listed under **VHD File**. Update the **Host caching** setting of the disk, and then select **OK** to save the new disk configuration for the VM.

    ![Example: Attach the VHD file](media/azure-stack-manage-vm-disks/attach-vhd.png)

8. After Azure Stack creates the disk and attaches it to the VM, the new disk is listed in the VM's disk settings under **Data Disks**.

    ![Example: Complete the disk attach](media/azure-stack-manage-vm-disks/complete-disk-attach.png)

## Use PowerShell to add multiple disks to a VM

You can use PowerShell to provision a VM and add new data disks, or attach a pre-existing managed disk or .vhd file as a data disk.

The **Add-AzureRmVMDataDisk** cmdlet adds a data disk to a VM. You can add a data disk when you create a VM, or you can add a data disk to an existing VM. For an unamanaged disk, specify the **VhdUri** parameter to distribute the disks to different containers.

### Add data disks to a **new** VM

The following examples use PowerShell commands to create a VM with three data disks. The commands are provided with several parts due to the minor differences when using managed disks or unmanaged disks. 

#### Create virtual machine configuration and network resources

The following script creates a VM object, and then stores it in the `$VirtualMachine` variable. The commands assign a name and size to the VM, then create the network resources (virtual network, subnet, virtual network adapter, NSG, and public IP address) for the VM:

```powershell
# Create new virtual machine configuration
$VirtualMachine = New-AzureRmVMConfig -VMName "VirtualMachine" `
                                      -VMSize "Standard_A2"

# Set variables
$rgName = "myResourceGroup"
$location = "local"

# Create a subnet configuration
$subnetName = "mySubNet"
$singleSubnet = New-AzureRmVirtualNetworkSubnetConfig -Name $subnetName -AddressPrefix 10.0.0.0/24

# Create a vnet configuration
$vnetName = "myVnetName"
$vnet = New-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName -Location $location `
                                  -AddressPrefix 10.0.0.0/16 -Subnet $singleSubnet

# Create a public IP
$ipName = "myIP"
$pip = New-AzureRmPublicIpAddress -Name $ipName -ResourceGroupName $rgName -Location $location `
                                  -AllocationMethod Dynamic

# Create a network security group configuration
$nsgName = "myNsg"
$rdpRule = New-AzureRmNetworkSecurityRuleConfig -Name myRdpRule -Description "Allow RDP" `
                                                -Access Allow -Protocol Tcp -Direction Inbound -Priority 110 `
                                                -SourceAddressPrefix Internet -SourcePortRange * `
                                                -DestinationAddressPrefix * -DestinationPortRange 3389
$nsg = New-AzureRmNetworkSecurityGroup -ResourceGroupName $rgName -Location $location `
                                       -Name $nsgName -SecurityRules $rdpRule

# Create a NIC configuration
$nicName = "myNicName"
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName `
                                   -Location $location -SubnetId $vnet.Subnets[0].Id `
                                   -NetworkSecurityGroupId $nsg.Id -PublicIpAddressId $pip.Id

```

#### Add managed disk
>[!NOTE]  
>It is only for adding managed disks in this section. 

The following three commands add managed data disks to the virtual machine stored in `$VirtualMachine`. Each command specifies the name and additional properties of the disk:

```powershell
$VirtualMachine = Add-AzureRmVMDataDisk -VM $VirtualMachine -Name 'DataDisk1' `
                                        -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 0 `
                                        -CreateOption Empty
```

```powershell
$VirtualMachine = Add-AzureRmVMDataDisk -VM $VirtualMachine -Name 'DataDisk2' `
                                        -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 1 `
                                        -CreateOption Empty
```

```powershell
$VirtualMachine = Add-AzureRmVMDataDisk -VM $VirtualMachine -Name 'DataDisk3' `
                                        -Caching 'ReadOnly' -DiskSizeInGB 12 -Lun 2 `
                                        -CreateOption Empty
```

The following command adds an OS disk as a managed disk to the virtual machine storged in `$VirtualMachine`.

```powershell
# Set OS Disk
$osDiskName = "osDisk"
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $osDiskName  `
                                      -CreateOption FromImage -Windows
```

#### Add unmanaged disk

>[!NOTE]  
>This section is only for adding unmanaged disks. 

The next three commands assign paths of three unmanaged data disks to the `$DataDiskVhdUri01`, `$DataDiskVhdUri02`, and `$DataDiskVhdUri03` variables. Define a different path name in the URL to distribute the disks to different containers:

```powershell
$DataDiskVhdUri01 = "https://contoso.blob.local.azurestack.external/test1/data1.vhd"
```

```powershell
$DataDiskVhdUri02 = "https://contoso.blob.local.azurestack.external/test2/data2.vhd"
```

```powershell
$DataDiskVhdUri03 = "https://contoso.blob.local.azurestack.external/test3/data3.vhd"
```

The following three commands add data disks to the virtual machine stored in `$VirtualMachine`. Each command specifies the name, and additional properties of the disk. The URI of each disk is stored in `$DataDiskVhdUri01`, `$DataDiskVhdUri02`, and `$DataDiskVhdUri03`:

```powershell
$VirtualMachine = Add-AzureRmVMDataDisk -VM $VirtualMachine -Name 'DataDisk1' `
                                        -Caching 'ReadOnly' -DiskSizeInGB 10 -Lun 0 `
                                        -VhdUri $DataDiskVhdUri01 -CreateOption Empty
```

```powershell
$VirtualMachine = Add-AzureRmVMDataDisk -VM $VirtualMachine -Name 'DataDisk2' `
                                        -Caching 'ReadOnly' -DiskSizeInGB 11 -Lun 1 `
                                        -VhdUri $DataDiskVhdUri02 -CreateOption Empty
```

```powershell
$VirtualMachine = Add-AzureRmVMDataDisk -VM $VirtualMachine -Name 'DataDisk3' `
                                        -Caching 'ReadOnly' -DiskSizeInGB 12 -Lun 2 `
                                        -VhdUri $DataDiskVhdUri03 -CreateOption Empty
```

The following commands add an unmanaged OS disk to the virtual machine stored in `$VirtualMachine`.

```powershell
# Set OS Disk
$osDiskUri = "https://contoso.blob.local.azurestack.external/vhds/osDisk.vhd"
$osDiskName = "osDisk"
$VirtualMachine = Set-AzureRmVMOSDisk -VM $VirtualMachine -Name $osDiskName -VhdUri $osDiskUri `
                                      -CreateOption FromImage -Windows
```


#### Create new virtual machine
Use the following PowerShell commands to set OS image, add network configuration to the VM, and then start the new VM.

```powershell
#Create the new VM
$VirtualMachine = Set-AzureRmVMOperatingSystem -VM $VirtualMachine -Windows -ComputerName VirtualMachine -ProvisionVMAgent | `
                  Set-AzureRmVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer `
                  -Skus 2016-Datacenter -Version latest | Add-AzureRmVMNetworkInterface -Id $nic.Id

New-AzureRmVM -ResourceGroupName $rgName -Location $location -VM $VirtualMachine
```


### Add data disks to an **existing** VM
The following examples use PowerShell commands to add three data disks to an existing VM.

#### Get virtual machine

 The first command gets the VM named **VirtualMachine** by using the **Get-AzureRmVM** cmdlet. The command stores the VM in the `$VirtualMachine` variable:

```powershell
$VirtualMachine = Get-AzureRmVM -ResourceGroupName "myResourceGroup" `
                                -Name "VirtualMachine"
```

#### Add managed disk

>[!NOTE]  
>This section is only for adding managed disks.

The next three commands add the managed data disks to the VM stored in the `$VirtualMachine` variable. Each command specifies the name and additional properties of the disk:

```powershell
Add-AzureRmVMDataDisk -VM $VirtualMachine -Name "DataDisk1" -Lun 0 `
                      -Caching ReadOnly -DiskSizeinGB 10 -CreateOption Empty
```

```powershell
Add-AzureRmVMDataDisk -VM $VirtualMachine -Name "DataDisk2" -Lun 1 `
                      -Caching ReadOnly -DiskSizeinGB 11 -CreateOption Empty
```

```powershell
Add-AzureRmVMDataDisk -VM $VirtualMachine -Name "DataDisk3" -Lun 2 `
                      -Caching ReadOnly -DiskSizeinGB 12 -CreateOption Empty
```

#### Add unamanged disk

>[!NOTE]  
>This section is only for adding unmanaged disks. 

The next three commands assign paths for three data disks to the `$DataDiskVhdUri01`, `$DataDiskVhdUri02`, and `$DataDiskVhdUri03` variables. The different path names in the VHD URIs indicate different containers for the disk placement:

```powershell
$DataDiskVhdUri01 = "https://contoso.blob.local.azurestack.external/test1/data1.vhd"
```

```powershell
$DataDiskVhdUri02 = "https://contoso.blob.local.azurestack.external/test2/data2.vhd"
```

```powershell
$DataDiskVhdUri03 = "https://contoso.blob.local.azurestack.external/test3/data3.vhd"
```

The next three commands add the data disks to the VM stored in the `$VirtualMachine` variable. Each command specifies the name, location, and additional properties of the disk. The URI of each disk is stored in `$DataDiskVhdUri01`, `$DataDiskVhdUri02`, and `$DataDiskVhdUri03`:

```powershell
Add-AzureRmVMDataDisk -VM $VirtualMachine -Name "DataDisk1" `
                      -VhdUri $DataDiskVhdUri01 -LUN 0 `
                      -Caching ReadOnly -DiskSizeinGB 10 -CreateOption Empty
```

```powershell
Add-AzureRmVMDataDisk -VM $VirtualMachine -Name "DataDisk2" `
                      -VhdUri $DataDiskVhdUri02 -LUN 1 `
                      -Caching ReadOnly -DiskSizeinGB 11 -CreateOption Empty
```

```powershell
Add-AzureRmVMDataDisk -VM $VirtualMachine -Name "DataDisk3" `
                      -VhdUri $DataDiskVhdUri03 -LUN 2 `
                      -Caching ReadOnly -DiskSizeinGB 12 -CreateOption Empty
```

#### Update virtual machine state

This command updates the state of the VM stored in `$VirtualMachine` in `-ResourceGroupName`:

```powershell
Update-AzureRmVM -ResourceGroupName "myResourceGroup" -VM $VirtualMachine
```

## Next steps

To learn more about Azure Stack VMs, see [Considerations for Virtual Machines in Azure Stack](azure-stack-vm-considerations.md).
