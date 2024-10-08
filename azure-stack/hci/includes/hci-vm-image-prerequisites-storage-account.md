---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 07/18/2024
---


- Make sure to review and [complete the prerequisites](../hci/manage/azure-arc-vm-management-prerequisites.md).


- For custom images in Azure Storage account, you have the following extra prerequisites:

    - You should have a VHD loaded in your Azure Storage account. See how to [Upload a VHD image in your Azure Storage account](/azure/databox-online/azure-stack-edge-gpu-create-virtual-machine-image?tabs=windows#copy-vhd-to-storage-account-using-azcopy).
    - If using a VHDX: 
        - The VHDX image must be Gen 2 type and secure boot enabled.
        - The VHDX image must be prepared using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options?view=windows-11#oobe&preserve-view=true).