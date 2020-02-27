--- 
title: Manage virtual machines using Windows PowerShell 
description: Learn how to manage virtual machines for Azure Stack HCI using Windows PowerShell 
author: v-dasis 
ms.topic: article 
ms.prod:  
ms.date: 02/28/2020 
ms.author: v-dasis 
ms.reviewer: JasonGerend 
---

# Manage virtual machines using Windows PowerShell

Windows PowerShell can be used to manage the virtual machines for all Azure Stack HCI servers running Windows Server 2019 Datacenter.

Alternatively, you can also manage virtual machines using Windows Admin Center from a Web browser. For more information, see [Managing virtual machines using Windows Admin Center]().

## Create a virtual machine using Windows PowerShell  

1. On the Windows desktop, click the Start button and type any part of the name **Windows PowerShell**.  

1. Right-click **Windows PowerShell** and select **Run as administrator**.  

1. Get the name of the virtual switch that you want the virtual machine to use by using [Get-VMSwitch](https://technet.microsoft.com/library/hh848499.aspx).  For example,  

   ```  
   Get-VMSwitch  * | Format-Table Name  
   ```  

4. Use the [New-VM](https://technet.microsoft.com/library/hh848537.aspx) cmdlet to create the  virtual machine.  See the following examples.  

   - **Existing virtual hard disk** - To create a virtual machine with an existing virtual hard disk, you can use the following command where,  
     - **-Name** is the name that you provide for the virtual machine that you're creating.  
     - **-MemoryStartupBytes** is the amount of memory   that is available to the virtual machine at start up.  
     - **-BootDevice** is the device that the virtual machine boots to  when it starts like the network adapter (NetworkAdapter) or virtual hard disk (VHD).  
     - **-VHDPath** is the path to the virtual machine disk that you want to use.  
     - **-Path** is the path to store the virtual machine configuration files.  
     - **-Generation** is the virtual machine generation. Use generation 1 for VHD and generation 2 for VHDX.
     - **-Switch** is the name of the virtual switch that you want the virtual machine to use to connect to other virtual machines or the network. See [Create a virtual switch for Hyper-V virtual machines](Create-a-virtual-switch-for-Hyper-V-virtual-machines.md).  

       ```  
       New-VM -Name <Name> -MemoryStartupBytes <Memory> -BootDevice <BootDevice> -VHDPath <VHDPath> -Path <Path> -Generation <Generation> -Switch <SwitchName>  
       ```  

       For example:  

       ```  
       New-VM -Name Win10VM -MemoryStartupBytes 4GB -BootDevice VHD -VHDPath .\VMs\Win10.vhdx -Path .\VMData -Generation 2 -Switch ExternalSwitch  
       ```  

       This creates a generation 2 virtual machine named Win10VM with 4GB of memory. It boots from the folder VMs\Win10.vhdx in the current directory and uses the virtual switch named ExternalSwitch. The virtual machine configuration files are stored in the folder VMData.  

   - **New virtual hard disk** - To create a virtual machine with a new virtual hard disk, replace the **-VHDPath** parameter from the example above  with  **-NewVHDPath** and add the **-NewVHDSizeBytes** parameter. For example,  

     ```  
     New-VM -Name Win10VM -MemoryStartupBytes 4GB -BootDevice VHD -NewVHDPath .\VMs\Win10.vhdx -Path .\VMData -NewVHDSizeBytes 20GB -Generation 2 -Switch ExternalSwitch  
     ```  

   - **New virtual hard disk that boots to operating system image** - To create a virtual machine with a new virtual disk that boots to an operating system image, see the PowerShell example in [Create virtual machine walkthrough for Hyper-V on Windows 10](https://msdn.microsoft.com/virtualization/hyperv_on_windows/quick_start/walkthrough_create_vm).  

5. Start the virtual machine by using the [Start-VM](https://technet.microsoft.com/library/hh848589.aspx) cmdlet. Run the following cmdlet where Name is the name of the  virtual machine you created.  

   ```  
   Start-VM -Name <Name>  
   ```  

   For example:  

   ```  
   Start-VM -Name Win10VM  
   ```  

6. Connect to the virtual machine by using Virtual Machine Connection (VMConnect).  

   ```  
   VMConnect.exe  
   ```  

## Next Steps  

- [New-VM](https://technet.microsoft.com/library/hh848537.aspx)  

-   [Create a virtual switch for Hyper-V virtual machines](Create-a-virtual-switch-for-Hyper-V-virtual-machines.md)  