---
title: Compare Management Capabilities of VMs on Azure Local
description: Learn about the kinds of virtual machines (VMs) that can run on Azure Local and compare their management capabilities.
ms.topic: conceptual
author: alkohli
ms.author: alkohli
ms.date: 03/18/2025
---

# Compare management capabilities of VMs on Azure Local

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the types of virtual machines (VMs) available on Azure Local. It also compares their management capabilities in Azure.

## Types of VMs on Azure Local

You can run these types of VMs on your Azure Local system:

- **Azure Local VMs enabled by Azure Arc**: Windows and Linux VMs hosted outside Azure, on your corporate network, running on Azure Local. These types of VMs:
  - Are created through the [Azure Local VM provisioning flow](../manage/create-arc-virtual-machines.md?tabs=azureportal), are registered to an [Azure Arc resource bridge](/azure/azure-arc/resource-bridge/overview), and have the [Azure Connected Machine agent](/azure/azure-arc/servers/agent-overview) installed.
  - Offer extensive management capabilities in the Azure portal, second only to native Azure VMs.
  - Through an Azure Arc resource bridge, provide life-cycle management capabilities like starting, stopping, changing VM memory or vCPU, and adding or removing data disk and network interfaces.
  - Through the Azure Connected Machine agent, use Azure Arc extensions such as Microsoft Defender for Cloud and Azure Monitor to govern, protect, configure, and monitor virtual machines.
  - Can be managed through Azure.

- [Azure Arc-enabled servers](/azure/azure-arc/servers/overview): Windows and Linux physical servers and VMs hosted outside Azure, on your corporate network, or on other cloud providers with the Azure Connected Machine agent installed. These types of VMs:
  - Run on Azure Local as virtual machines.
  - Lack the life-cycle management capabilities that Azure Local VMs offer.
  - Through the Azure Connected Machine agent, use Azure Arc extensions such as Microsoft Defender for Cloud and Azure Monitor to govern, protect, configure, and monitor virtual machines.
  - Can be managed through Azure.

- **Unmanaged VMs**: Windows and Linux VMs created and hosted outside Azure, on your corporate network, running on Azure Local. These types of VMs:
  - Aren't connected to Azure.
  - Can't be managed through Azure.

The following table compares the provisioning and management methods for the various types of VMs running on Azure Local:

| Method | Azure Local VMs enabled by Azure Arc | Azure Arc-enabled servers | Unmanaged VMs |
| :---- | :---- | :---- | :---- |
| Provisioning |  [Azure Local VM provisioning flow](../manage/create-arc-virtual-machines.md?tabs=azureportal). Create Azure Local VMs by using the Azure CLI, the Azure portal, or an Azure Resource Manager template (ARM template). By using ARM templates, you can also automate VM provisioning in a secure cloud environment. <br><br> [Azure Migrate flow](../migrate/migration-azure-migrate-overview.md). Migrate existing VMware and Hyper-V VMs to Azure Local by using the migration flow. | Connect these machines to Azure by [deploying the Azure Connected Machine agent](/azure/azure-arc/servers/deployment-options). | On-premises provisioning flow. Use local tools like Failover Cluster Manager available in your on-premises environment Or use [Windows Admin Center](../manage/vm.md#create-a-new-vm), [System Center Virtual Machine Manager](/system-center/vmm/provision-vms), or [PowerShell](../manage/vm-powershell.md#create-a-vm).|
| Management | [Via Azure](../manage/manage-arc-virtual-machines.md). | Via Azure. See [Management and monitoring for Azure Arc-enabled servers](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-management-and-monitoring-arc-server). | Via the local tools. Manage these VMs through the management consoles of the same local tools that you used for their creation. |

> [!NOTE]
> Currently, conversion of an Azure Arc-enabled server or an unmanaged VM to an Azure Local VM isn't supported.

## Comparison of VM management capabilities

The following table compares the management capabilities for Azure Local VMs, Azure Arc-enabled servers, and unmanaged VMs across various operations and features available through the Azure portal.

Keep in mind the following information when you're comparing VM management capabilities:

- Azure product terms for your program override this section. For more information, see [Understand, choose, and manage your Microsoft licenses](https://www.microsoft.com/licensing/#products) and select your program.
- Some services, even if they're included in Azure Hybrid Benefit, might incur operational costs for activities like storing log data. For more information, see the [Azure pricing calculator](https://azure.microsoft.com/pricing/calculator/).
- Some key features are part of the experience of Windows Server Management enabled by Azure Arc. For more information, see [Windows Server Management enabled by Azure Arc](/azure/azure-arc/servers/windows-server-management-overview?tabs=portal).

|Azure VM management capability|Azure Local VMs enabled by Azure Arc | Azure Arc-enabled servers | Unmanaged VMs |
|:-----|:-----:|:-----:|:-----:|
| **Setting** |
| Start|✅|❌|❌|
| Restart |✅|❌|❌|
| Stop |✅|❌|❌|
| Delete |✅|✅|❌|
| Save state (CLI) |✅|❌|❌|
| Pause (CLI) |✅|❌|❌|
| GPU configuration (CLI) |✅|❌|❌|
| Add network interface |✅|❌|❌|
| Connect with SSH |✅|✅|❌|
| Add new data disk |✅|❌|❌|
| Change vCPU count |✅|❌|❌|
| Change memory amount |✅|❌|❌|
| Change minimum memory |✅|❌|❌|
| Change maximum memory |✅|❌|❌|
| **Operation** |
| Microsoft Defender for Cloud |✅|✅|❌|
| Security recommendations |✅|✅|❌|
| Extension support |✅|✅|❌|
| Locks |✅|✅|❌|
| Policies (RBAC, compliance) |✅|✅|❌|
| Machine configuration |✅|✅|❌|
| Automanage |✅|❌|❌|
| Run command |✅|✅|❌|
| SQL Server configuration |✅|✅|❌|
| Azure Update Manager | ✅ <br>[3](#3) | ✅ <br>[1](#1) and [2](#2)  | ❌ |
| Inventory |✅|✅  <br>[1](#1) and [2](#2) |❌|
| Change tracking |✅|✅  <br>[1](#1) and [2](#2) |❌|
| Extended Security Updates | ✅ <br>[3](#3) | ✅ <br>[3](#3) | ❌ |
| **Windows management** |
| Windows Admin Center |❌|✅  <br>[1](#1) and [2](#2) |❌|
| Best Practices Assessment |❌|✅  <br>[1](#1) and [2](#2) |❌|
| **Monitoring** |
| Azure Monitor |✅|✅|❌|
| Insights|✅|✅|❌|
| Logs |✅|✅|❌|
| Alerts |✅|❌|❌|
| Workbooks |❌|✅|❌|
| **Automation** |
| CLI/PowerShell |✅|✅|❌|
| Tasks |✅|✅|❌|
| Export template |✅|❌|❌|
| Resource health |❌ <br>(Use Alerts) |✅|❌|

<a name="1"></a>1: At additional cost.

<a name="2"></a>2: Included as part of Windows Server and SQL Server management capabilities enabled by Azure Arc. For more information, see [Azure Hybrid Benefit for Windows Server](/windows-server/get-started/azure-hybrid-benefit?tabs=azure).

<a name="3"></a>3: Included for VMs running on Azure and Azure Local instances.

## Related content

- [Review prerequisites for Azure Local VMs enabled by Azure Arc](../manage/azure-arc-vm-management-prerequisites.md)
