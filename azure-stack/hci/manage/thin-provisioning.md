---
title: Storage thin provisioning in Azure Stack HCI
description: How to use storage thin provisioning on Azure Stack HCI clusters by using Windows PowerShell or Windows Admin Center.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/20/2021
---

# Storage thin provisioning in Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2

Inefficient volume provisioning wastes your storage and requires significantly more maintenance and management as data grows. Traditionally, volumes are fixed provisioned, meaning that storage is allocated from the storage pool when a volume is created. Despite a volume being empty, a portion of the storage pool’s resources are depleted, and other volumes cannot make use of this storage.

## Capacity management: thin vs. fixed provisioned volumes 

New in Azure Stack HCI, version 21H2, thin provisioning is recommended over the traditional fixed provisioning if you don't know exactly how much storage a volume will need and want more flexibility. If you want to limit the size of a volume or limit how much storage a volume can take from the pool, then use fixed provisioning instead.

Below is a comparison of the two provisioning types with empty volumes.

With traditional fixed provisioning, pre-allocated space is not available in the storage pool.

:::image type="content" source="media/thin-provisioning/fixed-provisioning.png" alt-text="With traditional fixed provisioning, pre-allocated space is not available in the storage pool." lightbox="media/thin-provisioning/fixed-provisioning.png":::

With thin provisioning, space is allocated from the pool when needed and volumes can be over-provisioned (size larger than available capacity) to accommodate anticipated growth. 

:::image type="content" source="media/thin-provisioning/thin-provisioning.png" alt-text="With thin provisioning, space is allocated from the pool when needed and volumes can be over-provisioned (size larger than available capacity) to accommodate anticipated growth." lightbox="media/thin-provisioning/thin-provisioning.png":::

When a thin-provisioned volume is created, the footprint will be smaller than the specified size of volume. As data is added or removed from the volume, the volume footprint will increase and decrease accordingly.

:::image type="content" source="media/thin-provisioning/storage-pool.gif" alt-text="As data is added or removed from the volume, the volume footprint will increase and decrease accordingly." lightbox="media/thin-provisioning/storage-pool.gif":::

Thin provisioning will work with all resiliency settings (three-way mirror, mirror accelerated parity, etc.) and all types of clusters. Because TRIM is disabled for stretched clusters, storage will not be returned to the pool after data is deleted.

You can create volumes that exceed the total available storage capacity by overprovisioning. An alert will be sent when over 70% (customizable) of the pool capacity is used, signaling that you should add more capacity or delete some of the data.

:::image type="content" source="media/thin-provisioning/thin-provisioning.gif" alt-text="You can create volumes that exceed the total available storage capacity by overprovisioning." lightbox="media/thin-provisioning/thin-provisioning.gif":::

## Use thin provisioning with PowerShell

The two options for provisioning a volume with PowerShell are **Fixed** and **Thin**. This can be set at the volume level or applied as a default provisioning type to the storage pool. Use the cmdlets below to create a thin-provisioned volume or check/change the default settings.

Create a new thin-provisioned volume:

```PowerShell
New-VirtualDisk -StoragePoolFriendlyName <name of storage pool> -FriendlyName <name of virtual disk> -Size <Size> -ProvisioningType Thin
```

Check the volume provisioning type:

```PowerShell
Get-VirtualDisk -FriendlyName <name of virtual disk> | ft FriendlyName,ProvisioningType
```

Change pool default setting to create thinly provisioned volumes:

```PowerShell
Set-StoragePool -FriendlyName <name of storage pool> -ProvisioningTypeDefault Thin
```

Check the default provisioning setting:

```PowerShell
Get-StoragePool -FriendlyName <name of storage pool> | ft FriendlyName,ProvisioningTypeDefault
```

Change the default thin provisioning alert threshold:

```PowerShell
Set-StoragePool -FriendlyName <name of storage pool> -ThinProvisioningAlertThresholds <% value>
```

## Use thin provisioning in Windows Admin Center  

To change the default provisioning type for a storage pool to **Thin** in Windows Admin Center:

1.	In **Cluster Manager**, select **Settings** from the lower left.
2.	In the **Settings** pane, select **Storage Spaces and pools**.
3.	Under **Storage pool > Default provisioning type**, select **Thin**. 
4.	Select **Save**.
5.	Select **Volumes** from the **Tools** pane at the left.
6.	Click **+** to create a new volume.

:::image type="content" source="media/thin-provisioning/thin-provisioning-wac.png" alt-text="You can change the default provisioning type by selecting Storage Spaces and pools under Settings in Windows Admin Center." lightbox="media/thin-provisioning/thin-provisioning-wac.png":::

## Next steps

For more information, see also:

- [Plan volumes](../concepts/plan-volumes.md)
- [Create volumes](create-volumes.md)