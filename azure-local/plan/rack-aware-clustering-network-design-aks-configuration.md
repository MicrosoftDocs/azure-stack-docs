---
title: AKS configuration considerations for network design for Rack Aware Cluster on Azure Local (Preview)
description: AKS configuration considerations for a Rack Aware Cluster on Azure Local (Preview).
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 04/01/2025
---

# AKS configuration for network design of Rack Aware Cluster on Azure Local (Preview)

Applies to: Azure Local 2504 or later

This article discusses considerations for the network design for the Rack Aware Cluster architecture on Azure Local.

[!INCLUDE [important](../includes/hci-preview.md)]

## About Rack Aware Cluster

The Rack Aware Cluster architecture is a hyper-converged infrastructure (HCI) solution that provides high availability and disaster recovery capabilities. It is designed to support workloads that require low latency and high throughput, making it suitable for various applications, including databases, analytics, and virtualization. <!--check if good-->

This article describes the network design and configuration of the Rack Aware Cluster architecture on Azure Local. The configuration involves a single cluster where the nodes are placed in different physical locations within a building. The intent is to support disaster recovery scenarios by placing different workloads in one or both locations. This configuration can support environments with or without Software Defined Networking (SDN), Layer 2 virtual networks, or Azure Kubernetes Service (AKS).

The Rack Aware Cluster setup is intended to support environments with up to 4 + 4 nodes, where the cluster is separated into two local availability zones with less than 1ms latency between the rooms. The network architecture requires the use of spine and top of rack (TOR) switch layers to support network traffic. Compute and management traffic are hosted at the spine layer, while Storage Spaces Direct Remote Direct Memory Access (RDMA) traffic is hosted at the TOR switch layer. RDMA traffic doesn't travel to the spine switch layer; it is dedicated to the TOR layer and can travel to its neighboring TOR in a different zone with a matching configuration.

## TOR switch design

At the top of the setup there are two spine devices that span both rooms supporting Rack Aware Cluster. These devices support Layer 2 and Layer 3 VLAN traffic for the system and host compute and management network intents.

The designs illustrate the use of a single compute intent, but can support multiple intents depending on the scenario. The Storage Spaces Direct virtual LANs (711 and 712) aren't hosted at the spine layer; rather they are only hosted at the TOR layer. The Storage Spaces Direct VLANs are Layer 2 broadcast domains, and the switch doesn't support IP in the VLAN configuration. Depending on the specific Azure Local deployment scenario, the spine switches can support configurations such as SDN and AKS.

The TOR switches are Layer 2 switches that have the following configuration paths: spine uplinks for the compute and management traffic, and storage for room-to-room Storage Spaces Direct communication. The Storage Spaces Direct traffic is not distributed to the spine. Each TOR switch has uplink connections to spine devices to distribute the compute and management intent traffic. The Storage Spaces Direct traffic is isolated on specific TOR switches.

### Requirements

There are a few requirements for the TOR configuration.

- A room-to-room link to support the storage intent traffic between the TOR switches. This link is the primary connectivity for RDMA traffic.

- Management and compute network intents require a Layer 2 network extension to all TOR switches via a spine layer.

- RDMA room-to-room link with a network latency of less than 1ms. In this example, Node 1 RDMA network interface (NIC) 1 is shown in red, travels to its local TOR, crosses the room-to-room link, arrives on the TOR in the next room, and continues to Node 3 NIC 1. The latency of this crossing takes less than 1ms.

#### Aggregated setup (option A)

:::image type="content" source="media/rack-aware-clustering-network-design/option-a.png" alt-text="Diagram showing aggregated setup for option A." lightbox="media/rack-aware-clustering-network-design/option-a.png":::

Option A illustrates four TOR switches (TOR1 to TOR4). Each machine is equipped with two physical network cards, totaling four interfaces. One network card utilizes NIC teaming for management (7) and compute (8) network intents, creating an aggregated link with Switch Embedded Teaming (SET). The second network card manages storage intents (711, 712) traffic, with each interface tagged with a single VLAN.

For storage intents, the switch ports have one VLAN tag per interface, whereas the management/compute interface ports support all non-storage VLAN tags. The TOR switches use Multi-Chassis Link Aggregation (MLAG) for management and compute traffic, but not for storage traffic, to reduce hops in RDMA sessions due to its low-latency, lossless nature. There are two independent sets of bundled links to support room-to-room link traffic: VLAN 711 is supported using a link between TOR1 and TOR3, and VLAN 712 is supported using a link between TOR2 and TOR4.

> [!NOTE]
> Storage intents are intentionally omitted on certain TOR devices and aren't universally applied. The rack aware cluster follows the standard hyper-converged infrastructure disaggregated network design, where storage interfaces support only one storage Intent per interface. This configuration was tested using Multiple Spanning Tree Protocol (MSTP). Storage VLANs are grouped into one spanning tree group, while non-storage VLANs are in a different STP group. During MSTP configuration, the spine switches needed to include the storage STP group even though they did not support those VLANs.

#### Disaggregated setup (option B)
:::image type="content" source="media/rack-aware-clustering-network-design/option-b.png" alt-text="Diagram showing disaggregated setup for option B." lightbox="media/rack-aware-clustering-network-design/option-b.png":::

Option B operates similarly to Option A in a disaggregated setup. RDMA storage traffic uses interfaces: 711 (red) and 712 (blue). Key differences are:

- **TOR1 and TOR2**: Two port-channels (700, 701) connect across rooms, supporting VLANs 711, 712. VPC is used for MLAG service, with each port-channel assigned to a corresponding VPC group.

- **TOR3**: A single port-channel 700 connects to TOR1 and TOR2, and is assigned to VPC identifier 700.

- **TOR4**: A single port-channel 701 connects to TOR1 and TOR2, and is assigned to VPC identifier 701.

In-room TOR-to-TOR MLAG links support VLANs 7, 8, 711, and 712, forming a full mesh:

- TOR1 connects to TOR3 and TOR4

- TOR2 connects to TOR3 and TOR4

Room-to-room link traffic occurs via two scenarios based on the link hashing algorithm:

- Direct room-to-room connection without MLAG traversal. 

- Room-to-room connection with MLAG traversal, potentially increasing latency.

### Failure considerations

Both Option A and Option B handle RDMA session failures. The source host queries the destination for all RDMA interfaces and connects using them. Data transfers across these interfaces, restarting the session if any packet is lost and reconnecting with available links. If a link or device fails, the connection continues at reduced capacity.

## Switched disaggregated design

In a standard switched disaggregated configuration (option B), the storage and compute/management intents are separated into different network interfaces. The storage intents have Quality of Service (QoS) applied.

**TOR1 VLANs**
- 711: Storage intent 1 (excluded from MLAG)
- 8: Compute intent
- 7: Management intent

**TOR2 VLANs**
- 712: Storage intent 2 (excluded from MLAG)
- 8: Compute intent
- 7: Management intent

:::image type="content" source="media/rack-aware-clustering-network-design/disaggregated-design.png" alt-text="Diagram switched disaggregated design." lightbox="media/rack-aware-clustering-network-design/disaggregated-design.png":::

*Figure: RDMA traffic doesn't cross between TORs. All NIC 1 traffic is exclusive to all NIC 1 interfaces. Same for NIC 2 interfaces.*

Each machine in the system has two network interfaces: one for storage intent 1 and another for storage intent 2. These RDMA-capable NICs, typically equipped with two interfaces each, are dedicated as follows: NIC1 connects to TOR1 and handles VLAN 711, while NIC2 connects to TOR2 and manages VLAN 712. The NICs are not teamed, so traffic from NIC1 remains on NIC1 and doesn't cross to NIC2. This setup uses the switch backplane, designed for non-blocking performance, optimal latency, and high throughput, which is crucial for protocols like RDMA. Each switch port that supports RDMA traffic is managed with QoS policies.

## Switch-to-host interface

Here is an example of a TOR1 or TOR3 switch to host interface.

:::image type="content" source="media/rack-aware-clustering-network-design/switch-host-interface.png" alt-text="Diagram showing switch host interface." lightbox="media/rack-aware-clustering-network-design/switch-host-interface.png":::

The configuration is shown for a storage intent switch interface connected to a storage host NIC. This setup applies to both Option A and Option B. The physical link connects to NIC1 on the host, supporting VLAN 711 of TOR1. The switch port is trunked with VLAN tag 711, and a QoS policy matching the host policy is assigned. See the Appendix for specific QoS settings.

```output
interface ethernet 1/x 
  description Storage Intent AZLocal Host Interface 
  switchport 
  switchport mode trunk 
.... 
  switchport trunk allowed vlan 711 
  service-policy type qos input AZS_SERVICES 
  priority-flow-control mode on send-tlv 
  no shutdown
```

- `interface ethernet 1/x`: Defines a physical Ethernet interface. 

- `description`: *Storage Intent AzLocal Host Interface*: Adds a description to the interface, indicating its purpose. 

- `switchport`: Configures the interface as a Layer 2 switching port. 

- `switchport mode trunk`: Sets the interface to operate in trunk mode, allowing it to carry traffic for multiple VLANs. 

- `switchport trunk allowed vlan 711`: Specifies that only VLAN 711 traffic is allowed on this trunk link. 

- `service-policy type qos input AZS_SERVICES`: Applies a QoS policy named `AZS_SERVICES` to the input traffic on this interface. 

- `priority-flow-control mode on send-tlv`: Enables priority flow control to manage traffic congestion on the interface and sends PFC information in the LLDP packets. 

- `no shutdown`: Ensures that the interface is active and not administratively shut down. 

### Room-to-room link requirements

The RDMA network VLAN (711 or 712) is connected by a set of bundled links to support room-to-room traffic.  To support the Storage Spaces Direct traffic, the room-to-room links require a 1:1 bandwidth ratio. Using a 2 x 2 configuration as an example, this ratio can be calculated as follows:

*(NIC speed) * (storage ports on a machine) * (total ARC nodes per zone) = bandwidth requirement*

Using the diagram as an example (25 GbE x 2 x 2) = 100 GbE:

- `Storage Interface Speed`: 25 GbE, the storage NIC has 2 ports each port supporting a link speed of 25 GbE. 

- `Storage ports on a single machine`: 2, each machine in this example has a Storage NIC with 2 Interface ports. One supports VLAN 711, the other supports VLAN 712. 

- `Total ARC nodes per zone`: 2, the example shows a 2 x 2 environment.

| ARC nodes in zone | NIC speed | Storage ports on machine | Bandwidth |
| --- | --- | --- | --- |  
| 1 | 10 | 2 | 20 GbE |
| 2 | 10 | 2 | 40 GbE |
| 3 | 10 |2 | 60 GbE |
| 4 | 10 | 2 | 80 GbE |
| 1 | 25 | 2 | 50 GbE |
| 2 | 25 | 2 | 100 GbE |
| 3 | 25 | 2 | 150 GbE |
| 4 | 25 | 2 | 200 GbE |

### Link requirements 

The room-to-room link must include a QoS policy matching the machine configuration for either RDMA over Converged Ethernet (RoCE) v2 or iWARP. Only matching VLANs that connect TOR to TOR, such as VLAN 711, are supported. 

The RDMA room-to-room link requires network latency of less than 1ms. For instance, Node 1 RDMA NIC 1 sends traffic to its local TOR switch, crosses the room-to-room link, reaches the TOR switch in the next room, and continues to node 3 NIC 1, all within 1ms. 

The link speed should match a 1:1 ratio, recommended as a bundled set of links based on bandwidth requirements. 

### Room-to-room link configuration -  Option A

:::image type="content" source="media/rack-aware-clustering-network-design/room-to-room-option-a.png" alt-text="Diagram showing room-to-room link configuration Option B.." lightbox="media/rack-aware-clustering-network-design/room-to-room-option-a.png":::

The syntax configures TOR1 or TOR3 to link network interfaces into a port channel on a switch. Here's what each part means: 

#### Port channel configuration 

```output
interface port-channel711  
  description room-to-room PO  
  switchport mode trunk  
  switchport trunk native vlan 99 
  switchport trunk allowed vlan 711  
  priority-flow-control mode on  
  mtu 9216  
  service-policy type qos input AZS_SERVICES
```

- `interface port-channel711`: Defines a logical interface named `port-channel711`. 

- `switchport mode trunk`: Configures the interface to operate in trunk mode, allowing it to carry traffic for multiple VLANs.

- `switchport trunk native vlan 99`: Specifies VLAN 99 as the native VLAN. This VLAN won't have its traffic tagged as it passes through the trunk. Traffic to this VLAN is black holed. 

- `switchport trunk allowed vlan 711`: Specifies that only VLAN 711 traffic is allowed on this trunk link. 

- `priority-flow-control mode on`: Enables priority flow control to manage traffic congestion on the interface. 

- `mtu 9216`: Sets the Maximum Transmission Unit (MTU) to 9216 bytes, which is typical for jumbo frames. 

- `service-policy type qos input AZS_SERVICES`: Applies a QoS policy named AZS_SERVICES to the input traffic on this interface. 

#### Ethernet interface configuration

```output
interface Ethernet1/51 
  description room-to-room plink 
  switchport mode trunk 
  switchport trunk native vlan 99 
  switchport trunk allowed vlan 711 
  priority-flow-control mode on 
  mtu 9216 
  channel-group 711 
  no shutdown 
! 
interface Ethernet1/52 
  description room-to-room plink 
  switchport mode trunk 
  switchport trunk native vlan 99 
  switchport trunk allowed vlan 711 
  priority-flow-control mode on 
  mtu 9216 
  channel-group 711 
  no shutdown
```

This configuration is used to create a high-bandwidth, redundant link between two rooms, ensuring that traffic can flow efficiently and reliably between them. 

- `interface Ethernet1/51 and interface Ethernet1/52`: Defines physical Ethernet interfaces Ethernet1/51 and Ethernet1/52. 

- `switchport mode trunk`: Configures the interfaces to operate in trunk mode. 

- `switchport trunk native vlan 99`: Specifies VLAN 99 as the native VLAN to black hole (dropped) traffic. 

- `switchport trunk allowed vlan 711`: Specifies that only VLAN 711 traffic is allowed on these trunk links. 

- `priority-flow-control mode on`: Enables priority flow control on these interfaces as well. 

- `mtu 9216`: Sets the MTU to 9216 bytes. 

- `channel-group 711`: Adds these interfaces to the port channel group 711, effectively bundling them into a single logical link. 

- `no shutdown`: Ensures that the interfaces are active and not administratively shut down. 

### Room-to-room link configuration - Option B 

:::image type="content" source="media/rack-aware-clustering-network-design/room-to-room-option-b.png" alt-text="Diagram showing room-to-room link configuration Option B." lightbox="media/rack-aware-clustering-network-design/room-to-room-option-b.png":::

#### TOR1 VPC configuration 

```output
vlan 711 
  name Storage_711_TOR1 
vlan 712 
  name Storage_712_TOR2 
! 
vpc domain 2 
  peer-switch 
  role priority 2 
  peer-keepalive destination <TOR2>.25 source <TOR1>.26 vrf default 
  delay restore 150 
  peer-gateway 
  auto-recovery
```

**VLAN configuration:** 

- `vlan 711`: name Storage_711_TOR1: This command creates VLAN 711 and names it "Storage_711_TOR1". 

- `vlan 712`: name Storage_712_TOR2: This command creates VLAN 712 and names it "Storage_712_TOR2". 

- `vlan 99`: This VLAN is a network container used to capture packets that are not tagged. The VLAN is shut down, and ports that are disconnected are configured with this VLAN. 

**VPC domain configuration:**

- `vpc domain 2`: This command defines the VPC domain with an ID of 2. 

- `peer-switch`: This command enables the peer-switch feature, which allows both VPC peers to act as the spanning-tree root. 

- `role priority 2`: This command sets the role priority for the VPC primary switch. The switch with the lower priority value becomes the primary switch. 

- `peer-keepalive destination <TOR2>.25 source <TOR1>.26 vrf default`: This command configures the VPC peer-keepalive link, which is used to monitor the health of the VPC peer link. The destination and source IP addresses are specified, along with the VRF (Virtual Routing and Forwarding) instance. 

- `delay restore 150`: This command sets the delay time (in seconds) before restoring the VPC after a peer link failure. 

- `peer-gateway`: This command enables the peer-gateway feature, which allows the VPC peers to act as the default gateway for packets that are destined for the VPC peer's MAC address. 

- `auto-recovery`: This command enables the auto-recovery feature, which allows the VPC secondary switch to assume the primary role if the primary switch fails and the peer link is down. 

### TOR1 port channel configuration

```output
interface port-channel700 
  description Storage:TOR1_To_TOR3 
  switchport 
  switchport mode trunk 
  switchport trunk native vlan 99 
  switchport trunk allowed vlan 711-712 
  priority-flow-control mode on 
  spanning-tree port type network 
  no logging event port link-status 
  mtu 9216 
  service-policy type qos input AZS_SERVICES no-stats 
  vpc 700 
interface port-channel701 
  description Storage:TOR4_To_N42R19-TOR1 
  switchport 
  switchport mode trunk 
  switchport trunk native vlan 99 
  switchport trunk allowed vlan 711-712 
  priority-flow-control mode on 
  spanning-tree port type network 
  no logging event port link-status 
  mtu 9216 
  service-policy type qos input AZS_SERVICES no-stats 
  vpc 701
```

**Port-channel 700 configuration:**

- `switchport`: This command enables Layer 2 switching on the interface. 

- `switchport mode trunk`: This command sets the interface to trunk mode, allowing it to carry multiple VLANs. 

- `switchport trunk native vlan 99`: This command sets VLAN 99 as the native VLAN for the trunk.  VLAN 99 is a network container used to capture untagged traffic and drop it. 

- `switchport trunk allowed vlan 711-712`: This command allows VLANs 711 and 712 on the trunk. 

- `priority-flow-control mode on`: This command enables priority flow control on the interface. 

- `spanning-tree port type network`: This command sets the spanning-tree port type to network. 

- `no logging event port link-status`: This command disables logging of link status changes. 

- `mtu 9216`: This command sets the maximum transmission unit (MTU) size to 9216 bytes. 

- `service-policy type qos input AZS_SERVICES no-stats`: This command applies a QoS service policy named `AZS_SERVICES` to the input traffic. 

- `vpc 700`: This command associates the port channel with VPC 700. 

#### Port channel 701 configuration:

The rest of the configuration is similar to port-channel 700, with the same commands applied. 

**TOR 1 room-to-room interface configuration**

```output
interface Ethernet1/53 
  description Storage:TOR1_To_(TOR3,TOR4) 
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
  description Storage:TOR1_To_(TOR3,TOR4) 
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
```

**interface Ethernet1/53 and interface Ethernet1/54**

- `no cdp enable`: This command disables Cisco Discovery Protocol (CDP) on the interfaces. 

The rest of the configuration is similar to the port-channel interfaces, with the same commands applied. 

- `channel-group 700 mode active`: This command adds the interfaces to port-channel 700 in active mode. 

- `no shutdown`: This command enables the interfaces. 

### TOR3 VPC configuration 

```output
vlan 711 
  name Storage_711_TOR3 
vlan 712 
  name Storage_712_TOR2 
! 
vpc domain 3 
  peer-switch 
  role priority 1 
  peer-keepalive destination 100.71.55.30 source 100.71.55.29 vrf default 
  delay restore 150 
  peer-gateway 
  auto-recovery
```

**VLAN configuration:**

- `vlan 711`: name Storage_711_TOR3: This command creates VLAN 711 and names it `Storage_711_TOR3`.  

- `vlan 712`: name Storage_712_TOR2: This command creates VLAN 712 and names it `Storage_712_TOR2`.  

- `vlan 99`: This VLAN is a network container used to capture packets that are not tagged. The VLAN is shut down, and ports that are disconnected are configured with this VLAN.

**VPC domain configuration:**

- `vpc domain 3`: This command defines the VPC domain with an ID of 3. 

- `peer-switch`: This command enables the peer-switch feature, which allows both VPC peers to act as the spanning-tree root. 

- `role priority 1`: This command sets the role priority for the VPC primary switch. The switch with the lower priority value becomes the primary switch. 

- `peer-keepalive destination 100.71.55.30 source 100.71.55.29 vrf default`: This command configures the VPC peer-keepalive link, which is used to monitor the health of the VPC peer link. The destination and source IP addresses are specified, along with the VRF (Virtual Routing and Forwarding) instance. 

- `delay restore 150`: This command sets the delay time (in seconds) before restoring the VPC after a peer link failure. 

- `peer-gateway`: This command enables the peer-gateway feature, which allows the VPC peers to act as the default gateway for packets that are destined for the VPC peer's MAC address. 

- `auto-recovery`: This command enables the auto-recovery feature, which allows the VPC secondary switch to assume the primary role if the primary switch fails and the peer link is down. 

### TOR3 port channel configuration

```output
interface port-channel700 
  description Storage:TOR3 - (TOR1,TOR2) 
  switchport 
  switchport mode trunk 
  switchport trunk native vlan 99 
  switchport trunk allowed vlan 711-712 
  priority-flow-control mode on 
  spanning-tree port type network 
  no logging event port link-status 
  mtu 9216 
  service-policy type qos input AZS_SERVICES no-stats 
```

**Port channel configuration:**

For `interface port-channel700`:

- `switchport`: This command enables Layer 2 switching on the interface. 

- `switchport mode trunk`: This command sets the interface to trunk mode, allowing it to carry multiple VLANs. 

- `switchport trunk native vlan 99`: This command sets VLAN 99 as the native VLAN for the trunk. 

- `switchport trunk allowed vlan 711-712`: This command allows VLANs 711 and 712 on the trunk. 

- `priority-flow-control mode on`: This command enables priority flow control on the interface. 

- `spanning-tree port type network`: This command sets the spanning-tree port type to network. 

- `no logging event port link-status`: This command disables logging of link status changes. 

- `mtu 9216`: This command sets the maximum transmission unit (MTU) size to 9216 bytes. 

- `service-policy type qos input AZS_SERVICES no-stats`: This command applies a QoS service policy named `AZS_SERVICES` to the input traffic.

### TOR3 room-to-room interface configuration

```output
interface Ethernet1/53 
  description Storage:TOR3-(TOR1,TOR2) 
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
  description Storage:TOR3-(TOR1,TOR2) 
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
```

**Ethernet interface configuration**

For interface Ethernet1/53 and interface Ethernet1/54:

- `no cdp enable`: This command disables Cisco Discovery Protocol (CDP) on the interfaces. 

The rest of the configuration is similar to the port-channel interfaces, with the same commands applied. 

- `channel-group 700 mode active`: This command adds the interfaces to port-channel 700 in active mode. 

- `no shutdown`: Enables interfaces.

## QoS

The QoS configuration applies the DCB framework to establish a lossless, low-latency setup for RDMA, encompassing both ROCE v2 and iWARP technologies. In the default Azure Local configuration, RDMA traffic is assigned to PFC ID 3. Another PFC ID is allocated for the system heartbeat, which by default uses PFC ID 7. PFC ID 7 is given the highest priority, while PFC ID 3 is also configured to support pause frames or function as a no-drop queue.

These two PFC IDs are mapped to specific traffic classes, with all other traffic, not marked by these PFC IDs, which are categorized as default traffic with the lowest priority. Additionally, Enhanced Transmission Selection (ETS) is employed to allocate bandwidth reservations for particular traffic classes. The default RDMA setting in Azure Local reserves a minimum of 50% of the interface bandwidth for RDMA traffic. System traffic is allocated 1% of bandwidth for 25Gb interfaces and 2% for 10Gb interfaces.

A policy map is used to facilitate Weighted Random Early Detection (WRED); when thresholds are exceeded, traffic associated with the default queue dropped. For environments that support ROCE v2, Enhanced Congestion Notification (ECN) is implemented to prevent incast situations. When congestion is detected along the connection path between nodes, a bit in the packet DSCP field is set by the network device and sent to the destination. The destination device then informs the sender to reduce their traffic flow. 

For QoS examples, see *Cisco switch configuration* and *Dell switch configuration* in the Appendix.

## SDN

### Software Load Balancing

:::image type="content" source="media/rack-aware-clustering-network-design/sdn-slb-configuration.png" alt-text="Diagram showing software load balancing." lightbox="media/rack-aware-clustering-network-design/sdn-slb-configuration.png":::

The Software Load Balancing (SLB) solution for Azure Local in a rack aware cluster consists of three network layers: spine, TOR, and SLB. In this setup, the spine is a combined Layer 2/Layer 3 BGP router that peers with the SLB. The TOR layer is a simple Layer 2 switch that enables BGP sessions to pass from the SLB to the spine. Each spine is configured with a Dynamic BGP configuration, allowing multiple SLBs to establish BGP sessions with the spines. The SLB uses the spine loopback IP address as the peering IP. In the spine BGP configuration, the update source is set to loopback 0. When the SLB establishes a BGP session with the spine, it advertises the VIP addresses provided by the network controller as host IP addresses. 

### BGP configuration

The provided BGP configuration is for setting up a BGP routing instance with specific parameters.  

```output
router bgp 64588 
  router-id 10.71.28.24 
  bestpath as-path multipath-relax 
  address-family ipv4 unicast 
    ...   
    network 10.68.212.0/24   
  ... 
  neighbor 10.68.212.0/24 
    description SDN:65000:ComputeIntent:10.68.212.0 
    remote-as 65000 
    update-source loopback0 
    ebgp-multihop 3 
```

- `router bgp 64588`: This command starts the BGP configuration process and assigns the autonomous system number (ASN) 64588 to this router. 

- `router-id 10.71.28.24`: This sets the BGP router ID to 10.71.28.24. The router ID is typically an IP address that uniquely identifies the router in the BGP network. 

- `bestpath as-path multipath-relax`: This command allows BGP to relax the criteria for selecting multiple paths for the same destination. It permits BGP to consider paths as multipaths even if their AS paths are different. 

- `address-family ipv4 unicast`: This specifies the address family for IPv4 unicast routing. All subsequent commands apply to this address family. 

- `network 10.68.212.0/24`: This command advertises the network 10.68.212.0/24 to other BGP peers. It tells BGP to include this network in its routing updates. 

- `neighbor 10.68.212.0/24`: Defines a BGP neighbor with the IP address 10.68.212.0/24. Typically, a neighbor IP address is a single IP rather than a subnet. Using the subnet allows the SLB/MUX to establish a Dynamic BGP peering with the Spine. The SLB/MUX starts the BGP peering session, and the Spine is a passive listener waiting for a BGP request to start. 

- `remote-as 65000`: Specifies that the neighbor at 10.68.212.0/24 belongs to the autonomous system 65000. This is necessary for establishing an external BGP (eBGP) session. 

- `update-source loopback0`: This command specifies that the BGP updates for this neighbor should use the IP address of the loopback0 interface as the source address. 

- `ebgp-multihop 3`: Allow eBGP sessions to be established with a TTL of 3 hops, which is useful if the eBGP peer is not directly connected.

This configuration sets up BGP on a router with ASN 64588, advertises the network 10.68.212.0/24, and establishes a BGP session with a neighbor in ASN 65000 using loopback 0 as the source interface. The multipath-relax option allows for more flexible path selection.

### SDN gateway

The SDN gateway is a virtual router hosted in the Azure Local cloud environment, designed to support multitenant Hyper-V virtual networks. The SDN gateway can be connected using either static routing or dynamic routing via BGP. In both cases, a virtual network is created within the Azure Local system, and the SDN gateway serves as the primary gateway for the network. A compute intent Provider Address (PA) network supports a single SDN gateway. 

In a static configuration, the switch/router has a static route to the endpoint, which acts as the next hop to reach the virtual network. This next hop is contained within the Compute Intent network. The static route is manually maintained in the switch/router route table.  In this configuration, the Switch Virtual Interface (SVI) PA network supporting the SDN gateway is maintained on the switch/router along with the Azure Local virtual network. 

In a dynamic configuration, BGP is used to dynamically advertise the virtual network to the switch/router. Once a BGP session is established, it advertises the virtual network subnet, and is injected into the switch/router route table.  In this instance, the same SVI is maintained to support the PA network, but the virtual network is not included in the configuration. This is received dynamically via BGP as a network advertisement. 

#### Common configurations

```output
vlan 202 
  name 202ComputeIntent:PA 
! 
interface vlan202 
  description 202ComputeIntent:PA 
  no shutdown 
  mtu 9216 
  ip address 10.68.40.2/24  
  no ip redirects 
hsrp version 2 
  hsrp 107 
    priority 150 forwarding-threshold lower 1 upper 150 
    ip 10.68.212.1
```

**VLAN configuration**

- `vlan 202`: Defines VLAN 202. 

- `name 202ComputeIntent:PA`: Assigns the name `202ComputeIntent:PA` to VLAN 202. 

**Interface VLAN configuration** 

- `interface vlan202`: Specifies the switch virtual interface for VLAN 202. 

- `description 202ComputeIntent:PA`: Adds a description to the interface. 

- `no shutdown`: Ensures the interface is active. 

- `mtu 9216`: Sets the Maximum Transmission Unit (MTU) to 9216 bytes, which is typical for jumbo frames. 

- `ip address 10.68.40.2/24`: Assigns the IP address 10.68.40.2 with a subnet mask of [address] to the interface. 

- `no ip redirects`: Disables ICMP redirects on the interface. 

**Hot Standby Router Protocol (HSRP) configuration**

- `hsrp version 2`: Configures HSRP version 2. 

- `hsrp 202`: Configures HSRP group 202. 

- `priority 150`: Sets the priority of this router to 150. 

- `forwarding-threshold lower 1 upper 150`: Specifies the thresholds for transitioning to the forwarding state. 

- `ip 10.68.40.1`: Sets the virtual IP address for the HSRP group. 

#### Static SDN gateway

:::image type="content" source="media/rack-aware-clustering-network-design/static-sdn-gateway.png" alt-text="Diagram showing static SDN gateway." lightbox="media/rack-aware-clustering-network-design/static-sdn-gateway.png":::

```output
ip route 10.10.50.0/24 10.68.40.6 name AZLOCAL/VNET/AccntSvc 
ip route 0.0.0.0/0 10.8.8.2/30 name CoreNet/DefaultRoute 
ip route 0.0.0.0/0 10.8.9.2/30 name CoreNet/DefaultRoute
```

- `ip route 10.10.50.0/24 10.68.40.6 name AZLOCAL/VNET/AccntSvc`: Adds a static route for the network 10.10.50.0/24 with the next hop 10.68.40.6 and names it `AZLOCAL/VNet/AccountingServices`. The next hop 10.68.40.6 is the gateway service that is acting as the gateway to the VNET 10.10.50.0/24.  Each TOR in the environment has the same configuration. 

- `ip route 0.0.0.0/0 10.8.8.2/30 name CoreNet/DefaultRoute`: Adds a default route with the next hop 10.8.8.2/30 and names it `CoreNet/DefaultRoute` 

- `ip route 0.0.0.0/0 10.8.9.2/30 name CoreNet/DefaultRoute`: Adds another default route with the next hop 10.8.9.2/30 and names it `CoreNet/DefaultRoute`. 

#### Dynamic SDN gateway

:::image type="content" source="media/rack-aware-clustering-network-design/dynamic-sdn-gateway.png" alt-text="Diagram showing dynamic SDN gateway." lightbox="media/rack-aware-clustering-network-design/dynamic-sdn-gateway.png":::

```output
interface loopback0 
  ip address 10.71.5.5/32 
router bgp 64512 
  router-id 10.71.5.5 
  bestpath as-path multipath-relax 
  address-family ipv4 unicast 
    ... 
    network 10.71.5.5/32 
    network 10.68.40.0/24  
  ... 
  neighbor 10.68.40.0/24 
    description SDN:65500:202ComputeIntent:PA 
    remote-as 65500 
    ebgp-multihop 3
```

This configuration sets up BGP on a router with ASN 64588, advertises the network 10.68.40.0/24, and establishes a BGP session with a neighbor in ASN 65500 using loopback 0 as the source interface. The multipath-relax option allows for a more flexible path selection. 

- `router bgp 64512`: Starts the BGP configuration process and assigns the autonomous system number (ASN) 64512 to this router. 

- `router-id 10.71.5.5`: Sets the BGP router ID to 10.71.5.5. The router ID is typically an IP address that uniquely identifies the router in the BGP network. 

- `bestpath as-path multipath-relax`: Allows BGP to relax the criteria for selecting multiple paths for the same destination. 

- `address-family ipv4 unicast`: Specifies the address family for IPv4 unicast routing. 

- `network 10.68.40.0/24`: Advertises the PA network 10.68.40.0/24 to other BGP peers. This contains the next hop to the Virtual network and the SDN Gateway will advertise. 

- `neighbor 10.68.40.0/24`: Defines a BGP neighbor with the IP address 10.68.40.0/24. 

- `description SDN:65500:202ComputeIntent:PA`: Adds a description for the BGP neighbor. 

- `remote-as 65500`: Specifies that the neighbor belongs to the autonomous system 65500. 

- `ebgp-multihop 3`: Allows eBGP sessions to be established with a TTL of 3 hops. 

### AKS

In an AKS configuration, Layer 2 and Layer 3 scenarios are supported. Layer 2 uses the spine Layer 3 services to access the network. The compute intent network is the VLAN that is used to connect to the router and network. MetalLB refers to a load-balancer implementation for bare metal Kubernetes clusters, with nodes referred to as K8.

#### MetalLB Layer 2

:::image type="content" source="media/rack-aware-clustering-network-design/load-balancer-l2.png" alt-text="Diagram showing metalLB Layer 2." lightbox="media/rack-aware-clustering-network-design/load-balancer-l2.png":::

In a Layer 2 configuration, the AKS load balancer uses ARP in Layer 2 networking to reach the network. The switch/router is a primary gateway for the Azure Local system and provides the Layer 3 services to AKS.  The MetalLB system uses ARP to network allowing its IP address to be reachable.  The IP pool of the MetalLB service is required to be in the same subnet as the Kubernetes K8 nodes.  

#### AKS MetalLB Layer 3

:::image type="content" source="media/rack-aware-clustering-network-design/load-balancer-bgp.png" alt-text="Diagram showing metalLB Layer 3 BGP." lightbox="media/rack-aware-clustering-network-design/load-balancer-bgp.png":::

In a Layer 3 configuration, the switch/router (spine) acts as a BGP router that the Azure Local AKS MetalLB service uses to connect using BGP. The spine enables dynamic BGP as the peering neighbor for the compute intent 10.68.40.0/26. Any IP address used by AKS within the compute intent network can be used if it uses the configured BGP AS number on the spine. In this example, the spine AS number is 64512, with a router ID of Y.Y.5.5. The spine advertises the x.x.40.0/26 compute intent and its loopback 0 networks. In the dynamic BGP configuration the compute intent subnet is specified as the neighbor with the neighbor AS of 65500. It uses update-source loopback 0 and set a `ebgp-multihop` of 3. 

In the AKS configuration, multiple peering addresses are listed when it starts the BGP peering session, which can be one or more spine devices. Its MyASN is 65500, with the neighbor peerASN as 64512. The peering address it connects to is the loopback addresses of the spine devices. It uses the compute intent network as its PA (Provider Address) network to connect to the spine. Once the spine establishes a BGP session, it advertises its Virtual IP (VIP) addresses.  The MetalLB address pools can be in different networks than the K8 nodes.  

```output
interface loopback0 
  ip address 10.71.5.5/32 
router bgp 64512 
  router-id 10.71.5.5 
  bestpath as-path multipath-relax 
  address-family ipv4 unicast 
    ...  
    network 10.71.5.5/32 
    network 10.68.40.0/26  
  ... 
  neighbor 10.68.40.0/26 
    description AKS:65500:202ComputeIntent:PA 
    remote-as 65500 
    update-source loopback0     
    ebgp-multihop 3
```

- `router bgp 64512`: This command starts the BGP configuration process and assigns the autonomous system number (ASN) 64512 to this router. 

- `router-id 10.71.5.5`: This sets the BGP router ID to 10.71.5.5. The router ID is typically an IP address that uniquely identifies the router in the BGP network. 

- `bestpath as-path multipath-relax`: This command allows BGP to relax the criteria for selecting multiple paths for the same destination. It permits BGP to consider paths as multipaths even if their AS paths are different. 

- `address-family ipv4 unicast`: This specifies the address family for IPv4 unicast routing. All subsequent commands apply to this address family. 

- `network 10.68.40.0/26`: This command advertises the network 10.68.40.0/26 to other BGP peers. It tells BGP to include this network in its routing updates. 

- `Network 10.71.5.5/32`: This command advertises the loopback network 10.71.5.5/32 to other BGP peers. It tells BGP to include this network in its routing updates. 

- `neighbor 10.68.40.0/26`: Defines a BGP neighbor with the IP address 10.68.40.0/26. Typically, a neighbor is a unicast IP address rather than a subnet. Using the subnet allows MetalLB to establish a Dynamic BGP peering session with the Spine. MetalLB starts the BGP peering session, and the Spine is a passive listener waiting for a BGP request to start. 

- `remote-as 65500`: Specifies that the neighbor at 10.68.40.0/26 belongs to the autonomous system 65500. This is necessary for establishing an external BGP (eBGP) session. 

- `update-source loopback0`: This command specifies that the BGP updates for this neighbor should use the IP address of the loopback0 interface as the source address. 

- `ebgp-multihop 3`: Allows eBGP sessions to be established with a TTL of 3 hops, which is useful if the eBGP peer is not directly connected. 

## References

- [Host network requirements for Azure Local](../concepts/host-network-requirements.md)

- [Physical network requirements for Azure Local](../concepts/physical-network-requirements.md)

- [RDMA over Converged Ethernet (RoCE) on Cisco Nexus 9300](https://aboutnetworks.net/rocev2-on-nexus9k/)

- [What is Software Load Balancer (SLB) for SDN?](../concepts/software-load-balancer.md)

- [Overview of MetalLB for Kubernetes clusters](/azure/aks/aksarc/load-balancer-overview)

- [Software defined networking (SDN) in Azure Local and Windows Server](../concepts/software-defined-networking.md)

- [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure.md)

- [Azure Local Network configuration design with SDN](https://techcommunity.microsoft.com/blog/azurestackblog/azure-stack-hci---network-configuration-design-with-sdn/3817175)

- [Cisco Nexus 9000 Series NX-OS Unicast Routing Configuration Guide, Release 10.5(x)](https://www.cisco.com/c/en/us/td/docs/dcn/nx-os/nexus9000/105x/unicast-routing-configuration/cisco-nexus-9000-series-nx-os-unicast-routing-configuration-guide/m-n9k-configuring-basic-bgp-101x.html)

- [Cisco Nexus 9000 Series NX-OS Unicast Routing Configuration Guide, Release 10.4(x)](https://www.cisco.com/c/en/us/td/docs/dcn/nx-os/nexus9000/104x/unicast-routing-configuration/cisco-nexus-9000-series-nx-os-unicast-routing-configuration-guide/m-n9k-configuring-advanced-bgp-102x.html)

- [Cisco Nexus 9300-FX Series Switches Data Sheet](https://www.cisco.com/c/en/us/products/collateral/switches/nexus-9000-series-switches/datasheet-c78-742284.html)

- [Cisco Nexus 93180YC-FX Switch](https://www.cisco.com/c/en/us/support/switches/nexus-93180yc-fx-switch/model.html)

- [Cisco Nexus 9000 Series NX-OS Quality of Service Configuration Guide, Release 10.3(x)](https://www.cisco.com/c/en/us/td/docs/dcn/nx-os/nexus9000/103x/configuration/qos/cisco-nexus-9000-nx-os-quality-of-service-configuration-guide-103x.html)

- [RoCE Storage Implementation over NX-OS VXLAN Fabrics](https://www.cisco.com/c/en/us/td/docs/dcn/whitepapers/roce-storage-implementation-over-nxos-vxlan-fabrics.html)

## Appendix

### Cisco switch configuration

:::image type="content" source="media/rack-aware-clustering-network-design/cisco-qos.png" alt-text="Diagram showing Cicso configuration." lightbox="media/rack-aware-clustering-network-design/cisco-qos.png":::

Make: Cisco 

Model: 93180YC-FX 

Firmware: 10.3.x 

Interface Speed: 25G

#### QoS policy configuration

This QoS configuration is dedicated to the Cisco Nexus 9300 switch hardware.  NICs use 25Gb link speeds in this setup.  The configuration has been tested with 4-16 machine environments.

**Global LLDP command**

This enables ETS in the switch configuration and recommendation to the Azure Local nodes.  The Azure Local machines won't utilize DCBX to configurate their QoS settings, the LLDP portion are used to notify the hosts of the switch QoS configuration.

```output
feature lldp 
lldp tlv-select dcbxp egress-queuing
```

**Policy map**

This outlines the configuration of the policy map with network QoS, which is designated as `QOS_NETWORK`. The purpose of this policy is to act as a universal setting, applicable to all interfaces facilitating RDMA traffic. Traffic from SMB/RDMA, originating from the Aure Local system, is tagged with a Priority Flow Control (PFC) identifier of 3. It is mandatory for the physical network infrastructure to align with the policy parameters established by the hardware. Traffic entering the switch interface is marked with a pause frame to manage flow control. 

> [!NOTE]
> In this environment, SDN is configured with iWARP network cards. When SDN is used in the Azure Local environment, Jumbo frames are required on the TOR switch to handle the increased packet side to support SDN traffic. In addition, when iWARP is also included, RDMA packets use the increased frame side to transmit Storage Spaces Direct traffic.  The MTU size is also used if the environment is using a fully converged network with SDN.

```output
! Ingress traffic to the Interface 
! 
policy-map type network-qos QOS_NETWORK 
  class type network-qos c-8q-nq3 
    pause pfc-cos 3 
    mtu 9216 
  class type network-qos c-8q-nq7 
    mtu 9216 
  class type network-qos c-8q-nq-default 
    mtu 9216 
```

PFC flags that are used are 3 and 5. Storage Spaces Direct and RDMA traffic use PFC 3, with PFC 7 used for system heartbeat traffic.  

- `policy-map type network-qos`: This type of policy map is used for configuring network-wide QoS settings, such as MTU and PFC, which affect the entire switch. 

- `class type network-qos`: This specifies the class of traffic to which the policy applies. Each class can have different QoS settings. 

- `pause pfc-cos`: PFC is used to manage congestion by pausing traffic for specific CoS values. 

- `mtu`: The Maximum Transmission Unit (MTU) defines the largest packet size that can be transmitted. Setting it to 9216 bytes is common for jumbo frames, which are often used in data center environments to improve efficiency. 

**Class map**

In this configuration, two class maps are defined: `RDMA` and `CLUSTER`. All traffic matching the PFC COS 3 and 7 is categorized as either `RDMA` or `CLUSTER`. Any traffic not including these PFC COS IDs is considered default traffic.

```output
! Identify the traffic 
! 
class-map type qos match-all RDMA 
  match cos 3 
class-map type qos match-all CLUSTER 
  match cos 7
```

- `Class of Service (CoS)`: CoS is a 3-bit field in the 802.1Q VLAN tag that can be used to differentiate traffic. Values range from 0 to 7, with higher values typically indicating higher priority traffic. 

- `Match Criteria`: The `match cos` command is used to specify the CoS value that the traffic must have to be classified into the defined class. 

**Policy map type QOS**

`Policy-map type qos` is defining a service called `AZS_SERVICES` and configuring the class maps `RDMA` and `CLUSTER`. This setting should only maintain the existing PFC COS ID of the traffic. From the syntax it maps PFC COS 3 to 3 and PFC COS 7 to 7. 

```output
! Map the traffic to a queue map from the class-map 
! 
policy-map type qos AZS_SERVICES 
  class RDMA 
    set qos-group 3 
  class CLUSTER 
    set qos-group 7
```

- `policy-map type qos`: This type of policy map is used to configure QoS policies that apply to specific interfaces or traffic classes. 

- `class`: Specifies the class of traffic to which the policy applies. In this case, `RDMA` and `CLUSTER` are the traffic classes. 

- `set qos-group`: This command assigns the traffic to a specific QoS group. QoS groups are used to apply specific QoS policies, such as marking, policing, or shaping, to the classified traffic. 

**Policy map type queuing**

The `policy-map queuing` is setting the `QOS_EGRESS_PORT` values. Three values are configured COS 0, 3, 7. COS 0 is default traffic, COS 3 is Storage Spaces Direct/RDMA traffic, and COS 7 is system heartbeat traffic.  

Starting with COS 3, it's configured to support Weighted Random Early Detection (WRED) with a minimum and maximum threshold of 300 kbytes. The drop probability is set to 100%, when this threshold is reached packets are dropped from COS 0. Explicit Congression Notification (ECN) is configured to signal to the Azure Local system when congestion is discovered in the communication path. The COS group is assigned a minimum of 50% of the interface bandwidth in the environment. In a high traffic environment COS 3 can use all the remaining bandwidth of the interface.  

COS 7 is dedicated to the heartbeat traffic. This is assigned a fixed bandwidth reservation of 1%. In this configuration, the hosts are using 25Gb NIC and the switch is set to utilize a 25Gb interface. When 25Gb interfaces are using 1% bandwidth reservation, which is adequate for heartbeat traffic.  

> [!NOTE] 
> If 10Gb interfaces are used, it's recommended to set a 2% reservation.
>
>COS 0 is given the remainder of the bandwidth. When setting the egress queue bandwidth reservation, it must equal 100% of the bandwidth. 

```output
! Egress traffic from the interface 
! 
policy-map type queuing QOS_EGRESS_PORT 
  class type queuing c-out-8q-q3 
    bandwidth remaining percent 50 
    random-detect minimum-threshold 300 kbytes maximum-threshold 300 kbytes drop-probability 100 weight 0 ecn 
  class type queuing c-out-8q-q-default 
    bandwidth remaining percent 48 
  class type queuing c-out-8q-q1 
    bandwidth remaining percent 0 
  class type queuing c-out-8q-q2 
    bandwidth remaining percent 0 
  class type queuing c-out-8q-q4 
    bandwidth remaining percent 0 
  class type queuing c-out-8q-q5 
    bandwidth remaining percent 0   
  class type queuing c-out-8q-q6 
    bandwidth remaining percent 0 
  class type queuing c-out-8q-q7 
    bandwidth percent 1 
```

- `policy-map type queuing`: This type of policy map is used to configure queuing policies for managing how traffic is handled as it exits the switch. 

- `class type queuing`: Specifies the class of traffic to which the queuing policy applies. 

- `bandwidth remaining percent`: Allocates a percentage of the remaining bandwidth to the specified queue. 

- `bandwidth percent`: Allocates a fixed percentage of the total bandwidth to the specified queue. 

- `random-detect`: Configures WRED, which helps manage congestion by dropping packets probabilistically before the queue is full. This helps avoid global synchronization issues in TCP traffic. 

- `ecn`: Enables Explicit Congestion Notification (ECN), which allows end-to-end notification of network congestion without dropping packets. ECN is useful in in-cast scenarios where multiple nodes are sending traffic to a specific machine.  ECN allows the destination machine to signal to all the senders to slow the traffic that is being sent because congestion is happening along the path. 

**System QOS**

```output
! Apply to the system 
! 
system qos 
  service-policy type queuing output QOS_EGRESS_PORT 
  service-policy type network-qos QOS_NETWORK
```

- `system qos` applies the configuration globally to the entire switch. Two service policies are used in the environment, and these are used in the interface configurations. `QOS_EGRESS_PORT` and `QOS_NETWORK`. When `AZS_SERVICES` is applied with PFC mode on this policy these policies are applied to the interface configuration. 

- `QOS_EGRESS_PORT` is the name of the queuing policy map that is being applied. This policy map defines how different classes of traffic are managed as they exit the switch, including bandwidth allocation and congestion management. 

- `QOS_NETWORK` is the name of the network QoS policy map that is being applied. This policy map defines global QoS settings like MTU and PFC for the different classes of traffic. 

- `Global Application`: The system qos command applies the specified QoS policies globally across the entire switch. 

- `Queuing Policy`: The service-policy type queuing output `QOS_EGRESS_PORT` command applies the `QOS_EGRESS_PORT` policy map to manage egress traffic, ensuring that different traffic classes are handled according to their defined bandwidth and congestion management settings. 

- `Network QoS Policy`: The `service-policy type network-qos QOS_NETWORK` command applies the `QOS_NETWORK` policy map to set global QoS parameters like MTU and PFC, which affect the entire switch.

#### Example: Interface QoS applied 

In this example, QoS policies are being applied to the switch interface. PFC is enabled along with the `AZS_SERVICE` configuration defined. In addition, a MTU size of 9216 is applied to support SDN with iWARP. The key items in this configuration are the priority flow control and service policy lines. 

`Priority-flow-control` enables the PFC in the configuration and sends the values within the LLDP messages.  `Service-polity type qos` enables the `AZS_SERVICES` that are set in the QoS section.

```output
interface ethernet 1/1 
  description Azure Local nodes NIC 
  ..... 
  service-policy type qos input AZS_SERVICES 
  priority-flow-control mode on send-tlv 
  mtu 9216 
  no shutdown
``` 

**Room-to-room link**

Example of a room-to-room link for TOR1 to TOR3. In this example TOR1 and TOR3 are supporting the Storage Spaces Direct VLAN 711. TOR2 and TOR4 would support VLAN 712. 

```output
interface port-channel711 
  description room-to-room PO 
  switchport mode trunk 
  switchport trunk native vlan 99 
  switchport trunk allowed vlan 711 
  priority-flow-control mode on 
  mtu 9216 
  service-policy type qos input AZS_SERVICES 
!  
interface Ethernet1/51 
  description room-to-room plink 
  switchport mode trunk 
  switchport trunk native vlan 99 
  switchport trunk allowed vlan 711 
  priority-flow-control mode on 
  mtu 9216 
  channel-group 711 
  no shutdown 
! 
interface Ethernet1/52 
  description room-to-room plink 
  switchport mode trunk 
  switchport trunk native vlan 99 
  switchport trunk allowed vlan 711 
  priority-flow-control mode on 
  mtu 9216 
  channel-group 711 
  no shutdown 
```

### Dell switch

:::image type="content" source="media/rack-aware-clustering-network-design/dell-qos.png" alt-text="Diagram showing Dell switch." lightbox="media/rack-aware-clustering-network-design/dell-qos.png":::

Make: Dell

Model: S5248F-ON

Device Description: S5248F-ON 48x25 GbE SFP28, 4x100 GbE QSFP28, 2x200 GbE QSFP-DD Interface Module 

Firmware version: 10.5.4.5 

#### QoS policy configuration

This provides an overview of the switch settings implemented for Azure Local, applicable to both RoCE v2 and iWARP protocols. This configuration is not limited to a specific system size.  


```output
dcbx enable
```

QoS facilitates Azure Local storage operations for both RoCE v2 and iWARP by prioritizing storage traffic on ports designed for a storage intent. This ensures that RDMA traffic is reliably maintained. For the setup of QOS, the Data Center Bridging Capability Exchange (DCBX) protocol is activated on the switch. Although Azure Local doesn't process DCBX LLDP messages for configuration purposes, LLDP TLVs are used in future scenarios. 

**Class map**

The class map section associates traffic with a queue. 

```output
class-map type queuing AZS_SERVICES_EtsQue_0 
  match queue 0  
! 
class-map type queuing AZS_SERVICES_EtsQue_3 
  match queue 3  
! 
class-map type queuing AZS_SERVICES_EtsQue_7 
  match queue 7  
! 
class-map type network-qos AZS_SERVICES_Dot1p_3 
  match qos-group 3  
! 
class-map type network-qos AZS_SERVICES_Dot1p_7 
  match qos-group 7  
```

- `class-map type queuing AZS_SERVICES_EtsQue_0`: Match traffic with queue 0. 

- `class-map type queuing AZS_SERVICES_EtsQue_3`: Match traffic with queue 3. 

- `class-map type queuing AZS_SERVICES_EtsQue_7`: Match traffic with queue 7. 

- `class-map type network-qos AZS_SERVICES_Dot1p_3`: Traffic matching queue 3 match to QoS group 3. 

- `class-map type network-qos AZS_SERVICES_Dot1p_7`: Traffic matching queue 7 match to QoS group 7. 

**Trusted dot1p-map**

`trusted dot1p-map` is assigned a name `AZS_SERIVCES-Dot1p` this group name helps associate the different queues based on their packet markings. This setting maps the QoS groups to 802.1p priority values. 

```output
trust dot1p-map AZS_SERVICES_Dot1p 
  qos-group 0 dot1p 0-2,4-6 
  qos-group 3 dot1p 3 
  qos-group 7 dot1p 7 
```
 
- `qos-group 0 dot1p 0-2,4-6`: any traffic that arrives on the switch utilizing any of these priority flags are associated with the default queue. This is the lowest traffic class that is configured on the device. 

- `qos-group 3 dot1p 3`: Map dot1p traffic to class 3, this maintains the same priority class. 

- `qos-group 7 dot1p 7`: Map dot1p traffic to class 7, this maintains the same priority class.

**Qos map traffic class**

The QoS traffic map is associated with traffic to their respective queues established in the switch configuration.  In this case queues 3 and 7 are configured.  Queue 3 marked as RDMA traffic and queue 7 marked as system heartbeat. 

```output
qos-map traffic-class AZS_SERVICES_Que 
  queue 0 qos-group 0-2,4-6 
  queue 3 qos-group 3 
  queue 7 qos-group 7 
```

- `queue 0 qos-group 0-2,4-6`: Queue 0 is mapped to QoS groups 1-2, 4-7, generic default traffic. 

- `queue 3 qos-group 3`: Queue 3 is mapped to QoS group 3 RDMA traffic. 

- `queue 7 qos-group 7`: Queue 7 is mapped to QoS group 7 system communications.

**Policy map queuing**

This section details the configuration of bandwidth reservations for various traffic classes. Bandwidth reservations are allocated to specific interfaces and are subject to the bandwidth limitations of the physical interfaces.  ETS guarantees a minimum level of bandwidth of a traffic class, but it is not limited to that minimum level. In a high use environment, a traffic class can burst to utilize the remaining unused bandwidth of an interface. If a traffic class is not utilizing its bandwidth reservation, the other classes can utilize the unused bandwidth. 

```output
policy-map type queuing AZS_SERVICES_ets 
! 
 class AZS_SERVICES_EtsQue_0 
  bandwidth percent 48 
! 
 class AZS_SERVICES_EtsQue_3 
  bandwidth percent 50 
  random-detect ecn 
! 
 class AZS_SERVICES_EtsQue_7 
  bandwidth percent 2 
``` 

- `class AZS_SERVICES_EtsQue_0`: The default class, and the remaining bandwidth is listed in this class. 

- `class AZS_SERVICES_EtsQue_3`: Allocates 50% of the bandwidth to queue 3 supporting RDMA and enable random early detection (RED) with explicit congestion notification (ECN) 

- `class AZS_SERVICES_EtsQue_7`: This is configured with a bandwidth reservation of 2% for system heartbeat traffic. Depending on the link speed of the host port, this reservation can range between 1% and 2%. Specifically, Azure Local applies a 2% reservation when the host port speed is 10 Gb. For speeds of 25 Gb or higher, a reservation of 1% is deemed sufficient. 

**Policy-map type network-qos**

Within this policy, there is a class named `AZS_SERVICES_Dot1p_3` which has two commands associated with it: 

```output
policy-map type network-qos AZS_SERVICES_pfc 
! 
 class AZS_SERVICES_Dot1p_3 
  pause 
  pfc-cos 3 
```
 
- `pause`: This command typically enables the use of Priority Flow Control (PFC) on the associated class. PFC is a mechanism that prevents frame loss due to congestion by pausing the transmission of frames in a particular class when the receiving end is overwhelmed. 

- `pfc-cos 3`: This command associates the `AZS_SERVICES_Dot1p_3` class with Class of Service (CoS) 3. CoS is a method of assigning priority levels to network traffic. In the context of the page content provided, Class 3 is designated for storage intent traffic, which implies this class is meant for traffic related to storage operations, and by associating it with PFC, it ensures that storage traffic is reliable and lossless even under congestion. 

**System QOS**

This section applies the global QoS configuration on the device.  Trusted map settings from the `AZS_SERVICES_Dot1p` setting are applied.  Buffer statistics and enable in the configuration.  Enhanced Transmission Selection (ETS) is applied. 

```output
system qos 
  trust-map dot1p AZS_SERVICES_Dot1p 
    buffer-statistics-tracking 
  ets mode on 
```
 
**Full QoS configuration**

```output
dcbx enable 
class-map type queuing AZS_SERVICES_EtsQue_0 
  match queue 0  
! 
class-map type queuing AZS_SERVICES_EtsQue_3 
  match queue 3  
! 
class-map type queuing AZS_SERVICES_EtsQue_7 
  match queue 7  
! 
class-map type network-qos AZS_SERVICES_Dot1p_3 
  match qos-group 3  
! 
class-map type network-qos AZS_SERVICES_Dot1p_7 
  match qos-group 7  
! 
trust dot1p-map AZS_SERVICES_Dot1p 
  qos-group 0 dot1p 0-2,4-6 
  qos-group 3 dot1p 3 
  qos-group 7 dot1p 7 
! 
qos-map traffic-class AZS_SERVICES_Que 
  queue 0 qos-group 0-2,4-6 
  queue 3 qos-group 3 
  queue 7 qos-group 7 
! 
policy-map type queuing AZS_SERVICES_ets 
! 
 class AZS_SERVICES_EtsQue_0 
  bandwidth percent 48 
! 
 class AZS_SERVICES_EtsQue_3 
  bandwidth percent 50 
  random-detect ecn 
! 
 class AZS_SERVICES_EtsQue_7 
  bandwidth percent 2 
! 
policy-map type network-qos AZS_SERVICES_pfc 
! 
 class AZS_SERVICES_Dot1p_3 
  pause 
  pfc-cos 3  
! 
system qos 
  trust-map dot1p AZS_SERVICES_Dot1p 
    buffer-statistics-tracking 
  ets mode on 
```

**Packet inspection**

This packet capture shows the ETS values in the LLDP packet. This specific setup is using priority ID 5 vs 7. Packet capture of a LLDP packet with the ETS and PFC configured.

:::image type="content" source="media/rack-aware-clustering-network-design/frame-code.png" alt-text="Diagram showing packet capture." lightbox="media/rack-aware-clustering-network-design/frame-code.png":::

#### Interface configuration

```output
interface ethernet1/1/18 
description Storage-CL1 
... 
mtu 9216 
priority-flow-control mode on 
service-policy input type network-qos AZS_SERVICES_pfc 
service-policy output type queuing AZS_SERVICES_ets 
ets mode on 
qos-map traffic-class AZS_SERVICES_Que 
...
```

The following items need to be enabled on the interface - each of the policy names are found in the configurations. 

 - `ets mode on`: Must configured under interface level as well to enable ETS.  

- `priority-flow-control mode on`: Used to support priority flow control traffic. 

- `service-policy input type network-qos AZS_SERVICES_pfc`: This setting enables the `AZS_SERVICES_pfc` policy enabling the ability to pause priority 3 frames. The name of the service varies depending on your configuration. 

- `service-policy output type queuing AZS_SERVICES_ets`: This setting enables the ETS setting to reserve bandwidth, enable RED settings and ECN.  The name of the service varies depending on your configuration. 

- `qos-map traffic-class AZS_SERVICES_Que`: This setting enables the interface to support the different traffic classes associate them to the correct queue. The `qos-map` name varies depending on your configuration. 

- `mtu 9216`: In this configuration SDN is enabled, the TOR is set with its maximum MTU size to support VXLAN encapsulation.

<!-- ## Glossary of networking terms

AS (Autonomous Number) - 

ASN (Autonomous System Number) - 

BGP (Border Gateway Protocol) - 

CDP (Cisco Discovery Protocol) - 

CoS (Class of Service) - 

DCB (Data center bridging) - 

DCBX (Data Center Bridging Capability Exchange) - 

DSCP (Differentiated Services Code Point) - 

eBBGP (External BGP) - 
 
ECN (Enhanced Congestion Notification) - 

ETS (Enhanced Transmission Selection) - 

HSRP (Hot Standby Router Protocol) - 

ICMP (Internet Control Message Protocol) - 

iWARP - 

Jumbo Frames - 

K8S - Kubernetes - 

LLDP  (Link Layer Discovery Protocol) - 

MetalLB - 

MTU  (Maximum Transmission Unit) - 

MLAG (Multi-Chassis Link Aggregation) - 

MSTP (Multiple Spanning Tree Protocol) - 

NX-OS (Nexus-series OS) - 

PA (Provider Address) - 

PFC (Priority-based Flow Control) - 

QoS (Quality of Service) - 

RoCE (RDMA over Converged Ethernet) - 

RDMA (Remote Direct Memory Access) - 

SMB (Server Message Block Protocol) - 

SLB (Software Load Balancing) - 

SET (Switch Embedded Teaming) - 

TTL (Time to Live) - 

TLV (Type, Length, Value) - 

VXLAN (Virtual Extensible LAN) - 

VRF (Virtual Routing and Forwarding) - 

VIP (Virtual IP) - 

VPC (Virtual Private Cloud) - 

WRED (Weighted Random Early Detection) - -->


## Next steps

- [Download Azure Local](../deploy/download-software.md).
