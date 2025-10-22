---
title: Azure Local rack aware cluster room-to-room connectivity (Preview)
description: Learn about Azure Local rack aware cluster room-to-room connectivity (Preview).
author: sipastak
ms.author: sipastak
ms.date: 10/22/2025
ms.service: azure-local
ms.topic: concept-article
---

# Azure Local rack aware cluster room-to-room connectivity (Preview)

Azure Local rack aware clusters require specialized room-to-room connectivity to enable storage replication and failover across availability zones. This article outlines four distinct configuration options (A, B, C, and D) for implementing room-to-room links, each optimized for different resilience, cost, and complexity requirements.

[!INCLUDE [important](../includes/hci-preview.md)]

Review the following key concepts:

- **Room-to-room links**: Physical network connections that span between separate rooms or availability zones, enabling RDMA (Remote Direct Memory Access) storage traffic, management, and compute workloads to traverse between zones for high availability and disaster recovery scenarios.

- **Storage intent traffic**: Dedicated RDMA network traffic using SMB1 and SMB2 protocols for Storage Spaces Direct (S2D) operations. This traffic requires low-latency, lossless connectivity to maintain cluster performance and data consistency.

- **Bandwidth requirements**: Room-to-room links must maintain a 1:1 bandwidth ratio between aggregate storage network capacity within a zone and inter-zone connectivity to prevent bottlenecks during storage operations and failover scenarios.


## Option A

:::image type="content" source="media/rack-aware-cluster-room-to-room-connectivity/room-to-room-link-option-a.png" alt-text="Screenshot of room-to-room link option A diagram." lightbox="media/rack-aware-cluster-room-to-room-connectivity/room-to-room-link-option-a.png":::

The diagram shows four Top-of-Rack (TOR) switches (TOR-1 to TOR-4). Each node is equipped with two physical network cards, totaling four interfaces.

One network card uses NIC teaming for management and compute network intents, creating an aggregated link with Switch Embedded Teaming (SET). The second network card manages storage intents (SMB1, SMB2) traffic, with each interface tagged with a single VLAN.

For storage intents, the switch ports have one VLAN tag per interface, whereas the management or compute interfaces' ports support all nonstorage VLAN tags. The TOR switches use Multi-Chassis Link Aggregation (MLAG) for management and compute traffic, but not for storage traffic, to reduce hops in RDMA sessions due to its low-latency, lossless nature.

There are two independent sets of bundled links to support room-to-room link traffic:

- SMB1 is supported by a link between TOR1 and TOR3.
- SMB2 is supported by a link between TOR2 and TOR4.

> [!Note]
> Storage intents are intentionally omitted on certain TOR devices and are not universally applied. The rack aware cluster follows the standard hyperconverged infrastructure disaggregated network design, where Node Storage Interfaces support only one storage intent per interface. This configuration was tested using Multiple Spanning Tree Protocol (MSTP). Storage VLANs are grouped into one spanning tree group, while non-storage VLANs are in a different STP group. During MSTP configuration, the spine switches needed to include the storage STP group even though they did not support those VLANs.

### Room-to-room link configurations

The following configuration example shows the room-to-room port-channel setup for **Option A**. Each TOR switch hosts a specific storage VLAN, creating dedicated paths for storage traffic between rooms.

Configuration details:

- **TOR1**: Hosts SMB1 traffic using VLAN 711 on port-channel 700.
- **TOR2**: Hosts SMB2 traffic using VLAN 712 on port-channel 701.
- **Room-to-room links**: TOR1 ↔ TOR3 (VLAN 711), TOR2 ↔ TOR4 (VLAN 712).

```console
interface port-channel700
  description room-to-room PO TOR1-TOR3 SMB1
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711
  priority-flow-control mode on
  mtu 9216
  service-policy type qos input AZS_SERVICES
```

> [!NOTE]
> This configuration shows port-channel 700 carrying VLAN 711 (SMB1) traffic between TOR1 and TOR3. TOR2 would use an identical configuration with port-channel 701 and VLAN 712 (SMB2) for its connection to TOR4.

### Ethernet interface configuration

This configuration is used to create a high-bandwidth redundant link between two network rooms, ensuring that traffic can flow efficiently and reliably between them.

```console
interface Ethernet1/51
  description room-to-room plink
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711
  priority-flow-control mode on
  mtu 9216
  channel-group 700
  no shutdown
!
interface Ethernet1/52
  description room-to-room plink
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711
  priority-flow-control mode on
  mtu 9216
  channel-group 700
  no shutdown
```


|Parameter/setting |Description  |
|---------|---------|
| `interface Ethernet1/51 and interface Ethernet1/52`| Defines physical Ethernet interfaces Ethernet1/51 and Ethernet1/52. |
| `switchport mode trunk` | Configures the interfaces to operate in trunk mode. |
| `switchport trunk native vlan 99` | Specifies VLAN 99 as the native VLAN to black hole traffic. |
| `switchport trunk allowed vlan 711` | Specifies that only VLAN 711 traffic is allowed on these trunk links. |
| `priority-flow-control mode on` | Enables priority flow control on these interfaces as well. |
| `mtu 9216` | Sets the MTU to 9,216 bytes. |
| `channel-group 700` | Adds these interfaces to the port channel group 700, effectively bundling them into a single logical link. |
| `no shutdown` | Ensures that the interfaces are active and not administratively shut down. |


## Option B 

:::image type="content" source="media/rack-aware-cluster-room-to-room-connectivity/room-to-room-link-option-b.png" alt-text="Screenshot of room-to-room link option B diagram." lightbox="media/rack-aware-cluster-room-to-room-connectivity/room-to-room-link-option-b.png":::

Option B operates similarly to Option A in a disaggregated setup. RDMA storage traffic uses interfaces SMB1 and SMB2. The key differences are:

- **TOR1 and TOR2**: Two port-channels (700, 701) connect across rooms, supporting VLANs SMB1, SMB2. VPC is used for MLAG service, with each port-channel assigned to a corresponding VPC group.
- **TOR3**: A single port-channel 700 connects to TOR1 and TOR2, assigned to VPC identifier 700.
- **TOR4**: A single port-channel 701 connects to TOR1 and TOR2, assigned to VPC identifier 701.

In-room TOR-to-TOR MLAG links support VLANs 7, 8, 711, and 712, forming a full mesh:

- TOR1 connects to TOR3 and TOR4.
- TOR2 connects to TOR3 and TOR4.

Room-to-room link traffic occurs in two scenarios based on the link hashing algorithm:

- Direct room-to-room connection without MLAG traversal.
- Room-to-room connection with MLAG traversal, potentially increasing latency.

### Configuration context and implementation

Option B uses a more complex but highly resilient design using Virtual Port Channel (vPC) technology. This configuration provides load balancing and redundancy for room-to-room storage traffic while maintaining the disaggregated storage approach.

**Key design elements:**

- **vPC domain**: TOR1 and TOR2 form a vPC domain in room 1.
- **Peer-link**: Port-channel 101 synchronizes state between vPC peers.
- **Dual-homed connections**: Room 2 switches connect to both room 1 switches.
- **Load distribution**: Traffic is distributed across multiple paths.

### TOR1-TOR4 VPC configuration example

The vPC domain configuration is the foundation of the Option B design, letting two physical switches (TOR1 and TOR2) operate as a single logical entity. This configuration uses a dedicated physical link for peer-keepalive communication, providing more reliable heartbeat detection than management network connectivity.

**TOR1 configuration:**

```console
interface Ethernet1/47
  description vPC-Peer-Keepalive-Link
  no switchport
  ip address 192.168.100.1/30
  no shutdown
!
vpc domain 2
  peer-switch
  role priority 1
  peer-keepalive destination 192.168.100.2 source 192.168.100.1 vrf default
  delay restore 150
  peer-gateway
  auto-recovery
```

**TOR2 configuration:**

```console
interface Ethernet1/47
  description vPC-Peer-Keepalive-Link
  no switchport
  ip address 192.168.100.2/30
  no shutdown
!
vpc domain 2
  peer-switch
  role priority 2
  peer-keepalive destination 192.168.100.1 source 192.168.100.2 vrf default
  delay restore 150
  peer-gateway
  auto-recovery
```

**interface Ethernet1/47 configuration:**

- **no switchport**: Configures the interface as a Layer 3 routed interface.
- **ip address 192.168.100.1/30**: Assigns point-to-point IP addressing.
  - **TOR1**: 192.168.100.1/30
  - **TOR2**: 192.168.100.2/30
- **Dedicated link benefits**: Provides independent heartbeat path separate from data traffic.

**vpc domain 2:**

- **Purpose**: Establishes vPC domain with identifier 2 (must match on both peer switches).
- **Scope**: All vPC-related configurations reference this domain ID.
- **Best Practice**: Use consistent domain IDs across the data center for operational clarity.

**peer-switch:**

- **Function**: Enables Spanning Tree Protocol (STP) optimization by allowing both switches to act as the root bridge.
- **Benefit**: Eliminates STP convergence delays and blocked ports in the vPC domain.
- **Requirement**: Must be configured on both vPC peers for proper operation.

**role priority (1 vs 2):**

- **TOR1 primary**: `role priority 1` (lower value = higher priority)
- **TOR2 secondary**: `role priority 2` (higher value = lower priority)
- **Function**: Determines which switch becomes the vPC primary for control plane operations.
- **Impact**: Primary switch handles initial configuration sync and certain forwarding decisions.

**peer-keepalive with dedicated link:**

- **TOR1**: `destination 192.168.100.2 source 192.168.100.1`
- **TOR2**: `destination 192.168.100.1 source 192.168.100.2`
- **Function**: Establishes heartbeat mechanism between vPC peers via dedicated physical link.
- **Advantage**: Independent of management network and data plane traffic.
- **Reliability**: Direct physical connection provides better failure detection.

**delay restore 150:**

- **Function**: Delays vPC restoration after peer-link recovery.
- **Duration**: 150-seconds delay before resuming normal vPC operations.
- **Purpose**: Prevents traffic disruption during transient link flaps.
- **Benefit**: Allows network convergence to complete before restoring dual-active mode.

**peer-gateway:**

- **Function**: Enables Layer 3 gateway redundancy for vPC-connected devices.
- **Capability**: Allows both switches to respond to ARP requests for the same gateway IP.
- **Use Case**: Critical for hosts that perform gateway MAC address caching.
- **Advantage**: Removes the need for additional gateway protocols like HSRP/VRRP.

**auto-recovery:**

- **Function**: Automatically recovers from split-brain scenarios.
- **Trigger**: Activates when peer-keepalive is restored after peer-link failure.
- **Behavior**: Automatically brings vPC ports out of suspended state.
- **Safety**: Prevents permanent network partitioning in failure recovery scenarios.

> [!NOTE]
> **Dedicated link:**
> The peer-keepalive dedicated link (Ethernet1/47) is part of the test environment and isn't a required configuration.

### TOR1-TOR4 VLAN configurations

The VLAN configuration establishes the Layer 2 broadcast domains required for the rack aware cluster. Each VLAN serves a specific network intent and must be consistently configured across all participating switches.

```console
vlan 1-2,7-8,99,711-712
vlan 2
  name UNUSED_VLAN
vlan 7
  name Management_7
vlan 8
  name Compute_8
vlan 99
  name NativeVlan
vlan 711
  name Storage_711_TOR1
vlan 712
  name Storage_712_TOR2
```

|VLAN  |Description |
|---------|---------|
| VLAN 1 | Default VLAN (typically unused in production). |
| VLAN 2 | Assigned to unused ports for traffic security. |
| VLAN 7 (Management_7) | Azure Local cluster management traffic. |
| VLAN 8 (Compute_8) |  Virtual machine and workload traffic. |
| VLAN 99 (NativeVlan) | Blackhole VLAN for untagged traffic security. |
| VLAN 711 (Storage_711)  | SMB1 RDMA storage traffic. |
| VLAN 712 (Storage_712) | SMB2 RDMA storage traffic. |


> [!NOTE]
> VLAN names include references to specific TOR switches for operational clarity, helping network administrators quickly identify which switch primarily handles each storage intent.

### TOR1/TOR2 MLAG (vPC peer-link) configuration

The vPC peer-link is critical for synchronizing MAC address tables, forwarding decisions, and ensuring consistent behavior between vPC peer switches. This link allows the two physical switches to appear as a single logical switch to downstream devices.

```console
interface Ethernet1/49
  description MLAG_Peer
  no cdp enable
  switchport
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 7-8,711-712
  logging event port link-status
  channel-group 101 mode active
  no shutdown

interface Ethernet1/50
  description MLAG_Peer
  no cdp enable
  switchport
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 7-8,711-712
  logging event port link-status
  channel-group 101 mode active
  no shutdown

interface port-channel101
  description VPC:MLAG_PEER
  switchport
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 7-8,711-712
  spanning-tree port type network
  logging event port link-status
  vpc peer-link
```

**Physical interface configuration (Ethernet1/49, Ethernet1/50):**

|Parameter/setting  | Description  |
|---------|---------|
| `no cdp enable`| Disables CDP to reduce unnecessary protocol overhead. |
| `channel-group 101 mode active`| Uses LACP for active port-channel negotiation. |
| `switchport trunk allowed vlan 7-8,711-712`| Carries all necessary VLANs for synchronization. |

**Port-channel configuration:**

|Parameter/setting | Description  |
|---------|---------|
| `vpc peer-link`| Designates this port-channel as the vPC peer-link. |
| `spanning-tree port type network`| Optimizes STP for inter-switch links. |
| `native VLAN 99`| Uses blackhole VLAN for security (drops untagged traffic). |

**Critical requirements:**

- Peer-link must carry all VLANs present in the vPC domain.
- Bandwidth should be sufficient to handle failover scenarios.
- Low latency is essential for proper vPC synchronization.

### TOR1/TOR2 room-to-room links

These configurations establish the physical connections that carry storage traffic between room 1 (vPC domain) and room 2 (individual switches). Each port-channel creates a logical connection to a specific room 2 switch while maintaining vPC redundancy.

```console
interface Ethernet1/53
  description Storage:TOR1-TOR3
  no cdp enable
  switchport
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711-712
  priority-flow-control mode on
  spanning-tree port type network
  mtu 9216
  no logging event port link-status
  channel-group 700 mode active
  no shutdown

interface Ethernet1/54
  description Storage:TOR1-TOR4
  no cdp enable
  switchport
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711-712
  priority-flow-control mode on
  spanning-tree port type network
  mtu 9216
  no logging event port link-status
  channel-group 701 mode active
  no shutdown

interface port-channel700
  description Storage:TOR1/TOR2 - TOR3
  switchport
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711-712
  priority-flow-control mode on
  spanning-tree port type network
  no logging event port link-status
  mtu 9216
  service-policy type qos input AZS_SERVICES
  vpc 700

interface port-channel701
  description Storage:TOR1/TOR2 - TOR4
  switchport
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711-712
  priority-flow-control mode on
  spanning-tree port type network
  no logging event port link-status
  mtu 9216
  service-policy type qos input AZS_SERVICES
  vpc 701
```

**Physical interface settings:**

|Parameter/setting |Description  |
|---------|---------|
| `Ethernet1/53` | Connects TOR1 to TOR3 (room 1 to room 2). |
| `Ethernet1/54` | Connects TOR1 to TOR4 (room 1 to room 2). |
| `priority-flow-control mode on` | Enables PFC for lossless RDMA traffic. |
| `mtu 9216` | Jumbo frames (required only for iWARP when hosts support it). |
| `switchport trunk allowed vlan 711-712` | Restricts to storage VLANs only. |

**vPC port-channel configuration:**

|Parameter/setting  |Description  |
|---------|---------|
| `vpc 700/701` | Associates port-channels with specific vPC IDs. |
| `service-policy type qos input AZS_SERVICES` | Applies RDMA QoS policy. |
| `no-stats` | Reduces CPU overhead by disabling detailed statistics. |
| `no-stats` | Reduces CPU overhead by disabling detailed statistics. |
| `spanning-tree port type network` | Optimizes for inter-switch connectivity. |

**Normal operation:**

- **Hash-based distribution**: Traffic is distributed between TOR1 and TOR2 based on flow hashing.
- **Direct forwarding**: Each vPC peer can forward traffic directly without peer-link traversal.
- **Load balancing**: Both storage VLANs (711, 712) utilize both room 1 switches.

**Failure scenarios:**

- **Single link failure**: Traffic automatically redistributes to remaining links.
- **Switch failure**: Surviving vPC peer handles all traffic for both port-channels.
- **Room-to-room link failure**: Traffic can traverse via alternate vPC peer and peer-link.

**Performance considerations:**

- **Latency optimization**: Direct paths minimize RDMA latency requirements (≤1 ms).
- **Bandwidth utilization**: vPC enables full utilization of available bandwidth.
- **Congestion management**: PFC prevents packet loss during congestion events.

> [!IMPORTANT]
> **vPC synchronization requirements:**
> Both TOR1 and TOR2 must maintain identical configurations for VLANs, QoS policies, and port-channel settings to ensure proper vPC operation. Configuration mismatches can result in traffic forwarding inconsistencies and potential loops.

## Option C

Option C represents the most simplified room-to-room design, consolidating both storage VLANs (711 and 712) onto a single TOR switch per availability zone. This approach reduces infrastructure complexity and cost while maintaining RDMA performance requirements for less critical environments.

:::image type="content" source="media/rack-aware-cluster-room-to-room-connectivity/room-to-room-link-option-c.png" alt-text="Screenshot of room-to-room link option C diagram." lightbox="media/rack-aware-cluster-room-to-room-connectivity/room-to-room-link-option-c.png":::


**Option C** is a configuration where a single top-of-rack (TOR) switch is utilized to support an availability zone. This configuration is typically deployed when redundant top-of-rack switches aren't required due to cost constraints, simplified management requirements, or reduced complexity needs. In this design, the room-to-room link carries both Storage 1 and Storage 2 network traffic for RDMA communications.

> [!WARNING]
> Loss of the single TOR switch due to maintenance or failure results in a complete outage for all nodes in the affected zone.

**Key design characteristics:**

- **Single TOR per zone**: Each availability zone uses only one TOR switch.
- **Consolidated storage traffic**: Both SMB1 (VLAN 711) and SMB2 (VLAN 712) traverse the same port-channel.
- **Simplified cabling**: Reduced physical infrastructure compared to Options A and B.
- **Cost optimization**: Fewer switches and links required for deployment.

### Room-to-room link configuration

**Port-channel and physical interface configuration:**

```console
interface port-channel700
  description room-to-room PO TOR1-TOR2 (SMB1,SMB2)
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711,712
  priority-flow-control mode on
  mtu 9216
  service-policy type qos input AZS_SERVICES

interface Ethernet1/51
  description room-to-room plink
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711,712
  priority-flow-control mode on
  mtu 9216
  channel-group 700
  no shutdown
!
interface Ethernet1/52
  description room-to-room plink
  switchport mode trunk
  switchport trunk native vlan 99
  switchport trunk allowed vlan 711,712
  priority-flow-control mode on
  mtu 9216
  channel-group 700
  no shutdown
```

**Configuration analysis:**

**Port-channel 700 configuration:**

- **description room-to-room PO TOR1-TOR2 (SMB1,SMB2)**: Clearly identifies the link purpose and supported storage intents.
- **switchport trunk allowed vlan 711,712**: Carries both storage VLANs on the same logical interface.
- **Consolidation benefit**: Single port-channel handles all storage traffic between zones.
- **Bandwidth aggregation**: Both storage VLANs share the available port-channel bandwidth.

**Physical interface configuration (Ethernet1/51, Ethernet1/52):**

|Parameter/setting  |Description  |
|---------|---------|
| `switchport trunk allowed vlan 711,712` | Both interfaces support both storage VLANs. |
| `channel-group 700` | Both interfaces bundled into the same port-channel. |
| `` | . |

- **Identical configuration**: Both interfaces are configured identically for load balancing.
- **Redundancy**: Link aggregation provides resilience against single link failure.

**RDMA specific settings:**

|Parameter/setting  |Description  |
|---------|---------|
| `priority-flow-control mode on` | Enables PFC for lossless RDMA traffic on both VLANs. |
| `service-policy type qos input AZS_SERVICES` | Applies consistent QoS treatment to both storage intents. |
| `mtu 9216` | Jumbo frame support (required only for iWARP when host nodes support it). |
| `switchport trunk native vlan 99` | Blackhole VLAN for security (drops untagged traffic). |

**Key differences between options A and B:**

**Simplified architecture:**

- **Single switch dependency**: Each zone relies on one TOR switch instead of two.
- **Consolidated bandwidth**: Both storage VLANs share port-channel bandwidth.
- **Reduced complexity**: No vPC, MLAG, or inter-switch coordination required.
- **Fewer configuration points**: Simpler troubleshooting and maintenance.

**Traffic flow characteristics:**

- **No load balancing between switches**: All traffic is handled by a single TOR per zone.
- **Direct path**: Storage traffic flows directly between room TOR switches.
- **Bandwidth sharing**: VLANs 711 and 712 compete for the same physical bandwidth.
- **Simplified forwarding**: No hash-based distribution across multiple switches.

**Advantages:**

- **Lower cost**: Fewer switches and cables required.
- **Simplified management**: Single point of configuration per zone.
- **Reduced power**: Lower power consumption with fewer active switches.
- **Easier troubleshooting**: Fewer components to diagnose.

**Limitations:**

- **Single point of failure**: Zone outage if TOR switch fails.
- **No redundancy**: No failover capability within a zone.
- **Maintenance impact**: Switch maintenance affects entire zone.

> [!IMPORTANT]
> **Bandwidth planning for option C:**
> Since both storage VLANs (711, 712) share the same port-channel bandwidth, ensure the room-to-room link capacity meets the combined storage traffic requirements from both intents. The 1:1 bandwidth ratio still applies but now covers the aggregate of both storage VLANs.

## Option D

:::image type="content" source="media/rack-aware-cluster-room-to-room-connectivity/room-to-room-link-option-d.png" alt-text="Screenshot of room-to-room link option D diagram." lightbox="media/rack-aware-cluster-room-to-room-connectivity/room-to-room-link-option-d.png":::

Option D differs from the other configurations by implementing cross-room direct node connections. In this design, nodes directly connect to switches in different rooms rather than relying solely on inter-switch room-to-room links for storage traffic.

### Architecture overview

- **Switch configuration**: Limited to two TOR switches (TOR1 and TOR2).
- **Room-to-room link**: Exists but is dedicated to management and compute intent traffic only (not used for SMB storage traffic).
- **Traffic distribution**:
  - **TOR1**: Services SMB1 traffic along with management and compute intent traffic.
  - **TOR2**: Services SMB2 traffic along with management and compute intent traffic.
- **Inter-Switch Connectivity**: LAG connection between TOR1 and TOR2 enables management and compute traffic to span between devices.

### Node connectivity pattern

Each node requires **4 physical links** to achieve the required connectivity:

**Room 1 nodes:**

- **Eth1**: Connected to local TOR1 (management/compute).
- **SMB1**: Connected to local TOR1 (storage).
- **Eth2**: Connected to remote TOR2 (management/compute).
- **SMB2**: Connected to remote TOR2 (storage).

**Room 2 nodes:**

- **Eth1**: Connected to remote TOR1 (management/compute).
- **SMB1**: Connected to remote TOR1 (storage).
- **Eth2**: Connected to local TOR2 (management/compute).
- **SMB2**: Connected to local TOR2 (storage).

This configuration ensures that storage traffic is distributed across both switches while maintaining redundant paths for management and compute workloads.

## Bandwidth requirements

The RDMA network VLANs (711 and 712) are connected by a set of bundled links to support room-to-room traffic. To support Storage Spaces Direct traffic, the room-to-room links require a **1:1 bandwidth ratio** between the aggregate storage network capacity within a zone and the inter-zone connectivity.

The required bandwidth for room-to-room links can be calculated using the following formula:

```
Bandwidth required = (NIC speed) × (storage ports per node) × (total ARC nodes per zone)
```

### Example configuration (2×2 environment)

Using a 2×2 configuration with 25-GbE storage NICs:

- **Storage interface speed**: 25 GbE per port
- **Storage ports per node**: 2 ports (one for VLAN 711, one for VLAN 712)
- **Total ARC nodes per zone**: 2 nodes
- **Calculation**: 25 GbE × 2 ports × 2 nodes = **100 GbE total bandwidth required**

### Network architecture details

Each server in the cluster has:

- A dual-port storage NIC with 2 interface ports.
- Port 1: Connected to VLAN 711.
- Port 2: Connected to VLAN 712.
- Each port operates at the specified link speed (10 GbE or 25 GbE).

### Bandwidth requirements

The following table shows the bandwidth requirements.

| ARC nodes per zone | NIC Speed | Storage ports per node | Total bandwidth required |
| ------------------ | --------- | ---------------------- | ------------------------ |
| 1️                  | 10 GbE    | 2                      | 20 GbE                   |
| 2️                  | 10 GbE    | 2                      | 40 GbE                   |
| 3️                  | 10 GbE    | 2                      | 60 GbE                   |
| 4️                  | 10 GbE    | 2                      | 80 GbE                   |
| ➖                | ➖        | ➖                    | ➖                       |
| 1️                  | 25 GbE    | 2                      | 50 GbE                   |
| 2️                  | 25 GbE    | 2                      | 100 GbE                  |
| 3️                  | 25 GbE    | 2                      | 150 GbE                  |
| 4️                  | 25 GbE    | 2                      | 200 GbE                  |

### Implementation considerations

- The room-to-room links must provide sufficient aggregate bandwidth to handle the full storage traffic from all nodes in a zone.
- Link aggregation (bonding/teaming) might be required to achieve the calculated bandwidth requirements.

## Next steps

- [Prepare for rack aware cluster deployment](../deploy/rack-aware-cluster-deploy-prep.md)