---
title: Overview of Azure Local Rack Aware Clustering
description: Use this article to learn about Azure Local Rack Aware Clustering.
author: alkohli
ms.author: alkohli
ms.topic: overview
ms.service: azure-local
ms.date: 04/03/2025
---

# Azure Local Rack Aware Clustering overview

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article gives a high-level overview of the Azure Local Rack Aware Clustering feature including its benefits and use cases. The article also details the supported configurations and deployment requirements for rack aware clustering.

[!INCLUDE [important](../includes/hci-preview.md)]

## About Rack Aware Cluster

Azure Local Rack Aware Cluster is an advanced architecture designed to enhance fault tolerance and data distribution within an Azure Local instance. This architecture enables you to cluster nodes that are strategically placed across two physical racks in two different rooms or buildings with high bandwidth and low latency. 

The following diagram shows a cluster of two racks of servers with top-of-rack (TOR) switches connected between rooms. Each rack functions as a local availability zone across layers from the operating system to Azure Local management, including Azure Local VMs enabled by Azure Arc and Azure Kubernetes Service (AKS).  

:::image type="content" source="media/rack-aware-clustering-overview/rack-aware-cluster-architecture.png" alt-text="Diagram of rack aware cluster architecture." lightbox="media/rack-aware-clustering-overview/rack-aware-cluster-architecture.png":::

This direct connection between racks supports a single storage pool, with Rack Aware Clusters guaranteeing data copy distribution evenly between the two racks.  

This design is valuable in environments that require high availability and disaster recovery capabilities. Even if an entire rack encounters an issue, the other rack maintains the integrity and accessibility of the data.

To support the synchronous replications between racks, a dedicated storage network intent is required to secure the bandwidth and low latency for storage traffic. The required round-trip latency between the two racks should be 1 ms or less.

For detailed networking requirements, see [Rack Aware Clustering network design](./rack-aware-clustering-network-design-switch-configuration.md).

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
- Barbara to provide more information on use cases.


## Requirements and supported configurations

All [system requirements for Azure Local](../concepts/system-requirements-23h2.md) apply to rack aware clusters.  

Other requirements for rack aware clusters include:

- **Drive requirements**: Data drives must be all-flash. Either non volatile memory express (NVMe) or solid-state drives (SSD) work.

- **Availability zone requirements**: Rack aware cluster supports only two local availability zones, with a maximum of four machines in each zone. The two zones must contain an equal number of machines.

- **Supported configurations**:

    - The following table summarizes the supported configurations with volume resiliency settings.

        | Machines in two zones  | Volume resiliency   | Infra volumes  | Workload volumes  |
        |--| -- |--| -- |
        | 1+1 <br> (2-node cluster)  | 2-way mirror  | 1 | 2 |
        | 2+2 <br> (4-node cluster)  | Rack level nested mirror <br> (4-way mirror)  | 1 | 4 |
        | 3+3 <br> (6-node cluster)  | Rack level nested mirror <br> (4-way mirror)  | 1 | 6 |
        | 4+4 <br> (8-node cluster)  | Rack level nested mirror <br> (4-way mirror)  | 1 | 8 |

    - Only the new deployments are supported. Conversion from existing standard deployments to rack aware clusters isn't supported.

- **Replication requirements**: To facilitate synchronous replications between racks, a dedicated storage network is essential to ensure adequate bandwidth and low latency for storage traffic. The round-trip latency requirement between two racks should be 1 millisecond or less. The necessary bandwidth can be calculated based on the cluster size and the network interface card (NIC) speed as follows:

    | Machines in zone | NIC speed | Storage ports | Bandwidth required |
    |--| -- |--| -- |
    | 1 | 10 | 2 | 20 GbE  |
    | 2 | 10 | 2 | 40 GbE  |
    | 3 | 10 | 2 | 60 GbE  |
    | 4 | 10 | 2 | 80 GbE  |
    | 1 | 25 | 2 | 50 GbE  |
    | 2 | 25 | 2 | 100 GbE |
    | 3 | 25 | 2 | 150 GbE |
    | 4 | 25 | 2 | 200 GbE |

- **Adding a machine to a cluster** using the `add-node` command isn't supported in this release.

## Storage design

Storage Spaces Direct is used to create a single storage pool that aggregates the disk capacity from all machines.

- Only two-way mirror volumes are supported. Three-way mirror volumes aren't supported.

- For a *1+1* configuration, two volumes are created—one on each machine—with a two-way mirror that respects the rack fault domain, ensuring two copies of data are available in the cluster, one in each rack.
- In a *2+2* configuration, four volumes are created—one on each machine—with a two-way mirror that also respects the rack fault domain, providing one copy of data in each rack.

    With a two-way mirror:

    - The total usable capacity of the storage pool is 50%.
    - The system can handle one type of failure at a time. This means each cluster can support the failure of either one rack, one machine, or one disk without losing data.


## Next steps

- See [Rack Aware Cluster networking](./rack-aware-clustering-network-design-switch-configuration.md).