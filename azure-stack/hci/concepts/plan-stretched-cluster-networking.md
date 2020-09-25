---
title: Plan host networking for Azure Stack HCI
description: Learn how to plan host networking for Azure Stack HCI clusters
author: v-dasis
ms.topic: how-to
ms.date: 09/28/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Plan host networking for Azure Stack HCI

> Applies to Azure Stack HCI version 20H2

This topic discusses planning considerations and requirements for host networking in both non-stretched and stretched cluster environments.

## RDMA considerations

Remote direct memory access (RDMA) is a direct memory access from the memory of one computer into that of another without involving either one's operating system. This permits high-throughput, low-latency networking, which is especially useful in clusters. RDMA lowers CPU usage and increases throughput while keeping CPU usage down.

All host RDMA traffic leverages SMB Direct as the RDMA transport and is multiplexed over port 445.  A minimum of two PFC enabled TCs must be used for RDMA (RoCE) traffic to remain compatible with the majority of current and future physical Switches on the market.

Internet Wide Area RDMA Protocol (iWARP) runs RDMA over TCP, while RDMA over Converged Ethernet (RCoE) avoids the use of TCP, but requires both NICs and physical switches that support it.

RDMA is enabled by default for all east/west traffic traffic between cluster nodes in a site on the same subnet. RDMA is disabled and not supported for north/south stretched cluster traffic between sites on different subnets.

These are the requirements for RDMA for Azure Stack HCI:

- All traffic between subnets and between sites (stretched clusters) must use WinSock TCP. Any intermediate network hops are outside of the view and control of Azure Stack HCI.
- RDMA between subnets and between sites (stretched clusters) is not supported. The use of uplinks and multiple network devices means multiple failure points where this could become unstable and unsupportable
- No additional virtual NICs are needed for Storage Replica (stretched clusters). However for troubleshooting purposes, it may be useful to keep the cross-site and cross-subnet traffic separate from the east-west RDMA traffic. If SMBDirect cannot be natively disabled cross-site or cross-subnet per flow, then:
    - One or more additional vNICs should be provisioned for Storage Replica
    - Storage Replica vNICs must have RDMA disabled (using the PowerShell `Disable-NetAdapterRDMA` cmdlet) since it is by definition cross-site and cross-subnet
    - Native RDMA adapters would need a vSwitch and vNICs for Storage Replica support in order to satisfy the site/subnet requirements above
    - Intra-site RDMA bandwidth requirements require knowing the bandwidth percentages per traffic type, as discussed in the **Traffic bandwidth allocation** section. This will ensure that appropriate bandwidth reservations and limits can be applied for east/west (node-to-node) traffic

## SMB traffic support

Server Message Block (SMB) is used by Azure Stack HCI. SMB on HCI supports the following traffic types:

- Storage Bus Layer (SBL) - used by Storage Spaces Direct; highest priority traffic
- Cluster Shared Volumes (CSV)
- Live Migration (LM)
- Storage Replica (SR) - used in stretched clusters
- File Shares (FS traditional and SOFS)
- Cluster heartbeat (HB)
- Cluster communication (node joins, cluster updates, registry updates)

SMB can flow over the following protocols:

- TCP (default)
- RDMA (per flow)
- QUIC (future)

## Network adapter considerations

### Compute and storage shared virtual switch

### Compute-only virtual switch

### Compute and storage dedicated virtual switches

## Interconnect requirements between nodes

This section discusses specific networking requirements between server nodes in a site, called interconnects. Either switched or switchless node interconnects can be used and are supported:

**Switched:** Server nodes are most commonly connected to each other via Ethernet networks that use network switches. Switches must be properly configured to handle the bandwidth and networking type. If using RDMA that implements the RoCE protocol, network device and switch configuration is important.

**Switchless:** Server nodes can also be interconnected using direct Ethernet connections without a switch. In this case, each server node must have a direct connection with every other cluster node in the same site.

### Interconnects for 2-3 node clusters

These are the minimum interconnect requirements for single-site clusters having two or three nodes. These apply for each server node:

One or more 1 Gb network adapter cards to be used for management functions
One or more 10 Gb (or faster) network interface cards for storage and workload traffic
Two or more network connections between each node recommended for redundancy and performance

### Interconnects for 4-node and greater clusters

These are the minimum interconnect requirements for clusters having four or more nodes, and for high-performance clusters. These apply for each server node:

One or more 1 Gb network adapter cards to be used for management functions.
One or more 25 Gb (or faster) network interface cards for storage and workload traffic. We recommend two or more network connections for redundancy and performance.
Network cards that are remote-direct memory access (RDMA) capable: iWARP (recommended) or RoCE.

## Site-to-site requirements (stretched cluster)

When connecting between sites for stretched clusters (or between subnets), interconnect requirements within each site still apply, and have additional Storage Replica and Hyper-V live migration traffic requirements that must be considered:

- At least one 1 Gb RDMA or Ethernet/TCP connection between sites for synchronous replication. A 25 Gb RDMA connection is preferred.
- A network between sites with enough bandwidth to contain your I/O write workload and an average of 5ms round trip latency or lower for synchronous replication. Asynchronous replication doesn't have a latency recommendation.
- If using a single connection between sites, set SMB bandwidth limits for Storage Replica using PowerShell. For more information, see [Set-SmbBandwidthLimit](https://docs.microsoft.com/powershell/module/smbshare/set-smbbandwidthlimit?view=win10-ps).
- If using multiple connections between sites, separate traffic between the connections. For example, put Storage Replica traffic on a separate network than Hyper-V live migration traffic using PowerShell. For more information, see [Set-SRNetworkConstraint](https://docs.microsoft.com/powershell/module/storagereplica/set-srnetworkconstraint?view=win10-ps).

- ## Traffic bandwidth allocation

The following table shows bandwidth allocations for various traffic types, where:

- LM and SR traffic are SMB bandwidth-limited
- SR traffic does not use RDMA
- All values are in GBps
- Values apply to both stretched and non-stretched clusters
- SMB traffic gets 50% of total allocation
- SBL/CSV traffic gets 70% of the remaining 50% allocation
- LM traffic gets 15% of the remaining 50% allocation
- SR traffic gets 14% of the remaining 50% allocation
- HB traffic gets 1% of the remaining 50% allocation
- *= should use compression rather than RDMA if bandwidth allocation for LM traffic is <5 Gbps

|NIC Speed|Teamed NIC Speed|SMB 50% Reservation|SBL/CSV %|SBL/CV Bandwidth|LM %|LM Bandwidth|SR % |SR Bandwidth|HB %|HB Bandwidth|
|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
|10|20|10|70%|7|14%*|1.4*|14%|1.4|2%|0.2|
|25|50|25|70%|17.5|15%*|3.75*|14%|3.5|1%|0.25|
|40|80|	40|70%|28|15%|6|14%|5.6|1%|0.4|
|50|100|50|70%|35|15%|7.5|14%|7|1%|0.5|
|100|200|100|70%|70|15%|15|14%|14|1%|1|
|200|400|200|70%|140|15%|30|14%|28|1%|2|

## Network port requirements

Ensure that the proper network ports are open between all server nodes both within a site and between sites (for stretched clusters). You'll need appropriate firewall and router rules to allow ICMP, SMB (port 445, plus port 5445 for SMB Direct), and WS-MAN (port 5985) bi-directional traffic between all servers in the cluster.

When using the Cluster Creation wizard in Windows Admin Center to create the cluster, the wizard automatically opens the appropriate firewall ports on each server in the cluster for Failover Clustering, Hyper-V, and Storage Replica. If using a different software firewall on each server, open the following ports:

### Failover Clustering ports

- ICMPv4 and ICMPv6
- TCP port 445
- RPC Dynamic Ports
- TCP port 135
- TCP port 137
- TCP port 3343
- UDP port 3343

### Hyper-V ports

- TCP port 135
- TCP port 80 (HTTP connectivity)
- TCP port 443 (HTTPS connectivity)
- TCP port 6600
- TCP port 2179
- RPC Dynamic Ports
- RPC Endpoint Mapper
- TCP port 445

### Storage Replica ports (stretched cluster)

- TCP port 445
- TCP 5445 (if using iWarp RDMA)
- TCP port 5985
- ICMPv4 and ICMPv6 (if using Test-SRTopology)

There may be additional ports required not listed above. These are the ports for basic Azure Stack HCI functionality.

## Non-stretched cluster scenario

:::image type="content" source="media/plan-host-networking/rack-topology-non-stretched.png" alt-text="Non-stretched cluster" lightbox="media/plan-host-networking/rack-topology-non-stretched.png":::

>[!NOTE]
>

## Stretched cluster scenario

:::image type="content" source="media/plan-host-networking/rack-topology-stretched.png" alt-text="Stretched cluster - simple" lightbox="media/plan-host-networking/rack-topology-stretched.png":::

Simple use case.

:::image type="content" source="media/plan-host-networking/simple-stretched-cluster.png" alt-text="Stretched cluster - advanced" lightbox="media/plan-host-networking/simple-stretched-cluster.png":::

## Next steps

- See [Create a cluster using Windows Admin Center](deploy/create-cluster.md)
- See [Create a cluster using Windows PowerShell](/deploy/create-cluster-powershell.md)