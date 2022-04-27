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

A single-server aims to provide flexibility, hardware resiliency, and cost savings for users with lower resiliency environments. The following sections will provide information for installing Azure Stack HCI OS on a single server.

To review single-server supported systems or to size a single-server, see the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/)

> [!IMPORTANT]
> Using PowerShell is the supported method for single-server deployment. Windows Admin Center may be used to register and manage the single server once configured.
## **Prerequisites**

- A single server with only type NVMe or SSD drives from the [Azure Stack HCI Catalog](https://hcicatalog.azurewebsites.net/#/).
- For network, hardware and other requirements, see [Azure Stack HCI network and domain requirements](../deploy/operating-system.md#determine-hardware-and-network-requirements).
- Optional, [Install Windows Admin Center](/windows-server/manage/windows-admin-center/deploy/install) (WAC).

## **Single-Server Steps**

Here are the steps to deploy Azure Stack HCI OS on a single server. 

1. Deploy [Azure Stack HCI OS](../deploy/operating-system.md#manual-deployment).
2. Configure 21H2 HCI server with the [Server Configuration Tool](/windows-server/administration/server-core/server-core-sconfig) (SConfig).
3. Using PowerShell, [create a Cluster](../deploy/create-cluster-powershell.md).
4. Optional, [add server to Windows Admin Center](/windows-server/manage/windows-admin-center/use/manage-servers#adding-a-server-to-windows-admin-center).

> [!NOTE]
> Cluster witness is not required for single node.

5. [Register cluster with Azure](../deploy/register-with-azure.md), use PowerShell or WAC.
6. [Create Volumes]() with PowerShell.

> [!Note]
> Create Volume for single node is only supported with PowerShell.

Now that you've completed the single server configuration, you're ready to deploy your workload.
