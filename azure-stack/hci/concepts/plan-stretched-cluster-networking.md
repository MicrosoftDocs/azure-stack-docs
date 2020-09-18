---
title: Plan host networking for Azure Stack HCI
description: Learn how to plan host networking for Azure Stack HCI clusters
author: v-dasis
ms.topic: how-to
ms.date: 08/20/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Plan host networking for Azure Stack HCI

> Applies to Azure Stack HCI version 20H2

This topic discusses planning considerations and requirements for host networking in both non-stretched and stretched cluster environments.

## About RDMA

Remote direct memory access (RDMA) is a direct memory access from the memory of one computer into that of another without involving either one's operating system. This permits high-throughput, low-latency networking, which is especially useful in clusters. RDMA lowers CPU usage and increases throughput while keeping CPU usage down.

All host RDMA traffic leverages SMB Direct as the RDMA transport and is multiplexed over port 445.  A minimum of two PFC enabled TCs must be used for RDMA (RoCE) traffic to remain compatible with the majority of current and future physical Switches on the market.

Internet Wide Area RDMA Protocol (iWARP) runs RDMA over TCP, while RDMA over Converged Ethernet (RCoE) avoids the use of TCP, but requires both NICs and physical switches that support it.

## About SMB

Server Message Block (SMB) is used by Azure Stack HCI. SMB on HCI supports the following traffic types:

- Storage Bus Layer (SBL) - used by Storage Spaces Direct; highest priority traffic
- Cluster Shared Volumes (CSV)
- Live Migration (LM)
- Storage Replica (SR) - used in stretched clusters
- File Shares (FS traditional and SOFS)
- Cluster heartbeat (HB)

SMB can flow over the following protocols:

- TCP (default)
- RDMA (per flow)
- QUIC (future)

## Requirements

- All traffic between subnets and between sites (stretched clusters) must use WinSock TCP. Any intermediate network hops are outside of the view and control of Azure Stack HCI.
- RDMA between subnets and between sites (stretched clusters) is not supported. The use of uplinks and multiple network devices means multiple failure points where this could become unstable and unsupportable.
- No additional virtual NICs are needed for Storage Replica (stretched clusters). However for troubleshooting purposes, it may be useful to keep the cross-site and cross-subnet traffic separate from the east-west RDMA traffic. If SMBDirect cannot be natively disabled cross-site or cross-subnet per flow, then:
    - One or more additional vNICs should be provisioned for Storage Replica
    - Storage Replica vNICs must have RDMA disabled (using the PowerShell `Disable-NetAdapterRDMA` cmdlet) since it is by definition cross-site and cross-subnet
    - Native RDMA adapters would need a vSwitch and vNICs for Storage Replica support in order to satisfy the site/subnet requirements above
    - Intra-site RDMA bandwidth requirements require knowing the bandwidth percentages per traffic type, as discussed in the next section. This will ensure that appropriate bandwidth reservations and limits can be applied for east/west (node-to-node) traffic

## Traffic bandwidth allocation

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
- *= should use compression rather than RDMA if bandwidth allocation for LM traffic is < 5 Gbps

|NIC Speed|Teamed NIC Speed|SMB 50% Reservation|SBL/CSV %|SBL/CV Bandwidth|LM %|LM Bandwidth|SR % |SR Bandwidth|HB %|HB Bandwidth|
|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
|10|20|10|70%|7|14%*|1.4*|14%|1.4|2%|0.2|
|25|50|25|70%|17.5|15%*|3.75*|14%|3.5|1%|0.25|
|40|80|	40|70%|28|15%|6|14%|5.6|1%|0.4|
|50|100|50|70%|35|15%|7.5|14%|7|1%|0.5|
|100|200|100|70%|70|15%|15|14%|14|1%|1|
|200|400|200|70%|140|15%|30|14%|28|1%|2|

## Non-stretched cluster scenario

:::image type="content" source="media/plan-host-networking/rack-topology-non-stretched.png" alt-text="Create cluster wizard - HCI option" lightbox="media/plan-host-networking/rack-topology-non-stretched.png":::

>[!NOTE]
>

## Stretched cluster scenario

:::image type="content" source="media/plan-host-networking/rack-topology-stretched.png" alt-text="Create cluster wizard - HCI option" lightbox="media/plan-host-networking/rack-topology-stretched.png":::

Simple use case.

:::image type="content" source="media/plan-host-networking/simple-stretched-cluster.png" alt-text="Create cluster wizard - HCI option" lightbox="media/plan-host-networking/simple-stretched-cluster.png":::

## Next steps

- See [Create a cluster using Windows Admin Center]
- See [Create a cluster using Windows Powershell]