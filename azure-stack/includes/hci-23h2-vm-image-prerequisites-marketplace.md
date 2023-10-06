---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 10/06/2023
---


- You have Azure subscription credentials (Microsoft Account or Entra ID user).

- You have access to an Azure Stack HCI cluster that is deployed, registered, and connected to Azure Arc. During deployment, an Arc Resource Bridge and a custom location are also created on the cluster.

   - Go to the **Overview > Server** page in the Azure Stack HCI cluster resource. Verify that **Azure Arc** shows as **Connected**. You should also see a custom location and an Arc Resource Bridge for your cluster.
    
    :::image type="content" source="../hci/manage/media/manage-vm-resources/azure-arc-connected.png" alt-text="Screenshot of the Overview page in the Azure Stack HCI cluster resource showing Azure Arc as connected." lightbox="../hci/manage/media/manage-vm-resources/azure-arc-connected.png":::
