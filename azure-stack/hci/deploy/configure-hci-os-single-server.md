---
title: Configure Azure Stack HCI OS - Single-Server 
description: This article describes Azure Stack HCI OS configuration on a single server
author: robess
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/04/2022
---

# **Azure Stack HCI OS - Single-Server - Configuration**

> Applies to: Azure Stack HCI, version 21H2

Azure Stack HCI 21H2 single-server configuration aims to provide flexibility, hardware resiliency, and cost savings in scenarios where lower  resiliency can be tolerated. The following sections will provide information for deploying Azure Stack HCI OS on a single server, configuring the single-server, cluster creation, and more.

To review single-server supported systems or to size a single-server, see the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/).

> [!IMPORTANT]
> Using PowerShell is the only supported method for a single-server deployment. Windows Admin Center (WAC) can be used to manage specific components following a successful deployment.

## **Prerequisites**

- A single server with only type NVMe or SSD drives from the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/catalog).
- For network, hardware and other requirements, see [Azure Stack HCI network and domain requirements](../deploy/operating-system.md#determine-hardware-and-network-requirements).
- Optionally, [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) (WAC) to register and manage the server once it has been configured.

## **Getting started**

Before you can configure your purchased single server, follow these instructions to [deploy Azure Stack HCI OS](../deploy/operating-system.md#manual-deployment) onto your server.

## **Configure single-server**

Here are the steps to configure Azure Stack HCI OS on a single server.
> [!NOTE]
> Cluster witness is not required for a single server deployment.

1. After successfully deploying the Azure Stack HCI OS, configure the 21H2 HCI server utilizing the [Server Configuration Tool](/windows-server/administration/server-core/server-core-sconfig) (SConfig).
1. Use PowerShell to [create a cluster](../deploy/create-cluster-powershell.md), *recommended*.
1. Use PowerShell to [add a server](../manage/cluster-powershell#add-or-remove-a-server) to the cluster.
    1. Optionally, you may choose to [add a server using WAC](/windows-server/manage/windows-admin-center/use/manage-servers#adding-a-server-to-windows-admin-center).
1. Use PowerShell to [Register a cluster](../deploy/register-with-azure#register-a-cluster-using-powershell)
    1. Optionally, you may choose to [register your cluster using WAC](../deploy/register-with-azure#register-a-cluster-using-windows-admin-center)
1. [Create volumes](../manage/create-volumes#create-volumes-using-windows-powershell) with PowerShell, *recommended*.

Now that you've completed the single server configuration, you're ready to deploy your workload.
