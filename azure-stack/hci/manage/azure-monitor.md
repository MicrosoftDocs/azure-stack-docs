---
title: Monitor servers with Azure Monitor
description: Monitor servers and configure alerts with Azure Monitor from Windows Admin Center.
author: khdownie
ms.author: v-kedow
ms.topic: how-to
ms.date: 07/21/2020
---

# Monitor servers with Azure Monitor

> Applies to: Windows Server 2019, Windows Server 2016

[Azure Monitor](/azure/azure-monitor/overview) collects, analyzes, and acts on telemetry from a variety of resources, including Windows servers and virtual machines (VMs), both on-premises and in the cloud.

## How does Azure Monitor work?
:::image type="content" source="media/monitor/azure-monitor-diagram.png" alt-text="diagram of how Azure Monitor works" border="false":::
Data generated from on-premises Windows Servers is collected in a Log Analytics workspace in Azure Monitor. Within a workspace, you can enable various monitoring solutions and use sets of logic that provide insights for a particular scenario; for example, performance metrics.

When you enable a monitoring solution in a Log Analytics workspace, all the servers reporting to that workspace will start collecting data relevant to that solution, so that the solution can generate insights for all the servers in the workspace.

To collect diagnostic data on an on-premises server and push it to the Log Analytics workspace, Azure Monitor requires the installation of the Microsoft Monitoring Agent (MMA). Certain monitoring solutions also require a secondary agent. For example, Azure Monitor for VMs also depends on a dependency agent for additional functionality.

## What data does Azure Monitor collect?

All data collected by Azure Monitor fits into one of two fundamental types: metrics and logs.

1. [Metrics](/azure/azure-monitor/platform/data-platform#metrics) are numerical values that describe some aspect of a system at a particular point in time. They are lightweight and capable of supporting near real-time scenarios. You'll see data collected by Azure Monitor right in the **Overview** page in the Azure portal.

    :::image type="content" source="media/monitor/metrics.png" alt-text="image of metrics ingesting in metrics explorer" border="false":::

2. [Logs](/azure/azure-monitor/platform/data-platform#logs) contain different kinds of data organized into records with different sets of properties for each type. Telemetry such as events and traces are stored as logs in addition to performance data so that it can all be combined for analysis. Log data collected by Azure Monitor can be analyzed with [queries](/azure/azure-monitor/log-query/log-query-overview) to quickly retrieve, consolidate, and analyze collected data. You can create and test queries using [Log Analytics](/azure/azure-monitor/log-query/portals) in the Azure portal and then either directly analyze the data using these tools or save queries for use with [visualizations](/azure/azure-monitor/visualizations) or [alert rules](/azure/azure-monitor/platform/alerts-overview).

    :::image type="content" source="media/monitor/logs.png" alt-text="image of logs ingesting in log analytics" border="false":::

## How does Windows Admin Center enable you to use Azure Monitor?

From within Windows Admin Center, you can enable the following monitoring solutions:

- [Azure Monitor for Clusters](#onboard-your-cluster-using-windows-admin-center)
- Azure Monitor for VMs (in server Settings), a.k.a Virtual Machine insights

You can get started using Azure Monitor from any of these tools. If you've never used Azure Monitor before, Windows Admin Center will automatically provision a Log Analytics workspace (and Azure Automation account, if needed), and install and configure the MMA and the dependency agent on the target server. It will then install the corresponding solution into the workspace.

If you want to add another monitoring solution from within Windows Admin Center on the same server, Windows Admin Center will simply install that solution into the existing workspace to which that server is connected. Windows Admin Center will additionally install any other necessary agents.

If you connect to a different server, but have already setup a Log Analytics workspace (either through Windows Admin Center or manually in the Azure portal), you can also install the MMA on the server and connect it up to an existing workspace. When you connect a server into a workspace, it automatically starts collecting data and reporting to solutions installed in that workspace.

## Azure Monitor for virtual machines (Virtual Machine insights)

When you set up Azure Monitor for VMs in **Server Settings**, Windows Admin Center enables the Azure Monitor for VMs solution, also known as Virtual Machine insights. This solution allows you to monitor server health and events, create email alerts, get a consolidated view of server performance across your environment, and visualize apps, systems, and services connected to a given server.

> [!NOTE]
> Despite its name, Virtual Machine insights works for physical servers as well as virtual machines.

With Azure Monitor's free 5 GB of data/month/customer allowance, you can easily try this out for a server or two without worry of getting charged. Read on to see additional benefits of onboarding servers into Azure Monitor, such as getting a consolidated view of systems performance across the servers in your environment.

## Onboard your cluster using Windows Admin Center

The simplest way to onboard your cluster to Azure Monitor is by using the automated workflow in Windows Admin Center that configures the Health Service and Log Analytics, then installs the MMA.

:::image type="content" source="media/monitor/onboarding.gif" alt-text="image of onboarding cluster to Azure Monitor":::

From the Overview page of a server connection, click the new button **Manage alerts**, or go to **Server Settings > Monitoring and alerts**. Within this page, onboard your server to Azure Monitor by clicking **Set up** and completing the setup pane. Admin Center takes care of provisioning the Azure Log Analytics workspace, installing the necessary agent, and ensuring the Virtual Machine insights solution is configured. Once complete, your server will send performance counter data to Azure Monitor, enabling you to view and create email alerts based on this server, from the Azure portal.

## Onboard your cluster manually using PowerShell

If you prefer to onboard your cluster manually, follow the steps below.

### Configure Health Service

The first thing that you need to do is configure your cluster. As you may know, the [Health Service](/windows-server/failover-clustering/health-service-overview) improves the day-to-day monitoring and operational experience for clusters running Storage Spaces Direct.

As we saw above, Azure Monitor collects logs from each node that it is running on in your cluster. So, we have to configure the Health Service to write to an event channel, which happens to be:

```
Event Channel: Microsoft-Windows-Health/Operational
Event ID: 8465
```

To configure the Health Service, you run:

```PowerShell
get-storagesubsystem clus* | Set-StorageHealthSetting -Name "Platform.ETW.MasTypes" -Value "Microsoft.Health.EntityType.Subsystem,Microsoft.Health.EntityType.Server,Microsoft.Health.EntityType.PhysicalDisk,Microsoft.Health.EntityType.StoragePool,Microsoft.Health.EntityType.Volume,Microsoft.Health.EntityType.Cluster"
```

Running the cmdlet above tells the Health Setting to start writing events to the *Microsoft-Windows-Health/Operational* event channel.

### Configure Log Analytics

Now that you have setup the proper logging on your cluster, the next step is to properly configure Log Analytics.

To give an overview, [Azure Log Analytics](/azure/azure-monitor/platform/agent-windows) can collect data directly from your physical or virtual Windows computers in your data center or other cloud environment into a single repository for detailed analysis and correlation.

To understand the supported configuration, review [supported Windows operating systems](/azure/azure-monitor/platform/log-analytics-agent#supported-windows-operating-systems) and [network firewall configuration](/azure/azure-monitor/platform/log-analytics-agent#network-firewall-requirements).

If you don't have an Azure subscription, create a [free account](https://azure.microsoft.com/free/?WT.mc_id=A261C142F) before you begin.

#### Log in to Azure portal

Log in to the Azure portal at [https://portal.azure.com](https://azure.microsoft.com/free/?WT.mc_id=A261C142F).

#### Create a workspace

For more details on the steps listed below, see the [Azure Monitor documentation](/azure/azure-monitor/learn/quick-collect-windows-computer).

1. In the Azure portal, click **All services**. In the list of resources, type **Log Analytics**. As you begin typing, the list filters based on your input. Select **Log Analytics**.

    :::image type="content" source="media/monitor/azure-portal-01.png" alt-text="Azure portal":::

2. Click **Create**, and then select choices for the following items:

   * Provide a name for the new **Log Analytics Workspace**, such as *DefaultLAWorkspace*.
   * Select a **Subscription** to link to by selecting from the drop-down list if the default selected is not appropriate.
   * For **Resource Group**, select an existing resource group that contains one or more Azure virtual machines.

    :::image type="content" source="media/monitor/create-loganalytics-workspace-02.png" alt-text="Create Log Analytics resource blade":::

3. After providing the required information on the **Log Analytics Workspace** pane, click **OK**.

While the information is verified and the workspace is created, you can track its progress under **Notifications** from the menu.

#### Obtain workspace ID and key
Before installing the MMA for Windows, you need the workspace ID and key for your Log Analytics workspace.  This information is required by the setup wizard to properly configure the agent and ensure it can successfully communicate with Log Analytics.

1. In the Azure portal, click **All services** found in the upper left-hand corner. In the list of resources, type **Log Analytics**. As you begin typing, the list filters based on your input. Select **Log Analytics**.
2. In your list of Log Analytics workspaces, select *DefaultLAWorkspace* created earlier.
3. Select **Advanced settings**.
    :::image type="content" source="media/monitor/log-analytics-advanced-settings-01.png" alt-text="Log Analytics Advance Settings":::
4. Select **Connected Sources**, and then select **Windows Servers**.
5. The value to the right of **Workspace ID** and **Primary Key**. Save both temporarily - copy and paste both into your favorite editor for the time being.

### Installing the MMA on Windows
The following steps install and configure the Microsoft Monitoring Agent.

> [!IMPORTANT]
> Be sure to install this agent on each server in your cluster and indicate that you want the agent to run at Windows startup.

1. On the **Windows Servers** page, select the appropriate **Download Windows Agent** version to download depending on the processor architecture of the Windows operating system.
2. Run Setup to install the agent on your computer.
3. On the **Welcome** page, click **Next**.
4. On the **License Terms** page, read the license and then click **I Agree**.
5. On the **Destination Folder** page, change or keep the default installation folder and then click **Next**.
6. On the **Agent Setup Options** page, choose to connect the agent to Azure Log Analytics and then click **Next**.
7. On the **Azure Log Analytics** page, paste the **Workspace ID** and **Workspace Key (Primary Key)** that you copied earlier. If the computer needs to communicate through a proxy server to the Log Analytics service, click **Advanced** and provide the URL and port number of the proxy server. If your proxy server requires authentication, type the username and password to authenticate with the proxy server and then click **Next**.
8. Click **Next** once you have completed providing the necessary configuration settings.
    :::image type="content" source="media/monitor/log-analytics-mma-setup-laworkspace.png" alt-text="paste Workspace ID and Primary Key":::
9. On the **Ready to Install** page, review your choices and then click **Install**.
10. On the **Configuration completed successfully** page, click **Finish**.

When complete, the **Microsoft Monitoring Agent** appears in **Control Panel**. You can review your configuration and verify that the agent is connected to Log Analytics. When connected, on the **Azure Log Analytics** tab, the agent displays a message stating: **The Microsoft Monitoring Agent has successfully connected to the Microsoft Log Analytics service.**

:::image type="content" source="media/monitor/log-analytics-mma-laworkspace-status.png" alt-text="MMA connection status to Log Analytics":::

To understand the supported configuration, review [supported Windows operating systems](/azure/azure-monitor/platform/log-analytics-agent#supported-windows-operating-systems) and [network firewall configuration](/azure/azure-monitor/platform/log-analytics-agent#network-firewall-requirements).

## Setting up alerts using Windows Admin Center

Once you've attached your server to Azure Monitor, you can use the intelligent hyperlinks within the **Settings > Monitoring and alerts** page to navigate to the Azure portal. In Windows Admin Center, you can easily configure default alerts that will apply to all servers in your Log Analytics workspace. Windows Admin Center automatically enables performance counters to be collected, so you can [create a new alert](/azure/azure-monitor/platform/alerts-log) by customizing one of many pre-defined queries, or write your own.

:::image type="content" source="media/monitor/setup1.gif" alt-text="Configure alerts screenshot":::

These are the alerts and their default conditions that you can opt into:

| Alert Name                | Default Condition                                  |
|---------------------------|----------------------------------------------------|
| CPU utilization           | Over 85% for 10 minutes                            |
| Disk capacity utilization | Over 85% for 10 minutes                            |
| Memory utilization        | Available memory less than 100 MB for 10 minutes   |
| Heartbeat                 | Fewer than 2 beats for 5 minutes                   |
| System critical error     | Any critical alert in the cluster system event log |
| Health service alert      | Any health service fault on the cluster            |

Once you configure the alerts in Windows Admin Center, you can see the alerts in your Log Analytics workspace in Azure.

:::image type="content" source="media/monitor/setup2.gif" alt-text="View alerts screenshot":::

### Collecting event and performance data

Log Analytics can collect events from the Windows event log and performance counters that you specify for longer term analysis and reporting, and take action when a particular condition is detected. Follow these steps to configure collection of events from the Windows event log, and several common performance counters to start with.

1. In the Azure portal, click **More services** found on the lower left-hand corner. In the list of resources, type **Log Analytics**. As you begin typing, the list filters based on your input. Select **Log Analytics**.
2. Select **Advanced settings**.
    :::image type="content" source="media/monitor/log-analytics-advanced-settings-01.png" alt-text="Log Analytics Advanced Settings":::
3. Select **Data**, and then select **Windows Event Logs**.
4. Here, add the Health Service event channel by typing in the name below and the click the plus sign **+**.
   ```
   Event Channel: Microsoft-Windows-Health/Operational
   ```
5. In the table, check the severities **Error** and **Warning**.
6. Click **Save** at the top of the page to save the configuration.
7. Select **Windows Performance Counters** to enable collection of performance counters on a Windows computer.
8. When you first configure Windows Performance counters for a new Log Analytics workspace, you are given the option to quickly create several common counters. They are listed with a checkbox next to each.
    :::image type="content" source="media/monitor/windows-perfcounters-default.png" alt-text="[Default Windows performance counters selected":::
    Click **Add the selected performance counters**.  They are added and preset with a ten second collection sample interval.
9. Click **Save** at the top of the page to save the configuration.

## Create queries and alerts based on log data

If you've made it this far, your cluster should be sending your logs and performance counters to Log Analytics. The next step is to create alert rules that automatically run log searches at regular intervals. If results of the log search match particular criteria, then an alert is fired that sends you an email or text notification. Let's explore this below.

### Create a query

Start by opening the **Log Search** portal.

1. In the Azure portal, click **All services**. In the list of resources, type **Monitor**. As you begin typing, the list filters based on your input. Select **Monitor**.
2. On the **Monitor** navigation menu, select **Log Analytics** and then select a workspace.

The quickest way to retrieve some data to work with is a simple query that returns all records in table. Type the following queries in the search box and click the search button.

```
Event
```

Data is returned in the default list view, and you can see how many total records were returned.

:::image type="content" source="media/monitor/log-analytics-portal-eventlist-01.png" alt-text="Simple query screenshot":::

On the left side of the screen is the filter pane which allows you to add filtering to the query without modifying it directly.  Several record properties are displayed for that record type, and you can select one or more property values to narrow your search results.

Select the checkbox next to **Error** under **EVENTLEVELNAME** or type the following to limit the results to error events.

```
Event | where (EventLevelName == "Error")
```

:::image type="content" source="media/monitor/log-analytics-portal-eventlist-02.png" alt-text="Filter screenshot":::

After you have the appropriate queries made for events you care about, save them for the next step.

### Create alerts
Now, let's walk through an example for creating an alert.

1. In the Azure portal, click **All services**. In the list of resources, type **Log Analytics**. As you begin typing, the list filters based on your input. Select **Log Analytics**.
2. In the left-hand pane, select **Alerts** and then click **New Alert Rule** from the top of the page to create a new alert.
    :::image type="content" source="media/monitor/alert-rule-02.png" alt-text="Create new alert rule screenshot":::
3. For the first step, under the **Create Alert** section, you are going to select your Log Analytics workspace as the resource, since this is a log-based alert signal.  Filter the results by choosing the specific **Subscription** from the drop-down list if you have more than one, which contains Log Analytics workspace created earlier.  Filter the **Resource Type** by selecting **Log Analytics** from the drop-down list.  Finally, select the **Resource** **DefaultLAWorkspace** and then click **Done**.
    :::image type="content" source="media/monitor/alert-rule-03.png" alt-text="Create new alert rule step 1 screenshot":::
4. Under the section **Alert Criteria**, click **Add Criteria** to select your saved query and then specify logic that the alert rule follows.
5. Configure the alert with the following information:
   a. From the **Based on** drop-down list, select **Metric measurement**.  A metric measurement will create an alert for each object in the query with a value that exceeds our specified threshold.
   b. For the **Condition**, select **Greater than** and specify a threshold.
   c. Then define when to trigger the alert. For example you could select **Consecutive breaches** and from the drop-down list select **Greater than** a value of 3.
   d. Under Evaluation based on section, modify the **Period** value to **30** minutes and **Frequency** to 5. The rule will run every five minutes and return records that were created within the last thirty minutes from the current time.  Setting the time period to a wider window accounts for the potential of data latency, and ensures the query returns data to avoid a false negative where the alert never fires.
6. Click **Done** to complete the alert rule.
    :::image type="content" source="media/monitor/alert-signal-logic-02.png" alt-text="Configure alert signal screenshot":::
7. Now moving onto the second step, provide a name of your alert in the **Alert rule name** field, such as **Alert on all Error Events**.  Specify a **Description** detailing specifics for the alert, and select **Critical(Sev 0)** for the **Severity** value from the options provided.
8. To immediately activate the alert rule on creation, accept the default value for **Enable rule upon creation**.
9. For the third and final step, you specify an **Action Group**, which ensures that the same actions are taken each time an alert is triggered and can be used for each rule you define. Configure a new action group with the following information:
   a. Select **New action group** and the **Add action group** pane appears.
   b. For **Action group name**, specify a name such as **IT Operations - Notify** and a **Short name** such as **itops-n**.
   c. Verify the default values for **Subscription** and **Resource group** are correct. If not, select the correct one from the drop-down list.
   d. Under the Actions section, specify a name for the action, such as **Send Email** and under **Action Type** select **Email/SMS/Push/Voice** from the drop-down list. The **Email/SMS/Push/Voice** properties pane will open to the right in order to provide additional information.
   e. On the **Email/SMS/Push/Voice** pane, select and setup your preference. For example, enable **Email** and provide a valid email SMTP address to deliver the message to.
   f. Click **OK** to save your changes.<br><br>

    :::image type="content" source="media/monitor/action-group-properties-01.png" alt-text="Create new action group screenshot":::

10. Click **OK** to complete the action group.
11. Click **Create alert rule** to complete the alert rule. It starts running immediately.
    :::image type="content" source="media/monitor/alert-rule-01.png" alt-text="Complete creating new alert rule screenshot":::

### Example alert

For reference, this is what an example alert looks like in Azure.

:::image type="content" source="media/monitor/alert.gif" alt-text="Azure alert screenshot":::

Below is an example of the email that you will be sent by Azure Monitor:

:::image type="content" source="media/monitor/warning.png" alt-text="Alert email example screenshot":::

## Create custom Kusto queries in Log Analytics

You can also [write custom log queries](/azure/azure-monitor/log-query/get-started-queries) in Azure Monitor using the Kusto query language to collect data from one or more virtual machines.

## Get a consolidated view across multiple servers

If you onboard multiple servers to a single Log Analytics workspace within Azure Monitor, you can get a consolidated view of all these servers from the [Virtual Machines insights](/azure/azure-monitor/insights/vminsights-overview) solution within Azure Monitor. (Note that only the Performance and Maps tabs of Virtual Machines Insights for Azure Monitor will work with on-premises servers – the health tab functions only with Azure VMs.) To view this in the Azure portal, go to **Azure Monitor > Virtual Machines** (under Insights), and navigate to the **Performance** or **Maps** tabs.

## Visualize connected services

When Windows Admin Center onboards a server into the Virtual Machine insights solution within Azure Monitor, it also lights up a capability called [Service Map](/azure/azure-monitor/insights/service-map). This capability automatically discovers application components and maps the communication between services so that you can easily visualize connections between servers with great detail from the Azure portal. You can find this by going to the Azure portal and selecting **Azure Monitor > Virtual Machines** (under Insights), and navigating to the **Maps** tab.

> [!NOTE]
> The visualizations for Virtual Machine insights for Azure Monitor are offered in six public regions currently.  For the latest information, check the [Azure Monitor for VMs documentation](/azure/azure-monitor/insights/vminsights-onboard#log-analytics). You must deploy the Log Analytics workspace in one of the supported regions to get the additional benefits provided by the Virtual Machine insights solution described above.

## Disabling monitoring

To completely disconnect your server from the Log Analytics workspace, uninstall the MMA. This means that this server will no longer send data to the workspace, and all the solutions installed in that workspace will no longer collect and process data from that server. However, this does not affect the workspace itself; all the resources reporting to that workspace will continue to do so. To uninstall the MMA agent within Windows Admin Center, connect to the server and then go to **Installed apps**, find the Microsoft Monitoring Agent, and then select **Remove**.

If you want to turn off a specific solution within a workspace, you will need to [remove the monitoring solution from the Azure portal](/azure/azure-monitor/insights/solutions#remove-a-management-solution). Removing a monitoring solution means that the insights created by that solution will no longer be generated for _any_ of the servers reporting to that workspace. For example, if you uninstall the Azure Monitor for VMs solution, you will no longer see insights about VM or server performance from any of the machines connected to your workspace.

## Next steps

For related topics, see also:

- [Learn more about Azure integration with Windows Admin Center](/windows-server/manage/windows-admin-center/azure/)
- [Use Azure Monitor to send emails for Health Service Faults](/windows-server/storage/storage-spaces/configure-azure-monitor)
