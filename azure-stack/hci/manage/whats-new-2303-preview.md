---
title: What's in Azure Stack HCI, 2303 Supplemental Package and preview channel (preview)
description: Preview features and OS versions available via preview channel and 2303 supplemental package features.
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/30/2023
---

# What's in preview for Azure Stack HCI, 2303 release (preview)

> Applies to: Azure Stack HCI preview channel and Supplemental Package

This article describes the new features or enhancements that are currently available in the preview for Azure Stack HCI. This article includes:

- [What's in the preview channel](#azure-stack-hci-preview-channel).
- [What's in the Azure Stack HCI, Supplemental Package](#azure-stack-hci-2303-supplemental-package-preview).

## Azure Stack HCI preview channel

The Azure Stack HCI preview channel features preview versions of Azure Stack HCI OS release. For more information, see [Join the preview channel](./preview-channel.md).

## Azure Stack HCI, 2303 Supplemental Package (preview)

Azure Stack HCI, 2303 Supplemental Package is now in preview. You can deploy this package on servers running the English version of the Azure Stack HCI, version 22H2 OS. For more information on Azure Stack HCI, version 22H2, see [What's new](../whats-new.md).

[!INCLUDE [hci-deployment-tool-sp](../../includes/hci-deployment-tool-sp.md)]

To learn more about the new deployment methods, see [Deployment overview](../deploy/deployment-tool-introduction.md).


### What's new

The following new features are available in the 2303 preview release of Supplemental Package:

- **ISO refresh** - In this release, the ISO for the installation of Azure Stack HCI, version 22H2 operating system is refreshed to include the latest cumulative update corresponding to March 2023.  

    > [!NOTE]
    > The Supplemental Package supports only the English version of the Azure Stack HCI OS. Make sure to download the English version and use the refreshed ISO. For more information on March release, see [Azure Stack HCI, version 22H2 OS build 20349.1607](../release-information.md#azure-stack-hci-version-22h2-os-build-20349).

- **Solution Updates** - Starting with this release, we're introducing the Solution Updates functionality that will let you update to the next preview release. To learn more about the new update experience, go to [What's the Lifecycle Manager?](../update/whats-the-lifecycle-manager.md) and [Keep your Azure Stack HCI up-to-date](../update/update-azure-stack-hci-solution.md).

- **Validate deployment** - Beginning this release, you can choose to validate the deployment configuration before you run it. The validation assesses the environment readiness and ensures that the actual deployment proceeds smoothly. For more information, see the validate deployment step in how to [Deploy interactively](../deploy/deployment-tool-new-file.md#step-5-validate-and-deploy).

- **Cluster witness** - Starting this release, you can configure the cluster witness from within the deployment tool. Use an Azure Storage account to define a cloud witness or provide a path to an SMB share for a local witness. For more information, see the clustering step in how to [Deploy interactively](../deploy/deployment-tool-new-file.md#step-3-cluster).


Here are the changes to the existing features in this release:

- **Retention of deployment tool UX** - In earlier versions, the deployment tool instance was deleted once the deployment was complete. Beginning this release, the deployment tool UX continues to be available even when the deployment has completed. 

    Once you connect to your Azure Stack HCI cluster via the Windows Admin Center for the first time, the deployment UX is uninstalled automatically.

- **Trusted hosts settings** - After you've installed the Azure Stack HCI operating system on your servers, you're no longer required to configure the trusted hosts setting. For more information, see the modified steps in [Install required Windows Roles](../deploy/deployment-tool-install-os.md#install-required-windows-roles).

- **Parameters for `Invoke-CloudDeployment` cmdlet** - The parameters for `Invoke-CloudDeployment` cmdlet have changed. For more information, see the [Parameters used for `Invoke-CloudDeployment`](../deploy/deployment-tool-powershell.md#get-information-for-the-required-parameters).

- **Lifecycle Manager account** - With this release, Deployment user account has changed to Lifecycle Manager account.  


## Next steps

- [Join the preview channel](./preview-channel.md) and [install a preview version of Azure Stack HCI](./install-preview-version.md).

- For new Azure Stack HCI deployments via supplemental package:
    - Read the [Deployment overview](../deploy/deployment-tool-introduction.md).
    - Learn how to [Deploy interactively](../deploy/deployment-tool-new-file.md) using the Azure Stack HCI, Supplemental Package.