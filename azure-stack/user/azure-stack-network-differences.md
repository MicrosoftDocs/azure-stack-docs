---
title: Azure Stack Hub networking differences 
description: Learn about differences and considerations when working with networking in Azure Stack Hub.
author: sethmanheim
ms.date: 05/17/2021
ms.topic: article
ms.author: sethm
ms.reviewer: wamota
ms.lastreviewed: 07/10/2019

# Intent: As an Azure Stack user, I want to know the networking differences between Azure and Azure Stack
# Keyword: azure stack networking differences

---


# Differences and considerations for Azure Stack Hub networking

Azure Stack Hub networking has many of the features provided by Azure networking. However, there are some key differences that you should understand before deploying an Azure Stack Hub network.

This article provides an overview of the unique considerations for Azure Stack Hub networking and its features. To learn about high-level differences between Azure Stack Hub and Azure, see the [Key considerations](azure-stack-considerations.md) article.

> [!IMPORTANT]
> Azure Stack Hub does not offer support for IPv6 and there are no roadmap items to provide support.

## Cheat sheet: Networking differences

| Service | Feature | Azure (global) | Azure Stack Hub |
|--------------------------|----------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------|
| DNS | Multi-tenant DNS | Supported | Not yet supported |
|  | DNS zones per subscription | 100 (default)<br>Can be increased on request. | 100 |
|  | DNS record sets per zone | 5000 (default)<br>Can be increased on request. | 5000 |
|  | Name servers for zone delegation | Azure provides four name servers for each user (tenant) zone that is created. | Azure Stack Hub provides two name servers for each user (tenant) zone that is created. |
| Azure Firewall | Network security service | Azure Firewall is a managed, cloud-based network security service that protects your Azure Virtual Network resources. | Not yet supported. |
| Virtual Network | Virtual network peering | Connect two virtual networks in the same region through the Azure backbone network. | Supported since version 2008 [Virtual Network peering](virtual-network-peering.md) |
|  | IPv6 addresses | You can assign an IPv6 address as part of the [Network Interface Configuration](/azure/virtual-network/virtual-network-network-interface-addresses#ip-address-versions). | Only IPv4 is supported. |
|  | DDoS Protection Plan | Supported | Not yet supported. |
|  | Scale Set IP Configurations | Supported | Not yet supported. |
|  | Private Access Services (Subnet) | Supported | Not yet supported. |
|  | Service Endpoints | Supported for internal (non-Internet) connection to Azure Services. | Not yet supported. |
|  | Service Endpoint Policies | Supported | Not yet supported. |
|  | Service Tunnels | Supported | Not yet supported.  |
| Network Security Groups | Augmented Security Rules | Supported | Supported. |
|  | Effective Security Rules | Supported | Not yet supported. |
|  | Application Security Groups | Supported | Not yet supported. |
|  | Rule Protocols | TCP, UDP, ICMP, Any | Only TCP, UDP or Any |
| Virtual Network Gateways | Point-to-Site VPN Gateway | Supported | Not yet supported. |
|  | Vnet-to-Vnet Gateway | Supported | Not yet supported. |
|  | Virtual Network Gateway Type | Azure Supports VPN<br> Express Route <br> Hyper Net. | Azure Stack Hub currently supports only VPN type. |
|  | VPN Gateway SKUs | Support for Basic, GW1, GW2, GW3, Standard High Performance, Ultra-High Performance. | Support for Basic, Standard, and High-Performance SKUs. |
|  | VPN Type | Azure supports both policy-based and route-based. | Azure Stack Hub supports route-based only. |
|  | BGP Settings | Azure supports configuration of BGP Peering Address and Peer Weight. | BGP Peering Address and Peer Weight are auto-configured in Azure Stack Hub.<br/> Support for up to 150 routes for BGP advertisement.<br/> There's no way for the user to configure these settings with their own values. |
|  | Default Gateway Site | Azure supports configuration of a default site for forced tunneling. | Not yet supported. |
|  | Gateway Resizing | Azure supports resizing the gateway after deployment. | Resizing not supported. |
|  | Availability Configuration | Active/Active | Active/Passive |
|  | UsePolicyBasedTrafficSelectors | Azure supports using policy-based traffic selectors with route-based gateway connections. | Not yet supported. |
|  | Monitoring and Alerts | Azure uses Azure Monitor to provide the ability to set up alerts for VPN resources. | Not yet supported.|
| Load balancer | SKU | Basic and Standard Load Balancers are supported | Only the Basic Load Balancer is supported.<br>The SKU property is not supported.<br>The Basic SKU load balancer supports 200 front-end IP configurations per load balancer.  |
|  | Zones | Availability Zones are Supported. | Not yet supported |
|  | Inbound NAT Rules support for Service Endpoints | Azure supports specifying Service Endpoints for Inbound NAT rules. | Azure Stack Hub doesn't yet support Service Endpoints, so these can't be specified. |
|  | Protocol | Azure Supports specifying GRE or ESP. | Protocol Class isn't supported in Azure Stack Hub. |
|  | Health Probes | Azure originates the Load Balancer health probes from the IP address 168.63.129.16 | Azure Stack Hub Load Balancer health probes source is from the subnet Gateway IP and originates from the host where the Virtual Machine DIP is present. For example, if the subnet range is 10.0.0.0/24, the first IP of the subnet is reserved for the gateway IP, which would be 10.0.0.1. |
| Internal Load Balancer | Front end IP | No limit. | Azure Stack Hub provides an IP pool of 127 IPs for the internal load balancer's front end IPs. A small subset of that IP pool (8) is used for its internal infrastructure and 119 are available for users. |
| Public IP Address | Public IP Address Version | Azure supports both IPv6 and IPv4. | Only IPv4 is supported. |
| | SKU | Azure supports Basic and Standard. | Only Basic is supported. |
| Network Interface | Get Effective Route Table | Supported | Not yet supported. |
|  | Get Effective ACLs | Supported | Not yet supported. |
|  | Enable Accelerated Networking | Supported | Not yet supported. |
|  | IP Forwarding | Disabled by default.  Can be enabled. | Toggling this setting isn't supported.  On by default. |
|  | Application Security Groups | Supported | Not yet supported. |
|  | Internal DNS Name Label | Supported | Not yet supported. |
|  | Private IP Address Version | Both IPv6 and IPv4 are supported. | Only IPv4 is supported. |
|  | Static MAC Address | Not supported | Not supported. Each Azure Stack Hub system uses the same MAC address pool. |
|  | Network interface for virtual machines | Supported. New network interface configuration only applied after rebooting the virtual machine. | Supported. New network interface configuration is applied while the virtual machine is running. This might impact overall virtual machine connectivity and drop existing connections for a few seconds. It is recommended to add the network interface while the virtual machine is stopped or during a planned maintenance. |
|  | Primary Network interface for virtual machines replacement | Supported. New network interface configuration only applied after rebooting the virtual machine. | It is possible to replace the primary network interface of a virtual machine by stopping the VM, attaching a second network interface, detaching the primary interface and deleting the primary network interface resource. If primary network interface resource is not deleted, the virtual machine will not start. |
| Network Watcher | Network Watcher tenant network monitoring capabilities | Supported | Not yet supported. |
| CDN | Content Delivery Network profiles | Supported | Not yet supported. |
| Application gateway | Layer-7 load balancing | Supported | Not yet supported. |
| Traffic Manager | Route incoming traffic for optimal application performance and reliability. | Supported | Not yet supported. |
| Express Route | Set up a fast, private connection to Microsoft cloud services from your on-premises infrastructure or colocation facility. | Supported | Support for connecting Azure Stack Hub to an Express Route circuit. |
| Virtual Machine Scale Sets | Public IP per Virtual Machine | Supported | Not supported. If needed, similar functionality can be achieved with a load balancer. |
|  | Update or change VMs primary NIC | Supported | Not supported. It's not possible to elevate a secondary NIC to primary or vice versa in Azure Stack Hub. |

## API versions 

Azure Stack Hub Networking supports the following API versions: 

- 2018-11-01
- 2018-10-01
- 2018-08-01
- 2018-07-01
- 2018-06-01
- 2018-05-01
- 2018-04-01
- 2018-03-01
- 2018-02-01
- 2018-01-01
- 2017-11-01
- 2017-10-01

## Next steps

[DNS in Azure Stack Hub](azure-stack-dns.md)
