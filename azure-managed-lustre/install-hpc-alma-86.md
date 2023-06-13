---
title: Install client software for AlmaLinux 8
description: Tutorial that describes how to install AlmaLinux HPC 8.6 client software for the Azure Managed Lustre File System.
ms.topic: tutorial
author: mvbishop
ms.author:  mayabishop
ms.lastreviewed: 04/28/2023
ms.reviewer: dsundarraj
ms.date: 04/28/2023

# Intent: As an IT Pro, XXX.
# Keyword: 

---

# Tutorial: Install client software for AlmaLinux HPC 8.6

This tutorial shows how to install an appropriate client package, in order to set up client VMs running AlmaLinux HPC 8.6 and attach them to an Azure Managed Lustre cluster.

For client VMs running:

* AlmaLinux HPC 8.6

In this tutorial you will:

> [!div class="checklist"]
> * download a pre-built client
> * install the pre-built client

For additional information, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md), including:

* [Client prerequisites and supported operating systems](connect-clients.md#client-prerequisites)
* [Installing on a client with existing Lustre client software](connect-clients.md#update-a-lustre-client-to-the-current-version)
* [Mount command](connect-clients.md#mount-command)

## Install prebuilt client software

[!INCLUDE [client-install-hpc-alma-86](includes/client-install-hpc-alma-86.md)]

## Next steps

[AMLFS overview](amlfs-overview.md)
