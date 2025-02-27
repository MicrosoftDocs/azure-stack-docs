---
title: Supported operations for Arc VMs on Azure Local 
description: Learn the supported VM operations for Azure Arc VMs on Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 02/26/2025
---

# Supported operations for Azure Local virtual machines 

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article discusses the most common operations for Azure Local virtual machines (VMs) enabled by Azure Arc and identifies the operations that are supported, and the ones that you need to avoid to prevent compllications.

## Overview

Azure Local can host various types of VMs including Arc-enabled servers, traditional VMs, and VMs enabled by Azure Arc. When comparing these options, the VMs enabled by Azure Arc provide the highest level of management capabilities in Azure portal, second only to [native Azure VMs](/azure/azure-local/concepts/compare-vm-management-capabilities).

The architecture of VMs enabled by Arc, is specifically designed to be managed by the Azure control plane. However, these VMs can also be managed by on-premises local tools. These tools include System Center Virtual Machine Manager (SCVMM), Failover Cluster Manager, Hyper-V Manager, and Windows Admin Center. Many customers have used these tools for years to manage their on-premises VMs.

While IT admins can manage Azure Local VMs using the same tool and scripts, this practice could lead to synchronization issues between the Arc VMs and the Azure portal. The best way to manage these VMs is to make sure if the operations are supported in Azure portal only or supported by portal and local tools, manage these VMs via the portal. Use the local tools only if the operations are supported only by the local tools (and not via the portal).

## Supported VM operations

If an operation is supported in Azure portal, make sure to perform that operation only via the Azure portal (and not via local tools).

### Using Azure portal

The following operations are supported using Azure portal:

- Create VM.
- Start VM.
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

The following VM operations are supported only using the Azure Command-Line Interface (CLI):

- Pause state of VM.
- Save state of VM.
- Attach GPU to VM.
- Detach GPU from VM.

### Using local tools

The following VM operations are supported only using the local tools:

- Connect to VM.
- Quick migrate a VM to another machine in the same system.
- Live migrate a VM to another machine in the same system.
- Enable/disable MAC address spoofing per network interface.
- Enable/disable single root input/output virtualization (SR-IOV) per network interface.
- Processor compatibility mode configuration per VM.
- Processor NUMA topology configuration per VM.
- Processor VM reserve, limit, and weight.
- Enable Quality of Service (QoS) management per disk.
- Add/remove SCSI controller and move existing data disk.
- Add/remove DVD drive from VM.
- Configure dynamic memory of VM.
- Change VM boot order of VM.
- Enable/disable integration services of VM.
- Change automatic start action of VM.
- Change automatic stop action of VM.
- Enable Trusted Platform Module (TPM) of Generation 2 VM.
- Enable secure boot of Generation 2 VM.
- Change default location of VM files.
- Pause/resume machine in a system.
- Change automatic balancing of VMs in a system.
- Configure the number of simultaneous live migrations of a system.
- Configure the number of simultaneous storage live migrations of a system.
- Add/remove/change order of host network for live migration of a system.


## Unsupported VM operations

The following VM operations aren't supported. These operations can't be performed using the Azure portal or the local tools.

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
