---
title: How-to guide for replacing drives on Azure Stack HCI
description: Step-by-step how-to guide on replacing failed drives on Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.service: #Required; service per approved list. service slug assigned to your service by ACOM.
ms.topic: how-to guide
ms.date: 02/21/2020
---

# How-To Guide: Replacing failed drives on Azure Stack HCI

1. When a drive fails, an alert appears in the upper left **Alerts** area of the **Windows Admin Center Dashboard**.
1. You can also select **Drives** from the navigation on the left side or click the **VIEW DRIVES >** link on the tile in the lower right corner to browse drives and see their status for yourself. In the **Inventory** tab, the grid supports sorting, grouping, and keyword search.
1. From the **Dashboard**, click the alert to see details, like the drive's physical location.
1. To learn more, click the **Go to drive** shortcut to the **Drive** detail page.
1. If your hardware supports it, you can click **Turn light on/off** to control the drive's indicator light.
1. Storage Spaces Direct automatically retires and evacuates failed drives. When this has happened, the drive status is Retired, and its storage capacity bar is empty.
1. Remove the failed drive and insert its replacement.
1. In **Drives > Inventory**, the new drive will appear. In time, the alert will clear, volumes will repair back to OK status, and storage will rebalance onto the new drive – no user action is required.