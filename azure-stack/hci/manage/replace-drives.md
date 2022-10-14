---
title: Replace failed drives on Azure Stack HCI
description: How to replace failed drives on Azure Stack HCI.
author: jasongerend
ms.author: jgerend
ms.topic: how-to
ms.date: 07/11/2022
---

# Replace failed drives on Azure Stack HCI

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022, Windows Server 2019

Azure Stack HCI works with direct-attached SATA, SAS, NVMe, or persistent memory drives that are physically attached to just one server each. If a drive fails, you will need access to the physical server hardware to replace it.

## Find the alert

When a drive fails, an alert appears in the upper left **Alerts** area of the **Windows Admin Center** dashboard. You can also select **Drives** from the navigation on the left side or click the **VIEW DRIVES >** link on the tile in the lower right corner to browse drives and see their status for yourself. In the **View** tab, the grid supports sorting, grouping, and keyword search.

1. From the dashboard, click the alert to see details, like the drive's physical location.
1. To learn more, click the **Go to drive** shortcut to the **Drive** detail page.
1. If your hardware supports it, you can click **Turn light on/off** to control the drive's indicator light.
   Storage Spaces Direct automatically retires and evacuates failed drives. When this has happened, the drive status is Retired, and its storage capacity bar is empty.
1. Remove the failed drive and insert its replacement.

## Wait for the alert to clear

In **Drives > Inventory**, the new drive will appear. In time, the alert will clear, volumes will repair back to OK status, and storage will rebalance onto the new drive – no user action is required.

## Troubleshooting

The new drive is not added to the pool.  AutoPool may be disabled.

- Run **Get-StorageSubsystem Cluster* | Get-StorageHealthSetting | select "System.Storage.PhysicalDisk.AutoPool.Enabled"**. If the value is **True**, AutoPool is enabled.  If the value is **False**, AutoPool is disabled.  You have two choices:

Option A: Leave AutoPool disabled and manually add the disk(s) to the pool:

1. Run **Get-PhysicalDisk -CanPool $true** and verify the new physical disk is listed with an **OperationalStatus** of OK, and a **HealthStatus** of Healthy.
1. Run **Get-StoragePool -IsPrimordial $False** and make a note of the **FriendlyName** of the storage pool that you want to add the disk to. If this is a stretch cluster, you should see more than one pool name.
1. Run **$disks = Get-PhysicalDisk -CanPool $true**.
1. Run **Add-PhysicalDisk -StoragePoolFriendlyName "Substitute FriendlyName from Step2" -PhysicalDisks $disks**

Option B: Enable AutoPool and let the Health service add the disk to the pool.

- Run **Get-StorageSubsystem Cluster* | Set-StorageHealthSetting -Name "System.Storage.PhysicalDisk.AutoPool.Enabled" -Value True**.

## Next steps

- To learn about how storage health is tracked at different levels, including at the drive level, see [Health and operational states](/windows-server/storage/storage-spaces/storage-spaces-states).
- If you're using PMem, [Understand and deploy persistent memory](/windows-server/storage/storage-spaces/deploy-pmem)
