---
title: Compare management capabilities of Azure Local VMs
description: Learn about the kinds of virtual machines (VMs) that can run on Azure Local and compare their management capabilities.
ms.topic: conceptual
author: ManikaDhiman
ms.author: v-manidhiman
ms.date: 02/04/2025
---

# Compare management capabilities of Azure Local VMs

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the types of virtual machines (VMs) available on Azure Local and compares their management capabilities in Azure.

## Types of VMs on Azure Local

Here are the different types of VMs that you can run on your Azure Local system:

- **Arc VMs:** Windows and Linux VMs hosted outside of Azure, on your corporate network, running on Azure Local.
  - Are created using [Arc VM provisioning flow](../manage/create-arc-virtual-machines.md?tabs=azureportal), registered to [Arc Resource Bridge](/azure/azure-arc/resource-bridge/overview), and have the [Connected Machine agent](/azure/azure-arc/servers/agent-overview) installed.
  - Offer extensive management capabilities in the Azure portal, second only to native Azure VMs.
  - Through Arc Resource Bridge, Arc VMs provide lifecycle management capabilities like starting, stopping, changing VM memory/vCPU, and adding or removing data disk and network interfaces.
  - Through the Connected Machine agent, Arc VMs leverage Azure Arc extensions such as Microsoft Defender for Cloud and Azure Monitor to govern, protect, configure, and monitor virtual machines.
  - Can be managed through Azure.

- **[Arc-enabled servers](/azure/azure-arc/servers/overview):** Windows and Linux physical servers and virtual machines hosted outside of Azure, on your corporate network, or on other cloud providers with the Connected Machine agent installed.
  - Arc-enabled servers run on Azure Local as virtual machines.
  - Lack the lifecycle management capabilities that Arc VMs offer.
  - Through the Connected Machine agent, Arc-enabled servers leverage Azure Arc extensions such as Microsoft Defender for Cloud and Azure Monitor to govern, protect, configure, and monitor virtual machines.
  - Can be managed through Azure.

- **Non-Arc VMs:** Windows and Linux VMs created and hosted outside of Azure, on your corporate network, running on Azure Local.
  - Aren't connected to Azure.
  - Can't be managed through Azure.

The following table compares the provisioning and management methods for the various types of Azure Local VM:

| VM provisioning and management methods | Arc VMs | Arc-enabled servers | Non-Arc VMs |
| :---- | :---- | :---- | :---- |
| Provisioning method |  [Arc VM provisioning flow](../manage/create-arc-virtual-machines.md?tabs=azureportal). Create Arc VMs using Azure CLI, Azure portal, or Azure Resource Manager template. Using ARM templates, you can also automate VM provisioning in a secure cloud environment. <br><br> [Azure Migrate flow](../migrate/migration-azure-migrate-overview.md). Migrate existing VMware and Hyper-V VMs as Arc VMs to Azure Local using the migration flow. | Connect these machines to Azure by [deploying the Connected Machine agent](/azure/azure-arc/servers/deployment-options) | On-premises provisioning flow. Use local tools like Failover Cluster Manager available in your on-premises environment, or use [Windows Admin Center](../manage/vm.md#create-a-new-vm), [System Center Virtual Machine Manager (SCVMM)](/system-center/vmm/provision-vms), or [PowerShell](../manage/vm-powershell.md#create-a-vm).|
| Management method | Via Azure. | Via Azure. See [Management and monitoring for Azure Arc-enabled servers](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-management-and-monitoring-arc-server). | Via the local tools. Manage these VMs through the management consoles of the same local tools used for their creation. |

> [!NOTE]
> Currently, conversion of an Arc-enabled server or non-Arc VM to an Arc VM isn't supported.

## Compare VM management capabilities

The following table compares the management capabilities for Arc VMs, Arc-enabled servers, and non-Arc VMs across various operations and features available through the Azure portal:

|Azure VM Management capability|Arc VMs|Arc-enabled servers|Non-Arc VMs|
|:-----|:-----:|:-----:|:-----:|
| **Settings** |
| - Start|✅|❌|❌|
| - Restart |✅|❌|❌|
| - Stop |✅|❌|❌|
| - Delete |✅|✅|❌|
| - Save State (CLI) |✅|❌|❌|
| - Pause (CLI) |✅|❌|❌|
| - GPU configuration (CLI) |✅|❌|❌|
| - Add network interface |✅|❌|❌|
| - Connect with SSH |✅|✅|❌|
| - Add a new data disk |✅|❌|❌|
| - Change vCPU count |✅|❌|❌|
| - Change Memory amount |✅|❌|❌|
| - Change Min memory |✅|❌|❌|
| - Change Max memory |✅|❌|❌|
| **Operations** |
| - Microsoft Defender for Cloud |✅|✅|❌|
| - Security recommendations |✅|✅|❌|
| - Extension Support |✅|✅|❌|
| - Locks |✅|✅|❌|
| - Policies (RBAC, compliance) |✅|✅|❌|
| - Machine Configuration |✅|✅|❌|
| - Automanage |✅|❌|❌|
| - Run command |✅|✅|❌|
| - SQL Server Configuration |✅|✅|❌|
| - Azure Update Manager | ✅ <br>[^3] | ✅ <br>[^1][^2] | ❌ |
| - Inventory |✅|✅ <br>[^1][^2] |❌|
| - Change tracking |✅|✅ <br>[^1][^2] |❌|
| - Extended Security Updates | ✅ <br>[^3] | ✅ <br>[^3] | ❌ |
| **Windows management** |
| - Windows Admin Center |❌|✅ <br>[^1][^2] |❌|
| - Best Practices Assessment |✅|✅ <br>[^1][^2] |❌|
| **Monitoring** |
| - Azure Monitor |✅|✅|❌|
| - Insights|✅|✅|❌|
| - Logs |✅|✅|❌|
| - Alerts |✅|❌|❌|
| - Metrics |✅|❌|❌|
| - Workbooks |❌|✅|❌|
| **Automation** |
| - CLI/PS |✅|✅|❌|
| - Tasks |✅|✅|❌|
| - Export template |✅|❌|❌|
| - Resource health |❌ <br>(Use Alerts) |✅|❌|

[^1]: at addtional costs
[^2]: included, as part of Windows Server and SQL Server management capabilities enable by Azure Arc and parent [Azure Hybrid Benefits for Windows Server](WindowsServerDocs/get-started/azure-hybrid-benefit.md). The Microsoft Product Terms for your program take precedent over this article. For more information, see [Microsoft Azure Product Terms](https://www.microsoft.com/licensing/terms/productoffering/MicrosoftAzure) and select your program to show the terms.
[^3]: included, for VMs running on Azure and Azure Local instances.

## Next steps

- Review [Azure Arc VM management prerequisites](../manage/azure-arc-vm-management-prerequisites.md).
