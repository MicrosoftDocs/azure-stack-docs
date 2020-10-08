---
title: Overview of Network Controller in Azure Stack HCI
description: Use this topic to learn about Network Controller for Software Defined Networking in Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/8/2020
---
# What is Network Controller?

> Applies to Azure Stack HCI, version 20H2; Windows Server 2019

Network Controller is the cornerstone of Software Defined Networking (SDN) management. It is a highly scalable server role that provides a centralized, programmable point of automation to manage, configure, monitor, and troubleshoot virtual network infrastructure.

Using Network Controller, you can automate the configuration and management of network infrastructure instead of performing manual configuration of network devices and services.

## How Network Controller works

Network Controller provides one application programming interface (API) that allows Network Controller to communicate with and manage network devices, services, and components (Southbound API), and a second API that allows management applications to tell the Network Controller what network settings and services they need (Northbound API).

With the Southbound API, Network Controller can manage network devices and network services, and gather all of the information you need about the network. Network Controller continually monitors the state of network devices and services, and ensures that any configuration drift from the desired state is remediated.

The Network Controller Northbound API is implemented as a REST interface. It provides the ability to manage your datacenter network from management applications. For management, users can use the REST API directly, or use Windows PowerShell built on top of the REST API, or management applications with a graphical user interface such as Windows Admin Center or System Center Virtual Machine Manager.

## Network Controller features

Network Controller allows you to manage SDN features such as virtual networks, firewalls, Software Load Balancer, and RAS Gateway. The following are some of its many features.

### Virtual network management

This Network Controller feature allows you to deploy and configure Hyper-V Network Virtualization, configure virtual network adapters on individual VMs, and store and distribute virtual network policies. With this feature, you can create virtual networks and subnets, attach virtual machines (VMs) to these networks, and enable communication between VMs in the same virtual network.

Network Controller supports Virtual Local Area Network (VLAN) based networks, Network Virtualization Generic Routing Encapsulation (NVGRE) and Virtual Extensible Local Area Network (VXLAN).

## Firewall management

This Network Controller feature allows you to configure and manage allow/deny firewall Access Control rules for your workload VMs for both internal (East/West) and external (North/South) network traffic in your datacenter. The firewall rules are plumbed in the vSwitch port of workload VMs, and so they are distributed across your workloads in the datacenter and move along with your workloads.

Using the Northbound API, you can define the firewall rules for both incoming and outgoing traffic from the workload VMs. You can also configure each firewall rule to log the traffic that was allowed or denied by the rule.

## Software Load Balancer management

[Software Load Balancer](software-load-balancer.md) allows you to enable multiple servers to host the same workload, providing high availability and scalability. With Software Load Balancer, you can configure and manage load balancing, inbound Network Address Translation (NAT), and outbound access to the Internet for workloads connected to traditional VLAN networks and virtual networks.

## Gateway management

[Remote Access Service (RAS) Gateway](gateway-overview.md) allows you to deploy, configure, and manage VMs that are members of a gateway pool, providing external network connectivity to your customer workloads. With gateways, the following connectivity types are supported between your virtual and remote networks:

- Site-to-site virtual private network (VPN) gateway connectivity using IPsec
- Site-to-site VPN gateway connectivity using Generic Routing Encapsulation (GRE)
- Layer 3 forwarding capability
 
Gateway connections support Border Gateway Protocol (BGP) for dynamic route management.

## Virtual appliance chaining

This Network Controller feature allows you to attach virtual network appliances to your virtual networks. These appliances can be used for advanced firewalling, load balancing, intrusion detection and prevention, and many other network services. You can add virtual appliances that perform user-defined routing and port mirroring functions. With user-defined routing, the virtual appliance gets used as a router between the virtual subnets on the virtual network. With port mirroring, all network traffic that is entering or leaving the monitored port is duplicated and sent to a virtual appliance for analysis.

To learn more about user-defined routes, see [Use Network Virtual Appliances on a Virtual Network](/windows-server/networking/sdn/manage/use-network-virtual-appliances-on-a-vn).

## Network Controller deployment considerations

- Do not deploy the Network Controller server role on physical hosts. The Network Controller should be deployed on its own dedicated VMs.

- You can deploy Network Controller in both domain and non-domain environments. In domain environments, Network Controller authenticates users and network devices by using Kerberos; in non-domain environments, you must deploy certificates for authentication.

- It’s critical for Network Controller deployments to provide high availability and the ability for you to easily scale up or down with your datacenter needs. Use at least three VMs in order to provide high availability for the Network Controller application.

- To achieve high availability and scalability, Network Controller relies on Service Fabric. Service Fabric provides a distributed systems platform to build scalable, reliable, and easily managed applications. [Learn more about Network Controller as a Service Fabric Application](/windows-server/networking/sdn/technologies/network-controller/network-controller-high-availability#network-controller-as-a-service-fabric-application).


## Next steps

For related information, see also:

- [Plan to deploy Network Controller](network-controller.md)
- [Deploy Network Controller using Windows PowerShell](../deploy/network-controller-powershell.md)
- [SDN in Azure Stack HCI](software-defined-networking.md)