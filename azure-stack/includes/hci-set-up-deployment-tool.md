---
author: ManikaDhiman
ms.author: v-mandhiman
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 02/01/2023
ms.reviewer: alkohli
---

For servers running Azure Stack HCI, version 22H2 OS, you can perform new deployments using the Azure Stack HCI, Supplemental Package (preview). You can deploy an Azure Stack HCI cluster via a brand new deployment tool in one of the three ways - interactively, using an existing configuration file, or via PowerShell.

> [!IMPORTANT]
> When you try out this new deployment tool, make sure that you do not run production workloads on systems deployed with the Supplemental Package while it's in preview even with the core operating system Azure Stack HCI 22H2 being generally available. Microsoft Customer Support will supply support services while in preview, but service level agreements available at GA do not apply.

You can download the Supplemental Package here:  

| Azure Stack HCI Supplemental Package component| URL                                             |
|-----------------------------------------------|-------------------------------------------------|
| Bootstrap PowerShell                           | https://go.microsoft.com/fwlink/?linkid=2210545 |
| CloudDeployment.zip                           | https://go.microsoft.com/fwlink/?linkid=2210546 |
| Verify Cloud Deployment PowerShell            | https://go.microsoft.com/fwlink/?linkid=2210608 |

To learn more about the new deployment methods, see [Deployment overview](../hci/deploy/deployment-tool-introduction.md).