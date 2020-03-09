---
title: Delete volumes in Azure Stack HCI
description: How to delete volumes in Azure Stack HCI using Windows Admin Center.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 03/05/2020
---

# Deleting volumes in Azure Stack HCI

> Applies to: Windows Server 2019

This topic provides instructions for deleting volumes on a [Storage Spaces Direct](/windows-server/storage/storage-spaces/storage-spaces-direct-overview) cluster by using Windows Admin Center.

Watch a quick video on how to delete a volume.

> [!VIDEO https://www.youtube-nocookie.com/embed/DbjF8r2F6Jo]

## Use Windows Admin Center to delete a volume

1. In Windows Admin Center, connect to a Storage Spaces Direct cluster, and then select **Volumes** from the **Tools** pane.
2. On the **Volumes** page, select the **Inventory** tab, and then select the volume that you want to delete.
3. At the top of the volumes detail page, select **Delete**.
4. In the confirmations dialog, select the check box to confirm that you want to delete the volume, and select **Delete**.

## Next steps

For step-by-step instructions on other essential storage management tasks, see also:

- [Planning volumes in Storage Spaces Direct](/windows-server/storage/storage-spaces/plan-volumes)
- [Creating volumes in Storage Spaces Direct](/windows-server/storage/storage-spaces/create-volumes)
- [Extending volumes in Storage Spaces Direct](/windows-server/storage/storage-spaces/resize-volumes)