---
title: SDN considerations for network design for Rack Aware Cluster on Azure Local (Preview)
description: SDN considerations for a Rack Aware Cluster on Azure Local (Preview).
ms.topic: conceptual
author: alkohli
ms.author: alkohli
ms.service: azure-local
ms.date: 04/01/2025
---

# SDN considerations for network design of Rack Aware Cluster on Azure Local (Preview)

Applies to: Azure Local 2504 or later

This article discusses Software Designed Network (SDN) considerations for the network design for the Rack Aware Cluster on Azure Local.

[!INCLUDE [important](../includes/hci-preview.md)]

## About Rack Aware Cluster

The Rack Aware Cluster architecture is a hyper-converged infrastructure (HCI) solution that provides high availability and disaster recovery capabilities. It is designed to support workloads that require low latency and high throughput, making it suitable for various applications, including databases, analytics, and virtualization. <!--check if good-->

This article describes the network design and configuration of the Rack Aware Cluster architecture on Azure Local. The configuration involves a single cluster where the nodes are placed in different physical locations within a building. The intent is to support disaster recovery scenarios by placing different workloads in one or both locations. This configuration can support environments with or without Software Defined Networking (SDN), Layer 2 virtual networks, or Azure Kubernetes Service (AKS).

The Rack Aware Cluster setup is intended to support environments with up to 4 + 4 nodes, where the cluster is separated into two local availability zones with less than 1ms latency between the rooms. The network architecture requires the use of spine and top of rack (TOR) switch layers to support network traffic. Compute and management traffic are hosted at the spine layer, while Storage Spaces Direct Remote Direct Memory Access (RDMA) traffic is hosted at the TOR switch layer. RDMA traffic doesn't travel to the spine switch layer; it is dedicated to the TOR layer and can travel to its neighboring TOR in a different zone with a matching configuration.

## About SDN



## Software Load Balancing

:::image type="content" source="media/rack-aware-clustering-network-design/sdn-slb-configuration.png" alt-text="Diagram showing software load balancing." lightbox="media/rack-aware-clustering-network-design/sdn-slb-configuration.png":::

The Software Load Balancing (SLB) solution for Azure Local in a rack aware cluster consists of three network layers: spine, TOR, and SLB. In this setup, the spine is a combined Layer 2/Layer 3 BGP router that peers with the SLB. The TOR layer is a simple Layer 2 switch that enables BGP sessions to pass from the SLB to the spine. Each spine is configured with a Dynamic BGP configuration, allowing multiple SLBs to establish BGP sessions with the spines. The SLB uses the spine loopback IP address as the peering IP. In the spine BGP configuration, the update source is set to loopback 0. When the SLB establishes a BGP session with the spine, it advertises the VIP addresses provided by the network controller as host IP addresses.

## BGP configuration

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

## SDN gateway

The SDN gateway is a virtual router hosted in the Azure Local cloud environment, designed to support multitenant Hyper-V virtual networks. The SDN gateway can be connected using either static routing or dynamic routing via BGP. In both cases, a virtual network is created within the Azure Local system, and the SDN gateway serves as the primary gateway for the network. A compute intent Provider Address (PA) network supports a single SDN gateway. 

- **Static configuration**: In a static configuration, the switch/router has a static route to the endpoint, which acts as the next hop to reach the virtual network. This next hop is contained within the Compute Intent network. The static route is manually maintained in the switch/router route table.  In this configuration, the Switch Virtual Interface (SVI) PA network supporting the SDN gateway is maintained on the switch/router along with the Azure Local virtual network. 

- **Dynamic configuration**: In a dynamic configuration, BGP is used to dynamically advertise the virtual network to the switch/router. Once a BGP session is established, it advertises the virtual network subnet, and is injected into the switch/router route table.  In this instance, the same SVI is maintained to support the PA network, but the virtual network is not included in the configuration. This is received dynamically via BGP as a network advertisement. 

## Common configurations

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

#### VLAN configuration

- `vlan 202`: Defines VLAN 202. 

- `name 202ComputeIntent:PA`: Assigns the name `202ComputeIntent:PA` to VLAN 202. 

#### Interface VLAN configuration 

- `interface vlan202`: Specifies the switch virtual interface for VLAN 202. 

- `description 202ComputeIntent:PA`: Adds a description to the interface. 

- `no shutdown`: Ensures the interface is active. 

- `mtu 9216`: Sets the Maximum Transmission Unit (MTU) to 9216 bytes, which is typical for jumbo frames. 

- `ip address 10.68.40.2/24`: Assigns the IP address 10.68.40.2 with a subnet mask of [address] to the interface. 

- `no ip redirects`: Disables ICMP redirects on the interface. 

#### Hot Standby Router Protocol (HSRP) configuration

- `hsrp version 2`: Configures HSRP version 2.

- `hsrp 202`: Configures HSRP group 202. 

- `priority 150`: Sets the priority of this router to 150.

- `forwarding-threshold lower 1 upper 150`: Specifies the thresholds for transitioning to the forwarding state. 

- `ip 10.68.40.1`: Sets the virtual IP address for the HSRP group.

### Static SDN gateway

:::image type="content" source="media/rack-aware-clustering-network-design/static-sdn-gateway.png" alt-text="Diagram showing static SDN gateway." lightbox="media/rack-aware-clustering-network-design/static-sdn-gateway.png":::

```output
ip route 10.10.50.0/24 10.68.40.6 name AZLOCAL/VNET/AccntSvc 
ip route 0.0.0.0/0 10.8.8.2/30 name CoreNet/DefaultRoute 
ip route 0.0.0.0/0 10.8.9.2/30 name CoreNet/DefaultRoute
```

- `ip route 10.10.50.0/24 10.68.40.6 name AZLOCAL/VNET/AccntSvc`: Adds a static route for the network 10.10.50.0/24 with the next hop 10.68.40.6 and names it `AZLOCAL/VNet/AccountingServices`. The next hop 10.68.40.6 is the gateway service that is acting as the gateway to the VNET 10.10.50.0/24.  Each TOR in the environment has the same configuration. 

- `ip route 0.0.0.0/0 10.8.8.2/30 name CoreNet/DefaultRoute`: Adds a default route with the next hop 10.8.8.2/30 and names it `CoreNet/DefaultRoute` 

- `ip route 0.0.0.0/0 10.8.9.2/30 name CoreNet/DefaultRoute`: Adds another default route with the next hop 10.8.9.2/30 and names it `CoreNet/DefaultRoute`. 

### Dynamic SDN gateway

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