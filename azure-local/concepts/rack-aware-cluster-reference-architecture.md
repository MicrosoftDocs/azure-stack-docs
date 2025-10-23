---
title: Azure Local rack aware cluster reference architecture (Preview)
description: Learn about the network design and configuration of an Azure Local rack aware cluster (Preview)
author: sipastak
ms.author: sipastak
ms.date: 10/03/2025
ms.service: azure-local
ms.topic: concept-article
---

# Azure Local rack aware cluster reference architecture (Preview)

> Applies to: Azure Local version 2510 and later

This article contains information about the network design and configuration of an Azure Local rack aware cluster. This configuration involves a single cluster where nodes are placed in different physical locations within a building.

The primary intent is to support factory environments where hardware must be isolated in different rooms due to regulatory requirements, safety protocols, or operational constraints. This isolation provides fault domain separation while maintaining cluster functionality for critical industrial workloads.

The rack aware cluster configuration can also support disaster recovery scenarios by placing different workloads in one or both locations. This configuration supports environments with or without software defined networking (SDN) or Layer 2 virtual networks.

[!INCLUDE [important](../includes/hci-preview.md)]

## Key network principles

The rack aware cluster setup is intended to support environments with up to 4+4 nodes, where the cluster is separated into two local availability zones with less than or equal to 1-ms latency between rooms. This low-latency requirement ensures that despite physical separation, the cluster maintains performance characteristics suitable for factory automation, real-time monitoring, and other time-sensitive industrial applications.

- RDMA (Remote Direct Memory Access) traffic doesn't traverse to the spine switch layer.
- RDMA traffic is dedicated to the Top of Rack (TOR) layer and can travel to neighboring TORs in different zones.
- Storage VLANs (711, 712) are Layer 2 broadcast domains without IP configuration.
- Room-to-room latency must be less than or equal to 1 ms for RDMA traffic.

The environment includes two spine devices spanning both rooms to support the rack aware cluster. These spine devices host two primary network intents: management and compute. The designs show a single compute intent, but multiple intents can be supported depending on customer requirements. Storage VLANs (711, 712) are exclusively hosted at the TOR layer and operate as Layer 2 broadcast domains without IP configuration.

> [!IMPORTANT]
>
> The network diagrams use simplified naming conventions that differ from the VLAN IDs referenced in this article:
>
> - **SMB1** in diagrams = **VLAN 711** (storage intent 1)
> - **SMB2** in diagrams = **VLAN 712** (storage intent 2)
> - **Management** in diagrams = **VLAN 7** (management intent)
> - **Compute** in diagrams = **VLAN 8** (compute intent)
>
> This naming convention in the diagrams focuses on the functional purpose rather than specific VLAN IDs for clarity.

## TOR switch architecture

The TOR switches operate as Layer 2 switches with the following connectivity paths:

- **Spine uplinks**: Carry management and compute traffic.
- **Storage links**: Support room-to-room S2D communication.
- **Room-to-room links**: Primary connectivity for RDMA traffic between zones.

**Core requirements:**

- Room-to-room links must support storage intent traffic between TOR devices.
- Management and compute network intents require Layer 2 extension to all TOR devices via the spine layer.
- RDMA room-to-room link latency must be less than or equal to 1ms.
- Minimum 10-GbE interfaces required for storage traffic with 25 GbE recommended for optimal performance.
- Jumbo frame support (MTU 9216) is required only for iWARP implementations when host nodes support jumbo frames.

The following switch capabilities are required:

- **Data Center Bridging (DCB)** support for lossless Ethernet.
- **Priority Flow Control (PFC)** for RDMA traffic classes.
- **Enhanced Transmission Selection (ETS)** for bandwidth allocation.
- **LLDP with DCB TLVs** for automated host configuration.
- **Spanning Tree Protocol (STP)** for storage/non-storage VLAN separation, MSTP (Multiple Spanning Tree Protocol) was utilized in the testing of this environment.

> [!IMPORTANT]
> **RDMA QoS requirement:**
> All interfaces that support RDMA (SMB) traffic are **required** to implement [QoS policies](https://github.com/ebmarquez/AzureLocal-Supportability/blob/main/TSG/Networking/Top-Of-Rack-Switch/Reference-TOR-QOS-Policy-Configuration.md). This includes both host-facing storage interfaces and room-to-room links carrying storage VLANs (711, 712). Proper QoS configuration is essential for maintaining lossless, low-latency RDMA performance across the cluster.

**Design considerations:**

- **Buffer allocation**: Ensure adequate buffer depth for PFC pause frame handling.
- **Port density**: Plan for four ports per node minimum (2x management/compute, 2x storage).
- **Power and cooling**: Account for higher power consumption in DCB-enabled switches.
- **Firmware compatibility**: Refer to [Physical Network Requirements for Azure Local](physical-network-requirements.md) for supported network devices and appropriate firmware levels.
- **RDMA protocol considerations**: RoCEv2 doesn't require jumbo frames; iWARP requires jumbo frames only when host nodes support them.

**RDMA traffic flow example:**
Node 1 RDMA NIC 1 → local TOR → room-to-room link → remote TOR → node 3 NIC 1 (total latency ≤ 1ms)

### Option A: Dedicated storage links

:::image type="content" source="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-diagrams-option-a.png" alt-text="Network diagram showing rack aware cluster design option A." lightbox="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-diagrams-option-a.png":::

This design features four TOR switches (TOR-1 through TOR-4) with the following characteristics:

**Node configuration:**

- Two physical network cards per node (four interfaces total).
- NIC 1: Switch Embedded Teaming (SET) for management (VLAN 7) and compute (VLAN 8) traffic.
- NIC 2: Dedicated storage interfaces with single VLAN tagging (711, 712).

**Switch configuration:**

- Storage interfaces: One VLAN tag per interface.
- Management/Compute interfaces: Support all nonstorage VLAN tags.
- Multi-Chassis Link Aggregation (MLAG) for management and compute traffic only.
- Storage traffic bypasses MLAG to minimize RDMA session hops.

**Room-to-room connectivity:**

- Two independent bundled link sets support room-to-room traffic.
- VLAN 711: Dedicated link between TOR1 and TOR3.
- VLAN 712: Dedicated link between TOR2 and TOR4.

> [!NOTE]
> Storage intents are intentionally distributed across specific TOR devices following the disaggregated network design principle. Each node's storage interface supports only one storage intent per interface. This configuration has been validated using Multiple Spanning Tree Protocol (MSTP) with separate spanning tree groups for storage and nonstorage VLANs.

### Option B: Aggregated storage links

:::image type="content" source="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-diagrams-option-b.png" alt-text="Network diagram showing rack aware cluster design option B." lightbox="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-diagrams-option-b.png":::

Option B implements a disaggregated setup similar to Option A but with aggregated storage connectivity:

**Storage configuration:**

- RDMA storage traffic uses SMB1 and SMB2 interfaces.
- TOR1 and TOR2: Two port-channels (700, 701) provide cross-room connectivity.
- Virtual Port Channel (vPC) provides MLAG services with Port-Channel to vPC mapping.

**Connectivity details:**

- **TOR3**: Single port-channel 700 connects to TOR1/TOR2 (vPC ID 700).
- **TOR4**: Single port-channel 701 connects to TOR1/TOR2 (vPC ID 701).

**In-room MLAG links:**
Full mesh connectivity supporting VLANs 7, 8, 711, and 712:

- TOR1 ↔ TOR2
- TOR3 ↔ TOR4

**Traffic patterns:**
Room-to-room traffic follows two scenarios based on link hashing algorithms:

- Direct room-to-room connection (optimal path)
   TOR1 ↔ TOR3
   TOR2 ↔ TOR4
- Room-to-room with MLAG traversal (potential latency increase)
   TOR1 ↔ TOR4 ↔ TOR3
   TOR2 ↔ TOR3 ↔ TOR4

### Option C: Single TOR per room

:::image type="content" source="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-diagrams-option-c.png" alt-text="Network diagram showing rack aware cluster design option C." lightbox="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-diagrams-option-c.png":::

Option C simplifies the architecture with a single TOR device per room.

**Key characteristics:**

- Single TOR per availability zone.
- SMB1 and SMB2 are hosted on the same TOR device.
- Room-to-room link can be redundant (bonded) carrying both storage VLANs.
- No TOR redundancy within zones.


**Uplink configuration:** Spine connectivity can be single or bundled links depending on the number of spine switches deployed.

While this option simplifies management and reduces complexity, it also creates a single point of failure per zone during maintenance or device failure.

### Option D: Cross-room node connectivity

:::image type="content" source="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-diagrams-option-D.png" alt-text="Network diagram showing rack aware cluster design option D." lightbox="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-diagrams-option-D.png":::

Option D represents a distributed design where nodes connect to TOR devices in both rooms.

**Node connectivity pattern (per node):**

- **SET team NIC 0**: Connects to local TOR1 (room 1).
- **SET team NIC 1**: Connects to remote TOR2 (room 2).
- **SMB1 NIC 0**: Connects to TOR1 (room 1).
- **SMB2 NIC 1**: Connects to TOR2 (room 2).

**Infrastructure requirements:**

- Dedicated fiber links for each node-to-TOR connection spanning rooms.
- Cross-room cabling for every node interface.
- TOR-to-TOR links support management and compute intent traffic.

**High availability options:**

- vPC/HSRP configuration for TOR-to-TOR links.
- HSRP-only configuration for simplified deployments.

## Room-to-room link configurations and requirements

For information on room-to-room link configurations, see [Room-to-room connectivity](rack-aware-cluster-room-to-room-connectivity.md).

## Host to switch configuration

### Option A and B

:::image type="content" source="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-in-room-option-a-and-b.png" alt-text="Network diagram showing option A and B." lightbox="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-in-room-option-a-and-b.png":::

Options A and B have similar configurations, featuring two TOR devices to support a room environment.

The management/compute NIC is configured as a Switch Embedded Teaming (SET) team, which requires only standard switch trunk configuration with the appropriate VLAN tags to support the environment.

**Management/compute interface configuration:**

```console
interface Ethernet1/1
  description Management-Compute-Host-Connection
  no cdp enable
  switchport
  switchport mode trunk
  switchport trunk native vlan 7
  switchport trunk allowed vlan 8
  spanning-tree port type edge trunk
  mtu 9216
  logging event port link-status
  no shutdown
```

**Storage interface configuration:**

```console
interface ethernet 1/15
  description Storage-Intent-SMB1-Host-Interface
  switchport
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711
  spanning-tree port type edge trunk
  mtu 9216
  service-policy type qos input AZS_SERVICES
  priority-flow-control mode on send-tlv
  logging event port link-status
  no shutdown
```

|Parameter/setting  | Description  |
|---------|---------|
| `switchport trunk native vlan 99` | Assigns a blackhole VLAN to capture any spurious untagged network traffic. |
| `switchport trunk allowed vlan 711` | Restricts trunk to carry only VLAN 711 traffic for this storage interface. |
| `service-policy type qos input AZS_SERVICES` | Applies QoS policy for RDMA traffic optimization. |
| `priority-flow-control mode on send-tlv` | Enables Priority Flow Control (PFC) with LLDP TLV transmission. |
| `spanning-tree port type edge trunk` | Optimizes STP for host-facing ports. |
| `mtu 9216` | Enables jumbo frames. Required only for iWARP when host nodes support jumbo frames. |


### Option C

:::image type="content" source="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-in-room-option-c.png" alt-text="Network diagram showing option C." lightbox="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-in-room-option-c.png":::

Option C utilizes a single TOR device supporting all Azure Local network intents (management, compute, SMB1, SMB2).

In a typical rack aware cluster configuration, storage intents are isolated to different TOR devices within a room. This simplified configuration consolidates all intents onto a single device while maintaining logical separation through different interfaces and VLANs.

See the following example of a complete single-node configuration:

**Management/compute interfaces (SET team):**

```console

interface ethernet 1/1
  description Management-Compute-Host-Connection-Primary
  no cdp enable
  switchport
  switchport mode trunk
  switchport trunk native vlan 7
  switchport trunk allowed vlan 8
  spanning-tree port type edge trunk
  mtu 9216
  logging event port link-status
  no shutdown
!
interface ethernet 1/2
  description Management-Compute-Host-Connection-Secondary
  no cdp enable
  switchport
  switchport mode trunk
  switchport trunk native vlan 7
  switchport trunk allowed vlan 8
  spanning-tree port type edge trunk
  mtu 9216
  logging event port link-status
  no shutdown
```

**Storage interfaces (SMB1 and SMB2):**

```console
interface ethernet 1/15
  description Storage-Intent-SMB1-Host-Interface
  switchport
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711
  spanning-tree port type edge trunk
  mtu 9216
  service-policy type qos input AZS_SERVICES
  priority-flow-control mode on send-tlv
  logging event port link-status
  no shutdown
!
interface ethernet 1/16
  description Storage-Intent-SMB2-Host-Interface
  switchport
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 712
  spanning-tree port type edge trunk
  mtu 9216
  service-policy type qos input AZS_SERVICES
  priority-flow-control mode on send-tlv
  logging event port link-status
  no shutdown
```

### Option D

:::image type="content" source="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-in-room-option-d.png" alt-text="Network diagram showing option D." lightbox="media/rack-aware-cluster-reference-architecture/rack-aware-cluster-in-room-option-d.png":::

Option D removes the requirement for room-to-room links supporting RDMA storage traffic. Instead, nodes directly cross-connect to TOR devices in both rooms. Each room maintains a single TOR, but that TOR has direct connections to all nodes in both rooms. This configuration requires additional fiber infrastructure but provides high availability through distributed connectivity.

**Key characteristics:**

- **TOR1 (room 1)**: Services management, compute, and SMB1 traffic.
- **TOR2 (room 2)**: Services management, compute, and SMB2 traffic.
- **Cross-room connectivity**: Each node connects to both TORs for redundancy.

See the following example of a TOR1 configuration:

```console
interface Ethernet1/1
  description Management-Compute-Cross-Room-Connection
  no cdp enable
  switchport
  switchport mode trunk
  switchport trunk native vlan 7
  switchport trunk allowed vlan 8
  spanning-tree port type edge trunk
  mtu 9216
  logging event port link-status
  no shutdown
!
interface ethernet 1/15
  description Storage-Intent-SMB1-Cross-Room-Interface
  switchport
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711
  spanning-tree port type edge trunk
  mtu 9216
  service-policy type qos input AZS_SERVICES
  priority-flow-control mode on send-tlv
  logging event port link-status
  no shutdown
```

## QoS Policy

The QoS configuration uses the Data Center Bridging (DCB) framework to establish a lossless, low-latency environment for RDMA traffic, encompassing both RoCEv2 and iWARP technologies.

> [!IMPORTANT]
> **Mandatory QoS implementation:**
> Apply QoS policies to all interfaces carrying RDMA (SMB) traffic, including:
>
> - Host-facing storage interfaces (VLAN 711, 712).
> - Room-to-room links supporting storage traffic.
> - Port-channels and aggregated links carrying storage VLANs.
>
> Without proper QoS policies, you can experience packet loss, performance degradation, and potential cluster instability.

**Default Azure Local configuration:**

- **RDMA traffic**: Assigned to Priority Flow Control (PFC) class 3.
- **Cluster heartbeat**: Assigned to PFC class 7 (highest priority).
- **Bandwidth allocation**: Minimum 50% reserved for RDMA traffic.
- **Cluster traffic reservation**: 1% for 25GbE interfaces, 2% for 10GbE interfaces.

**Key technologies:**

- **Priority Flow Control (PFC)**: Provides lossless transmission for critical traffic classes.
- **Enhanced Transmission Selection (ETS)**: Allocates bandwidth reservations for specific traffic classes.
- **Weighted Random Early Detection (WRED)**: Manages queue congestion by dropping lower-priority traffic.
- **Enhanced Congestion Notification (ECN)**: Prevents incast scenarios in RoCEv2 environments.

For environments supporting RoCEv2, ECN is implemented to prevent incast situations. When congestion is detected along the connection path between nodes, the DSCP field is marked, and the destination device instructs senders to reduce their traffic flow.

For more information, see [Azure Local QoS policy](https://github.com/ebmarquez/AzureLocal-Supportability/blob/main/TSG/Networking/Top-Of-Rack-Switch/Reference-TOR-QOS-Policy-Configuration.md).

## Software defined networking

Azure Local rack aware clusters support Software Defined Networking (SDN) implementations for advanced network virtualization and micro-segmentation requirements. SDN integration enables centralized network policy management and enhanced security isolation between workloads across availability zones.

For more information, see the [Software Defined Networking configuration guide](https://github.com/ebmarquez/AzureLocal-Supportability/blob/main/TSG/Networking/SDN-Express/HowTo-SDNExpress-SDN-Layer3-Gateway-Configuration.md).

## Next steps

- [Room-to-room connectivity](rack-aware-cluster-room-to-room-connectivity.md)