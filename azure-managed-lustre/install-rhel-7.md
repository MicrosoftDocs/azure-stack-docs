---
title: Install client software for Red Hat Enterprise Linux or CentOS 7
description: Tutorial that describes how to install RHEL 7 or CentOS 7 client software for the Azure Managed Lustre File System.
ms.topic: tutorial
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 06/14/2023
ms.reviewer: dsundarraj
ms.date: 06/14/2023

---

# Tutorial: Install client software for Red Hat Enterprise Linux or CentOS 7

This tutorial shows how to install an appropriate client package, in order to set up client VMs running RHEL 7 and CentOS 7, and attach them to an Azure Managed Lustre cluster.

For client VMs running:

* Red Hat Enterprise Linux 7 (RHEL 7)
* CentOS Linux 7

In this tutorial you will:

> [!div class="checklist"]
> * download a pre-built client
> * install the pre-built client

For more information, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md), including:

* [Client prerequisites and supported operating systems](connect-clients.md#client-prerequisites)
* [Installing on a client with existing Lustre client software](connect-clients.md#update-a-lustre-client-to-the-current-version)
* [Mount command](connect-clients.md#mount-command)

## Download and install prebuilt client software

[!INCLUDE [client-install-rhel-7](includes/client-install-rhel-7.md)]

## Next steps

* [How to connect clients to the file system](connect-clients.md)
* [Azure Managed Lustre File System overview](amlfs-overview.md)
