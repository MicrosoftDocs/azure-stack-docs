---
title: VM update and management automation in Azure Stack Hub | Microsoft Docs
description: Learn how to use the Azure Monitor for VMs, Update Management, Change Tracking, and Inventory solutions in Azure Automation to manage Windows and Linux VMs deployed in Azure Stack Hub. 
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.assetid: 
ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 11/11/2019
ms.author: mabrigg
ms.reviewer: rtiberiu
ms.lastreviewed: 11/11/2019
---

# VM update and management automation in Azure Stack Hub
Use the following Azure Automation solution features to manage Windows and Linux virtual machines (VMs) that are deployed using Azure Stack Hub:

- **[Update Management](https://docs.microsoft.com/azure/automation/automation-update-management)**: With the Update Management solution, you can quickly assess the status of available updates on all agent computers and manage the process of installing required updates for Windows and Linux VMs.

- **[Change Tracking](https://docs.microsoft.com/azure/automation/automation-change-tracking)**: Changes to installed software, Windows services, Windows registry and files, and Linux daemons on the monitored servers are sent to the Azure Monitor service in the cloud for processing. Logic is applied to the received data and the cloud service records the data. By using the information on the Change Tracking dashboard, you can easily see the changes that were made to your server infrastructure.

- **[Inventory](https://docs.microsoft.com/azure/automation/automation-vm-inventory)**. The Inventory tracking for an Azure Stack Hub VM provides a browser-based user interface for setting up and configuring inventory collection.

- **[Azure Monitor for VMs](https://docs.microsoft.com/azure/azure-monitor/insights/vminsights-overview)**: Azure Monitor for VMs monitors your Azure and Azure Stack Hub VMs and virtual machine scale sets at scale. It analyzes the performance and health of your Windows and Linux VMs and also monitors their processes and dependencies on other resources and external processes.

> [!IMPORTANT]
> These solutions are the same as the ones used to manage Azure VMs. Both Azure and Azure Stack Hub VMs are managed in the same way, from the same interface, using the same tools. The Azure Stack Hub VMs are also priced the same as Azure VMs when using the Update Management, Change Tracking, Inventory, and Azure Monitor for VMs solutions with Azure Stack Hub.

## Prerequisites
Several prerequisites must be met before using these features to update and manage Azure Stack Hub VMs. These include steps that must be taken in the Azure portal and also the Azure Stack Hub administration portal.

### In the Azure portal
To use the Azure Monitor for VMs, Inventory, Change Tracking, and Update Management Azure Automation features for Azure Stack Hub VMs, you first need to enable these solutions in Azure.

> [!TIP]
> If you've already enabled these features for Azure VMs, you can use your pre-existing LogAnalytics Workspace credentials. If you already have a LogAnalytics WorkspaceID and Primary Key that you want to use, skip ahead to [the next section](./vm-update-management.md#in-the-azure-stack-hub-administrator-portal). Otherwise, continue in this section to create a new LogAnalytics Workspace and automation account.

The first step in enabling these solutions is to [create a LogAnalytics Workspace](https://docs.microsoft.com/azure/log-analytics/log-analytics-quick-create-workspace) in your Azure subscription. A Log Analytics workspace is a unique Azure Monitor logs environment with its own data repository, data sources, and solutions. After you've created a workspace, note the WorkspaceID and Key. To view this information, go to the workspace blade, click on **Advanced settings**, and review the **Workspace ID** and **Primary Key** values. 

Next, you must [create an Automation account](https://docs.microsoft.com/azure/automation/automation-create-standalone-account). An Automation account is a container for your Azure Automation resources. It provides a way to separate your environments or further organize your Automation workflows and resources. Once the Automation account is created, you need to enable the Inventory, Change Tracking, and Update Management features. To enable each feature, follow these steps:

1. In the Azure portal, go to the Automation Account that you want to use.

2. Select the solution to enable (either **Inventory**, **Change tracking**, or **Update management**).

3. Use the **Select Workspace...** drop-down list to select the Log Analytics workspace to use.

4. Verify that all remaining information is correct, and then click **Enable** to enable the solution.

5. Repeat steps 2-4 to enable all three solutions. 

   [![](media/vm-update-management/1-sm.PNG "Enable Azure Automation account features")](media/vm-update-management/1-lg.PNG#lightbox)

### Enable Azure Monitor for VMs

Azure Monitor for VMs monitors your Azure VMs and virtual machine scale sets at scale. It analyzes the performance and health of your Windows and Linux VMs and also monitors their processes and dependencies on other resources and external processes.

As a solution, Azure Monitor for VMs includes support for monitoring performance and app dependencies for VMs that are hosted on-premises or in another cloud provider. Three key features deliver in-depth insight:

1. Logical components of Azure VMs that run Windows and Linux that are measured against pre-configured health criteria, and they alert you when the evaluated condition is met.

2. Pre-defined trending performance charts that display core performance metrics from the guest VM operating system.

3. Dependency map that displays the interconnected components with the VM from various resource groups and subscriptions.

After the Log Analytics Workspace is created, enable the performance counters in the workspace for collection on Linux and Windows VMs. Then, install and enable the ServiceMap and InfrastructureInsights solution in your workspace. The process is described in the [Deploy Azure Monitor for VMs](https://docs.microsoft.com/azure/azure-monitor/insights/vminsights-onboard#how-to-enable-azure-monitor-for-vms-preview) guide.

### In the Azure Stack Hub administrator portal
After enabling the Azure Automation solutions in the Azure portal, you next need to sign in to the Azure Stack Hub administrator portal as a cloud admin and download the **Azure Monitor, Update and Configuration Management** and the **Azure Monitor, Update and Configuration Management for Linux** extension in the Azure Stack Hub Marketplace.

   ![Azure Monitor, update and configuration management extension marketplace item](media/vm-update-management/2.PNG) 

To enable the Azure Monitor for VMs Map solution and gain insights into the networking dependencies, download the **Azure Monitor Dependency Agent**:

   ![Azure Monitor Dependency Agent](media/vm-update-management/2-dependency.PNG) 

## Enable Update Management for Azure Stack Hub VMs
Follow these steps to enable update management for Azure Stack Hub VMs.

1. Sign in to the Azure Stack Hub user portal.

2. In the Azure Stack Hub user-portal, go to the Extensions blade of the VMs for which you want to enable these solutions, click **+ Add**, select the **Azure Update and Configuration Management** extension, and then click **Create**:

   [![](media/vm-update-management/3-sm.PNG "VM extension blade")](media/vm-update-management/3-lg.PNG#lightbox)

3. Provide the previously created WorkspaceID and Primary Key to link the agent with the LogAnalytics workspace. Then click **OK** to deploy the extension.

   [![](media/vm-update-management/4-sm.PNG "Providing the WorkspaceID and Key")](media/vm-update-management/4-lg.PNG#lightbox) 

4. As described in the [Update Management documentation](https://docs.microsoft.com/azure/automation/automation-update-management), you need to enable the Update Management solution for each VM that you want to manage. To enable the solution for all VMs reporting to the workspace, select **Update management**, click **Manage machines**, and then select the **Enable on all available and future machines** option.

   [![](media/vm-update-management/5-sm.PNG "Enable Update Management solution on all machines")](media/vm-update-management/5-lg.PNG#lightbox) 

   > [!TIP]
   > Repeat this step to enable each solution for the Azure Stack Hub VMs that report to the workspace. 
  
After the Azure Update and Configuration Management extension is enabled, a scan is done twice per day for each managed VM. The API is called every 15 minutes to query for the last update time to determine whether the status has changed. If the status has changed, a compliance scan is started.

After the VMs are scanned, they'll appear in the Azure Automation account in the Update Management solution: 

   [![](media/vm-update-management/6-sm.PNG "Azure Automation account in Update Management")](media/vm-update-management/6-lg.PNG#lightbox) 

> [!IMPORTANT]
> It can take between 30 minutes and 6 hours for the dashboard to display updated data from managed computers.

The Azure Stack Hub VMs can now be included in scheduled update deployments together with Azure VMs.

## Enable Azure Monitor for VMs running on Azure Stack Hub
Once the VM has the **Azure Monitor, Update and Configuration Management**, and the **Azure Monitor Dependency Agent** extensions installed, it will start reporting data in the [Azure Monitor for VMs](https://docs.microsoft.com/azure/azure-monitor/insights/vminsights-overview) solution. 

> [!TIP]
> The **Azure Monitor Dependency Agent** extension doesn't require any parameters. The Azure Monitor for VMs Map Dependency agent doesn't transmit any data itself, and it doesn't require any changes to firewalls or ports. The Map data is always transmitted by the Log Analytics agent to the Azure Monitor service, either directly or through the [OMS Gateway](https://docs.microsoft.com/azure/azure-monitor/platform/gateway) if your IT security policies don't allow computers on the network to connect to the internet.

Azure Monitor for VMs includes a set of performance charts that target several key performance indicators (KPIs) to help you determine how well a VM is performing. The charts show resource use over a period of time so you can identify bottlenecks and anomalies. You can also switch to a perspective listing each machine to view resource use based on the metric selected. While there are many elements to consider when dealing with performance, Azure Monitor for VMs monitors key operating system performance indicators related to processor, memory, network adapter, and disk use. Performance charts complement the health monitoring feature and help expose issues that indicate a possible system component failure. Azure Monitor for VMs also supports capacity planning and tuning and optimization to achieve efficiency.

   ![Azure Monitor VMs Performance tab](https://docs.microsoft.com/azure/azure-monitor/insights/media/vminsights-performance/vminsights-performance-aggview-01.png)

Viewing the discovered app components on Windows and Linux VMs running in Azure Stack Hub can be observed in two ways with Azure Monitor for VMs. The first is from a VM directly and the second is across groups of VMs from Azure Monitor.
The [Using Azure Monitor for VMs Map to understand app components](https://docs.microsoft.com/azure/azure-monitor/insights/vminsights-maps) article will help you understand the experience between the two perspectives and how to use the Map feature.

   ![Azure Monitor VMs Map tab](https://docs.microsoft.com/azure/azure-monitor/insights/media/vminsights-maps/map-multivm-azure-monitor-01.png)

In case [Azure Monitor for VMs](https://docs.microsoft.com/azure/azure-monitor/insights/vminsights-overview) is not showing you any performance data, you have to enable the collection of performance data for Windows and Linux in your [LogAnalytics Workspace](https://docs.microsoft.com/azure/azure-monitor/platform/data-sources-performance-counters) Advanced Settings.

## Enable Update Management using a Resource Manager template
If you have a large number of Azure Stack Hub VMs, you can use [this Azure Resource Manager template](https://aka.ms/aa6zdzy) to more easily deploy the solution on VMs. The template deploys the Microsoft Monitoring Agent extension to an existing Azure Stack Hub VM and adds it to an existing Azure LogAnalytics workspace.
 
## Next steps
[Optimize SQL Server VM performance](azure-stack-sql-server-vm-considerations.md)
