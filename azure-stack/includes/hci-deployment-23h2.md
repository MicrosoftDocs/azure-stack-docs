---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 10/04/2023
---

> [!IMPORTANT]
> Make sure that you do not run production workloads on systems deployed with this preview package, even with the core operating system Azure Stack HCI 23H2 being generally available. Microsoft Customer Support will supply support services while in preview, but service level agreements available at GA do not apply.

Go to the Microsoft Collaborate site and download the 23H2 preview package, which contain the following files:

| 23H2 preview content|  Description |
|---------------------------------------------- |---------------------- |
|[*BootstrapCloudDeploymentTool.ps1*](https://go.microsoft.com/fwlink/?linkid=2210545) | Script to extract content and launch the deployment tool. When this script is run with the `-ExtractOnly` parameter, it will extract the zip file but not launch the deployment tool. |
| [*CloudDeployment.zip*](https://go.microsoft.com/fwlink/?linkid=2210546) | Lifecycle Manager. |
| [*Verify-CloudDeployment.ps1*](https://go.microsoft.com/fwlink/?linkid=2210608) | Hash used to validate the integrity of zip file. |