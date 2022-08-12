---
title: Install Azure Stack HCI version 22H2
description: Learn how to install Azure Stack HCI version 22H2 preview from a boot image
author: dansisson
ms.topic: how-to
ms.date: 08/23/2022
ms.author: v-dansisson
ms.reviewer: jgerend
---

# Install Azure Stack HCI version 22H2

> Applies to: Azure Stack HCI, version 22H2 (preview)

The Azure Stack HCI, version 22H2 Preview operating system (OS) is installed locally using a a USB drive or other media that can boot from a VHDX file.

The installation includes an OS image and a deployment tool that allows a physical server to boot from a VHDX file. This is different from how Azure Stack HCI has been installed in the past. Two folders are included with the installation: *Cloud* and *Image*.

## Files and folders

The *Cloud* folder contains the following files:

|File|Description|
|--|--|
|*CloudDeployment_*.zip*|Azure Stack HCI, version 22H2 content images and agents.|
|*BoostrapCloudDeploymentTool.ps1*|Hash script to extract content and launch the deployment tool. When this script is run with the `-ExtractOnly` parameter, it will extract the zip file but not launch the deployment tool.|
|*Verify-CloudDeployment_buildnumber.zip_Hash.ps1*|Hash used to validate the integrity of the .zip file.|

The *Image* folder contains the following files:

|File|Description|
|--|--|
|*ServerHCI.vhdx*|Azure Stack HCI, version 22H2 preview OS image|
|*Verify-ServerHCI.vhdx_Hash.ps1*|Script that verifies the integrity of the OS image.|

## Boot and install the OS

You can configure boot from a VHDX file one of two ways:

**Native boot** – Follow the steps to [configure native boot from a VHDX or VHD file](https://docs.microsoft.com/windows-hardware/manufacture/desktop/boot-to-vhd--native-boot--add-a-virtual-hard-disk-to-the-boot-menu) using the *ServerHCI.vhdx* file. This step requires a bootable WinPE image.

**BCD boot** - Boot configuration data (BCD) allows multiple boot entries and requires you to first install a Windows OS on the physical boot drive, which becomes the first boot entry. You then configure the VHDX boot, which becomes the second boot entry using the *ServerHCI.vhdx* file. 

If using BCD boot, complete the following steps:

1. Copy the *ServerHCI.vhdx* file to the physical boot drive of your server.
1. From a command prompt, run the following to attach the VHDX file, select a volume, and assign a drive letter:

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

An alternative to setting up multiple BCD entries manually is to use the [Azure Stack Development Kit installer](https://github.com/Azure/AzureStack-Tools/tree/master/Deployment).

## Configure the OS using Sconfig

You can use [Sconfig](https://www.powershellgallery.com/packages/SCONFIG/2.0.1)to configure Azure Stack HCI version 22H2 after installation as follows.

1. Configure networking as per your environment:

    - **Single node**. If using a single node in your system, the the last octet of the IPv4 address must be .92 if you are using a /25 network size.  If you are using a different subnet, for example, the second half of a /24 network, then the IPv4 address must be .220.

        *Example 1*:  If your management subnet is 192.168.1.0/25, configure the static IP address as 192.168.1.92 with a subnet mask of 255.255.255.128.

        *Example 2*: If your management subnet is 192.168.1.128/25, configure the static IP address as  192.168.1.22 with a subnet mask of 255.255.255.128.

    - **Two nodes**. If using two nodes in your system, the first host must use .92 as the last octet of the IPv4 address, while the second node must use .93. If you are using a different subnet, for example, the second half of a /24 network the IPv4 address must be .220 for the first host and .221 for the second host.

        *Example 3*: If your management subnet is 192.168.1.0/25, configure 192.168.1.92 as the static IP address for the first node and 192.168.1.93 as the IP address for the second node. In both cases, configure a subnet mask of 255.255.255.128.

        *Example 4*:  If your management subnet is 192.168.1.128/25, configure 192.168.1.220 as the static IP address for the first node and 192.168.1.221 as the IP address for the second node. In this case, configure a subnet mask of 255.255.255.128.

1. Configure a default valid gateway and a DNS server.

1. Rename the server(s) using option 2 in Sconfig as needed, as you won’t rename the servers later.

1. Restart the servers.

1. Set the local administrator credentials to be identical across all servers.

1. Install latest drivers and firmware as per the instructions provided by your hardware manufacturer. You can Sconfig to run driver installation apps. After completed, restart the servers again.

## Next step

After installing the Azure Stack HCI version 22H2 OS, you are ready to install and use the deployment tool in Windows Admin Center to set up your cluster. You can either create a new deployment configuration file or use an existing configuration file:

- [Deploy using a new configuration file](deployment-tool-new-file.md)
- [Deploy using an existing configuration file](deployment-tool-existing-file.md)

If applicable for your environment, you can also [deploy using PowerShell](deployment-tool-powershell.md)