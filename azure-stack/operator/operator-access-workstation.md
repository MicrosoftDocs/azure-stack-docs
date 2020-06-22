---
title: Azure Stack Hub Operator Access Workstation
titleSuffix: Azure Stack Hub
description: Learn how to download and configure an Azure Stack Hub Operator Access Workstation.
author: asganesh
ms.topic: article
ms.date: 06/22/2020
ms.author: justinha
ms.reviewer: asganesh
ms.lastreviewed: 06/22/2020

# Intent: As an Azure Stack operator, I want to download and configure an Azure Stack Hub Operator Access Workstation.
# Keyword: azure stack hub operator access workstation

---

# Azure Stack Hub Operator Access Workstation (Preview Only)

The Operator Access Workstation (OAW) is used to deploy a jump box virtual machine (VM) on the Hardware Lifecycle Host (HLH) so an Azure Stack Hub operator can access the privileged endpoint (PEP) and the Administrator portal for support scenarios. The HLH version must run version 2005 or later. 

The OAW VM should be created when an operator performs a new task. After a required task inside the VM is completed, the VM should be shut down and removed as Azure Stack Hub doesn't need to always run it.  

Due to the stateless nature of the solution, there are no updates for the OAW VM. For each milestone, a new version of the VM image file will be released. Use the latest version to create a new OAW VM. The image file is based on the latest Windows Server 2019 version. After installation, you can apply updates, including any critical updates, using Windows Update. 

Please be sure to review the [Microsoft Privacy Statement](https://privacy.microsoft.com/privacystatement) and [Legal Terms](https://aka.ms/OAW) prior to download.

You can download the necessary files to create the OAW VM for the preview from [here](https://aka.ms/OAW).

The following user account policy is applied to the OAW VM: 

- Built-in Administrator username: AdminUser
- MinimumPasswordLength = 14
- PasswordComplexity is enabled
- MinimumPasswordAge = 1 (day)
- MaximumPasswordAge = 42 (days)
- NewGuestName = GUser (disabled by default)

The following table lists the pre-installed software on the OAW VM.

| Software Name           | Location                                                                                       |
|--------------------------|------------------------------------------------------------------------------------------------|
| [Microsoft Edge for Business](https://www.microsoft.com/edge/business/)                                            | \[SystemDrive\]\Program Files (x86)\Microsoft\Edge\Application                                                                                        |
| [Az Modules](https://docs.microsoft.com/azure-stack/operator/powershell-install-az-module)                         | \[SystemDrive\]\ProgramFiles\WindowsPowerShell\Modules                                         |  
| [Powershell 7](https://devblogs.microsoft.com/powershell/announcing-PowerShell-7-0/)| \[SystemDrive\]\Program Files\PowerShell\7                                                                       |
| [Azure Command-Line Interface (CLI)](https://docs.microsoft.com/cli/azure/?view=azure-cli-latest) | \[SystemDrive\]\Program Files (x86)\Microsoft SDKs\Azure\CLI2 |
| [Microsoft Azure Storage Explorer](https://azure.microsoft.com/features/storage-explorer/)   | \[SystemDrive\]\Program Files (x86)\Microsoft Azure Storage Explorer                                                                       |
| [AzCopy](https://docs.microsoft.com/azure/storage/common/storage-use-azcopy-v10)                             | \[SystemDrive\]\VMSoftware\azcopy_windows_amd64_10.3.4                                         |
| [AzureStack-Tools](https://github.com/Azure/AzureStack-Tools/tree/az)                  | \[SystemDrive\]\VMSoftware\AzureStack-Tools                                                    |

## Check HLH version

1. Log onto the HLH with your credentials.
1. Open PowerShell ISE and run the following script:

   ```powershell
   'C:\Version\Get-Version.ps1'
   ```

   For example:

   ![Screenshot of PowerShell cmdlet to check the version of the OAW VM](./media/operator-access-workstation/check-hardware-lifecycle-host-version.png)

## Create the OAW VM using a script

The following script prepares the virtual machine as the Operator Access Workstation (OAW), which is used to access Microsoft Azure Stack Hub for administration and diagnostics.

1. Log onto the HLH with your credentials
1. Download OAW.zip and extract the files.
1. Open an elevated PowerShell session.
1. Navigate to the extracted contents of the OAW.zip file.
1. Run the New-OAW.ps1 script. The following two parameter sets are available for New-OAW, with optional parameters shown in brackets:

   ```powershell
   -LocalAdministratorPassword <Security.SecureString> [-AzureStackCertificatePath <String>] [-ERCSVMIP <String[]>] [-DNS <String[]>] [-DeploymentDataFilePath <String>] [-SkipNetworkConfiguration] [-UseDVMConfiguration] [-ImageFilePath <String>] [-VirtualMachineName <String>] [-VirtualMachineMemory <int64>] [-VirtualProcessorCount <int>] [-VirtualMachineDiffDiskPath <String>] [-PhysicalAdapterMACAddress <String>] [-VirtualSwitchName <String>] [-ReCreate] [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
   ```

   ```powershell
   -LocalAdministratorPassword <Security.SecureString> -IPAddress <String> -SubnetMask <String> -DefaultGateway <String> -DNS <String[]> [-AzureStackCertificatePath <String>] [-ERCSVMIP <String[]>] [-ImageFilePath <String>] [-VirtualMachineName <String>] [-VirtualMachineMemory <int64>] [-VirtualProcessorCount <int>] [-VirtualMachineDiffDiskPath <String>] [-PhysicalAdapterMACAddress <String>] [-VirtualSwitchName <String>] [-ReCreate] [-AsJob] [-Passthru] [-WhatIf] [-Confirm] [<CommonParameters>]
   ```

   For example, to create the OAW VM on the HLH without any customization using Azure Stack Hub version 2005 or later, run the New-OAW.ps1 script with only the **-LocalAdministratorPassword** parameter:

   ```powershell
   $securePassword = Read-Host -Prompt "Enter password for Azure Stack OAW's local administrator" -AsSecureString
   New-OAW.ps1 -LocalAdministratorPassword $securePassword  
   ```

The following table lists the definition for each parameter.

| Parameter   | Description       |
|-------------|-------------------|
| LocalAdministratorPassword | Password for the virtual machine's local administrator account AdminUser. |
| AzureStackCertificatePath  | Optional parameter; path of certificates to be imported to the virtual machine for Azure Stack Hub access. |
| ERCSVMIP                   | Optional parameter; IP of Azure Stack Hub ERCS VM(s) to be added to trusted host list of the virtual machine. Won't take effect if **-SkipNetworkConfiguration** is set. |
SkipNetworkConfiguration     | Optional parameter; use this flag to skip network configuration for the virtual machine, user can configure later. |
| UseDVMConfiguration        | Optional parameter; use this flag to apply Azure Stack Hub deployment virtual machine (DVM) network configuration. Won't take effect if **-SkipNetworkConfiguration** is set.|
| DeploymentDataFilePath     | Optional parameter; path of DeploymentData.json. Won't take effect if **-SkipNetworkConfiguration** is set.            |
| IPAddress                  | The static IPv4 address to configure TCP/IP on the virtual machine.                                                |
| SubnetMask                 | The IPv4 subnet mask to configure TCP/IP on the virtual machine.                                                   |
| DefaultGateway             | IPv4 address of the default gateway to configure TCP/IP on the virtual machine.                                    |
| DNS                        | DNS server(s) to configure TCP/IP on the virtual machine.                                                          |
| ImageFilePath              | Path of OAW.vhdx provided by Microsoft. Optional parameter; default value is **OAW.vhdx** under the same parent folder of this script. |
| VirtualMachineName         | The name to be assigned to the virtual machine. Optional parameter; default value is **AzSOAW**.                       |
| VirtualMachineMemory       | Memory to be assigned to the virtual machine. Optional parameter; default value is **4GB**.                            |
| VirtualProcessorCount      | Number of virtual processors to be assigned to the virtual machine. Optional parameter; default value is **8**.        |
| VirtualMachineDiffDiskPath | Path to store temporary diff disk files while the management VM was active. Optional parameter; default value is **DiffDisks** subdirectory under the same parent folder of this script. |
| PhysicalAdapterMACAddress  | Optional parameter; the MAC address of the host's network adapter that will be used to connect the virtual machine to.<br>- If there is only one physical network adapter, this parameter is not needed and the only network adapter will be used.<br>- If there is more than one physical network adapter, this parameter is required to specify which one to use.<br> |
| VirtualSwitchName          | Optional parameter; the name of virtual switch that needs to be configured in HyperV for the virtual machine.<br>- If there is VMSwitch with the provided name, such VMSwitch will be selected.<br>- If there is only one VMSwitch with switch type External, value **DVMVirtualSwitch** can be used to select this VMSwitch without providing its name.<br>- If there is no VMSwitch with the provided name, a VMSwitch will be created with the provided name.<br> |
| ReCreate                   | Optional parameter; use this flag to remove and re-create the virtual machine if there is already an existed virtual machine with the same name. |

 ### Examples

To create the OAW VM on the HLH without any customization using Azure Stack Hub version 2005 or later, run the New-OAW.ps1 script with the following parameters:

   ```powershell
   $securePassword = Read-Host -Prompt "Enter password for Azure Stack OAW's local administrator" -AsSecureString
   New-OAW.ps1 -LocalAdministratorPassword $securePassword   
   ```

To create the OAW VM on the HLH with DeploymentData.json, run the New-OAW.ps1 script with the following parameters:

   ```powershell
   $securePassword = Read-Host -Prompt "Enter password for Azure Stack OAW's local administrator" -AsSecureString
   New-OAW.ps1 -LocalAdministratorPassword $securePassword `
      -DeploymentDataFilePath 'D:\AzureStack\DeploymentData.json'
   ```

To create the OAW VM on a host with network connection to Azure Stack Hub, run the New-OAW.ps1 script with the following parameters:

   ```powershell
   $securePassword = Read-Host -Prompt "Enter password for Azure Stack OAW's local administrator" -AsSecureString
   New-OAW.ps1 -LocalAdministratorPassword $securePassword `
      -IPAddress '192.168.0.20' `
      -SubnetMask '255.255.255.0' `
      -DefaultGateway '192.168.0.1' `
      -DNS '192.168.0.10'
   ```

## Check the OAW VM version

1. Log onto the OAW VM with your credentials.
1. Open PowerShell ISE and run the following script:

   ```powershell
   'C:\Version\Get-Version.ps1'
   ```

   For example:

   ![Screenshot of PowerShell cmdlet to check the Hardware LifeCycle Host version](./media/operator-access-workstation/check-operator-access-workstation-vm-version.png)


## Remove the OAW VM

The following script removes the OAW VM, which is used to access Azure Stack Hub for administration and diagnostics. This script also removes the disk files and the guardian associated with the VM.

1. Log onto the HLH with your credentials.
1. Open an elevated PowerShell session. 
1. Navigate to the extracted contents of the installed OAW.zip file.
1. Remove the VM by running the Remove-OAW.ps1 script: 

   ```powershell
   Remove-OAW.ps1 -VirtualMachineName <name>
   ```

   Where \<name\> is the name of the virtual machine to be removed. By default, the name is **AzSOAW**.

   For example:

   ```powershell
   Remove-OAW.ps1 -VirtualMachineName AzSOAW
   ```

