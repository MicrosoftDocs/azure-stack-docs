---
title:  Use Azure Update Manager to update your Azure Local
description: This article describes the Azure Update Manager, its benefits, and ways to use it to update your Azure Local system in the Azure portal.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: mindydiep
ms.date: 08/29/2026
ms.subservice: hyperconverged
---

# Use Azure Update Manager to update Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

[!INCLUDE [WARNING](../includes/hci-applies-to-23h2-cluster-updates.md)]

This article describes how to use Azure Update Manager to find and install available updates on Azure Local. It also describes how to review, track progress, and browse the history of system updates.

[!INCLUDE [azure-local-banner-new-releases](../includes/azure-local-banner-new-releases.md)]

## About Azure Update Manager

Azure Update Manager is an Azure service that you can use to apply, view, and manage updates for each of your Azure Local machines. You can monitor your entire infrastructure, including remote and branch offices, and perform updates at scale.

Here are some benefits of Azure Update Manager:

- The update agent checks Azure Local instances daily for update health and available updates.
- You can view the update status and readiness for each system.
- You can update multiple systems at the same time.
- You can view the status of updates while they're in progress.
- You can view the results and history of updates after they're complete.

## About readiness checks

[!INCLUDE [about-readiness-checks](../includes/about-readiness-checks.md)]

The pre-update readiness checks that run during the [prepare updates](#optional-prepare-updates-for-later-installation) workflow run again before [installation](#install-prepared-or-available-system-updates) if they fail or expire.

## Prerequisites

- An Azure Local system deployed and registered with Azure.
- Apply updates through a supported method. Microsoft only supports applying updates by using:
    - The [Azure portal](https://portal.azure.com):
        - **Azure Update Manager** > **Resources** > **Azure Local**.
        - The **Azure Local** resource page.

        > [!NOTE]
        > Azure Update Manager is supported for Azure Local only in regions where Azure Local is available. For more information, see [List of supported Azure Local regions](../concepts/system-requirements-23h2.md#azure-requirements).
    - PowerShell, as documented in [Update Azure Local, version 23H2 systems via PowerShell](update-via-powershell-23h2.md) and [Import and Discover Update Packages For Azure Local With Limited Connectivity](import-discover-updates-offline-23h2.md).

- One of the following Azure RBAC roles assigned:
  - **Azure Stack HCI Administrator** - Full access to cluster and resources, including updates.
  - **Azure Stack HCI Device Management Role** - Full cluster operations including updates.

> [!NOTE]
> Microsoft doesn't support using non-Microsoft tools to install updates.

## (Optional) Check for updates

Before installing system updates, you can optionally check for the latest available updates on a per-system basis. This step helps you keep your cluster status synchronized.

1. Sign in to [the Azure portal](https://portal.azure.com) and go to **Azure Update Manager**.

1. Under the **Resources** dropdown, select **Azure Local**.

1. Select the systems for which you want to check for updates.

1. Select **Check for updates**.

:::image type="content" source="media/azure-update-manager/check-for-updates.png" alt-text="Screenshot to check for system updates in Azure Update Manager." lightbox="media/azure-update-manager/check-for-updates.png":::

## (Optional) Prepare updates for later installation

> [!IMPORTANT]
> The **prepare** workflow from the portal is only available to clusters that are on version **12.2604.1003.28** or later.

You can prepare update content in advance and install it later. This workflow allows you to download update packages and perform update readiness validation before your planned maintenance window.

Preparing an update doesn't start the update installation. The system downloads the required update content, evaluates update readiness checks, and makes the selected update available for installation later.

This workflow helps you:

- Reduce maintenance-window duration by downloading and validating updates before the planned installation.

- Stage updates across one or more Azure Local systems and install them during the maintenance window.

After the preparation operation finishes successfully, you can return at any time and install the prepared update.

# [Azure Update Manager](#tab/azureupdatemanager)

To prepare updates by using Azure Update Manager, follow these steps:

1. Sign in to the [Azure portal](https://portal.azure.com) and go to Azure Update Manager.

1. Under the **Resources** dropdown, select **Azure Local**.

1. Select one or more systems with a **Status** of **Updates available** and an **Azure connection** value of **Connected** from the list, and then select **Prepare**.

    :::image type="content" source="media/prepare-updates/azure-update-manager/select-systems.png" alt-text="Screenshot to select systems to prepare system updates in Azure Update Manager." lightbox="media/prepare-updates/azure-update-manager/select-systems.png":::

1. On the **Check readiness** page, review the list of readiness checks and their results.
    - To view more details and individual system results, select the links under **Details**.
    - The Azure portal displays details only for informational, warning, and failed health checks. You can view detailed readiness check results, including successful checks, in PowerShell.
    - For failed readiness checks, review details and remediation messages via the links under **Details**.

    To learn more about readiness checks, view successful check results, and troubleshoot solution updates, see [Troubleshoot solution updates for Azure Local](./update-troubleshooting-23h2.md).

    :::image type="content" source="media/prepare-updates/azure-update-manager/check-readiness.png" alt-text="Screenshot to review readiness checks in Azure Update Manager." lightbox="media/prepare-updates/azure-update-manager/check-readiness.png":::

1. Select **Next**.

1. On the **Select updates** page, select the updates you want to prepare.
    1. View and select the available updates to prepare on your Azure Local machines.
    1. Select the **Version** link to view the update components, versions, and update release notes.
    1. Add or remove systems to an update.

1. Select **Next**.

    :::image type="content" source="media/prepare-updates/azure-update-manager/select-updates.png" alt-text="Screenshot to select system updates in Azure Update Manager." lightbox="media/prepare-updates/azure-update-manager/select-updates.png":::

1. On the **Review + prepare** page, verify your update options, and then select **Prepare**.

    :::image type="content" source="media/prepare-updates/azure-update-manager/review-updates.png" alt-text="Screenshot to review system updates in Azure Update Manager." lightbox="media/prepare-updates/azure-update-manager/review-updates.png":::

    You see a notification that confirms the preparation of updates. If you don't see the notification, select the **notification icon** in the top right taskbar.

    :::image type="content" source="media/prepare-updates/azure-update-manager/notification.png" alt-text="Screenshot of notification to prepare system updates in Azure Update Manager." lightbox="media/prepare-updates/azure-update-manager/notification.png":::

1. You can track the progress in the **History** tab.

    :::image type="content" source="media/prepare-updates/azure-update-manager/update-history.png" alt-text="Screenshot of system update history in Azure Update Manager." lightbox="media/prepare-updates/azure-update-manager/update-history.png":::

# [Azure Local resource page](#tab/azurelocalresourcepage)

In addition to using Azure Update Manager, you can prepare updates on individual systems from the Azure Local resource page.

To prepare updates on a single system from the resource page, follow these steps:

1. Sign in to the [Azure portal](https://portal.azure.com) and go to Azure Update Manager.

1. Under the **Resources** dropdown, select **Azure Local**.

1. Select the system name from the list to open the Azure Local resource page.

1. By default, the latest eligible update is selected. You can change the selection, and then select **Prepare**.

    :::image type="content" source="media/prepare-updates/azure-local-resource-page/select-updates.png" alt-text="Screenshot to select system updates in Azure Local resource page." lightbox="media/prepare-updates/azure-local-resource-page/select-updates.png":::

1. On the **Check readiness** page, review the list of readiness checks and their results.

    - Select the links under **Details** to view more details and individual system results. For information on the check types, see [About readiness checks](#about-readiness-checks).

1. Select **Next**.

1. On the **Review + prepare** page, verify your update options, and then select **Prepare**.

    :::image type="content" source="media/prepare-updates/azure-local-resource-page/review-updates.png" alt-text="Screenshot to review system updates in Azure Local resource page." lightbox="media/prepare-updates/azure-local-resource-page/review-updates.png":::

1. You see a notification that confirms the preparation of updates. If you don't see the notification, select the **notification icon** in the top right taskbar.

    :::image type="content" source="media/prepare-updates/azure-local-resource-page/notification.png" alt-text="Screenshot of notification to prepare system updates in Azure Local resource page." lightbox="media/prepare-updates/azure-local-resource-page/notification.png":::

1. You can track the progress in the **History** tab.

    :::image type="content" source="media/prepare-updates/azure-local-resource-page/update-history.png" alt-text="Screenshot of system update history in Azure Local resource page." lightbox="media/prepare-updates/azure-local-resource-page/update-history.png":::

---

## Install prepared or available system updates

> [!IMPORTANT]
>
> - Microsoft only supports updates applied from the **Azure Local** resource page or via the **Azure Update Manager > Resources > Azure Local**.
> - Use of non-Microsoft tools to install updates isn't supported.
> - When you update to solution version 2601 or later, the infrastructure logical network appears in Azure. For more information, see [Infrastructure logical network as a component of Azure Local VM management](../manage/azure-arc-vm-management-overview.md#components-of-azure-local-vm-management).

You can install updates from the Azure Local resource page or via the **Azure Update Manager > Resources > Azure Local page**. Select the appropriate tab to view the detailed steps.

# [Azure Update Manager](#tab/azureupdatemanager)

To install system updates by using Azure Update Manager, follow these steps:

1. Sign in to [the Azure portal](https://portal.azure.com) and go to **Azure Update Manager**.

1. Under the **Resources** dropdown, select **Azure Local**.

1. Select one or more systems where **Updates available** and the systems are **Connected** to the internet from the list, and then select **Install now**.

    :::image type="content" source="media/azure-update-manager/install-update.png" alt-text="Screenshot to install system updates in Azure Update Manager." lightbox="media/azure-update-manager/install-update.png":::

1. On the **Check readiness** page, review the list of readiness checks and their results.

    - To view more details and individual system results, select the links under **Details**.
    - The Azure portal displays details only for informational, warning, and failed health checks. You can view detailed readiness check results, including successful checks, in PowerShell.
    - For failed readiness checks, review details and remediation messages via the links under **Details**.

    To learn more about readiness checks, view successful check results, and troubleshoot solution updates, see [Troubleshoot solution updates for Azure Local](./update-troubleshooting-23h2.md).

    :::image type="content" source="media/azure-update-manager/check-readiness.png" alt-text="Screenshot on the check readiness of updates in Azure Update Manager." lightbox="media/azure-update-manager/check-readiness.png":::

1. Select **Next**.

1. On the **Select updates** page, specify the updates you want to include in the deployment.
    1. View and select the available updates or the prepared updates to install on your Azure Local machines.
    1. Select the **Version** link to view the update components, versions, and update release notes.
    1. Add or remove systems to an update.

1. Select **Next**.

    :::image type="content" source="media/azure-update-manager/select-updates.png" alt-text="Screenshot to specify system updates in Azure Update Manager." lightbox="media/azure-update-manager/select-updates.png":::

1. On the **Review + install** page, verify your update options, and then select **Install**.

    :::image type="content" source="media/azure-update-manager/review-plus-install-1.png" alt-text="Screenshot to review and install updates for multiple systems in Azure Update Manager." lightbox="media/azure-update-manager/review-plus-install-1.png":::

    You see a notification that confirms the installation of updates. If you don’t see the notification, select the **notification icon** in the top right taskbar.

    :::image type="content" source="media/azure-update-manager/installation-notification.png" alt-text="Screenshot of the update installation notification in Azure Update Manager." lightbox="media/azure-update-manager/installation-notification.png":::

# [Azure Local resource page](#tab/azurelocalresourcepage)

In addition to using Azure Update Manager, you can update individual systems from the Azure Local resource page.

To install updates on a single system from the resource page, follow these steps:

1. Sign in to [the Azure portal](https://portal.azure.com) and go to **Azure Update Manager**.

1. Under the **Resources** dropdown, select **Azure Local**.

1. Select the system name from the list to open the Azure Local resource page. By default, the latest eligible update is selected to install. You can change the selection, and then select **Install now**.

    :::image type="content" source="media/azure-update-manager/update-single-cluster.png" alt-text="Screenshot of a one-time system update in Azure Update Manager." lightbox="media/azure-update-manager/update-single-cluster.png":::

1. On the **Check readiness** page, review the list of readiness checks and their results.
    - Select the links under **Details** to view more details and individual system results. For information on the check types, see [About readiness checks](azure-update-manager-23h2.md#about-readiness-checks).

1. Select **Next**.

1. On the **Review + install** page, verify your update deployment options, and then select **Install**.

    :::image type="content" source="media/azure-update-manager/review-plus-install-single-system.png" alt-text="Screenshot to review and install updates for a single system in Azure Update Manager." lightbox="media/azure-update-manager/review-plus-install-single-system.png":::

    You see a notification that confirms the installation of updates. If you don’t see the notification, select the **notification icon** in the top right taskbar.

    :::image type="content" source="media/azure-update-manager/installation-notification.png" alt-text="Screenshot of the update installation notification on the Azure Local resource page." lightbox="media/azure-update-manager/installation-notification.png":::

---

## Track system update progress and history

You can check the progress of updates you start through PowerShell, the Azure Local resource page, or Azure Update Manager.

> [!NOTE]
> After you trigger an update, it can take up to 15 minutes for the update run to appear in the Azure portal.

To view the progress of your update installation and completion results, follow these steps:

1. Sign in to [the Azure portal](https://portal.azure.com) and go to **Azure Update Manager**.

1. Under the **Manage** dropdown, select **History**.

1. Select an update run that you want to monitor or review:
    - Select an **In progress** update to monitor a current update's progress.
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
