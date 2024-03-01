---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 02/29/2024
---


- Make sure to review and [Complete the prerequisites](../hci/manage/azure-arc-vm-management-prerequisites.md).

- You have access to an Azure Stack HCI system that is deployed, has an Arc Resource Bridge and a custom location.

   - Go to the **Overview > Server** page in the Azure Stack HCI system resource. Verify that **Azure Arc** shows as **Connected**. You should also see a custom location and an Arc Resource Bridge for your cluster.
    
    :::image type="content" source="./media/hci-vm-image-prerequisites-local-share/azure-arc-connected.png" alt-text="Screenshot of the Overview page in the Azure Stack HCI cluster resource showing Azure Arc as connected." lightbox="./media/hci-vm-image-prerequisites-local-share/azure-arc-connected.png":::

- For custom images in a local share on your Azure Stack HCI, you'll have the following extra prerequisites:
    - You should have a VHD/VHDX uploaded to a local share on your Azure Stack HCI cluster.
    - The VHDX image must be Gen 2 type and secure boot enabled.
    - The VHDX image must be prepared using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options?view=windows-11#oobe&preserve-view=true).
    - The image should reside on a Cluster Shared Volume available to all the servers in the cluster. Both the Windows and Linux operating systems are supported.