---
title: Server firmware updates in Azure Stack Hub Ruggedized
description: Describes how to perform server firmware updates in Azure Stack Hub Ruggedized
author: sethmanheim
ms.topic: article
ms.date: 05/06/2021
ms.author: sethm
ms.reviewer: thoroet
ms.lastreviewed: 05/06/2021

# Intent: As an Azure Stack
# Keyword: 

---

# Server firmware updates

This article describes the process to update the server firmware for an Azure Stack Hub Ruggedized deployment.

Task is executed by: **Operator**

## Configure credentials and network settings

Requirements: BMC factory credentials (username/password: changeme/changeme).

1. Sign in to the hardware lifecycle host.
1. Launch PowerShell ISE with elevated permission.
1. Assign IP address to the physical machine by running the following script:

   ```powershell
   Import-module c:\firmware\OEMFirmwareBootstrap.psd1
   Set-AzsBMCNetwork -FRUNode
   ```

1. Install Identity module. The BIOS and iDRAC need to restart for the changes to take effect.

   ```powershell
   Apply-AzsBMCIdentityModule -FRU
   ```

1. Assign IP address to the physical machine by running the following script, because the identity module update will clear that setting:

   ```powershell
   Set-AzsBMCNetwork -FRUNode
   ```

1. Update the BMC credentials to match the existing nodes in the scale unit. The previous command output shows the IP address assigned to the BMC.

   ```powershell
   $BMCIPAddress = "X.X.X.X"
   $oldcredentials = get-credentials
   $newcredentials = get-credentials
   Set-AzsSingleBMCUserPassword -BMCIPAddress $BMCIPAddress -BmcCredentials $oldcredentials -NewBmcCredentials $newcredentials
   ```

## Update firmware

Requirements: OEM update package.

Before you continue, make sure you have the OEM update package available that is currently applicable to your system. You can validate this using the administrator portal to compare the versions.

1. Sign in to the hardware lifecycle host.
2. Extract the OEM update package to **C:\OEMPackage**.
3. Launch PowerShell ISE with elevated permissions.
4. Run the following script. Update the `servername` and `HostBmcIpAddress` values to match the BMC server and IP address for your environment before executing the script. The script will also ask for the BMC credentials that you configured when applying the baseline to the physical machine. The name that you provide in the script must be unique, as it will be used to create a temporary local user account on the HLH for accessing the firmware files:

   ```powershell
   $ErrorActionPreference = [System.Management.Automation.ErrorActionPreference]::Stop
   try {
       $updateParams = @{
           HostData = @{
               Role = 'BareMetal'
               Name = 'servername'
               HostBmcIpAddress = '192.168.0.100'
           }
           BmcCredential = Get-Credential
           FirmwarePath = 'C:\OEMPackage\Version\Firmware"
           FirmwareJson = Get-Content -Path "$FirmwarePath\Firmware.json" -Raw
       }
       Import-Module "$($updateParams.FirmwarePath)\OEMFirmwareUpdate.psd1"
       Update-OEMFirmware @updateParams -NoReboot
       Invoke-OEMFirmwarePostUpdate @updateParams
   }
   catch {
       Write-Error $_.Exception.Message
   }
   ```

Wait for the script to be finished before you proceed.

## Apply BIOS and BMC settings baseline

Task is executed by: **Operator**

1. Logon to the hardware lifecycle host.
2. Launch PowerShell ISE with elevated permission.
3. Apply the Bios and BMC baseline settings using the following script:

   ```powershell
   Import-AzsBmcBiosConfigonNodes -FRU -BMCIPAddress $BMCIPAddress -BmcCredentials $newcredentials
   ```

## Next steps

[Add scale unit nodes in Azure Stack Hub - Ruggedized](add-scale-node-ruggedized.md)