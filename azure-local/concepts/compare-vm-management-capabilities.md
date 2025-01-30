---
title: Compare management capabilities of Azure Local VMs
description: Learn about the kinds of virtual machines (VMs) that can run on Azure Local and compare their management capabilities.
ms.topic: conceptual
author: ManikaDhiman
ms.author: v-manidhiman
ms.date: 01/30/2025
---

# Compare management capabilities of Azure Local VMs

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the types of virtual machines (VMs) that can run on Azure Local and compares their management capabilities when accessed through the Azure portal.

## Compare Azure Local VMs

Here are the different types of VMs that you can run on your Azure Local system:

- **Arc VMs:** Windows and Linux VMs hosted outside of Azure, on your corporate network, running on Azure Local.
  - Created using [Arc VM provisioning flow](../manage/create-arc-virtual-machines.md?tabs=azureportal), registered to [Arc Resource Bridge](/azure/azure-arc/resource-bridge/overview), and have the [Connected Machine agent](/azure/azure-arc/servers/agent-release-notes) installed.
  - Offer extensive management capabilities in the Azure portal, second only to native Azure VMs.
  - Provide lifecycle management capabilities like starting, stopping, changing VM memory/vCPU, and adding or removing data disk and network interfaces with the help of [Arc Resource Bridge](/azure/azure-arc/resource-bridge/overview).
  - Use Azure Arc extensions like Defender for Cloud, Log Analytics, Azure Monitor to help govern, protect, configure, and monitor VMs through the Connected Machine agent.
  - Can be managed through the Azure portal.

- **[Arc-enabled servers](/azure/azure-arc/servers/overview):** Windows and Linux VMs hosted outside of Azure, on your corporate network, running on Azure Local with [Connected Machine agent](/azure/azure-arc/servers/agent-release-notes) installed.
  - Use Azure Arc extensions to help govern, protect, configure, and monitor VMs, similar to Arc VMs.
  - Don't have the lifecycle management capabilities that Arc VMs have.
  - Can be managed through the Azure portal.

- **Non-Arc VMs:** Windows and Linux VMs created and hosted outside of Azure, on your corporate network, running on Azure Local.
  - Aren't connected to Azure.
  - Can't be managed through the Azure portal.

The following table compares the provisioning and management methods for the various types of Azure Local VM:

| VM provisioning and management methods | Arc VMs | Arc-enabled servers | Non-Arc VMs |
| :---- | :---- | :---- | :---- |
| Provisioning method |  [Arc VM provisioning flow](../manage/create-arc-virtual-machines.md?tabs=azureportal). Create Arc VMs using Azure CLI, Azure portal, or Azure Resource Manager template. Using ARM templates, you can also automate VM provisioning in a secure cloud environment. <br><br> [Azure Migrate flow](../migrate/migration-azure-migrate-overview.md). Migrate existing Hyper-V VMs as Arc VMs to Azure Local using the migration flow. | Connect these machines to Azure by installing the [Connected Machine agent](/azure/azure-arc/servers/agent-overview) on each machine. | On-premises provisioning flow. Use local tools like Failover Cluster Manager available in your on-premises environment, or use [Windows Admin Center](../manage/vm.md#create-a-new-vm), [System Center Virtual Machine Manager (SCVMM)](/system-center/vmm/provision-vms), or [PowerShell](../manage/vm-powershell.md#create-a-vm).|
| Management method | Via [the Azure portal](../manage/manage-arc-virtual-machines.md). | Via the Azure portal. See [Management and monitoring for Azure Arc-enabled servers](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-management-and-monitoring-arc-server). | Via the local tools. Manage these VMs through the management consoles of the same local tools used for their creation. |

> [!NOTE]
> Currently, conversion of an Arc-enabled server or non-Arc VM to an Arc VM isn't supported. 

## Compare VM management capabilities

The following table compares the management capabilities for Arc VMs, Arc-enabled servers, and non-Arc VMs across various operations and features available through the Azure portal:

| Management capability | Arc VMs | Arc-enabled servers | Non-Arc VMs |
|:--|:--:|:--:|:--:|
| Start | Yes | No | No |
| Restart | Yes | No | No |
| Stop | Yes | No | No |
| Delete | Yes | Yes | No |
| Save State (CLI) | Yes | No | No |
| Pause (CLI) | Yes | No | No |
| GPU configuration (CLI) | Yes | No | No |
| Add network interface | Yes | No | No |
| Connect with SSH | Yes | Yes | No |
| Add a new data disk | Yes | No | No |
| Change vCPU count | Yes | No | No |
| Change Memory amount | Yes | No | No |
| Change Memory type (static, dynamic) | Yes | No | No |
| Change Min memory | Yes | No | No |
| Change Max memory | Yes | No | No |
| Security recommendations | Yes | Yes | No |
| Defender for Cloud | Yes | Yes | No |
| Extension Support | Yes | Yes | No |
| Policies (RBAC, compliance) | Yes | Yes | No |
| Machine Configuration | Yes | Yes | No |
| Automanage | Yes | Yes | No |
| Run command | Yes | Yes | No |
| SQL Server configuration | Yes | Yes | No |
| Update management (Guest OS) | Yes (free) | Yes (charged) | No |
| Inventory | Yes | Yes | No |
| Change tracking | Yes | Yes | No |
| Insights | Yes | Yes | No |
| Logs | Yes | Yes | No |
| Alerts | Yes | No | No |
| Metrics | Yes | No | No |
| CLI/PS | Yes | Yes | No |
| Tasks | Yes | Yes | No |

## Next steps

- Review [Azure Arc VM management prerequisites](../manage/azure-arc-vm-management-prerequisites.md).