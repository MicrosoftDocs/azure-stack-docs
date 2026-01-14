---
title: Manage logical networks for Azure Local VMs enabled by Azure Arc
description: Learn how to manage logical networks for Azure Local VMs enabled by Azure Arc.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 01/14/2026
ms.subservice: hyperconverged
---

# Manage logical networks for Azure Local VMs enabled by Azure Arc

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

To deploy Azure Local virtual machines (VMs) enabled by Azure Arc, you need to create a logical network. Once the Azure Local VMs are deployed, you may need to manage these logical networks. This article describes how to manage these logical networks for an Azure Local VMs deployed on your Azure Local instance.


## About logical networks

A logical network is a software-defined representation of a physical network that enables you to segment and isolate network traffic for different workloads or applications running on Azure Local VMs. Logical networks can be related to Azure Local VM management or application workloads.

### About infrastructure logical network

When you deploy an Azure Local instance, an infrastructure logical network is created automatically.
- This logical network encompasses the management IP address range provided during deployment. 
- You can't manage infrastructure logical networks.
    - If you try to create a network interface using Azure CLI on the infrastructure logical network, the operation will fail.
    - You can't update the infrastructure logical network.
    - Deletion of this logical network should be done in a prescribed order. First remove Arc VM network interfaces associated with the network, then remove all the associated application workload logical networks and finally remove all the Azure Local VMs. Once everything is removed, you can delete the infrastructure logical network. Deletion will only remove the cloud projection, the on-premises logical network remains.

### About workload logical networks

You can create additional logical networks for application workload on your Azure Local VMs and you can manage these logical networks as needed. For example, you can update the DNS server configuration for a workload logical network.


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
