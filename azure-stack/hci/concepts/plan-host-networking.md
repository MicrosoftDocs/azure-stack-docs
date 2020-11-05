---
title: Plan host networking for Azure Stack HCI
description: Learn how to plan host networking for Azure Stack HCI clusters
author: v-dasis
ms.topic: how-to
ms.date: 10/13/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Plan host networking for Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2

This topic discusses host networking planning considerations and requirements in both non-stretched and stretched Azure Stack HCI cluster environments.

## Traffic types supported

Azure Stack HCI uses Server Message Block (SMB). SMB on Azure Stack HCI supports the following traffic types:

- Storage Bus Layer (SBL) - used by Storage Spaces Direct; highest priority traffic
- Cluster Shared Volumes (CSV)
- Live Migration (LM)
- Storage Replica (SR) - used in stretched clusters
- File Shares (FS) - FS traditional and Scale-Out File Server (SOFS)
- Cluster heartbeat (HB)
- Cluster communication (node joins, cluster updates, registry updates)

SMB traffic can flow over the following protocols:

- Transport Control Protocol (TCP) - used between sites
- Remote direct memory access (RDMA)

## Traffic bandwidth allocation

The following table shows bandwidth allocations for various traffic types, where:

- All units are in Gbps
- Values apply to both stretched and non-stretched clusters
- SMB traffic gets 50% of the total bandwidth allocation
- Storage Bus Layer/Cluster Shared Volume (SBL/CSV) traffic gets 70% of the remaining 50% allocation
- Live Migration (LM) traffic gets 15% of the remaining 50% allocation
- Storage Replica (SR) traffic gets 14% of the remaining 50% allocation
- Heartbeat (HB) traffic gets 1% of the remaining 50% allocation
- *= should use compression rather than RDMA if bandwidth allocation for LM traffic is <5 Gbps

|NIC Speed|Teamed Bandwidth|SMB 50% Reservation|SBL/CSV %|SBL/CSV Bandwidth|LM %|LM Bandwidth|SR % |SR Bandwidth|HB %|HB Bandwidth|
|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
|10|20|10|70%|7|14%*|1.4*|14%|1.4|2%|0.2|
|25|50|25|70%|17.5|15%*|3.75*|14%|3.5|1%|0.25|
|40|80|	40|70%|28|15%|6|14%|5.6|1%|0.4|
|50|100|50|70%|35|15%|7.5|14%|7|1%|0.5|
|100|200|100|70%|70|15%|15|14%|14|1%|1|
|200|400|200|70%|140|15%|30|14%|28|1%|2|

## RDMA considerations

Remote direct memory access (RDMA) is a direct memory access from the memory of one computer into that of another without involving either computer's operating system. This permits high-throughput, low-latency networking while minimizing CPU usage, which is especially useful in clusters.

All host RDMA traffic takes advantage of SMB Direct. SMB Direct is SMB 3.0 traffic sent over RDMA and is multiplexed over port 445. A minimum of two Priority-based Flow Control (PFC) enabled Traffic Classes (TCs) must be used for RDMA traffic to remain compatible with the majority of current and future physical switches on the market.

Internet Wide Area RDMA Protocol (iWARP) runs RDMA over TCP, while RDMA over Converged Ethernet (RoCE) avoids the use of TCP, but requires both NICs and physical switches that support it. For converged network requirements for RDMA over RoCE, see the [Windows Server 2016 and 2019 RDMA Deployment Guide](https://github.com/Microsoft/SDN/blob/master/Diagnostics/S2D%20WS2016_ConvergedNIC_Configuration.docx).

RDMA is enabled by default for all east/west traffic between cluster nodes in a site on the same subnet. RDMA is disabled and not supported for north/south stretched cluster traffic between sites on different subnets.

These are the requirements for RDMA for Azure Stack HCI:

- All traffic between subnets and between sites (stretched clusters) must use WinSock TCP. Any intermediate network hops are outside of the view and control of Azure Stack HCI.
- RDMA between subnets and between sites (stretched clusters) is not supported. The use of uplinks and multiple network devices means multiple failure points where this could become unstable and unsupportable.
- No additional virtual NICs are needed for Storage Replica traffic for stretched clusters. However for troubleshooting purposes, it may be useful to keep the cross-site and cross-subnet traffic separate from the east-west RDMA traffic. If SMB Direct cannot be natively disabled cross-site or cross-subnet per flow, then:
    - One or more additional vNICs should be provisioned for Storage Replica
    - Storage Replica vNICs must have RDMA disabled using the PowerShell [Disable-NetAdapterRDMA](https://docs.microsoft.com/powershell/module/netadapter/disable-netadapterrdma) cmdlet because it is by definition cross-site and cross-subnet
    - Native RDMA adapters would need a vSwitch and vNICs for Storage Replica support in order to satisfy the site/subnet requirements above
    - Intra-site RDMA bandwidth requirements require knowing the bandwidth percentages per traffic type, as discussed in the **Traffic bandwidth allocation** section. This will ensure that appropriate bandwidth reservations and limits can be applied for east/west (node-to-node) traffic
- Live Migration and Storage Replica traffic must be SMB bandwidth-limited, otherwise they could consume all the bandwidth, starving the high-priority storage traffic. For more information, see the [Set-SmbBandwidthLimit](https://docs.microsoft.com/powershell/module/smbshare/set-smbbandwidthlimit) and [Set-SRNetworkConstraint](https://docs.microsoft.com/powershell/module/storagereplica/set-srnetworkconstraint) PowerShell cmdlets.

> [!NOTE]
> You need to convert bits into bytes when using the `Set-SmbBandwidthLimit` cmdlet.

## Node interconnect requirements

This section discusses specific networking requirements between server nodes in a site, called interconnects. Either switched or switchless node interconnects can be used and are supported:

- **Switched:** Server nodes are most commonly connected to each other via Ethernet networks that use network switches. Switches must be properly configured to handle the bandwidth and networking type. If using RDMA that implements the RoCE protocol, network device and switch configuration is important.
- **Switchless:** Server nodes can also be interconnected using direct Ethernet connections without a switch. In this case, each server node must have a direct connection with every other cluster node in the same site.

### Interconnects for 2-3 node clusters

These are the *minimum* interconnect requirements for single-site clusters having two or three nodes. These apply for each server node:

- One or more 1 Gb network adapter cards to be used for management functions
- One or more 10 Gb (or faster) network interface cards for storage and workload traffic
- Two or more network connections between each node recommended for redundancy and performance

### Interconnects for 4-node and greater clusters

These are the *minimum* interconnect requirements for clusters having four or more nodes, and for high-performance clusters. These apply for each server node:

- One or more 1 Gb network adapter cards to be used for management functions.
- One or more 25 Gb (or faster) network interface cards for storage and workload traffic. We recommend two or more network connections for redundancy and performance.
- Network cards that are remote-direct memory access (RDMA) capable: iWARP (recommended) or RoCE.

### Site-to-site requirements (stretched cluster)

When connecting between sites for stretched clusters, interconnect requirements within each site still apply, and have additional Storage Replica and Hyper-V live migration traffic requirements that must be considered:

- At least one 1 Gb RDMA or Ethernet/TCP connection between sites for synchronous replication. A 25 Gb connection is preferred.
- A network between sites with enough bandwidth to contain your I/O write workload and an average of 5ms round trip latency or lower for synchronous replication. Asynchronous replication doesn't have a latency recommendation.
- If using a single connection between sites, set SMB bandwidth limits for Storage Replica using PowerShell. For more information, see [Set-SmbBandwidthLimit](/powershell/module/smbshare/set-smbbandwidthlimit).
- If using multiple connections between sites, separate traffic between the connections. For example, put Storage Replica traffic on a separate network than Hyper-V live migration traffic using PowerShell. For more information, see [Set-SRNetworkConstraint](/powershell/module/storagereplica/set-srnetworkconstraint).

## Network port requirements

Ensure that the proper network ports are open between all server nodes both within a site and between sites (for stretched clusters). You'll need appropriate firewall and router rules to allow ICMP, SMB (port 445, plus port 5445 for SMB Direct), and WS-MAN (port 5985) bi-directional traffic between all servers in the cluster.

When using the Cluster Creation wizard in Windows Admin Center to create the cluster, the wizard automatically opens the appropriate firewall ports on each server in the cluster for Failover Clustering, Hyper-V, and Storage Replica. If using a different firewall on each server, open the following ports:

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
- ICMPv4 and ICMPv6 (if using the `Test-SRTopology` PowerShell cmdlet)

There may be additional ports required not listed above. These are the ports for basic Azure Stack HCI functionality.

## Network switch requirements

This section defines the requirements for physical switches used with Azure Stack HCI. These requirements list the industry specifications, organizational standards, and protocols that are mandatory for all Azure Stack HCI deployments. Unless otherwise noted, the latest active (non-superseded) version of the standard is required.

These requirements help ensure reliable communications between nodes in Azure Stack HCI cluster deployments. Reliable communications between nodes are critical. To provide the needed level of reliability for Azure Stack HCI requires that switches:

- Comply with applicable industry specifications, standards, and protocols
- Provide visibility as to which specifications, standards, and protocols the switch supports
- Provide information on which capabilities are enabled

Make sure you ask your switch vendor if your switch supports the following:

#### Standard: IEEE 802.1Q

Ethernet switches must comply with the IEEE 802.1Q specification that defines VLANs. VLANs are required for several aspects of Azure Stack HCI and are required in all scenarios.

#### Standard: IEEE 802.1Qbb

Ethernet switches must comply with the IEEE 802.1Qbb specification that defines Priority Flow Control (PFC). PFC is required where Data Center Bridging (DCB) is used. Since DCB can be used in both RoCE and iWARP RDMA scenarios, 802.1Qbb is required in all scenarios. A minimum of three Class of Service (CoS) priorities are required without downgrading the switch capabilities or port speed.

#### Standard: IEEE 802.1Qaz

Ethernet switches must comply with the IEEE 802.1Qaz specification that defines Enhanced Transmission Select (ETS). ETS is required where DCB is used. Since DCB can be used in both RoCE and iWARP RDMA scenarios, 802.1Qaz is required in all scenarios. A minimum of three CoS priorities are required without downgrading the switch capabilities or port speed.

#### Standard: IEEE 802.1AB

Ethernet switches must comply with the IEEE 802.1AB specification that defines the Link Layer Discovery Protocol (LLDP). LLDP is required for Windows to discover switch configuration. Configuration of the LLDP Type-Length-Values (TLVs) must be dynamically enabled. These switches must not require additional configuration.

For example, enabling 802.1 Subtype 3 should automatically advertise all VLANs available on switch ports.

#### TLV Requirements

LLDP allows organizations to define and encode their own custom TLVs. These are called Organizationally Specific TLVs. All Organizationally Specific TLVs start with an LLDP TLV Type value of 127. The following table shows which Organizationally Specific Custom TLV (TLV Type 127) subtypes are required and which are optional:

|Condition|Organization|TLV Subtype|
|-|-|-|
|Required|IEEE 802.1|VLAN Name (Subtype = 3)|
|Required|IEEE 802.3|Maximum Frame Size (Subtype = 4)|
|Optional|IEEE 802.1|Port VLAN ID (Subtype = 1)|
|Optional|IEEE 802.1|Port And Protocol VLAN ID (Subtype = 2)|
|Optional|IEEE 802.1|Link Aggregation (Subtype = 7)|
|Optional|IEEE 802.1|Congestion Notification (Subtype = 8)|
|Optional|IEEE 802.1|ETS Configuration (Subtype = 9)|
|Optional|IEEE 802.1|ETS Recommendation (Subtype = A)|
|Optional|IEEE 802.1|PFC Configuration (Subtype = B)|
|Optional|IEEE 802.1|EVB (Subtype = D)|
|Optional|IEEE 802.3|Link Aggregation (Subtype = 3)|

> [!NOTE]
> Some of the optional features listed may be required in the future.

## Next steps

- Brush up on failover clustering basics. See [Failover Clustering Networking Basics](https://techcommunity.microsoft.com/t5/failover-clustering/failover-clustering-networking-basics-and-fundamentals/ba-p/1706005?s=09)
- Brush up on using SET. See [Remote Direct Memory Access (RDMA) and Switch Embedded Teaming (SET)](https://docs.microsoft.com/windows-server/virtualization/hyper-v-virtual-switch/rdma-and-switch-embedded-teaming)
- For deployment, see [Create a cluster using Windows Admin Center](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster)
- For deployment, see [Create a cluster using Windows PowerShell](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster-powershell)