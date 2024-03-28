---
title: Introduction to Azure Stack Hub networking 
description: Learn about Azure Stack Hub networking
author: sethmanheim

ms.topic: conceptual
ms.date: 03/28/2024
ms.author: sethm
ms.reviewer: rtiberiu
ms.lastreviewed: 03/28/2024

# Intent: As an Azure Stack user, I want an introduction to networking in Azure Stack so I can get started.
# Keyword: azure stack networking 

---

# Introduction to Azure Stack Hub networking

Azure Stack Hub provides different kinds of networking capabilities that can be used together or separately:

- **Connectivity between Azure Stack Hub resources**  
    Connect Azure resources together in a secure and private virtual network in the cloud.
- **Internet connectivity**  
    Communicate to and from Azure Stack Hub resources over the internet.
- **On-premises connectivity**  
    Connect an on-premises network to Azure Stack Hub resources through a virtual private network (VPN) over the internet, or through a dedicated connection to Azure Stack Hub. 
    > [!IMPORTANT]
    > You must create a VPN or public IP connection in order to access on-premises resources.
- **Load balancing and traffic direction**  
    Load balance traffic to servers in the same location and direct traffic to servers in different locations.
- **Security**  
    Filter network traffic between network subnets or individual VMs.
- **Routing**  
    Use default routing or fully control routing between your Azure Stack Hub and on-premises resources.
- **Manageability**  
    Monitor and manage your Azure Stack Hub networking resources.
- **Deployment and configuration tools**  
    Use a web-based portal or cross-platform command-line tools to deploy and configure network resources.

## Standard Load Balancer considerations (preview)

Azure Stack Hub supports the Standard Load Balancer SKU, currently in public preview. While this new SKU enables customer scenarios, there are certain differences between the Standard Load Balancer SKU on Azure Stack Hub and the Azure Load Balancer available in Azure. This section describes the main differences between the two, as well as the scenarios we have validated in the Standard Load Balancer on Azure Stack Hub.

### Main differences in Standard Load Balancer between Azure and Azure Stack Hub

| Features                                       | Azure                                                                                                                                                                             | Azure Stack Hub                                                                                        |
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
| TCP reset on idle                              | Configurable                                                                                                                                                                      |                                                                                                        |
| *                                              | 4 to 100 minutes for outbound rules.                                                                                                                                               |                                                                                                        |
| *                                              | 1 to 30 minutes for inbound rules.                                                                                                                                                 | Same as Azure.                                                                                         |
| Multiple frontend IPs                          | Inbound and outbound front end IPs.                                                                                                                                                | Same as Azure.                                                                                          |
| Global VNET peering                            | Standard ILB Is supported via global VNET peering.                                                                                                                                 | Not supported.                                                                                          |
| NAT gateway                                    | Both Standard ILB and Standard public LB are supported via NAT gateway.                                                                                                            | Not supported.                                                                                          |
| Private Link                                   | Standard ILB is supported via Private Link.                                                                                                                                        | Not supported.                                                                                          |

### Main differences between Basic and Standard Load Balancer on Azure Stack Hub

| Features                                       | Standard Load Balancer                                                                                                                                                            | Basic Load Balancer                                                                                                                                     |
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
| TCP reset on idle                              | Configurable.                                                                                                                                                                      |                                                                                                                                                         |
| *                                              | 4 to 100 minutes for outbound rules.                                                                                                                                               |                                                                                                                                                         |
| *                                              | 1 to 30 minutes for inbound rules.                                                                                                                                                 | Only for inbound rules.                                                                                                                                  |
| Multiple front-end IPs                          | Inbound and outbound front-end IPs.                                                                                                                                                | Only for inbound rules.                                                                                                                                  |
| Global VNET peering                            | Not supported.                                                                                                                                                                     | Not supported.                                                                                                                                           |
| NAT gateway                                    | Not supported.                                                                                                                                                                     | Not supported.                                                                                                                                           |
| Private Link                                   | Not supported.                                                                                                                                                                     | Not supported.                                                                                                                                           |

### Scenarios

The following scenarios have been validated for the Standard Load Balancer on Azure Stack Hub:

- Standard public IP and HTTPS health probes.
- Backend pools with different endpoint types.
- Inbound rules, outbound rules, and endpoint security.
- Multiple backend pools, frontend IPs, outbound rules and timeout configurations.
- Single backend pool with multiple frontend IPs.
- Outbound-only load balancer configuration.
- Internal load balancer with HA ports.
- Internal load balancer with HA ports and floating IP.

The scenario descriptions, validation steps, and some of the expected differences are [described here](https://www.github.com).

## Azure Stack Hub IPv6 support

Azure Stack Hub does not offer support for IPv6 and there are no roadmap items to provide support.

## Next steps

* [Considerations for Azure Stack Hub networking](azure-stack-network-differences.md)