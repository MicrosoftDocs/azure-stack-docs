---
title: Storage thin provisioning in Azure Stack HCI
description: How to use storage thin provisioning on Azure Stack HCI clusters by using Windows PowerShell or Windows Admin Center.
author: TinaWu-Msft
ms.author: Wu.Tina
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 07/27/2021
---

# Storage thin provisioning in Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2

Thin provisioning is now available in Azure Stack HCI 21H2. Traditionally, volumes are fixed provisioned, meaning that all storage is allocated from the storage pool when a volume is created. Despite the volume being empty, a portion of the storage pool’s resources are depleted. Other volumes can't make use of this storage, which impacts storage efficiency and requires more maintenance.

## Capacity management: thin vs. fixed provisioned volumes

Thin provisioning is recommended over the traditional fixed provisioning if you don't know exactly how much storage a volume will need and want more flexibility. If you want to limit the size of a volume or limit how much storage a volume can take from the pool, then use fixed provisioning instead.

Below is a comparison of the two provisioning types with empty volumes.

With traditional fixed provisioning, pre-allocated space is not available in the storage pool. With thin provisioning, space is allocated from the pool when needed and volumes can be over-provisioned (size larger than available capacity) to accommodate anticipated growth.

| **Fixed provisioning** | **Thin provisioning** |
|:----------------------:|:---------------------:|
|:::image type="content" source="media/thin-provisioning/fixed-provisioning.png" alt-text="With traditional fixed provisioning, pre-allocated space is not available in the storage pool." border="false":::|:::image type="content" source="media/thin-provisioning/thin-provisioning.png" alt-text="With thin provisioning, space is allocated from the pool when needed and volumes can be over-provisioned (size larger than available capacity) to accommodate anticipated growth." border="false":::|

When a thin-provisioned volume is created, the footprint will be smaller than the specified size of volume. As data is added or removed from the volume, the volume footprint will increase and decrease accordingly.

:::image type="content" source="media/thin-provisioning/storage-pool.gif" alt-text="As data is added or removed from the volume, the volume footprint will increase and decrease accordingly." border="false":::

Thin provisioning will work with all resiliency settings (three-way mirror, mirror accelerated parity, etc.) and all types of clusters. Because TRIM is disabled for stretched clusters, storage will not be returned to the pool after data is deleted.

You can create volumes that exceed the total available storage capacity by overprovisioning. An alert will be sent in Windows Admin Center when over 70% (customizable) of the pool capacity is used, signaling that you should add more capacity or delete some of the data.

:::image type="content" source="media/thin-provisioning/thin-provisioning.gif" alt-text="You can create volumes that exceed the total available storage capacity by overprovisioning." border="false":::

## Use thin provisioning with PowerShell

The two options for provisioning a volume with PowerShell are **Fixed** and **Thin**. This can be set at the volume level or applied as a default provisioning type to the storage pool. Use the cmdlets below to create a thin-provisioned volume or check/change the default settings.

### Option 1: Apply thin provisioning at the volume level

Create a new thin-provisioned volume:

```PowerShell
New-Volume -FriendlyName <name> -Size <size> -ProvisioningType Thin
```

Create a new thin-provisioned mirror accelerated parity volume:

```PowerShell
Get-StorageTier <mirror tier> | Set-StorageTier -ProvisioningType Thin
Get-StorageTier <parity tier> | Set-StorageTier -ProvisioningType Thin 
New-Volume -FriendlyName <name> -StorageTierFriendlyNames <mirror tier,parity tier> -StorageTierSizes 200GB,800GB
```

Check the volume provisioning type:

```PowerShell
Get-VirtualDisk -FriendlyName <name of virtual disk> | ft FriendlyName,ProvisioningType 
```

### Option 2: Set pool default provisioning type to thin

Change the pool default setting to create thin provisioned volumes:

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

1. In **Cluster Manager**, select **Settings** from the lower left.
1. In the **Settings** pane, select **Storage Spaces and pools**.
1. Under **Storage pool > Default provisioning type**, select **Thin**.
1. Select **Save**.
1. Select **Volumes** from the **Tools** pane at the left and go to the **Inventory** tab.
1. Click **+** to create a new volume.

:::image type="content" source="media/thin-provisioning/thin-provisioning-wac.png" alt-text="You can change the default provisioning type by selecting Storage Spaces and pools under Settings in Windows Admin Center." lightbox="media/thin-provisioning/thin-provisioning-wac.png":::

To check a volume’s provisioning type:

1. In **Cluster Manager**, select **Volumes** from the **Tools** pane at the left and go to the **Inventory** tab.
1. Select a volume to visit its **Properties** page.
1. Check the provisioning type.

:::image type="content" source="media/thin-provisioning/check-volume-provisioning-type.png" alt-text="You can check the volume provisioning type by visiting a volume's Properties page in Windows Admin Center." lightbox="media/thin-provisioning/check-volume-provisioning-type.png":::

To display Provisioning type as a column heading:

1. In **Cluster Manager**, select **Volumes** from the **Tools** pane at the left and go to the **Inventory** tab.
1. Click on the Column picker icon.
1. Click **Add a column** and search for **Provisioning type**
1. Select **Save**.

:::image type="content" source="media/thin-provisioning/display-provisioning-type.png" alt-text="You can display Provisioning type as a column heading by clicking the Column picker icon in Windows Admin Center and selecting Add a column." lightbox="media/thin-provisioning/display-provisioning-type.png":::

## Thin provisioning FAQ

This section answers frequently asked questions about thin provisioning on Azure Stack HCI, version 21H2.

### Can existing fixed volumes be converted to thin?

No. At this time, converting from a fixed volume to a thin volume is not supported.

### Is it possible to go back to creating fixed provisioned volumes as a default after switching the setting to thin?

Yes. Navigate to **Settings > Storage Spaces and pools**, and change the **Default provisioning type** back to **Fixed**.  

### Can there be a mix of fixed and thin volumes in one storage pool?

Yes, it's possible to have a mix of both fixed and thin volumes in one pool.

### Will space be given back to the pool immediately after files are deleted?

No. This is a gradual process that can take 15 minutes or so after the files are deleted.

### Can I overprovision the volume in Windows Admin Center?

At this time, overprovisioning can't be performed in Windows Admin Center, so you'll need to use PowerShell.

## Next steps

For more information, see also:

- [Plan volumes](../concepts/plan-volumes.md)
- [Create volumes](create-volumes.md)