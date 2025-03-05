---
title: Supported operations for Arc Virtual Machines on Azure Local 
description: Learn the supported VM operations for Azure Arc VMs on Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 03/05/2025
---

# Supported operations for Azure Local virtual machines 

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article discusses the most common operations for Azure Local virtual machines (VMs) enabled by Azure Arc and identifies the operations that are supported, and the ones that you need to avoid to prevent complications.

## Overview

Azure Local can host various types of VMs including Arc-enabled servers, unmanaged VMs, and VMs enabled by Azure Arc. When comparing these options, the Azure Local VMs enabled by Azure Arc provide the highest level of management capabilities in Azure portal, second only to [native Azure VMs](/azure/azure-local/concepts/compare-vm-management-capabilities).

While the architecture of Azure Local VMs is designed to be managed by the Azure control plane, these VMs can also be managed by on-premises local tools. These tools include System Center Virtual Machine Manager (SCVMM), Failover Cluster Manager, Hyper-V Manager, and Windows Admin Center. Many customers have used these tools for years to manage their on-premises VMs.

If IT admins manage Azure Local VMs using the same tools and scripts as those for on-premises VMs, this could result in synchronization issues between the Azure Local VMs and the portal.

> [!NOTE]
> We recommend that you use the Azure portal or Azure CLI to manage Azure Local VMs. Use the local tools only if these operations are included in the list of [Supported operations for local tools](#using-local-tools).

## Supported operations

The supported operations can be performed via multiple interfaces.

### Using Azure portal or Azure CLI

> [!IMPORTANT]
> Make sure to perform these operations only via the Azure portal or Azure CLI (and not via the local tools).

- Restart VM.
- Stop VM.
- Delete VM.
- Add network interface to VM.
- Delete network interface for VM.
- Enable and use Windows Admin Center (for read-only) on a VM.
- Add data disk to VM.
- Delete data disk from VM.
- Change CPU cores for VM.
- Change memory of VM.
- Add extensions to VM.
- Delete extensions from VM.
- Enable guest management on VM.
- Connect to VM via SSH.

### Using Azure CLI

> [!IMPORTANT]
> Make sure to perform these operations only via the Azure CLI (and not via the local tools).

- Pause state of VM.
- Save state of VM.
- Attach GPU to VM.
- Detach GPU from VM.

### Using local tools

The following VM operations are supported only using the local tools such as Windows Admin Center, Hyper-V Manager, Failover Cluster Manager, and SCVMM. These operations are performed either on the VM itself or on the cluster/node.

### VM-level operations

- Enable/disable MAC address spoofing per network interface.
- Processor compatibility mode configuration per VM.
- Processor Non-Uniform Memory Access (NUMA) topology configuration per VM.
- Processor VM reserve, limit, and weight.
- Enable Quality of Service (QoS) management per disk.
- Add a Small Computer System Interface (SCSI) controller and move an existing data disk to another SCSI controller.
- Remove a SCSI controller from VM.
- Add/remove DVD drive from VM.
- Configure dynamic memory of VM.
- Change VM boot order of VM.
- Enable/disable integration services of VM.
- Change automatic start action of VM.
- Change automatic stop action of VM.
- Enable secure boot of Generation 2 VM.

### Cluster or node-level operations

- Connect to VM.
- Quick migrate a VM to another machine in the same system.
- Live migrate a VM to another machine in the same system.
- Change default location of VM files.
- Change automatic balancing of VMs in a system.


## Operations supported only via Network ATC PowerShell cmdlets

The following VM operations are supported only using the Network ATC PowerShell cmdlets. For more information, see [Customize cluster network settings](./manage-network-atc.md#customize-cluster-network-settings).

- Enable/disable single root input/output virtualization (SR-IOV) per network interface.
- Configure the number of simultaneous live migrations of a system.
- Configure the number of simultaneous storage live migrations of a system.
- Add/remove/change order of host network for live migration of a system.

## Unsupported VM operations

The following VM operations aren't supported. These operations can't be performed using the Azure portal, or the Azure CLI, or the local tools.

- Live migrate a VM from one system to another.
- Rename a VM.
- Checkpoint a VM (standard or production).
- Change the VM MAC address pool on the machine.
- Change disk type (static/dynamic) of a VM.
- Change IP address of network interface.
- Enable/change VLAN ID per network interface.
- Change MAC address of network interface.

## Related content

- [Manage Arc VMs](manage-arc-virtual-machines.md)
