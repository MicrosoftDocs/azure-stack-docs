--- 
title: Manage VMs on Azure Stack HCI with Windows PowerShell 
description: Learn how to manage virtual machines on Azure Stack HCI using Windows PowerShell 
author: v-dasis 
ms.topic: article 
ms.date: 03/12/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Manage VMs on Azure Stack HCI with Windows PowerShell

> Applies to Windows Server 2019

Windows PowerShell can be used to create and manage your virtual machines (VMs) on Azure Stack HCI. This article discusses how to manage individual VMs. If you want to manage multiple VMs or cluster-wide VM settings, such as load-balancing VMs across your cluster, see [Manage Azure Stack HCI clusters using PowerShell].

## View VM inventory

Use the `Get-VM` command to return a list of all virtual machines.

1. In PowerShell, run the following command:
 
    ```powershell
     Get-VM
    ```
2. To return a list of only powered-on virtual machines add a filter to the `Get-VM` command. A filter can be added by using the `Where-Object` command. For more information, see [Using the Where-Object](<https://docs.microsoft.com/previous-versions/windows/it-pro/windows-powershell-1.0/ee177028(v=technet.10)>) documentation.

     ```powershell
     Get-VM | where {$_.State -eq 'Running'}
     ```
3.  To list all virtual machines in a powered off state, run the following command. This command is a copy of the command from step 2 with the filter changed from 'Running' to 'Off'.

     ```powershell
     Get-VM | where {$_.State -eq 'Off'}
     ```
## Start and stop VMs

1. To start a particular virtual machine, run the following command:

     ```powershell
     Start-VM -Name <your_virtual_machine_name>
     ```
1. To start all currently powered off virtual machines, get a list of those machines and pipe the list to the `Start-VM` command:

    ```powershell
    Get-VM | where {$_.State -eq 'Off'} | Start-VM
    ```
1. To shut down all running virtual machines, run this:
 
    ```powershell
    Get-VM | where {$_.State -eq 'Running'} | Stop-VM
    ```

## Create a VM checkpoint

To create a checkpoint using PowerShell, select the virtual machine using the `Get-VM` command and pipe this to the `Checkpoint-VM` command. Finally give the checkpoint a name using `-SnapshotName`. The complete command looks like the following:

    ```powershell
    Get-VM -Name <VM Name> | Checkpoint-VM -SnapshotName <name for snapshot>
    ```
## Create a new VM using PowerShell ISE

The following shows how to create a new VM in the PowerShell Integrated Scripting Environment (ISE). This is a simple example and could be expanded on to include additional PowerShell features and more advanced VM deployments.

1. Open the PowerShell ISE by clicking Windows start, then type **PowerShell ISE**.
1. Run the following code to create a virtual machine. See the [New-VM](https://docs.microsoft.com/powershell/module/hyper-v/new-vm?view=win10-ps) documentation for detailed information on the `New-VM` command.

    ```powershell
    $VMName = "VMNAME"

    $VM = @{
      Name = $VMName
      MemoryStartupBytes = 2147483648
      Generation = 2
      NewVHDPath = "C:\Virtual Machines\$VMName\$VMName.vhdx"
      NewVHDSizeBytes = 53687091200
      BootDevice = "VHD"
      Path = "C:\Virtual Machines\$VMName"
      SwitchName = (Get-VMSwitch).Name
    }

    New-VM @VM
    ```

## Create a VM using PowerShell  

1. Use the [New-VM](https://technet.microsoft.com/library/hh848537.aspx) cmdlet to create the  virtual machine.  See the following examples.  

   - **Existing virtual hard disk** - To create a virtual machine with an existing virtual hard disk, you can use the following command where,  
     - **-Name** is the name that you provide for the virtual machine that you're creating.  
     - **-MemoryStartupBytes** is the amount of memory   that is available to the virtual machine at start up.  
     - **-BootDevice** is the device that the virtual machine boots to  when it starts like the network adapter (NetworkAdapter) or virtual hard disk (VHD).  
     - **-VHDPath** is the path to the virtual machine disk that you want to use.  
     - **-Path** is the path to store the virtual machine configuration files.  
     - **-Generation** is the virtual machine generation. Use generation 1 for VHD and generation 2 for VHDX.
     - **-Switch** is the name of the virtual switch that you want the virtual machine to use to connect to other virtual machines or the network. Get the name of the virtual switch by using [Get-VMSwitch](https://technet.microsoft.com/library/hh848499.aspx).  For example:  

       ``` PowerShell
       Get-VMSwitch  * | Format-Table Name  
       ```  
    The full command as follows:

    ``` powershell 
    New-VM -Name <Name> -MemoryStartupBytes <Memory> -BootDevice <BootDevice> -VHDPath <VHDPath> -Path <Path> -Generation <Generation> -Switch <SwitchName>  
    ```  
    For example:  

    ``` powershell 
    New-VM -Name Win10VM -MemoryStartupBytes 4GB -BootDevice VHD -VHDPath .\VMs\Win10.vhdx -Path .\VMData -Generation 2 -Switch ExternalSwitch  
    ```  
    This creates a Generation 2 virtual machine named Win10VM with 4GB of memory. It boots from the folder VMs\Win10.vhdx in the current directory and uses the virtual switch named ExternalSwitch. The virtual machine configuration files are stored in the folder VMData.  

   - **New virtual hard disk** - To create a virtual machine with a new virtual hard disk, replace the **-VHDPath** parameter from the example above  with  **-NewVHDPath** and add the **-NewVHDSizeBytes** parameter. For example,  

     ``` powershell  
     New-VM -Name Win10VM -MemoryStartupBytes 4GB -BootDevice VHD -NewVHDPath .\VMs\Win10.vhdx -Path .\VMData -NewVHDSizeBytes 20GB -Generation 2 -Switch ExternalSwitch  
     ```  
   - **New virtual hard disk that boots to operating system image** - To create a virtual machine with a new virtual disk that boots to an operating system image, see the PowerShell example in [Create virtual machine walkthrough for Hyper-V on Windows 10](https://msdn.microsoft.com/virtualization/hyperv_on_windows/quick_start/walkthrough_create_vm).  

1. Start the virtual machine by using the [Start-VM](https://technet.microsoft.com/library/hh848589.aspx) cmdlet. Run the following cmdlet where Name is the name of the  virtual machine you created.  

   ``` powershell
   Start-VM -Name <Name>  
   ```  
## Connect to a VM using VMConnect ##

1. Connect to the virtual machine by using Virtual Machine Connection (VMConnect).  

    ``` powershell 
    VMConnect.exe  
    ```  

## Next Steps  

 - You can also create and manage VMs using Windows Admin Center. For more information, see [Managing VMs using Windows Admin Center](manage-vm.md).
 - Find out how to manage cluster-wide VM settings using PowerShell. See [Manage Azure Stack HCI clusters].