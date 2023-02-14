--- 
title: Set up the first server for new Azure Stack HCI deployments (preview) 
description: Learn how to set up the first server before you deploy Azure Stack HCI (preview).
author: ManikaDhiman
ms.topic: how-to
ms.date: 02/02/2023
ms.author: v-mandhiman
ms.reviewer: alkohli
ms.subservice: azure-stack-hci
---

# Set up the first server for new Azure Stack HCI deployment (preview)

[!INCLUDE [applies-to](../../includes/hci-applies-to-supplemental-package.md)]

This article describes how to set up the first server in the cluster for a new Azure Stack HCI deployment. The first server listed for the cluster acts as a staging server in the deployment.

The deployment tool is included in the Azure Stack HCI Supplemental Package. You need to install and set up the deployment tool only on the first server in the cluster.

[!INCLUDE [important](../../includes/hci-preview.md)]

## Prerequisites

Before you begin, make sure you've done the following:

- Satisfy the [prerequisites](deployment-tool-prerequisites.md).
- Complete the [deployment checklist](deployment-tool-checklist.md).
- Prepare your [Active Directory](deployment-tool-active-directory.md) environment.
- [Install version 22H2 OS](deployment-tool-install-os.md) on each server.

## Download the Supplemental Package

[!INCLUDE [hci-deployment-tool-sp](../../includes/hci-deployment-tool-sp.md)]

## Connect to the first server

Follow these steps to connect to the first server:

1. In the deployment wizard, select the **first server listed for the cluster to act as a staging server** during deployment.

1. Sign in to the first server using local administrative credentials.

1. Copy the [Supplemental Package that you downloaded previously](#download-the-supplemental-package) to any drive other than the C:\ drive of the first server.

## Set up the deployment tool

[!INCLUDE [hci-set-up-deployment-tool](../../includes/hci-set-up-deployment-tool.md)]

## Next steps

After setting up the first server in your cluster, you're ready to run the deployment tool. You can either create a new deployment configuration file interactively or use an existing configuration file you created:

- [Deploy using a new configuration file](deployment-tool-new-file.md).
- [Deploy using an existing configuration file](deployment-tool-existing-file.md).
- If preferred, you can also [deploy using PowerShell](deployment-tool-powershell.md).