---
title: Standard Load Balancer considerations in Azure Stack Hub and Azure
description: Learn about differences in the Standard Load Balancer between Azure Stack Hub and Azure.
author: sethmanheim
ms.topic: conceptual
ms.date: 09/03/2024
ms.author: sethm
ms.reviewer: rtiberiu
ms.lastreviewed: 03/29/2024

# Intent: As an Azure Stack user, I want an introduction to networking in Azure Stack so I can get started.
# Keyword: azure stack networking 

---

# Standard Load Balancer considerations in Azure Stack Hub

Azure Stack Hub now supports the Standard Load Balancer SKU. While this new SKU enables customer scenarios, there are certain differences between the Standard Load Balancer SKU on Azure Stack Hub and the Azure Load Balancer available in Azure. This section describes the main differences between the two, and the scenarios we validated in the Standard Load Balancer on Azure Stack Hub.

## Main differences in Standard Load Balancer between Azure and Azure Stack Hub

| Feature                                       | Azure                                                                                                                                                                             | Azure Stack Hub                                                                                        |
|------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------|
| Backend pool size                              | Supports up to 5000 instances.                                                                                                                                                     | Not limited by Standard Load Balancer itself - depends on the number of VMs on the stamp.                                  |
| Backend pool endpoints                         | Any virtual machine, virtual machine scale sets, or IP address in a single virtual network.                                                                                        | Virtual machines and scale sets on a single virtual network only. No IP addresses supported.            |
| Health probes                                  | TCP, HTTP, and HTTPS.                                                                                                                                                               | Same as Azure.                                                                                          |
| Behavior when health probe goes down                     | TCP connections stay alive when an instance probe goes down even when all probes are down.                                                                                               | TCP connections stay alive on an instance probe when it's down. All TCP connections end when all probes are down. |
| HA ports                                       | High availability (HA) ports are a type of load balancing rule that provides an easy way to load balance all flows that arrive on all ports of an internal standard load balancer. | Same as Azure.                                                                                          |
| Availability Zones                             | Zone-redundant and zonal front ends for inbound and outbound traffic.                                                                                                               | Not supported.                                                                                          |
| Secure by default                              | Closed to inbound flows unless allowed by a network security group. Internal traffic from the virtual network to the internal load balancer is allowed.                           | Same as Azure.                                                                                          |
| Outbound rules                                 | Allows you to use the public IP or IPs of your load balancer for outbound connectivity for the backend instances.                                                                      | Same as Azure.                                                                                         |
| Inbound NAT rule port ranges                   | Azure Load Balancer supports inbound NAT rule port ranges.                                                                                                                         | Not supported.                                                                                          |
| Custom SNAT port allocation for outbound rules | This configuration uses source network address translation (SNAT) to translate the virtual machine's private IP into the load balancer's public IP address.                            | Not supported.                                                                                          |
| TCP reset on idle                              | Configurable:<br> - 4 to 100 minutes for outbound rules.<br>- 1 to 30 minutes for inbound rules.                                                                                                                                                 | Same as Azure.                                                                                         |
| Multiple frontend IPs                          | Inbound and outbound front end IPs.                                                                                                                                                | Same as Azure.                                                                                          |
| Global VNET peering                            | Standard ILB Is supported via global VNET peering.                                                                                                                                 | Not supported.                                                                                          |
| NAT gateway                                    | Both Standard ILB and Standard public LB are supported via NAT gateway.                                                                                                            | Not supported.                                                                                          |
| Private Link                                   | Standard ILB is supported via Private Link.                                                                                                                                        | Not supported.                                                                                          |

## Main differences between Basic and Standard Load Balancer on Azure Stack Hub

| Feature                                       | Standard Load Balancer                                                                                                                                                            | Basic Load Balancer                                                                                                                                     |
|------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------|
| Backend pool size                              | Not limited by the Standard Load Balancer itself - depends on the number of VMs on the stamp.                                                                                                             | Depends on stamp capacity.                                                                                                                               |
| Backend pool endpoints                         | Virtual machines and scale sets on the same virtual network.                                                                                                                                  | Virtual machines or virtual machine scale set on the same virtual network. It cannot include both types in the same backend pool.                                   |
| Health probes                                  | TCP, HTTP, and HTTPS.                                                                                                                                                               | TCP and HTTP.                                                                                                                                            |
| Behavior when health probe goes down                     | TCP connections stay alive when an instance probe goes down. All TCP connections end when all probes are down.                                                                            | TCP connections stay alive when an instance probe goes down. All TCP connections end when all probes are down.                                                  |
| HA ports                                       | High availability (HA) ports are a type of load balancing rule that provide an easy way to load-balance all flows that arrive on all ports of an internal standard load balancer. | Not supported.                                                                                                                                           |
| Availability Zones                             | Not supported.                                                                                                                                                                     | Not supported.                                                                                                                                           |
| Secure by default                              | Closed to inbound flows unless allowed by a network security group. Internal traffic from the virtual network to the internal load balancer is allowed.                           | Closed to inbound flows unless allowed by a network security group. Internal traffic from the virtual network to the internal load balancer is allowed. |
| Outbound rules                                 | Allows you to use the public IP or IPs of your load balancer for outbound connectivity of the backend instances.                                                                      | Not supported.                                                                                                                                           |
| Custom SNAT port allocation for outbound rules | This configuration uses source network address translation (SNAT) to translate a virtual machine's private IP into the load balancer's public IP address.                            | Not supported.                                                                                                                                           |
| TCP reset on idle                              | Configurable:<br> - 4 to 100 minutes for outbound rules.<br>- 1 to 30 minutes for inbound rules.                                                                                                                                                 | Same as Azure.                                                                                         |
| Multiple front-end IPs                          | Inbound and outbound front-end IPs.                                                                                                                                                | Only for inbound rules.                                                                                                                                  |
| Global VNET peering                            | Not supported.                                                                                                                                                                     | Not supported.                                                                                                                                           |
| NAT gateway                                    | Not supported.                                                                                                                                                                     | Not supported.                                                                                                                                           |
| Private Link                                   | Not supported.                                                                                                                                                                     | Not supported.                                                                                                                                           |

## Scenarios

The following scenarios were validated for the Standard Load Balancer on Azure Stack Hub:

- Standard public IP and HTTPS health probes.
- Backend pools with different endpoint types.
- Inbound rules, outbound rules, and endpoint security.
- Multiple backend pools, frontend IPs, outbound rules and timeout configurations.
- Single backend pool with multiple frontend IPs.
- Outbound-only load balancer configuration.
- Internal load balancer with HA ports.
- Internal load balancer with HA ports and floating IP.

> [!NOTE]
> Portal diagnostic features for the Standard Load Balancer are not supported.

## Next steps

- [Considerations for Azure Stack Hub networking](azure-stack-network-differences.md)
