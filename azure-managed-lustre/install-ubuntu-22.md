---
title: Install client software for Ubuntu 22.04
description: Tutorial that describes how to install Ubuntu 22.04 client software for the Azure Managed Lustre File System.
ms.topic: tutorial
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 06/14/2023
ms.reviewer: dsundarraj
ms.date: 06/14/2023

---

# Tutorial: Install client software for Ubuntu 22.04

This tutorial shows how to install an appropriate client package, in order to set up client VMs running Ubuntu 22.04, and attach them to an Azure Managed Lustre cluster.

For client VMs running:

* Ubuntu 22.04

In this tutorial you will:

> [!div class="checklist"]
> * download a pre-built client
> * install the pre-built client

For more information, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md), including:

* [Client prerequisites and supported operating systems](connect-clients.md#client-prerequisites)
* [Installing on a client with existing Lustre client software](connect-clients.md#update-a-lustre-client-to-the-current-version)
* [Mount command](connect-clients.md#mount-command)

## Install prebuilt client software

[!INCLUDE [client-install-ubuntu-22](includes/client-install-ubuntu-22.md)]

## Next steps

* [How to connect clients to the file system](connect-clients.md)
* [Azure Managed Lustre File System overview](amlfs-overview.md)
