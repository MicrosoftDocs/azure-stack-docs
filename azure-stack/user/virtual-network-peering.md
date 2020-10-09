---

title: Virtual network peering in Azure Stack Hub
description: Learn how to use Virtual network peering to connect virtual networks in Azure Stack Hub.
author: sethmanheim
ms.author: sethm
ms.date: 10/09/2020
ms.topic: conceptual

ms.reviewer: sranthar
ms.lastreviewed: 10/09/2020
---

# Virtual Network peering

Virtual network peering enables you to seamlessly connect virtual networks in an Azure Stack Hub environment. The virtual networks appear as one for connectivity purposes. The traffic between virtual machines uses the underlying SDN infrastructure. Like traffic between virtual machines in the same network, traffic is only routed through the Azure Stack Hub private network.

Azure Stack Hub does not support global peering, as the concept of "regions" does not apply.

The benefits of using virtual network peering are as follows:

- A low-latency, high-bandwidth connection between resources in different virtual networks.
- The ability of resources in one virtual network to communicate with resources in a different virtual network.
- The ability to transfer data between virtual networks across different subscriptions and Azure Active Directory tenants.
- No downtime to resources in either virtual network when creating the peering, or after the peering is created.

Network traffic between peered virtual networks is private. Traffic between virtual networks is kept in the infrastructure layer. No public internet, gateways, or encryption is required in the communication between virtual networks.

## Connectivity

For peered virtual networks, resources in either virtual network can directly connect with resources in the peered virtual network.

The network latency between virtual machines in peered virtual networks in the same region is the same as the latency within a single virtual network. The network throughput is based on the bandwidth that's allowed for the virtual machine, proportionate to its size. There isn't any additional restriction on bandwidth within the peering.

The traffic between virtual machines in peered virtual networks is routed directly through the SDN layer, not through a gateway or over the public internet.

You can apply network security groups in either virtual network to block access to other virtual networks or subnets. When configuring virtual network peering, either open or close the network security group rules between the virtual networks. If you open full connectivity between peered virtual networks, you can apply network security groups to block or deny specific access. Full connectivity is the default option. To learn more about network security groups, see [Security groups](/azure/virtual-network/security-overview).

## Service chaining

Service chaining enables you to direct traffic from one virtual network to a virtual appliance or gateway in a peered network through user-defined routes.

To enable service chaining, configure user-defined routes that point to virtual machines in peered virtual networks as the *next hop* IP address.

You can deploy *hub-and-spoke* networks, where the hub virtual network hosts infrastructure components such as a network virtual appliance or VPN gateway. All the spoke virtual networks can then peer with the hub virtual network. Traffic flows through network virtual appliances or VPN gateways in the hub virtual network.

Virtual network peering enables the next hop in a user-defined route to be the IP address of a virtual machine in the peered virtual network. To learn more about user-defined routes, see [User-defined routes overview](/azure/virtual-network/virtual-networks-udr-overview#user-defined). To learn how to create a hub and spoke network topology, see [Hub-spoke network topology in Azure](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?toc=%2fazure%2fvirtual-network%2ftoc.json).

## Gateways and on-premises connectivity

Each virtual network, including a peered virtual network, can have its own gateway. A virtual network can use its gateway to connect to an on-premises network. Please review the [Virtual Network Gateway documentation](/azure/vpn-gateway/).

You can also configure the gateway in the peered virtual network as a transit point to an on-premises network. In this case, the virtual network that is using a remote gateway can't have its own gateway. A virtual network has only one gateway. The gateway is either a local or remote gateway in the peered virtual network, as shown in the following figure:

:::image type="content" source="media/virtual-network-peering/virtual-network-gateway.png" alt-text="VPN gateway topology":::

Note that a **Connection** object must be created in the VPN gateway prior to enabling the **UseRemoteGateways** options in the peering.

## Virtual network peering configuration

**Allow virtual network access:** Enabling communication between virtual networks allows resources connected to either virtual network to communicate with each other with the same bandwidth and latency as if they were connected to the same virtual network. All communication between resources in the two virtual networks is routed through the internal SDN layer.  

One reason to not enable network access might be a scenario where you've peered a virtual network with another virtual network, but occasionally want to disable traffic flow between the two virtual networks. You might find enabling/disabling is more convenient than deleting and re-creating peerings. When this setting is disabled, traffic does not flow between the peered virtual networks.

**Allow forwarded traffic:** Check this box to allow traffic *forwarded* by a network virtual appliance in a virtual network (that didn't originate from the virtual network) to flow to this virtual network through a peering. For example, consider three virtual networks named Spoke1, Spoke2, and Hub. A peering exists between each spoke virtual network and the Hub virtual network, but peerings don't
exist between the spoke virtual networks. A network virtual appliance is deployed in the Hub virtual network, and user-defined routes are applied to each spoke virtual network that route traffic between the subnets through the network virtual appliance. If this checkbox is not checked for the peering between each spoke virtual network and the hub virtual network, traffic doesn't flow between the spoke virtual networks because the hub is not forwarding the traffic between the virtual networks. While enabling this capability allows the forwarded traffic through the
peering, it does not create any user-defined routes or network virtual appliances. User-defined routes and network virtual appliances are created separately. Learn about [user-defined routes](/azure/virtual-network/virtual-networks-udr-overview#user-defined). You do not need to check this setting if traffic is forwarded between virtual networks through a VPN Gateway.

**Allow gateway transit:** Check this box if you have a virtual network gateway attached to this virtual network, and want to allow traffic from the peered virtual network to flow through the gateway. For example, this virtual network may be attached to an on-premises network through a virtual network gateway. Checking this box allows traffic from the peered virtual network to flow through the gateway attached to this virtual network to the on-premises network. If you check this box, the peered virtual network cannot have a gateway configured. The peered virtual network must have the **Use remote gateways** box checked when setting up the peering from the other virtual network to this virtual network. If you leave this box unchecked (the default), traffic from the peered virtual network still flows to this virtual network, but cannot flow through a virtual network gateway attached to this virtual network.

**Use remote gateways:** Check this box to allow traffic from this virtual network to flow through a virtual network gateway attached to the virtual network you're peering with. For example, the virtual network you're peering with has a VPN gateway attached that enables communication to an on-premises network. Checking this box allows traffic from this virtual network to flow through the VPN gateway attached to the peered virtual network. If you check this box, the peered virtual network must have a virtual network gateway attached to it and must have the **Allow gateway transit** box checked. If you leave this box unchecked (the default), traffic from the peered virtual network can still flow to this virtual network, but cannot flow through a virtual network gateway attached to this virtual network.

You can't use remote gateways if you already have a gateway configured in your virtual network.

## Virtual network peering frequently asked questions (FAQ)

### What is Virtual network peering?

Virtual network peering enables you to connect virtual networks. A VNet peering connection between virtual networks enables you to route traffic between them privately through IPv4 addresses. Virtual machines in the peered VNets can communicate with each other as if they are within the same network. VNet peering connections can also be created across multiple subscriptions.

### Does Azure Stack Hub support Global VNET peering?

Azure Stack Hub does not support global peering, as the concept of "regions" does not apply.

### On which Azure Stack Hub update will virtual network peering be available?

virtual network peering is available in Azure Stack Hub starting with the 2008 update.

### Can I peer my virtual network in Azure Stack Hub to a virtual network in Azure?

No, peering between Azure and Azure Stack hub is not supported at this time.

### Can I peer my virtual network in Azure Stack Hub1 to a virtual network in Azure Stack Hub2?

No, peering can only be created between virtual networks in one Azure Stack Hub system. For more information about how to connect two virtual networks from different stamps, see [Establish a VNET to VNET connection in Azure Stack Hub](azure-stack-network-howto-vnet-to-vnet-stacks.md).

### Can I enable peering if my virtual networks belong to subscriptions within different Azure Active Directory tenants?

Yes. It is possible to establish VNet Peering if your subscriptions belong to different Azure Active Directory tenants. You can do this via PowerShell or CLI. The portal is not yet supported.

### Can I peer my virtual network with a virtual network in a different subscription?

Yes. You can peer virtual networks across subscriptions.

### Are there any bandwidth limitations for peering connections?

No. Virtual network peering does not impose any bandwidth restrictions. Bandwidth is only limited by the VM or the compute resource.

### My virtual network peering connection is in an *Initiated* state, why can't I connect?

If your peering connection is in an **Initiated** state, it means you have created only one link. A bidirectional link must be created in order to establish a successful connection. For example, to peer VNet A to VNet B, a link must be created from VNet A to VNet B, and from VNet B to VNet A. Creating both links changes the state to **Connected**.

### My virtual network peering connection is in a *Disconnected* state, why can't I create a peering connection?

If your virtual network peering connection is in a **Disconnected** state, it means
one of the links created was deleted. In order to re-establish a peering connection, delete the link and recreate it.

### Is virtual network peering traffic encrypted?

No. Traffic between resources in peered virtual networks is private and isolated. It remains completely in the SDN layer of the Azure Stack Hub system.

### If I peer VNet A to VNet B and I peer VNet B to VNet C, does that mean VNet A and VNet C are peered?

No. Transitive peering is not supported. You must peer VNet A and VNet C.

## Next steps

- [About Azure Virtual Network](/azure/virtual-network/virtual-networks-overview)
- [User-defined routes overview](/azure/virtual-network/virtual-networks-udr-overview#user-defined)
- [Hub-spoke network topology in Azure](/azure/architecture/reference-architectures/hybrid-networking/hub-spoke?toc=%2fazure%2fvirtual-network%2ftoc.json)
