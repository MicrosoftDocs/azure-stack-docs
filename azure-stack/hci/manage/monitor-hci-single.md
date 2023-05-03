---
title: Monitor Azure Stack HCI with Azure Monitor HCI Insights
description: Enable logging and monitoring capabilities to monitor Azure Stack HCI clusters using Azure portal.
author: dansisson
ms.author: v-dansisson
ms.reviewer: saniyaislam
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 05/03/2023
# zone_pivot_groups: hci-versions
---

# Monitor Azure Stack HCI with Azure Monitor HCI Insights

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This article explains how to monitor an Azure Stack HCI cluster using Azure Stack HCI Insights. HCI Insights is a feature of Azure Monitor that quickly gets you started monitoring your Azure Stack HCI cluster. You can view key metrics, health, and usage information regarding cluster, servers, virtual machines, and storage.

## Benefits of Azure Stack HCI Insights

Azure Stack HCI Insights offers three primary benefits:

- It's managed by Azure and accessed from Azure portal, so it's always up to date, and there's no database or special software setup required.

- It's highly scalable, capable of loading more than 400 cluster information sets across multiple subscriptions at a time, with no boundary limitations on cluster, domain, or physical location.

- It's highly customizable. The user experience is built on top of Azure Monitor workbook templates, allowing users to change the views and queries, modify or set thresholds that align with the users' limits, and save these customizations into a workbook. Charts in the workbooks can then be pinned to Azure dashboards.

We recommend that you use the new Insights experience with Azure Monitor Agent (AMA) as AMA is faster, more secure and more performant. You can onboard new nodes to AMA  or  can also migrate your existing nodes from Legacy agent to AMA. Please refer to the “new” tab below in this document to configure Insights. For any reason, if you need to stay on the older experience temporarily, please refer the “old” tab below.

This article explains how to monitor an Azure Stack HCI cluster using Azure Stack HCI Insights. HCI Insights is a feature of Azure Monitor that quickly gets you started monitoring your Azure Stack HCI cluster. You can view useful insights regarding cluster, servers, virtual machines, and storage.

HCI Insights installs the Azure Monitor Agent and helps you to configure Data Collection rules for monitoring your Azure Stack HCI cluster.

# [New](#tab/22h2)

In the May 2023 cumulative update for Azure Stack HCI, version 22H2, a feature enhancement has been made to the Azure Stack HCI operating system that enables on-premises Azure Stack HCI systems to be monitored with Azure Monitor HCI Insights.

We recommend that you use the new Insights experience with Azure Monitor Agent (AMA) as AMA is faster, more secure and more performant. You can onboard new nodes to AMA or can also [migrate](#migrate-from-the-microsoft-monitoring-agent) your existing nodes from the legacy Log Analytics (MMA) agent to AMA.

Once the prerequisite are met, the **Get Started** button for Insights onboarding is enabled.

## Prerequisites for enabling Insights

There are several prerequisites for using Azure Stack HCI Insights:

- Azure Stack HCI cluster should be [registered](azure-stack/hci/deploy/register-with-azure) with Azure and Arc-enabled. If you registered your cluster on or after June 15, 2021, this happens by default. Otherwise, you'll need to enable [Azure Arc integration](azure-stack/hci/deploy/register-with-azure.md?enable-azure-arc-integration).

- The cluster must have Azure Stack HCI version 22H2 and the May 2023 cumulative update or later installed.

- Enable the managed identity for the Azure resource. For more information, see [What are managed identities for Azure resources?](/azure/active-directory/managed-identities-azure-resources/overview/)


### Enable Insights

Enabling Insights helps you monitor all Azure Stack HCI clusters currently associated with the Log Analytics workspace by providing useful health metrics. To enable this capability from the Azure portal, follow these steps:

1. In the Azure portal, browse to your Azure Stack HCI cluster resource page, then select your cluster. Under the **Capabilities** tab, select **Insights**.

    :::image type="content" source="media/monitor-hci-single/insights-tile.png" alt-text="Screenshot showing the Insights tile." lightbox="media/monitor-hci-single/insights-tile.png":::

1.	On the welcome screen. Select **Get started**.

    :::image type="content" source="media/monitor-hci-single/get-started.png" alt-text="Screenshot showing the Get Started button." lightbox="media/monitor-hci-single/get-started.png":::

    > [!NOTE]
    > The **Get Started** button is only available for version 22H2 with the May 2023 cumulative update or later installed and only after the managed identity is enabled. Otherwise this button is disabled.

1. In the **Insights** configuration window, select an existing [Data Collection Rule](/azure/azure-monitor/essentials/data-collection-rule-overview) (DCR) or create a new DCR and then select **Set up**.

    :::image type="content" source="media/monitor-hci-single/data-collection-rule.png" alt-text="Screenshot showing the Insights configuration window." lightbox="media/monitor-hci-single/data-collection-rule.png":::

1.	The **New data collection rule** window is displayed:

    :::image type="content" source="media/monitor-hci-single/data-collection-rule-2.png" alt-text="Screenshot showing the data collection rule window." lightbox="media/monitor-hci-single/data-collection-rule-2.png":::

    If a DCR hasn't already been created for the unmonitored cluster, then one will be created with performance counters enabled and the Windows event log channel enabled.

1.	Do one of the following:

    - Create a new DCR by selecting **Create new** in the Insights configuration window. Specify the subscription, data collection rule name, and data collection endpoint (optional) and then select the **Review + create** button.

    - Select an existing data collection rule from the dropdown:

    :::image type="content" source="media/monitor-hci-single/data-collection-rule-3.png" alt-text="Screenshot showing the data collection rule dropdown selector." lightbox="media/monitor-hci-single/data-collection-rule-3.png":::

    Only data collection rules enabled for Azure Stack HCI insights will be included. The DCR specifies the data to collect and the workspace to use. HCI insights creates a default DCR if one doesn't already exist.

    > [!IMPORTANT]
    > Don't create your own DCR. The DCR created by Azure Stack HCI Insights includes a special data stream required for its operation. You can edit this DCR to collect more data, such as Windows and Syslog events, but you should create additional DCRs and associate them with the computer if required. The DCRs created through AMA installation will have a prefix `AzureStackHCI-` attached with the DCR name.

1. Insights should now show as **Configured** on the **Capabilities** tab:

    :::image type="content" source="media/monitor-hci-single/insights-configured.png" alt-text="Screenshot showing the Insights tile as Configured." lightbox="media/monitor-hci-single/insights-configured.png":::

### Data collection rule

When you enable Azure Stack HCI insights on a machine with the Azure Monitor agent, you must specify a [data collection rule](/azure/azure-monitor/essentials/data-collection-rule-overview) to use. The DCR specifies the data to collect and the workspace to use.

|**Option**|**Description**|
|--|--|
|Performance Counters|Specifies what data performance counters to collect from the operating system. This option is required for all computers. These performance counters are used to populate the visualizations in the Insights workbook. Currently, Azure Stack HCI Insights workbook uses 5 performance counters - `Memory()\Available Bytes`, `Network Interface()\Bytes Total/sec`, `Processor(_Total)\% Processor Time`, `RDMA Activity()\RDMA Inbound Bytes/sec`, and `RDMA Activity()\RDMA Outbound Bytes/sec`|
|Event Log Channel|Specifies which Windows event logs to collect from the operating system. This option is required for all computers. Windows event logs are used to populate the visualizations in the Insights workbook. Currently, data is collected through two Windows event log channels: `- microsoft-windows-health/operational` and `microsoft-windows-sddc-management/operational`|
|Log Analytics workspace|Workspace to store the data. Only workspaces with Azure Stack HCI Insights are listed.|

### Event channel

The `Microsoft-windows-sddc-management/operational` and `Microsoft-windows-health/operational` Windows event channel will be added to your Log Analytics workspace under **Windows event logs**.

:::image type="content" source="media/monitor-hci-single/event-channel.png" alt-text="Screenshot showing Add data source window" lightbox="media/monitor-hci-single/event-channel.png":::

By collecting these logs, Insights will show the health status of the individual servers, drives, volumes, and VMs. By default, five performance counters are added.

### Performance counters

By default, five performance counters are added:

:::image type="content" source="media/monitor-hci-single/performance-counters.png" alt-text="Screenshot showing performance counters added." lightbox="media/monitor-hci-single/performance-counters.png":::

The following table describes the performance counters that are monitored:

| Performance counters                          | Description                                                                                                                                                           |
|--------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Memory(*)\Available Bytes                | Available Bytes is the amount of physical memory, in bytes, immediately available for allocation to a process or for system use.                                          |
| Network Interface(*)\Bytes Total/sec     | The rate at which bytes are sent and received over each network adapter, including framing characters. Bytes Total/sec is a sum of Bytes Received/sec and Bytes Sent/sec. |
| Processor(_Total)\% Processor Time       | The percentage of elapsed time that all of process threads used the processor to execution instructions.                                                                  |
| RDMA Activity(*)\RDMA Inbound Bytes/sec  | Rate of data received over RDMA by the network adapter per second.                                                                                                            |
| RDMA Activity(*)\RDMA Outbound Bytes/sec | Rate of data sent over RDMA by the network adapter per second.                                                                                                                |

After you enable Insights, it can take up to 15 minutes to collect the data. When the process is finished, you'll be able to see a rich visualization of the health of your cluster from the **Insights** menu on the left pane:

:::image type="content" source="media/monitor-hci-single/insights-visualization.png" alt-text="Screenshot showing Insight visualizations." lightbox="media/monitor-hci-single/insights-visualization.png":::

### Insights visualizations

Once Insights is enabled, the following tables provide details about all resources.

#### Health

Provides health faults on a cluster.

| Metric         | Description                                                                                                    | Unit                                        | Example                |
|--------------------|--------------------------------------------------------------------------------------------------------------------|-------------------------------------------------|----------------------------|
| Fault           | A short description of health faults. On clicking the link, a side panel opens with more information.                                                                      | No unit                                         | PoolCapacityThresholdExceeded                      |
| Faulting resource type       | The type of resource that encountered a fault.                                                                | No unit                                   | StoragePool      |
| Faulting resource ID          | Unique ID for the resource that encountered a health fault.                                                       | Unique ID | {1245340c-780b-4afc-af3c-f9bdc4b12f8a}: SP:{c57f23d1-d784-4a42-8b59-4edd8e70e830}                   |
| Severity          | Severity of fault could be warning or critical.                                                                            | No unit                                       | Warning                       |
| Initial fault time      | Timestamp of when server was last updated. | Datetime                                        | 4/9/2022, 12:15:42 PM

#### Server

| Metric         | Description                                                                                                    | Unit                                        | Example                |
|--------------------|--------------------------------------------------------------------------------------------------------------------|-------------------------------------------------|----------------------------|
| Servers            | The names of the servers in the cluster.                                                                       | No unit                                         | VM-1                       |
| Last updated       | The date and time of when the server was last updated.                                                                | Datetime                                   | 4/9/2022, 12:15:42 PM      |
| Status             | The health of server resources in the cluster.                                                       | It can be healthy, warning, critical, and other | Healthy                    |
| CPU usage          | The % of time the process has used the CPU.                                                                            | Percent                                         | 56%                        |
| Memory usage       | Memory usage of the server process is equal to counter Process\Private Bytes plus the size of memory-mapped data. | Percent                                         | 16%                        |
| Logical processors | The number of logical processors.                                                                              | Count                                           | 2                          |
| CPUs               | The number of CPUs.                                                                                            | Count                                           | 2                          |
| Uptime             | The time during which a machine, especially a computer, is in operation.                                     | Timespan                                    | 2.609 hr.                  |
| Site               | The name of the site to which the server belongs.                                                              | Site name                                      | SiteA |
| Domain name        | The local domain to which the server belongs.                                                               | No unit                                         | Contoso.local              |

#### Virtual machines

Provides the state of all the virtual machines in the cluster. A VM can be in one of the following states: Running, Stopped, Failed, or Other (Unknown, Starting, Snapshotting, Saving, Stopping, Pausing, Resuming, Paused, Suspended).

| Metric   | Description                                                                                                                                    | Unit      | Example           |
|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------|---------------|-----------------------|
| Servers      | The name of the server.                                                                                                                      | No unit       | Sample-VM-1           |
| Last Updated | This gives the date and time of when the server was last updated                                                                                   | Datetime | 4/9/2022, 12:24:02 PM |
| Total VMs    | The number of VMs in a server node.                                                                                                        | Count         | 0 of 0 running        |
| Running      | The number of VMs running in a server node.                                                                                                | Count         | 2                     |
| Stopped      | The number of VMs stopped in a server node.                                                                                                | Count         | 3                     |
| Failed       | The number of VMs failed in a server node.                                                                                                 | Count         | 2                     |
| Other        | If VM is in one of the following states (Unknown, Starting, Snapshotting, Saving, Stopping, Pausing, Resuming, Paused, Suspended), it is considered as "Other." | Count         | 2                     |

#### Storage
The following table provides the health of volumes in the cluster:

| Metric         | Description                                                                                 | Unit                                        | Example               |
|--------------------|-------------------------------------------------------------------------------------------------|-------------------------------------------------|---------------------------|
| Volumes            | The name of the volume                                                                  | No unit                                         | ClusterPerformanceHistory |
| Last updated       | The date and time of when the storage was last updated.                               | Datetime                                   | 4/14/2022, 2:58:55 PM     |
| Status             | The status of the volume.                                                                     | Healthy, warning, critical, and other. | Healthy                   |
| Total capacity     | The total capacity of the device in bytes during the reporting period.                          | Bytes                                           | 2.5GB                       |
| Available capacity | The available capacity in bytes during the reporting period.                                    | Bytes                                           | 20B                       |
| Iops               | Input/output operations per second.                                                              | Per second                                      | 45/s                      |
| Throughput         | Number of bytes per second the Application Gateway has served.                                   | Bytes per second                                  | 5B/s                      |
| Latency            | The time it takes for the I/O request to be completed.                                | Second                                          | 0.0016s                       |
| Resiliency         | The capacity to recover from failures. Maximizes data availability.                    | No unit                                         | Three Way Mirror          |
| Deduplication      | The process of reducing the physical amount of bytes of data that needs to be stored on disk. | Available or not                                | Yes/No                    |
| File system        | The type of filesystem.                                                                    | No unit                                         | ReFS                      |

### Disable Insights

To disable Insights, follow these steps:

1. Select **Insights** under the **Capabilities** tab.
2. Select **Disable Insights**.

   :::image type="content" source="media/monitor-hci-single/disable-insights-new.png" alt-text="Screenshot showing the Disable Insights window." lightbox="media/monitor-hci-single/disable-insights-new.png":::

When you disable the Insights feature, the association between the data collection rule and the cluster is deleted and the Health Service and SDDC Management logs are no longer collected; however, existing data is not deleted. If you'd like to delete that data, go into your DCR and Log Analytics workspace and delete the data manually.

### Update Insights

The Insights tile shows a **Needs update** message in the following cases:

- A data collection rule has changed.
- A health event from the Windows events log is deleted.
- Any of the five performance counters from the **Log Analytics** workspace are deleted.

To enable Insights again, do the following:

1. Select the **Insights** tile under **Capabilities**.

1. Select **Update** to see the visualizations again.

:::image type="content" source="media/monitor-hci-single/update-insights.png" alt-text="Screenshot showing the Update Insights window." lightbox="media/monitor-hci-single/update-insights.png":::

### Migrate from the Microsoft Monitoring Agent

1. To migrate from the Microsoft Monitoring Agent (MMA) to the Azure Monitoring Agent (AMA), scroll down to **Insights**.

    :::image type="content" source="media/monitor-hci-single/agent-migration.png" alt-text="Portal shows update needed" lightbox="media/monitor-hci-single/agent-migration.png":::

1. Select **Install AMA**; the **Insights configuration** window opens.

    :::image type="content" source="media/monitor-hci-single/agent-migration-2.png" alt-text="Screenshot showing the Data collection rules window." lightbox="media/monitor-hci-single/agent-migration-2.png":::

1. Select or create a data collection rule as mentioned previously in the *Enable Insights* section.

The Azure Monitor agent and the Microsoft Monitoring Agent extension can both be installed on the same computer during migration. Running both agents might lead to duplication of data and increased cost. If a machine has both agents installed, you'll see a warning in the Azure portal that you might be collecting duplicate data, as shown below.

> [!WARNING]
> Collecting duplicate data from a single machine with both the Azure Monitor agent and the Microsoft Monitoring Agent extension can result in extra ingestion cost from sending duplicate data to the Log Analytics workspace.

:::image type="content" source="media/monitor-hci-single/agent-migration-3.png" alt-text="Screenshot showing a data duplication warning." lightbox="media/monitor-hci-single/agent-migration-3.png":::

You must remove the Microsoft Monitoring Agent extension yourself from any computers that are using it. Before you do this step, ensure that the computer isn't relying on any other solutions that require the Microsoft Monitoring Agent.  After you verify that **MicrosoftMonitoringAgent** is not still connected to your Log Analytics workspace, you can remove **MicrosoftMonitoringAgent** manually by redirecting to the **Extensions** page.  

:::image type="content" source="media/monitor-hci-single/agent-migration-4.png" alt-text="Screenshot showing the Extensions list." lightbox="media/monitor-hci-single/agent-migration-4.png":::

## Azure Monitor pricing

As described previously, when you enable monitoring visualization, logs are collected from:

- Health Management (Microsoft-windows-health/operational).
- SDDC Management (Microsoft-Windows-SDDC-Management/Operational; Event ID: 3000, 3001, 3002, 3003, 3004).

You are billed based on the amount of data ingested and the data retention settings of your Log Analytics workspace.

Azure Monitor has pay-as-you-go pricing, and the first 5 GB per billing account per month is free. Because pricing can vary due to multiple factors, such as the region of Azure you're using, visit the [Azure Monitor pricing calculator](https://azure.microsoft.com/pricing/details/monitor/) for the most up-to-date pricing calculations.

## Troubleshooting

For troubleshooting steps, see [Troubleshooting guidance for the Azure Monitor agent](/azure/azure-monitor/agents/azure-monitor-agent-troubleshoot-windows-arc).

## Next steps

- [Azure Stack HCI Insights](/azure-stack/hci/manage/monitor-hci-multi)
- [Register your cluster with Azure](../deploy/register-with-azure.md)
- [Enable Azure Arc integration](../deploy/register-with-azure.md#enable-azure-arc-integration)
- [Event Log Channel](/azure-stack/hci/manage/monitor-hci-multi#event-log-channel)
- [Azure Monitor pricing calculator](https://azure.microsoft.com/pricing/details/monitor/)
- [Log Analytics Troubleshooting Tool](/azure/azure-monitor/agents/agent-windows-troubleshoot)


# [Legacy](#tab/21h2)

This content applies to version 21H2 of Azure Stack HCI.

## Prerequisites for enabling Insights

To use Azure Stack HCI Insights with the legacy Agent, make sure you've completed the following:

- Azure Stack HCI cluster should be [registered](azure-stack/hci/deploy/register-with-azure) with Azure and arc enabled. If you registered your cluster on or after June 15, 2021, this happens by default. Otherwise, you'll need to enable [Azure Arc integration].

- [Enable Log Analytics](/azure-stack/hci/deploy/register-with-azure.md) to link the cluster to a Log Analytics workspace where the log data required for monitoring will be saved.

- [Enable Insights](monitor-hci-single.md) to allow Azure Monitor to start collecting the events that are required for monitoring.

## Logs capability

After you register your cluster and Arc-enable the servers, you'll see the following in Azure portal:

- An Azure Stack HCI resource in the specified resource group.
- **Server - Azure Arc** resources for every server in the cluster in the `<clustername>ArcInstanceResourceGroup`.
- Nodes with a **Server-Azure Arc** resource link on the Azure Stack HCI resource page under the **Nodes** tab.

Now that your cluster nodes are Arc-enabled, navigate to your Azure Stack HCI cluster resource page. Under the **Capabilities** tab you will see the option to enable logs, which should say **Not configured**.

:::image type="content" source="media/monitor-hci-single/logs-capability.png" alt-text="Logs capability under the Capabilities tab" lightbox="media/monitor-azure-portal/logs-capability.png":::

This capability is an Arc for Servers extension that simplifies installing the Microsoft Monitoring Agent. Because you're using the Arc for Servers extension to enable this workflow, if you ever add additional servers to your cluster, they will automatically have the Microsoft Monitoring Agent installed on them.

   > [!NOTE]
   > The Microsoft Monitoring Agent for Windows communicates outbound to the Azure Monitor service over TCP port 443. If the servers connect through a firewall or proxy server to communicate over the internet, review [these requirements](/azure/azure-monitor/agents/log-analytics-agent#network-requirements) to understand the network configuration required.

### Configure the Microsoft Monitoring Agent extension

To configure the Microsoft Monitoring Agent (AMA) extension:

1. Under the **Capabilities** tab, select **Logs**.
2. Select **Use existing** to use the existing workspace for your subscription.
3. Select **Add** at the bottom of the page.

   :::image type="content" source="media/monitor-hci-single/enable-log-analytics.png" alt-text="Enable Log Analytics on Azure portal" lightbox="media/monitor-hci-single/enable-log-analytics.png":::

4. When the configuration is finished, **Logs** will appear as **Configured** under the **Capabilities** tab.
5. Select **Settings > Extensions** from the toolbar on the left. You should see that each of your servers has successfully installed the Microsoft Monitoring Agent.

You have now successfully installed the log analytics extension.

### Disable Log Analytics

If you'd like to disable the Logs capability, you'll need to remove the Microsoft Monitoring Agent from the **Extensions** settings. Note that this does not delete the Log Analytics workspace in Azure or any of the data that resides in it, so you'll have to do that manually.

To remove the Microsoft Monitoring Agent from every server in the cluster, follow these steps:

1. Select **Settings > Extensions** from the toolbar on the left.
2. Select the **MicrosoftMonitoringAgent** checkbox.
3. Click **Remove**, and then **Yes**.

## Azure Stack HCI Insights

Insights was previously known as "monitoring" and is used to monitor your resources and provide useful insights regarding cluster, servers, virtual machines, storage, and much more.

:::image type="content" source="media/monitor-hci-single/cluster-preview.png" alt-text="Cluster portal screen" lightbox="media/monitor-hci-single/cluster-preview.png":::

The data generated from your on-premises Azure Stack HCI cluster is collected in a Log Analytics workspace in Azure. Within that workspace, you can collect data about the health of your cluster. By default, monitoring collects the following logs every hour:

- Health Management (Microsoft-windows-health/operational)
- SDDC Management (Microsoft-Windows-SDDC-Management/Operational; Event ID: 3000, 3001, 3002, 3003, 3004)

To change the frequency of log collection, see [Event Log Channel](/azure-stack/hci/manage/monitor-hci-multi#event-log-channel).

### Enable Insights

Enabling Insights helps you monitor all Azure Stack HCI clusters currently associated with the Log Analytics workspace by providing useful health metrics. To enable this capability from the Azure portal, follow these steps:

1. Under the **Capabilities** tab, select **Insights**. Then select **Get started**.
2. Insights should now show as **Configured** in the **Capabilities** tab.

:::image type="content" source="media/monitor-hci-single/enable-insights.png" alt-text="Portal screen to enable Insights" lightbox="media/monitor-hci-single/enable-insights.png":::

### What data is collected?

The **Microsoft-windows-sddc-management/operational** and **microsoft-windows-health/operational** Windows event channel will be
added to your Log Analytics workspace under **Windows event logs**.

:::image type="content" source="media/monitor-hci-single/windows-event-logs.png" alt-text="Portal workspace for Windows event logs" lightbox="media/monitor-hci-single/windows-event-logs.png":::

By collecting these logs, analytics will show the health status of the individual servers, drives, volumes, and VMs. By default, 5 performance counters will be added:

:::image type="content" source="media/monitor-hci-single/performance-counters.png" alt-text="Windows performance counters" lightbox="media/monitor-hci-single/performance-counters.png":::

### Performance counters

The following table describes the performance counters that are monitored:

| Performance counters                          | Description                                                                                                                                                           |
|--------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Memory(*)\Available Bytes                | Available Bytes is the amount of physical memory, in bytes, immediately available for allocation to a process or for system use.                                          |
| Network Interface(*)\Bytes Total/sec     | The rate at which bytes are sent and received over each network adapter, including framing characters. Bytes Total/sec is a sum of Bytes Received/sec and Bytes Sent/sec. |
| Processor(_Total)\% Processor Time       | The percentage of elapsed time that all of process threads used the processor to execution instructions.                                                                  |
| RDMA Activity(*)\RDMA Inbound Bytes/sec  | Rate of data received over RDMA by the network adapter per second.                                                                                                            |
| RDMA Activity(*)\RDMA Outbound Bytes/sec | Rate of data sent over RDMA by the network adapter per second.                                                                                                                |

After you enable Insights, it can take up to 15 minutes to collect the data. When the process is finished, you'll be able to see a rich visualization of the health of your cluster, under the **Insights** tab on the left navigation, as shown in the following screen shot:

:::image type="content" source="media/monitor-hci-single/server-health.png" alt-text="Server visualizations" lightbox="media/monitor-hci-single/server-health.png":::

### Insights visualizations

Once Insights is enabled, the following tables provide details about all resources.

#### Health

Provides health faults on a cluster.

| Metric         | Description                                                                                                    | Unit                                        | Example                |
|--------------------|--------------------------------------------------------------------------------------------------------------------|-------------------------------------------------|----------------------------|
| Fault           | A short description of health faults. On clicking the link, a side panel opens with more information.                                                                      | No unit                                         | PoolCapacityThresholdExceeded                      |
| Faulting resource type       | The type of resource that encountered a fault.                                                                | No unit                                   | StoragePool      |
| Faulting resource ID          | Unique ID for the resource that encountered a health fault.                                                       | Unique ID | {1245340c-780b-4afc-af3c-f9bdc4b12f8a}: SP:{c57f23d1-d784-4a42-8b59-4edd8e70e830}                   |
| Severity          | Severity of fault could be warning or critical.                                                                            | No unit                                       | Warning                       |
| Initial fault time      | Timestamp of when server was last updated. | Datetimestamp                                        | 4/9/2022, 12:15:42 PM

#### Server

| Metric         | Description                                                                                                    | Unit                                        | Example                |
|--------------------|--------------------------------------------------------------------------------------------------------------------|-------------------------------------------------|----------------------------|
| Servers            | The names of the servers in the cluster.                                                                       | No unit                                         | VM-1                       |
| Last updated       | The timestamp of when the server was last updated.                                                                | Datetime                                   | 4/9/2022, 12:15:42 PM      |
| Status             | The health of server resources in the cluster.                                                       | It can be healthy, warning, critical, and other | Healthy                    |
| CPU usage          | The % of time the process has used the CPU.                                                                            | Percent                                         | 56%                        |
| Memory usage       | Memory usage of the server process is equal to counter Process\Private Bytes plus the size of memory-mapped data. | Percent                                         | 16%                        |
| Logical processors | The number of logical processors.                                                                              | Count                                           | 2                          |
| CPUs               | The number of CPUs.                                                                                            | Count                                           | 2                          |
| Uptime             | The time during which a machine, especially a computer, is in operation.                                     | Timespan                                    | 2.609 hr.                  |
| Site               | The site name to which the server belongs.                                                              | Site name                                      | SiteA |
| Domain name        | The local domain to which the server belongs.                                                               | No unit                                         | Contoso.local              |

#### Virtual machines

Provides the state of all the virtual machines in the cluster. A VM can be in one of the following states: Running, Stopped, Failed, or Other (Unknown, Starting, Snapshotting, Saving, Stopping, Pausing, Resuming, Paused, Suspended).

| Metric   | Description                                                                                                                                    | Unit      | Example           |
|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------|---------------|-----------------------|
| Servers      | The name of the server.                                                                                                                      | No unit       | Sample-VM-1           |
| Last Updated | This gives the datetimestamp of when the server was last updated                                                                                   | Datetimestamp | 4/9/2022, 12:24:02 PM |
| Total VMs    | The number of VMs in a server node.                                                                                                        | Count         | 0 of 0 running        |
| Running      | The number of VMs running in a server node.                                                                                                | Count         | 2                     |
| Stopped      | The number of VMs stopped in a server node.                                                                                                | Count         | 3                     |
| Failed       | The number of VMs failed in a server node.                                                                                                 | Count         | 2                     |
| Other        | If VM is in one of the following states (Unknown, Starting, Snapshotting, Saving, Stopping, Pausing, Resuming, Paused, Suspended), it is considered as "Other." | Count         | 2                     |

#### Volume health

The following table provides the health of volumes in the cluster:

| Metric         | Description                                                                                 | Unit                                        | Example               |
|--------------------|-------------------------------------------------------------------------------------------------|-------------------------------------------------|---------------------------|
| Volumes            | The name of the volume                                                                  | No unit                                         | ClusterPerformanceHistory |
| Last updated       | The date/timestamp of when the storage was last updated.                               | Datetime                                   | 4/14/2022, 2:58:55 PM     |
| Status             | The status of the volume.                                                                     | Healthy, warning, critical, and other. | Healthy                   |
| Total capacity     | The total capacity of the device in bytes during the reporting period.                          | Bytes                                           | 2.5GB                       |
| Available capacity | The available capacity in bytes during the reporting period.                                    | Bytes                                           | 20B                       |
| Iops               | Input/output operations per second.                                                              | Per second                                      | 45/s                      |
| Throughput         | Number of bytes per second the Application Gateway has served.                                   | Bytes per second                                  | 5B/s                      |
| Latency            | The time it takes for the I/O request to be completed.                                | Second                                          | 0.0016s                       |
| Resiliency         | The capacity to recover from failures. Maximizes data availability.                    | No unit                                         | Three Way Mirror          |
| Deduplication      | The process of reducing the physical amount of bytes of data that needs to be stored on disk. | Available or not                                | Yes/No                    |
| File system        | The type of filesystem.                                                                    | No unit                                         | ReFS                      |

### Disable Insights

To disable insights, follow these steps:

1. Select **Insights** under the **Capabilities** tab.
2. Select **Disable Insights**.

   :::image type="content" source="media/monitor-hci-single/disable-insights.png" alt-text="Portal screen for disabling Insights" lightbox="media/monitor-hci-single/disable-insights.png":::

When you disable the Insights feature, the Health Service and SDDC Management logs are no longer collected; however, existing data is not
deleted. If you'd like to delete that data, go into your Log Analytics workspace and delete the data manually.

### Update Insights

The Insights tile shows a **Needs update** message in the following cases:

- The health event from Windows events logs is deleted.
- Any or all of the 5 performance counters from the **Loganalytics** workspace are deleted.

To enable Insights again,

- Select the **Insights** tile under **Capabilities**.
- Select **Update** to see the visualizations again.

:::image type="content" source="media/monitor-hci-single/needs-update.png" alt-text="Portal shows update needed" lightbox="media/monitor-hci-single/needs-update.png":::

## Azure Monitor pricing

As described previously, when you enable monitoring visualization, logs are collected from:

- Health Management (Microsoft-windows-health/operational).
- SDDC Management (Microsoft-Windows-SDDC-Management/Operational; Event ID: 3000, 3001, 3002, 3003, 3004).

You are billed based on the amount of data ingested and the data retention settings of your Log Analytics workspace.

Azure Monitor has pay-as-you-go pricing, and the first 5 GB per billing account per month is free. Because pricing can vary due to multiple factors, such as the region of Azure you're using, visit the [Azure Monitor pricing calculator](https://azure.microsoft.com/pricing/details/monitor/) for the most up-to-date pricing calculations.

## Troubleshooting

If the Logs capability and Monitoring capability are enabled without errors but the monitoring data doesn't appear after an hour or so, you can use the [Log Analytics Troubleshooting Tool](/azure/azure-monitor/agents/agent-windows-troubleshoot).

### How to use the Log Analytics Troubleshooting Tool

1. Open a PowerShell prompt as Administrator on the Azure Stack HCI host where the MicrosoftMonitoringAgent extension is installed.
2. Navigate to the directory where the tool is located.

   ```PowerShell
   cd C:\Program Files\Microsoft Monitoring Agent\Agent\Troubleshooter
   ```

3. Execute the main script using this command:

   ```PowerShell
   .\GetAgentInfo.ps1
   ```

4. When prompted to select a troubleshooting scenario, choose option 1: **Agent not reporting data or heartbeat data missing**.

5. You'll be prompted to select the action that you'd like to perform. Choose option **1: Diagnose**.

   :::image type="content" source="media/monitor-hci-single/tool-options-1.png" alt-text="Troubleshooting tool command line options" lightbox="media/monitor-hci-single/tool-options-1.png":::

6. If you encounter the error that's highlighted in the following screenshot but are still able to connect to all Log Analytics endpoints and your firewall and gateway settings are correct, you have likely encountered a timezone issue.

   :::image type="content" source="media/monitor-hci-single/tool-errors.png" alt-text="Command prompt showing tool errors" lightbox="media/monitor-hci-single/tool-errors.png":::

   The cause is that the local time is different than Azure time, and the workspace key could not be validated due to the mismatch.

   :::image type="content" source="media/monitor-hci-single/tool-errors-prompt.png" alt-text="Move to next error" lightbox="media/monitor-hci-single/tool-errors-prompt.png":::

7. To resolve the issue:

   1. Go to your Azure Stack HCI resource page in Azure portal, select **[cluster name] > Extensions**. Then select the tick box for the MicrosoftMonitoringAgent extension and remove the Microsoft Monitoring Agent extension.
   1. Ensure that your Azure Stack HCI host time zone is correct, and that the local time on the host is the same as Azure time for your time zone.
      1. From the Azure Stack HCI host console, select **option 9: Date & Time** from the **Sconfig** menu, then select **change time zone** and ensure local time is correct.
      1. Review the Active Directory PDC (Primary Domain Controller) time zone, and make sure the date and time are correct.
      1. If Active Directory PDC is correct and Azure Stack HCI local time is still incorrect, then the Active Directory domain hierarchy is not being recognized. If this is the case, complete steps iv - vi below. Otherwise, proceed to step c.
      1. From the Azure Stack HCI host,  select **option 15** to exit the **Sconfig menu**. Then run the following command in PowerShell as an administrator: `w32tm.exe /config /syncfromflags:domhier /update` - this should return a confirmation that the command completed successfully, and the time setting should now be correct.
      1. To diagnose further, run `w32tm /monitor` on the Azure Stack HCI host console. The active domain controller should be listed as stratum 1 server, and all other domain controllers as stratum 2.
      1. Lastly, ensure that the Windows time service and time providers are not configured in a Group Policy Object, as this will interfere with the Active Directory domain hierarchy.
   1. Re-add the **Log Analytics** extension by going to your Azure Stack HCI resource page in Azure portal, select **[cluster name] > Overview**, then select **Capabilities** and configure Log Analytics and Monitoring.

8. Rerun the Log Analytics Troubleshooting Tool and you should no longer see the error. You should now see Windows agent numbers increment in your Log Analytics workspace under **Agents Management** to match your cluster nodes, and monitoring events will begin to flow.

## Next steps

- [Azure Stack HCI Insights](/azure-stack/hci/manage/monitor-hci-multi)
- [Register your cluster with Azure](../deploy/register-with-azure.md)
- [Enable Azure Arc integration](../deploy/register-with-azure.md#enable-azure-arc-integration)
- [Event Log Channel](/azure-stack/hci/manage/monitor-hci-multi#event-log-channel)
- [Azure Monitor pricing calculator](https://azure.microsoft.com/pricing/details/monitor/)
- [Log Analytics Troubleshooting Tool](/azure/azure-monitor/agents/agent-windows-troubleshoot)