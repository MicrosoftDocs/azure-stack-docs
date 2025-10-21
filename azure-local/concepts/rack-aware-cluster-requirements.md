---
title: Requirements and supported configurations for Rack Aware Clusters (Preview)
description: Learn about requirements and supported configurations for Rack Aware Clusters (Preview).
author: alkohli
ms.topic: how-to
ms.date: 10/08/2025
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
---

# Requirements and supported configurations for Rack Aware Clusters (Preview)

This article provides the requirements and supported configurations for Rack Aware Clusters.

[!INCLUDE [important](../includes/hci-preview.md)]

## General requirements

| Category | Details |
|--|--|
| System requirements | All Azure Local system requirements apply to Rack Aware Clusters. See [System requirements for Azure Local](../concepts/system-requirements-23h2.md). |
| Drive requirements | Data drives must be all-flash. Either Nonvolatile Memory Express (NVMe) or solid-state drives (SSD) work. |
| Availability zones | - Supports two local zones with maximum four machines per zone.<br>- The two zones must contain an equal number of machines.<br>- A machine can belong to only one zone. |
| Deployment type | Only new deployments are supported. Conversion from standard clusters deployments to Rack Aware Clusters isn't supported. |
| Latency requirement | Round-trip latency between racks must be 1 millisecond or less. |
| Bandwidth requirement | Dedicated storage network is required for synchronous replication between racks. For details on bandwidth requirements based on cluster size and network interface card (NIC) speed, see [Bandwidth requirements](#bandwidth-requirements). |

### Bandwidth requirements

The necessary bandwidth can be calculated based on the cluster size and the network interface card (NIC) speed, as described in the following table:

<!--Add link--For detailed networking requirements, see the [network design requirements]().-->

| Machines per zone | NIC speed (Gbps) | Storage ports | Required bandwidth (GbE) |
|--|--|--|--|
| 1 | 10 | 2 | 20 GbE |
| 2 | 10 | 2 | 40 GbE |
| 3 | 10 | 2 | 60 GbE |
| 4 | 10 | 2 | 80 GbE |
| 1 | 25 | 2 | 50 GbE |
| 2 | 25 | 2 | 100 GbE |
| 3 | 25 | 2 | 150 GbE |
| 4 | 25 | 2 | 200 GbE |

## Supported node configurations

The following table summarizes the supported configurations with volume resiliency settings:

| Number of machines in two zones | Workload volumes | Volume resiliency | Storage efficiency | Fault tolerance |
|--|--|--|--|--|
| 1+1 (2-node cluster) | 2 | Two-way mirror | 50% | Single fault (drive, node, or rack) |
| 2+2 (4-node) | 4 | Four-way mirror | 25% | Three faults (drive or node). <br> If one rack fails, the remaining can sustain one fault of drive or node. |
| 3+3 (6-node) | 6 | Four-way mirror | 25% | Three faults (drive or node). <br> If one rack fails, the remaining can sustain one fault of drive or node. |
| 4+4 (8-node) | 8 | Four-way mirror | 25% | Three faults (drive or node). <br> If one rack fails, the remaining can sustain one fault of drive or node. |

> [!NOTES]
> - Rack Level Nested Mirror (RLNM) is required for all configurations.
> - You can’t create 3-way mirror volumes. Only 2-way or 4-way mirror volumes are supported.

## Key considerations

Keep in mind the following key considerations for Rack Aware Cluster:

- You can deploy Rack Aware Clusters through the [Azure portal](../index.yml) or using [ARM template](../index.yml).
- You can create Azure Local VMs and assign them to specific zones to balance workloads. Based on VM criticality, you can configure:
  - Strict placement. VM stays in its assigned zone and doesn't fail over.
  - Non-strict placement. VM can fail over to the other zone if needed.
- You can scale the cluster by adding a pair of nodes to a Rack Aware Cluster. The 2+2 configuration can be expanded to 3+3, and 3+3 to 4+4. However, adding nodes to a 1+1 Rack Aware Cluster isn't supported in this release.

## Recommendations

- Perform load testing to ensure the solution is properly scaled for production.
- Conduct live migration and failover testing for VM workloads.

    - During planned failovers, non-strict VMs are seamlessly migrated to operational nodes within the same zone or, if necessary, to another zone with no downtime.

    - During unplanned failovers, VM operations might be interrupted. Typically, systems require three to five minutes to restore availability on an alternate node or zone.

    The following table outlines the VM placement and failover behavior:

    | VM starting placement | Failure mode | VM placement reaction | Recovery | VM placement after recovery |
    |--|--|--|--|--|
    | Zone 1 (strict) | Zone 1 down | Saved mode (no failover) | Zone 1 back | Zone 1 (strict) |
    | Zone 1 (non-strict) | Zone 1 down | Zone 2 (non-strict) (failover) | Zone 1 back | Zone 1 (non-strict) |
    | Zone 2 (strict) | Zone 1 down | No change | Zone 1 back | No change |
    | Zone 2 (non-strict) | Zone 1 down | No change | Zone 1 back | No change |

- When reporting issues, collect diagnostic logs. See [Collect diagnostic logs for Azure Local](../manage/collect-logs.md).

## Unsupported configurations

- Applying VM affinity rules using Windows Admin Center and PowerShell can result in unknown behavior.
- Adding nodes to a 1+1 Rack Aware Cluster isn't supported in this release.

## Next steps

- [Deploy Rack Aware Cluster via the Azure portal](../index.yml).
- [Deploy Rack Aware Cluster via ARM template](../index.yml).