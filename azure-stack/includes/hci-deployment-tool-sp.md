---
author: alkohli
ms.author: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.topic: include
ms.date: 05/05/2023
---

> [!IMPORTANT]
> When you try out this new deployment tool, make sure that you do not run production workloads on systems deployed with the Supplemental Package while it's in preview even with the core operating system Azure Stack HCI 22H2 being generally available. Microsoft Customer Support will supply support services while in preview, but service level agreements available at GA do not apply.

Follow these steps to download the Supplemental Package files:  

1. Go to [Download Azure Stack HCI 22H2](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) and fill out and submit a trial form.

1. On the **Azure Stack HCI software download** page, go to **Supplemental package for Azure Stack HCI 22H2 (public preview)**. 

    :::image type="content" source="../hci/manage/media/whats-in-preview/azure-stack-hci--supplemental-package-download.png" alt-text="Screenshot of the Azure Stack HCI v22H2 Supplemental Package download.":::

1. Download the following files: 

    | Azure Stack HCI Supplemental Package component|  Description |
    |---------------------------------------------- |---------------------- |
    |*BootstrapCloudDeploymentTool.ps1* | Script to extract content and launch the deployment tool. When this script is run with the `-ExtractOnly` parameter, it will extract the zip file but not launch the deployment tool. |
    | *CloudDeployment.zip* | Azure Stack HCI, version 22H2 content, such as images and agents. |
    | *Verify-CloudDeployment.ps1* | Hash used to validate the integrity of zip file. |