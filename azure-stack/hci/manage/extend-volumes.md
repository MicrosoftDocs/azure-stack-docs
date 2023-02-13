---
title: Expand volumes on Azure Stack HCI and Windows Server clusters
description: How to expand volumes on Azure Stack HCI and Windows Server clusters by using Windows Admin Center and PowerShell.
ms.topic: how-to
author: dansisson
ms.author: v-dansisson
ms.reviewer: jgerend
ms.date: 02/08/2023
---

# Expand volumes on Azure Stack HCI and Windows Server clusters

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019

This article explains how to expand volumes on a cluster by using Windows Admin Center and PowerShell.

> [!WARNING]
>**Not supported: resizing the underlying storage used by Storage Spaces Direct.** If you are running Storage Spaces Direct in a virtualized storage environment, including in Azure, resizing or changing the characteristics of the storage devices used by the virtual machines isn't supported and will cause data to become inaccessible. Instead, follow the instructions in the Add servers or drives section to add additional capacity before expanding volumes.

## Expand volumes using Windows Admin Center

1. In Windows Admin Center, connect to a cluster, and then select **Volumes** from the **Tools** pane.
1. On the **Volumes** page, select the **Inventory** tab, and then select the volume that you want to expand. On the volume detail page, the storage capacity for the volume is indicated. 

    You can also open the volumes detail page directly from **Dashboard**. On the Dashboard, in the **Alerts** section, select the alert, which notifies you if a volume is running low on storage capacity, and then select **Go To Volume**.

1. At the top of the volumes detail page, select **Settings**.
1. Enter a new larger size in the right pane, and then select **Save**.

    On the volumes detail page, the larger storage capacity for the volume is indicated, and the alert on the Dashboard is cleared.

## Expand volumes using PowerShell

### Capacity in the storage pool

Before you expand a volume, make sure you have enough capacity in the storage pool to accommodate its new, larger footprint. For example, when expanding a three-way mirror volume from 1 TB to 2 TB, its footprint would grow from 3 TB to 6 TB. For the expansion to succeed, you would need at least (6 - 3) = 3 TB of available capacity in the storage pool.

### Familiarity with volumes in Storage Spaces

In Storage Spaces Direct, every volume is comprised of several stacked objects: the cluster shared volume (CSV), which is a volume; the partition; the disk, which is a virtual disk; and one or more storage tiers (if applicable). To resize a volume, you will need to resize several of these objects.

![Diagram shows the layers of a volume, including cluster shard volume, volume, partition, disk, virtual disk, and storage tiers.](media/extend-volumes/volumes-in-smapi.png)

To familiarize yourself with them, try running the `Get-` cmdlet with the corresponding noun in PowerShell.

For example:

```PowerShell
Get-VirtualDisk
```

To follow associations between objects in the stack, pipe one `Get-` cmdlet into the next.

For example, here's how to get from a virtual disk up to its associated volume:

```PowerShell
Get-VirtualDisk <FriendlyName> | Get-Disk | Get-Partition | Get-Volume
```

### Step 1 – Expand the virtual disk

The virtual disk may use storage tiers, or not, depending on how it was created.

To check, run the following cmdlet:

```PowerShell
Get-VirtualDisk <FriendlyName> | Get-StorageTier
```

If the cmdlet returns nothing, the virtual disk doesn't use storage tiers.

#### No storage tiers

If the virtual disk has no storage tiers, you can expand it directly using the `Resize-VirtualDisk` cmdlet.

Provide the new size in the `-Size` parameter.

```PowerShell
Get-VirtualDisk <FriendlyName> | Resize-VirtualDisk -Size <Size>
```

When you expand the **VirtualDisk**, the associated **Disk** follows automatically and is resized too.

![Animated diagram shows the virtual disk of a volume becoming larger while the disk layer immediately above it automatically becomes larger as a result.](media/extend-volumes/Resize-VirtualDisk.gif)

#### With storage tiers

If the virtual disk uses storage tiers, you can expand each tier separately using the `Resize-StorageTier` cmdlet.

Get the names of the storage tiers by following the associations from the virtual disk:

```PowerShell
Get-VirtualDisk <FriendlyName> | Get-StorageTier | Select FriendlyName
```

Then, for each tier, provide the new size in the `-Size` parameter:

```PowerShell
Get-StorageTier <FriendlyName> | Resize-StorageTier -Size <Size>
```

> [!TIP]
> If your tiers are different physical media types (such as **MediaType = SSD** and **MediaType = HDD**) you need to ensure you have enough capacity of each media type in the storage pool to accommodate the new, larger footprint of each tier.

When you expand the **StorageTier**(s), the associated **VirtualDisk** and **Disk** follow automatically and are resized too.

![Animated diagram shows first one then another storage tier becoming large while the virtual disk layer and disk layer above become larger as well.](media/extend-volumes/Resize-StorageTier.gif)

### Step 2 – Expand the partition

Next, expand the partition using the `Resize-Partition` cmdlet. The virtual disk is expected to have two partitions: the first is `Reserved` and should not be modified; the one you need to resize has **PartitionNumber = 2** and **Type = Basic**.

Provide the new size in the `-Size` parameter. We recommend using the maximum supported size, as shown below:

```PowerShell
# Choose virtual disk
$VirtualDisk = Get-VirtualDisk <FriendlyName>

# Get its partition
$Partition = $VirtualDisk | Get-Disk | Get-Partition | Where PartitionNumber -Eq 2

# Resize to its maximum supported size
$Partition | Resize-Partition -Size ($Partition | Get-PartitionSupportedSize).SizeMax
```

When you expand the **Partition**, the associated **Volume** and **ClusterSharedVolume** follow automatically and are resized too.

![Animated diagram shows the virtual disk layer, at the bottom of the volume, growing larger with each of the layers above it growing larger as well.](media/extend-volumes/Resize-Partition.gif)

That's it!

> [!TIP]
> You can verify the volume has the new size by running the `Get-Volume` cmdlet.

## Next steps

For step-by-step instructions on other essential storage management tasks, see:

- [Plan volumes](../concepts/plan-volumes.md)
- [Create volumes](create-volumes.md)
- [Delete volumes](delete-volumes.md)
