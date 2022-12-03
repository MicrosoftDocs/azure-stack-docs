---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 12/03/2022
---

In this release, you can perform new deployments using the Azure Stack HCI, Supplemental Package (preview). The new deployment tool can be launched on servers running Azure Stack HCI, version 22H2 OS. You can deploy an Azure Stack HCI cluster via a brand new deployment tool in one of the three ways - interactively, using an existing configuration file or via PowerShell.

When you try out this new deployment tool, make sure that you do not run production workloads on systems deployed with the supplemental package while it's in preview even with the core operating system Azure Stack HCI 22H2 being generally available. Microsoft Customer Support will supply support services while in preview, but service level agreements available at GA do not apply.

To learn more about the new deployment methods, see [Deployment overview](./deploy/deployment-tool-introduction.md). You can download the Supplemental Package here:  

| Azure Stack HCI Supplemental Package component| URL                                             |
|-----------------------------------------------|-------------------------------------------------|
| Bootstrap PowerShell                           | https://go.microsoft.com/fwlink/?linkid=2210545 |
| CloudDeployment.zip                           | https://go.microsoft.com/fwlink/?linkid=2210546 |
| Verify Cloud Deployment PowerShell            | https://go.microsoft.com/fwlink/?linkid=2210608 |