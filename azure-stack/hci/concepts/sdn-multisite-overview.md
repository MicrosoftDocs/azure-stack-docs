---
title: Overview of SDN Multisite
description: This article provides an overview of the SDN Multisite solution.
ms.author: alkohli
ms.topic: conceptual
author: alkohli
ms.date: 02/06/2024
---

# What is SDN Multisite?

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

This article provides an overview of SDN Multisite. For information about how to manage SDN Multisite, see []().

## East-West Traffic
An important part of this conversation would be how East-West Traffic flows from VM to VM within Multisite. To help illustrate some of these concepts, I’ll   discuss a few common scenarios.

## VM communication without SDN Multisite vs with SDN Multisite

### VM communication without SDN Multisite

Previously with SDN, if you had two physical sites with SDN deployed in both and you had workloads that needed to communicate across locations, you would have to set up a Layer 3 or GRE gateway connection. With this set-up, you would also have to provide additional subnets for your applications. For instance, if you had two frontend applications on both locations, you would have to provision a subnet range such as 10.1/16 for one physical location and 10.6/16 for the other. Additionally, with a gateway connection, you will also have to allocate additional VMs for your Gateway VMs and manage those VMs.

:::image type="content" source="./media/sdn-multisite-overview/sdn-without-multisite.png" alt-text="Diagram showing SDN deployed at two physical locations without the Multisite feature." lightbox="./media/sdn-multisite-overview/sdn-without-multisitee.png" :::


### VM communication with SDN Multisite

With SDN Multisite, you can have native layer 2 connectivity across both locations. What this means for data path is that you now can have a single subnet range for your applications that span across the two physical locations without having to set up SDN gateway connection. For instance, in figure 2, you could have frontend applications on both locations with the same subnet, 10.1/16 instead of having two different ones. How information flows from one VM to another then simply relies on your underlying physical infrastructure instead of having to traverse an additional SDN gateway VM.

:::image type="content" source="./media/sdn-multisite-overview/sdn-with-multisite.png" alt-text="Diagram showing SDN deployed at two physical locations with the Multisite feature." lightbox="./media/sdn-multisite-overview/sdn-with-multisitee.png" :::

## Software Load Balancers

Currently, Software Load Balancers are still local resources for each of your physical sites. This means that load balancing policies and configurations are not synced across sites through Multisite. 
This concept can be best illustrated through an example. In figure 3 below, we have two Azure Stack HCI clusters, each with their own SDN infrastructure deployed and configured. Multisite is enabled. Let’s say a client wants to reach VM1 with IP address 10.0.0.5 with VIP of 11.0.0.5. If you don’t expect your VMs to migrate from one location to another, then data packets get forwarded as usual as illustrated below.

However, if you decide to migrate one VM or all VMs sitting behind this VIP to the other site, you may find that the VM you are trying to reach become unreachable over the VIP, depending on where the VM is located. This is due to load balancer resources being localized to each HCI cluster. As workloads move, the configurations on the MUXes aren’t global and thus your other site isn’t aware of migrations.

Solution
You might be asking yourself now how to accommodate such a limitation in your network. Here’s a possible solution to this constraint. You can enable an external load balancer to check if there are backend VMs sitting behind a load balancer at one of your sites . If there are no backend VMs sitting behind a load balancer, then the VIP for the MUX will not be advertised up to the external load balancer and subsequently any health probe sent forth will fail. This external load balancer will ensure connectivity to workloads even as VMs move from one site to another.

However, if deploying an external load balancer is not an option, then using our software load balancing solution like in figure 4 will still work as long as workloads aren’t migrating.

Gateways
SDN gateway connections are not synchronized between sites. This means that each site has its own gateway VMs and gateway connections. When a workload VM is created or migrated to a site, it gets local gateway configuration like gateway routes. If you create a gateway connection on one site for a particular virtual network, and not on the other site, the VMs on that virtual network will not get gateway connectivity when they move to the other site. If you want VMs to retain gateway connectivity when they move to the other site, you must configure a separate gateway connection for the other site for the same virtual network. 

