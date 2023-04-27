---
title: What's in Azure Stack HCI, 2303.1 Supplemental Package and preview channel (preview)
description: Preview features and OS versions available via preview channel and 2303.1 supplemental package features.
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/26/2023
---

# What's in preview for Azure Stack HCI, 2303.1 release (preview)

> Applies to: Azure Stack HCI preview channel and Supplemental Package

This article describes the new features or enhancements that are currently available in the preview for Azure Stack HCI. This article includes:

- [What's in the preview channel](#azure-stack-hci-preview-channel).
- [What's in the Azure Stack HCI, Supplemental Package](#azure-stack-hci-2303-supplemental-package-preview).

## Azure Stack HCI preview channel

The Azure Stack HCI preview channel features preview versions of Azure Stack HCI OS release. For more information, see [Join the preview channel](./preview-channel.md).

## Azure Stack HCI, 2303.1 Supplemental Package (preview)

Azure Stack HCI, 2303.1 Supplemental Package is now in preview. This package deploys on servers running Azure Stack HCI, version 22H2, which is now generally available. For more information on Azure Stack HCI, version 22H2, see [What's new](../whats-new.md).

> [!IMPORTANT]
> When you try out this new deployment tool, make sure that you do not run production workloads on systems deployed with the Supplemental Package while it's in preview even with the core operating system Azure Stack HCI 22H2 being generally available. Microsoft Customer Support will supply support services while in preview, but service level agreements available at GA do not apply.


### Download Azure Stack HCI, 2303.1 Supplemental Package

Follow these steps to download the Supplemental Package files:  

1. Go to [Download Azure Stack HCI 22H2](https://azure.microsoft.com/products/azure-stack/hci/hci-download/) and fill out and submit a trial form.

1. On the **Azure Stack HCI software download** page, go to **Supplemental package for Azure Stack HCI 22H2 (public preview)**. 

    :::image type="content" source="../manage/media/whats-in-preview/azure-stack-hci--supplemental-package-download.png" alt-text="Screenshot of the Azure Stack HCI v22H2 Supplemental Package download.":::

    You can download the following files:
    - *Bootstrap PowerShell*.
    - *CloudDeployment.zip*.
    - *Verify Cloud Deployment PowerShell*.

To learn more about the new deployment methods, see [Deployment overview](../deploy/deployment-tool-introduction.md).


### What's new

The following new features are available in the 2303.1 preview release of Supplemental Package:

- **Scale out using Storage Switched host networking pattern** - In this release, you can scale out your single node deployments to two nodes using the storage switched host networking pattern. You can now define a storage network intent for storage RDMA network interfaces and also add a second top-of-rack switch to provide redundancy if required. For more information, see the [Storage switched host networking pattern](../plan/two-node-switched-non-converged.md). 

- **Update improvements** - In this release, the following enhancements have been made for the solution updates: 
    - Starting with this release, the solution update runs will display the start time and the last updated time for the various update phases while the update is in progress. <!--To learn more about update times, see [Track the update progress](../index.yml).-->
    - With this release, you can update the cluster nodes following the addition or replacement of a node.
    - SBE toolkit is available in this release. <!--To download this toolkit, go to: []().-->

- **Multi-language support for deployment tool** - Beginning this release, the deployment tool will support multiple languages. <!--DO WE HAVE INFO ON LANGUAGES SUPPORTED?-->


## Next steps

- [Join the preview channel](./preview-channel.md) and [install a preview version of Azure Stack HCI](./install-preview-version.md).

- For new Azure Stack HCI deployments via supplemental package:
    - Read the [Deployment overview](../deploy/deployment-tool-introduction.md).
    - Learn how to [Deploy interactively](../deploy/deployment-tool-new-file.md) using the Azure Stack HCI, Supplemental Package.