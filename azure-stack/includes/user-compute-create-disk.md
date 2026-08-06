---
author: sethmanheim
ms.author: sethm
ms.service: azure-stack
ms.topic: include
ms.date: 07/08/2026
ms.reviewer: thoroet
ms.lastreviewed: 08/04/2020
---

1. Sign in to the Azure Stack Hub user portal.

    If you're a cloud operator creating a platform disk, follow the instructions in [Add a platform image](../operator/azure-stack-add-vm-image.md#add-a-platform-image) to add the VHD through the administrator portal or by using the administrator endpoints.

1. In the user portal, select **All Services** > **Disks** > **Add**.

1. In **Create managed disk**:

    1. Enter the **Name** for your image.
    1. Select your **Subscription**.
    1. Create or add the image to a **Resource group**.
    1. Select the **Location**, also referred to as the region, of your ASDK.
    1. Select the **Account type**.
        - **Premium disks (SSD)** are backed by solid-state drives and offer consistent, low-latency performance. They provide the best balance between price and performance, and are ideal for I/O-intensive applications and production workloads.  
        - **Standard disks (HDD)** are backed by magnetic drives and are preferable for applications where data is accessed infrequently. Zone-redundant disks are backed by Zone redundant storage (ZRS) that replicates your data across multiple zones and are available even if a single zone is down.

    1. Select **Storage blob** as your **Source type**. You create a disk from a blob in a storage account.
    1. For the VHD source:
        1. Select the source subscription where the storage account is located.
        1. Select **Browse** and then go to your storage account, container, and VHD. Choose **Select**.
        1. Select the **OS Type** that matches the VHD.
    1. Select a disk **Size (GiB)** that's the size of or larger than your VHD.
    1. Select **Create**.

1. After you create the disk, use it to create a new VM.