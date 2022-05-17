---
title: Configure Azure portal to monitor Azure Stack HCI clusters
description: How to enable Logs and Monitoring capabilities to monitor Azure Stack HCI clusters from Azure portal.
author: sethmanheim
ms.author: sethm
ms.reviewer: arduppal
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 04/06/2022
---

# Configure Azure portal to monitor Azure Stack HCI clusters (preview)

> Applies to: Azure Stack HCI, version 21H2

This article explains how to enable logs and monitoring capabilities to monitor Azure Stack HCI clusters with [Azure Stack HCI Insights](/azure-stack/hci/manage/monitor-hci-multi).

If you haven't already, be sure to [Register your cluster with Azure](../deploy/register-with-azure.md). After you've enabled logs and monitoring, you can use [Azure Stack HCI Insights](/azure-stack/hci/manage/monitor-hci-multi) to monitor cluster health, performance, and usage.

   > [!IMPORTANT]
   > Monitoring an Azure Stack HCI cluster from Azure portal requires every server in the cluster to be Azure Arc-enabled. If you registered your cluster on or after June 15, 2021, this happens by default. Otherwise, you'll need to [enable Azure Arc integration](../deploy/register-with-azure.md#enable-azure-arc-integration).

## Logs capability (preview)

After you register your cluster and Arc-enable the servers, you'll see the following in Azure portal:

- An Azure Stack HCI resource in the specified resource group.
- **Server - Azure Arc** resources for every server in the cluster in the `<clustername>ArcInstanceResourceGroup`.
- Nodes with a **Server-Azure Arc** resource link on the Azure Stack HCI resource page under the **Nodes** tab.

Now that your cluster nodes are Arc-enabled, navigate to your Azure Stack HCI cluster resource page. Under the **Capabilities** tab you will see the option to enable logs, which should say **Not configured**.

:::image type="content" source="media/monitor-azure-portal/logs-capability.png" alt-text="Select the Logs capability under the Capabilities tab" lightbox="media/monitor-azure-portal/logs-capability.png":::

This capability is an Arc for Servers extension that simplifies installing the Microsoft Monitoring Agent. Because you're using the Arc for Servers extension to enable this workflow, if you ever add additional servers to your cluster, they will automatically have the Microsoft Monitoring Agent installed on them.

   > [!NOTE]
   > The Microsoft Monitoring Agent for Windows communicates outbound to the Azure Monitor service over TCP port 443. If the servers connect through a firewall or proxy server to communicate over the internet, review [these requirements](/azure/azure-monitor/agents/log-analytics-agent#network-requirements) to understand the network configuration required.

### Configure the Log Analytics Agent extension

To configure the Log Analytics Agent extension:

1. Under the **Capabilities** tab, select **Logs**.
2. Select **Use existing** to use the existing workspace for your subscription.
3. Select **Add** at the bottom of the page.

   :::image type="content" source="media/monitor-azure-portal/enable-log-analytics.png" alt-text="Enable Log Analytics on Azure portal" lightbox="media/monitor-azure-portal/enable-log-analytics.png":::

4. When the configuration is finished, **Logs** will appear as **Configured** under the **Capabilities** tab.
5. Select **Settings > Extensions** from the toolbar on the left. You should see that each of your servers has successfully installed the Microsoft Monitoring Agent.

You have now successfully installed the log analytics extension.

### Disable Log Analytics

If you'd like to disable the Logs capability, you'll need to remove the Microsoft Monitoring Agent from the **Extensions** settings. Note that this does not delete the Log Analytics workspace in Azure or any of the data that resides in it, so you'll have to do that manually.

To remove the Microsoft Monitoring Agent from every server in the cluster, follow these steps:

1. Select **Settings > Extensions** from the toolbar on the left.
2. Select the **MicrosoftMonitoringAgent** checkbox.
3. Click **Remove**, and then **Yes**.

## Monitoring capability (preview)

Now that you've set up a Log Analytics workspace, you can enable monitoring. Once monitoring is enabled, the data generated from your on-premises Azure Stack HCI cluster will then be collected in a Log Analytics workspace in Azure. Within that workspace, you can collect data about the health of your cluster. By default, monitoring collects the following logs every hour:

- SDDC Management (Microsoft-Windows-SDDC-Management/Operational; Event ID: 3000, 3001, 3002, 3003, 3004)

To change the frequency of log collection, see [Event Log Channel](/azure-stack/hci/manage/monitor-hci-multi#event-log-channel).

### Enable monitoring visualizations

Enabling monitoring turns on monitoring for all Azure Stack HCI clusters currently associated with the Log Analytics workspace. You will be billed based on the amount of data ingested and the data retention settings of your Log Analytics workspace.

To enable this capability from the Azure portal, follow these steps:

1. Under the **Capabilities** tab, select **Monitoring**, then **Enable**.
1. Monitoring should now show as **Configured** under the **Capabilities** tab.

The **Microsoft-windows-sddc-management/operational** Windows event channel will be added to your Log Analytics workspace. By collecting these logs, these analytics  show the health status of the individual servers, drives, volumes, and VMs.

After you enable monitoring, it can take up to an hour to collect the data. When the process is finished, you'll be able go to the **Monitoring** tab and see a rich visualization of the health of your cluster, as in the screenshot below.

:::image type="content" source="media/monitor-azure-portal/monitoring-visualization.png" alt-text="Enabling monitoring displays a rich visualization of the health of your cluster from Azure portal" lightbox="media/monitor-azure-portal/monitoring-visualization.png":::

You'll see tiles for the health status of your overall cluster along with key subcomponents. The first tile shows any health faults that the Health Service has thrown on your cluster. The other three tiles show you the health status of your drives, VMs, and volumes so that you can easily discern what's going on with the internals of your HCI cluster. You'll also see charts for CPU, memory, and storage usage. These charts are populated using the SDDC Management logs that are collected every hour by default. This view will allow you to check up on your HCI cluster through the Azure portal without having to connect to it directly.

### Disable monitoring visualizations

To disable monitoring, follow these steps:

1. Select **Monitoring** under the **Capabilities** tab.
2. Select **Disable Monitoring**.

When you disable the monitoring feature, the Health Service and SDDC Management logs are no longer collected; however, existing data is not deleted. If you'd like to delete that data, go into your Log Analytics workspace and delete the data manually.

## Azure Monitor pricing

Because pricing can vary due to multiple factors, such as the region of Azure you're using, visit the [Azure Monitor pricing calculator](https://azure.microsoft.com/pricing/details/monitor/) for the most up-to-date pricing calculations.

As described earlier, when you enable monitoring visualization, logs are collected from:

- SDDC Management (Microsoft-Windows-SDDC-Management/Operational; Event ID: 3000, 3001, 3002, 3003, 3004)

Azure Monitor has pay-as-you-go pricing, and the first 5 GB per billing account per month is free. For exact costs, see the [Azure Monitor pricing calculator](https://azure.microsoft.com/pricing/details/monitor/) for price per GB after the first 5 GB. The following table can help you calculate the cost:

| **Clusters in standalone Log Analytics workspace** | **GB ingested per month** |
|:---------------------------------------------------|:--------------------------|
| Two-node cluster                                   | ~1 MB per hour            |
| Four-node cluster                                  | ~1 MB per hour            |
| Eight-node cluster                                 | ~1 MB per hour            |

The following table shows the pricing structure for Azure Stack HCI clusters of different sizes:

| **Clusters in same Log Analytics workspace** | **GB ingested per month** |
|:---------------------------------------------|:--------------------------|
| Small deployment (3 two-node clusters)       | ~3 GB                     |
| Medium deployment (10 four-node clusters)    | ~10 GB                    |
| Large deployment (25 four-node clusters)     | ~25 GB                    |

## Troubleshooting

If the Logs capability and Monitoring capability are enabled without errors but the monitoring data doesn't show up even after an hour or so, you can use the [Log Analytics Troubleshooting Tool](/azure/azure-monitor/agents/agent-windows-troubleshoot).

### How to use the Log Analytics Troubleshooting Tool

1.    Open a PowerShell prompt as Administrator on the Azure Stack HCI host where Log Analytics Agent is installed.

2.    Navigate to the directory where the tool is located.

   ```PowerShell
   cd C:\Program Files\Microsoft Monitoring Agent\Agent\Troubleshooter
   ```

3.    Execute the main script using this command:

   ```PowerShell
   .\GetAgentInfo.ps1
   ```

4.    When prompted to select a troubleshooting scenario, choose option **1: Agent not reporting data or heartbeat data missing**.

:::image type="content" source="media/monitor-azure-portal/select-troubleshooting-scenario.png" alt-text="choose option 1: Agent not reporting data or heartbeat data missing" lightbox="media/monitor-azure-portal/select-troubleshooting-scenario.png":::

5. You'll be prompted to select the action that you'd like to perform. Choose option **1: Diagnose**.

:::image type="content" source="media/monitor-azure-portal/select-option-1.png" alt-text="choose option 1: diagnose" lightbox="media/monitor-azure-portal/select-option-1.png":::

6. If you encounter the error highlighted in the screenshot below but are still able to connect to all Log Analytics endpoints and your firewall and gateway settings are correct, you have likely encountered a timezone issue.

:::image type="content" source="media/monitor-azure-portal/timezone-issue-1.png" alt-text="If you see this error, you have likely encountered a timezone issue." lightbox="media/monitor-azure-portal/timezone-issue-1.png":::

   The cause is that the local time is different than Azure time, and the workspace key could not be validated due to the mismatch.

:::image type="content" source="media/monitor-azure-portal/timezone-issue-2.png" alt-text="The cause is that the local time is different than Azure time, as shown in this screenshot." lightbox="media/monitor-azure-portal/timezone-issue-2.png":::

7. To resolve the issue:

   1. Go to your Azure Stack HCI resource page in Azure portal, select **[cluster name] > Extensions**. Then select the tick box for MicrosoftMonitoringAgent and remove the Microsoft Monitoring Agent Extension.
   1. Ensure that your Azure Stack HCI host time zone is correct, and that the local time on the host is the same as Azure time for your time zone.
      1. From the Azure Stack HCI host console, select **option 9: Date & Time** from the **Sconfig** menu, then select **change time zone** and ensure local time is correct.
      1. Review the Active Directory PDC (Primary Domain Controller) time zone, and make sure the date and time are correct.
      1. If Active Directory PDC is correct and Azure Stack HCI local time is still incorrect, then the Active Directory domain hierarchy is not being recognized. If this is the case, complete steps iv - vi below. Otherwise, proceed to step c.
      1. From the Azure Stack HCI host,  select **option 15** to exit the **Sconfig menu**. Then run the following command in PowerShell as an administrator: `w32tm.exe /config /syncfromflags:domhier /update` - this should return a confirmation that the command completed successfully, and the time setting should now be correct.
      1. To diagnose further, run `w32tm /monitor` on the Azure Stack HCI host console. The active domain controller should be listed as stratum 1 server, and all other domain controllers as stratum 2.
      1. Lastly, ensure that the Windows time service and time providers are not configured in a Group Policy Object, as this will interfere with the Active Directory domain hierarchy.
   1. Re-add the **Log Analytics** extension by going to your Azure Stack HCI resource page in Azure portal, select **[cluster name] > Overview**, then select **Capabilities** and configure Log Analytics and Monitoring.
   
8. Re-run the Log Analytics Troubleshooting Tool and you should no longer see the error. You should now see Windows agent numbers increment in your Log Analytics workspace under **Agents Management** to match your cluster nodes, and monitoring events will begin to flow.

## Next steps

You're now ready to monitor multiple Azure Stack HCI clusters from Azure portal:
> [!div class="nextstepaction"]
> [Azure Stack HCI Insights](/azure-stack/hci/manage/monitor-hci-multi)