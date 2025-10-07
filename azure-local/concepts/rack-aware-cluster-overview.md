---
title: Overview of Azure Local Rack Aware Clustering (Preview)
description: Use this article to learn about Azure Local Rack Aware Clustering. (Preview)
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-local
ms.date: 10/07/2025
---

# Azure Local Rack Aware Clustering overview (Preview)

Applies to: Azure Local version 2510 and later

This article gives a high-level overview of the Azure Local Rack Aware Clustering feature including its benefits and use cases. The article also details the supported configurations and deployment requirements for Rack Aware Clusters. This article applies only to new deployments of Azure Local version 2510 and later.

[!INCLUDE [important](../includes/hci-preview.md)]

## About Rack Aware Cluster

Azure Local Rack Aware Cluster is an advanced architecture designed to enhance fault tolerance and data distribution within an Azure Local instance. This architecture enables you to cluster nodes that are strategically placed across two physical racks in two different rooms or buildings with high bandwidth and low latency.

The following diagram shows a cluster of two racks of servers with top-of-rack (TOR) switches connected between rooms. Each rack functions as a local availability zone across layers from the operating system to Azure Local management, including Azure Local VMs enabled by Azure Arc.  

:::image type="content" source="media/rack-aware-cluster-overview/rack-aware-cluster-architecture.png" alt-text="Diagram of rack aware cluster architecture." lightbox="media/rack-aware-cluster-overview/rack-aware-cluster-architecture.png":::

This direct connection between racks supports a single storage pool, with Rack Aware Clusters guaranteeing data copy distribution evenly between the two racks.  

This design is valuable in environments that require high availability and disaster recovery capabilities. Even if an entire rack encounters an issue, the other rack maintains the integrity and accessibility of the data.

To support the synchronous replications between racks, a dedicated storage network intent is required to secure the bandwidth and low latency for storage traffic. The required round-trip latency between the two racks should be 1 ms or less.

For detailed networking requirements, see [Rack Aware Clustering network design](../index.yml).

## Benefits

The main benefits of Azure Local Rack Aware Cluster include:

- **High availability**: By distributing data across two or more racks, the system can withstand the failure of an entire rack without losing access to data. This is important for mission-critical applications that require continuous uptime.

- **Improved performance**: The architecture allows for better load balancing and resource utilization, as workloads can be distributed across multiple racks.

- **Simplified management**: Azure Local Rack Aware Clustering provides a unified management interface for both racks, making it easier to monitor and maintain the system.

- **Cost-effective**: By using existing infrastructure and providing a single storage pool, organizations can reduce costs associated with hardware and maintenance.


## Use cases

The use cases for Azure Local Rack Aware Cluster include:

- Use rack aware cluster in a high security environment for mission-critical applications.
- Use rack aware cluster in a manufacturing plant to minimize the risk of data loss or downtime in the event of a rack-level failure.  

## Requirements

All [system requirements for Azure Local](../concepts/system-requirements-23h2.md) apply to rack aware clusters. There are [Other requirements](../index.yml) for rack aware clusters including those for drives, Availability Zones, node configurations, latency, and bandwidth.


## Deploy a Rack Aware Cluster

To deploy a Rack Aware Cluster, use one of the following methods:

- [Azure portal](../index.yml).
- [Azure Resource Manager template](../index.yml).

## Scale a Rack Aware Cluster

Scale the cluster by adding a pair of nodes to a Rack Aware Cluster. The 2+2 configuration can be expanded to 3+3, and 3+3 to 4+4.

> [!NOTE]
> Adding nodes to a 1+1 Rack Aware Cluster is not supported in this release.

For more information, see [Add nodes to a Rack Aware Cluster](../index.yml).

## Place Azure Local VMs

You can create Azure Local VMs to place in a specified zone to balance workloads between zones. Based on the criticality of the VMs, you can configure strict or non-strict placement to disable or enable failover to the other zone.

For more information about VM placement in a Rack Aware Cluster, see [Manage VM placement in a Rack Aware Cluster](../manage/rack-aware-cluster-vm-placement.md).

## Fail over Azure Local VMs in a Rack Aware Cluster

We recommend that you conduct live migration and failover testing of your VM workloads within a Rack Aware Cluster.

- **Planned failover**: During planned failover, non-strict placed VMs are seamlessly migrated to operational nodes within the same zone or, if necessary, to another zone without incurring downtime. 
- **Unplanned failover**: During unplanned failover, VM operations may be interrupted. Typically, systems require three to five minutes to restore availability on an alternate node or zone. Strict placed VMs stay in the zone they are placed and do not fail over to the other zone.

    | VM starting placement | Failure mode | VM placement reaction          | Recover     | VM placement reaction |
    |-----------------------|--------------|--------------------------------|-------------|-----------------------|
    | Zone 1 (strict)       | Zone 1 down  | Saved mode (no failover)       | Zone 1 back | Zone 1 (strict)       |
    | Zone 1 (non-strict)   | Zone 1 down  | Zone 2 (non-strict) (failover) | Zone 1 back | Zone 1 (non-strict)   |
    | Zone 2 (strict)       | Zone 1 down  | No change                      | Zone 1 back | No change             |
    | Zone 2 (non-strict)   | Zone 1 down  | No change                      | Zone 1 back | No change             |

We recommend that you perform load testing to ensure the solution is properly scaled for deployment in the production environment.

## Next steps

- Review [Rack Aware Cluster network design](../index.yml).
- Deploy a Rack Aware Cluster via [Azure portal](../index.yml) or [ARM template](../index.yml).
- Learn how to [Configure availability zones](../index.yml) in a Rack Aware Cluster.
