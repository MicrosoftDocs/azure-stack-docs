---
title: Replace failed drives on Azure Stack HCI
description: How to replace failed drives on Azure Stack HCI.
ms.topic: how-to
author: dansisson
ms.author: v-dansisson
ms.reviewer: jgerend
ms.date: 02/28/2023
---

# Replace failed drives on Azure Stack HCI

> Applies to: Azure Stack HCI, versions 22H2, 21H2, and 20H2; Windows Server 2022, Windows Server 2019

Azure Stack HCI works with direct-attached SATA, SAS, NVMe, and persistent memory drives that are physically attached to one server each. Storage Spaces Direct automatically retires and evacuates failed drives. When this has happened, the drive status is **Retired**, and its storage capacity bar is empty.

If a drive fails, you will need access to the physical server hardware to replace it.

## Find the alert

When a drive fails, an alert appears in the upper left **Alerts** area of Windows Admin Center. 

You can also select **Drives** under **Tools** in the left pane or select **View Drives >** on the tile in the lower-right corner to browse drives and see their status. On the **View** tab, the grid supports sorting, grouping, and keyword search.

1. In Windows Admin Center, select the alert to see details, like the drive's physical location.
1. To see more details, select **Go to drive** to go to the **Drive** detail page.
1. If your hardware supports it, you can select **Turn light on/off** to control the drive's indicator light.
1. Physically remove the failed drive and insert its replacement.

## Wait for the alert to clear

In Windows Admin Center, under **Drives > Inventory**, the new drive will appear. In time, the alert will clear, volumes will repair back to OK status, and storage will rebalance onto the new drive automatically.

## Troubleshooting

If the new drive is not added to the pool, it may be because AutoPool is disabled. To determine this, run the following PowerShell command as administrator:

```powershell
Get-StorageSubsystem Cluster* | Get-StorageHealthSetting | select "System.Storage.PhysicalDisk.AutoPool.Enabled"
```

If the value is **True**, AutoPool is enabled.  If the value is **False**, AutoPool is disabled.  You have two options to resolve this:

**Option A**: Leave AutoPool disabled and manually add the disk(s) to the pool

Run the following PowerShell commands as administrator:

1. Run `Get-PhysicalDisk -CanPool $true` and verify the new physical disk is listed with `OperationalStatus` is **OK**, and `HealthStatus` is **Healthy**.
1. Run `Get-StoragePool -IsPrimordial $False` and make a note of the **FriendlyName** of the storage pool that you want to add the disk to. If this is a stretched cluster, you should see more than one pool name.
1. Run `$disks = Get-PhysicalDisk -CanPool $true`.
1. Run `Add-PhysicalDisk -StoragePoolFriendlyName "FriendlyName_from_step2" -PhysicalDisks $disks`.

**Option B**: Enable AutoPool and let the Health service add the disk to the pool.

Run the following Powershell command as administrator:

```powershell
Get-StorageSubsystem Cluster* | Set-StorageHealthSetting -Name "System.Storage.PhysicalDisk.AutoPool.Enabled" -Value True
```

## Next steps

- To learn about how storage health is tracked at different levels, including at the drive level, see [Health and operational states](/windows-server/storage/storage-spaces/storage-spaces-states).
- If you're using PMem, see [Understand and deploy persistent memory](/windows-server/storage/storage-spaces/deploy-pmem)
