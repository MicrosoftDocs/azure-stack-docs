---
title: Virtual Machine Load Balancing overview
description: Use this topic to learn about Virtual Machine Load Balancing in Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 1/6/2021
---
# What is Virtual Machine Load Balancing?

> Applies to: Azure Stack HCI, version 20H2; Windows Server 2019; Windows Server 2016

A key consideration for HCI deployments is the capital expenditure (CapEx) required to go into production. It is common to add redundancy to avoid under-capacity during peak traffic in production, but this increases CapEx. This redundancy is often needed because some servers in the cluster are hosting more virtual machines (VMs), while other servers are underutilized.

Enabled by default in Azure Stack HCI, VM Load Balancing allows you to optimize server utilization in your Azure Stack HCI cluster. It identifies over-committed nodes and live migrates VMs from those nodes to under-committed nodes. Failure policies such as anti-affinity, fault domains, and possible owners are honored.

Virtual Machine Load Balancing evaluates a server's load based on the following heuristics:

- **Current memory pressure:** Memory is the most common resource constraint on a Hyper-V host.
- **CPU utilization averaged over a five-minute window:** Mitigates any one server in the cluster from becoming over-committed.

## How does it work?

When you add a new server to your cluster, the Virtual Machine Load Balancing feature automatically balances capacity from the existing nodes to the newly added node in the following order:

1. The pressure is evaluated on the existing servers in the cluster.
2. All servers exceeding the threshold are identified. 
3. The nodes with the highest pressure are identified to determine priority of balancing.
4. VMs are Live Migrated (with no downtime) from a server that exceeds the threshold to the newly added server in the cluster.

When configured for periodic balancing, the pressure on the cluster nodes is evaluated for balancing every 30 minutes. Alternately, the pressure can be evaluated on-demand. Here is the flow of the steps:

1. The pressure is evaluated on all servers in the cluster.
2. All servers exceeding the threshold and those below the threshold are identified.
3. The servers with the highest pressure are identified to determine priority of balancing.
4. VMs are live migrated (with no downtime) from a server that exceeds the threshold to another server that is under the minimum threshold.

## Configure Virtual Machine Load Balancing

You can configure the aggressiveness of balancing based on the memory and CPU heuristics by using the cluster common property `AutoBalancerLevel`. To control the aggressiveness threshold, run the following in PowerShell, substituting a value from the table below:

```PowerShell
(Get-Cluster).AutoBalancerLevel = <value>
```

| AutoBalancerLevel | Aggressiveness | Behavior |
|-------------------|----------------|----------|
| 1 (default) | Low | Move when host is more than 80% loaded |
| 2 | Medium | Move when host is more than 70% loaded |
| 3 | High | Average nodes and move when host is more than 5% above average |

If and when load balancing occurs can be configured using the cluster common property `AutoBalancerMode`. To control when Node Fairness balances the cluster, run the following in PowerShell, substituting a value from the table below:

```PowerShell
(Get-Cluster).AutoBalancerMode = <value>
```

|AutoBalancerMode |Behavior|
|:----------------:|:----------:|
|0| Disabled|
|1| Load balance on node join|
|2 (default)| Load balance on node join and every 30 minutes |

To check how the `AutoBalancerLevel` and `AutoBalancerMode` properties are set, run the following in PowerShell:

```PowerShell
Get-Cluster | fl AutoBalancer*
```

## Next steps

For related information, see also:

- [Manage VMs](vm.md)
- [Manage VMs with PowerShell](vm-powershell.md)
- [Create VM affinity rules](vm-affinity.md)
