---
title: Move a specialized VM from on-premises to Azure Stack Hub
description: Learn how to move a specialized VM from on-premises to Azure Stack Hub.
author: mattbriggs
ms.topic: how-to
ms.date: 12/16/2020
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 9/8/2020

# Intent: As an Azure Stack Hub user, I want to move my specific workload VM into Azure Stack Hub so that I can use my applications.
# Keywords: migration workload specialized VM

---

# Move a specialized VM from on-premises to Azure Stack Hub

You can add a virtual machine (VM) image from your on-premises environment. You can create your image as a virtual hard disk (VHD) and upload the image to a storage account in your Azure Stack Hub instance. You can then create a VM from the VHD.

A specialized disk image is a copy of a virtual hard disk (VHD) from an existing VM that contains the user accounts, applications, and other state data from your original VM. This is typically the format in which VMs are migrated to Azure Stack Hub. Specialized VHDs are a good fit for when you need to migrate VMs from on-premises to Azure Stack Hub.

## How to move an image

Find the section that that is specific to your needs when preparing your VHD.

#### [Windows VM](#tab/port-win)

- Follow the steps in [Prepare a Windows VHD or VHDX to upload to Azure](/azure/virtual-machines/windows/prepare-for-upload-vhd-image) to prepare the VHD correctly. You must use a VHD for Azure Stack Hub.
   > [!NOTE]  
   > **Do not** generalize the VM by using Sysprep.
- Remove any guest virtualization tools and agents that are installed on the VM (such as VMware tools).
- Make sure the VM is configured to get the IP address and DNS settings from DHCP. This ensures that the server obtains an IP address within the virtual network when it starts up.
- Make sure the RDP/SSH is enabled and the firewall allows communication.
- To deploy VM extensions, make sure that the VM agent `.msi` available. For guidance, see [Azure Virtual Machine Agent overview](/azure/virtual-machines/extensions/agent-windows). If the VM agent is not present in the VHD, extension deployment will fail. You do not need to set the OS profile while provisioning, or set `$vm.OSProfile.AllowExtensionOperations = $true`.

#### [Linux VM](#tab/port-linux)

#### Generalize the VHD

Follow the appropriate instructions to prepare the VHD for your Linux OS:

- [CentOS-based Distributions](/azure/virtual-machines/linux/create-upload-centos?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Debian Linux](/azure/virtual-machines/linux/debian-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Red Hat Enterprise Linux](../operator/azure-stack-redhat-create-upload-vhd.md)
- [SLES or openSUSE](/azure/virtual-machines/linux/suse-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Ubuntu Server](/azure/virtual-machines/linux/create-upload-ubuntu?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)

> [!IMPORTANT]
> Do not run the last step: (`sudo waagent -force -deprovision`) as this will generalize the VHD.

#### Identify the version of the Linux Agent

Identify what version of Linux Agent is installed in the source VM image, run the following commands. The version number that describes the provisioning code is `WALinuxAgent-`, not the `Goal state agent`:

   ```bash  
   waagent -version
   ```
    
   For example:
    
   ```bash  
   waagent -version
   WALinuxAgent-2.2.45 running on centos 7.7.1908
   Python: 2.7.5
   Goal state agent: 2.2.46
   ```

#### Linux Agent 2.2.4 and earlier, disable the Linux Agent provisioning 

Disable the Linux Agent provisioning with Linux Agent lower than 2.2.4, set the following parameters in **/etc/waagent.conf**: `Provisioning.Enabled=n, and Provisioning.UseCloudInit=n`.

#### Linux Agent 2.2.45 and later, disable the Linux Agent provisioning

To disable provisioning with Linux Agent 2.2.45 and later, make the following configuration option changes:

`Provisioning.Enabled` and `Provisioning.UseCloudInit` are now ignored.

In this version, currently there is no `Provisioning.Agent` option to disable provisioning completely; however, you can add the provisioning marker file, and with the following settings, provisioning is ignored:

1. In **/etc/waagent.conf** add this configuration option: `Provisioning.Agent=Auto`.
2. To ensure walinuxagent provisioning is disabled, run: `mkdir -p /var/lib/waagent && touch /var/lib/waagent/provisioned`.
3. Disable cloud-init install by running the following:

   ```bash  
   touch /etc/cloud/cloud-init.disabled
   sudo sed -i '/azure_resource/d' /etc/fstab
   ```

4. Log out.

#### Run an extension

1. Set the following parameter in **/etc/waagent.conf**:

   - `Provisioning.Enabled=n`
   - `Provisioning.UseCloudInit=n`

2. To ensure walinuxagent provisioning is disabled, run: `mkdir -p /var/lib/waagent && touch /var/lib/waagent/provisioned`

3. If you have cloud-init in your image, disable cloud init:

    ```bash  
   touch /etc/cloud/cloud-init.disabled
   sudo sed -i '/azure_resource/d' /etc/fstab
   ```

4. Execute a logout.

---

## Verify your VHD

[!INCLUDE [Verify VHD](../includes/user-compute-verify-vhd.md)]

## Upload to a storage account

[!INCLUDE [Upload to a storage account](../includes/user-compute-upload-vhd.md)]

## Create the disk in Azure Stack Hub

[!INCLUDE [Create the disk in Azure Stack Hub](../includes/user-compute-create-disk.md)]

## Next steps

[Move a VM to Azure Stack Hub Overview](vm-move-overview.md)
