---
title: Supported operations for Azure Local virtual machines (VMs) enabled by Azure Arc
description: Learn the supported virtual machine (VM) operations for Azure Local VMs enabled by Azure Arc.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 03/18/2025
---

# Supported operations for Azure Local virtual machines (VMs) 

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article discusses the most common operations for Azure Local virtual machines (VMs) enabled by Azure Arc. The article identifies the operations that are supported on Azure Local VMs, and the ones that you need to avoid to prevent complications.

## Overview

Azure Local can host various types of VMs including unmanaged VMs, Arc-enabled servers, and VMs enabled by Azure Arc. When comparing these options, the VMs enabled by Azure Arc provide the highest level of management capabilities in Azure portal, second only to [native Azure VMs](/azure/azure-local/concepts/compare-vm-management-capabilities).

While Azure Local VMs are designed to be managed through the Azure control plane and have numerous management features within the portal, on-premises local tools offer a broader range of capabilities. These tools include System Center Virtual Machine Manager (SCVMM), Failover Cluster Manager, Hyper-V Manager, and Windows Admin Center. Many IT admins use these tools to manage their on-premises VMs.

When IT admins manage Azure Local VMs using the same tools and scripts as those for on-premises VMs, this may results in synchronization or more severe problems between the Azure Local VMs and the portal. 
> [!NOTE]
> - We recommend that you use the Azure portal or Azure CLI to manage Azure Local VMs. Use the local tools only if these operations are included in the list of [Supported operations for local tools](#using-local-tools).
> - Though the operations listed under [Supported operations for local tools](#using-local-tools) don't affect the management of Azure Local VMs, the changes aren't reflected in the Azure portal.
> - Only the following operations when performed using local tools update the state of the Azure Local VM in the portal: Changing the size of VM memory, vCPU count, change the power state status (Start/Stop VM) resulting from the power cycle operation.

## Supported operations for VMs

The supported operations can be performed via multiple interfaces.

### Using Azure portal or Azure CLI

> [!IMPORTANT]
> Make sure to perform these VM operations only via the Azure portal or Azure CLI (and not via the local tools).

- Restart.
- Stop.
- Delete.
- Add network interface.
- Delete network interface.
- Enable and use Windows Admin Center (for read-only).
- Add data disk.
- Delete data disk.
- Change CPU cores.
- Change memory.
- Add extensions.
- Delete extensions.
- Enable guest management.
- Connect via SSH.

### Using Azure CLI

> [!IMPORTANT]
> Make sure to perform these operations only via the Azure CLI (and not via the local tools).

- Pause VM.
- Save VM state.
- Attach GPU.
- Detach GPU.

### Using local tools

The following VM operations are supported only using the local tools such as Windows Admin Center, Hyper-V Manager, Failover Cluster Manager, and SCVMM. These operations are performed either on the VM itself or on the cluster/node. 

> [!IMPORTANT]
> These changes aren't reflected in the portal.

#### VM-level operations

- Rename a VM inside the guest operating system.
- Rename a VM on local tools.
- Change MAC address of network adapter.
- Enable/disable MAC address spoofing per network adapter.
- Configure Processor compatibility mode.
- Configure Processor Non-Uniform Memory Access (NUMA) topology.
- Configure Processor VM reserve, limit, and weight.
- Enable Quality of Service (QoS) management per disk.
- Add a Small Computer System Interface (SCSI) controller and move an existing data disk to another SCSI controller.
- Remove a SCSI controller.
- Add/remove DVD drive.
- Configure dynamic memory.
- Change VM boot order.
- Enable/disable integration services.
- Change automatic start action.
- Change automatic stop action.
- Enable secure boot of Generation 2 VM.

#### Cluster or node-level operations

- Connect to VM.
- Quick migrate a VM to another node in the same cluster.
- Live migrate a VM to another node in the same cluster.
- Change default location of VM files.
- Change automatic balancing of VMs in the cluster.
- Change the Hyper-V MAC address range on the node.

#### Operations supported only via Network ATC PowerShell cmdlets

The following VM operations are supported only using the Network ATC PowerShell cmdlets. For more information, see [Customize cluster network settings](./manage-network-atc.md#customize-cluster-network-settings).

- Enable/disable single root input/output virtualization (SR-IOV) per network interface.
- Configure the number of simultaneous live migrations of a cluster.
- Configure the number of simultaneous storage live migrations of a cluster.
- Add/remove/change order of host network for live migration of a cluster.

## Unsupported VM operations

The following VM operations aren't supported.

> [!IMPORTANT]
> These operations can't be performed using Azure portal, Azure CLI, or local tools. Performing these operations can lead to Azure Local VMs becoming unmanageable from Azure portal.

- Change IP address of network adapter. To perform this operation, create a new network interface and delete the old one.
- Enable/change VLAN ID per network adapter. To perform this operation, create a new network interface and delete the old one.
- Live migrate a VM from one cluster to another.
- Checkpoint a VM (standard or production).
- Change the type of disk (static/dynamic/VHD/VHDX).
- Change the size of disk (compact/expand).


## Related content

- [Manage Arc VMs](manage-arc-virtual-machines.md)
