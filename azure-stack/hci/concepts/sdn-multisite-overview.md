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

This article provides an overview of SDN Multisite, it's current capabilities and limitations. Use this article to help design your network topology and disaster recovery plan.

For information about how to manage SDN Multisite, see [Manage SDN Multisite for Azure Stack HCI](../manage/manage-sdn-multisite.md).

SDN Multisite allows you to expand the capabilities of traditional SDN on Azure Stack HCI clusters deployed at different physical locations or sites. SDN Multisite enables native Layer 2 and Layer 3 connectivity across different physical locations for virtualized workloads.

## Multisite peering

Multisite requires peering between sites, which is initiated like virtual network peering. A connection is automatically initiated on both sites via Windows Admin Center. Once a connection is established, peering becomes successful. For instructions about how to establish peering, see [Establish peering](../manage/manage-sdn-multisite.md#establish-peering).  

### Primary and secondary site roles

In a multisite SDN environment, one site is designated as the primary and the other as secondary. The primary site handles resource synchronization. During multisite peering, the primary site is automatically selected, which you can change later using Windows Admin Center.

### Resource handling

- If the primary site is unreachable, resources can't be updated through the secondary site. However, this applies only to local resources requiring global validation and global Customer Address (CA) allocations.

    Examples of resources needing global validation include:

    - MAC pools.
    - Logical network/IP pool.

    Examples of global CA allocations include:

    - Internal load balancing for virtual subnet. Currently, this isn't supported through Multisite.
    - Gateway connections for virtual subnet.

- If the secondary site is unreachable, resources can be updated through the primary site.

- If the primary site goes down, you can designate your secondary site as the new primary site to perform updates to your network security groups and virtual networks. However, any pending data synchronization from the old primary site will be lost. To address this issue, apply those same changes on the new primary site once the old primary site is back online.

### Resource synchronization

When you enable SDN Multisite, not all resources from each site are synchronized across all sites. Here are the lists of resources that are synchronized and that remain unsynchronized.

- **Synchronized resources**

    These resources are synchronized across all sites after peering is established. You can update these resources from any site, be it primary or secondary. However, the primary site is responsible for ensuring that these resources are applied and synced across sites. Guideline and instructions for managing these resources remain the same as in a single-site SDN environment.

    - Virtual networks. For instructions on how to manage virtual networks, see [Manage tenant virtual networks](./tenant-virtual-networks.md). Note that logical networks aren't synchronized across sites. However, if your virtual networks reference a logical network, then the logical network with the same name must exist on both sites.
    - Network Security Groups (NSGs). For instructions on how to configure NSG with Windows Admin Center and PowerShell, see [Configure network security groups with Windows Admin Center](./use-datacenter-firewall-windows-admin-center.md) and [Configure network security groups with PowerShell](./use-datacenter-firewall-powershell.md).
    - User-defined routing. For instructions on how to use user-defined routing, see [Use network virtual appliances on a virtual network](/windows-server/networking/sdn/manage/use-network-virtual-appliances-on-a-vn).

- **Unsynchronized resources**

    These resources aren't synchronized after peering is established:

    - Load balancing policies.
    - Virtual IP addresses (VIPs).
    - Gateway policies.
    - Logical networks. Although logical networks aren't synchronized across sites, IP pools are checked for overlap and that overlap is not allowed.

    These policies are created on the local site, and if you want the same policies on the other site, you must manually create them there. If your backend VMs for load balancing policies are located on a single site, then connectivity over SLB will work fine without any extra configuration. But, if you expect the backend VMs to move from one site to the other, by default, connectivity works only if there are any backend VMs behind a VIP on the local site. If all the backend VMs move to another site, connectivity over that VIP fails.

## East-West traffic flow and subnet sharing

Multisite allows VMs on different sites with SDN deployed to communicate over the same subnet without having to set up SDN gateway connections. This simplifies the network topology and reduces the need for additional VMs and subnets. The data path between VMs on different sites relies on the underlying physical infrastructure.

The following scenarios compares how VM communication is established between two physical sites in a traditional SDN setup vs in a SDN Mulltisite setup.

### VM to VM communication without SDN Multisite

In a traditional setup with SDN deployed across two physical sites, you need to establish L3 or GRE gateway connection for intersite communication. You also need to provide additional subnets for your applications. For example, if each site hosts frontend applications, you'd allocate separate subnet ranges like 10.1/16 and 10.6/16. Moreover, when you set up a gateway connection, you also need to allocate additional VMs for your Gateway VMs and manage them thereafter.

:::image type="content" source="./media/sdn-multisite-overview/sdn-without-multisite.png" alt-text="Diagram to show VM to VM communication between two physical sites in a traditional SDN setup." lightbox="./media/sdn-multisite-overview/sdn-without-multisitee.png" :::

### VM to VM communication with SDN Multisite

With SDN Multisite across two physical locations, you can have native layer 2 connectivity for intersite communication. This enables you to have a single subnet range for your applications that span across both locations, eliminating the need to set up SDN gateway connection. For example, as illustrated in the following diagram, frontend applications on both locations can use the same subnet, such as 10.1/16, instead of maintaining two separate ones. With this setup, data flow from one VM to another solely relies on your underlying physical infrastructure, avoiding the need to traverse an additional SDN gateway VM.

:::image type="content" source="./media/sdn-multisite-overview/sdn-with-multisite.png" alt-text="Diagram to show VM to VM communication with SDN Multisite." lightbox="./media/sdn-multisite-overview/sdn-with-multisitee.png" :::

## Software Load Balancers and their limitations

Currently, Software Load Balancers are local resources for each of your physical sites. This means that load balancing policies and configurations aren't synced across sites through Multisite. Keep this in mind when migrating VMs from one location to another in a SDN Multisite setup.

### Load balancing in SDN Multisite: Example scenario

The following sections explain load balancing in Multisite, both without and with migrating workload VMs, using an example scenario. Suppose you have two Azure Stack HCI clusters with SDN Multisite enabled, each with its own SDN infrastructure deployed and configured. In this scenario, a client wants to reach VM1 with the IP address 10.0.0.5 and VIP of 11.0.0.5.

#### Load balancing in SDN Multisite without migrating workload VMs

In SDN Multisite, if there's no VM migration between locations, data packets are forwarded as usual, similar to the traditional SDN setup. The following two diagrams illustrate the data path from the client machine to VM1 via SLB MUX1 in Cluster 2.

The first diagram shows the data packet's path from the client machine to SLB MUX1:

:::image type="content" source="./media/sdn-multisite-overview/software-load-balancer-normal1.png" alt-text="Diagram shows the data packet's path from the client machine to SLB MUX1." lightbox="./media/sdn-multisite-overview/software-load-balancer-normal1.png" :::

The second diagram shows the data packet's path from SLB MUX1 to VM1:

:::image type="content" source="./media/sdn-multisite-overview/software-load-balancer-normal2.png" alt-text="Diagram shows the data packet's path from SLB MUX1 to VM1." lightbox="./media/sdn-multisite-overview/software-load-balancer-normal2.png" :::

#### Load balancing in SDN Multisite with migrating workload VMs

If you decide to migrate one VM or all VMs behind the VIP to the other site, you might encounter situations where the VM you are trying to reach becomes unreachable over the VIP, depending on its location. This happens because load balancer resources are local to each Azure Stack HCI cluster. As workload VMs move, the configurations on the MUXes aren’t global, leaving the other site unaware of migrations. The following diagrams illustrate the VM migration from Cluster 2 to Cluster 1 and how the data packet's path fails after the migration.

The first diagram shows the two clusters before VM migration from Cluster 2 to Cluster 1:

:::image type="content" source="./media/sdn-multisite-overview/software-load-balancer-broken1.png" alt-text="Diagram shows the two clusters before VM migration from Cluster 2 to Cluster 1." lightbox="./media/sdn-multisite-overview/software-load-balancer-broken1.png" :::

The second diagram shows the two clusters after VM migration:

:::image type="content" source="./media/sdn-multisite-overview/software-load-balancer-broken2.png" alt-text="Diagram shows the two clusters after VM migration." lightbox="./media/sdn-multisite-overview/software-load-balancer-broken2.png" :::

The third diagram shows that the data packet's path fails after VM migration:

:::image type="content" source="./media/sdn-multisite-overview/software-load-balancer-broken3.png" alt-text="Diagram shows that the data packet's path fails after VM migration." lightbox="./media/sdn-multisite-overview/software-load-balancer-broken3.png" :::

To workraound this limitation, you can use external load balancer that checks the availability of backend VMs on each site and routes the traffic accordingly. See [Use external load balancer in Multisite with migrating workload VMs](#use-external-load-balancer-in-multisite-with-migrating-workload-vms).

#### Use external load balancer in Multisite with migrating workload VMs

You can enable an external load balancer to check if there are backend VMs behind a load balancer at one of your sites. If there are no backend VMs behind a load balancer, then the VIP for the MUX will not be advertised up to the external load balancer and subsequently any health probe sent forth will fail. This external load balancer ensures connectivity to workloads even as VMs move from one site to another.

:::image type="content" source="./media/sdn-multisite-overview/external-load-balancer.png" alt-text="Diagram showing using an external software local balancer as a solution for migrating VMs between sites in a multisite setup." lightbox="./media/sdn-multisite-overview/external-load-balancer.png" :::

However, if deploying an external load balancer is not an option, use the software load balancing solution as described in [Load balancing in SDN Multisite without migrating workload VMs](#load-balancing-in-sdn-multisite-without-migrating-workload-vms) as long you don't have any migrating workload VMs.

## Gateways and their limitations

SDN gateway connections are also local resources that aren't synced across sites by Multisite. Each site has its own gateway VMs and gateway connections. When a workload VM is created or migrated to a site, it gets local gateway configuration like gateway routes. If you create a gateway connection for a particular virtual network on one site, VM's from that site lose gateway connectivity upon migration to the other site. For VMs to retain gateway connectivity on migration, you must configure a separate gateway connection for the same virtual network on the other site.

## Next steps

[Manage SDN Multisite for Azure Stack HCI](../manage/manage-sdn-multisite.md)