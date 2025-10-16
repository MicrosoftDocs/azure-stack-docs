---
title: Supported Operations for Azure Local Virtual Machines (VMs) Enabled by Azure Arc
description: Learn about the supported virtual machine (VM) operations for Azure Local VMs enabled by Azure Arc.
author: alkohli
ms.author: alkohli
ms.topic: concept-article
ms.service: azure-local
ms.date: 10/16/2025
---

# Supported operations for Azure Local VMs enabled by Azure Arc

> Applies to: Azure Local 2504 or later

This article discusses the most common operations for Azure Local virtual machines (VMs) enabled by Azure Arc. The article identifies the operations that are supported on Azure Local VMs, along with the operations that you need to avoid to prevent complications.

## Overview

Azure Local can host various types of VMs, including unmanaged VMs, Azure Arc-enabled servers, and Azure Arc-enabled VMs. Azure Arc-enabled VMs provide the highest level of management capabilities in the Azure portal, second only to [native Azure VMs](/azure/azure-local/concepts/compare-vm-management-capabilities).

Azure Local VMs are designed to be managed through the Azure control plane and have numerous management features within the portal. However, on-premises local tools offer a broader range of capabilities. These tools include System Center Virtual Machine Manager, Failover Cluster Manager, Hyper-V Manager, and Windows Admin Center. Many IT admins use these tools to manage their on-premises VMs.

When IT admins manage Azure Local VMs by using the same tools and scripts as those for on-premises VMs, it can result in synchronization errors or more severe problems between the Azure Local VMs and the portal.

> [!NOTE]
>
> - We recommend that you use the Azure portal or the Azure CLI to manage Azure Local VMs. Use the local tools only if these operations are included in the [list of supported operations for local tools](#local-tools) later in this article.
> - Though the supported operations for local tools don't affect the management of Azure Local VMs, the changes aren't reflected in the Azure portal.
> - Only the following operations update the state of an Azure Local VM in the portal, when you perform them by using local tools: change the size of VM memory, change the vCPU count, or change the power state (start or stop a VM) resulting from the power cycle operation.

## Supported VM operations

You can use multiple interfaces to perform supported operations for VMs.

### Azure portal or Azure CLI

Perform the following VM operations only via the Azure portal or the Azure CLI. Don't use the local tools.

- Restart a VM
- Stop a VM
- Delete a VM
- Add a network interface
- Delete a network interface
- Enable and use Windows Admin Center (for read-only)
- Add a data disk
- Delete a data disk
- Change CPU cores
- Change memory
- Add extensions
- Delete extensions
- Enable guest management
- Connect via Secure Shell (SSH)

### Azure CLI

Perform the following VM operations only via the Azure CLI. Don't use the local tools.

- Pause a VM
- Save the VM state
- Rename the computer name of your Azure Local VM.

    > [!NOTE]
    > This operation will automatically restart your Azure Local VM.

- Attach a GPU
- Detach a GPU
- Expand a data disk

### Local tools

The following VM operations are supported only when you use the local tools, such as Windows Admin Center, Hyper-V Manager, Failover Cluster Manager, and Virtual Machine Manager.

You perform these operations either on the VM itself or on the cluster/node. The changes aren't reflected in the portal.

#### VM-level operations

- Rename a VM on local tools
- Change the MAC address of a network adapter
- Enable/disable MAC address spoofing per network adapter
- Configure processor compatibility mode
- Change the IP address of a network interface (NIC) to match static IP NIC configuration on Azure Local control plane.
    > [!NOTE]
    > This manual change is allowed from within the guest operating system using local tools only when a static IP NIC was added post VM provisioning from Azure Local control plane. This ensures network configurations within the VM aligns with the configuration defined in the Azure control plane.
- Configure processor Non-Uniform Memory Access (NUMA) topology
- Configure processor VM reserve, limit, and weight
- Enable Quality of Service (QoS) management per disk
- Add a Small Computer System Interface (SCSI) controller and move an existing data disk to another SCSI controller
- Remove a SCSI controller
- Add or remove a DVD drive
- Configure dynamic memory
- Change VM boot order
- Enable or disable integration services
- Change an automatic start action
- Change an automatic stop action
- Enable secure boot of a generation 2 VM
- [Apply affinity / anti-affinity rules](vm-affinity.md)
- [Enable nested virtualization](../concepts/nested-virtualization?toc=/azure/azure-local/toc.json&bc=/azure/azure-local/breadcrumb/toc.json)

#### Cluster or node-level operations

- Connect to a VM
- Quickly migrate a VM to another node in the same cluster
- Live migrate a VM to another node in the same cluster
- Change the default location of VM files
- Change automatic balancing of VMs in the cluster
- Change the Hyper-V MAC address range on the node
- Compact a disk
- Checkpoint a VM (standard or production)

> [!NOTE]
> Taking a VM checkpoint locally is only supported for Azure Local 2504 and later.

#### Operations supported only via Network ATC PowerShell cmdlets

The following VM operations are supported only when you use the Network ATC PowerShell cmdlets. For more information, see [Customize cluster network settings](./manage-network-atc.md#customize-cluster-network-settings).

- Enable or disable single-root input/output virtualization (SR-IOV) per network interface
- Configure the number of simultaneous live migrations of a cluster
- Configure the number of simultaneous storage live migrations of a cluster
- Add, remove, or change the order of host networks for live migration of a cluster

## Unsupported VM operations

The following VM operations aren't supported for Azure Local VMs.

> [!IMPORTANT]
> You can't perform these operations by using the Azure portal, the Azure CLI, or local tools. Performing these operations can lead to Azure Local VMs becoming unmanageable from the Azure portal.

- Enable or change the VLAN ID of a network interface
- Live migrate a VM from one cluster to another
- Storage live migration on a VM
- Change the type of disk (static, dynamic, VHD, or VHDX)
- Add shared storage (shared VHD/X)

If you need to change the IP address or the VLAN ID of a network interface, create a new network interface and delete the old one.

## Related content

- [Manage Azure Local VMs enabled by Azure Arc](manage-arc-virtual-machines.md)
