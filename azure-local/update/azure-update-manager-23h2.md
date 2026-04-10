---
title:  Use Azure Update Manager to update your Azure Local, version 23H2
description: This article describes the Azure Update Manager, its benefits, and ways to use it to update your Azure Local, version 23H2 system in the Azure portal.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: mindydiep
ms.date: 04/01/2026
ms.subservice: hyperconverged
#customer intent: As a Senior Content Developer, I want provide customers with information and guidance on using Azure Update Manager to manage and keep their Azure Local instances up to date.
---

# Use Azure Update Manager to update Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

[!INCLUDE [WARNING](../includes/hci-applies-to-23h2-cluster-updates.md)]

This article describes how to use Azure Update Manager to find and install available updates on Azure Local. It also describes how to review, track progress, and browse the history of system updates.

[!INCLUDE [azure-local-banner-new-releases](../includes/azure-local-banner-new-releases.md)]

## About Azure Update Manager

Azure Update Manager is an Azure service that allows you to apply, view, and manage updates for each of your Azure Local machines. You can monitor your entire infrastructure, including remote and branch offices, and perform updates at scale.

Here are some benefits of the Azure Update Manager:

- The update agent checks Azure Local instances for update health and available updates daily.
- You can view the update status and readiness for each system.
- You can update multiple systems at the same time.
- You can view the status of updates while they're in progress.
- You can view the results and history of updates, after they're complete.

## About readiness checks

[!INCLUDE [about-readiness-checks](../includes/about-readiness-checks.md)]

## Prerequisites

- An Azure Local system deployed and registered with Azure.
- Make sure to apply updates via supported navigation paths in Azure portal. Microsoft only supports updates applied from the **Azure Local** resource page or via the **Azure Update Manager > Resources > Azure Local**. Additionally, use of non-Microsoft tools to install updates isn't supported.

For Azure Local, Azure Update Manager is supported only in the regions where Azure Local is supported. For more information, see [List of supported Azure Local regions](../concepts/system-requirements-23h2.md#azure-requirements).

## Install system updates

> [!IMPORTANT]
>
> - Microsoft only supports updates applied from the **Azure Local** resource page or via the **Azure Update Manager > Resources > Azure Local**.
> - Use of non-Microsoft tools to install updates isn't supported.
> - When you update to solution version 2601 or later, the infrastructure logical network appears in Azure. For more information, see [Infrastructure logical network as a component of Azure Local VM management](../manage/azure-arc-vm-management-overview.md#components-of-azure-local-vm-management).

You can install updates from the Azure Local resource page or via the **Azure Update Manager > Resources > Azure Local page**. Select the appropriate tab to view the detailed steps.

# [Azure Update Manager](#tab/azureupdatemanager)

To install system updates using Azure Update Manager, follow these steps:

1. Sign into [the Azure portal](https://portal.azure.com) and go to **Azure Update Manager**.

1. Under the **Resources** dropdown, select **Azure Local**.

1. Select one or more systems where **Updates available** and the systems are **Connected** to the internet from the list, then select **Install now**.

    :::image type="content" source="media/azure-update-manager/install-update.png" alt-text="Screenshot to install system updates in Azure Update Manager." lightbox="media/azure-update-manager/install-update.png":::

1. On the **Check readiness** page, review the list of readiness checks and their results.

    - You can select the links under **Details** to view more details and individual system results. For information on the check types, see [About readiness checks](#about-readiness-checks).
    - For failed readiness checks, review the details and remediation messages via the links under **Details**. To further troubleshoot, see [Troubleshoot updates](./update-troubleshooting-23h2.md) before proceeding.

    :::image type="content" source="media/azure-update-manager/check-readiness.png" alt-text="Screenshot on the check readiness of updates in Azure Update Manager." lightbox="media/azure-update-manager/check-readiness.png":::

1. Select **Next**.

1. On the **Select updates** page, specify the updates you want to include in the deployment.
    1. View and select the available updates to install on your Azure Local machines.
    1. Select the **Version** link to view the update components, versions, and update release notes.
    1. You can add or remove systems to an update.

1. Select **Next**.

    :::image type="content" source="media/azure-update-manager/select-updates.png" alt-text="Screenshot to specify system updates in Azure Update Manager." lightbox="media/azure-update-manager/select-updates.png":::

1. On the **Review + install** page, verify your update options, and then select **Install**.

    :::image type="content" source="media/azure-update-manager/review-plus-install-1.png" alt-text="Screenshot to review and install updates for multiple systems in Azure Update Manager." lightbox="media/azure-update-manager/review-plus-install-1.png":::

    You should see a notification that confirms the installation of updates. If you don’t see the notification, select the **notification icon** in the top right taskbar.

    :::image type="content" source="media/azure-update-manager/installation-notification.png" alt-text="Screenshot of the update installation notification in Azure Update Manager." lightbox="media/azure-update-manager/installation-notification.png":::

# [Azure Local resource page](#tab/azurelocalresourcepage)

In addition to using Azure Update Manager, you can update individual systems from the Azure Local resource page.

To install updates on a single system from the resource page, follow these steps:

1. Sign into [the Azure portal](https://portal.azure.com) and go to **Azure Update Manager**.

1. Under the **Resources** dropdown, select **Azure Local**.

1. Select the system name from the list to open the Azure Local resource page. By default, the latest eligible update is selected to be installed. You can change the selection, and then select **Install now**.

    :::image type="content" source="media/azure-update-manager/update-single-cluster.png" alt-text="Screenshot of a one-time system update in Azure Update Manager." lightbox="media/azure-update-manager/update-single-cluster.png":::

1. On the **Check readiness** page, review the list of readiness checks and their results.
    - You can select the links under **Details** to view more details and individual system results. For information on the check types, see [About readiness checks](azure-update-manager-23h2.md#about-readiness-checks).

1. Select **Next**.

1. On the **Review + install** page, verify your update deployment options, and then select **Install**.

    :::image type="content" source="media/azure-update-manager/review-plus-install-single-system.png" alt-text="Screenshot to review and install updates for a single system in Azure Update Manager." lightbox="media/azure-update-manager/review-plus-install-single-system.png":::

    You should see a notification that confirms the installation of updates. If you don’t see the notification, select the **notification icon** in the top right taskbar.

    :::image type="content" source="media/azure-update-manager/installation-notification.png" alt-text="Screenshot of the update installation notification on the Azure Local resource page." lightbox="media/azure-update-manager/installation-notification.png":::

---

## Track system update progress and history

You can check the progress of updates started via PowerShell, the Azure Local resource page, or Azure Update Manager.

> [!NOTE]
> After you trigger an update, it can take up to 15 minutes for the update run to show up in the Azure portal.

To view the progress of your update installation, and completion results, follow these steps:

1. Sign into [the Azure portal](https://portal.azure.com) and go to **Azure Update Manager**.

1. Under the **Manage** dropdown, select **History**.

1. Select an update run that you want to monitor or review:
    - Select an **In progress** update to monitor a current updates progress.
    - Select a **Failed to update** or **Successfully updated** update to review historical results.

    :::image type="content" source="media/azure-update-manager/update-progress.png" alt-text="Screenshot to view progress about system updates in Azure Update Manager." lightbox="media/azure-update-manager/update-progress.png":::

## Install hardware updates

[!INCLUDE [azure-local-install-harware-updates](../includes/azure-local-install-harware-updates.md)]

## Get solution version

Follow these steps to find the solution version of your Azure Local instance:

1. In the Azure portal, go to your Azure Local resource page and then go to **Overview**.
1. In the right pane, go to the **Properties** tab and then to **Updates**.
1. Identify the solution version for your Azure Local instance.

    :::image type="content" source="./media/azure-update-manager/get-solution-version-1.png" alt-text="Screenshot of the Azure Local resource Overview page showing the Properties tab and the solution version." lightbox="./media/azure-update-manager/get-solution-version-1.png":::

## Next steps

- For more information about update phases, see [Understand update phases](./update-phases-23h2.md).

- For troubleshooting guidance, see [Troubleshoot updates](./update-troubleshooting-23h2.md) and [Azure Local update troubleshooting guides](https://github.com/Azure/AzureLocal-Supportability/tree/main/TSG/Update).
