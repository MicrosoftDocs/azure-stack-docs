---
title: Configure local availability zones for disaggregated deployments
description: Learn how to configure local availability zones for disaggregated deployments.
author: ronmiab
ms.topic: how-to
ms.date: 07/17/2026
ms.author: robess
ms.service: azure-local
ms.custom: devx-track-azurepowershell
ms.subservice: hyperconverged
---

# Configure local availability zones for disaggregated deployments

This article explains how to plan, configure, and validate local availability zones for disaggregated Azure Local deployments. You learn how to map machines to zone boundaries that reflect your physical topology so you can specify placement for Azure Local VMs and improve workload resiliency across failure domains.

## Overview

Local availability zones are logical groups of Azure Local machines that share a physical failure boundary, such as a rack, room, power distribution unit, top-of-rack switch, or maintenance domain.

Disaggregated Azure Local deployments let you choose the node density for each rack based on power, cooling, and floor weight requirements. You can map each rack to a local availability zone, enabling workloads to be placed within these zones or without an explicit placement setting.

For example, if an Azure Local instance spans four racks, you can create one local availability zone per rack and assign each machine to the zone for its rack. When you create Azure Local VMs, you can place a VM in a specific zone to help distribute workloads across failure boundaries.

Local availability zones help you:

- Align workload placement with physical infrastructure boundaries.
- Reduce the chance that related workloads are concentrated in the same rack or failure boundary.
- Support placement decisions for workloads that need zone-aware resiliency, performance affinity, or compliance-driven locality.
- Provide consistent placement semantics across Azure Local management and Azure Local VMs enabled by Azure Arc.

> [!IMPORTANT]
> Local availability zone configuration depends on the physical topology that you provide. Azure Local can validate that the zone configuration is structurally valid, but it can't independently confirm that each machine is physically installed in the rack or location represented by the zone. Verify the physical mapping before you apply the configuration.

## Prerequisites

Before you configure local availability zones, make sure that you:

- Deploy an Azure Local instance by using a supported disaggregated architecture.
- Use supported external SAN storage for the Azure Local instance.
- Know the physical location of each machine.
- Decide the number of local availability zones to create.
- Assign each machine to exactly one local availability zone.
- Include every machine in the Azure Local instance in the zone mapping.
- Don't set the number of zones to exceed the number of machines.

## Plan your local availability zone configuration

Before you create the configuration, plan the zone layout and node mapping.

1. Identify the physical failure boundaries in your environment. Use one local availability zone per rack.
1. Choose a naming pattern for the zones. For example, if you use the prefix zone and a zone count of 4, the generated zone names might be zone1, zone2, zone3, and zone4.
1. Map each machine to a zone. Each machine must belong to one local availability zone.
1. Review the mapping with your datacenter or hardware operations team. Confirm that the machine-to-zone mapping matches the physical topology.

The following table provides an example of zone layout and mapping.

|Zone|Physical boundary|Machines|
|---|---|---|
|zone1|Rack 1|node01, node02, node03, node04|
|zone2|Rack 2|node05, node06, node07, node08|
|zone3|Rack 3|node09, node10, node11, node12|
|zone4|Rack 4|node13, node14, node15, node16|

## Create local availability zones

Use PowerShell to create local availability zones and assign machines to each zone.

> [!IMPORTANT]
> The following PowerShell example uses placeholder command names and parameters. Replace them with the final cmdlet, module, and parameter names for your supported Azure Local release before publishing.

```powershell
$assignment = @{
    "zone1" = @("node1", "node2", "node3", "node4")
    "zone2" = @("node5", "node6", "node7", "node8")
    "zone3" = @("node9", "node10", "node11", "node12")
    "zone4" = @("node13", "node14", "node15", "node16")
}

Enable-AsLocalAvailabilityZones -Count 4 -Prefix "zone" -NodeAssignment $assignment
```

The configuration job creates local availability zones and maps each machine to one zone.

## Validate local availability zones

After you submit the configuration, validate that the job completed successfully and that each machine is assigned to the expected zone.

> [!IMPORTANT]
> The following PowerShell example uses placeholder command names and parameters. Replace them with the final cmdlet, module, and parameter names for your supported Azure Local release before publishing.

```powershell
Get-ClusterFaultDomain
```

Example output:

```
Name                        Type   ParentName             ChildrenNames                            Location
----                        ----   ----------             -------------                            --------
Site 100.00.000.0/24 Site                                 {zone1, zone2, zone3, zone4}
zone1                       Rack   Site 100.00.000.0/24   {node1, node2, node3, node4}
zone2                       Rack   Site 100.00.000.0/24   {node5, node6, node7, node8}
zone3                       Rack   Site 100.00.000.0/24   {node9, node10, node11, node12}
zone4                       Rack   Site 100.00.000.0/24   {node13, node14, node15, node16}
node1                       Node   zone1
node2                       Node   zone1
node3                       Node   zone1
node4                       Node   zone1
node5                       Node   zone2
node6                       Node   zone2
node7                       Node   zone2
node8                       Node   zone2
node9                       Node   zone3
node10                      Node   zone3
node11                      Node   zone3
node12                      Node   zone3
node13                      Node   zone4
node14                      Node   zone4
node15                      Node   zone4
node16                      Node   zone4
```

Review the output and confirm that:

- The expected local availability zones are created.
- Every machine is assigned to a zone.
- No machine is assigned to more than one zone.
- The zone names match your intended naming pattern.
- The mapping matches the physical topology that you planned.

If the operation fails, review the error message, correct the configuration, and rerun the command.

```powershell
Enable-AsLocalAvailabilityZones -Rerun
```

## Common issues

You might encounter the following issues when configuring local availability zones:

- A machine is missing from the zone mapping.
- A machine is assigned to more than one zone.
- The number of zones is greater than the number of machines.
- A zone name or prefix doesn't meet naming requirements.
- The Azure Local instance doesn't meet the requirements for local availability zones.

## Change a local availability zone configuration

Plan your local availability zone configuration carefully before deployment. Changing the zone mapping afterward can disrupt VM placement, especially for VMs already assigned to a specific zone.

If you need to correct a zone mapping, refer to the [troubleshooting guide](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Deployment/HowTo-Deployment-RedoLocalAvailabilityZones.md).

> [!CAUTION]
> Don't change local availability zone mappings without understanding the impact on existing VMs. Existing VM placement settings can reference the configured zones.

## Deploy Azure Local VMs in a local availability zone

After you configure local availability zones, you can create Azure Local VMs in a specific zone.

For the VM placement instructions, see [Provision Azure Local VMs in a local availability zone](../concepts/rack-aware-cluster-provision-vm-local-availability-zone.md).