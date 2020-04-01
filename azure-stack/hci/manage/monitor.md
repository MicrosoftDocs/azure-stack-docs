---
title: Monitor Azure Stack HCI with Azure Monitor
description: Monitor servers and configure alerts with Azure Monitor from Windows Admin Center.
author: khdownie
ms.author: v-kedow
ms.topic: article
ms.date: 04/01/2020
---

# Monitor servers and configure alerts with Azure Monitor from Windows Admin Center

> Applies to: Windows Server 2019

[Azure Monitor](/azure/azure-monitor/overview) is a solution that collects, analyzes, and acts on telemetry from a variety of resources, including Windows Servers and VMs, both on-premises and in the cloud. Though Azure Monitor pulls data from Azure VMs, and other Azure resources, this article focuses on how Azure Monitor works with on-premises servers and VMs, specifically with Windows Admin Center.

## How does Azure Monitor work?
:::image type="content" source="media/monitor/azure-monitor-diagram.png" alt-text="How Azure Monitor Works Screenshot":::
Data generated from on-premises Windows Servers is collected in a Log Analytics workspace in Azure Monitor. Within a workspace, you can enable various monitoring solutions—sets of logic that provide insights for a particular scenario. For example, Azure Update Management, Azure Security Center, and Azure Monitor for VMs are all monitoring solutions that can be enabled within a workspace.

When you enable a monitoring solution in a Log Analytics workspace, all the servers reporting to that workspace will start collecting data relevant to that solution, so that the solution can generate insights for all the servers in the workspace.

To collect telemetry data on an on-premises server and push it to the Log Analytics workspace, Azure Monitor requires the installation of the Microsoft Monitoring Agent, or the MMA. Certain monitoring solutions also require a secondary agent. For example, Azure Monitor for VMs also depends on a ServiceMap agent for additional functionality that this solution provides.

Some solutions, like Azure Update Management, also depend on Azure Automation, which enables you to centrally manage resources across Azure and non-Azure environments. For example, Azure Update Management uses Azure Automation to schedule and orchestrate installation of updates across machines in your environment, centrally, from the Azure portal.

## How does Windows Admin Center enable you to use Azure Monitor?

From within WAC, you can enable two monitoring solutions:

- [Azure Update Management](azure-update-management.md) (in the Updates tool)
- Azure Monitor for VMs (in server Settings), a.k.a Virtual Machines insights

You can get started using Azure Monitor from either of these tools. If you've never used Azure Monitor before, WAC will automatically provision a Log Analytics workspace (and Azure Automation account, if needed), and install and configure the Microsoft Monitoring Agent (MMA) on the target server. It will then install the corresponding solution into the workspace. 

For instance, if you first go to the Updates tool to setup Azure Update Management, WAC will:

1. Install the MMA on the machine
2. Create the Log Analytics workspace and the Azure Automation account (since an Azure Automation account is necessary in this case)
3. Install the Update Management solution in the newly created workspace.

If you want to add another monitoring solution from within WAC on the same server, WAC will simply install that solution into the existing workspace to which that server is connected. WAC will additionally install any other necessary agents.

If you connect to a different server, but have already setup a Log Analytics workspace (either through WAC or manually in the Azure Portal), you can also install the MMA agent on the server and connect it up to an existing workspace. When you connect a server into a workspace, it automatically starts collecting data and reporting to solutions installed in that workspace.

## Azure Monitor for virtual machines (a.k.a. Virtual Machine insights)
>Applies To: Windows Admin Center Preview

When you set up Azure Monitor for VMs in server Settings, Windows Admin Center enables the Azure Monitor for VMs solution, also known as Virtual Machine insights. This solution allows you to monitor server health and events, create email alerts, get a consolidated view of server performance across your environment, and visualize apps, systems, and services connected to a given server.

> [!NOTE]
> Despite its name, VM insights works for physical servers as well as virtual machines.

With Azure Monitor's free 5 GB of data/month/customer allowance, you can easily try this out for a server or two without worry of getting charged. Read on to see additional benefits of onboarding servers into Azure Monitor, such as getting a consolidated view of systems performance across the servers in your environment.

## Next steps

For related topics, see also:

- [Learn more about Azure integration with Windows Admin Center](/windows-server/manage/windows-admin-center/azure/)
- [Use Azure Monitor to send emails for Health Service Faults](/windows-server/storage/storage-spaces/configure-azure-monitor)
