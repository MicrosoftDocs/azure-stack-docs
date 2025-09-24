---
title: Virtual machine load balancing
description: Use this article to learn how to configure the VM load balancing feature in Azure Local and Windows Server.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.date: 08/04/2025
---
# Virtual machine load balancing

> Applies to: Azure Local 2311.2 and later; Windows Server 2025, Windows Server 2022, Windows Server 2019, Windows Server 2016

[!INCLUDE [hci-arc-vm](../includes/hci-arc-vm.md)]

A key consideration for Azure Local deployments is the capital expenditure (CapEx) required to go into production. It's common to add redundancy to avoid under-capacity during peak traffic in production, but this increases CapEx. This redundancy is often needed because some machines in the system are hosting more virtual machines (VMs), while other machines are underutilized.

VM load balancing is a feature that allows you to optimize machine utilization in your Azure Local systems. It identifies over-committed machines and live migrates VMs from those machines to under-committed machines. Failure policies such as anti-affinity, fault domains (sites), and possible owners are honored.

VM load balancing evaluates a machine's load based on the following heuristics:

- **Current memory pressure:** Memory is the most common resource constraint on a Hyper-V host.
- **CPU utilization averaged over a five-minute window:** Mitigates any machine in the system from becoming over-committed.

## How does VM load balancing work?

VM load balancing occurs automatically when you add a new machine to your Azure Local and can also be configured to perform periodic, recurring load balancing.

### When a new machine is added

When you join a new machine to your system, the VM load balancing feature automatically balances capacity from the existing machines to the newly added machine in the following order:

1. The memory pressure and CPU utilization are evaluated on the existing machines in the system.
2. All machines exceeding the threshold are identified.
3. The machines with the highest memory pressure and CPU utilization are identified to determine priority of balancing.
4. VMs are live migrated (with no downtime) from a machine that exceeds the threshold to the newly added machine in the system.

:::image type="content" source="media/vm-load-balancing/server-added.png" alt-text="Image showing a new machine being added to a system." lightbox="media/vm-load-balancing/server-added.png":::

### Recurring load balancing

By default, VM load balancing is configured for periodic balancing: the memory pressure and CPU utilization on each machine in the system are evaluated for balancing every 30 minutes. Here's the flow of the steps:

1. The memory pressure and CPU utilization are evaluated on all machines in the system.
2. All machines exceeding the threshold and those below the threshold are identified.
3. The machines with the highest memory pressure and CPU utilization are identified to determine priority of balancing.
4. VMs are live migrated (with no downtime) from a machine that exceeds the threshold to another machine that is under the minimum threshold.

:::image type="content" source="media/vm-load-balancing/periodic-balancing.png" alt-text="Image showing a live system being automatically rebalanced" lightbox="media/vm-load-balancing/periodic-balancing.png":::

## Configure VM load balancing using Windows Admin Center

The easiest way to configure VM load balancing is using Windows Admin Center.

:::image type="content" source="media/vm-load-balancing/vm-load-balancing.png" alt-text="Configuring VM load balancing with Windows Admin Center" lightbox="media/vm-load-balancing/vm-load-balancing.png":::

1. Connect to your system and go to **Tools > Settings**.

2. Under **Settings**, select **Virtual machine load balancing**.

3. Under **Balance virtual machines**, select **Always** to load balance upon machine join and every 30 minutes, **Server joins** to load balance only upon machine joins, or **Never** to disable the VM load balancing feature. The default setting is **Always**.

4. Under **Aggressiveness**, select **Low** to live migrate VMs when the machine is more than 80% loaded, **Medium** to migrate when the machine is more than 70% loaded, or **High** to average the machines in the system and migrate when the machine is more than 5% above average. The default setting is **Low**.

## Configure VM load balancing using Windows PowerShell

You can configure if and when load balancing occurs using the cluster common property `AutoBalancerMode`. To control when to balance the cluster, run the following in PowerShell, substituting a value from the table:

```PowerShell
(Get-Cluster).AutoBalancerMode = <value>
```

|AutoBalancerMode |Behavior|
|-----------------|-----------|
| 0 | Disabled (default for Azure Local) |
| 1 | Load balance upon machine join (default for Windows Server) |
| 2 | Load balance upon machine join and every 30 minutes |

You can also configure the aggressiveness of balancing by using the cluster common property `AutoBalancerLevel`. To control the aggressiveness threshold, run the following in PowerShell, substituting a value from the table:

```PowerShell
(Get-Cluster).AutoBalancerLevel = <value>
```

| AutoBalancerLevel | Aggressiveness | Behavior |
|-------------------|----------------|----------|
| 1 (default) | Low | Move when host is more than 80% loaded |
| 2 | Medium | Move when host is more than 70% loaded |
| 3 | High | Average machines in the system and move when host is more than 5% above average |

To check how the `AutoBalancerLevel` and `AutoBalancerMode` properties are set, run the following in PowerShell:

```PowerShell
Get-Cluster | fl AutoBalancer*
```

## Next steps

For related information, see also:

- [Manage VMs](vm.md)
- [Manage VMs with PowerShell](vm-powershell.md)
- [Create VM affinity rules](vm-affinity.md)
