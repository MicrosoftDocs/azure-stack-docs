---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 09/27/2022
---


- You've your Microsoft account with credentials to access Azure portal.

- You've access to an Azure Stack HCI cluster. This cluster is deployed, registered, and connected to Azure Arc.

   - Go to the **Overview** page in the Azure Stack HCI cluster resource. On the **Server** tab in the right-pane, the **Azure Arc** should show as **Connected**.
    
    :::image type="content" source="../hci/manage/media/manage-vm-resources/azure-arc-connected.png" alt-text="Screenshot of the Overview page in the Azure Stack HCI cluster resource showing Azure Arc as connected." lightbox="../hci/manage/media/manage-vm-resources/azure-arc-connected.png":::

- To enable Azure Arc VMs on your Azure Stack HCI, see [Deploying Azure Arc resource bridge](../hci/manage/azure-arc-enabled-virtual-machines.md#azure-arc-resource-bridge-deployment-overview). As a part of Arc Resource Bridge deployment, you'll also create a custom location for your Azure Stack HCI cluster that you'll use later in the scenario. The custom location will also show up in the **Overview** page for Azure Stack HCI cluster.

- For custom images in a local share on your Azure Stack HCI, you'll have the following extra prerequisites:
    - You should have a VHD/VHDX uploaded to a local share on your Azure Stack HCI cluster.
    - The VHDX image must be Gen 2 type and secure boot enabled.
    - The image should reside on a Cluster Shared Volume available to all the servers in the cluster. Arc-enabled Azure Stack HCI supports Windows and Linux operating systems.