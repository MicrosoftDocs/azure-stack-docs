---
title: Replace failed drives on Azure Stack HCI
description: How to replace failed drives on Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 02/27/2020
---

# Replace failed drives on Azure Stack HCI

Azure Stack HCI works with direct-attached SATA, SAS, or NVMe drives that are physically attached to just one server each. If a drive fails, you will need access to the physical server hardware to replace it.

## Find the alert
When a drive fails, an alert appears in the upper left **Alerts** area of the **Windows Admin Center** dashboard. You can also select **Drives** from the navigation on the left side or click the **VIEW DRIVES >** link on the tile in the lower right corner to browse drives and see their status for yourself. In the **View** tab, the grid supports sorting, grouping, and keyword search.

1. From the dashboard, click the alert to see details, like the drive's physical location.
1. To learn more, click the **Go to drive** shortcut to the **Drive** detail page.
1. If your hardware supports it, you can click **Turn light on/off** to control the drive's indicator light.
   Storage Spaces Direct automatically retires and evacuates failed drives. When this has happened, the drive status is Retired, and its storage capacity bar is empty.
1. Remove the failed drive and insert its replacement.

## Wait for the alert to clear
In **Drives > Inventory**, the new drive will appear. In time, the alert will clear, volumes will repair back to OK status, and storage will rebalance onto the new drive – no user action is required.

## Next steps
-  To learn about how storage health is tracked at different levels, including at the drive level, see [Health and operational states](/windows-server/storage/storage-spaces/storage-spaces-states).
