---
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.topic: include
ms.date: 07/08/2025
---


- Make sure to review and [complete the prerequisites](../manage/azure-arc-vm-management-prerequisites.md).


- For custom images in Azure Storage account, you have the following extra prerequisites:

    - You should have a VHD loaded in your Azure Storage account. See how to [Upload a VHD image in your Azure Storage account](/azure/databox-online/azure-stack-edge-gpu-create-virtual-machine-image?tabs=windows#copy-vhd-to-storage-account-using-azcopy).
    - Make sure that you're uploading your VHD or VHDX as a page blob image into the Storage account. Only page blob images are supported to create VM images via the Storage account.
    - If using a VHDX: 
        - The VHDX image must be Gen 2 type and secure boot enabled.
        - The VHDX image must be prepared using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options?view=windows-11#oobe&preserve-view=true). This is true for both Windows and Linux VM images.ea