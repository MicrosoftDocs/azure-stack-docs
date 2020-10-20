---
title: Plan a Software Defined Network infrastructure
description: This topic provides information on how to plan a Software Defined Network (SDN) infrastructure deployment.
manager: grcusanz
ms.topic: conceptual
ms.assetid: ea7e53c8-11ec-410b-b287-897c7aaafb13
ms.author: anpaul
author: AnirbanPaul
ms.date: 10/16/2020
---
# Plan a Software Defined Network infrastructure

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019, Windows Server (Semi-Annual Channel), Windows Server 2016

Learn about deployment planning for a Software Defined Network (SDN) infrastructure, including hardware and software prerequisites. This topic includes planning requirements for physical and logical network configuration, routing, gateways, network hardware, and more. It also includes considerations on extending a SDN infrastructure and using a phased deployment.

   > [!NOTE]
   > SDN is not supported on stretched (multi-site) clusters.

## Prerequisites
There are several hardware and software prerequisites for a SDN infrastructure, including:
- **Security groups and dynamic DNS registration**. You must prepare your datacenter for Network Controller deployment, which requires a set of virtual machines (VMs). Before you can deploy the Network Controller, you must configure security groups and dynamic DNS registration.

    To learn more about Network Controller deployment for your datacenter, see [Requirements for Deploying Network Controller](/windows-server/networking/sdn/plan/installation-and-preparation-requirements-for-deploying-network-controller).

- **Physical network**. You need access to your physical network devices to configure virtual local area networks (VLANs), routing, and the Border Gateway Protocol (BGP). This topic provides instructions for manual switch configuration, as well as options to use either BGP peering on Layer-3 switches / routers, or a Routing and Remote Access Server (RRAS) VM.

- **Physical compute hosts**. These hosts run Hyper-V and are required to host a SDN infrastructure and tenant VMs. Specific network hardware is required in these hosts for best performance, as described in the [Network hardware](#network-hardware) section.

## Physical and logical network configuration
Each physical compute host requires network connectivity through one or more network adapters attached to a physical switch port. A Layer-2 [VLAN](https://en.wikipedia.org/wiki/Virtual_LAN) supports networks divided into multiple logical network segments.

>[!TIP]
>Use VLAN 0 for logical networks in either access mode or untagged.

>[!IMPORTANT]
>Windows Server 2016 Software Defined Networking supports IPv4 addressing for the underlay and the overlay. IPv6 is not supported. Windows Server 2019 supports both IPv4 and IPv6 addressing.

### Logical networks
This section covers SDN infrastructure planning requirements for the management logical network and the Hyper-V Network Virtualization (HNV) Provider logical network. It includes details on provisioning additional logical networks to use gateways and the Software Load Balancer (SLB), and a sample network topology.

#### Management and HNV Provider
All physical compute hosts must access the management logical network and the HNV Provider logical network. For IP address planning purposes, each physical compute host must have at least one IP address assigned from the management logical network. The Network Controller requires a reserved IP address from this network to serve as the Representational State Transfer (REST) IP address.

The HNV Provider network serves as the underlying physical network for East/West (internal-internal) tenant traffic, North/South (external-internal) tenant traffic, and to exchange BGP peering information with the physical network.

A DHCP server can automatically assign IP addresses for the management network, or you can manually assign static IP addresses. The SDN stack automatically assigns IP addresses for the HNV Provider logical network for the individual Hyper-V hosts from an IP address pool. The Network Controller specifies and manages the IP address pool.

>[!NOTE]
>The Network Controller assigns an HNV Provider IP address to a physical compute host only after the Network Controller Host Agent receives network policy for a specific tenant VM.

| If...                                                    | Then...                                               |
| :------------------------------------------------------- | :---------------------------------------------------- |
| The logical networks use VLANs,                          | the physical compute host must connect to a trunked switch port that has access to the VLANs. It's important to note that the physical network adapters on the computer host must not have any VLAN filtering activated.|
| You are using Switched-Embedded Teaming (SET) and have multiple Network Interface Card (NIC) team members, such as network adapters,| you must connect all NIC team members for that particular host to the same Layer-2 broadcast domain.|
| The physical compute host is running additional infrastructure VMs, such as Network Controller, the SLB/Multiplexer (MUX), or Gateway, | ensure that the management logical network has sufficient IP addresses for each hosted VM. Also, ensure that the HNV Provider logical network has sufficient IP addresses to allocate to each SLB/MUX and gateway infrastructure VM. Although IP reservation is managed by the Network Controller, failure to reserve a new IP address due to unavailability may result in duplicate IP addresses on your network.|

For information about Hyper-V Network Virtualization (HNV) that you can use to virtualize networks in a Microsoft SDN deployment, see [Hyper-V Network Virtualization](/windows-server/networking/sdn/technologies/hyper-v-network-virtualization/hyper-v-network-virtualization).

#### Gateways and the Software Load Balancer (SLB)
You need to create and provision additional logical networks to use gateways and the SLB. Make sure to obtain the correct IP prefixes, VLAN IDs, and gateway IP addresses for these networks.

|                                |                     |
| :----------------------------- | :------------------ |
| **Public VIP logical network** | The Public virtual IP (VIP) logical network must use IP subnet prefixes that are routable outside of the cloud environment (typically internet routable). These are the front-end IP addresses that external clients use to access resources in the virtual networks, including the front-end VIP for the site-to-site gateway. You don’t need to assign a VLAN to this network. |
| **Private VIP logical network** | The Private VIP logical network is not required to be routable outside of the cloud. This is because only VIPs that can be accessed from internal cloud clients use it, such as private services. You don’t need to assign a VLAN to this network. |
| **GRE VIP logical network** | The Generic Routing Encapsulation (GRE) VIP network is a subnet that exists solely to define VIPs. The VIPs are assigned to gateway VMs running on your SDN fabric for a site-to-site (S2S) GRE connection type. You don't need to preconfigure this network in your physical switches or router, or assign a VLAN to it. |

#### Sample network topology
Change the sample IP subnet prefixes and VLAN IDs for your environment.

| Network name | Subnet | Mask | VLAN ID on trunk | Gateway | Reservation (examples) |
| :----------------------- | :------------ | :------- | :---------------------------- | :-------------- | :------------------------------------------- |
| Management              | 10.184.108.0 |    24   |          7                   | 10.184.108.1   | 10.184.108.1 - Router<br> 10.184.108.4 - Network Controller<br> 10.184.108.10 - Compute host 1<br> 10.184.108.11 - Compute host 2<br> 10.184.108.X - Compute host X |
| HNV Provider             |  10.10.56.0  |    23    |          11                |  10.10.56.1    | 10.10.56.1 - Router<br> 10.10.56.2 - SLB/MUX1<br> 10.10.56.5 - Gateway1 |
| Public VIP               |  41.40.40.0  |    27    |          NA                |  41.40.40.1    | 41.40.40.1 - Router<br> 41.40.40.3 - IPSec S2S VPN VIP |
| Private VIP              |  20.20.20.0  |    27    |          NA                |  20.20.20.1    | 20.20.20.1 - Default GW (router) |
| GRE VIP                  |  31.30.30.0  |    24    |          NA                |  31.30.30.1    | 31.30.30.1 - Default GW |

## Routing infrastructure
Routing information \(such as next-hop\) for the VIP subnets is advertised by the SLB/MUX and Remote Access Server (RAS) gateways into the physical network using internal BGP peering. The VIP logical networks do not have a VLAN assigned and they are not preconfigured in the Layer-2 switch (such as the Top-of-Rack switch).

You need to create a BGP peer on the router that your SDN infrastructure uses to receive routes for the VIP logical networks advertised by the SLB/MUXes and RAS Gateways. BGP peering only needs to occur one way (from the SLB/MUX or RAS Gateway to the external BGP peer). Above the first layer of routing, you can use static routes or another dynamic routing protocol, such as Open Shortest Path First (OSPF). However, as previously stated, the IP subnet prefix for the VIP logical networks do need to be routable from the physical network to the external BGP peer.

BGP peering is typically configured in a managed switch or router as part of the network infrastructure. The BGP peer could also be configured on a Windows Server with the RAS role installed in a Routing Only mode. The BGP router peer in the network infrastructure must be configured to use its own Autonomous System Numbers (ASN) and allow peering from an ASN that is assigned to the SDN components \(SLB/MUX and RAS Gateways\).

You must obtain the following information from your physical router, or from the network administrator in control of that router:
- Router ASN
- Router IP address

>[!NOTE]
>Four-byte ASNs are not supported by the SLB/MUX. You must allocate two-byte ASNs to the SLB/MUX and the router to which it connects. You can use four-byte ASNs elsewhere in your environment.

You or your network administrator must configure the BGP router peer to accept connections from the ASN and IP address or subnet address of the HNV Provider logical network that your RAS Gateway and SLB MUXes are using.

For more information, see [Border Gateway Protocol (BGP)](/windows-server/remote/remote-access/bgp/border-gateway-protocol-bgp).

## Default gateways
Machines configured to connect to multiple networks, such as the physical hosts, SLB/MUX, and gateway VMs must only have one default gateway configured. Use the following default gateways for the hosts and the infrastructure VMs:
- For Hyper-V hosts, use the management network as the default gateway.
- For Network Controller VMs, use the management network as the default gateway.
- For SLB/MUX VMs, use the management network as the default gateway.
- For the gateway VMs, use the HNV Provider network as the default gateway. This should be set on the front-end NIC of the gateway VMs.

## Network hardware
This section provides network hardware deployment requirements for NICs and physical switches.

### Network Interface Cards (NICs)
The NICs that you use in your Hyper-V hosts and storage hosts require specific capabilities to achieve the best performance.

Remote Direct Memory Access (RDMA) is a kernel bypass technique that makes it possible to transfer large amounts of data without using the host CPU, which frees the CPU to perform other work. Switch Embedded Teaming (SET) is an alternative NIC Teaming solution that you can use in environments that include Hyper-V and the SDN stack. SET integrates some NIC Teaming functionality into the Hyper-V Virtual Switch.

For more information, see [Remote Direct Memory Access (RDMA) and Switch Embedded Teaming (SET)](/windows-server/virtualization/hyper-v-virtual-switch/rdma-and-switch-embedded-teaming).

To account for the overhead in tenant virtual network traffic caused by VXLAN or NVGRE encapsulation headers, the maximum transmission unit (MTU) of the Layer-2 fabric network (switches and hosts) must be set to greater than or equal to 1674 bytes \(including Layer-2 Ethernet headers\).

NICs that support the new *EncapOverhead* advanced adapter keyword set the MTU automatically through the Network Controller Host Agent. NICs that do not support the new *EncapOverhead* keyword need to set the MTU size manually on each physical host using the *JumboPacket* \(or equivalent\) keyword.

### Switches
When selecting a physical switch and router for your environment, make sure it supports the following set of capabilities:
- Switchport MTU settings \(required\)
- MTU set to >= 1674 bytes \(including L2-Ethernet Header\)
- L3 protocols \(required\)
- Equal-cost multi-path (ECMP) routing
- BGP \(IETF RFC 4271\)\-based ECMP

Implementations should support the MUST statements in the following IETF standards:
- RFC 2545: [BGP-4 Multiprotocol extensions for IPv6 Inter-Domain Routing](https://tools.ietf.org/html/rfc2545)
- RFC 4760: [Multiprotocol Extensions for BGP-4](https://tools.ietf.org/html/rfc4760)
- RFC 4893: [BGP Support for Four-octet AS Number Space](https://tools.ietf.org/html/rfc4893)
- RFC 4456: [BGP Route Reflection: An Alternative to Full Mesh Internal BGP (IBGP)](https://tools.ietf.org/html/rfc4456)
- RFC 4724: [Graceful Restart Mechanism for BGP](https://tools.ietf.org/html/rfc4724)

The following tagging protocols are required:
- VLAN - Isolation of various types of traffic
- 802.1q trunk

The following items provide Link control:
- Quality of Service \(QoS\) \(PFC only required if using RoCE\)
- Enhanced Traffic Selection \(802.1Qaz\)
- Priority-based Flow Control (PFC) \(802.1p/Q and 802.1Qbb\)

The following items provide availability and redundancy:
- Switch availability (required)
- A highly available router is required to perform gateway functions. You can provide this by using either a multi-chassis switch\router or technologies like the Virtual Router Redundancy Protocol (VRRP).

### Switch configuration examples
To help configure your physical switch or router, a set of sample configuration files for a variety of switch models and vendors is available at the [Microsoft SDN GitHub repository](https://github.com/microsoft/SDN/tree/master/SwitchConfigExamples). A detailed readme and tested command-line interface (CLI) commands for specific switches are provided.

## Compute
All Hyper-V hosts must have the appropriate operating system installed, be enabled for Hyper-V, and use an external Hyper-V virtual switch with at least one physical adapter connected to the management logical network. The host must be reachable via a management IP address assigned to the management host vNIC.

You can use any storage type that is compatible with Hyper-V, shared, or local.

> [!TIP]
> It is convenient to use the same name for all your virtual switches, but it is not mandatory. If you plan to use scripts to deploy, see the comment associated with the `vSwitchName` variable in the config.psd1 file.

### Host compute requirements
The following shows the minimum hardware and software requirements for the four physical hosts used in the example deployment.

Host|Hardware requirements|Software requirements|
--------|-------------------------|-------------------------
|Physical Hyper-V host|4-Core 2.66 GHz CPU<br> 32 GB of RAM<br> 300 GB of Disk Space<br> 1 Gb/s (or faster) physical network adapter|Operating system: As defined in<br> the “Applies to” at the start of this topic.<br> Hyper-V Role installed|

### SDN infrastructure VM role requirements
The following shows the requirements for the VM roles.

Role|vCPU requirements|Memory requirements|Disk requirements|
--------|-----------------------------|-----------------------|--------------------------
|Network Controller (three nodes)|4 vCPUs|4 GB minimum<br> (8 GB recommended)|75 GB for operating system drive
|SLB/MUX (three nodes)|8 vCPUs|8 GB recommended|75 GB for operating system drive
|RAS Gateway<br> (single pool of three nodes<br> gateways, two active, one passive)|8 vCPUs|8 GB recommended|75 GB for operating system drive
|RAS Gateway BGP router<br> for SLB/MUX peering<br> (alternatively use ToR switch<br> as BGP Router)|2 vCPUs|2 GB|75 GB for operating system drive|

If you use System Center - Virtual Machine Manager (VMM) for deployment, additional infrastructure VM resources are required for VMM and other non-SDN infrastructure. To learn more, see [System requirements for System Center Virtual Machine Manager](/system-center/vmm/system-requirements?preserve-view=true&view=sc-vmm-2019).

## Extending your infrastructure
The sizing and resource requirements for your infrastructure depend on the tenant workload VMs that you plan to host. The CPU, memory, and disk requirements for the infrastructure VMs (for example: Network Controller, SLB, gateway, and so on) are defined in the previous table. You can add more infrastructure VMs to scale as needed. However, any tenant VMs running on the Hyper-V hosts have their own CPU, memory, and disk requirements that you must consider.

When the tenant workload VMs start to consume too many resources on the physical Hyper-V hosts, you can extend your infrastructure by adding additional physical hosts. You can use either Windows Admin Center, VMM, or PowerShell scripts to create new server resources through the Network Controller. The method to use depends on how you initially deployed the infrastructure. If you need to add additional IP addresses for the HNV Provider network, you can create new logical subnets (with corresponding IP Pools) that the hosts can use.

## Phased deployment
Based on your requirements, you may need to deploy a subset of the SDN infrastructure. For example, if you want to only host customer workloads in your datacenter, and external communication is not required, you can deploy Network Controller and skip deploying SLB/MUX and gateway VMs. The following describes networking feature infrastructure requirements for a phased deployment of the SDN infrastructure.

Feature|Deployment requirements|Network requirements|
--------|-------------------------|-------------------------
|Logical Network management<br> Access control lists (ACLs) (for VLAN-based network)<br> Quality of Service (QoS) (for VLAN-based networks)<br>|Network Controller|None|
|Virtual Networking<br> User Defined Routing<br> ACLs (for virtual network)<br> Encrypted Subnets<br> QoS (for virtual networks)<br> Virtual network peering|Network Controller|HNV PA VLAN, Subnet, Router|
|Inbound/Outbound NAT<br> Load Balancing|Network Controller<br> SLB/MUX|BGP on HNV PA network<br> Private and Public VIP subnets|
|GRE gateway connections|Network Controller<br> Gateway|BGP on HNV PA network<br> GRE VIP subnet|
|IPSec gateway connections|Network Controller<br> SLB/MUX<br> Gateway|BGP on HNV PA network<br> Public VIP subnet|
|L3 gateway connections|Network Controller<br> Gateway|Tenant VLAN, Subnet, Router<br> BGP on tenant VLAN optional.|

## Next steps
For related information, see also:
- [Requirements for Deploying Network Controller](/windows-server/networking/sdn/plan/installation-and-preparation-requirements-for-deploying-network-controller)
- [SDN in Azure Stack HCI](./software-defined-networking.md)