---
title: Supported operations for Arc VMs on Azure Local 
description: Learn the supported VM operations for Azure Arc VMs on Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 02/13/2025
---

# Supported operations for Arc VMs on Azure Local 

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article discusses the most common supported operations for Azure Arc virtual machines (VMs) on Azure Local.

## Overview

Azure Local can host various VM types, but Arc VMs provide the highest level of management capabilities in Azure portal, second only to [native Azure VMs](/azure/azure-local/concepts/compare-vm-management-capabilities). VMs are created using [Arc VM provisioning flow](/azure/azure-local/manage/create-arc-virtual-machines?tabs=azureportal), registered to [Arc Resource Bridge](/azure/azure-arc/resource-bridge/overview), and have the [Connected Machine agent](/azure/azure-arc/servers/agent-overview) installed. Due to the nature of their architecture, Arc VMs are specifically designed to be managed by the Azure control plane.  

Local tools such as System Center Virtual Machine Manager (SCVMM), Failover Cluster Manager, Hyper-V Manager, and Windows Admin Console have been available for many years, offering extensive management capabilities. Many are well-versed with these tools and have been managing these systems for years, using scripts and orchestration that have been refined over time.

Arc VMs hosted outside of Azure, inside of corporate networks, run on Azure Local and appear identical to non-Arc VMs running on the same system. You can manage these VMs using the same local tools and scripts. However, this practice may result in synchronization issues between the Arc VM and Azure portal, hindering their management with the comprehensive features provided by the Azure portal ecosystem. Some VM operations are supported and some are not.

## Supported VM operations  

If an operation is supported by Azure portal, it can only be performed using Azure portal (and not using local tools).

### Using Azure portal

The following operations are supported using Azure portal.

- Create VM
- Start VM
- Restart VM
- Stop VM
- Delete VM
- Add network interface to VM
- Delete network interface for VM
- Enable and use Windows Admin Center (for read-only) on a VM
- Add data disk to VM
- Delete data disk from VM
- Change CPU cores for VM
- Change memory of VM
- Add extensions to VM
- Delete extensions from VM
- Enable guest management on VM
- Connect to VM via SSH

### Using Azure CLI from Azure portal

The following VM operations are supported using Azure Command Line Interface (CLI) only from Azure portal.

- Pause state of VM
- Save state of VM
- Attach GPU to VM
- Detach GPU from VM

### Using local tools

The following VM operations are supported using local tools.

- Connect to VM
- Quick migrate a VM to another machine in the same system
- Live migrate a VM to another machine in the same system
- Enable/disable MAC address spoofing per network interface
- Enable/disable single root input/output virtualization (SR-IOV) per network interface
- Processor compatibility mode configuration per VM
- Processor NUMA topology configuration per VM
- Processor VM reserve, limit, and weight
- Enable Quality of Service (QoS) management per disk
- Add/remove SCSI controller and move existing data disk
- Add/remove DVD drive from VM
- Configure dynamic memory of VM
- Change VM boot order of VM
- Enable/disable integration services of VM
- Change automatic start action of VM
- Change automatic stop action of VM
- Enable Trusted Platform Module (TPM) of Generation 2 VM
- Enable secure boot of Generation 2 VM
- Change default location of VM files
- Pause/resume machine in a system
- Change automatic balancing of VMs in a system
- Configure the number of simultaneous live migrations of a system
- Configure the number of simultaneous storage live migrations of a system
- Add/remove/change order of host network for live migration of a system

### Coming soon for Azure portal

The following VM operations will be supported in a future release using Azure portal.

- Connect VM from Azure (requires line of sight to host machine)
- VM availability zone awareness
- Hot add/remove memory
- Give shutdown/turnoff option during stopping VM
- Convert existing VM to Arc VM (hydration)
- Resize data disks of VM from Azure
- Allow sharing disks between Arc VMs
- Basic day N operations on logical networks (DNS, IP pool changes)

## Unsupported VM operations

The following VM operations are not supported and can't be performed using Azure portal or local tools.

- Live migrate a VM from one system to another
- Rename a VM
- Checkpoint a VM (standard or production)
- Change the VM MAC address pool on the machine
- Change disk type (static/dynamic) of a VM
- Change IP address of network interface
- Enable/change VLAN ID per network interface
- Change MAC address of network interface

## Related content

- [Manage Arc VMs](manage-arc-virtual-machines.md)
