---
title: Overview of Network Controller in Azure Stack HCI
description: Use this topic to learn about Network Controller for Software Defined Networking in Azure Stack HCI.
author: khdownie
ms.author: v-kedow
ms.topic: overview
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/10/2020
---
# What is Network Controller?

> Applies to Azure Stack HCI, version 20H2; Windows Server 2019

Network Controller is the cornerstone of SDN management. It is a highly scalable server role that provides a centralized, programmable point of automation to manage, configure, monitor, and troubleshoot virtual network infrastructure.

Using Network Controller, you can automate the configuration and management of network infrastructure instead of performing manual configuration of network devices and services.

## How Network Controller works

Network Controller provides one application programming interface (API) that allows Network Controller to communicate with and manage network devices, services, and components (Southbound API), and a second API that allows management applications to tell the Network Controller what network settings and services they need (Northbound API).

With the Southbound API, Network Controller can manage network devices and network services, and gather all of the information you need about the network. Network Controller continually monitors the state of network devices and services, and ensures that any configuration drift from the golden state is remediated.

The Network Controller Northbound API is implemented as a REST interface. It provides the ability to manage your datacenter network from management applications. For management, users can use the REST API directly, or use Windows PowerShell built on top of the REST API, or management applications with a graphical user interface such as Windows Admin Center or System Center Virtual Machine Manager.

## Network Controller features

### Virtual network management

This Network Controller feature allows you to deploy and configure Hyper-V Network Virtualization, configure virtual network adapters on individual VMs, and to store and distribute virtual network policies. With this feature, you can create virtual networks and subnets, attach virtual machines to these networks, and enable communication between VMs in the same virtual network.

Network Controller supports VLAN based networks, Network Virtualization Generic Routing Encapsulation (NVGRE) and Virtual Extensible Local Area Network (VXLAN).

## Firewall management

This Network Controller feature allows you to configure and manage allow/deny firewall Access Control rules for your workload VMs for both East/West and North/South network traffic in your datacenter. The firewall rules are plumbed in the vSwitch port of workload VMs, and so they are distributed across your workloads in the datacenter and move along with your workloads.

Using the Northbound API, you can define the firewall rules for both incoming and outgoing traffic from the workload VM(s). You can also configure each firewall rule to log the traffic that was allowed or denied by the rule.

## Software Load Balancer management

This Network Controller feature allows you to enable multiple servers to host the same workload, providing high availability and scalability. With Software Load Balancer, you can configure and manage load balancing, inbound Network Address Translation (NAT), outbound access to Internet for workloads connected to traditional VLAN networks and virtual networks.

## Gateway management

This Network Controller feature allows you to deploy, configure, and manage VMs that are members of a RAS Gateway pool, providing external network connectivity to your customer workloads.

Network Controller allows you to automatically deploy VMs running RAS Gateway with the following gateway features:

1. Configure multiple gateway VMs for scalability and specify the level of redundancy required.
1. The following connectivity types are supported between your virtual networks and remote networks:
   - Site-to-site virtual private network (VPN) gateway connectivity using IPsec.
   - Site-to-site VPN gateway connectivity using Generic Routing Encapsulation (GRE).
   - Layer 3 forwarding capability.
1. Border Gateway Protocol (BGP) routing, which allows you to manage the routing of network traffic between your customers' VM networks and their remote sites.

## Virtual appliance chaining

Anirban: Do you mean service chaining [as described here](https://docs.microsoft.com/en-us/windows-server/networking/sdn/vnet-peering/sdn-vnet-peering#service-chaining)?

## Network Controller deployment considerations

1. Do not deploy the Network Controller server role on physical hosts. The Network Controller should be deployed on its own dedicated VM and requires a reserved IP address to serve as the REST IP address.

1. You can deploy Network Controller in both domain and non-domain environments. In domain environments, Network Controller authenticates users and network devices by using Kerberos; in non-domain environments, you must deploy certificates for authentication.

1. It’s critical for Network Controller deployments to provide high availability and the ability for you to easily scale up or down with your datacenter needs. Therefore, the server role requires three to five cluster VMs in order to provide high availability on your network.

1. To achieve high availability and scalability, Network Controller relies on Service Fabric. Service Fabric provides a distributed systems platform to build scalable, reliable, and easily managed applications. [Learn more about Network Controller as a Service Fabric Application](/windows-server/networking/sdn/technologies/network-controller/network-controller-high-availability#network-controller-as-a-service-fabric-application).


## Next steps

For related information, see also:

- [Plan to deploy Network Controller](network-controller.md)
- [SDN in Azure Stack HCI](software-defined-networking.md)