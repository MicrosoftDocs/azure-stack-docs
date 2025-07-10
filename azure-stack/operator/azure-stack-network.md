---
title: Network integration planning for Azure Stack Hub 
description: Learn how to plan for datacenter network integration with Azure Stack Hub integrated systems.
author: sethmanheim
ms.topic: article
ms.date: 01/27/2025
ms.author: sethm
ms.lastreviewed: 03/18/2022

# Intent: As an Azure Stack operator, I want to plan for my network integration so I'm prepared.
# Keyword: azure stack network integration planning

---


# Network integration planning for Azure Stack Hub

This article provides Azure Stack Hub network infrastructure information to help you decide how to best integrate Azure Stack Hub into your existing networking environment.

> [!NOTE]
> To resolve external DNS names from Azure Stack Hub (for example, `www.bing.com`), you must provide DNS servers to which to forward DNS requests. For more information about Azure Stack Hub DNS requirements, see [Azure Stack Hub datacenter integration - DNS](azure-stack-integrate-dns.md).

## Physical network design

The Azure Stack Hub solution requires a resilient and highly available physical infrastructure to support its operation and services. To integrate Azure Stack Hub to the network, it requires uplinks from the Top-of-Rack switches (ToR) to the nearest switch or router, which in this article is referred as *Border*. The ToRs can be uplinked to a single or a pair of Borders. The ToR is pre-configured by our automation tool. It expects a minimum of one connection between ToR and Border when using BGP Routing and a minimum of two connections (one per ToR) between ToR and Border when using Static Routing, with a maximum of four connections on either routing option. These connections are limited to SFP+ or SFP28 media and a minimum of one GB speed. Check with your original equipment manufacturer (OEM) hardware vendor for availability. The following diagram presents the recommended design:

![Recommended Azure Stack network design](media/azure-stack-network/physical-network.svg)

### Bandwidth allocation

Azure Stack Hub is built using Windows Server 2019 Failover Cluster and Spaces Direct technologies. To ensure that the Spaces Direct storage communications can meet the performance and scale required of the solution, a portion of the Azure Stack Hub physical network configuration is set up to use traffic separation and bandwidth guarantees. The network configuration uses traffic classes to separate the Spaces Direct, RDMA-based communications from that of the network utilization by the Azure Stack Hub infrastructure and/or tenant. To align to the current best practices defined for Windows Server 2019, Azure Stack Hub is changing to use an additional traffic class or priority to further separate server to server communication in support of the Failover Clustering control communication. This new traffic class definition is configured to reserve 2% of the available, physical bandwidth. This traffic class and bandwidth reservation configuration is accomplished by a change on the top-of-rack (ToR) switches of the Azure Stack Hub solution and on the host or servers of Azure Stack Hub. Note that changes are not required on the customer border network devices. These changes provide better resiliency for Failover Cluster communication and are meant to avoid situations where network bandwidth is fully consumed and as a result Failover Cluster control messages are disrupted. Note that the Failover Cluster communication is a critical component of the Azure Stack Hub infrastructure and if disrupted for long periods, can lead to instability in the Spaces Direct storage services or other services that will eventually impact tenant or end-user workload stability.

## Logical networks

Logical networks represent an abstraction of the underlying physical network infrastructure. They're used to organize and simplify network assignments for hosts, virtual machines (VMs), and services. As part of logical network creation, network sites are created to define the virtual local area networks (VLANs), IP subnets, and IP subnet/VLAN pairs that are associated with the logical network in each physical location.

The following table shows the logical networks and associated IPv4 subnet ranges that you must plan for:

| Logical network | Description | Size |
| -------- | ------------- | ------------ |
| Public VIP | Azure Stack Hub uses a total of 31 addresses from this network and the rest are used by tenant VMs. From the 31 addresses, 8 public IP addresses are used for a small set of Azure Stack Hub services. If you plan to use App Service and the SQL resource providers, 7 more addresses are used. The remaining 16 IPs are reserved for future Azure services. | /26 (62 hosts) - /22 (1022 hosts)<br><br>Recommended = /24 (254 hosts) |
| Switch infrastructure | Point-to-point IP addresses for routing purposes, dedicated switch management interfaces, and loopback addresses assigned to the switch. | /26 |
| Infrastructure | Used for Azure Stack Hub internal components to communicate. | /24 |
| Private | Used for the storage network, private VIPs, Infrastructure containers and other internal functions. For more details reference the [Private network](#private-network) section in this article. | /20 |
| BMC | Used to communicate with the BMCs on the physical hosts. | /26 |

> [!NOTE]
> An alert on the portal reminds the operator to run the PEP cmdlet **Set-AzsPrivateNetwork** to add a new /20 private IP space. For more information and guidance on selecting the /20 private IP space, see the [Private network](#private-network) section in this article.

## Network infrastructure

The network infrastructure for Azure Stack Hub consists of several logical networks that are configured on the switches. The following diagram shows these logical networks and how they integrate with the top-of-rack (TOR), baseboard management controller (BMC), and border (customer network) switches.

![Logical network diagram and switch connections](media/azure-stack-network/networkdiagram.svg)

### BMC network

This network is dedicated to connecting all the baseboard management controllers (also known as BMC or service processors) to the management network. Examples include: iDRAC, iLO, iBMC, and so on. Only one BMC account is used to communicate with any BMC node. If present, the Hardware Lifecycle Host (HLH) is located on this network and may provide OEM-specific software for hardware maintenance or monitoring.

The HLH also hosts the Deployment VM (DVM). The DVM is used during Azure Stack Hub deployment and is removed when deployment completes. The DVM requires internet access in connected deployment scenarios to test, validate, and access multiple components. These components can be inside and outside of your corporate network (for example: NTP, DNS, and Azure). For more information about connectivity requirements, see the [NAT section in Azure Stack Hub firewall integration](azure-stack-firewall.md#network-address-translation).

### Private network

This /20 (4096 IPs) network is private to the Azure Stack Hub region (doesn't route beyond the border switch devices of the Azure Stack Hub system) and is divided into multiple subnets, here are some examples:

- **Storage network**: A /25 (128 IPs) network used to support the use of Spaces Direct and Server Message Block (SMB) storage traffic and VM live migration.
- **Internal virtual IP network**: A /25 network dedicated to internal-only VIPs for the software load balancer.
- **Container network**: A /23 (512 IPs) network dedicated to internal-only traffic between containers running infrastructure services.

The Azure Stack Hub system requires an additional /20 private internal IP space. This network is private to the Azure Stack Hub system (doesn't route beyond the border switch devices of the Azure Stack Hub system) and can be reused on multiple Azure Stack Hub systems within your datacenter. While the network is private to Azure Stack, it must not overlap with other networks in the datacenter. The /20 private IP space is divided into multiple networks that enable running the Azure Stack Hub infrastructure on containers. In addition, this new private IP space enables ongoing efforts to reduce the required routable IP space prior to deployment. The goal of running the Azure Stack Hub infrastructure in containers is to optimize utilization and enhance performance. In addition, the /20 private IP space is also used to enable ongoing efforts that will reduce required routable IP space before deployment. For guidance on private IP space, see [RFC 1918](https://tools.ietf.org/html/rfc1918).

### Azure Stack Hub infrastructure network

This /24 network is dedicated to internal Azure Stack Hub components so that they can communicate and exchange data among themselves. This subnet can be routable externally from the Azure Stack Hub solution to your datacenter. We do not recommend using public or internet routable IP addresses on this subnet. This network is advertised to the border but most of its IPs are protected by Access Control Lists (ACLs). The IPs allowed for access are within a small range, equivalent in size to a /27 network and host services such as the [privileged end point (PEP)](azure-stack-privileged-endpoint.md) and [Azure Stack Hub backup](azure-stack-backup-reference.md).

### Public VIP network

The public VIP network is assigned to the network controller in Azure Stack. It's not a logical network on the switch. The SLB uses the pool of addresses and assigns /32 networks for tenant workloads. On the switch routing table, these /32 IPs are advertised as an available route via BGP. This network contains the external-accessible or public IP addresses. The Azure Stack Hub infrastructure reserves the first 31 addresses from this public VIP network while the remainder is used by tenant VMs. The network size on this subnet can range from a minimum of /26 (64 hosts) to a maximum of /22 (1022 hosts). We recommend that you plan for a /24 network.

#### Connecting to on-premises networks

Azure Stack Hub uses virtual networks for customer resources such as virtual machines, load balancers, and others.

There are several different options for connecting from resources inside the virtual network to on-premises/corporate resources:

- Use public IP addresses from the public VIP network.
- Use Virtual Network Gateway or Network Virtual Appliance (NVA).

When a S2S VPN tunnel is used to connect resources to or from on-premises networks, you may encounter a scenario in which a resource also has a public IP address assigned, and it is no longer reachable via that public IP address. If the source attempts to access the public IP fall within the same subnet range that is defined in the Local Network Gateway Routes (Virtual Network Gateway) or user-defined route for NVA solutions, Azure Stack Hub attempts to route the traffic outbound back to the source through the S2S tunnel, based on the routing rules that are configured. The return traffic uses the private IP address of the VM, rather than be source NATed as the public IP address:

:::image type="content" source="media/azure-stack-network/pvip-1.png" alt-text="Route traffic" lightbox="media/azure-stack-network/pvip-1-expanded.png":::

There are two solutions to this issue:

- Route the traffic directed to the public VIP network to the internet.
- Add a NAT device to NAT any subnet IPs defined in the local network gateway directed to the public VIP network.

:::image type="content" source="media/azure-stack-network/pvip-2.png" alt-text="Route traffic solution" lightbox="media/azure-stack-network/pvip-2-expanded.png":::

### Switch infrastructure network

This /26 network is the subnet that contains the routable point-to-point IP /30 (two host IPs) subnets and the loopbacks, which are dedicated /32 subnets for in-band switch management and BGP router ID. This range of IP addresses must be routable outside the Azure Stack Hub solution to your datacenter. They can be private or public IPs.

### Switch management network

This /29 (six host IPs) network is dedicated to connecting the management ports of the switches. It allows out-of-band access for deployment, management, and troubleshooting. It's calculated from the switch infrastructure network previously mentioned.

## Permitted networks

The deployment worksheet has a field allowing the operator to change some access control lists to allow access to network device management interfaces and the hardware lifecycle host (HLH) from a trusted datacenter network range. With the access control list change, the operator can allow their management jumpbox VMs within a specific network range to access the switch management interface, and the HLH OS. The operator can provide one or multiple subnets to this list; if left blank, it defaults to denying access. This new functionality replaces the need for post-deployment manual intervention as it used to be described on the [Modify specific settings on your Azure Stack Hub switch configuration](./azure-stack-customer-defined.md#access-control-list-updates).

## Next steps

- [Virtual network traffic routing](/azure/virtual-network/virtual-networks-udr-overview)
- Learn about network planning: [Border connectivity](azure-stack-border-connectivity.md)
