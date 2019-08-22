---
title: Apply updates in Azure Stack | Microsoft Docs
description: Learn how to import and install Microsoft update packages for an Azure Stack integrated system.
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
ms.date: 04/25/2019
ms.author: mabrigg
ms.reviewer: justini
ms.lastreviewed: 02/11/2019

---

# Apply updates in Azure Stack

*Applies to: Azure Stack integrated systems*

You can apply the update using the **Update** blade in the Azure Stack. This article walks you through the steps to update, monitor, and troubleshoot the update process. You can use the Update blade to view update information, install updates, monitor update progress, review update history, and view the current OEM package version.

You can manage updates from the administrator portal. You can use the **Updates** in the dashboard to:

-   View important information, such as the current version.
-   Install updates and monitor progress.
-   Review update history for previously installed updates.
-   View the cloud's current OEM package version.

## Determine the current version

You can view the current version of Azure Stack in the **Updates** blade. To open:

1.  Open the Azure Stack administrator portal.

2.  Select **Dashboard**. In the **Updates** blade, the current version is listed.

    ![Updates tile on default dashboard](media\azure-stack-apply-updates/media/image1.png)

    For example, in this image the version is 1.1903.0.35.

## Install updates and monitor progress

1.  Open the Azure Stack administrator portal.

2.  Select **Dashboard**. Select **Update**.

3.  Select the available update that you wish to apply. If you do not have an update marked as "Available", you will need to Prepare the Update Package.

4.  Select **Update now**.

    ![Azure Stack update run details](media\azure-stack-apply-updates/media/image2.png)

5.  You can view high-level status as the update process iterates through various subsystems in Azure Stack. Example subsystems include physical hosts, Service Fabric, infrastructure virtual machines, and services that provide both the administrator and user portals. Throughout the update process, the update resource provider reports additional details about the update, such as the number of steps that have succeeded, and the number in progress.

6.  Select the **Download full logs** from the update run details blade to download full logs.

    If you run into an issue while monitoring the update, you can use the [*privileged endpoint*](https://docs.microsoft.com/azure-stack/operator/azure-stack-privileged-endpoint) to monitor the progress of an Azure Stack update run, and to resume a failed update run from the last successful step should the Azure Stack portal become unavailable. For instructions, see "Monitor updates in Azure Stack using the privileged endpoint"

    ![Azure Stack update run details](media\azure-stack-apply-updates/media/image3.png)

7.  Once completed, the update resource provider provides a **Succeeded** confirmation to show that the update process has been completed and how long it took. From there, you can view information about all updates, available updates, or installed updates using the filter.

    ![azure stack apply updates](media\azure-stack-apply-updates/media/image4.png)

    If the update fails, the **Update** blade reports **Needs attention**. Use the **Download full logs** option to get a high-level status of where the update failed. The Azure Stack log collection helps facilitate diagnostics and troubleshooting. The current version of your Azure Stack. You can update to the next full version. For example if you running Azure Stack 1811, the next released version is 1901.**Review update history**

8.  Open the Administration portal.

9.  Select **Dashboard**. Select **Update** .

10.  Select **Update history**.

![Azure Stack update history](media\azure-stack-apply-updates/media/image5.png)

## Next steps

-   [Manage updates in Azure Stack overview](https://docs.microsoft.com/azure-stack/operator/azure-stack-updates)  
-   [Azure Stack servicing policy](https://docs.microsoft.com/azure-stack/operator/azure-stack-servicing-policy)  