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

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

To deploy Azure Local virtual machines (VMs) enabled by Azure Arc, you need to create logical networks. Once these networks are provisioned, you may need to manage them. This article describes how to manage these logical networks for Azure Local VMs deployed on your multi-rack instance.


## About logical networks

A logical network is a logical representation of a physical network where Azure Local VMs can be provisioned. It defines how VM network interfaces connect to the underlying network. Logical networks allow you to configure networking settings like address prefix, subnet, IP pools, gateways, DNS servers, and VLANs used for VM connectivity.

Once a logical network is created, you can't update the following:
  - Default gateway
  - IP pools
  - IP address space
  - VLAN ID

You can manage logical networks as needed. For example, you can update the DNS server configuration for a logical network.

> [!NOTE]
> Only static IP allocation is supported on Azure Local for multi-rack deployments. For more information on creating logical networks, see [Create logical networks for Azure Local multi-rack VMs](./multi-rack-create-logical-networks.md).


## Prerequisites

- Access to a deployed and registered Azure Local multi-rack instance with one or more running Azure Local VMs.
  For more information, see [Create an Azure Local VM enabled by Azure Arc](./multi-rack-create-arc-virtual-machines.md).

::: moniker range=">=azloc-2508"

## Manage DNS server configuration for logical networks (preview)

### Key considerations

Before you update the DNS server configuration for a logical network, be aware of the following caveats:

- This feature is in preview and shouldn't be used on production logical networks.
- The updated DNS server configuration only applies to new Azure Local VMs created on the logical network after the update. For all the existing Azure Local VMs, manually update the DNS server entries within the VM.

### Update DNS server configuration

> [!IMPORTANT]
> Make sure to enter all the relevant DNS server IP entries in your `update` command and not just the entry you want to change. Running a DNS server `update` command replaces the existing configuration.

Follow these steps to manage DNS server configuration for logical networks.

#### Set parameters

```PowerShell
$logicalNetwork = "your-logical-network"
$resourceGroup = "your-resource-group"
$dnsServers = "IP-address1", "IP-address2"
```

#### Update configuration

```azure cli
az stack-hci-vm network lnet update --name $logicalNetwork --resource-group $resourceGroup --dns-servers $dnsServers
```

::: moniker-end

## Related content

- [Create logical networks for Azure Local multi-rack VMs](./multi-rack-create-logical-networks.md).
- [Manage VM extensions on Azure Local virtual machines](./multi-rack-virtual-machine-manage-extension.md).
