---
title: Manage logical networks for Azure Local VMs enabled by Azure Arc
description: Learn how to manage logical networks for Azure Local VMs enabled by Azure Arc.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 01/20/2026
ms.subservice: hyperconverged
---

# Manage logical networks for Azure Local VMs enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

To deploy Azure Local virtual machines (VMs) enabled by Azure Arc, you need to create logical networks. Once these networks are provisioned, you may need to manage them. This article describes how to manage these logical networks for Azure Local VMs deployed on your Local instance.


## About logical networks

A logical network is a logical representation of a physical network where Azure Local VMs can be provisioned. It defines how VM network interfaces connect to the underlying network. Logical networks allows you to configure networking settings like address prefix, subnet, IP pools, gateways, DNS servers, and VLANs used for VM connectivity.

- Once a logical network is created, you can't update the following:
  - Default gateway
  - IP pools
  - IP address space
  - VLAN ID
  - Virtual switch name
  - DNS server configuration of infrastructure logical networks

Logical networks are of two types: infrastructure logical networks and workload logical networks.

### About infrastructure logical network

When you deploy an Azure Local instance, an infrastructure logical network is created automatically.
- This logical network encompasses the management IP address range provided during deployment. 
- You can't manage this infrastructure logical network.
    - You can't create a network interface on the infrastructure logical network.
    - You can't update the infrastructure logical network configuration including DNS server settings.
    - Deletion of this logical network requires you to first delete all the Azure Local VMs, network interfaces, and workload logical networks on your Azure Local instance. Deletion will only remove the cloud projection, the on-premises logical network remains.

        Typically you delete the infrastructure logical network only when you are decommissioning or redeploying the Azure Local instance.

### About workload logical networks

You can create additional logical networks for application workloads running on your Azure Local VMs and you can manage these logical networks as needed. For example, you can update the DNS server configuration for a workload logical network.


## Prerequisites

- Access to a deployed and registered Azure Local instance with one or more running Azure Local VMs.
  For more information, see [Create an Azure Local VM enabled by Azure Arc](./create-arc-virtual-machines.md).

::: moniker range=">=azloc-2508"

## Manage DNS server configuration for logical networks (preview)

### Key considerations

Before you update the DNS server configuration for a logical network, be aware of the following caveats:

- This feature is in preview and shouldn't be used on production logical networks.
- The updated DNS server configuration only applies to new Azure Local VMs created on the logical network after the update. For all the existing Azure Local VMs, manually update the DNS server entries within the VM.
- You can't update the DNS server of a logical network that has an AKS cluster deployed.
- You can't update the DNS server of a DHCP logical network. To update the DNS server for a DHCP logical network, manually update the DNS server configuration from within the DHCP server.
- The infrastructure logical network (enveloping the 6 management IP address range provided during deployment) and Arc resource bridge DNS server updates are not supported.

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

- [Manage VM extensions on Azure Local virtual machines](./virtual-machine-manage-extension.md).
