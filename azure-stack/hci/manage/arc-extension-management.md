---
title:  Azure Arc extension management on Azure Stack HCI
description: This article describes how to manage Azure Arc extensions on Azure Stack HCI server machines.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.reviewer: arduppal
ms.lastreviewed: 05/01/2023
ms.date: 05/01/2023
---

# Azure Arc extension management on Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to manage Azure Arc extensions on Azure Stack HCI server machines, in the Azure portal.

## Customer-managed Azure Arc extensions on Azure Stack HCI

With Azure Stack HCI, you can install, uninstall and update Azure Arc extensions on your Azure Stack HCI systems. Azure Arc lets you run hybrid services like monitoring and Windows Admin Center in the Azure portal.

Here are the individual extensions you can install and manage.

- [Azure Monitoring Agent](monitor-hci-single.md)
- [Azure Site Recovery](azure-site-recovery.md)
- [Windows Admin Center](/windows-server/manage/windows-admin-center/azure/manage-hci-clusters)

## Azure-managed extensions in Azure Stack HCI

In Azure Stack HCI, version 22H2, once you've successfully registered your new Azure Stack HCI cluster with Azure, Azure-managed extensions are automatically installed on your cluster. These extensions are essential for the functionality and quality of your system and can't be uninstalled. You can manage the behavior of these extensions in the Azure portal by navigating to the **Extensions** page and selecting the **Settings** menu.

If you have an existing Azure Stack HCI cluster that is registered to Azure without these extensions, a banner shows on the **Overview** or **Extensions** page in the Azure portal. You can use the information in the banner to guide you through installing these extensions.

Here are the Azure-managed extensions:

- [Telemetry and diagnostics](../concepts/telemetry-and-diagnostics-overview.md)

## Install an extension via the Azure portal

You can install extensions from the **Capabilities** tab for your Azure Stack HCI Arc-enabled servers as shown in the screenshot. You can use the capabilities tab to install most extensions.

:::image type="content" source="media/arc-extension-management/arc-extension-overview.png" alt-text="Screenshot of the Capabilities tab and options in the Azure portal." lightbox="media/arc-extension-management/arc-extension-overview.png":::

When you install an extension in the Azure portal, it's a cluster-aware operation. The extension is installed on all servers of the cluster. If you add more servers to your cluster, all the extensions installed on your cluster are automatically added to the new servers.

## Check the extension status
# [Azure portal](#tab/azureportal)
You can check the status of an extension on each server from the **Extensions** page by viewing the **status** column of the grid.

:::image type="content" source="media/arc-extension-management/arc-extension-status-view.png" alt-text="Screenshot of the different extension statuses in the Azure portal." lightbox="media/arc-extension-management/arc-extension-status-view.png":::

# [Azure CLI](#tab/azurecli)

Azure CLI is available to install in Windows, macOS and Linux environments. It can also be run in [Azure Cloud Shell](https://shell.azure.com/). This document details how to use Bash in Azure Cloud Shell. For more information, refer [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use Azure CLI to check if the extensions are installed following these steps:

1. Set up your subscription
    ```azurecli
    subscription="00000000-0000-0000-0000-000000000000" # Replace with your subscription ID
    az account set --subscription "${subscription}"
    ```

1. Set up parameters from your subscription, resource group, cluster name, and extension name
    ```azurecli
    resourceGroup="hcicluster-rg" # Replace with your resource group name
    clusterName="HCICluster" # Replace with your cluster name
    extensionName="AzureMonitorWindowsAgent" # Replace with the extension name
    ```
1. To list all the extensions on a cluster, run the following command:

    ```azurecli    
    az stack-hci extension list \
    --arc-setting-name "default" \
    --cluster-name "${clusterName}" \
    --resource-group "${resourceGroup}" \
    -o table
    ```

1. To filter out a specific extension like `AzureMonitorWindowsAgent`, run the following command:
    ```azurecli    
    az stack-hci extension list \
    --arc-setting-name "default" \
    --cluster-name "${clusterName}" \
    --resource-group "${resourceGroup}" \
    --query "[?name=='${extensionName}'].{Name:name, ManagedBy:managedBy, ProvisionStatus:provisioningState, State:aggregateState, Type:extensionParameters.type}" \
    -o table
    ```
---

## How the extension upgrade works

When published by the extension publisher team, the extension upgrade process replaces the existing extension version with a newly supported one. By default, the automatic extension upgrade feature is enabled for all extensions deployed on Azure Stack HCI Arc-enabled clusters unless you explicitly opt-out of automatic upgrades.

Currently, automatic extension upgrades are only supported in the Windows Admin Center extension, but more extensions will be added in the future.

> [!NOTE]
> By default, all extensions are set up to enable automatic upgrades, even if an extension doesn't support the automatic extension upgrade. However, this default setting has no effect until the extension publisher chooses to support automatic extension upgrade.

### Enable automatic upgrade via the Azure portal

# [Azure portal](#tab/azureportal)

For some extensions, you can enable automatic upgrades through extension management.

To enable an automatic upgrade, navigate to the **Extensions** page and perform these steps:

1. Choose the extension you want to enable automatic upgrade on.
2. Select **Enable automatic upgrade** from the top menu

    :::image type="content" source="media/arc-extension-management/arc-extension-enable-auto-upgrade-1.png" alt-text="Screenshot of how to enable auto upgrade in the Azure portal." lightbox="media/arc-extension-management/arc-extension-enable-auto-upgrade-1.png":::

3. When prompted to confirm your intent, select **OK**.

    :::image type="content" source="media/arc-extension-management/arc-extension-enable-auto-upgrade-2.png" alt-text="Screenshot of the notification to enable auto upgrade in the Azure portal." lightbox="media/arc-extension-management/arc-extension-enable-auto-upgrade-2.png":::

# [Azure CLI](#tab/azurecli)

To install and enable auto upgrade for a specific extension like `AdminCenter` run the following command:
```azurecli
resourceGroup="hcicluster-rg" # Replace with your resource group name
clusterName="HCICluster" # Replace with your cluster name
extensionName="AdminCenter"
extensionPublisher="Microsoft.AdminCenter"
extensionType="AdminCenter"

az stack-hci arc-setting update \
--name "default" \
--cluster-name "${clusterName}" \
--resource-group "${resourceGroup}" \
--connectivity-properties '{"enabled": true}'

az stack-hci extension create \
--extension-name "${extensionName}" \
--arc-setting-name "default" \
--cluster-name "${clusterName}" \
--resource-group "${resourceGroup}" \
--publisher ${extensionPublisher} \
--type ${extensionType} \
--settings "{\"port\": \"6516\"}" \
--auto-upgrade true
```
---

### Manual extension upgrade via the Azure portal

The manual extension upgrade works like the [Automatic extension upgrade](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#how-does-automatic-extension-upgrade-work). On an Azure Stack HCI Arc-enabled cluster, when you manually upgrade an extension, Azure saves the version you've selected. Azure then attempts to upgrade the extension on all servers in the cluster to that version.

On some servers, if the extension upgrade fails the platform attempts to upgrade to the selected version during the next [Azure Stack HCI cloud sync](../faq.yml).

Use the manual workflow in these scenarios:

- A new version of the extension is available and you want to upgrade it manually.

- The extension's automatic upgrade option is disabled and there's a version mismatch across different servers of the Azure Stack HCI cluster.

To manually upgrade an extension, follow these steps:

1. Go to the **Extensions** page.
2. Choose the extension you want to upgrade and select **Settings** from the top menu.

    :::image type="content" source="media/arc-extension-management/arc-extension-manual-upgrade.png" alt-text="Screenshot of how to manually upgrade an extension in the Azure portal." lightbox="media/arc-extension-management/arc-extension-manual-upgrade.png":::

3. Choose the latest version and select **Save**.

### Disable automatic upgrade via the Azure portal

You can disable automatic upgrades for certain extensions in the Azure portal. To disable automatic upgrades, navigate to the **Extensions** page and perform these steps:

1. Choose the extension you want to disable the automatic upgrade on.
2. Select **Disable automatic upgrade** from the top menu.

    :::image type="content" source="media/arc-extension-management/arc-extension-disable-auto-upgrade-1.png" alt-text="Screenshot of how to disable auto upgrade in the Azure portal." lightbox="media/arc-extension-management/arc-extension-disable-auto-upgrade-1.png":::

3. When prompted to confirm your intent, select **OK**.

    :::image type="content" source="media/arc-extension-management/arc-extension-disable-auto-upgrade-2.png" alt-text="Screenshot of notification when you disable auto upgrade in the Azure portal." lightbox="media/arc-extension-management/arc-extension-disable-auto-upgrade-2.png":::

### Check the extension upgrade history

You can view the Activity Log tab on individual Azure Arc-enabled server resources, resource groups, and subscriptions to check the history of automatic extension upgrades for individual cluster servers. For more information, see [Check automatic extension upgrade history](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#check-automatic-extension-upgrade-history).

### Availability-first updates

For a group of Azure Stack HCI Arc-enabled clusters undergoing an upgrade, the Azure platform used the [Automatic extension upgrade](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#how-does-automatic-extension-upgrade-work) model to orchestrate upgrades.

### Timing of automatic extension upgrades

When a new version of a supported extension is published, it becomes available for installation and manual upgrade on Azure Arc-enabled servers. Upgrades are issued in batches across Azure regions and subscriptions, so you might see an extension upgrade occur on some servers before others. For more information, see [Timing of automatic extension upgrades](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#timing-of-automatic-extension-upgrades).

To upgrade an extension immediately, see [Manual extension upgrade via the Azure portal](#manual-extension-upgrade-via-the-azure-portal).

### Automatic rollback and retries

If an extension upgrade fails, Azure performs the actions associated with [Automatic rollback and retries](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#automatic-rollback-and-retries) in an attempt to repair the extension.

If you continue to have trouble with an extension upgrade, you can [disable automatic extension upgrade](#disable-automatic-upgrade-via-the-azure-portal). When you disable the automatic upgrade, it prevents system retries while you troubleshoot the issue. You can [enable automatic extension upgrade](#enable-automatic-upgrade-via-the-azure-portal) again when you're ready.

### Upgrades with multiple extensions

If multiple extension upgrades are available for a machine, they might be batched together. However, each extension upgrade is applied individually on the machine. For more information, see [Extension upgrades with multiple extensions](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#extension-upgrades-with-multiple-extensions).

## Uninstall an extension from the Azure portal

# [Azure portal](#tab/azureportal)

If desired, you can uninstall some extensions from your Azure Stack HCI clusters in the Azure portal. To uninstall an extension, use these steps:

1. Go to the **Extensions page**.
2. Choose the extension you want to uninstall. The uninstall button isn't available for Azure-managed extensions.

    :::image type="content" source="media/arc-extension-management/arc-extension-uninstall-extension-1.png" alt-text="Screenshot of how to uninstall an extension in the Azure portal." lightbox="media/arc-extension-management/arc-extension-uninstall-extension-1.png":::

3. Select **Uninstall** from the top menu.
4. Confirm the intent and select **Yes**.

    :::image type="content" source="media/arc-extension-management/arc-extension-uninstall-extension-2.png" alt-text="Screenshot of the notification to uninstall an extension in the Azure portal." lightbox="media/arc-extension-management/arc-extension-uninstall-extension-2.png":::

# [Azure CLI](#tab/azurecli)

To remove a specific extension like `AzureMonitorWindowsAgent` run the following command:
```azurecli
extensionName="AzureMonitorWindowsAgent" # Replace with the extension name
resourceGroup="hcicluster-rg" # Replace with your resource group name
clusterName="HCICluster" # Replace with your cluster name

az stack-hci extension delete \
--arc-setting-name "default" \
--name "${extensionName}" \
--cluster-name "${clusterName}" \
--resource-group "${resourceGroup}"
```

---

## Troubleshooting extension errors

**Extension Status**: Failed

:::image type="content" source="media/arc-extension-management/arc-extension-troubleshoot-extension-1.png" alt-text="Screenshot of how to troubleshoot an extension in the Azure portal." lightbox="media/arc-extension-management/arc-extension-troubleshoot-extension-1.png":::

**Recommendation**: For an extension with a failed status, select the **Failed (View details)** link. View all the information about the failure and apply the troubleshooting tips.

:::image type="content" source="media/arc-extension-management/arc-extension-troubleshoot-extension-2.png" alt-text="Screenshot of tips to troubleshoot a failed extension." lightbox="media/arc-extension-management/arc-extension-troubleshoot-extension-2.png":::

## Next step

Learn about [Virtual machine extension management with Azure Arc-enabled servers](/azure/azure-arc/servers/manage-vm-extensions).
