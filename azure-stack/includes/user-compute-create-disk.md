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

    If you are a cloud operator creating a platform disk, follow the instructions in [Add a platform image](../operator/azure-stack-add-vm-image.md#add-a-platform-image) to add the VHD through the administrator portal or with the administrator endpoints.

2. In the user portal, select  **All Services** > **Disks** > **Add**.

3. In **Create managed disk**:

    1. Type the **Name** of your image.
    2. Select your **Subscription**.
    3. Create or add the image to a **Resource group**.
    4. Select the **Location**, also referred to as the region, of your ASDK.
    5. Select the **Account type**.
        - **Premium disks (SSD)** are backed by solid-state drives and offer consistent, low-latency performance. They provide the best balance between price and performance, and are ideal for I/O-intensive applications and production workloads.  
        - **Standard disks (HDD)** are backed by magnetic drives and are preferable for applications where data is accessed infrequently. Zone-redundant disks are backed by Zone redundant storage (ZRS) that replicates your data across multiple zones and are available even if a single zone is down.

    6. Select **Storage blob** your **Source type**. You are created a disk from a blob in a storage account.
    7. For the VHD source select:
        1. The Source subscription where the storage account is located.
        1. Select **Browse** and then navigate to your Storage account, container, and VHD. Choose **Select**.
        1. Select the **OS Type** that matches the VHD.
    8. Select a disk **Size (GiB)** that the size of or larger than your VHD.
    9. Select **Create**.

4. Once the disk is created, you can use the disk to create a new VM.