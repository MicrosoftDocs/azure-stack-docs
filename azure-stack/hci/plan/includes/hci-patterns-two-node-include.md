---
ms.topic: include
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/29/2022
---

### OOB network

The Out of Band (OOB) network is dedicated to supporting the "lights-out" server management interface also known as the baseboard management controller (BMC). Each BMC interface connects to a customer-supplied switch. The BMC is used to automate PXE boot scenarios.

The management network requires access to the BMC interface using Intelligent Platform Management Interface (IPMI) User Datagram Protocol (UDP) port 623.

The OOB network is isolated from compute workloads and is optional for non-solution-based deployments.

### Management VLAN

All physical compute hosts require access to the management logical network. For IP address planning, each physical compute host must have at least one IP address assigned from the management logical network.

A DHCP server can automatically assign IP addresses for the management network, or you can manually assign static IP addresses. When DHCP is the preferred IP assignment method, we recommend that you use DHCP reservations without expiration.

The management network supports the following VLAN configurations:

- **Native VLAN** - you aren't required to supply VLAN IDs. This is required for solution-based installations.

- **Tagged VLAN** - you supply VLAN IDs at the time of deployment.

The management network supports all traffic used for management of the cluster, including Remote Desktop, Windows Admin Center, and Active Directory.

For more information, see [Plan an SDN infrastructure: Management and HNV Provider](/azure-stack/hci/concepts/plan-software-defined-networking-infrastructure.md#management-and-hnv-provider).

### Compute VLANs

In some scenarios, you don’t need to use SDN Virtual Networks with Virtual Extensible LAN (VXLAN) encapsulation. Instead, you can use traditional VLANs to isolate your tenant workloads. Those VLANs are configured on the TOR switch's port in trunk mode. When connecting new VMs to these VLANs, the corresponding VLAN tag is defined on the virtual network adapter.

### HNV Provider Address (PA) network

The Hyper-V Network Virtualization (HNV) Provider Address (PA) network serves as the underlying physical network for East/West (internal-internal) tenant traffic, North/South (external-internal) tenant traffic, and to exchange BGP peering information with the physical network. This network is only required when there's a need for deploying virtual networks using VXLAN encapsulation for another layer of isolation and for network multitenancy.

For more information, see [Plan an SDN infrastructure: Management and HNV Provider](/azure-stack/hci/concepts/plan-software-defined-networking-infrastructure.md#management-and-hnv-provider).

## Network isolation options

The following network isolation options are supported:

### VLANs (IEEE 802.1Q)

VLANs allow devices that must be kept separate to share the cabling of a physical network and yet be prevented from directly interacting with one another. This managed sharing yields gains in simplicity, security, traffic management, and economy. For example, a VLAN can be used to separate traffic within a business based on individual users or groups of users or their roles, or based on traffic characteristics. Many internet hosting services use VLANs to separate private zones from one other, allowing each customer's servers to be grouped in a single network segment no matter where the individual servers are located in the data center. Some precautions are needed to prevent traffic "escaping" from a given VLAN, an exploit known as VLAN hopping.

For more information, see [Understand the usage of virtual networks and VLANs](/windows-server/networking/sdn/manage/understanding-usage-of-virtual-networks-and-vlans).

### Default network access policies and microsegmentation

Default network access policies ensure that all virtual machines (VMs) in your Azure Stack HCI cluster are secure by default from external threats. With these policies, we'll block inbound access to a VM by default, while giving the option to enable selective inbound ports and thus securing the VMs from external attacks. This enforcement is available through management tools like Windows Admin Center.  

Microsegmentation involves creating granular network policies between applications and services. This essentially reduces the security perimeter to a fence around each application or VM. This fence permits only necessary communication between application tiers or other logical boundaries, thus making it exceedingly difficult for cyberthreats to spread laterally from one system to another. Microsegmentation securely isolates networks from each other and reduces the total attack surface of a network security incident.

Default network access policies and microsegmentation are realized as five-tuple stateful (source address prefix, source port, destination address prefix, destination port, and protocol) firewall rules on Azure Stack HCI clusters. Firewall rules are also known as Network Security Groups (NSGs). These policies are enforced at the vSwitch port of each VM. The policies are pushed through the management layer, and the SDN Network Controller distributes them to all applicable hosts. These policies are available for VMs on traditional VLAN networks and on SDN overlay networks.

> [!NOTE]
> These capabilities are enabled by default when deploying Azure Stack HCI and Network Controller VMs.

For more information, see [What is Datacenter Firewall?](/azure-stack/hci/concepts/datacenter-firewall-overview).
 
### QoS for VM network adapters

You can configure Quality of Service (QoS) for a VM network adapter to limit bandwidth on a virtual interface to prevent a high-traffic VM from contending with other VM network traffic. You can also configure QoS to reserve a specific amount of bandwidth for a VM to ensure that the VM can send traffic regardless of other traffic on the network. This can be applied to VMs attached to traditional VLAN networks as well as VMs attached to SDN overlay networks.

> [!NOTE]
> This network isolation option is enabled by default when deploying Azure Stack HCI and Network Controller VMs.

For more information, see [Configure QoS for a VM network adapter](/windows-server/networking/sdn/manage/configure-qos-for-tenant-vm-network-adapter).

### Virtual networks

Network virtualization provides virtual networks to VMs similar to how server virtualization (hypervisor) provides VMs to the operating system. Network virtualization decouples virtual networks from the physical network infrastructure and removes the constraints of VLAN and hierarchical IP address assignment from VM provisioning. Such flexibility makes it easy for you to move to (Infrastructure-as-a-Service) IaaS clouds and is efficient for hosters and datacenter administrators to manage their infrastructure, and maintaining the necessary multi-tenant isolation, security requirements, and overlapping VM IP addresses.

> [!NOTE]
> This network isolation option isn't enabled by default when deploying Azure Stack HCI and requires you to explicitly enable it during deployment.

For more information, see [Hyper-V Network Virtualization](/windows-server/networking/sdn/technologies/hyper-v-network-virtualization/hyper-v-network-virtualization).

## L3 networking services options

The following L3 networking service options are available:

### Virtual network peering

Virtual network peering lets you connect two virtual networks seamlessly. Once peered, for connectivity purposes, the virtual networks appear as one. The benefits of using virtual network peering include:

- Traffic between VMs in the peered virtual networks gets routed through the backbone infrastructure through private IP addresses only. The communication between the virtual networks doesn't require public Internet or gateways.
- A low-latency, high-bandwidth connection between resources in different virtual networks.
- The ability for resources in one virtual network to communicate with resources in a different virtual network.
- No downtime to resources in either virtual network when creating the peering.

For more information, see [Virtual network peering](/windows-server/networking/sdn/vnet-peering/sdn-vnet-peering.md).

### SDN software load balancer

Cloud Service Providers (CSPs) and enterprises that deploy Software Defined Networking (SDN) can use Software Load Balancer (SLB) to evenly distribute customer network traffic among virtual network resources. SLB enables multiple servers to host the same workload, providing high availability and scalability. It's also used to provide inbound Network Address Translation (NAT) services for inbound access to VMs, and outbound NAT services for outbound connectivity.

Using SLB, you can scale out your load balancing capabilities using SLB VMs on the same Hyper-V compute servers that you use for your other VM workloads. SLB supports rapid creation and deletion of load balancing endpoints as required for CSP operations. In addition, SLB supports tens of gigabytes per cluster, provides a simple provisioning model, and is easy to scale out and in. SLB uses [Border Gateway Protocol](/windows-server/remote/remote-access/bgp/border-gateway-protocol-bgp.md) to advertise virtual IP addresses to the physical network.

For more information, see [What is SLB for SDN?](/azure-stack/hci/concepts/software-load-balancer.md)

### SDN VPN gateways

SDN Gateway is a software-based Border Gateway Protocol (BGP) capable router designed for CSPs and enterprises that host multi-tenant virtual networks using Hyper-V Network Virtualization (HNV). You can use RAS Gateway to route network traffic between a virtual network and another network, either local or remote.

SDN Gateway can be used to:

- Create secure site-to-site IPsec connections between SDN virtual networks and external customer networks over the internet.

- Create Generic Routing Encapsulation (GRE) connections between SDN virtual networks and external networks. The difference between site-to-site connections and GRE connections is that the latter isn't an encrypted connection.

    For more information about GRE connectivity scenarios, see [GRE Tunneling in Windows Server](/windows-server/remote/remote-access/ras-gateway/gre-tunneling-windows-server.md).

- Create Layer 3 (L3) connections between SDN virtual networks and external networks. In this case, the SDN gateway simply acts as a router between your virtual network and the external network.

SDN Gateway requires SDN [Network Controller](/azure-stack/hci/concepts/network-controller-overview.md). Network Controller performs the deployment of gateway pools, configures tenant connections on each gateway, and switches network traffic flows to a standby gateway if a gateway fails.

Gateways use [Border Gateway Protocol](/windows-server/remote/remote-access/bgp/border-gateway-protocol-bgp.md) to advertise GRE endpoints and establish point-to-point connections. SDN deployment creates a default gateway pool that supports all connection types. Within this pool, you can specify how many gateways are reserved on standby in case an active gateway fails.

For more information, see [What is RAS Gateway for SDN?](/azure-stack/hci/concepts/gateway-overview.md)