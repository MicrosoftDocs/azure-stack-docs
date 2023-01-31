---
title: What's in Azure Stack HCI, 2301 Supplemental Package and preview channel (preview)
description: Preview features and OS versions available via preview channel and 2301 supplemental package features.
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 01/31/2022
---

# What's in preview for Azure Stack HCI, 2301 release (preview)

> Applies to: Azure Stack HCI preview channel and Supplemental Package

This article describes the new features or enhancements that are currently available in the preview for Azure Stack HCI. This article includes:

- [What's in the preview channel](#azure-stack-hci-preview-channel).
- [What's in the Azure Stack HCI, Supplemental Package](#azure-stack-hci-supplemental-package-preview).

## Azure Stack HCI preview channel

The Azure Stack HCI preview channel features preview versions of Azure Stack HCI OS release. For more information, see [Join the preview channel](./preview-channel.md).

## Azure Stack HCI, 2301 Supplemental Package (preview)

Azure Stack HCI, 2301 Supplemental Package is now in preview. This package deploys on servers running Azure Stack HCI, version 22H2, which is now generally available. For more information on Azure Stack HCI, version 22H2 see [What's new](../whats-new.md).

> [!IMPORTANT]
> When you try out this new deployment tool, make sure that you do not run production workloads on systems deployed with the Supplemental Package while it's in preview even with the core operating system Azure Stack HCI 22H2 being generally available. Microsoft Customer Support will supply support services while in preview, but service level agreements available at GA do not apply.

You can download the Supplemental Package here:  

| Azure Stack HCI Supplemental Package component| URL                                             |
|-----------------------------------------------|-------------------------------------------------|
| Bootstrap PowerShell                           | https://go.microsoft.com/fwlink/?linkid=2210545 |
| CloudDeployment.zip                           | https://go.microsoft.com/fwlink/?linkid=2210546 |
| Verify Cloud Deployment PowerShell            | https://go.microsoft.com/fwlink/?linkid=2210608 |

To learn more about the new deployment methods, see [Deployment overview](../hci/deploy/deployment-tool-introduction.md).

The following new features are available in the 2301 preview release of Supplemental Package:

- **Creation of workload and infrastructure volumes**. In this release, you can create workload volumes in addition to the infrastructure volumes used by Azure Stack HCI cluster. For more information, see the **Create workload and infrastructure volume** of how to [Deploy interactively](../deploy/deployment-tool-new-file.md) using the Azure Stack HCI, Supplemental package.

- **Download deployment log and deployment report**. Beginning this release, you have the option to download deployment logs and deployment report after the deployment is complete. For more information, see the last step of how to [Deploy interactively](../deploy/deployment-tool-new-file.md) to download deployment log and report.


## Next steps

- [Join the preview channel](./preview-channel.md) and [install a preview version of Azure Stack HCI](./install-preview-version.md)

- For new Azure Stack HCI deployments via supplemental package:
    - Read the [Deployment overview](../deploy/deployment-tool-introduction.md).
    - Learn how to [Deploy interactively](../deploy/deployment-tool-new-file.md) using the Azure Stack HCI, Supplemental Package.

