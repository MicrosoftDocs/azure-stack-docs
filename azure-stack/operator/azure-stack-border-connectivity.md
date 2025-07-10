---
title: Border connectivity and network integration for Azure Stack Hub integrated systems
description: Learn how to plan for datacenter border network connectivity in Azure Stack Hub integrated systems.
author: sethmanheim
ms.topic: how-to
ms.date: 08/18/2021
ms.author: sethm
ms.reviewer: wamota
ms.lastreviewed: 01/14/2021

# Intent: As an Azure Stack operator, I want to know how to plan for datacenter border network connectivity with multi-node Azure Stack.
# Keyword: azure stack border connectivity

---


# Border connectivity
Network integration planning is an important prerequisite for successful Azure Stack Hub integrated systems deployment, operation, and management. Border connectivity planning begins by choosing if you want use dynamic routing with border gateway protocol (BGP). This requires assigning a 16-bit autonomous system number (ASN), public or private, or using static routing.

> [!IMPORTANT]
> The top of rack (TOR) switches require Layer 3 uplinks with Point-to-Point IPs (/30 networks) configured on the physical interfaces. Layer 2 uplinks with TOR switches supporting Azure Stack Hub operations isn't supported. The Border device can support 32-bit BGP autonomous system number (ASN).
>
> The physical connectivity between the border devices and Azure Stack Hub's top of rack (TOR) switches require network transceivers. It is important to ensure the required module type (SR, LR, ER, or other) is discussed with the hardware solution provider prior to the onsite deployment.

## BGP routing
Using a dynamic routing protocol like BGP guarantees that your system is always aware of network changes and facilitates administration. For enhanced security, a password may be set on the BGP peering between the TOR and the Border.

As shown in the following diagram, advertising of the private IP space on the TOR switch is blocked using a prefix-list. The prefix list denies the advertisement of the Private Network and it's applied as a route-map on the connection between the TOR and the border.

The Software Load Balancer (SLB) running inside the Azure Stack Hub solution peers to the TOR devices so it can dynamically advertise the VIP addresses.

To ensure that user traffic immediately and transparently recovers from failure, the VPC or MLAG configured between the TOR devices allows the use of multi-chassis link aggregation to the hosts and HSRP or VRRP that provides network redundancy for the IP networks.

![BGP routing](media/azure-stack-border-connectivity/bgp-routing.svg)

## Static routing
Static routing requires additional configuration to the border devices. It requires more manual intervention and management as well as thorough analysis before any change. Issues caused by a configuration error may take more time to rollback depending on the changes made. This routing method isn't recommended, but it's supported.

To integrate Azure Stack Hub into your networking environment using static routing, all four physical links between the border and the TOR device must be connected. High availability can't be guaranteed because of how static routing works.

The border device must be configured with static routes pointing to each one of the four P2P IP's set between the TOR and the Border for traffic destined to any network inside Azure Stack Hub, but only the *External* or Public VIP network is required for operation. Static routes to the *BMC* and the *External* networks are required for initial deployment. Operators can choose to leave static routes in the border to access management resources that reside on the *BMC*  and the *Infrastructure* network. Adding static routes to *switch infrastructure* and *switch management* networks is optional.

The TOR devices are configured with a static default route sending all traffic to the border devices. The one traffic exception to the default rule is for the private space, which is blocked using an Access Control List applied on the TOR to border connection.

Static routing applies only to the uplinks between the TOR and border switches. BGP dynamic routing is used inside the rack because it's an essential tool for the SLB and other components and can't be disabled or removed.

![Static routing](media/azure-stack-border-connectivity/static-routing.svg)

<sup>\*</sup> The BMC network is optional after deployment.

<sup>\*\*</sup> The Switch Infrastructure network is optional, as the whole network can be included in the Switch Management network.

<sup>\*\*\*</sup> The Switch Management network is required and can be added separately from the Switch Infrastructure network.

## Next steps

- [DNS integration](azure-stack-integrate-dns.md)
- [Transparent proxy for Azure Stack Hub](azure-stack-transparent-proxy.md)
