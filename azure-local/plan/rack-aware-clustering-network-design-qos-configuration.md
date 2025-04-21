---
title: QoS considerations for network design for Rack Aware Cluster on Azure Local (Preview)
description: QoS considerations for a Rack Aware Cluster design on Azure Local (Preview).
ms.topic: overview
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 04/01/2025
---

# QoS considerations for network design for Rack Aware Cluster on Azure Local (Preview)

Applies to: Azure Local 2504 or later

This article discusses Quality Of Service (QoS) considerations for the network design for the Rack Aware Cluster on Azure Local.

[!INCLUDE [important](../includes/hci-preview.md)]

## About Rack Aware Cluster

The Rack Aware Cluster architecture is a hyper-converged infrastructure (HCI) solution that provides high availability and disaster recovery capabilities. It is designed to support workloads that require low latency and high throughput, making it suitable for various applications, including databases, analytics, and virtualization. <!--check if good-->

This article describes the network design and configuration of the Rack Aware Cluster architecture on Azure Local. The configuration involves a single cluster where the nodes are placed in different physical locations within a building. The intent is to support disaster recovery scenarios by placing different workloads in one or both locations. This configuration can support environments with or without Software Defined Networking (SDN), Layer 2 virtual networks, or Azure Kubernetes Service (AKS).

The Rack Aware Cluster setup is intended to support environments with up to 4 + 4 nodes, where the cluster is separated into two local availability zones with less than 1ms latency between the rooms. The network architecture requires the use of spine and top of rack (TOR) switch layers to support network traffic. Compute and management traffic are hosted at the spine layer, while Storage Spaces Direct Remote Direct Memory Access (RDMA) traffic is hosted at the TOR switch layer. RDMA traffic doesn't travel to the spine switch layer; it is dedicated to the TOR layer and can travel to its neighboring TOR in a different zone with a matching configuration.


## QoS

The QoS configuration applies the DCB framework to establish a lossless, low-latency setup for RDMA, encompassing both ROCE v2 and iWARP technologies. In the default Azure Local configuration, RDMA traffic is assigned to PFC ID 3. Another PFC ID is allocated for the system heartbeat, which by default uses PFC ID 7. PFC ID 7 is given the highest priority, while PFC ID 3 is also configured to support pause frames or function as a no-drop queue.

These two PFC IDs are mapped to specific traffic classes, with all other traffic, not marked by these PFC IDs, which are categorized as default traffic with the lowest priority. Additionally, Enhanced Transmission Selection (ETS) is employed to allocate bandwidth reservations for particular traffic classes. The default RDMA setting in Azure Local reserves a minimum of 50% of the interface bandwidth for RDMA traffic. System traffic is allocated 1% of bandwidth for 25Gb interfaces and 2% for 10Gb interfaces.

A policy map is used to facilitate Weighted Random Early Detection (WRED); when thresholds are exceeded, traffic associated with the default queue dropped. For environments that support ROCE v2, Enhanced Congestion Notification (ECN) is implemented to prevent incast situations. When congestion is detected along the connection path between nodes, a bit in the packet DSCP field is set by the network device and sent to the destination. The destination device then informs the sender to reduce their traffic flow. 

For QoS examples, see *Cisco switch configuration* and *Dell switch configuration* in the Appendix.


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
