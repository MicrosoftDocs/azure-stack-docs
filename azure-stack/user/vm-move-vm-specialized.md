---
title: ove a specialized VM from on-premises to Azure Stack Hub
description: Learn how to move a specialized VM from on-premises to Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 8/18/2020
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 8/18/2020

# Intent: As an Azure Stack Hub user, I wan to learn about how where to find more information developing solutions.
# Keywords: Develop solutions with Azure Stack Hub

---

# Move a specialized VM from on-premises to Azure Stack Hub

You can add a virtual machine (VM) image from your on-premises environment. YOu can create your image as a virtual hard disk (VHD) and upload the image to a storage account in your Azure Stack Hub instance. You can then create a VM from the VHD.

## How to move an image

#### [Portal - Windows VM](#tab/port-win)

Follow the steps [here](/azure/virtual-machines/windows/create-vm-specialized#prepare-the-vm) to prepare the VHD correctly.
To deploy VM extensions, make sure that the VM agent .msi available [in this article](/azure/virtual-machines/extensions/agent-windows#manual-installation) is installed in the VM before VM deployment. If the VM agent is not present in the VHD, extension deployment will fail. You do not need to set the OS profile while provisioning, or set `$vm.OSProfile.AllowExtensionOperations = $true`.


#### [Portal - Linux VM](#tab/port-linux)

Step 1: Follow the appropriate instructions to make the VHD suitable for Azure. Use this article until the step to install the Linux agent, and then proceed to step 2 before installing the agent:

- [CentOS-based Distributions](/azure/virtual-machines/linux/create-upload-centos?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Debian Linux](/azure/virtual-machines/linux/debian-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Red Hat Enterprise Linux](../operator/azure-stack-redhat-create-upload-vhd.md)
- [SLES or openSUSE](/azure/virtual-machines/linux/suse-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Ubuntu Server](/azure/virtual-machines/linux/create-upload-ubuntu?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)

> [!IMPORTANT]
> Do not run the last step: (`sudo waagent -force -deprovision`) as this will generalize the VHD.

Step 2: If a Linux specialized VHD is brought from outside of Azure to Azure Stack Hub, to run VM extensions and disable provisioning do the following:

To identify what version of Linux Agent is installed in the source VM image, run the following commands. The version number that describes the provisioning code is `WALinuxAgent-`, not the `Goal state agent`:

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

To disable the Linux Agent provisioning with Linux Agent lower than 2.2.4, set the following parameters in **/etc/waagent.conf**: `Provisioning.Enabled=n, and Provisioning.UseCloudInit=n`.

In scenarios in which you want to run extensions:

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

To disable provisioning with Linux Agent 2.2.45 and later, make the following configuration option changes:

- `Provisioning.Enabled` and `Provisioning.UseCloudInit` are now ignored.

In this version, currently there is no `Provisioning.Agent` option to disable provisioning completely; however, you can add the provisioning marker file, and with the following settings, provisioning is ignored:

1. In **/etc/waagent.conf** add this configuration option: `Provisioning.Agent=Auto`.
2. To ensure walinuxagent provisioning is disabled, run: `mkdir -p /var/lib/waagent && touch /var/lib/waagent/provisioned`.
3. Disable cloud-init install by running the following:

   ```bash
   touch /etc/cloud/cloud-init.disabled
   sudo sed -i '/azure_resource/d' /etc/fstab
   ```

4. Log out.

#### [PowerShell - Windows VM](#tab/ps-win)

This is a stub.

#### [PowerShell - Linux VM](#tab/ps-linux)

This is a stub.

---

## Upload to a storage account

[!INCLUDE [Upload to a storage account](../includes/user-compute-upload-vhd.md)]

## Create the image in Azure Stack Hub

[!INCLUDE [Create the image in Azure Stack Hub](../includes/user-compute-create-image.md)]

## Next steps

[Move a VM to Azure Stack Hub Overview](vm-move-overview.md)
