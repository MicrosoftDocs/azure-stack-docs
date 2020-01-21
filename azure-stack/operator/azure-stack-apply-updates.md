---
title: Install Azure Stack Hub Updates | Microsoft Docs
description: Learn how to install Azure Stack Hub Updates.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 09/10/2019
ms.author: mabrigg
ms.lastreviewed: 09/10/2019
ms.reviewer: ppacent 

---

# Install Azure Stack Hub Updates

You can install update packages using the **Update** blade in the Azure Stack Hub. This article walks you through the steps to update, monitor, and troubleshoot the update process. Use the Update blade to view update info, install updates, monitor update progress, review update history, and view the current Azure Stack Hub and OEM package version.

You can manage updates from the administrator portal and use the **Updates** section of the dashboard to:

- View important info, such as the current version.
- Install updates and monitor progress.
- Review update history for previously installed updates.
- View the cloud's current OEM package version.

## Determine the current version

You can view the current version of Azure Stack Hub in the **Updates** blade. To open:

1.  Open the Azure Stack Hub administrator portal.

2.  Select **Dashboard**. In the **Updates** blade, the current version is listed.

    ![Updates tile on default dashboard](./media/azure-stack-update-apply/image1.png)

    For example, in this image the version is 1.1903.0.35.

## Install updates and monitor progress

> [!Important]
> Before applying updates in Azure Stack Hub, ensure you have completed **ALL** steps in the [Pre-Update Checklist](release-notes-checklist.md) and have scheduled an appropriate maintenance window for the update type that you are applying.

1. Open the Azure Stack Hub administrator portal.

2. Select **Dashboard**. Select **Update**.

3. Select the available update that you wish to install. If you don't have an update marked as **Available**, you need to [Prepare the Update Package](azure-stack-update-prepare-package.md)

4. Select **Update now**.

    ![Azure Stack Hub update run details](./media/azure-stack-update-apply/image2.png)

5. You can view high-level status as the update process iterates through various subsystems in Azure Stack Hub. Example subsystems include physical hosts, Service Fabric, infrastructure virtual machines, and services that provide both the admin and user portals. Throughout the update process, the update resource provider reports additional details about the update, such as the number of steps that have succeeded, and the number in progress.

6. Select the **Download summary** from the Update run details blade to download full logs.

    If you run into an issue while monitoring the update, you can use the [privileged endpoint](https://docs.microsoft.com/azure-stack/operator/azure-stack-privileged-endpoint) to monitor the progress of an Azure Stack Hub update run. You can also use the privileged endpoint to resume a failed update run from the last successful step if the Azure Stack Hub portal becomes unavailable. For instructions, see [Monitor updates in Azure Stack Hub using PowerShell](azure-stack-update-monitor.md).

    ![Azure Stack Hub update run details](./media/azure-stack-update-apply/image3.png)

7. Once completed, the update resource provider provides a **Succeeded** confirmation to show that the update process has finished and how long it took. From there, you can view info on all updates, available updates, or installed updates using the filter.

    ![azure-stack-update-apply](./media/azure-stack-update-apply/image4.png)

    If the update fails, the **Update** blade reports **Needs attention**. Use the **Download full logs** option to get a high-level status of where the update failed. The Azure Stack Hub log collection helps with diagnostics and troubleshooting.

## Review update history

1. Open the administrator portal.

2. Select **Dashboard**. Select **Update**.

3. Select **Update history**.

    ![Azure Stack Hub update history](./media/azure-stack-update-apply/image7.png)

## Next steps

-   [Manage updates in Azure Stack Hub overview](https://docs.microsoft.com/azure-stack/operator/azure-stack-updates)  
-   [Azure Stack Hub servicing policy](https://docs.microsoft.com/azure-stack/operator/azure-stack-servicing-policy)  
