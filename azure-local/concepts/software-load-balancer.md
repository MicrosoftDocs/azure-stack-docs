---
title: Software Load Balancer (SLB) for SDN in Azure Local and Windows Server
description: Use this article to learn about Software Load Balancer for Software Defined Networking in Azure Local and Windows Server.
author: AnirbanPaul
ms.author: anpaul
ms.topic: overview
ms.service: azure-local
ms.date: 10/10/2025
ms.custom: sfi-image-nochange
---

# What is Software Load Balancer (SLB) for SDN?

> Applies to: Azure Local 2311.2 and later; Windows Server 2022, Windows Server 2019, Windows Server 2016

Cloud Service Providers (CSPs) and enterprises that are deploying [Software Defined Networking (SDN)](software-defined-networking-23h2.md) can use Software Load Balancer (SLB) to evenly distribute tenant and tenant customer network traffic among virtual network resources. SLB enables multiple servers to host the same workload, providing high availability and scalability.

Software Load Balancer can provide a multitenant, unified edge by integrating with SDN technologies such as [RAS Gateway](gateway-overview.md), [Datacenter Firewall](datacenter-firewall-overview.md), and [Route Reflector](route-reflector-overview.md).

> [!NOTE]
> Multitenancy for VLANs isn't supported by [Network Controller](network-controller-overview.md). However, you can use VLANs with SLB for service provider managed workloads, such as the datacenter infrastructure and high density web servers.

Using Software Load Balancer, you can scale out your load balancing capabilities using SLB virtual machines (VMs) on the same Hyper-V compute servers that you use for your other VM workloads. Because of this, Software Load Balancer supports rapid creation and deletion of load balancing endpoints as required for CSP operations. In addition, Software Load Balancer supports tens of gigabytes per system, provides a simple provisioning model, and is easy to scale out and in.

To learn how to manage Software Load Balancer policies using Windows Admin Center, see [Manage Software Load Balancer for SDN](../manage/load-balancers.md).

## What does Software Load Balancer include?

Software Load Balancer includes the following capabilities:

- Layer 4 (L4) load balancing services for north/south and east/west TCP/UDP traffic.

- Public network and Internal network traffic load balancing.

- Dynamic IP addresses (DIPs) support on virtual Local Area Networks (VLANs) and on virtual networks that you create by using Hyper-V Network Virtualization.

- Health probe support.

- Ready for cloud scale, including scale-out capability and scale-up capability for multiplexers and host agents.

For more information, see [Software Load Balancer features](#software-load-balancer-features) in this article.

## How Software Load Balancer works

Software Load Balancer works by mapping virtual IP addresses (VIPs) to DIPs that are part of a cloud service set of resources in the datacenter.

VIPs are single IP addresses that provide public access to a pool of load balanced VMs. For example, VIPs are IP addresses that are exposed on the internet so that tenants and tenant customers can connect to tenant resources in the cloud datacenter.

DIPs are the IP addresses of the member VMs of a load balanced pool behind the VIP. DIPs are assigned within the cloud infrastructure to the tenant resources.

VIPs are located in the SLB Multiplexer (MUX). The MUX consists of one or more VMs. Network Controller provides each MUX with each VIP, and each MUX in turn uses Border Gateway Protocol (BGP) to advertise each VIP to routers on the physical network as a /32 route. BGP allows the physical network routers to:

- Learn that a VIP is available on each MUX, even if the MUXes are on different subnets in a Layer 3 network.

- Spread the load for each VIP across all available MUXes using Equal Cost Multi-Path (ECMP) routing.

- Automatically detect a MUX failure or removal and stop sending traffic to the failed MUX.

- Spread the load from the failed or removed MUX across the healthy MUXes.

When public traffic arrives from the internet, the SLB MUX examines the traffic, which contains the VIP as a destination, and maps and rewrites the traffic so that it arrives at an individual DIP. For inbound network traffic, this transaction is performed in a two-step process that is split between the MUX VMs and the Hyper-V host where the destination DIP is located:

1. Load balance - the MUX uses the VIP to select a DIP, encapsulates the packet, and forwards the traffic to the Hyper-V host where the DIP is located.

1. Network Address Translation (NAT) - the Hyper-V host removes encapsulation from the packet, translates the VIP to a DIP, remaps the ports, and forwards the packet to the DIP VM.

The MUX knows how to map VIPs to the correct DIPs because of load balancing policies that you define by using Network Controller. These rules include Protocol, Front-end Port, Back-end Port, and distribution algorithm (5, 3, or 2 tuples).

When tenant VMs respond and send outbound network traffic back to the internet or remote tenant locations, because the NAT is performed by the Hyper-V host, the traffic bypasses the MUX and goes directly to the edge router from the Hyper-V host. This MUX bypass process is called Direct Server Return (DSR).

And after the initial network traffic flow is established, the inbound network traffic bypasses the SLB MUX completely.

In the following illustration, a client computer performs a DNS query for the IP address of a company SharePoint site - in this case, a fictional company named Contoso. The following process occurs:

1. The DNS server returns the VIP 107.105.47.60 to the client.

1. The client sends an HTTP request to the VIP.

1. The physical network has multiple paths available to reach the VIP located on any MUX. Each router along the way uses ECMP to pick the next segment of the path until the request arrives at a MUX.

1. The MUX that receives the request checks configured policies, and sees that there are two DIPs available, 10.10.10.5 and 10.10.20.5, on a virtual network to handle the request to the VIP 107.105.47.60

1. The MUX selects DIP 10.10.10.5 and encapsulates the packets using VXLAN so that it can send it to the host containing the DIP using the host's physical network address.

1. The host receives the encapsulated packet and inspects it. It removes the encapsulation and rewrites the packet so that the destination is now DIP 10.10.10.5 instead of the VIP, and then sends the traffic to DIP VM.

1. The request reaches the Contoso SharePoint site in Server Farm 2. The server generates a response and sends it to the client, using its own IP address as the source.

1. The host intercepts the outgoing packet in the virtual switch, which remembers that the client, now the destination, made the original request to the VIP. The host rewrites the source of the packet to be the VIP so that the client doesn't see the DIP address.

1. The host forwards the packet directly to the default gateway for the physical network that uses its standard routing table to forward the packet on to the client, which eventually receives the response.

:::image type="content" source="media/software-load-balancer/slb-process.jpg" alt-text="Software Load Balancing process." lightbox="media/software-load-balancer/slb-process.jpg":::

### Load balancing internal datacenter traffic

When load balancing network traffic internal to the datacenter, such as between tenant resources that are running on different servers and are members of the same virtual network,  the Hyper-V virtual switch to which the VMs are connected performs NAT.

With internal traffic load balancing, the first request is sent to and processed by the MUX, which selects the appropriate DIP, and then routes the traffic to the DIP. From that point forward, the established traffic flow bypasses the MUX and goes directly from VM to VM.

### Health probes

Software Load Balancer includes the following health probes to validate the health of the network infrastructure:

- TCP probe to port

- HTTP probe to port and URL

Unlike a traditional load balancer appliance where the probe originates on the appliance and travels across the wire to the DIP, the SLB probe originates on the host where the DIP is located and goes directly from the SLB host agent to the DIP, further distributing the work across the hosts.

## Software Load Balancer infrastructure

Before you can configure Software Load Balancer, you must first deploy Network Controller and one or more SLB MUX VMs.

In addition, you must configure the Azure Local hosts with the SDN-enabled Hyper-V virtual switch and ensure that the SLB Host Agent is running. The routers that serve the hosts must support ECMP routing and Border Gateway Protocol (BGP), and they must be configured to accept BGP peering requests from the SLB MUXes.

The following figure provides an overview of the SLB infrastructure.

:::image type="content" source="media/software-load-balancer/slb-overview.png" alt-text="Software Load Balancer infrastructure." lightbox="media/software-load-balancer/slb-overview.png":::

The following sections provide more information about these elements of the Software Load Balancer infrastructure.

### Network Controller

Network Controller hosts the SLB Manager and performs the following actions for Software Load Balancer:

- Processes SLB commands that come in through the Northbound API from Windows Admin Center, System Center, Windows PowerShell, or another network management application.

- Calculates policy for distribution to Azure Local hosts and SLB MUXes.

- Provides the health status of the Software Load Balancer infrastructure.

You can use Windows Admin Center or Windows PowerShell to install and configure Network Controller and other SLB infrastructure.

### SLB MUX

The SLB MUX processes inbound network traffic and maps VIPs to DIPs, then forwards the traffic to the correct DIP. Each MUX also uses BGP to publish VIP routes to edge routers. BGP Keep Alive notifies MUXes when a MUX fails, which allows active MUXes to redistribute the load if there's a MUX failure. This essentially provides load balancing for the load balancers.

### SLB Host Agent

When you deploy Software Load Balancer, you must use Windows Admin Center, System Center, Windows PowerShell, or another management application to deploy the SLB Host Agent on every host server.

The SLB Host Agent listens for SLB policy updates from Network Controller. In addition, the host agent programs rules for SLB into the SDN-enabled Hyper-V virtual switches that are configured on the local computer.

### SDN-enabled Hyper-V virtual switch

For a virtual switch to be compatible with SLB, the Virtual Filtering Platform (VFP) extension must be enabled on the virtual switch. This is done automatically by the SDN deployment PowerShell scripts, Windows Admin Center deployment wizard, and System Center Virtual Machine Manager (SCVMM) deployment.

For information on enabling VFP on virtual switches, see the Windows PowerShell commands [Get-VMSystemSwitchExtension](/powershell/module/hyper-v/get-vmsystemswitchextension?view=win10-ps&preserve-view=true) and [Enable-VMSwitchExtension](/powershell/module/hyper-v/enable-vmswitchextension?f=255&MSPPError=-2147217396&view=win10-ps&preserve-view=true).

The SDN-enabled Hyper-V virtual switch performs the following actions for SLB:

- Processes the data path for SLB.

- Receives inbound network traffic from the MUX.

- Bypasses the MUX for outbound network traffic, sending it to the router using DSR.

### BGP router

The BGP router performs the following actions for Software Load Balancer:

- Routes inbound traffic to the MUX using ECMP.

- For outbound network traffic, uses the route provided by the host.

- Listens for route updates for VIPs from SLB MUX.

- Removes SLB MUXes from the SLB rotation if Keep Alive fails.

## Software Load Balancer features

The following sections describe some of the features and capabilities of Software Load Balancer.

### Core functionality

- SLB provides Layer 4 load balancing services for north/south and east/west TCP/UDP traffic.

- You can use SLB on a Hyper-V Network Virtualization-based network.

- You can use SLB with a VLAN-based network for DIP VMs connected to an SDN enabled Hyper-V virtual switch.

- One SLB instance can handle multiple tenants.

- SLB and DIP support a scalable and low-latency return path, as implemented by DSR.

- SLB functions when you're also using Switch Embedded Teaming (SET) or Single Root Input/Output Virtualization (SR-IOV).

- SLB includes Internet Protocol version 6 (IPv6) and version 4 (IPv4) support.

- For site-to-site gateway scenarios, SLB provides NAT functionality to enable all site-to-site connections to utilize a single public IP.

### Scale and performance

- Ready for cloud scale, including scale-out and scale-up capability for MUXes and Host Agents.

- One active SLB Manager Network Controller module can support eight MUX instances.

### High availability

- You can deploy SLB to more than two nodes in an active/active configuration.

- MUXes can be added and removed from the MUX pool without impacting the SLB service. This maintains SLB availability when individual MUXes are being patched.

- Individual MUX instances have an uptime of 99 percent.

- Health monitoring data is available to management entities.

## Next steps

For related information, see also:

- [Manage Software Load Balancer for SDN](../manage/load-balancers.md)
- [SDN in Azure Local and Windows Server](software-defined-networking-23h2.md)
