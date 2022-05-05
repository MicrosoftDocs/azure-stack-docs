---
title: Configure Azure Stack HCI OS - Single Server 
description: This article describes Azure Stack HCI OS configuration on a single server
author: robess
ms.author: robess
ms.topic: how-to
ms.reviewer: kerimhanif
ms.lastreviewed: 04/28/2022
ms.date: 04/04/2022
---

# Azure Stack HCI OS - single server configuration

> Applies to: Azure Stack HCI, version 21H2

The following sections will provide information for deploying Azure Stack HCI OS on a single server, configuring the single server, cluster creation, and more.

To review single server supported systems, see the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/).

## Prerequisites

- A single server configured with all NVMe or all SSD drives from the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/catalog).

> [!NOTE]
> Single server is only supported on single storage type configurations.

- For network, hardware and other requirements, see [Azure Stack HCI network and domain requirements](../deploy/operating-system.md#determine-hardware-and-network-requirements).
- Optionally, [install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) (WAC) to register and manage the server once it has been configured.

## Getting started

Before you can configure your purchased single server, follow these instructions to [deploy Azure Stack HCI OS](../deploy/operating-system.md#manual-deployment) onto your server.

## Configure single server

Here are the steps to configure the Azure Stack HCI OS, on a single server, after it has been successfully deployed.
> [!NOTE]
> Cluster witness is not required for a single server deployment.

1. Configure the server utilizing the [Server Configuration Tool](/windows-server/administration/server-core/server-core-sconfig) (SConfig).
1. Use PowerShell to [create a cluster](../deploy/create-cluster-powershell.md).
1. Use PowerShell to [add a server](../manage/cluster-powershell.md#add-or-remove-a-server) to the cluster.
1. Use [PowerShell](../deploy/register-with-azure.md#register-a-cluster-using-powershell) or [WAC](../deploy/register-with-azure.md#register-a-cluster-using-windows-admin-center) to register the cluster.
1. [Create volumes](../manage/create-volumes.md#create-volumes-using-windows-powershell) with PowerShell.

Now that you've completed the single server configuration, you're ready to deploy your workload.

> [!IMPORTANT]
> For Azure StackHCI 21H2 using PowerShell is the only supported method for a single server deployment. Windows Admin Center (WAC) can be used to manage specific components following a successful deployment.

## Next steps

- [Deploy workload – AVD](../deploy/virtual-desktop-infrastructure.md)
- [Deploy workload – AKS-HCI](/azure-stack/aks-hci/overview.md)
- [Deploy workload – Azure Arc-enabled data services](/azure/azure-arc/data/overview.md)