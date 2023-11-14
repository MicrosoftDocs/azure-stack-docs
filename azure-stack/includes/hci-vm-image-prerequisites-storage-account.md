---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 11/06/2023
---


- You have your Microsoft account with credentials to access Azure portal.

- You have access to an Azure Stack HCI cluster. This cluster is deployed, registered, and connected to Azure Arc.

   - Go to the **Overview** page in the Azure Stack HCI cluster resource. On the **Server** tab in the right-pane, the **Azure Arc** should show as **Connected**.
    
    :::image type="content" source="../hci/manage/media/manage-vm-resources/azure-arc-connected.png" alt-text="Screenshot of the Overview page in the Azure Stack HCI cluster resource showing Azure Arc as connected." lightbox="../hci/manage/media/manage-vm-resources/azure-arc-connected.png":::

- To enable Azure Arc VMs on your Azure Stack HCI, see [Deploying Azure Arc resource bridge](/azure-stack/hci/manage/azure-arc-vm-management-overview#azure-arc-resource-bridge-deployment-overview). As a part of Arc Resource Bridge deployment, you'll also create a custom location for your Azure Stack HCI cluster that you use later in the scenario. The custom location will also show up in the **Overview** page for Azure Stack HCI cluster.

- For custom images in Azure Storage account, you have the following extra prerequisites:

    - You should have a VHD loaded in your Azure Storage account. See how to [Upload a VHD image in your Azure Storage account](/azure/databox-online/azure-stack-edge-gpu-create-virtual-machine-image?tabs=windows#copy-vhd-to-storage-account-using-azcopy).
    - If using a VHDX: 
        - The VHDX image must be Gen 2 type and secure boot enabled.
        - The VHDX image must be prepared using `sysprep /generalize /shutdown /oobe`. For more information, see [Sysprep command-line options](/windows-hardware/manufacture/desktop/sysprep-command-line-options?view=windows-11#oobe&preserve-view=true).