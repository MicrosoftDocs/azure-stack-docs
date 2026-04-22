---
title: Manage logical networks for Azure Local multi-rack VMs enabled by Azure Arc (preview)
description: Learn how to manage logical networks for Azure Local multi-rack VMs enabled by Azure Arc.
author: dramasamy
ms.author: dramasamy
ms.topic: how-to
ms.service: azure-local
ms.date: 04/15/2026
ms.subservice: multi-rack
---

# Manage logical networks for Azure Local multi-rack VMs enabled by Azure Arc (preview)

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

To deploy Azure Local virtual machines (VMs) enabled by Azure Arc, you need to create logical networks. Once these networks are provisioned, you might need to manage them. This article describes how to manage these logical networks for Azure Local VMs deployed on your multi-rack instance.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## About logical networks

A logical network is a logical representation of a physical network where Azure Local VMs can be provisioned. It defines how VM network interfaces connect to the underlying network. Logical networks allow you to configure networking settings like address prefix, subnet, IP pools, gateways, DNS servers, and VLANs used for VM connectivity.

Once a logical network is created, you can't update the following:

- Default gateway
- IP pools
- IP address space
- VLAN ID
- DNS servers
- Subnet name
- IP allocation method
- Network type
- Number of subnets

You can update the network security group (NSG) association for a logical network.

> [!NOTE]
> Only static IP allocation is supported on Azure Local for multi-rack deployments. For more information on creating logical networks, see [Create logical networks for Azure Local multi-rack VMs](./multi-rack-create-logical-networks.md).


## Prerequisites

- You must have access to a deployed and registered Azure Local multi-rack instance with one or more running Azure Local VMs.
  For more information, see [Create an Azure Local VM enabled by Azure Arc](./multi-rack-create-arc-virtual-machines.md).

## Related content

- [Create logical networks for Azure Local multi-rack VMs](./multi-rack-create-logical-networks.md).
- [Manage VM extensions on Azure Local virtual machines](./multi-rack-virtual-machine-manage-extension.md).
