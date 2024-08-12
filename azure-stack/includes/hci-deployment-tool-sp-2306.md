---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 11/30/2023
---

> [!IMPORTANT]
> When you try out this new deployment tool, make sure that you do not run production workloads on systems deployed with the Supplemental Package while it's in preview even with the core operating system Azure Stack HCI 22H2 being generally available. Microsoft Customer Support will supply support services while in preview, but service level agreements available at GA do not apply.
>
> Azure Stack HCI, 2306 Supplemental Package is supported for customers’ production workloads when deployed on Dell APEX Cloud Platform for Microsoft Azure.

Follow these steps to download the Supplemental Package files:  

1. [Download the Azure Stack HCI operating system from the Azure portal](../hci/deploy/download-azure-stack-hci-software.md). Make sure to select **English** from the **Choose language** dropdown list.

1. Download the following Supplemental Package files:

    | Azure Stack HCI Supplemental Package component|  Description |
    |---------------------------------------------- |---------------------- |
    |[*BootstrapCloudDeploymentTool.ps1*](https://go.microsoft.com/fwlink/?linkid=2210545) | Script to extract content and launch the deployment tool. When this script is run with the `-ExtractOnly` parameter, it will extract the zip file but not launch the deployment tool. |
    | [*CloudDeployment.zip*](https://go.microsoft.com/fwlink/?linkid=2210546) | Azure Stack HCI, version 22H2 content, such as images and agents. |
    | [*Verify-CloudDeployment.ps1*](https://go.microsoft.com/fwlink/?linkid=2210608) | Hash used to validate the integrity of zip file. |