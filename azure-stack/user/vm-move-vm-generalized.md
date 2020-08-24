---
title: Move a generalized VM from on-premises to Azure Stack Hub
description: Learn how to move a generalized VM from on-premises to Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 8/18/2020
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 8/18/2020

# Intent: As an Azure Stack Hub user, I wan to learn about how where to find more information developing solutions.
# Keywords: Develop solutions with Azure Stack Hub

---

# Move a generalized VM from on-premises to Azure Stack Hub

You can add a virtual machine (VM) image from your on-premises environment. You can create your image as a virtual hard disk (VHD) and upload the image to a storage account in your Azure Stack Hub instance. You can then create a VM from the VHD.

## How to move an image

Find the section that that is specific to your needs when preparing your VHD.

#### [Windows VM](#tab/port-win)

Follow the steps in [Prepare a Windows VHD or VHDX to upload to Azure](/azure/virtual-machines/windows/prepare-for-upload-vhd-image) to correctly generalize your VHD prior to uploading.

#### [Linux VM](#tab/port-linux)

Follow the appropriate instructions to generalize the VHD for your Linux OS:

- [CentOS-based Distributions](/azure/virtual-machines/linux/create-upload-centos?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Debian Linux](/azure/virtual-machines/linux/debian-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Red Hat Enterprise Linux](../operator/azure-stack-redhat-create-upload-vhd.md)
- [SLES or openSUSE](/azure/virtual-machines/linux/suse-create-upload-vhd?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)
- [Ubuntu Server](/azure/virtual-machines/linux/create-upload-ubuntu?toc=%2fazure%2fvirtual-machines%2flinux%2ftoc.json)

---

## Upload to a storage account

[!INCLUDE [Upload to a storage account](../includes/user-compute-upload-vhd.md)]

## Create the image in Azure Stack Hub

[!INCLUDE [Create the image in Azure Stack Hub](../includes/user-compute-create-image.md)]

## Next steps

[Move a VM to Azure Stack Hub Overview](vm-move-overview.md)
