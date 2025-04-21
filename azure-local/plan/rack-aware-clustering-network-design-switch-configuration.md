---
title: Network design for Rack Aware Cluster on Azure Local including switch considerations (Preview)
description: Switch considerations for a Rack Aware Cluster on Azure Local (Preview).
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 04/01/2025
---

# Network design for Rack Aware Cluster on Azure Local (Preview)

Applies to: Azure Local 2504 or later

This article provide a brief overview of network design for the Rack Aware Cluster architecture  on Azure Local and then details the switch considerations in  detail. architecture on Azure Local.

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
