---
title: How to remove Event Hubs on Azure Stack Hub
description: Learn how to remove the Event Hubs resource provider on Azure Stack Hub. 
author: BryanLa
ms.author: bryanla
ms.service: azure-stack
ms.topic: how-to
ms.date: 11/18/2019
ms.reviewer: jfggdl
ms.lastreviewed: 11/18/2019
---

# How to remove Event Hubs on Azure Stack Hub

> [!WARNING]
> Uninstalling Event Hubs will remove (erase) the resource provider, and all user-created Event Hubs clusters, namespaces, and event hubs resources. It will also remove their associated event data.  
> Please proceed with extreme caution before deciding to uninstall Event Hubs. 
> Uninstalling Event Hubs **does not** delete the packages used to install Event Hubs. To achieve that, please refer to [Delete Event Hubs packages](#delete-event-hub-packages).

## Uninstall Event Hubs

This sequence of steps will remove all Event Hubs resources, including clusters, namespaces, event hubs, and the resource provider.

To remove Event Hubs and all related resources created by users, complete the following steps:

1. Sign in to the Azure Stack Hub administrator portal.
2. Select **Marketplace Management** on the left.
3. Select **Resource providers**.
4. Select **Event Hubs** from the list of resource providers. You may want to filter the list by entering "Event Hubs" in the search text box provided.

   [![Remove event hubs 1](media/event-hubs-rp-remove/1-uninstall.png)](media/event-hubs-rp-remove/1-uninstall.png#lightbox)

5. Select **Uninstall** from the options provided across the top the page.

   [![Remove event hubs 2](media/event-hubs-rp-remove/2-uninstall.png)](media/event-hubs-rp-remove/2-uninstall.png#lightbox)

6. Enter the name of the resource provider, then select **Uninstall**. This action confirms your desire to uninstall:
   - The Event Hubs resource provider
   - All user-created clusters, namespaces, event hubs, and event data.

   [![Remove event hubs 3](media/event-hubs-rp-remove/3-uninstall.png)](media/event-hubs-rp-remove/3-uninstall.png#lightbox)

   [![Removing event hubs 4](media/event-hubs-rp-remove/4-uninstall.png)](media/event-hubs-rp-remove/4-uninstall.png#lightbox)

   > [!IMPORTANT]
   > You must wait at least 10 minutes after Event Hubs has been removed successfully before installing Event Hubs again. This is due to the fact that cleanup activities might still be running, which may conflict with any new installation.

## Delete Event Hub packages

Use this option if after uninstalling Event Hubs you also wish to remove any packages used to install Event Hubs. 

## Next steps

To reinstall, return to the [Install the Event Hubs resource provider](event-hubs-rp-install.md) article.