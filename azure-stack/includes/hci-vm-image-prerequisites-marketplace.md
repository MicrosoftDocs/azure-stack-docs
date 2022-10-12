---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 09/26/2022
---


- You've your Microsoft account with credentials to access Azure portal.

- You've access to an Azure Stack HCI cluster. This cluster is deployed, registered, and connected to Azure Arc.

   - Go to the **Overview** page in the Azure Stack HCI cluster resource. On the **Server** tab in the right-pane, the **Azure Arc** should show as **Connected**.
    
    :::image type="content" source="../hci/manage/media/manage-vm-resources/azure-arc-connected.png" alt-text="Screenshot of the Overview page in the Azure Stack HCI cluster resource showing Azure Arc as connected." lightbox="../hci/manage/media/manage-vm-resources/azure-arc-connected.png":::

- To enable Azure Arc VMs on your Azure Stack HCI, see [Deploying Azure Arc resource bridge](../hci/manage/azure-arc-enabled-virtual-machines.md#azure-arc-resource-bridge-deployment-overview). As a part of Arc Resource Bridge deployment, you'll also create a custom location for your Azure Stack HCI cluster that you'll use later in the scenario. The custom location will also show up in the **Overview** page for Azure Stack HCI cluster.

