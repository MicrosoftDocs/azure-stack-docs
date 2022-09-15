---
title: What is Azure Stack Hub Load Balancer?
titleSuffix: Azure Stack Hub Load Balancer
description: Overview of Azure Stack Hub Load Balancer features, architecture, and implementation. Learn how the Load Balancer works and how to use it in Azure Stack Hub.
services: load-balancer
documentationcenter: na
author: cedward
ms.service: load-balancer
# Customer intent: As an IT administrator, I want to learn more about the Azure Stack Hub Load Balancer service and what I can use it for. 
ms.topic: overview
ms.date: 09/13/2022
ms.author: cedward

---

# What is the Azure Stack Hub Load Balancer?

*Load balancing* refers to evenly distributing load (incoming network traffic) across a group of backend resources or servers.

Azure Stack Hub Load Balancer operates at layer 4 of the Open Systems Interconnection (OSI) model. It's the single point of contact for clients. Load balancer distributes inbound flows that arrive at the load balancer's front end to backend pool instances. These flows are according to configured load-balancing rules and health probes. The backend pool instances can be Azure Virtual Machines or instances in a virtual machine scale set.

A **[public load balancer](./components.md#frontend-ip-configurations)** can provide outbound connections for virtual machines (VMs) inside your virtual network. These connections are accomplished by translating their private IP addresses to public IP addresses. Public Load Balancers are used to load balance internet traffic to your VMs.

An **[internal (or private) load balancer](./components.md#frontend-ip-configurations)** is used where private IPs are needed at the frontend only. Internal load balancers are used to load balance traffic inside a virtual network.

<p align="center">
  <img src="./media/load-balancer-overview/load-balancer.svg" alt="Figure depicts both public and internal load balancers directing traffic to port 80 on multiple servers on a Web tier and port 443 on multiple servers on a business tier." width="512" title="Azure Load Balancer">
</p>

*Figure: Balancing multi-tier applications by using both public and internal Load Balancer*

For more information on the individual load balancer components, see [Azure Load Balancer components](./components.md).

## Why use Azure Load Balancer?

With Azure Stack Hub Load Balancer, you can scale your applications and create highly available services.
Load balancer supports both inbound and outbound scenarios. Load balancer provides low latency and high throughput, and scales up to millions of flows for all TCP and UDP applications.

Key scenarios that you can accomplish using Azure Stack Hub Standard Load Balancer include:

- Load balance **[internal](./quickstart-load-balancer-standard-internal-portal.md)** and **[external](./quickstart-load-balancer-standard-public-portal.md)** traffic to Azure virtual machines.

- Configure **[outbound connectivity](./load-balancer-outbound-connections.md)** for Azure Stack Hub virtual machines.

- Use **[health probes](./load-balancer-custom-probe-overview.md)** to monitor load-balanced resources.

- Employ **[port forwarding](./tutorial-load-balancer-port-forwarding-portal.md)** to access virtual machines in a virtual network by public IP address and port.

- Load balance services on **[multiple ports, multiple IP addresses, or both](./load-balancer-multivip-overview.md)**.

- Load balance TCP and UDP flow on all ports simultaneously using **[HA ports](./load-balancer-ha-ports-overview.md)**.

### <a name="securebydefault"></a>Secure by default

* Standard load balancer is built on the zero trust network security model.

* Standard Load Balancer is secure by default and part of your virtual network. The virtual network is a private and isolated network.  

* Standard load balancers and standard public IP addresses are closed to inbound connections unless opened by Network Security Groups. NSGs are used to explicitly permit allowed traffic.  If you don't have an NSG on a subnet or NIC of your virtual machine resource, traffic isn't allowed to reach this resource. To learn about NSGs and how to apply them to your scenario, see [Network Security Groups](../virtual-network/network-security-groups-overview.md).

* Basic load balancer is open to the internet by default.

* Load balancer doesn't store customer data.

## What's new?

Subscribe to the RSS feed and view the latest Azure Load Balancer feature updates on the [Azure Updates](https://azure.microsoft.com/updates/?category=networking&query=load%20balancer) page.

## Next steps

* See [Create a public standard load balancer](quickstart-load-balancer-standard-public-portal.md) to get started with using a load balancer.

* For more information on Azure Load Balancer limitations and components, see [Azure Load Balancer components](./components.md) and [Azure Load Balancer concepts](./concepts.md)

* [Learn module: Introduction to Azure Load Balancer](/learn/paths/intro-to-azure-application-delivery-services).