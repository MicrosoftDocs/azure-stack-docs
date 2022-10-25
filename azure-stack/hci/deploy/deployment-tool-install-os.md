---
title: Install  Azure Stack HCI version 22H2 operating system
description: Learn how to install the  Azure Stack HCI version 22H2 operating system on each server of your cluster.
author: dansisson
ms.topic: how-to
ms.date: 10/25/2022
ms.author: v-dansisson
ms.reviewer: alkohli
---

# Install the  Azure Stack HCI version 22H2 operating system (preview)

> Applies to: Azure Stack HCI, version 22H2

The  Azure Stack HCI version 22H2 operating system (OS) is installed locally on each server in your cluster using a USB drive or other media that can boot from a VHDX file.

The installation includes an OS image and a deployment tool that allows a physical server to boot from a VHDX file. This is different from how Azure Stack HCI has been installed in the past. One folder is included with the installation: *Cloud*.

> [!IMPORTANT]
 > Please review the [Terms of Use](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) and agree to the terms before you deploy this solution.

## Prerequisites

Before you begin, make sure you have done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md)  for Azure Stack HCI version 22H2.
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.

## Files and folders

The *Cloud* folder contains the following files:

|File|Description|
|--|--|
|*CloudDeployment_*.zip*|Azure Stack HCI, version 22H2 content images and agents.|
|*BoostrapCloudDeploymentTool.ps1*|Hash script to extract content and launch the deployment tool. When this script is run with the `-ExtractOnly` parameter, it will extract the zip file but not launch the deployment tool.|
|*Verify-CloudDeployment_buildnumber.zip_Hash.ps1*|Hash used to validate the integrity of the .zip file.|


## Boot and install the OS

<!--You can configure boot from a VHDX file one of two ways:

**Native boot** – Follow the steps to [configure native boot from a VHDX or VHD file](/windows-hardware/manufacture/desktop/boot-to-vhd--native-boot--add-a-virtual-hard-disk-to-the-boot-menu) using the *ServerHCI.vhdx* file. This step requires a bootable WinPE image.

**BCD boot** - Boot configuration data (BCD) allows multiple boot entries and requires you to first install a Windows OS on the physical boot drive, which becomes the first boot entry. You then configure the VHDX boot, which becomes the second boot entry using the *ServerHCI.vhdx* file. 

If using BCD boot, complete the following steps:

1. Copy the *ServerHCI.vhdx* file to the physical boot drive of your server.
1. Run the following command as administrator to attach the VHDX file, select a volume, and assign a drive letter:

    ```powershell
    Diskpart
    Select vdisk file=c:\ServerHCI.vhdx
    Attach vdisk
    List volume
    Select volume 4
    Assign letter=v
    exit
    ```

1. Add a boot entry and run the following command:

    ```Bcdboot v:\windows```

An alternative to setting up multiple BCD entries manually is to use the [Azure Stack Development Kit installer](https://github.com/Azure/AzureStack-Tools/tree/master/Deployment).-->

You can install the operating system using the ISO as per the instructions in [Install OS manually on your Azure Stack HCI](./operating-system.md#manual-deployment). When manually installing the OS, a special disk partition layout is required:

| Disk partition         | Purpose                  |
|------------------------|--------------------------|
| Boot partition (C:)    |Used for the OS           |
| Data partition (D:)    |Used for logs, crash dump |


## Configure the OS using Sconfig

You can use [Sconfig](https://www.powershellgallery.com/packages/SCONFIG/2.0.1)to configure Azure Stack HCI version 22H2 after installation as follows:

1. Configure networking as per your environment:

1. Configure a default valid gateway and a DNS server.

1. Rename the server(s) using option 2 in Sconfig to match what you have used when preparing Active Directory, as you won’t rename the servers later.

1. Restart the servers.

1. Set the local administrator credentials to be identical across all servers.

1. Install the latest drivers and firmware as per the instructions provided by your hardware manufacturer. You can use Sconfig to run driver installation apps. After completed, restart your servers again.

## Install required Windows Roles 

Skip this step if deploying via the PowerShell. This step is required only if deploying via the deployment tool.

Install Hyper-V role. Run the following command: 

```azurepowershell
Install-WindowsFeature -Name Hyper-V -IncludeManagementTools -Restart
```

Your servers will restart and this will take a few minutes.

## Next steps

After installing the Azure Stack HCI version 22H2 OS, you are ready to install, configure, and run the deployment tool in Windows Admin Center. You can either create a new deployment configuration file interactively or use an existing configuration file you created:

- [Deploy using a new configuration file](deployment-tool-new-file.md).
- [Deploy using an existing configuration file](deployment-tool-existing-file.md).

If preferred, you can also [deploy using PowerShell](deployment-tool-powershell.md).