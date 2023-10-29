---
title:  Azure Arc extension management on Azure Stack HCI
description: This article describes how to manage Azure Arc extensions on Azure Stack HCI server machines.
author: ronmiab
ms.author: robess
ms.topic: how-to
ms.custom: devx-track-azurecli, devx-track-azurepowershell
ms.reviewer: arduppal
ms.lastreviewed: 09/19/2023
ms.date: 09/19/2023
---

# Azure Arc extension management on Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article describes how to install, upgrade, and manage Azure Arc extensions on Azure Stack HCI server machines.

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

## Install an extension
### [Azure portal](#tab/azureportal)
You can install extensions from the **Capabilities** tab for your Azure Stack HCI Arc-enabled servers as shown in the screenshot. You can use the capabilities tab to install most extensions.

:::image type="content" source="media/arc-extension-management/arc-extension-overview.png" alt-text="Screenshot of the Capabilities tab and options in the Azure portal." lightbox="media/arc-extension-management/arc-extension-overview.png":::

When you install an extension in the Azure portal, it's a cluster-aware operation. The extension is installed on all servers of the cluster. If you add more servers to your cluster, all the extensions installed on your cluster are automatically added to the new servers.

### [Azure CLI](#tab/azurecli)
Azure CLI is available to install in Windows, macOS and Linux environments. It can also be run in Azure Cloud Shell. For more information, refer [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use Bash to install an extension following these steps:
1. Set up parameters from your subscription, resource group, and clusters
    ```azurecli
    subscription="00000000-0000-0000-0000-000000000000" # Replace with your subscription ID
    resourceGroup="hcicluster-rg" # Replace with your resource group name

    az account set --subscription "${subscription}"

    clusters=($(az graph query -q "resources | where type == 'microsoft.azurestackhci/clusters'| where resourceGroup =~ '${resourceGroup}' | project name" | jq -r '.data[].name'))
    ```

1. To install the Windows Admin Center extension on all the clusters under the resource group, run the following command:
    ```azurecli
    extensionName="AdminCenter"
    extensionType="AdminCenter"
    extensionPublisher="Microsoft.AdminCenter"
    settingsConfig="{'port':'6516'}"
    connectivityProps="{enabled:true}"

    for cluster in ${clusters}; do
        echo "Enabling Connectivity for cluster $currentCluster"
        az stack-hci arc-setting update \
            --resource-group ${resourceGroup} \
            --cluster-name ${cluster} \
            --name "default" \
            --connectivity-properties ${connectivityProps}
        
        echo "Installing extension: ${extensionName} on cluster: ${cluster}"
        az stack-hci extension create \
            --arc-setting-name "default" \
            --cluster-name "${cluster}" \
            --resource-group "${resourceGroup}" \
            --name "${extensionName}" \
            --auto-upgrade "true" \
            --publisher "${extensionPublisher}" \
            --type "${extensionType}" \
            --settings "${settingsConfig}"
    done
    ```

1. To install the Azure Monitor Agent extension on all the clusters under the resource group, run the following command:
    ```azurecli
    extensionName="AzureMonitorWindowsAgent"
    extensionType="AzureMonitorWindowsAgent"
    extensionPublisher="Microsoft.Azure.Monitor"

    for cluster in ${clusters}; do
        echo "Installing extension: ${extensionName} on cluster: ${cluster}"

        az stack-hci extension create \
            --arc-setting-name "default" \
            --cluster-name "${cluster}" \
            --resource-group "${resourceGroup}" \
            --name "${extensionName}" \
            --auto-upgrade "true" \
            --publisher "${extensionPublisher}" \
            --type "${extensionType}"
    done
    ```

1. To install the Azure Site Recovery (ASR) extension on all the clusters under the resource group run the following command:
    ```azurecli
    asrSubscription="00000000-0000-0000-0000-000000000000" # Replace with your ASR subscription ID
    asrResourceGroup="asr-rg" # Replace with your ASR resource group
    asrVaultName="asr-vault" # Replace with your ASR vault name
    asrLocation="East US" # Replace with your ASR Location
    asrSiteId="00000000-0000-0000-0000-000000000000" # Replace with your ASR Site ID
    asrSiteName="asr-site" # Replace with your Site Name
    asrSitePolicyId="/subscriptions/${asrSubscription}/resourceGroups/${asrResourceGroup}/providers/Microsoft.RecoveryServices/vaults/${asrVaultName}/replicationPolicies/s-cluster-policy" # Replace with your Site Policy name

    extensionName="ASRExtension"
    extensionType="Windows"
    extensionPublisher="Microsoft.SiteRecovery.Dra"
    jsonFile="./tmp-asr.json" #Temp JSON file

    echo "{\"SubscriptionId\": \"${asrSubscription}\", \"Environment\": \"AzureCloud\",\"ResourceGroup\": \"${asrResourceGroup}\",\"Location\": \"${asrLocation}\",\"SiteId\": \"${asrSiteId}\", \"SiteName\": \"${asrSiteName}\", \"PolicyId\": \"${asrSitePolicyId}\", \"PrivateEndpointStateForSiteRecovery\": \"None\" }" > ${jsonFile}
    
    for cluster in ${clusters}; do
        echo "Installing extension: ${extensionName} on cluster: ${cluster}"

        az stack-hci extension create \
            --arc-setting-name "default" \
            --cluster-name "${cluster}" \
            --resource-group "${resourceGroup}" \
            --name "${extensionName}" \
            --auto-upgrade "true" \
            --publisher "${extensionPublisher}" \
            --type "${extensionType}" \
            --settings "${jsonFile}"
    done
    ```

### [Azure PowerShell](#tab/azurepowershell)
Azure PowerShell can be run in Azure Cloud Shell. This document details how to use PowerShell in Azure Cloud Shell. For more information, refer [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use PowerShell to install an extension following these steps:

1. Set up parameters from your subscription, resource group, and clusters: 
    ```powershell
    $subscription = "00000000-0000-0000-0000-000000000000" # Replace with your subscription ID
    $resourceGroup = "hcicluster-rg" # Replace with your resource group name

    Set-AzContext -Subscription "${subscription}"
    $clusters = Get-AzResource -ResourceType "Microsoft.AzureStackHCI/clusters" -ResourceGroupName ${resourceGroup} | Select-Object -Property Name
    ```
1. To install the Windows Admin Center extension on all the clusters under the resource group, run the following command:
    ```powershell
    $extensionName = "AdminCenter"
    $extensionType = "AdminCenter"
    $extensionPublisher = "Microsoft.AdminCenter"
    $settingsConfig = @{"port" = 6516 }
    
    foreach ($cluster in $clusters) {
        $clusterName = ${cluster}.Name

        Write-Output ("Enable connectivity for cluster ${clusterName}")
        Invoke-AzRestMethod `
            -Method PATCH `
            -SubscriptionId ${subscription} `
            -ResourceGroupName ${resourceGroup} `
            -ResourceProviderName "Microsoft.AzureStackHCI" `
            -ResourceType ("clusters/" + ${clusterName} + "/arcSettings") `
            -Name "default" `
            -ApiVersion "2023-02-01" `
            -Payload (@{"properties" = @{ "connectivityProperties" = @{ "enabled" = $true } } } | ConvertTo-Json -Depth 5)
        

        Write-Output ("Installing Extension '${extensionName}' on cluster ${clusterName}")

        New-AzStackHciExtension `
            -ClusterName "${clusterName}" `
            -ResourceGroupName "${resourceGroup}" `
            -ArcSettingName "default" `
            -Name "${extensionName}" `
            -ExtensionParameterPublisher "${extensionPublisher}" `
            -ExtensionParameterType "${extensionType}" `
            -ExtensionParameterSetting ${settingsConfig} `
            -NoWait
    }
    ```

1. To install the Azure Monitor Agent extension on all the clusters under the resource group, run the following command:
    ```powershell
    $extensionName = "AzureMonitorWindowsAgent"
    $extensionType = "AzureMonitorWindowsAgent"
    $extensionPublisher = "Microsoft.Azure.Monitor"
    
    foreach ($cluster in $clusters) {
        $clusterName = ${cluster}.Name

        Write-Output ("Installing Extension '${extensionType}/${extensionPublisher}' on cluster ${clusterName}")

        New-AzStackHciExtension `
            -ClusterName "${clusterName}" `
            -ResourceGroupName "${resourceGroup}" `
            -ArcSettingName "default" `
            -Name "${extensionName}" `
            -ExtensionParameterPublisher "${extensionPublisher}" `
            -ExtensionParameterType "${extensionType}"
    }
    ```

1. To install the Azure Site Recovery (ASR) extension on all the clusters under the resource group, create a JSON parameter file and then run the following command:
    ```powershell
    $settings = @{
        SubscriptionId = "<Replace with your Subscription Id>"
        Environment = "<Replace with the cloud environment type. For example: AzureCloud>"
        ResourceGroup = "<Replace with your Site Recovery Vault resource group>"
        ResourceName = "<Replace with your Site Recovery Vault Name>"
        Location = "<Replace with your Site Recovery Azure Region>"
        SiteId = "<Replace with the ID of your recovery site>"
        SiteName = "<Replace with your recovery site name>"
        PolicyId = "<Replace with resource ID of your recovery site policy>"
        PrivateEndpointStateForSiteRecovery = "None"
    }

    $extensionName = "ASRExtension"
    $extensionType = "Windows"
    $extensionPublisher = "Microsoft.SiteRecovery.Dra"

    foreach ($cluster in $clusters) {
        $clusterName = ${cluster}.Name

        Write-Output ("Installing Extension '${extensionType}/${extensionPublisher}' on cluster ${clusterName}")

        New-AzStackHciExtension `
            -ClusterName "${clusterName}" `
            -ResourceGroupName "${resourceGroup}" `
            -ArcSettingName "default" `
            -Name "${extensionName}" `
            -ExtensionParameterPublisher "${extensionPublisher}" `
            -ExtensionParameterType "${extensionType}" `
            -ExtensionParameterSetting ${settings} `
            -NoWait
    }
    ```

---

## Check the extension status
### [Azure portal](#tab/azureportal)
You can check the status of an extension on each server from the **Extensions** page by viewing the **status** column of the grid.

:::image type="content" source="media/arc-extension-management/arc-extension-status-view.png" alt-text="Screenshot of the different extension statuses in the Azure portal." lightbox="media/arc-extension-management/arc-extension-status-view.png":::

### [Azure CLI](#tab/azurecli)
Azure CLI is available to install in Windows, macOS and Linux environments. It can also be run in Azure Cloud Shell. For more information, refer [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use Bash to check the status of an extension following these steps:

1. Set up parameters from your subscription, resource group, cluster name, and extension name
    ```azurecli
    subscription="00000000-0000-0000-0000-000000000000" # Replace with your subscription ID
    resourceGroup="hcicluster-rg" # Replace with your resource group name
    clusterName="HCICluster" # Replace with your cluster name
    extensionName="AzureMonitorWindowsAgent" # Replace with the extension name

    az account set --subscription "${subscription}"
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
### [Azure PowerShell](#tab/azurepowershell)
Azure PowerShell can be run in Azure Cloud Shell. This document details how to use PowerShell in Azure Cloud Shell. For more information, refer [Quickstart for Azure Cloud Shell](/azure/cloud-shell/quickstart).

Launch [Azure Cloud Shell](https://shell.azure.com/) and use PowerShell to check the status of an extension following these steps:

1. Set up parameters from your subscription, resource group, and cluster name
    ```powershell
    $subscription = "00000000-0000-0000-0000-000000000000" # Replace with your subscription ID
    $resourceGroup = "hcicluster-rg" # Replace with your resource group name

    Set-AzContext -Subscription "${subscription}"
    $clusters = Get-AzResource -ResourceType "Microsoft.AzureStackHCI/clusters" -ResourceGroupName ${resourceGroup} | Select-Object -Property Name
    ```


1. To list all the extensions on a cluster, run the following command:
    ```powershell
    foreach ($cluster in $clusters) {
        $clusterName = ${cluster}.Name
        Get-AzStackHciExtension `
            -ClusterName "${clusterName}" `
            -ResourceGroupName "${resourceGroup}" `
            -ArcSettingName "default"|Format-Table -Property Name, ParameterType, ParameterPublisher, ParameterEnableAutomaticUpgrade, ProvisioningState
    }
    ```

---

## How the extension upgrade works

When published by the extension publisher team, the extension upgrade process replaces the existing extension version with a newly supported one. By default, the automatic extension upgrade feature is enabled for all extensions deployed on Azure Stack HCI Arc-enabled clusters unless you explicitly opt-out of automatic upgrades.

Currently, automatic extension upgrades are only supported in the Windows Admin Center extension, but more extensions will be added in the future.

> [!NOTE]
> By default, all extensions are set up to enable automatic upgrades, even if an extension doesn't support the automatic extension upgrade. However, this default setting has no effect until the extension publisher chooses to support automatic extension upgrade.

### Enable automatic extension upgrade

### [Azure portal](#tab/azureportal)

For some extensions, you can enable automatic upgrades through extension management.

To enable an automatic upgrade, navigate to the **Extensions** page and perform these steps:

1. Choose the extension you want to enable automatic upgrade on.
2. Select **Enable automatic upgrade** from the top menu

    :::image type="content" source="media/arc-extension-management/arc-extension-enable-auto-upgrade-1.png" alt-text="Screenshot of how to enable auto upgrade in the Azure portal." lightbox="media/arc-extension-management/arc-extension-enable-auto-upgrade-1.png":::

3. When prompted to confirm your intent, select **OK**.

    :::image type="content" source="media/arc-extension-management/arc-extension-enable-auto-upgrade-2.png" alt-text="Screenshot of the notification to enable auto upgrade in the Azure portal." lightbox="media/arc-extension-management/arc-extension-enable-auto-upgrade-2.png":::

### [Azure CLI](#tab/azurecli)
To install and enable auto upgrade for a specific extension like `AzureMonitorWindowsAgent` run the following command:

```azurecli
clusterName="HCICluster" # Replace with your cluster name
resourceGroup="hcicluster-rg" # Replace with your resource group name

extensionName="AzureMonitorWindowsAgent"
extensionPublisher="Microsoft.Azure.Monitor"
extensionType="AzureMonitorWindowsAgent"

az stack-hci extension create \
    --name "${extensionName}" \
    --arc-setting-name "default" \
    --cluster-name "${clusterName}" \
    --resource-group "${resourceGroup}" \
    --publisher ${extensionPublisher} \
    --type ${extensionType} \
    --auto-upgrade "true"
```

### [Azure PowerShell](#tab/azurepowershell)
To install and enable auto upgrade for a specific extension like `AzureMonitorWindowsAgent` run the following command:

```powershell
$clusterName = "HCICluster" # Replace with your cluster name
$resourceGroup = "hcicluster-rg" # Replace with your resource group name

$extensionName = "AzureMonitorWindowsAgent"
$extensionType = "AzureMonitorWindowsAgent"
$extensionPublisher = "Microsoft.Azure.Monitor"

New-AzStackHciExtension `
    -ClusterName "${clusterName}" `
    -ResourceGroupName "${resourceGroup}" `
    -ArcSettingName "default" `
    -Name "${extensionName}" `
    -ExtensionParameterPublisher "${extensionPublisher}" `
    -ExtensionParameterType "${extensionType}" `
    -ExtensionParameterEnableAutomaticUpgrade
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

### Disable automatic extension upgrade

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

If you continue to have trouble with an extension upgrade, you can [disable automatic extension upgrade](#disable-automatic-extension-upgrade). When you disable the automatic upgrade, it prevents system retries while you troubleshoot the issue. You can [enable automatic extension upgrade](#enable-automatic-extension-upgrade) again when you're ready.

### Upgrades with multiple extensions

If multiple extension upgrades are available for a machine, they might be batched together. However, each extension upgrade is applied individually on the machine. For more information, see [Extension upgrades with multiple extensions](/azure/azure-arc/servers/manage-automatic-vm-extension-upgrade?tabs=azure-portal#extension-upgrades-with-multiple-extensions).

## Uninstall an extension

### [Azure portal](#tab/azureportal)
If desired, you can uninstall some extensions from your Azure Stack HCI clusters in the Azure portal. To uninstall an extension, use these steps:

1. Go to the **Extensions page**.
2. Choose the extension you want to uninstall. The uninstall button isn't available for Azure-managed extensions.

    :::image type="content" source="media/arc-extension-management/arc-extension-uninstall-extension-1.png" alt-text="Screenshot of how to uninstall an extension in the Azure portal." lightbox="media/arc-extension-management/arc-extension-uninstall-extension-1.png":::

3. Select **Uninstall** from the top menu.
4. Confirm the intent and select **Yes**.

    :::image type="content" source="media/arc-extension-management/arc-extension-uninstall-extension-2.png" alt-text="Screenshot of the notification to uninstall an extension in the Azure portal." lightbox="media/arc-extension-management/arc-extension-uninstall-extension-2.png":::

### [Azure CLI](#tab/azurecli)

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

### [Azure PowerShell](#tab/azurepowershell)
To remove a specific extension like `AzureMonitorWindowsAgent` run the following command:
```powershell
$clusterName = "HCICluster" # Replace with your cluster name
$resourceGroup = "hcicluster-rg" # Replace with your resource group name

$extensionName = "AzureMonitorWindowsAgent"

Remove-AzStackHciExtension `
    -ClusterName "${clusterName}" `
    -ResourceGroupName "${resourceGroup}" `
    -ArcSettingName "default" `
    -Name "${extensionName}"
```
---

## Troubleshooting extension errors

**Extension Status**: Failed

:::image type="content" source="media/arc-extension-management/arc-extension-troubleshoot-extension-1.png" alt-text="Screenshot of how to troubleshoot an extension in the Azure portal." lightbox="media/arc-extension-management/arc-extension-troubleshoot-extension-1.png":::

**Recommendation**: For an extension with a failed status, select the **Failed (View details)** link. View all the information about the failure and apply the troubleshooting tips.

:::image type="content" source="media/arc-extension-management/arc-extension-troubleshoot-extension-2.png" alt-text="Screenshot of tips to troubleshoot a failed extension." lightbox="media/arc-extension-management/arc-extension-troubleshoot-extension-2.png":::

## Next step

Learn about [Virtual machine extension management with Azure Arc-enabled servers](/azure/azure-arc/servers/manage-vm-extensions).
