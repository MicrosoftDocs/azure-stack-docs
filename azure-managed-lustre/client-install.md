---
title: Install client software for Azure Managed Lustre
description: Tutorial that describes how to install client software for the Azure Managed Lustre File System.
ms.topic: tutorial
author: mvbishop
ms.author:  mayabishop
ms.lastreviewed: 06/29/2023
ms.reviewer: dsundarraj
ms.date: 06/29/2023
zone_pivot_groups: select-os

---

::: zone pivot="alma-86"
# Tutorial: AlmaLinux HPC 8.6

This tutorial shows how to install an appropriate client package, in order to set up client VMs running AlmaLinux HPC 8.6 and attach them to an Azure Managed Lustre cluster.

For client VMs running:

* AlmaLinux HPC 8.6

In this tutorial you will:

> [!div class="checklist"]
> * download a pre-built client
> * install the pre-built client

For more information, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md), including:

* [Client prerequisites and supported operating systems](connect-clients.md#client-prerequisites)
* [Installing on a client with existing Lustre client software](connect-clients.md#update-a-lustre-client-to-the-current-version)
* [Mount command](connect-clients.md#mount-command)

## Install prebuilt client software

[!INCLUDE [client-install-hpc-alma-86](includes/client-install-hpc-alma-86.md)]
:::zone-end

::: zone pivot="rhel-7"
# Tutorial: Red Hat Enterprise Linux or CentOS 7

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
::: zone-end

::: zone pivot="rhel-8"
# Tutorial: Red Hat Enterprise Linux, CentOS Linux, or AlmaLinux 8

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
::: zone-end

::: zone pivot="ubuntu-18"
# Tutorial: Ubuntu 18.04

This tutorial shows how to install an appropriate client package, in order to set up client VMs running Ubuntu 18.04 and attach them to an Azure Managed Lustre cluster.

For client VMs running:

* Ubuntu 18.04

In this tutorial you will:

> [!div class="checklist"]
> * download a pre-built client
> * install the pre-built client

For more information, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md), including:

* [Client prerequisites and supported operating systems](connect-clients.md#client-prerequisites)
* [Installing on a client with existing Lustre client software](connect-clients.md#update-a-lustre-client-to-the-current-version)
* [Mount command](connect-clients.md#mount-command)

## Install prebuilt client software

[!INCLUDE [client-install-rhel-8](includes/client-install-ubuntu-18.md)]
::: zone-end

::: zone pivot="ubuntu-20"
# Tutorial: Ubuntu 20.04

This tutorial shows how to install an appropriate client package, in order to set up client VMs running Ubuntu 20.04, and attach them to an Azure Managed Lustre cluster.

For client VMs running:

* Ubuntu 20.04

In this tutorial you will:

> [!div class="checklist"]
> * download a pre-built client
> * install the pre-built client

For more information, see [Connect clients to an Azure Managed Lustre file system](connect-clients.md), including:

* [Client prerequisites and supported operating systems](connect-clients.md#client-prerequisites)
* [Installing on a client with existing Lustre client software](connect-clients.md#update-a-lustre-client-to-the-current-version)
* [Mount command](connect-clients.md#mount-command)

## Install prebuilt client software

[!INCLUDE [client-install-ubuntu-20](includes/client-install-ubuntu-20.md)]
::: zone-end

::: zone pivot="ubuntu-22"
# Tutorial: Ubuntu 22.04

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
::: zone-end

## Next steps

* [How to connect clients to the file system](connect-clients.md)
* [Azure Managed Lustre File System overview](amlfs-overview.md)
