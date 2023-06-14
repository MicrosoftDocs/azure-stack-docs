---
title: Install client software for Red Hat Enterprise Linux, CentOS Linux, or AlmaLinux 8
description: Tutorial that describes how to install RHEL 8, CentOS 8 or AlmaLinux 8client software for the Azure Managed Lustre File System.
ms.topic: tutorial
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 06/14/2023
ms.reviewer: dsundarraj
ms.date: 06/14/2023

---

# Tutorial: Install client software for Red Hat Enterprise Linux, CentOS Linux, or AlmaLinux 8

This tutorial shows how to install an appropriate client package, in order to set up client VMs running RHEL 8, CentOS 8, and Alma 8 and attach them to an Azure Managed Lustre cluster.

For client VMs running:

* Red Hat Enterprise Linux 8 (RHEL 8)
* CentOS Linux 8
* Alma Linux 8

In this tutorial you will:

> [!div class="checklist"]
> * download a pre-built client
> * install the pre-built client

> [!NOTE]
> For AlmaLinux 8.6 HPC Marketplace images, please see separate [Alma 8.6 HPC install instructions](install-hpc-alma-86.md)

For more information, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md), including:

* [Client prerequisites and supported operating systems](connect-clients.md#client-prerequisites)
* [Installing on a client with existing Lustre client software](connect-clients.md#update-a-lustre-client-to-the-current-version)
* [Mount command](connect-clients.md#mount-command)

## Download and install prebuilt client software

[!INCLUDE [client-install-rhel-8](includes/client-install-rhel-8.md)]

## Next steps

* [How to connect clients to the file system](connect-clients.md)
* [Azure Managed Lustre File System overview](amlfs-overview.md)
