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

# **Azure Stack HCI OS - Single-Server**
> Applies to: Azure Stack HCI, version 21H2

The implementation of a single-server configuration aims to provide flexibility, hardware resiliency, and cost savings in scenarios where lower  resiliency can be tolerated. To review single-server supported systems or to size a single-server, see the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/).

The following sections will provide information for installing Azure Stack HCI OS on a single server.

> [!IMPORTANT]
> Using PowerShell is the only supported method for a single-server deployment.
## **Prerequisites**

- A single server with only type NVMe or SSD drives from the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/catalog).
- For network, hardware and other requirements, see [Azure Stack HCI network and domain requirements](../deploy/operating-system.md#determine-hardware-and-network-requirements).
- Optional, you can utilize [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) (WAC) to register and manage the server once it has been configured.

## **Single-Server Steps**

Here are the steps to deploy Azure Stack HCI OS on a single server.
> [!NOTE]
> Cluster witness is not required for single server.

1. Deploy [Azure Stack HCI OS](../deploy/operating-system.md#manual-deployment).
2. Configure the 21H2 HCI server with the [Server Configuration Tool](/windows-server/administration/server-core/server-core-sconfig) (SConfig).
3. Using PowerShell, [Create a Cluster](../deploy/create-cluster-powershell.md).
4. Optional, [add server to Windows Admin Center](/windows-server/manage/windows-admin-center/use/manage-servers#adding-a-server-to-windows-admin-center).

5. [Register cluster with Azure](../deploy/register-with-azure.md), using PowerShell or WAC.
6. [Create Volumes]() with PowerShell.

Now that you've completed the single server configuration, you're ready to deploy your workload.
