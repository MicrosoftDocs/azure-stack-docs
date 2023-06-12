---
title: What's in Azure Stack HCI, 2303.1 Supplemental Package and preview channel (preview)
description: Preview features and OS versions available via preview channel and 2303.1 supplemental package features.
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/15/2023
---

# What's in preview for Azure Stack HCI, 2303.1 release (preview)

> Applies to: Azure Stack HCI preview channel and Supplemental Package

This article describes the new features or enhancements that are currently available in the preview for Azure Stack HCI. This article includes:

- [What's in the preview channel](#azure-stack-hci-preview-channel)?
- [What's in the Azure Stack HCI, Supplemental Package](#azure-stack-hci-23031-supplemental-package-preview).

## Azure Stack HCI preview channel

The Azure Stack HCI preview channel features preview versions of Azure Stack HCI OS release. For more information, see [Join the preview channel](./preview-channel.md).

## Azure Stack HCI, 2303.1 Supplemental Package (preview)

Azure Stack HCI, 2303.1 Supplemental Package is now in preview. This package deploys on servers running Azure Stack HCI, version 22H2, which is now generally available. For more information on Azure Stack HCI, version 22H2, see [What's new](../whats-new.md).

> [!IMPORTANT]
> Update to Azure Stack HCI, 2303.1 Supplemental Package only if you have an existing deployment of Azure Stack HCI, 2303 Supplemental Package.

To update to this release, see how to [Update your Azure Stack HCI solution via PowerShell](../update/update-via-powershell.md).


### What's new

The following new features are available in the 2303.1 preview release of Supplemental Package:

- **Updated OS build** - This release includes Azure Stack HCI, version 22H2 operating system refreshed to include the latest cumulative update corresponding to April 2023. Make sure to download the latest ISO. For more information on April release, see [Azure Stack HCI, version 22H2 OS build 20349.1688](../release-information.md#azure-stack-hci-version-22h2-os-build-20349).

- **Scale out using Storage Switched host networking pattern** - In this release, you can scale out your single node deployments to two nodes using the storage switched host networking pattern. You can now define a storage network intent for storage RDMA network interfaces and also add a second top-of-rack switch to provide redundancy if necessary. For more information, see the [Storage switched host networking pattern](../plan/two-node-switched-non-converged.md). 

- **Update improvements** - In this release, the following enhancements have been made for the solution updates: 
    - Starting with this release, the solution update runs will display the start time and the last updated time for the various update phases while the update is in progress. To learn more about update times, see [Track the update progress](../update/update-via-powershell.md#step-4-download-check-readiness-and-install-updates).
    - With this release, you can update the cluster nodes following the addition or replacement of a node.


## Next steps

- [Join the preview channel](./preview-channel.md) and [install a preview version of Azure Stack HCI](./install-preview-version.md).

- For new Azure Stack HCI deployments via supplemental package:
    - Read the [Deployment overview](../deploy/deployment-tool-introduction.md).
    - Learn how to [Deploy interactively](../deploy/deployment-tool-new-file.md) using the Azure Stack HCI, Supplemental Package.