---
title: Border connectivity and network integration for Azure Stack Hub integrated systems | Microsoft Docs
description: Learn how to plan for datacenter border network connectivity in Azure Stack Hub integrated systems.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.assetid: 
ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 11/15/2019
ms.author: mabrigg
ms.reviewer: wamota
ms.lastreviewed: 11/15/2019
---

# Border connectivity 
Network integration planning is an important prerequisite for successful Azure Stack Hub integrated systems deployment, operation, and management. Border connectivity planning begins by choosing if you want use dynamic routing with border gateway protocol (BGP). This requires assigning a 16-bit BGP autonomous system number (public or private) or using static routing, where a static default route is assigned to the border devices.

> [!IMPORTANT]
> The top of rack (TOR) switches require Layer 3 uplinks with Point-to-Point IPs (/30 networks) configured on the physical interfaces. Layer 2 uplinks with TOR switches supporting Azure Stack Hub operations isn't supported.

## BGP routing
Using a dynamic routing protocol like BGP guarantees that your system is always aware of network changes and facilitates administration. For enhanced security, a password may be set on the BGP peering between the TOR and the Border.

As shown in the following diagram, advertising of the private IP space on the TOR switch is blocked using a prefix-list. The prefix list denies the advertisement of the Private Network and it's applied as a route-map on the connection between the TOR and the border.

The Software Load Balancer (SLB) running inside the Azure Stack Hub solution peers to the TOR devices so it can dynamically advertise the VIP addresses.

To ensure that user traffic immediately and transparently recovers from failure, the VPC or MLAG configured between the TOR devices allows the use of multi-chassis link aggregation to the hosts and HSRP or VRRP that provides network redundancy for the IP networks.

![BGP routing](media/azure-stack-border-connectivity/bgp-routing.png)

## Static routing
Static routing requires additional configuration to the border devices. It requires more manual intervention and management as well as thorough analysis before any change. Issues caused by a configuration error may take more time to rollback depending on the changes made. This routing method isn't recommended, but it's supported.

To integrate Azure Stack Hub into your networking environment using static routing, all four physical links between the border and the TOR device must be connected. High availability can't be guaranteed because of how static routing works.

The border device must be configured with static routes pointing to each one of the four P2P IP's set between the TOR and the Border for traffic destined to any network inside Azure Stack Hub, but only the *External* or Public VIP network is required for operation. Static routes to the *BMC* and the *External* networks are required for initial deployment. Operators can choose to leave static routes in the border to access management resources that reside on the *BMC*  and the *Infrastructure* network. Adding static routes to *switch infrastructure* and *switch management* networks is optional.

The TOR devices are configured with a static default route sending all traffic to the border devices. The one traffic exception to the default rule is for the private space, which is blocked using an Access Control List applied on the TOR to border connection.

Static routing applies only to the uplinks between the TOR and border switches. BGP dynamic routing is used inside the rack because it's an essential tool for the SLB and other components and can't be disabled or removed.

![Static routing](media/azure-stack-border-connectivity/static-routing.png)

<sup>\*</sup> The BMC network is optional after deployment.

<sup>\*\*</sup> The Switch Infrastructure network is optional, as the whole network can be included in the Switch Management network.

<sup>\*\*\*</sup> The Switch Management network is required and can be added separately from the Switch Infrastructure network.

## Transparent proxy
If your datacenter requires all traffic to use a proxy, you must configure a *transparent proxy* to process all traffic from the rack to handle it according to policy, separating traffic between the zones on your network.

> [!IMPORTANT]
> The Azure Stack Hub solution doesn't support normal web proxies.  

A transparent proxy (also known as an intercepting, inline, or forced proxy) intercepts normal communication at the network layer without requiring any special client configuration. Clients don't need to be aware of the existence of the proxy.

![Transparent proxy](media/azure-stack-border-connectivity/transparent-proxy.png)

SSL traffic interception is [not supported](azure-stack-firewall.md#ssl-interception) and can lead to service failures when accessing endpoints. The maximum supported timeout to communicate with endpoints required for identity is 60s with 3 retry attempts.

## Next steps
[DNS integration](azure-stack-integrate-dns.md)
