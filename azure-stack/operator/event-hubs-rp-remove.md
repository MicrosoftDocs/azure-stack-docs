---
title: How to uninstall Event Hubs on Azure Stack Hub
description: Learn how to uninstall Event Hubs on Azure Stack Hub.
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 12/09/2019
ms.reviewer: jfggdl
ms.lastreviewed: 12/09/2019
ms.custom: contperf-fy22q2
---

# How to uninstall Event Hubs on Azure Stack Hub

> [!WARNING]
> Uninstalling Event Hubs will remove (erase) the resource provider, and all user-created Event Hubs clusters, namespaces, and event hubs resources. It will also remove their associated event data.  
> Please proceed with extreme caution before deciding to uninstall Event Hubs. 
> Uninstalling Event Hubs **does not** delete the packages used to install Event Hubs on Azure Stack Hub. To achieve that, please refer to [Delete Event Hubs packages](#delete-event-hubs-packages).

## Uninstall Event Hubs on Azure Stack Hub

This sequence of steps will delete all Event Hubs on Azure Stack Hub resources, including clusters, namespaces, event hubs, and the resource provider.

To uninstall Event Hubs on Azure Stack Hub and all related resources created by users, complete the following steps:

1. Sign in to the Azure Stack Hub administrator portal.
2. Select **Marketplace management** on the left.
3. Select **Resource providers**.
4. Select **Event Hubs** from the list of resource providers. You may want to filter the list by entering "Event Hubs" in the search text box provided.

   [![Remove event hubs 1](media/event-hubs-rp-remove/1-uninstall.png)](media/event-hubs-rp-remove/1-uninstall.png#lightbox)

5. Select **Uninstall** from the options provided across the top of the page.

   [![Remove event hubs 2](media/event-hubs-rp-remove/2-uninstall.png)](media/event-hubs-rp-remove/2-uninstall.png#lightbox)

6. Enter the name of the resource provider, then select **Uninstall**. This action confirms your desire to uninstall:
   - The Event Hubs resource provider.
   - All user-created clusters, namespaces, event hubs, and event data.

   [![Remove event hubs 3](media/event-hubs-rp-remove/3-uninstall.png)](media/event-hubs-rp-remove/3-uninstall.png#lightbox)

   [![Removing event hubs 4](media/event-hubs-rp-remove/4-uninstall.png)](media/event-hubs-rp-remove/4-uninstall.png#lightbox)

   > [!IMPORTANT]
   > You must wait at least 10 minutes after Event Hubs has been removed successfully before installing Event Hubs again. This is due to the fact that cleanup activities might still be running, which may conflict with any new installation.

## Delete Event Hubs packages

Use the **Delete** option after uninstalling Event Hubs on Azure Stack Hub, if you would also like to remove the related installation packages. 

## Next steps

To reinstall, return to the [Install the Event Hubs resource provider](event-hubs-rp-install.md) article.
