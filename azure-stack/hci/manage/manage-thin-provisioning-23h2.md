---
title: Storage thin provisioning in Azure Stack HCI, version 23H2
description: How to use storage thin provisioning on Azure Stack HCI, version 23H2 clusters by using Windows PowerShell.
author: TinaWu-Msft
ms.author: tinawu
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/09/2024
---

# Storage thin provisioning in Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article describes how thin provisioning works on your Azure Stack HCI cluster, version 23H2. Traditionally, volumes are fixed provisioned, meaning that all storage is allocated from the storage pool when a volume is created. Despite the volume being empty, a portion of the storage pool's resources are depleted. Other volumes can't make use of this storage, which impacts storage efficiency and requires more maintenance.

## Capacity management: thin vs. fixed provisioned volumes

Thin provisioning is recommended over the traditional fixed provisioning if you don't know exactly how much storage a volume requires. Thin provisioning provides flexibility compared to traditional fixed provisioning. If you want to limit the size of a volume or limit how much storage a volume can take from the pool, use fixed provisioning.

Below is a comparison of the two provisioning types with empty volumes.

With traditional fixed provisioning, preallocated space isn't available in the storage pool. With thin provisioning, space is allocated from the pool when needed and volumes can be over-provisioned (size larger than available capacity) to accommodate anticipated growth.

| **Fixed provisioning** | **Thin provisioning** |
|:----------------------:|:---------------------:|
|:::image type="content" source="media/manage-thin-provisioning-23h2/fixed-provisioning.png" alt-text="Diagram of traditional fixed provisioning. Preallocated space isn't available in the storage pool." lightbox="media/manage-thin-provisioning-23h2/fixed-provisioning.png":::|:::image type="content" source="media/manage-thin-provisioning-23h2/thin-provisioning.png" alt-text="Diagram of thin provisioning. Space is allocated from the pool when needed and volumes can be over-provisioned (size larger than available capacity) to accommodate anticipated growth." lightbox="media/manage-thin-provisioning-23h2/thin-provisioning.png":::|

When a thin-provisioned volume is created, the footprint is smaller than the specified size of volume. As data is added or removed from the volume, the volume footprint increases and decreases accordingly.

:::image type="content" source="media/manage-thin-provisioning-23h2/storage-pool.gif" alt-text="Diagram showing that as data is added or removed from the volume, the volume footprint increases and decreases accordingly." lightbox="media/manage-thin-provisioning-23h2/storage-pool.gif":::

Thin provisioning works with all resiliency settings (three-way mirror, mirror accelerated parity, etc.) and all types of clusters. Because TRIM is disabled for stretched clusters, storage isn't returned to the pool after data is deleted.

You can create volumes that exceed the total available storage capacity by overprovisioning. An alert is sent when over 70% (customizable) of the pool capacity is used, signaling that you should add more capacity or delete some data.

:::image type="content" source="media/manage-thin-provisioning-23h2/thin-provisioning.gif" alt-text="Diagram showing that you can create volumes that exceed the total available storage capacity by overprovisioning." lightbox="media/manage-thin-provisioning-23h2/thin-provisioning.gif":::

## Use thin provisioning with PowerShell

The two options for provisioning a volume with PowerShell are **Fixed** and **Thin**. This can be set at the volume level or applied as a default provisioning type to the storage pool. Use the cmdlets below to create a thin-provisioned volume or check/change the default settings.

### Option 1: Apply thin provisioning at the volume level

To create a new thin-provisioned volume, run the following cmdlet:

```PowerShell
New-Volume -FriendlyName <name> -Size <size> -ProvisioningType Thin
```

To create a new thin-provisioned mirror accelerated parity volume, run the following cmdlet:

```PowerShell
Get-StorageTier <mirror tier> | Set-StorageTier -ProvisioningType Thin
Get-StorageTier <parity tier> | Set-StorageTier -ProvisioningType Thin 
New-Volume -FriendlyName <name> -StorageTierFriendlyNames <mirror tier,parity tier> -StorageTierSizes 200GB,800GB
```

To check the volume provisioning type, run the following cmdlet:

```PowerShell
Get-VirtualDisk -FriendlyName <name of virtual disk> | ft FriendlyName,ProvisioningType 
```

### Option 2: Manage default provisioning alert threshold

The alert threshold for thin provisioning is set at 70%. We recommend that you accept the default alert threshold.

To change the default thin provisioning alert threshold, run the following cmdlet:

```powershell
Set-StoragePool -FriendlyName <name of storage pool> -ThinProvisioningAlertThresholds <% value>
```

## Thin provisioning FAQ

This section answers frequently asked questions about thin provisioning on Azure Stack HCI, version 23H2.

### Can existing fixed volumes be converted to thin?

Yes. Converting from a fixed volume to a thin volume is supported, see [Convert fixed to thin provisioned volumes on Azure Stack HCI](../manage/thin-provisioning-conversion.md).

### Is it possible to go back to creating fixed provisioned volumes as a default after switching the setting to thin?

Yes. Navigate to **Settings > Storage Spaces and pools**, and change the **Default provisioning type** back to **Fixed**.  

### Can there be a mix of fixed and thin volumes in one storage pool?

Yes, it's possible to have a mix of both fixed and thin volumes in one pool.

### Will space be given back to the pool immediately after files are deleted?

No. This is a gradual process that can take 15 minutes or so after the files are deleted. If there are many workloads running on the cluster, it may take longer for all of the space to be returned to the pool.

## Next steps

For more information, see also:

- [Plan volumes](../concepts/plan-volumes.md).
- [Create volumes](create-volumes.md).
