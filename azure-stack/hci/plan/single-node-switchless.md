---
title: Azure Stack HCI single node storage switchless deployment network reference pattern
description: Plan to deploy an Azure Stack HCI single-node storage switchless network reference pattern.
ms.topic: plan
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/14/2022
---

# Review single-node storage switchless deployment network reference pattern for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

In this article, you'll learn about the single-node storage switchless network reference pattern that you can use to deploy your Azure Stack HCI. The information in this article will also help you determine if this configuration is viable for your deployment planning needs. This article is targeted towards the IT administrators who deploy and manage Azure Stack HCI in their datacenters.

For information on other network patterns, see [Azure Stack HCI network deployment patterns](test0.md).

## Scenarios

Use the single-node storage switchless pattern in the following scenarios:

- **Facilities that can tolerate lower level of resiliency**. Consider implementing this pattern whenever your location or service provided by this pattern can tolerate the lower level of resiliency without impacting your business.

- **Food, healthcare, finance, retail, government facilities**. Some food, healthcare, finance, and retail scenarios can apply this option to minimize their costs without impacting their core operations and business transactions.

Consider implementing this pattern whenever your location/service provided by this pattern can tolerate the lower level of resiliency without impacting your business. Some food, healthcare, finance, and retail scenarios can apply this option to minimize their costs without impacting their core operations and business transactions. Although Software Defined Networking (SDN) L3 services are fully supported on this pattern, the routing services such as as Border Gateway Protocol (BGP) may need to be configured on the firewall device on top of the rack (TOR) switch..

Network security features such as micro-segmentation or Quality of Service (QoS) don't require extra configuration the firewall device, as they're implemented at virtual network adapter layer. For more information, see [Microsegmentation with Azure Stack HCI]https://techcommunity.microsoft.com/t5/azure-stack-blog/microsegmentation-with-azure-stack-hci/ba-p/2276339).

## Physical connectivity components

As illustrated in the diagram below, this pattern has the following physical network components:

- For northbound/southbound communication, the Azure Stack HCI cluster in this pattern is implemented with a single TOR switch.
- Two network ports in teaming to handle the management and compute traffics, connected to the L2 switch.
- The two RDMA NICs are disconnected as they aren’t used unless you add a second server to the system. There's no need to increase costs on cabling or physical switch ports consumption.
- As an option, single-node deployments can include a BMC card to enable remote management of the environment. Some solutions might use headless configuration without BMC card for security purposes.

:::image type="content" source="media/single-node-switchless/physical-connectivity-layout.png" alt-text="Diagram showing single-node switchless physical connectivity layout" lightbox="media/single-node-switchless/physical-connectivity-layout.png":::

|Networks|Management & compute|Storage|BMC|
|--|--|--|--|
|Link speed|At least 1 GBps. 10 GBps recommended|At least 1 GBps. 10 GBps recommended|Check with hardware manufacturer|
|Interface type|RJ45, SFP+ or SFP28|SFP+ or SFP28|RJ45|
|Ports and aggregation|Two teamed ports|Optional to allow adding a second server. Disconnected Ports|1 port|
|RDMA|Optional. Depends on requirements for Guest RDMA and NIC support|N/A|N/A|

## Network ATC intents

For single-node storage switchless pattern only one Network ATC intent is created for management and compute. RDMA network interfaces are disconnected.

:::image type="content" source="media/single-node-switchless/network-atc.png" alt-text="Diagram showing Network ATC intents for the single-node switchless pattern" lightbox="media/single-node-switchless/network-atc.png":::

### Management and compute intent

- Intent Type: Management and Compute
- Intent Mode: Cluster mode
- Teaming: Yes. pNIC01 and pNIC02 Team
- Default Management VLAN: Configured VLAN for management adapters isn’t modified
- PA VLAN and vNICs: Network ATC is transparent to PA vNICs and VLAN
- Compute VLANs and vNICs: Network ATC is transparent to compute VMs vNICs and VLANs

### Storage intent

- Intent type: None
- Intent mode: None
- Teaming: pNIC03 and pNIC04 are disconnected
- Default VLANs: None
- Default subnets: None

Follow these steps to create network intents for this reference pattern:

1. Run PowerShell as administrator.
1. Run the following command:

    ```powershell
    Add-NetIntent -Name <management_compute> -Management -Compute -ClusterName <HCI01> -AdapterName <pNIC01, pNIC02>
    ```

For more information, see [Deploy host networking: Compute and management intent](/azure-stack/hci/deploy/network-atc.md#compute-and-management-intent).

## Logical networks

As illustrated in the diagram below, this pattern has the following logical network components:

:::image type="content" source="media/single-node-switchless/logical-connectivity-layout.png" alt-text="Diagram showing single-node switchless logical connectivity layout" lightbox="media/single-node-switchless/logical-connectivity-layout.png":::

### Storage network VLANs

This pattern doesn't require a storage network.

### OOB network

The Out of Band (OOB) network is dedicated to supporting the server lights out server management interfaces also known as a BMC. This network is isolated from compute workloads. The OOB customer optional for non-solution-based installations. Each BMC interface connects to a customer supplied switch. The BMC is used to automate PXE boot scenarios. The management network will require network access to the BMC interface using the IPMI UDP port 623.

### Management VLAN

All physical compute hosts must access the management logical network. For IP address planning purposes, each physical compute host must have at least one IP address assigned from the management logical network.

A DHCP server can automatically assign IP addresses for the management network, or you can manually assign static IP addresses. When DHCP is the preferred IP assignment method, DHCP reservations without expiration are recommended.

The management network supports two different VLAN configurations Native or Tagged traffic:

- Native VLAN configuration, the customer isn't required to supply a VLAN ID. Required for solution-based installations.

- Tagged VLAN will be supplied by the customer at the time of deployment.
The Management network supports traffic used by the administrator for management of the cluster including Remote Desktop, Windows Admin Center, Active Directory, etc.

For more information, see [Plan an SDN infrastructure: Management and HNV Provider](/azure-stack/hci/concepts/plan-software-defined-networking-infrastructure.md#management-and-hnv-provider).

### Compute VLANs

In some scenarios, customers don’t need to use SDN Virtual Networks with VXLAN encapsulation. Instead, they can use traditional VLANs to isolate their tenant workloads. Those VLANs will need to be configured on the TOR switches port in trunk mode. When connecting new virtual machines to these VLANs, the corresponding VLAN tag will be defined on the virtual network adapter.

### HNV Provider Address (PA) network

The HNV Provider Address (PA) network serves as the underlying physical network for East/West (internal-internal) tenant traffic, North/South (external-internal) tenant traffic, and to exchange BGP peering information with the physical network. This network is only required when there's a need of deploying Virtual Networks using VXLAN encapsulation for an additional layer of isolation and network multitenancy.

For more information, see [Plan an SDN infrastructure: Management and HNV Provider](/azure-stack/hci/concepts/plan-software-defined-networking-infrastructure.md#management-and-hnv-provider).

## Network isolation

The following network isolation options are available.

### VLANs (IEEE 802.1Q)

VLANs allow devices that must be kept separate to share the cabling of a physical network and yet be prevented from directly interacting with one another. This managed sharing yields gains in simplicity, security, traffic management, and economy. For example, a VLAN can be used to separate traffic within a business based on individual users or groups of users or their roles, or based on traffic characteristics. Many Internet hosting services use VLANs to separate customers' private zones from one other, allowing each customer's servers to be grouped in a single network segment no matter where the individual servers are located in the data center. Some precautions are needed to prevent traffic "escaping" from a given VLAN, an exploit known as VLAN hopping.

For more information, see [Understand the usage of virtual networks and VLANs](/windows-server/networking/sdn/manage/understanding-usage-of-virtual-networks-and-vlans).

### Default network access policies and micro-segmentation

Default network access policies ensure that all customer VMs in your Azure Stack HCI cluster are secure by default from external threats. With these policies, we'll block inbound access to a VM by default, while giving the option to enable selective inbound ports and thus securing the VMs from external attacks. This enforcement will be available through management tools like Windows Admin Center.  

Micro-segmentation is the concept of creating granular network policies between applications and services. This essentially reduces the security perimeter to a fence around each application or virtual machine. The fence can permit only necessary communication between application tiers or other logical boundaries, thus making it exceedingly difficult for cyber threats to spread laterally from one system to another. This securely isolates networks from each other and reduces the total attack surface of a network security incident.

Default network access policies and micro-segmentation are realized as 5-tuple stateful (source address prefix, source port, destination address prefix, destination port, protocol) firewall rules a.k.a Network Security Groups (NSGs) on Azure Stack HCI clusters. These policies are enforced at the vSwitch port of each virtual machine (VM). The policies are pushed through the management layer, and Network Controller distributes them to all applicable hosts. These policies are available for VMs on traditional VLAN networks as well as SDN overlay networks.

> [!NOTE]
> These capabilities are enabled by default when deploying Azure Stack HCI and will deploy Network Controller VM(s).

For more information, see [What is Datacenter Firewall?](/azure-stack/hci/concepts/datacenter-firewall-overview).
 
### QoS for VM network adapters

You can configure Quality of Service (QoS) for a virtual machine (VM) network adapter to limit bandwidth on a virtual interface to prevent a high-traffic VM from contending with other VM network traffic. You can also configure QoS to reserve a specific amount of bandwidth for a VM to ensure that the VM can send traffic regardless of other traffic on the network. This can be applied to VMs attached to traditional VLAN networks as well as VMs attached to SDN overlay networks.

> [!NOTE]
> This network isolation option is enabled by default when deploying Azure Stack HCI and will deploy Network Controller VM(s).

For more information, see [Configure QoS for a VM network adapter](/windows-server/networking/sdn/manage/configure-qos-for-tenant-vm-network-adapter).

### Virtual networks

Network virtualization provides "virtual networks" (called a VM network) to virtual machines like how server virtualization (hypervisor) provides virtual machines (Vms) to the operating system. Network virtualization decouples virtual networks from the physical network infrastructure and removes the constraints of VLAN and hierarchical IP address assignment from virtual machine provisioning. This flexibility makes it easy for customers to move to IaaS clouds and efficient for hosters and datacenter administrators to manage their infrastructure, while maintaining the necessary multi-tenant isolation, security requirements, and supporting overlapping Virtual Machine IP addresses.

> [!NOTE]
> This network isolation option isn't enabled by default when deploying Azure Stack HCI and requires user to explicitly enable it during deployment.

For more information, see [Hyper-V Network Virtualization](/windows-server/networking/sdn/technologies/hyper-v-network-virtualization/hyper-v-network-virtualization).
 
## L3 networking services options

### Virtual network peering

Virtual network peering lets you connect two virtual networks seamlessly. Once peered, for connectivity purposes, the virtual networks appear as one. The benefits of using virtual network peering include:

- Traffic between virtual machines in the peered virtual networks gets routed through the backbone infrastructure through private IP addresses only. The communication between the virtual networks doesn't require public Internet or gateways.
- A low-latency, high-bandwidth connection between resources in different virtual networks.
- The ability for resources in one virtual network to communicate with resources in a different virtual network.
- No downtime to resources in either virtual network when creating the peering.

For more information, see [Virtual network peering](/windows-server/networking/sdn/vnet-peering/sdn-vnet-peering.md).

### Load balancers

Cloud Service Providers (CSPs) and enterprises that are deploying Software Defined Networking (SDN) can use Software Load Balancer (SLB) to evenly distribute customer network traffic among virtual network resources. SLB enables multiple servers to host the same workload, providing high availability and scalability. It's also used to provide inbound Network Address Translation (NAT) services for inbound access to virtual machines, and outbound NAT services for outbound connectivity.

Using Software Load Balancer, you can scale out your load balancing capabilities using SLB virtual machines (VMs) on the same Hyper-V compute servers that you use for your other VM workloads. Because of this, Software Load Balancer supports rapid creation and deletion of load balancing endpoints as required for CSP operations. In addition, Software Load Balancer supports tens of gigabytes per cluster, provides a simple provisioning model, and is easy to scale out and in.

SLB uses [Border Gateway Protocol](/windows-server/remote/remote-access/bgp/border-gateway-protocol-bgp.md) to advertise virtual IP addresses to the physical network.

For more information, see [What is SLB for SDN?](/azure-stack/hci/concepts/software-load-balancer.md).

### SDN VPN gateways

SDN Gateway is a software-based Border Gateway Protocol (BGP) capable router designed for cloud service providers (CSPs) and enterprises that host multitenant virtual networks using Hyper-V Network Virtualization (HNV). You can use RAS Gateway to route network traffic between a virtual network and another network, either local or remote.

Gateways can be used to:

- Create secure site-to-site IPsec connections between SDN virtual networks and external customer networks over the internet.

- Create Generic Routing Encapsulation (GRE) connections between SDN virtual networks and external networks. The difference between site-to-site connections and GRE connections is that the latter isn't an encrypted connection.

    For more information about GRE connectivity scenarios, see [GRE Tunneling in Windows Server](/windows-server/remote/remote-access/ras-gateway/gre-tunneling-windows-server.md).

- Create Layer 3 connections between SDN virtual networks and external networks. In this case, the SDN gateway simply acts as a router between your virtual network and the external network.

SDN Gateway requires [Network Controller](/azure-stack/hci/concepts/network-controller-overview.md), which performs the deployment of gateway pools, configures tenant connections on each gateway, and switches network traffic flows to a standby gateway if a gateway fails.

Gateways use [Border Gateway Protocol](/windows-server/remote/remote-access/bgp/border-gateway-protocol-bgp.md) to advertise GRE endpoints and establish point-to-point connections. SDN deployment creates a default gateway pool that supports all connection types. Within this pool, you can specify how many gateways are reserved on standby in case an active gateway fails.

For more information, see [What is RAS Gateway for SDN?](/azure-stack/hci/concepts/gateway-overview.md)

## Next steps

Learn about the [single-node storage switched network pattern](single-node-switchless.md).