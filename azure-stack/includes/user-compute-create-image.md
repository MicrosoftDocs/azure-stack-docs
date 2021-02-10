---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 2/1/2021
ms.reviewer: thoroet
ms.lastreviewed: 08/04/2020
---

1. Sign in to the Azure Stack Hub user portal.

    If you are a cloud operator creating a platform image, follow the instructions in [Add a platform image](../operator/azure-stack-add-vm-image.md#add-a-platform-image) to add the VHD through the administrator portal or with the administrator endpoints.

2. In the user portal, select  **All Services** > **Images** > **Add**.

3. In **Create image**:

    1. Type the **Name** of your image.
    2. Select your **Subscription**.
    3. Create or add the image to a **Resource group**.
    4. Select the **Location**, also referred to as the region, of your ASDK.
    5. Select an **OS type** that matches your image.
    6. Select **Browse** and then navigate to your Storage account, container, and VHD. Choose **Select**.
    5. Select the **Account type**.
        - **Premium disks (SSD)** are backed by solid-state drives and offer consistent, low-latency performance. They provide the best balance between price and performance, and are ideal for I/O-intensive applications and production workloads.  
        - **Standard disks (HDD)** are backed by magnetic drives and are preferable for applications where data is accessed infrequently. Zone-redundant disks are backed by Zone redundant storage (ZRS) that replicates your data across multiple zones and are available even if a single zone is down.

    8. Select **Read/write** for host catching.
    9. Select **Create**.

4. Once the image is created, use the image to create a new VM.