---
title: Move a generalized VM from on-premises to Azure Stack Hub
description: Learn how to move a generalized VM from on-premises to Azure Stack Hub.
author: mattbriggs
ms.topic: how-to
ms.date: 9/8/2020
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 9/8/2020

# Intent: As an Azure Stack Hub user, I want to move my generalized workload VM into Azure Stack Hub so that I can use my applications.
# Keywords: migration workload  generalized VM

---

# Move a generalized VM from on-premises to Azure Stack Hub

You can add a virtual machine (VM) image from your on-premises environment. You can create your image as a virtual hard disk (VHD) and upload the image to a storage account in your Azure Stack Hub instance. You can then create a VM from the VHD.

A generalized disk image is one that has been prepared with **Sysprep** to remove any unique information (such as user accounts), enabling it to be reused to create multiple VMs. Generalized VHDs are a good fit for when are creating images that the Azure Stack Hub cloud operator plans to use as marketplace items.

## How to move an image

Find the section that that is specific to your needs when preparing your VHD.

#### [Windows VM](#tab/port-win)

Follow the steps in [Prepare a Windows VHD or VHDX to upload to Azure](/azure/virtual-machines/windows/prepare-for-upload-vhd-image) to correctly generalize your VHD prior to uploading. You must use a VHD for Azure Stack Hub.

#### [Linux VM](#tab/port-linux)

Follow the appropriate instructions to generalize the VHD for your Linux OS:

- [CentOS-based Distributions](/azure/virtual-machines/linux/create-upload-centos?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Debian Linux](/azure/virtual-machines/linux/debian-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Red Hat Enterprise Linux](../operator/azure-stack-redhat-create-upload-vhd.md)
- [SLES or openSUSE](/azure/virtual-machines/linux/suse-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Ubuntu Server](/azure/virtual-machines/linux/create-upload-ubuntu?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)

---

## Verify your VHD

[!INCLUDE [Verify VHD](../includes/user-compute-verify-vhd.md)]
## Upload to a storage account

[!INCLUDE [Upload to a storage account](../includes/user-compute-upload-vhd.md)]

## Create the image in Azure Stack Hub

[!INCLUDE [Create the image in Azure Stack Hub](../includes/user-compute-create-image.md)]

## Next steps

[Move a VM to Azure Stack Hub Overview](vm-move-overview.md)
