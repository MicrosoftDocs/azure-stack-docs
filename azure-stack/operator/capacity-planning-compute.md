---
title: Compute capacity planning for Azure Stack | Microsoft Docs
description: Learn about compute capacity planning for Azure Stack deployments.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.assetid:
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/24/2019
ms.author: mabrigg
ms.reviewer: prchint
ms.lastreviewed: 04/03/2019
ms.custom: 

---

# Azure Stack compute capacity planning
The [VM sizes supported on Azure Stack](../user/azure-stack-vm-sizes.md) are a subset of those supported on Azure. Azure imposes resource limits to avoid overconsumption of resources at either the service-level or locally for the server. Without consumption limits, tenant experiences would suffer when other tenants overconsume resources. Networking egress bandwidth from a virtual machine (VM) has the same limitation as Azure. For storage resources, storage IOPs limits have been implemented on Azure Stack to avoid basic overconsumption of resources by tenants for storage access.  <!--- is the intent to compare AS cap restrictions to Azure as a point of reference? If so, how do storage IOPs compare? Also, it's not really clear why the para starts with VM sizes. Is the intent to compare Azure Stack to Azure for VM size, egress, and storage? Maybe we could show that in a table?>

## VM placement and virtual to physical core overprovisioning
A tenant can't place a VM on a specific server, so the only consideration when placing VMs is whether the server has enough memory to host that VM type. Azure Stack does not overcommit memory; however, an overcommit of the number of cores is allowed. Since placement algorithms do not look at the existing virtual to physical core overprovisioning ratio as a factor, each host could have a different ratio. 

To achieve high availability, VMs are placed in an availability set spread across multiple fault domains. In Azure Stack, a fault domain in an availability set is defined as a single node in the scale unit.

While the infrastructure of Azure Stack is resilient to failures, the underlying technology (failover clustering) still incurs some downtime for VMs on an impacted physical server in the event of a hardware failure. To be consistent with Azure, Azure Stack supports up to three fault domains within an availablity set. VMs placed in an availability set will be physically isolated from each other by spreading them as evenly as possible over multiple Azure Stack nodes. If there is a hardware failure, VMs from the failed fault domain will be restarted in other nodes, but, if possible, kept in separate fault domains from the other VMs in the same availability set. When the hardware comes back online, VMs will be rebalanced to maintain high availability.

Azure also provides update domains in availability sets. An update domain is a logical group of underlying hardware that can undergo maintenance or be rebooted at the same time. In Azure Stack, VMs are live migrated across the other online hosts in the cluster before their underlying host is updated. Since there is no tenant downtime during a host update, the update domain feature on Azure Stack only exists for template compatibility with Azure.

## Azure Stack memory 
To allow for patch and update of an Azure Stack integrated system, and to be resilient to physical hardware failures, a portion of the total server memory is reserved and unavailable for tenant VM placement. This reserved capacity allows VMs to be migrated and restarted on another server.

The following calculation results in the total available memory that can be used for tenant VM placement. This memory capacity is for the entirety of the Azure Stack Scale Unit. 

  Available Memory for VM placement = Total Server Memory - Resiliency Reserve - Memory used by running VMs - Azure Stack Infrastructure Overhead <sup>1</sup>

  Resiliency reserve = H + R * ((N-1) * H) + V * (N-2)

> Where:
> -	H = Size of single server memory
> - N = Size of Scale Unit (number of servers)
> -	R = The operating system reserve for OS overhead, which is .15 in this formula<sup>2</sup>
> -	V = Largest VM in the scale unit

  <sup>1</sup> Azure Stack Infrastructure Overhead = 242 GB (4 x # of nodes) <!--- need to confirm 4 x # of nodes>

  <sup>2</sup> Operating system reserve for overhead = 15% (.15) of node memory. The operating system reserve value is an estimate and will vary based on the physical memory capacity of the server and general operating system overhead.

The value V, largest VM in the scale unit, is dynamically based on the largest tenant VM memory size. For example, the largest VM value could be 7 GB or 112 GB or any other supported VM memory size in the Azure Stack solution.

This calculation is an estimate and subject to change based on the current version of Azure Stack. The ability to deploy tenant VMs and services is based on specific factors of the deployed solution. This example calculation is a guide, but not an absolute answer to whether a VM can be deployed to a server.

<!--- Are there any events or other indicators they should monitor ongoing to determine if the capacity is optmized? >



## Next steps
[Storage capacity planning](capacity-planning-storage.md)
