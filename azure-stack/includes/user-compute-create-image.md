---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 08/04/2020
ms.reviewer: thoroet
ms.lastreviewed: 08/04/2020
---

1. Sign in to the Azure Stack Hub user portal.

    If you are a cloud operator creating a platform image, follow the instructions in [Add a platform image](/azure-stack/operator/azure-stack-add-vm-image.md#add-a-platform-image) to add the VHD through the administrator portal or with he administrator endpoints.

2. In the user portal, select  **All Services** > **Images** > **Add**.

3. In the Create image blade:

    1. Type the **Name** of your image.
    2. Select your **Subscription**.
    3. Create or add the image to a **Resource group**.
    4. Select the **Location**, also referred to as the region, of your ASDK.
    5. Select an **OS type** that matches your image.
    6. Select **Browse** and then navigate to your Storage account, container, and VHD. Choose **Select**.
    7. Select your disk type in **Account type**.
    8. Select **Read/write** for host catching.
    9. Select **Create**.

4. Once the image is created, use the image to create a new VM. 
    1. For more information on using the portal to create a Windows VM, see [Create a Windows server VM with the Azure Stack Hub portal](/azure-stack/user/azure-stack-quick-windows-portal.md).
    1. For more information on using the portal to create a Linux VM, see [Create a Linux server VM by using the Azure Stack Hub portal](/azure-stack/user/azure-stack-quick-linux-portal.md).