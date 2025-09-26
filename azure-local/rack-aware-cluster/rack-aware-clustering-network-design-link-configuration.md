---
title: Link configuration for network design for Rack Aware Cluster on Azure Local (Preview)
description: Link configuration considerations for a Rack Aware Cluster on Azure Local (Preview).
ms.topic: conceptual
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 04/01/2025
---

# Room-to-room link configuration considerations for network design for Rack Aware Cluster on Azure Local (Preview)

Applies to: Azure Local 2504 or later

This article discusses the link configuration considerations for the network design for the Rack Aware Cluster architecture on Azure Local.

[!INCLUDE [important](../includes/hci-preview.md)]

## About Rack Aware Cluster

The Rack Aware Cluster architecture is a hyper-converged infrastructure (HCI) solution that provides high availability and disaster recovery capabilities. It is designed to support workloads that require low latency and high throughput, making it suitable for various applications, including databases, analytics, and virtualization. <!--check if good-->

This article describes the network design and configuration of the Rack Aware Cluster architecture on Azure Local. The configuration involves a single cluster where the nodes are placed in different physical locations within a building. The intent is to support disaster recovery scenarios by placing different workloads in one or both locations. This configuration can support environments with or without Software Defined Networking (SDN), Layer 2 virtual networks, or Azure Kubernetes Service (AKS).

The Rack Aware Cluster setup is intended to support environments with up to 4 + 4 nodes, where the cluster is separated into two local availability zones with less than 1ms latency between the rooms. The network architecture requires the use of spine and top of rack (TOR) switch layers to support network traffic. Compute and management traffic are hosted at the spine layer, while Storage Spaces Direct Remote Direct Memory Access (RDMA) traffic is hosted at the TOR switch layer. RDMA traffic doesn't travel to the spine switch layer; it is dedicated to the TOR layer and can travel to its neighboring TOR in a different zone with a matching configuration.


## Room-to-room link requirements

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

## Room-to-room link configuration -  Option A

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

## Room-to-room link configuration - Option B 

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


## Next steps

- [Download Azure Local](../deploy/download-software.md).


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
