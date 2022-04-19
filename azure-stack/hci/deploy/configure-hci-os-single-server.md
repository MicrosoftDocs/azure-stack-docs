---
title: Configure Azure Stack HCI OS - Single-Server 
description: This article describes Azure Stack HCI OS on a Single Server
author: robess
ms.author: robess
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/04/2022
---

# **Azure Stack HCI OS - Single-Server**
> Applies to: Azure Stack HCI, version 21H2

The following sections will provide configuration steps, when installing Azure Stack HCI OS on a single node.

> [!IMPORTANT]
> PowerShell is the only supported configuration option for single-node.

To review single-server supported systems or to size a single-server, see the [Catalog](https://hcicatalog.azurewebsites.net/#/)


## Prerequisites

- Follow [Azure Stack HCI network and domain requirements](../deploy/operating-system.md#determine-hardware-and-network-requirements).
- [Download](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) Azure Stack HCI software.
- [Deploy](/azure-stack/hci/deploy/operating-system#manual-deployment) Azure Stack HCI OS.
- Optional, [Install Windows Admin Center](https://docs.microsoft.com/windows-server/manage/windows-admin-center/deploy/install) (WAC).

## **Single-Server**

1. [Deploy OS](../deploy/operating-system.md#manual-deployment)
1. Configure 21H2 HCI server with the [Server Configuration Tool](https://docs.microsoft.com/windows-server/administration/server-core/server-core-sconfig) (SConfig).

1. [Create a Cluster with PowerShell](../deploy/create-cluster-powershell.md)
1. Optional, [add server to Windows Admin Center (WAC)](https://docs.microsoft.com/windows-server/manage/windows-admin-center/use/manage-servers#adding-a-server-to-windows-admin-center) cluster manager and server manager.

> [!NOTE]
> Cluster witness is not required for single node.

5. [Register cluster with Azure](../deploy/register-with-azure.md). Use PowerShell or WAC.

6. [Create Volumes]() with PowerShell.

> [!Note]
> Create Volume for single node is only supported with PowerShell.