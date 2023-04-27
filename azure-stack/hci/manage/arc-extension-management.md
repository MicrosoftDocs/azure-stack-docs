---
title:  Azure Arc extension management on Azure Stack HCI.
description: This article describes how to manage Azure Arc extensions on Azure Stack HCI server machines.
author: ronmiab
ms.author: robess
ms.topic: overview
ms.reviewer: arduppal
ms.lastreviewed: 04/13/2023
ms.date: 04/13/2023
---

# Azure Arc extension management on Azure Stack HCI

>[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)].

This article describes how to manage Azure Arc extensions on Azure Stack HCI server machines, in Azure portal.

## About Azure Arc extensions in Azure portal

Azure Stack HCI enables you to install, uninstall, and update Azure Arc extensions on your Azure Stack HCI systems. With Azure Arc extensions you can run hybrid services like monitoring, Windows Admin Center, in Azure portal.

Here are extensions you can install and manage in Azure portal.

- [Microsoft Monitoring Agent](/azure-stack/hci/manage/monitor-hci-single)
- [Windows Admin Center](/windows-server/manage/windows-admin-center/azure/manage-hci-clusters)
- [TelemetryAndDiagnostics](/azure-stack/hci/manage/telemetry-diagnostics-extension.md)

## Install an extension via Azure portal

Once Azure Stack HCI servers are Azure Arc enabled, you can install extensions from the **Capabilities tab** as highlighted in the screenshot. Use the capabilities tab to install most extensions.

:::image type="content" source="media/arc-extension-management/arc-extension-overview.png" alt-text="Screenshot of the Capabilities tab and options in Azure portal." lightbox="media/arc-extension-management/arc-extension-overview.png":::

## Check the extension status

After you install an extension, check the status of the extension on each of your nodes. To check the extension status, go to the **Extensions menu page** and view the **status column** of the grid.

:::image type="content" source="media/arc-extension-management/arc-extension-status-view.png" alt-text="Screenshot of the different extension statuses in Azure portal." lightbox="media/arc-extension-management/arc-extension-status-view.png":::

## How the extension upgrade works

When published by the extension publisher team, the extension upgrade process replaces the existing extension version with a newly supported version. The automatic extension upgrade feature is enabled by default for all extensions you deploy on Azure Stack HCI Azure Arc-enabled clusters, unless you explicitly opt-out of automatic upgrades.

Currently, Windows Admin Center is the only extension that supports automatic extension upgrades. More extensions will be added over time.

> [!NOTE]
> All extensions are configured by default to enable automatic upgrades, even if an extension doesn't support the automatic extension upgrade. This default setting has no effect until the extension publisher chooses to support automatic extension upgrade.

### Disable automatic upgrade via Azure portal

In Azure portal, you have the ability to disable automatic upgrade for some extensions. To disable automatic upgrades, go to the **Extensions pane**, then perform these steps:

1. Choose the extension you want to disable the automatic upgrade on.
2. Select **Disable automatic upgrade** from the top menu.
3. On the notification widow, select **OK**.

Here's an example of the disable automatic extension process:

:::image type="content" source="media/arc-extension-management/arc-extension-disable-auto-upgrade-1.png" alt-text="Screenshot of how to disable auto upgrade in Azure portal." lightbox="media/arc-extension-management/arc-extension-disable-auto-upgrade-1.png":::

:::image type="content" source="media/arc-extension-management/arc-extension-disable-auto-upgrade-2.png" alt-text="Screenshot of notification when you disable auto upgrade in Azure portal." lightbox="media/arc-extension-management/arc-extension-disable-auto-upgrade-2.png":::

### Enable automatic upgrade via Azure portal

With extension management, you can also enable automatic upgrade for some extensions.

To enable automatic upgrade, go to the **Extensions pane**, then perform these steps:

1. Choose the extension you want to enable automatic upgrade on.
2. Select **Enable automatic upgrade** from the top menu.
3. On the notification widow, select **OK**.

Here's an example of the enable automatic extension process:

:::image type="content" source="media/arc-extension-management/arc-extension-enable-auto-upgrade-1.png" alt-text="Screenshot of how to enable auto upgrade in Azure portal." lightbox="media/arc-extension-management/arc-extension-enable-auto-upgrade-1.png":::

:::image type="content" source="media/arc-extension-management/arc-extension-enable-auto-upgrade-2.png" alt-text="Screenshot of the notification to enable auto upgrade in Azure portal." lightbox="media/arc-extension-management/arc-extension-enable-auto-upgrade-2.png":::

### Manual extension upgrade via Azure portal

The manual extension upgrade works like the [Automatic extension upgrade](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#how-does-automatic-extension-upgrade-work). When you manually upgrade an extension, on an Azure Stack HCI Arc-enabled cluster, Azure platform saves the version you've selected and tries to upgrade the extension on all cluster nodes to that version.

If the extension upgrade fails, on some nodes, the platform tries to upgrade to the selected version during the next [Azure Stack HCI cloud sync](/azure-stack/hci/faq#how-often-does-azure-stack-hci-sync-with-the-cloud).

Use the manual workflow in these scenarios:

- You want to manually upgrade the extension version when a new version of the extension is available.

- There's a version mismatch across different servers of the Azure Stack HCI cluster and enable automatic upgrade is disabled.

To manually upgrade an extension, see these steps:

1. Go to the **Extensions page**
2. Select the menu item **Settings**.
3. Choose the latest version and select **Save**.

:::image type="content" source="media/arc-extension-management/arc-extension-manual-upgrade.png" alt-text="Screenshot of how to manually upgrade an extension in Azure portal." lightbox="media/arc-extension-management/arc-extension-manual-upgrade.png":::

### Check the extension upgrade history

To check the automatic extension upgrade history for individual cluster nodes, you can view the **Activity Log** tab on individual Azure Arc-enabled server resources, resource groups, and subscriptions. For more information, see [Check automatic extension upgrade history](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#check-automatic-extension-upgrade-history).

### Availability-first updates

For a group of Azure Stack HCI Azure Arc-enabled clusters undergoing an upgrade, the Azure platform orchestrates upgrades with the use of the [Automatic extension upgrade](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#how-does-automatic-extension-upgrade-work) model.

### Timing of automatic extension upgrades

When a new version of a supported extension is published, it becomes available for installation and manual upgrade on Azure Arc-enabled servers. Upgrades are issued in batches across Azure regions and subscriptions, so you might see the extension get upgraded on some servers before others. For more information, see [Timing of automatic extension upgrades](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#timing-of-automatic-extension-upgrades).

If you need to upgrade an extension immediately, see [Manual extension upgrade via Azure portal](../manage/arc-extension-management.md#manual-extension-upgrade-via-azure-portal).

### Automatic rollback and retries

If an extension upgrade fails, Azure performs the actions associated with [Automatic rollback and retries](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#automatic-rollback-and-retries) in an attempt to repair the extension.

If you continue to have trouble with an extension upgrade, you can [disable automatic extension upgrade](/azure-stack/hci/manage/arc-extension-management.md#disable-automatic-upgrade-via-azure-portal). When you disable the automatic upgrade, it prevents system retries while you troubleshoot the issue. You can [enable automatic extension upgrade](/azure-stack/hci/manage/arc-extension-management.md#enable-automatic-upgrade-via-azure-portal) again when you're ready.

### Upgrades with multiple extensions

If multiple extension upgrades are available for a machine, the upgrades might be batched together, however each extension upgrade is applied individually on the machine. For more information, see [Extension upgrades with multiple extensions](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#extension-upgrades-with-multiple-extensions).

## Uninstall an extension from Azure portal

If desired, you can uninstall some extensions from your Azure Stack HCI clusters in Azure portal. To uninstall an extension, use these steps:

1. Go to the **Extensions pane**.
2. Choose the extension you want to uninstall. The uninstall button is available only if you can uninstall the extension.
3. Select **Uninstall** from the top menu.
4. Confirm the intent and select **Yes**.

Here's an example of the uninstall extension process:

:::image type="content" source="media/arc-extension-management/arc-extension-uninstall-extension-1.png" alt-text="Screenshot of how to uninstall an extension in Azure portal." lightbox="media/arc-extension-management/arc-extension-uninstall-extension-1.png":::

:::image type="content" source="media/arc-extension-management/arc-extension-uninstall-extension-2.png" alt-text="Screenshot of the notification to uninstall an extension in Azure portal." lightbox="media/arc-extension-management/arc-extension-uninstall-extension-2.png":::

## Troubleshooting extension errors

Extension Status: Failed

:::image type="content" source="media/arc-extension-management/arc-extension-troubleshoot-extension-1.png" alt-text="Screenshot of how to troubleshoot an extension in Azure portal." lightbox="media/arc-extension-management/arc-extension-troubleshoot-extension-1.png":::

Recommendation: Whenever the extension is in a failed state, select the **Failed (View details)** status link to view all the information about the failure and troubleshooting tips.

:::image type="content" source="media/arc-extension-management/arc-extension-troubleshoot-extension-2.png" alt-text="Screenshot of tips to troubleshoot a failed extension." lightbox="media/arc-extension-management/arc-extension-troubleshoot-extension-2.png":::
