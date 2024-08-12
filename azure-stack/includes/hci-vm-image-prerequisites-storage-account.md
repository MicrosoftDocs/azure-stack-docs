---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 02/02/2024
---


- Make sure to review and [Complete the prerequisites](../hci/manage/azure-arc-vm-management-prerequisites.md).

- You have access to an Azure Stack HCI system that is deployed, has an Arc Resource Bridge and a custom location.

   - Go to the **Overview > Server** page in the Azure Stack HCI system resource. Verify that **Azure Arc** shows as **Connected**. You should also see a custom location and an Arc Resource Bridge for your cluster.
    
    :::image type="content" source="./media/hci-vm-image-prerequisites-storage-account/azure-arc-connected.png" alt-text="Screenshot of the Overview page in the Azure Stack HCI cluster resource showing Azure Arc as connected." lightbox="../hci/manage/media/virtual-machine-image-storage-account/azure-arc-connected.png":::

- For custom images in Azure Storage account, you have the following extra prerequisites:

    - You should have a VHD loaded in your Azure Storage account. See how to [Upload a VHD image in your Azure Storage account](/azure/databox-online/azure-stack-edge-gpu-create-virtual-machine-image?tabs=windows#copy-vhd-to-storage-account-using-azcopy).
    - If using a VHDX: 
        - The VHDX image must be Gen 2 type and secure boot enabled.
        - The VHDX image must be prepared using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options?view=windows-11#oobe&preserve-view=true).