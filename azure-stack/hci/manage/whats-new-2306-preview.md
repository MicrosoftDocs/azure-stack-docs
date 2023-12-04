---
title: What's in Azure Stack HCI, 2306 Supplemental Package and preview channel (preview)
description: Preview features and OS versions available via preview channel and 2306 supplemental package features.
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/30/2023
---

# What's in preview for Azure Stack HCI, 2306 release (preview)

> Applies to: Azure Stack HCI preview channel and Supplemental Package

This article describes the new features or enhancements that are currently available in the preview for Azure Stack HCI. This article includes:

- [What's in the preview channel](#azure-stack-hci-preview-channel).
- [What's in the Azure Stack HCI, Supplemental Package](#azure-stack-hci-2306-supplemental-package-preview).

## Azure Stack HCI preview channel

The Azure Stack HCI preview channel features preview versions of Azure Stack HCI OS release. For more information, see [Join the preview channel](./preview-channel.md).

## Azure Stack HCI, 2306 Supplemental Package (preview)

Azure Stack HCI, 2306 Supplemental Package is now in preview. You can deploy this package on servers running the English version of the Azure Stack HCI, version 22H2 OS. For more information on Azure Stack HCI, version 22H2, see [What's new](../whats-new.md).

[!INCLUDE [hci-deployment-tool-sp](../../includes/hci-deployment-tool-sp-2306.md)]

To learn more about the new deployment methods, see [Deployment overview](../deploy/deployment-tool-introduction.md).


### What's new

The following new features are available in the 2306 preview release of Supplemental Package:

- **ISO refresh** - In this release, the ISO for the installation of Azure Stack HCI, version 22H2 operating system is refreshed to include the latest cumulative update corresponding to June 2023.  

    > [!NOTE]
    > The Supplemental Package supports only the English version of the Azure Stack HCI OS. Make sure to download the English version and use the refreshed ISO. For more information on June release, see [Azure Stack HCI, version 22H2 OS build 20349.1787](../release-information.md#azure-stack-hci-version-22h2-os-build-20349).

- **Use existing data disks for storage** - Beginning this release, you can deploy a single server cluster using existing data drives. Use this option when you try to repair this server.  
- **Remove requirement for D: drive** - In this release, the requirement of boot (C: drive) partition and data (D:) partition is removed. This partition was created when you installed the operating system on your Azure Stack HCI servers. For more information, see [Install the v22H2 OS](../deploy/deployment-tool-install-os.md#boot-and-install-the-operating-system) on your Azure Stack HCI.
- **Manage capacity on your cluster** - Starting this release, you can manage the cluster capacity by adding servers to your cluster. You can also repair a server in an existing cluster. For more information, see [Add a server](./add-server.md) and [Repair a server](./repair-server.md) in your Azure Stack HCI cluster.


## Next steps

- [Join the preview channel](./preview-channel.md) and [install a preview version of Azure Stack HCI](./install-preview-version.md).

- For new Azure Stack HCI deployments via supplemental package:
    - Read the [Deployment overview](../deploy/deployment-tool-introduction.md).
    - Learn how to [Deploy interactively](../deploy/deployment-tool-new-file.md) using the Azure Stack HCI, Supplemental Package.