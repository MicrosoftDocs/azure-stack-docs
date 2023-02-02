---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 02/02/2023
---

> [!IMPORTANT]
> When you try out this new deployment tool, make sure that you do not run production workloads on systems deployed with the Supplemental Package while it's in preview even with the core operating system Azure Stack HCI 22H2 being generally available. Microsoft Customer Support will supply support services while in preview, but service level agreements available at GA do not apply.

You can download the Supplemental Package here:  

| Azure Stack HCI Supplemental Package component| Download URL | Description |
|- |- |- |
| BootstrapCloudDeploymentTool.ps1 | [Download](https://go.microsoft.com/fwlink/?linkid=2210545 )| Script to extract content and launch the deployment tool.. When this script is run with -ExtractOnly parameter, it will extract the zip file but not launch the deployment tool. |
| CloudDeployment.zip | [Download](https://go.microsoft.com/fwlink/?linkid=2210546)|Azure Stack HCI, version 22H2 content such as images and agents. |
| Verify-CloudDeployment.ps1 | [Download](https://go.microsoft.com/fwlink/?linkid=2210608) | Hash used to validate the integrity of zip file. |