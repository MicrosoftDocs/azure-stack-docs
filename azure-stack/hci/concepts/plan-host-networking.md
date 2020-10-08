---
title: Plan host networking for Azure Stack HCI
description: Learn how to plan host networking for Azure Stack HCI clusters
author: v-dasis
ms.topic: how-to
ms.date: 10/06/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Plan host networking for Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2

This topic discusses planning considerations and requirements for host networking in both non-stretched and stretched Azure Stack HCI cluster environments.

For interconnect requirements, see the **Interconnect requirements between nodes** section in [Before you deploy Azure Stack HCI](https://docs.microsoft.com/azure-stack/hci/deploy/before-you-start#interconnect-requirements-between-nodes).

For network switch requirements, see the **Network switch requirements** section in  [Before you deploy Azure Stack HCI](https://docs.microsoft.com/azure-stack/hci/deploy/before-you-start#network-switch-requirements).

## SMB traffic support

Azure Stack HCI uses Server Message Block (SMB). SMB on Azure Stack HCI supports the following traffic types:

- Storage Bus Layer (SBL) - used by Storage Spaces Direct; highest priority traffic
- Cluster Shared Volumes (CSV)
- Live Migration (LM)
- Storage Replica (SR) - used in stretched clusters
- File Shares (FS) - FS traditional and Scale-Out File Server (SOFS)
- Cluster heartbeat (HB)
- Cluster communication (node joins, cluster updates, registry updates)

SMB traffic can flow over the following protocols:

- Transport Control Protocol (TCP) - default
- Remote direct memory access (RDMA) - per flow
- QUIC - future

## RDMA considerations

Remote direct memory access (RDMA) is a direct memory access from the memory of one computer into that of another without involving either computer's operating system. This permits high-throughput, low-latency networking while minimizing CPU usage, which is especially useful in clusters.

All host RDMA traffic takes advantage of SMB Direct. SMB Direct is SMB 3.0 traffic sent over RDMA, and that is multiplexed over port 445. A minimum of two Priority-based Flow Control (PFC) enabled traffic classes (TCs) must be used for RDMA traffic to remain compatible with the majority of current and future physical switches on the market.

Internet Wide Area RDMA Protocol (iWARP) runs RDMA over TCP, while RDMA over Converged Ethernet (RoCE) avoids the use of TCP, but requires both NICs and physical switches that support it.

RDMA is enabled by default for all east/west traffic between cluster nodes in a site on the same subnet. RDMA is disabled and not supported for north/south stretched cluster traffic between sites on different subnets.

These are the requirements for RDMA for Azure Stack HCI:

- All traffic between subnets and between sites (stretched clusters) must use WinSock TCP. Any intermediate network hops are outside of the view and control of Azure Stack HCI.
- RDMA between subnets and between sites (stretched clusters) is not supported. The use of uplinks and multiple network devices means multiple failure points where this could become unstable and unsupportable.
- No additional virtual NICs are needed for Storage Replica traffic for stretched clusters. However for troubleshooting purposes, it may be useful to keep the cross-site and cross-subnet traffic separate from the east-west RDMA traffic. If SMB Direct cannot be natively disabled cross-site or cross-subnet per flow, then:
    - One or more additional vNICs should be provisioned for Storage Replica
    - Storage Replica vNICs must have RDMA disabled using the PowerShell [Disable-NetAdapterRDMA](https://docs.microsoft.com/powershell/module/netadapter/disable-netadapterrdma) cmdlet because it is by definition cross-site and cross-subnet
    - Native RDMA adapters would need a vSwitch and vNICs for Storage Replica support in order to satisfy the site/subnet requirements above
    - Intra-site RDMA bandwidth requirements require knowing the bandwidth percentages per traffic type, as discussed in the **Traffic bandwidth allocation** section below. This will ensure that appropriate bandwidth reservations and limits can be applied for east/west (node-to-node) traffic
- Live Migration and Storage Replica traffic must be SMB bandwidth-limited, otherwise they could consume all the bandwidth, starving the storage traffic. For more information, see the [Set-SmbBandwidthLimit](https://docs.microsoft.com/powershell/module/smbshare/set-smbbandwidthlimit) and [Set-SRNetworkConstraint](https://docs.microsoft.com/powershell/module/storagereplica/set-srnetworkconstraint) PowerShell cmdlets.

> [!NOTE]
> You need to convert bits into bytes when using the `Set-SmbBandwidthLimit` cmdlet.
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

|NIC Speed|Teamed NIC Speed|SMB 50% Reservation|SBL/CSV %|SBL/CSV Bandwidth|LM %|LM Bandwidth|SR % |SR Bandwidth|HB %|HB Bandwidth|
|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
|10|20|10|70%|7|14%*|1.4*|14%|1.4|2%|0.2|
|25|50|25|70%|17.5|15%*|3.75*|14%|3.5|1%|0.25|
|40|80|	40|70%|28|15%|6|14%|5.6|1%|0.4|
|50|100|50|70%|35|15%|7.5|14%|7|1%|0.5|
|100|200|100|70%|70|15%|15|14%|14|1%|1|
|200|400|200|70%|140|15%|30|14%|28|1%|2|

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

## Standard cluster scenario

The following diagram shows a standard (non-stretched) cluster configuration with two clusters on the same subnet and same site. Server nodes communicate with each other in the same cluster using redundant network adapters connected to dual top-of-rack (TOR) switches. Cluster-to-cluster communications go through dual network spine devices.

:::image type="content" source="media/plan-host-networking/rack-topology-non-stretched-cluster.png" alt-text="Non-stretched cluster" lightbox="media/plan-host-networking/rack-topology-non-stretched-cluster.png":::

## Stretched cluster scenario

The following diagrams show stretched cluster configuration with a single cluster with server nodes located in different sites and subnets (four nodes per site). Server nodes communicate with each other in the same cluster using redundant network adapters connected to dual-connected TOR switches. Site-to-site communications go through dual routers using Storage Replica for failover.

:::image type="content" source="media/plan-host-networking/rack-topology-stretched-cluster.png" alt-text="Stretched cluster" lightbox="media/plan-host-networking/rack-topology-stretched-cluster.png":::

### Host networking option 1

The following diagram shows a stretched cluster that flows management, Live Migration, and Storage Replica traffic between sites on the same adapter. Use the [Set-SmbBandwidthLimit](https://docs.microsoft.com/powershell/module/smbshare/set-smbbandwidthlimit) and [Set-SRNetworkConstraint](https://docs.microsoft.com/powershell/module/storagereplica/set-srnetworkconstraint) PowerShell cmdlets to bandwidth-limit Live Migration and Storage Replica traffic respectively.

Remember that TCP is used for traffic between sites while RDMA is used for intra-site Live Migration storage traffic.

:::image type="content" source="media/plan-host-networking/stretched-cluster-option-1.png" alt-text="Host networking option 1" lightbox="media/plan-host-networking/stretched-cluster-option-1.png":::

### Host networking option 2

The following diagram shows a more advanced configuration for a stretched cluster that uses [SMB Multichannel](https://docs.microsoft.com/azure-stack/hci/manage/manage-smb-multichannel) for Storage Replica traffic between sites and a dedicated adapter for cluster management traffic. Use the [Set-SmbBandwidthLimit](https://docs.microsoft.com/powershell/module/smbshare/set-smbbandwidthlimit) and [Set-SRNetworkConstraint](https://docs.microsoft.com/powershell/module/storagereplica/set-srnetworkconstraint) PowerShell cmdlets to bandwidth-limit Live Migration and Storage Replica traffic respectively.

Remember that TCP is used for traffic between sites while RDMA is used for intra-site storage traffic.

:::image type="content" source="media/plan-host-networking/stretched-cluster-option-2.png" style="float:center" alt-text="Host networking option 2" lightbox="media/plan-host-networking/stretched-cluster-option-2.png":::

## Next steps

- Brush up on failover clustering basics. See [Failover Clustering Networking Basics](https://techcommunity.microsoft.com/t5/failover-clustering/failover-clustering-networking-basics-and-fundamentals/ba-p/1706005?s=09)
- For deployment, see [Create a cluster using Windows Admin Center](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster)
- For deployment, see [Create a cluster using Windows PowerShell](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster-powershell)