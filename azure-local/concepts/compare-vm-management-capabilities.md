---
title: Compare management capabilities of Azure Local VMs
description: Learn about the kinds of virtual machines (VMs) that can run on Azure Local and compare their management capabilities.
ms.topic: conceptual
author: ManikaDhiman
ms.author: v-manidhiman
ms.date: 01/30/2029
---

# Compare management capabilities of Azure Local VMs

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes the types of virtual machines (VMs) that can run on Azure Local and compares their management capabilities when accessed through the Azure portal.

## Compare Azure Local VMs

Here are the different types of VMs that you can run on your Azure Local system:

- **Arc VMs.** Windows and Linux VMs hosted in an on-premises Azure Local environment, connected to Azure using Azure Arc. Arc VMs support the most management capabilities in the Azure portal, second only to native Azure VMs. They allow fabric operations like start, restart, stop, update VM memory/vCPU, add or remove data disk and network interfaces. In addition, Arc VMs can utilize Azure VM extensions that help govern, protect, configure, and monitor VMs.

- **Arc-enabled servers.** Physical machines or Windows and Linux VMs running on Azure Local, connected to Azure using Azure Arc. You can manage Arc-enabled servers through the Azure portal by installing the Azure Connected Machine agent. However, they lack the fabric management capabilities that come with Arc VMs.

- **Non-arc VMs.** Windows and Linux machines created and hosted in an on-premises Azure Local environment, not connected to Azure. You can't manage non-Arc VMs through the Azure portal.

The following table compares the provisioning and management methods for the various types of Azure Local VM:

| VM provisioning and management methods | Arc VMs | Arc-enabled servers | Non-arc VMs |
| ---- | ---- | ---- | ---- |
| Provisioning method |  - (Recommended) [Arc VM provisioning flow](../manage/create-arc-virtual-machines.md?tabs=azureportal). Create Arc VMs using Azure CLI, Azure portal, or Azure Resource Manager template. Using ARM templates, you can also automate VM provisioning in a secure cloud environment. <br><br> - [Azure Migrate flow](../migrate/migration-azure-migrate-overview.md). Migrate existing Hyper-V VMs as Arc VMs to Azure Local using the migration flow. | Physical servers or virtual machines on your Azure Local system managed through Azure Arc. Connect these machines to Azure by installing the [Azure Connected Machine agent](/azure/azure-arc/servers/agent-overview) on each machine. For example, each Azure Local host machine is Arc-enabled, facilitating management from the Azure portal. | On-premises provisioning flow. Use local tools like [Windows Admin Center](../manage/vm.md#create-a-new-vm), [System Center Virtual Machine Manager (SCVMM)](/system-center/vmm/provision-vms), [PowerShell](../manage/vm-powershell.md#create-a-vm), and Failover Cluster Manager available in your on-premises environment.|
| Management method | Via [the Azure portal](../manage/manage-arc-virtual-machines.md). | Via the Azure portal. See [Management and monitoring for Azure Arc-enabled servers](/azure/cloud-adoption-framework/scenarios/hybrid/arc-enabled-servers/eslz-management-and-monitoring-arc-server). | Via the local tools. Manage these VMs through the management consoles of the same local tools used for their creation. |

## Compare VM management capabilities

The following table compares the management capabilities for Arc VMs, non-Arc VMs, and Arc-enabled servers across various operations and features available through the Azure portal:

| Management capability | Arc VMs | Arc-enabled server | Non-Arc VMs |
|--|--|--|--|
| Start | Yes | No | No |
| Restart | Yes | No | No |
| Stop | Yes | No | No |
| Delete | Yes | Yes | No |
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
| Extension Support: | Yes | Yes | No |
| Azure Automation Windows Hybrid Worker <br><br>- Azure Extension for SQL Server<br>- Azure Monitor Agent for Windows<br>- Custom Script Extension for Windows - Azure Arc<br>- Datadog Agent<br>- Dynatrace OneAgent<br>- Log Analytics Agent - Azure Arc<br>- Network Watcher Agent for Windows<br>- OpenSSH for Windows - Azure Arc | Yes | Yes | No |
| Locks | Yes | Yes | No |
| Policies (RBAC, compliance) | Yes | Yes | No |
| Machine Configuration | Yes | Yes | No |
| Automanage | Yes | Yes | No |
| Run command | No | Yes | No |
| SQL Server configuration | No | Yes | No |
| Update management (Guest OS) | Yes (free) | Yes (charged) | No |
| Inventory | Yes | Yes | No |
| Change tracking | Yes | Yes | No |
| Insights | Yes | Yes | No |
| Logs | Yes | Yes | No |
| Workbooks | No | Yes | No |
| Alerts | Yes | No | No |
| Metrics | Yes | No | No |
| CLI/PS | Yes | Yes | No |
| Tasks | Yes | Yes | No |
| Export template | Yes | No | No |

## Next steps

- [Deploy a virtual Azure Local system](../deploy/deployment-virtual.md).
