--- 
title: Manage VMs using Windows PowerShell - Azure Stack HCI
description: How to manage virtual machines on Azure Stack HCI using Windows PowerShell 
author: v-dasis 
ms.topic: how-to 
ms.date: 07/21/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Manage VMs on Azure Stack HCI using Windows PowerShell

> Applies to Azure Stack HCI, version 20H2; Windows Server 2019

Windows PowerShell can be used to create and manage your virtual machines (VMs) on Azure Stack HCI.

Typically, you manage VMs from a remote computer, rather than on a host server in a cluster. This remote computer is called the management computer.

> [!NOTE]
> When running PowerShell commands from a management computer, include the -ComputerName parameter with the name of the host server you are managing. NetBIOS names, IP addresses, and fully qualified domain names are allowable.

For the complete reference documentation for managing VMs using PowerShell, see [Hyper-V reference](/powershell/module/hyper-v/?view=win10-ps).

## Create a VM  

The `New-VM` cmdlet is used to create a new VM. For detailed usage, see the [New-VM](/powershell/module/hyper-v/new-vm?view=win10-ps) reference documentation.

Here are the settings that you can specify when creating a new VM with an existing virtual hard disk, where:

- **-Name** is the name that you provide for the virtual machine that you're creating.

- **-MemoryStartupBytes** is the amount of memory   that is available to the virtual machine at start up.

- **-BootDevice** is the device that the virtual machine boots to when it starts.
 Typically this is a virtual hard disk (VHD), an .iso file for DVD-based boot, or a network adapter (NetworkAdapter) for network boot.

- **-VHDPath** is the path to the virtual machine disk that you want to use.

- **-Path** is the path to store the virtual machine configuration files.

- **-Generation** is the virtual machine generation. Use generation 1 for VHD and generation 2 for VHDX.

- **-Switch** is the name of the virtual switch that you want the virtual machine to use to connect to other virtual machines or the network. Get the name of the virtual switch by using [Get-VMSwitch](/powershell/module/hyper-v/get-vmswitch?view=win10-ps). For example:  

The full command as follows for creating a VM called VM1:

 ```powershell
 New-VM -ComputerName Server1 -Name VM1 -MemoryStartupBytes <Memory> -BootDevice <BootDevice> -VHDPath <VHDPath> -Path <Path> -Generation <Generation> -Switch <SwitchName>
 ```

The next example creates a Generation 2 virtual machine with 4GB of memory. It boots from the folder VMs\Win10.vhdx in the current directory and uses the virtual switch named ExternalSwitch. The virtual machine configuration files are stored in the folder VMData.  

``` powershell
New-VM -ComputerName Server1 -Name VM1 -MemoryStartupBytes 4GB -BootDevice VHD -VHDPath .\VMs\Win10.vhdx -Path .\VMData -Generation 2 -Switch ExternalSwitch
```

The following parameters are used to specify virtual hard disks.

To create a virtual machine with a new virtual hard disk, replace the **-VHDPath** parameter from the example above with  **-NewVHDPath** and add the **-NewVHDSizeBytes** parameter as shown here:  

``` powershell  
New-VM -ComputerName Server1 -Name VM1 -MemoryStartupBytes 4GB -BootDevice VHD -NewVHDPath .\VMs\Win10.vhdx -Path .\VMData -NewVHDSizeBytes 20GB -Generation 2 -Switch ExternalSwitch  
 ```  

To create a virtual machine with a new virtual disk that boots to an operating system image, see the PowerShell example in [Create virtual machine walkthrough for Hyper-V on Windows 10](/virtualization/hyper-v-on-windows/quick-start/create-virtual-machine).  

## Get a list of VMs

The following example returns a list of all VMs on Server1.

```powershell
Get-VM -ComputerName Server1
```

The following example returns a list of all running VMs on a server by adding a filter using the `Where-Object` command. For more information, see [Using the Where-Object](/previous-versions/windows/it-pro/windows-powershell-1.0/ee177028(v=technet.10)) documentation.

```powershell
Get-VM -ComputerName Server1 | Where-Object -Property State -eq "Running"
```

The next example returns a list of all shut-down VMs on the server.

```powershell
Get-VM -ComputerName Server1 | Where-Object -Property State -eq "Off"
```

## Start and stop a VM

Use the `Start-VM` and `Stop-VM` commands to start or stop a VM. For detailed information, see the [Start-VM](/powershell/module/hyper-v/start-vm?view=win10-ps) and [Stop-VM](/powershell/module/hyper-v/stop-vm?view=win10-ps) reference documentation.

The following example shows how to start a VM named VM1:

```powershell
Start-VM -Name VM1 -ComputerName Server1
```

The following example shows how to shut-down a VM named TestVM:

```powershell
Stop-VM -Name VM1 -ComputerName Server1
```

## Move a VM

The `Move-VM` cmdlet moves a VM to a different server. For more information, see the [Move-VM](/powershell/module/hyper-v/move-vm?view=win10-ps) reference documentation.

 The following example shows how to move a VM to Server2 when the VM is stored on an SMB share on Server1:

```powershell
Move-VM -ComputerName Server1 -Name VM1 -DestinationHost Server2
 ```

The following example shows how to move a VM to Server2 from Server1 and move all files associated with the VM to D:\VM_name on the remote computer:

```powershell
Move-VM -ComputerName Server1 -Name VM1 -DestinationHost Server2 -IncludeStorage -DestinationStoragePath D:\VM_name
```

## Import or export a VM

The `Import-VM` and `Export-VM` cmdlets import and export a VM. The following shows a couple of examples. For more information, see the [Import-VM](/powershell/module/hyper-v/import-vm?view=win10-ps)  and [Export-VM](/powershell/module/hyper-v/export-vm?view=win10-ps) reference documentation.

The following example shows how to import a VM from its configuration file. The VM is registered in-place, so its files are not copied:

```powershell
Import-VM -ComputerName Server1 -Name VM1 -Path 'C:\<vm export path>\2B91FEB3-F1E0-4FFF-B8BE-29CED892A95A.vmcx'
```

The following example exports a VM to the root of the D drive:

```powershell
Export-VM -ComputerName Server1 -Name VM1 -Path D:\
```

## Rename a VM

The `Rename-VM` cmdlet is used to rename a VM. For detailed information, see the [Rename-VM](/powershell/module/hyper-v/rename-vm?view=win10-ps) reference documentation.

The following example renames VM1 to VM2 and displays the renamed virtual machine:

```powershell
Rename-VM -ComputerName Server1 -Name VM1 -NewName VM2
```

## Create a VM checkpoint

The `Checkpoint-VM` cmdlet is used to create a checkpoint for a VM. For detailed information, see the [Checkpoint-VM](/powershell/module/hyper-v/checkpoint-vm?view=win10-ps) reference documentation.

The following example creates a checkpoint named BeforeInstallingUpdates for the VM named Test.

```powershell
Checkpoint-VM -ComputerName Server1 -Name VM1 -SnapshotName BeforeInstallingUpdates
```

## Create a VHD for a VM

The `New-VHD` cmdlet is used to create a new VHD for a VM. For detailed information on how to use it, see the [New-VHD](/powershell/module/hyper-v/new-vhd?view=win10-ps) reference documentation.

The following example creates a dynamic virtual hard disk in VHDX format that is 10 GB in size. The file name extension determines the format and the default type of dynamic is used because no type is specified.

```powershell
New-VHD -ComputerName Server1 -Name VM1 -Path c:\Base.vhdx -SizeBytes 10GB
```

## Add a network adapter to a VM

The `Add-VMNetworkAdapter` cmdlet is used to add a virtual network adapter to a VM. The following shows a couple of examples. For detailed information on how to use it, see the [Add-VMNetworkAdapter](/powershell/module/hyper-v/add-vmnetworkadapter?view=win10-ps) reference documentation.

The following example adds a virtual network adapter named Redmond NIC1 to a virtual machine named VM1:

```powershell
Add-VMNetworkAdapter -ComputerName Server1 -VMName VM1 -Name "Redmond NIC1"
```

This example adds a virtual network adapter to a virtual machine named VM1 and connects it to a virtual switch named Network:

```powershell
Add-VMNetworkAdapter -ComputerName Server1 -VMName VM1 -SwitchName Network
```

## Create a virtual switch for a VM

The `New-VMSwitch` cmdlet is used to new virtual switch on a VM host. For detailed information on how to use it, see the [New-VMSwitch](/powershell/module/hyper-v/new-vmswitch?view=win10-ps) reference documentation.

The following example creates a new switch called "QoS switch", which binds to a network adapter called Wired Ethernet Connection 3 and supports weight-based minimum bandwidth.

```powershell
New-VMSwitch "QoS Switch" -NetAdapterName "Wired Ethernet Connection 3" -MinimumBandwidthMode Weight
```

## Set memory for a VM

The `Set-VMMemory` cmdlet is used to configure the memory a VM. For detailed information on how to use it, see the [Set-VMMemory](/powershell/module/hyper-v/set-vmmemory?view=win10-ps) reference documentation.

The following example enables dynamic memory on a VM named VM1, sets its minimum, startup, and maximum memory, its memory priority, and its buffer.

```powershell
Set-VMMemory -ComputerName Server1 -Name VM1 -DynamicMemoryEnabled $true -MinimumBytes 64MB -StartupBytes 256MB -MaximumBytes 2GB -Priority 80 -Buffer 25
```

## Set virtual processors for a VM

The `Set-VMProcessor` cmdlet is used to configure the virtual processors for a VM. For detailed information on how to use it, see the [Set-VMProcessor](/powershell/module/hyper-v/set-vmprocessor?view=win10-ps) reference documentation.

The following example configures a VM named VM1 with two virtual processors, a reserve of 10%, a limit of 75%, and a relative weight of 200.

```powershell
Set-VMProcessor -ComputerName Server1 -Name VM1 -Count 2 -Reserve 10 -Maximum 75 -RelativeWeight 200
```

## Next steps  

You can also create and manage VMs using Windows Admin Center. For more information, see [Windows Admin Center](vm.md).
