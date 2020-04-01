---
title: Monitor Azure Stack HCI with Azure Monitor
description: Monitor servers and configure alerts with Azure Monitor from Windows Admin Center.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 04/01/2020
---

# Monitor Azure Stack HCI with Azure Monitor

> Applies to: Windows Server 2019

[Azure Monitor](/azure/azure-monitor/overview) collects, analyzes, and acts on telemetry from a variety of resources, including Windows Servers and VMs, both on-premises and in the cloud. Though Azure Monitor pulls data from Azure VMs and other Azure resources, this article focuses on how Azure Monitor works with on-premises servers and VMs running on Azure Stack HCI, specifically with Windows Admin Center.

## How does Azure Monitor work?
:::image type="content" source="media/monitor/azure-monitor-diagram.png" alt-text="diagram of how Azure Monitor works":::
Data generated from on-premises Windows Servers is collected in a Log Analytics workspace in Azure Monitor. Within a workspace, you can enable various monitoring solutions—sets of logic that provide insights for a particular scenario. For example, Azure Update Management, Azure Security Center, and Azure Monitor for VMs are all monitoring solutions that can be enabled within a workspace.

When you enable a monitoring solution in a Log Analytics workspace, all the servers reporting to that workspace will start collecting data relevant to that solution, so that the solution can generate insights for all the servers in the workspace.

To collect telemetry data on an on-premises server and push it to the Log Analytics workspace, Azure Monitor requires the installation of the Microsoft Monitoring Agent, or the MMA. Certain monitoring solutions also require a secondary agent. For example, Azure Monitor for VMs also depends on a ServiceMap agent for additional functionality that this solution provides.

Some solutions, like Azure Update Management, also depend on Azure Automation, which enables you to centrally manage resources across Azure and non-Azure environments. For example, Azure Update Management uses Azure Automation to schedule and orchestrate installation of updates across machines in your environment, centrally, from the Azure portal.

## What data does Azure Monitor collect?

All data collected by Azure Monitor fits into one of two fundamental types: metrics and logs.

1. [Metrics](/azure/azure-monitor/platform/data-platform#metrics) are numerical values that describe some aspect of a system at a particular point in time. They are lightweight and capable of supporting near real-time scenarios. You'll see data collected by Azure Monitor right in their Overview page in the Azure portal.

:::image type="content" source="media/monitor/metrics.png" alt-text="image of metrics ingesting in metrics explorer":::

2. [Logs](/azure/azure-monitor/platform/data-platform#logs) contain different kinds of data organized into records with different sets of properties for each type. Telemetry such as events and traces are stored as logs in addition to performance data so that it can all be combined for analysis. Log data collected by Azure Monitor can be analyzed with [queries](/azure/azure-monitor/log-query/log-query-overview) to quickly retrieve, consolidate, and analyze collected data. You can create and test queries using [Log Analytics](/azure/azure-monitor/log-query/portals) in the Azure portal and then either directly analyze the data using these tools or save queries for use with [visualizations](/azure/azure-monitor/visualizations) or [alert rules](/azure/azure-monitor/platform/alerts-overview).

:::image type="content" source="media/monitor/logs.png" alt-text="image of logs ingesting in log analytics":::

## How does Windows Admin Center enable you to use Azure Monitor?

From within Windows Admin Center, you can enable two monitoring solutions:

- [Azure Update Management](/windows-server/manage/windows-admin-center/azure/azure-update-management) (in the Updates tool)
- Azure Monitor for VMs (in server Settings), a.k.a Virtual Machines insights

You can get started using Azure Monitor from either of these tools. If you've never used Azure Monitor before, Windows Admin Center will automatically provision a Log Analytics workspace (and Azure Automation account, if needed), and install and configure the Microsoft Monitoring Agent (MMA) on the target server. It will then install the corresponding solution into the workspace.

For instance, if you first go to the Updates tool to setup Azure Update Management, Windows Admin Center will:

1. Install the MMA on the machine
2. Create the Log Analytics workspace and the Azure Automation account (since an Azure Automation account is necessary in this case)
3. Install the Update Management solution in the newly created workspace.

If you want to add another monitoring solution from within Windows Admin Center on the same server, Windows Admin Center will simply install that solution into the existing workspace to which that server is connected. Windows Admin Center will additionally install any other necessary agents.

If you connect to a different server, but have already setup a Log Analytics workspace (either through Windows Admin Center or manually in the Azure Portal), you can also install the MMA agent on the server and connect it up to an existing workspace. When you connect a server into a workspace, it automatically starts collecting data and reporting to solutions installed in that workspace.

## Azure Monitor for virtual machines (a.k.a. Virtual Machine insights)

When you set up Azure Monitor for VMs in server Settings, Windows Admin Center enables the Azure Monitor for VMs solution, also known as Virtual Machine insights. This solution allows you to monitor server health and events, create email alerts, get a consolidated view of server performance across your environment, and visualize apps, systems, and services connected to a given server.

> [!NOTE]
> Despite its name, VM insights works for physical servers as well as virtual machines.

With Azure Monitor's free 5 GB of data/month/customer allowance, you can easily try this out for a server or two without worry of getting charged. Read on to see additional benefits of onboarding servers into Azure Monitor, such as getting a consolidated view of systems performance across the servers in your environment.

## Disabling Monitoring

To completely disconnect your server from the Log Analytics workspace, uninstall the MMA agent. This means that this server will no longer send data to the workspace, and all the solutions installed in that workspace will no longer collect and process data from that server. However, this does not affect the workspace itself – all the resources reporting to that workspace will continue to do so. To uninstall the MMA agent within WAC, go to Apps & Features, find the Microsoft Monitoring Agent, and click Uninstall.

If you want to turn off a specific solution within a workspace, you will need to [remove the monitoring solution from the Azure portal](/azure/azure-monitor/insights/solutions#remove-a-management-solution). Removing a monitoring solution means that the insights created by that solution will no longer be generated for _any_ of the servers reporting to that workspace. For example, if I uninstall the Azure Monitor for VMs solution, I will no longer see insights about VM or server performance from any of the machines connected to my workspace.

## Next steps

For related topics, see also:

- [Learn more about Azure integration with Windows Admin Center](/windows-server/manage/windows-admin-center/azure/)
- [Use Azure Monitor to send emails for Health Service Faults](/windows-server/storage/storage-spaces/configure-azure-monitor)
