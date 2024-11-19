---
author: alkohli
ms.author: alkohli
ms.service: azure-stack-hci
ms.topic: include
ms.date: 10/22/2024
---


- Make sure to review and [complete the prerequisites](../manage/azure-arc-vm-management-prerequisites.md).

- For custom images in a local share on your Azure Local, you'll have the following extra prerequisites:
    - You should have a VHD/VHDX uploaded to a local share on your system.
    - The VHDX image must be Gen 2 type and secure boot enabled.
    - The VHDX image must be prepared using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options?view=windows-11#oobe&preserve-view=true).
    - The image should reside on a cluster shared volume available to all the machines in the instance. Both the Windows and Linux operating systems are supported.