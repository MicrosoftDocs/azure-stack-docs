---
title: Manage Azure Local Small Form Factor Storage devices (preview)
description: Learn how to manage storage resources in Azure Local small form factor (preview).
author: sipastak
ms.topic: how-to
ms.date: 08/17/2026
ms.author: sipastak
ms.service: azure-local
ms.subservice: small-form-factor
---

# Storage resource management for small form factor deployments of Azure Local (preview)

This article explains how to manage the storage resources on your Azure Local small form factor device. Use this interface to create or delete new volumes for local storage. 

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Prerequisites

- A completed small form factor deployment of Azure Local.
- Disks in addition to the system disk containing boot and root partitions. 

## Disks

Small form factor deployments enable you to manage your disk storage from the Azure portal. 
When Azure Local deploys on a small form factor device, it chooses a disk to use for the system disk. Additional disks remain unallocated. 
If you want to configure extra volumes on extra disks for workloads, you can do so through the Azure portal. Go to **Resources** > **Disks**.


### Create a volume

1. Select **+ Create volume** in the Disks summary view of the provisioned machine.
1. In the create pane, select a disk on which to create your volume.
1. Enter a size in gigabytes.
1. Enter a path for this volume to be available on the local system. This path is also called a mount point.
1. Select **Create** to send the creation request to the Azure Arc-connected Azure Local device.

The creation process includes multiple steps, such as initializing the filesystem on the new volume. Expect the creation process to take some time. The larger the volume, the longer the process takes.  
You can monitor the progress of the process by using the Notifications view (bell) in the top right of the Azure portal.  

> [!NOTE]
> Creating a new volume is a multistep process on the Linux host. It takes some time to complete.  

  :::image type="content" source="media/small-form-factor-volume-create.png" alt-text="Screenshot of the Azure portal volume create dialog." border="true" lightbox="media/small-form-factor-volume-create.png":::

### Delete a volume

When you no longer need a volume that you added to the Azure Local system, delete it through the Azure portal to free up space for new volumes.  

1. In **Resources** > **Disks**, expand the disk that contains the volume.
1. Select the individual volume to highlight it.
1. Select **Delete volume** from the top of the disk listing.
1. When prompted to **Delete** or **Cancel** the request, select **Delete** to continue.

> [!NOTE]
> Deleting a volume is permanent. You can't recover data after deleting a volume. Ensure you're deleting a volume that no longer contains data you want.
