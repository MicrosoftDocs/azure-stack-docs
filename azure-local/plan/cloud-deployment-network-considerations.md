---
title: Network considerations for cloud deployment for Azure Local
description: Plan the network architecture for an Azure Local cloud deployment by using an 11-decision design framework that covers connectivity mode, architecture, topology, storage, intents, IP addressing, backup, outbound connectivity, and software defined networking.
author: ronmiab
ms.topic: how-to
ms.date: 07/28/2026
ms.author: cedward
ms.subservice: hyperconverged
---

# Network considerations for cloud deployments of Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article discusses how to design and plan an Azure Local system network for cloud deployment. Before you continue, familiarize yourself with the various [Azure Local networking patterns](../plan/choose-network-pattern.md) and available configurations.

## Why a network design framework

Designing the host network for an Azure Local instance involves more than 10 interlocking decisions—connectivity mode, architecture, physical topology, cluster size, storage connectivity, network adapter ports, network traffic intents, IP addressing, VLANs, backup, outbound connectivity, and software defined networking. A structured framework helps you:

- Make each decision once, in the right order, so that earlier choices constrain and simplify later ones.
- Catch invalid combinations early, such as an unsupported mix of architecture, storage type, and intents.
- Establish a shared vocabulary across architects, operations, and field deployments.
- Apply a repeatable process from a single-node edge cluster to a 64-node multi-rack deployment.

## Network design framework

The network design framework is a sequence of 11 decisions for your Azure Local instance. You decide the connectivity mode first, then choose an architecture that forks the design into a hyperconverged (HCI) path or a disaggregated (DA) path. Each later decision documents both paths and closes with a list of design considerations:

1. [Determine connectivity mode](#decision-1-determine-connectivity-mode)
2. [Determine architecture](#decision-2-determine-architecture)
3. [Determine cluster topology](#decision-3-determine-cluster-topology)
4. [Determine cluster size](#decision-4-determine-cluster-size)
5. [Determine storage connectivity](#decision-5-determine-storage-connectivity)
6. [Determine network adapter ports and configuration](#decision-6-determine-network-adapter-ports-and-configuration)
7. [Determine network traffic intents](#decision-7-determine-network-traffic-intents)
8. [Determine management IPs and infrastructure network](#decision-8-determine-management-ips-and-infrastructure-network)
9. [Determine backup network](#decision-9-determine-backup-network)
10. [Determine outbound connectivity](#decision-10-determine-outbound-connectivity)
11. [Determine software defined networking (SDN)](#decision-11-determine-software-defined-networking-sdn)

## Decision 1: Determine connectivity mode

The connectivity mode determines how your Azure Local instance reaches Azure for registration, billing, and lifecycle management. You decide it first, because it applies to both the hyperconverged and disaggregated architectures and influences your outbound connectivity design in [Decision 10](#decision-10-determine-outbound-connectivity).

- **Connected**: Nodes and infrastructure services reach Azure over the internet—directly, through an enterprise proxy, through the Azure Arc gateway, or over ExpressRoute/S2S VPN. This is the most common mode and is required for standard cloud deployment. You plan the details of outbound connectivity in [Decision 10](#decision-10-determine-outbound-connectivity).
- **Disconnected (air-gapped)**: For sovereign, regulated, or air-gapped environments, Azure Local disconnected operations provide a local Autonomous Cloud endpoint instead of public Azure endpoints. A disconnected deployment uses an on-premises Azure Arc control plane running on a dedicated 3 nodes management cluster.

Here are the summarized considerations for the connectivity mode decision:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | Connected deployments require outbound access to Azure for Arc registration, billing, and lifecycle management. Plan the outbound topology in [Decision 10](#decision-10-determine-outbound-connectivity).        | Both  |
|2     | Disconnected deployments use Azure Local disconnected operations with a local Autonomous Cloud endpoint and don't require public Azure endpoints.        | Both  |
|3     | Disconnected deployments require a dedicated three-node management cluster plus one or more workload clusters.        | Both  |
|4     | The connectivity mode applies to both the hyperconverged and disaggregated architectures you choose in [Decision 2](#decision-2-determine-architecture).        | Both  |

## Decision 2: Determine architecture

The architecture decision forks the design into one of two paths. It determines the storage architecture, the cluster size, and the network intents available to you in the rest of this article.

| Architecture | Storage architecture | Typical scale | When to use it |
|--------------|----------------------|---------------|----------------|
| **Hyperconverged (HCI)** | Local NVMe/SSD/HDD pooled with Storage Spaces Direct (S2D). Storage traffic over RDMA. | 1–16 nodes, single rack or rack-aware | Most deployments. Compute and storage scale together. |
| **Hyperconverged (HCI) – hybrid storage variant** | S2D *plus* an external SAN side by side. Choose the storage type per workload. | 1–16 nodes, single rack | A hyperconverged cluster that also needs SAN-backed volumes for specific workloads. You attach the SAN after initial deployment; rack-aware isn't supported. |
| **Disaggregated (DA)** | External SAN—Fiber Channel (FC) or IP-based SAN. No S2D. Compute and storage scale independently. | 1 to 8 racks, up to 16 nodes per rack and 64 nodes per cluster | You already operate SAN storage, or need to scale compute and storage independently. |

The hyperconverged architecture also has an optional *hybrid storage* variant that runs an external SAN side by side with S2D so you can choose the storage type per workload. It's a hyperconverged-only configuration that you attach after initial deployment. [Decision 5](#decision-5-determine-storage-connectivity) covers the design details and the supported external storage integrations.

Each decision in this framework documents both architectures side by side, with separate hyperconverged (HCI) and disaggregated (DA) sections. Follow the design decisions for the architecture you chose here.

Here are the summarized considerations for the architecture decision:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | The architecture you choose determines the storage connectivity, network adapter ports, and network traffic intents available in later steps.        | Both  |
|2     | Hyperconverged (HCI) supports a rack-aware variant that stretches the cluster across two rooms or availability zones, while disaggregated (DA) scales across multiple racks. You define the physical layout in [Decision 3](#decision-3-determine-cluster-topology).        | Both  |
|3     | Hyperconverged (HCI) uses Storage Spaces Direct with local drives. Compute and storage scale together, up to 16 nodes.        | HCI  |
|4     | Hybrid storage is a hyperconverged-only variant: the cluster runs S2D with an external SAN side by side. You attach the external SAN after initial deployment (day-2 operation), not during the first deployment.        | HCI  |
|5     | Disaggregated (DA) uses an external SAN—Fiber Channel (FC) or IP-based SAN with no Storage Spaces Direct. Compute and storage scale independently across 1 to 8 racks, up to 16 nodes per rack and 64 nodes per cluster.        | DA  |


## Decision 3: Determine cluster topology

The cluster topology decision defines the physical layout of your nodes and switches. The available options depend on the architecture you chose in [Decision 2](#decision-2-determine-architecture).

The standard physical shape for both architectures is a single rack with a pair of top-of-rack (ToR) switches:

- A pair of ToR switches configured with multichassis link aggregation (MLAG), supporting up to 16 nodes in the same rack.
- One baseboard management controller (BMC) switch for out-of-band management above the ToRs.
- Northbound uplinks to the existing core switch, router, or firewall.

### Hyperconverged (HCI)

A hyperconverged cluster uses a single rack or a rack-aware layout:

- **Single rack**: All nodes and the ToR switch pair are in one rack, supporting up to 16 nodes. For switched patterns, all host traffic—management, compute, and storage—runs over the same switch pair.
- **Rack-aware (two zones)**: A rack-aware cluster spreads a hyperconverged deployment across two rooms or availability zones:
  - An even number of nodes split across two rooms, up to 8 nodes, assigned to two cluster availability zones.
  - Less than 1 ms latency is required between rooms for S2D replication.
  - RDMA storage traffic stays at the ToR layer and never traverses the spine.

  Four uplink options are available for rack-aware clusters:

  | Option | Topology | Notes |
  |--------|----------|-------|
  | 1. Dedicated storage links | 2 ToRs per room (4 total) | TOR1↔TOR3 on VLAN 711, TOR2↔TOR4 on VLAN 712. |
  | 2. Aggregated storage links | 2 ToRs per room (4 total) | Storage uses LAG/vPC across rooms; potential extra hop and RDMA latency versus option 1. |
  | 3. Per-room node connectivity | 1 ToR per room (2 total) | Both storage networks share the same ToR per room; bundled inter-room link. |
  | 4. Cross-room node connectivity | 1 ToR per room (2 total) | Each machine is cabled to ToRs in both rooms; reduces ToR-to-ToR dependency but increases cabling. |

### Disaggregated (DA)

A disaggregated cluster can span 1 to 8 racks:

- **Single rack**: A two-switch HSRP pair is sufficient up to 16 nodes. Cluster networks run on standalone network ports and aren't managed by Network ATC.
- **Multiple racks**: For more than 16 nodes, spread the cluster across up to 8 racks connected by a leaf-spine (Clos) fabric: each rack has two compute leaf switches, with two spines and two service leaf switches above the racks. Each rack holds up to 16 nodes, and the cluster scales to a maximum of 64 nodes. Only fabric-based SDN is supported; Microsoft SDN isn't supported.

For more information about the leaf-spine fabric architecture, traffic flow, and how to choose a disaggregated pattern, see [Network reference patterns overview for disaggregated deployments](../plan/network-patterns-overview-disaggregated.md) and [Choose a network reference pattern for disaggregated deployments](../plan/choose-network-pattern-disaggregated.md).

Here are the summarized considerations for the cluster topology decision:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | A single rack with a pair of ToR switches supports up to 16 nodes for both architectures.        | Both  |
|2     | Hyperconverged single-rack clusters run all host traffic (management, compute, and storage) over the same MLAG-configured ToR switch pair. Don't use a separate storage-only switch pair.        | HCI  |
|3     | Hyperconverged rack-aware clusters span two rooms or availability zones, with an even number of nodes up to 8 and less than 1 ms latency between rooms. Rack-aware clusters aren't supported with external SAN (hybrid) storage.        | HCI  |
|4     | For hyperconverged rack-aware clusters, choose one of the four uplink options. Dedicated storage links (option 1) keep RDMA traffic at the ToR layer with the lowest latency.        | HCI  |
|5     | Disaggregated clusters span 1 to 8 racks connected by a leaf-spine (Clos) fabric, with up to 16 nodes per rack and 64 nodes per cluster.        | DA  |
|6     | For more than 16 disaggregated nodes, use a leaf-spine fabric across multiple racks. Only fabric-based SDN is supported.        | DA  |

## Decision 4: Determine cluster size

To help determine the size of your Azure Local instance, use the [Azure Local sizer tool](https://azurestackhcisolutions.azure.microsoft.com/#/sizer) or the community tool sizer included in [Odin for Azure Local](https://aka.ms/Odin), where you can define your profile such as number of virtual machines (VMs), size of the VMs, and the workload use of the VMs such as Azure Virtual Desktop, SQL Server, or AKS.

As described in the Azure Local [machine requirements](../concepts/system-requirements-23h2.md#machine-and-storage-requirements) article, the maximum number of machines supported in a single hyperconverged (HCI) Azure Local instance is 16. Disaggregated deployments that use an external SAN scale to 64 nodes. Once you complete your workload capacity planning, you should have a good understanding of the number of machine nodes required to run workloads on your infrastructure.

### Hyperconverged (HCI)

A hyperconverged cluster supports 1 to 16 nodes. The node count determines your storage connectivity options in [Decision 5](#decision-5-determine-storage-connectivity):

- **If your workloads require four or more nodes with S2D storage**: You can't use a switchless configuration for storage network traffic. You need to include a physical switch with support for Remote Direct Memory Access (RDMA) to handle storage traffic. For more information on Azure Local instance network architecture, see [Network reference patterns overview](../plan/network-patterns-overview.md).
- **If your workloads require four or fewer nodes**: You can choose either switchless or switched configurations for storage connectivity. Switchless storage is supported for clusters of 1 to 4 nodes.
- **If you plan to scale out later beyond a switchless configuration**: You need to use a physical switch for storage network traffic. Any scale out operation for switchless deployments requires manual configuration of your network cabling between the nodes, which Microsoft isn't actively validating as part of its software development cycle for Azure Local.

### Disaggregated (DA)

A disaggregated cluster scales compute and storage independently across 1 to 8 racks, with up to 16 nodes per rack and a maximum of 64 nodes per cluster. Storage capacity is independent of the node count, because storage is provided by the external SAN rather than by local drives.

### Supported deployment shapes

The combination of node count and storage option determines whether a deployment shape is supported, and whether it requires Resource Manager templates:

| Nodes | No switch for storage (S2D switchless) | Network switch for storage (S2D switched) | External SAN (FC or IP-based) |
|-------|:--------------------------------------:|:-----------------------------------------:|:--------------------------:|
| 1 node | ✅ (default) | ✅ | ✅ |
| 2 nodes | ✅ (Azure portal or ARM templates) | ✅ | ✅ |
| 3 nodes | ✅ (ARM templates only) | ✅ | ✅ |
| 4 nodes | ✅ (ARM templates only) | ✅ | ✅ |
| 5–16 nodes | ❌ | ✅ | ✅ |
| More than 16 nodes (multi-rack) | ❌ | ❌ | ✅ |

Here are the summarized considerations for the cluster size decision:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | Hyperconverged clusters with more than 4 nodes that use S2D storage require a physical switch for the storage network traffic.        | HCI  |
|2     | If you intend to scale out your cluster using the orchestrator, you need to use a physical switch for the storage network traffic.        | HCI  |
|3     | Disaggregated clusters scale compute and storage independently across 1 to 8 racks, up to 16 nodes per rack and 64 nodes per cluster. Storage capacity is independent of the node count because it's provided by the external SAN.        | DA  |

## Decision 5: Determine storage connectivity

As described in [Physical network requirements](../concepts/physical-network-requirements.md), the storage connectivity options depend on the architecture you chose in [Decision 2](#decision-2-determine-architecture). Unless you override them with Resource Manager templates, all Storage Spaces Direct (S2D) patterns use the following Network ATC storage defaults:

| Storage network | Default VLAN | Default subnet |
|-----------------|--------------|----------------|
| Storage network 1 | 711 | 10.71.1.0/24 |
| Storage network 2 | 712 | 10.71.2.0/24 |
| Storage network 3 (when present) | 713 | 10.71.3.0/24 |

### Hyperconverged (HCI)

Hyperconverged deployments use Storage Spaces Direct with one of two storage connectivity types:

- **Switched storage**: Use a physical network switch to handle the storage traffic. Switched storage supports 1 to 16 nodes and supports scale-out.
- **Switchless storage**: Directly connect the nodes between them with crossover network or fiber cables for the storage traffic. Switchless storage is supported for clusters of 1 to 4 nodes only—a hard upper limit—and doesn't support scale-out.

The advantages and disadvantages of switched and switchless options are documented in the article linked above.

You can only decide between switched and switchless storage when the size of your cluster is four or fewer nodes. Any S2D cluster with more than four nodes is automatically deployed using a network switch for storage.

> [!IMPORTANT]
> For switched hyperconverged deployments, run storage traffic over the *same* top-of-rack (ToR) switch pair that carries management and compute traffic. Using a separate, dedicated pair of switches for the storage intent only isn't supported. A storage-only switch pair that is isolated from the management and compute network can lead to a cluster split-brain situation, because the nodes can lose the storage (east-west) path while keeping the management path, or the reverse. Keep all intents on a single MLAG-configured ToR switch pair per rack.

If clusters have four or fewer nodes, the storage connectivity decision influences the number and type of network intents you can define in [Decision 7](#decision-7-determine-network-traffic-intents). For example, for switchless configurations, you need to define two network traffic intents. Storage traffic for east-west communication using the crossover cables doesn't have north-south connectivity and is completely isolated from the rest of your network infrastructure. That means you need to define a second network intent for management outbound connectivity and for your compute workloads.

Although it's possible to define each network intent with only one physical network adapter port, that doesn't provide any fault tolerance. As such, we always recommend using at least two physical network ports for each network intent. If you decide to use a network switch for storage, you can group all network traffic including storage in a single network intent, which is also known as a *hyperconverged* or *fully converged* host network configuration.

#### Storage IP planning for switchless clusters

For switchless storage, the number of storage subnets grows with the number of nodes, because each node needs a direct connection to every other node. The number of storage subnets equals *N* × (*N* − 1), where *N* is the number of nodes:

| Switchless nodes | Storage subnets | Storage Auto IP |
|------------------|-----------------|-----------------|
| 2 | 2 | Supported automatically |
| 3 | 6 | Disable Storage Auto IP and define all storage IPs in the Resource Manager template |
| 4 | 12 | Disable Storage Auto IP and define all storage IPs in the Resource Manager template |

For more information about defining custom storage IPs, see [Custom IPs for storage](#custom-ips-for-storage).

#### Hybrid storage (S2D plus external SAN)

Azure Local supports attaching an external SAN to a hyperconverged cluster so that SAN-backed storage operates side by side with in-box Storage Spaces Direct (S2D). The external SAN is always attached as a post-deployment (day-2) operation: you first deploy a standard hyperconverged cluster with S2D, and then attach the SAN afterward. You can't deploy a hybrid configuration from the start, so plan the SAN fabric and adapters up front even though you connect them after the cluster is running. This lets you choose S2D or external SAN volumes per workload for VMs, AKS clusters, and Azure Virtual Desktop (AVD). Multiple SAN volumes are presented as Cluster Shared Volumes (CSVs) formatted with NTFS, and each CSV appears as a folder path that you map as a storage path for VMs. Two integrations are generally available:

- **Fiber Channel (FC) SAN arrays**: Each node connects to the SAN through dual Fiber Channel fabrics (Fabric A and Fabric B) for redundancy, using Host Bus Adapters (HBAs) on each host. SAN-backed volumes are discovered as NTFS CSVs and shared across nodes, and compute and storage scale independently.
- **IP-based (Ethernet) SAN**: Each node connects to the array over the Ethernet storage network—using a standard iSCSI initiator or a vendor-supplied storage client—and mounts remote block volumes into the cluster with multipath I/O across redundant fabrics. Volumes are presented as NTFS CSVs and shared across nodes, and compute and storage scale independently. These solutions typically use dedicated storage subnets, jumbo frames, and NIC bonding/teaming. Whether those storage subnets are routable depends on your storage network architecture: some deployments connect hosts directly to dedicated storage switches on isolated, non-routable subnets, while others route storage traffic in from the datacenter network. Supported node counts, scale limits, and the exact jumbo-frame MTU depend on the storage vendor and Azure Local validation.

From a network design standpoint:

- The S2D storage network is unchanged from the original switched or switchless deployment.
- SAN connectivity uses separate fabrics and adapters (FC HBAs, or NICs for IP-based SAN) and isn't managed by Network ATC. Plan dedicated ports for the SAN connectivity, and for IP-based block storage, dedicated storage subnets with jumbo frames (routable or non-routable, depending on your storage network architecture).
- Rack-aware clusters aren't supported with external SAN storage for hyperconverged deployments.

For more information, see [External storage support for Azure Local](../concepts/external-storage-support.md).

### Disaggregated (DA)

When you use an external SAN—Fiber Channel or IP-based SAN (for example, iSCSI or PowerFlex SDC)—there's no Storage Spaces Direct and no RDMA storage intent managed by Network ATC. In both cases:

- **Management and compute** traffic is configured through Network ATC using a Switch Embedded Teaming (SET) virtual switch.
- **Cluster networks**—Cluster Shared Volume (CSV) and Live Migration traffic over SMB Multichannel—run on standalone network ports that are *not* managed by Network ATC. Plan dedicated VLANs and subnets for these networks. The default cluster VLANs are 1711 and 1712.
- Configure Ethernet quality of service (QoS) for the cluster networks. [Decision 6](#decision-6-determine-network-adapter-ports-and-configuration) describes the recommended class of service (CoS) priority scheme and bandwidth allocation.

The storage fabric differs by SAN type:

- **Fiber Channel (FC)**: Storage runs entirely on the FC fabric, separate from the Ethernet network. No Ethernet storage QoS, Priority Flow Control (PFC), or lossless Ethernet is required—all cluster traffic is TCP over SMB Multichannel.
- **IP based SAN**: Storage runs over dedicated Ethernet adapters to access the IP based SAN. It replaces Storage Spaces Direct and removes RDMA, and because all traffic (IP based SAN traffic, CSV, Live Migration, and cluster heartbeat) runs over TCP, lossless Ethernet and PFC aren't required. Validate that your SAN array model is supported before you deploy.

iSCSI deployments follow this validated pattern, which you choose in [Decision 6](#decision-6-determine-network-adapter-ports-and-configuration):

- **6-port dedicated-path**: Dedicated ports carry iSCSI path A and path B, separate from the cluster networks. This pattern supports an optional dedicated backup network.

For more information about connecting an external SAN, including the host-side and array-side configuration for Fiber Channel and iSCSI, see [Connect an external storage array to Azure Local](../deploy/enable-external-storage.md) and [External storage support for Azure Local](../concepts/external-storage-support.md).

#### iSCSI host static routes

For iSCSI deployments, only the management interface has a default gateway. The cluster and iSCSI interfaces have IP addresses *without* a default gateway. To reach iSCSI targets that are one or more Layer 3 hops away, configure a persistent /32 static route on each host for every iSCSI target IP, with the next hop set to the leaf switch gateway (switch virtual interface) on the iSCSI VLAN and the route bound to the storage adapter. Static routes force iSCSI traffic out the storage adapter and prevent it from leaking onto the management network. In a Multipath I/O (MPIO) configuration, each iSCSI path needs its own static route to the same targets over its respective VLAN. If an array exposes many target IPs in the same subnet, you can route the whole target subnet through the corresponding path gateway instead of adding one route per target. You configure the iSCSI initiator, static routes, and MPIO during operating system installation.

> [!NOTE]
> With external SAN storage, Storage Spaces Direct isn't used, so the storage intent options that depend on RDMA aren't available. Use the management and compute intent, plus the standalone cluster networks described above.

### Custom IPs for storage

By default, Network ATC automatically assigns the IPs and VLANs for storage from the following table:

|Storage adapter|IP address and subnet|VLAN|
|---------------|---------------------|----|
|pNIC1          |10.71.1.x            |711 |
|pNIC2          |10.71.2.x            |712 |
|pNIC3          |10.71.3.x            |713 |

However, if your deployment requirements don't fit with those default IPs and VLANs, you can use your own IPs, subnet, and VLANs for storage. This functionality is only available when deploying clusters using ARM templates, and you'll need to specify the following parameters in your template:

- **enableStorageAutoIP:** When this parameter isn't specified, it's set to `true`. To enable custom storage IPs during deployment, this parameter must be set to `false`. Storage Auto IP is supported for 2-node switchless clusters; for 3-node and 4-node switchless clusters, you must set this parameter to `false` and define all storage IPs explicitly.
- **storageAdapterIPInfo:** This parameter has a dependency with the `enableStorageAutoIP` parameter and is always required when the storage auto IP parameter is set to `false`. Within the `storageAdapterIPInfo` parameter in your ARM template, you'll also need to specify the `ipv4Address` and `subnetMask` parameters for each node and network adapter with your own IPs and subnet mask.
- **vlanId:** As described in the table above, this parameter uses the Network ATC default VLANs if you don't need to change them. However, if those default VLANs don't work in your network, you can specify your own VLAN IDs for each of your storage networks.

The following ARM template includes an example of a two-node Azure Local instance with a network switch for storage, where storage IPs are customized: [2 nodes deployment with custom storage IPs](https://github.com/Azure/azure-quickstart-templates/blob/master/quickstarts/microsoft.azurestackhci/create-cluster-2-node-switched-custom-storageip/azuredeploy.parameters.json).

Here are the summarized considerations for the storage connectivity decision:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | Switchless configuration via the Azure portal is supported for 1 or 2 node clusters. 3 and 4 node storage switchless clusters can be deployed only using Resource Manager templates.        | HCI  |
|2     | Scale out operations aren't supported with switchless deployments. Any change to the number of nodes after deployment requires a manual configuration.        | HCI  |
|3     | Network switch for storage can be used with any number of nodes from 1 to 16, and a single intent can carry all traffic types.        | HCI  |
|4     | On hyperconverged deployments, the storage intent must share the same ToR switch pair as management and compute. A dedicated storage-only switch pair isn't supported and can cause a cluster split-brain situation.        | HCI  |
|5     | Disaggregated (DA) uses an external SAN—Fiber Channel (FC) or IP-based SAN (for example, iSCSI or PowerFlex SDC)—to connect the cluster to external storage. There's no Storage Spaces Direct, and compute and storage scale independently up to 64 nodes.        | DA  |
|6     | iSCSI deployments use this pattern:  a 6-port dedicated-path (dedicated iSCSI ports, optional backup network).        | DA  |
|7     | iSCSI requires per-target /32 host static routes and MPIO so that storage traffic stays on the storage adapter. iSCSI runs over TCP, so PFC and lossless Ethernet aren't required.        | DA  |

## Decision 6: Determine network adapter ports and configuration

Network adapters are qualified by the network traffic type (management, compute, and storage) they're used with. Work with your OEM to determine which adapters are available and qualified for each intent (management, compute, and storage) on your hardware.

Before purchasing a machine for Azure Local, you must have at least two adapters that are qualified for management, compute, and storage, as all three traffic types are required on Azure Local. Cloud deployment relies on Network ATC to configure the network adapters for the appropriate traffic types, so it's important to use supported network adapters.

Once you install the operating system, and before configuring networking on your nodes, you must ensure that your network adapters have the latest driver provided by your OEM or network interface vendor. Important capabilities of the network adapters might not surface when using the default Microsoft drivers.

The default values used by Network ATC are documented in [Cluster network settings](/windows-server/networking/network-atc/network-atc#cluster-network-settings). We recommend that you use the default values. With that said, the following options can be overridden using the Azure portal or Resource Manager templates if needed:

- **Storage VLANs**: Set this value to the required VLANs for storage.
- **Jumbo Packets**: Defines the size of the jumbo packets. We recommend a maximum transmission unit (MTU) of 9216 bytes for RDMA storage traffic. Configure the same MTU on the physical switches. For external SAN (hybrid or disaggregated) storage fabrics, the required jumbo-frame MTU depends on the storage vendor and may differ from the S2D value—for example, 9216 bytes for RDMA storage fabrics and a vendor-specified value (such as 9014 bytes) for IP-based block storage networks. Use the MTU specified by your storage vendor and configure the same value end to end across hosts and switches.
- **Network Direct**: Set this value to `false` if you want to disable RDMA for your network adapters.
- **Network Direct Technology**: Set this value to `RoCEv2` or `iWarp`.
- **Traffic Priorities Datacenter Bridging (DCB)**: Set the priorities that fit your requirements. We highly recommend that you use the default DCB values, as these are validated by Microsoft and customers.

### Hyperconverged (HCI)

Hyperconverged deployments use 2, 4, 6, or 8 network adapter ports per node, depending on how you group traffic into intents in [Decision 7](#decision-7-determine-network-traffic-intents). Each port's speed and RDMA capability must match the traffic it carries:

- **2 ports**: A single *Group all traffic* intent. SET teams the first two physical adapters (for example, pNIC01 and pNIC02). All traffic types share the same ports. Requires a minimum of 10 Gb; 25 GbE or higher is recommended.
- **4 ports**: A *Management and compute* intent on Port1 and Port2 (SET) plus a dedicated *Storage* intent on Port3 and Port4. The storage intent doesn't use SET; it uses SMB Multichannel for resiliency and bandwidth aggregation.
- **6 ports**: Separate *Management* (Port1 and Port2, SET), *Compute* (Port3 and Port4, SET), and *Storage* (Port5 and Port6, SMB Multichannel) intents.
- **8 ports**: Add a second compute or backup intent on the remaining ports for additional traffic separation.

For switched patterns, the ToR switches must meet the [Physical switch requirements](#physical-switch-requirements). For switchless patterns, storage adapters form a direct node-to-node mesh, so no storage switches are needed; each storage subnet requires a unique VLAN, and the subnet count grows as described in [Decision 5](#decision-5-determine-storage-connectivity).

### Disaggregated (DA)

Disaggregated deployments use an Ethernet port layout that depends on the SAN type. Define the design by the number of network ports and the role of each port, not by the physical adapter form factor. In all cases, two network ports carry the *Management and compute* intent (a SET team managed by Network ATC), and a separate pair of network ports carry the cluster networks—cluster heartbeat, Cluster Shared Volume (CSV), and Live Migration over SMB Multichannel—as standalone ports that Network ATC doesn't manage. How these ports are distributed across physical adapters is an OEM choice: they can come from a single multi-port adapter (such as a quad-port OCP), from two separate adapters (for example, an onboard OCP plus an add-in adapter), or from two onboard adapters. The default cluster VLANs are 1711 and 1712. Each standalone cluster and storage port carries a single VLAN, so you can set that VLAN as the access (native) VLAN on the ToR port and leave the host interface untagged—see [Cluster and storage QoS](#cluster-and-storage-qos). For the full switch, cabling, and port layout for each SAN type, see the [disaggregated network reference patterns](../plan/choose-network-pattern-disaggregated.md).

#### Fiber Channel (FC)

FC deployments use a 4-port or 6-port Ethernet layout per node. Each server also uses dual-port FC host bus adapters (HBAs) (Port A to FC switch A, Port B to FC switch B) for SAN connectivity, separate from the Ethernet network ports:

- **4 ports**: *Management and compute* on network ports 1 and 2 (SET), and cluster networks on standalone network ports 3 and 4.
- **6 ports (guest backup)**: Identical to the 4-port layout, plus a *Guest backup* compute intent on network ports 5 and 6 (SET) for guest backup traffic. For more information, see [Decision 9](#decision-9-determine-backup-network).

#### iSCSI

iSCSI deployments use this validated pattern. Storage adapters must be at least 10 GbE (25 GbE or higher for high-throughput workloads):

- **6-port dedicated-path**: Two network ports for *Management and compute* (SET), two standalone network ports for the cluster networks (VLANs 1711 and 1712), and two more standalone network ports for dedicated iSCSI path A (VLAN 300) and path B (VLAN 400). This pattern supports an optional backup network, as described in [Decision 9](#decision-9-determine-backup-network).

#### Cluster and storage QoS

All disaggregated storage and cluster traffic runs over TCP: SMB Multichannel for the cluster networks (CSV, Live Migration, and heartbeat), and iSCSI over TCP for storage. TCP manages congestion and recovers from loss through its own retransmission and congestion control, so this design doesn't need lossless Ethernet or host-side traffic shaping. Don't configure the following on the cluster and storage ports:

- **Priority Flow Control (PFC) or lossless queues.** PFC provides losslessness for RDMA/RoCE, which disaggregated deployments don't use. On a TCP fabric, PFC adds operational risk—pause propagation, head-of-line blocking, and victim flows—with no benefit.
- **Host-side Data Center Bridging (DCB) or Enhanced Transmission Selection (ETS).** Host ETS and 802.1p class of service (CoS) are hop-by-hop, Layer 2 mechanisms. They influence only the host-to-leaf link, and their bandwidth guarantees don't extend across the fabric.

> [!IMPORTANT]
> In a multi-rack leaf-spine deployment, cross-rack cluster and storage traffic is routed at Layer 3 over the VXLAN EVPN overlay. The 802.1p CoS that a host sets lives only inside the 802.1Q VLAN tag, so it's discarded when a leaf routes and encapsulates the frame—the spine switches schedule on the outer packet header, not the host's CoS. Host ETS therefore can't protect iSCSI or cluster traffic against spine or incast congestion, and configuring it gives a false sense of protection.

To keep cluster and storage traffic healthy across the fabric:

- **Engineer the fabric for capacity.** Build the leaf-spine fabric with low or no oversubscription, size the spine uplinks for storage bursts, and keep storage and cluster traffic on dedicated ports where the port layout allows. Combined with TCP congestion control, this is the primary protection for cross-rack traffic.

> [!NOTE]
> On a single-rack disaggregated cluster (Layer 2 on one ToR pair), or on a converged host uplink that carries several traffic types, host ETS still functions on that local link and can keep bulk CSV or Live Migration from starving cluster heartbeat. When you use dedicated ports for the cluster and storage networks—as the multi-rack layouts recommend—there's little to arbitrate on those links, so omitting host ETS has negligible effect. Removing host ETS everywhere is a deliberate simplification for the routed, TCP-based fabric.

Jumbo frames remain worthwhile and are independent of the QoS decision above, because the cluster ports carry CSV and Live Migration over SMB—bulk transfers that benefit from fewer, larger packets. You don't configure them manually: Azure Local applies the jumbo-frame MTU that you specify in the Azure portal or the ARM template during deployment to the host adapters, so there's no need to run adapter commands on the nodes. You do need to configure the same MTU on the physical switch ports yourself, because Azure Local doesn't configure the switches—a common pairing is MTU 9000 on the host and 9216 on the switch.

Because there's no host QoS, the standalone cluster and storage ports don't need to preserve any 802.1p priority, and each of these ports carries only a single VLAN. You can therefore set that VLAN as the **access (native) VLAN** on the ToR port and leave the host interface **untagged**—no VLAN tagging is needed on the hosts:

- **Cluster networks**: set the two cluster ports to the cluster VLANs (for example, 1711 and 1712).
- **iSCSI, 6-port dedicated-path**: set the two dedicated iSCSI ports to their storage VLANs (for example, 300 and 400).


The management and compute ports are separate—they stay on the Network ATC-managed SET team and are trunked if they carry more than one VLAN. Follow your storage vendor guidance for any additional requirements.

### Physical switch requirements

For switched (hyperconverged) and disaggregated deployments, the physical top-of-rack (ToR) switches must support the following capabilities to carry cluster traffic reliably:

- **Priority Flow Control (PFC)** for lossless RDMA traffic (IEEE 802.1Qbb).
- **Enhanced Transmission Selection (ETS)** for bandwidth allocation across traffic classes (IEEE 802.1Qaz).
- **Jumbo frames** with an MTU of at least 9216 bytes.
- **Explicit Congestion Notification (ECN)** for RoCEv2 deployments.
- **Multi-Chassis Link Aggregation (MLAG)** for redundant ToR pairs.

> [!NOTE]
> The PFC, ETS, and ECN capabilities apply to switched hyperconverged (RDMA) deployments. Disaggregated deployments carry all storage and cluster traffic over TCP, so they don't require PFC, lossless Ethernet, or host and switch ETS. Rely on adequate fabric capacity and TCP congestion control. The disaggregated fabric still needs jumbo frames, MLAG or virtual port channel (vPC), and MPIO-compatible VLAN support with static routing for iSCSI.

Here are the summarized considerations for the network adapter configuration decision:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | Use the default Network ATC configurations as much as possible.        | Both  |
|2     | Physical switches must be configured according to the network adapter configuration. See [Physical network requirements for Azure Local](../concepts/physical-network-requirements.md#network-switches-for-azure-local).        | Both  |
|3     | Work with your OEM to determine which network adapters are supported and qualified for each intent on Azure Local. The supported list is more constrained than the Windows Server Catalog.        | Both  |
|4     | At least 10 Gbps network interfaces are required to support RDMA or iSCSI storage traffic. We recommend 25 GbE or higher.        | Both  |
|5     | When accepting the defaults, Network ATC automatically configures the storage network adapter IPs and VLANs (Storage Auto IP). In some instances, Storage Auto IP isn't supported and you need to declare each storage network adapter IP using Resource Manager templates.        | HCI  |
|6     | Disaggregated storage and cluster traffic runs over TCP, so Priority Flow Control (PFC) and host-side ETS/DCB aren't required. Host ETS only affects the host-to-leaf link and isn't honored across the routed leaf-spine fabric; engineer fabric capacity to protect cross-rack traffic.        | DA  |
|7     | Because disaggregated deployments don't use host QoS, each standalone cluster and storage port carries a single VLAN and can use an access (native) VLAN on the ToR—for example, 1711 and 1712 for the cluster networks and 300 and 400 for dedicated iSCSI—so the host interfaces don't need VLAN tags.        | DA  |

## Decision 7: Determine network traffic intents

For Azure Local, all deployments rely on Network ATC for the host network configuration. The network intents are automatically configured when deploying Azure Local via the Azure portal. To understand more about the network intents and how to troubleshoot them, see [Common network ATC commands](../deploy/network-atc.md#common-network-atc-commands).

This section explains the implications of your design decision for network traffic intents. The options available depend on the architecture, the number of nodes in your cluster, and the storage connectivity type used.

> [!NOTE]
> Network ATC creates SET virtual switches for management and compute traffic. Storage traffic in S2D deployments uses SMB Multichannel and isn't placed behind a SET switch.

### Hyperconverged (HCI)

For hyperconverged deployments, you can select between four options to group your network traffic into one or more intents.

#### Network intent: Group all traffic

Network ATC configures a unique intent that includes management, compute, and storage network traffic. The network adapters assigned to this intent share bandwidth and throughput for all network traffic.

- This option requires a physical switch for storage traffic. If you require a switchless architecture, you can't use this type of intent. The Azure portal automatically filters out this option if you select a switchless configuration for storage connectivity.
- At least two network adapter ports are recommended to ensure high availability.
- At least 10 Gbps network interfaces are required to support RDMA traffic for storage. We recommend 25 GbE or higher.

#### Network intent: Group management and compute traffic

Network ATC configures two intents. The first intent includes management and compute network traffic, and the second intent includes only storage network traffic. Each intent must have a different set of network adapter ports.

You can use this option for both switched and switchless storage connectivity, if:

- At least two network adapter ports are available for each intent to ensure high availability.
- A physical switch is used for RDMA if you use the network switch for storage.
- At least 10 Gbps network interfaces are required to support RDMA traffic for storage.

#### Network intent: Group compute and storage traffic

Network ATC configures two intents. The first intent includes compute and storage network traffic, and the second intent includes only management network traffic. Each intent must use a different set of network adapter ports.

- This option requires a physical switch for storage traffic as the same ports are shared with compute traffic, which require north-south communication. If you require a switchless configuration, you can't use this type of intent. The Azure portal automatically filters out this option if you select a switchless configuration for storage connectivity.
- This option requires a physical switch for RDMA.
- At least two network adapter ports are recommended to ensure high availability.
- At least 10 Gbps network interfaces are recommended for the compute and storage intent to support RDMA traffic.
- Even when the management intent is declared without a compute intent, Network ATC creates a Switch Embedded Teaming (SET) virtual switch to provide high availability to the management network.

#### Network intent: Custom configuration

Define up to three intents using your own configuration as long as at least one of the intents includes management traffic. We recommend that you use this option when you need a second compute intent. Scenarios for this second compute intent requirement include remote storage traffic, VMs backup traffic, or a separate compute intent for distinct types of workloads.

- Use this option for both switched and switchless storage connectivity if the storage intent is different from the other intents.
- Use this option when another compute intent is required or when you want to fully separate the distinct types of traffic over different network adapters.
- Use at least two network adapter ports for each intent to ensure high availability.
- At least 10 Gbps network interfaces are recommended for the compute and storage intent to support RDMA traffic.

### Disaggregated (DA)

For disaggregated deployments, the storage array is reached over Fiber Channel or iSCSI, so there's no RDMA storage intent. Use the following:

- A *Management and compute* intent configured through Network ATC using a SET virtual switch.
- *Cluster networks* (cluster heartbeat, CSV, and Live Migration over SMB Multichannel) that run on standalone network ports outside of Network ATC, as described in [Decision 5](#decision-5-determine-storage-connectivity).
- For iSCSI, the iSCSI paths are standalone ports that Network ATC doesn't manage. They're dedicated in the 6-port pattern.
- An optional *Guest backup* intent when you use the 6-port (FC) or 6-port dedicated-path (iSCSI) layout, as described in [Decision 9](#decision-9-determine-backup-network).

### Supported intent groupings

The following table summarizes which intent groupings are supported for each storage connectivity option:

| Intent grouping | S2D switchless | S2D switched | External SAN (FC or IP-based) |
|-----------------|:--------------:|:------------:|:--------------------------:|
| Group all traffic (management, compute, storage) | ❌ | ✅ | ❌ |
| Group management and compute, separate storage | ✅ | ✅ | ❌ |
| Group compute and storage, separate management | ❌ | ✅ | ❌ |
| Custom configuration (up to three intents) | ✅ | ✅ | ❌ |
| Management and compute, plus cluster networks not managed by Network ATC | ❌ | ❌ | ✅ |

Here are the summarized considerations for the network traffic intents decision:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | Use at least two network adapter ports per intent to ensure high availability.        | Both  |
|2     | Switchless hyperconverged clusters require at least two intents (management and compute, plus storage).        | HCI  |
|3     | The *Group all traffic* and *Group compute and storage* intents require a physical switch for storage and aren't available for switchless clusters.        | HCI  |
|4     | Disaggregated deployments use a management and compute intent, plus cluster networks that run outside of Network ATC.        | DA  |
|5     | For iSCSI, the iSCSI paths are standalone and dedicated ports outside Network ATC       | DA  |

## Decision 8: Determine management IPs and infrastructure network

In this decision, you define the infrastructure subnet address space, how these addresses are assigned to your cluster, and whether there's any VLAN ID requirement for the nodes. This decision applies to both the hyperconverged and disaggregated architectures.

The following infrastructure subnet components must be planned and defined before you start deployment so you can anticipate any routing, firewall, or subnet requirements.

### Reserved IP ranges to avoid

When you deploy Azure Local, the platform reserves two internal Kubernetes CIDRs—`10.96.0.0/12` for Kubernetes services and `10.244.0.0/16` for pod networking. The Azure Resource Bridge (ARB) control plane runs on this internal Kubernetes platform, and any Azure Kubernetes Service (AKS) clusters you deploy use the same ranges. If any Azure Local configuration overlaps these ranges, deployment might fail or experience connectivity issues that are difficult to troubleshoot.

Because `10.96.0.0/12` is the platform's internal Kubernetes Service network, no Azure Local infrastructure IP—and none of the core infrastructure services the cluster must reach, such as DNS and proxy—can fall within it. From the nodes and the infrastructure VMs, any traffic sent to an address in `10.96.0.0/12` is handled internally and never reaches the real destination. Plan the following so they all sit outside `10.96.0.0/12`:

- The cluster node IPs and the cluster IP.
- The Azure Resource Bridge VM and the other infrastructure VM IPs, along with the management IP pool they're drawn from.
- The DNS servers and the proxy server that the infrastructure uses.

The `10.244.0.0/16` pod range carries the same restriction: any infrastructure IP, node IP, or logical network you place there collides with pod networking.

If you deploy AKS on Azure Local, the same reserved ranges add two more requirements for the AKS workloads:

- **The AKS logical network can't overlap the reserved ranges.** The logical network (LNET) that you deploy AKS clusters into must not overlap `10.96.0.0/12` (Kubernetes services) or `10.244.0.0/16` (pods).
- **AKS can't reach private endpoints inside `10.96.0.0/12`.** Any private endpoint that AKS workloads rely on—such as Azure Container Registry (ACR), Azure Key Vault, or Azure Storage endpoints—must not have an IP within `10.96.0.0/12`. From an AKS control plane VM or worker node, that range *is* the internal Kubernetes Service network, so traffic to any address in it is handled internally and never reaches the real endpoint. If your environment already places private endpoints or other services that AKS must reach in that space, move them out before you deploy AKS.

The service and pod CIDRs can't currently be changed, so plan your network to avoid these ranges rather than expecting them to move. Beyond the Azure Local infrastructure, the endpoints it must reach, and AKS, these ranges don't reserve or restrict the rest of your datacenter address space—only the services the cluster itself connects to need to stay clear of them. For the full AKS address-planning requirements, including multi-rack deployments, see [Plan IP addresses for AKS on Azure Local](/azure/aks/aksarc/aks-hci-ip-address-planning).

#### Reserved ranges to avoid

The following IP ranges are reserved internally by the Kubernetes platform (used by both Arc Resource Bridge and AKS) and must not be used for any Azure Local infrastructure component:

| Reserved range | What it's used for |
|----------------|-------------------|
| `10.96.0.0/12` | Kubernetes internal services (cluster IPs) |
| `10.244.0.0/16` | Kubernetes pod networking |

#### What to check before deployment

Make sure none of the following Azure Local infrastructure IPs fall within the reserved ranges above:

| Check this | Example of a problem |
|------------|---------------------|
| Your node management IPs | Node at `10.244.1.50` conflicts with pod network |
| Your cluster IP | Cluster IP at `10.96.0.5` is unreachable from the nodes |
| The Azure Resource Bridge VM and infrastructure IP pool | Pool starting at `10.100.0.1` falls within `10.96.0.0/12` |
| Your DNS server IPs | DNS at `10.96.1.10` would conflict |
| Your proxy server IP | Proxy server at `10.97.10.25` would conflict |
| Your default gateway | Gateway at `10.96.0.1` would conflict |
| Any logical networks for VMs | VM subnet `10.244.100.0/24` overlaps pod network |

#### Safe IP ranges to use

Here are examples of commonly used private IP ranges that won't conflict:

| Safe range | Notes |
|-----------|-------|
| `192.168.x.x` | Most common for small deployments |
| `172.16.x.x` to `172.31.x.x` | Good for medium-sized networks |
| `10.0.x.x` to `10.95.x.x` | Safe — stays below the reserved `10.96.0.0` boundary |
| `10.112.x.x` and higher | Safe — above the reserved `10.111.255.255` boundary |

#### IP planning references

- [IP address planning requirements for AKS](/azure/aks/aksarc/aks-hci-ip-address-planning)
- [Designated IP ranges for Arc resource bridge](/azure/azure-arc/resource-bridge/network-requirements#designated-ip-ranges-for-arc-resource-bridge)

### Management IP pool

When doing the initial deployment of your Azure Local instance, you must define an IP range of consecutive IPs for infrastructure services deployed by default.

To ensure the range has enough IPs for current and future infrastructure services, you must use a range of at least six consecutive available IP addresses. These addresses are used for the cluster IP, the Azure Resource Bridge VM, and its components.

If you anticipate running other services in the infrastructure network, we recommend that you assign an extra buffer of infrastructure IPs to the pool. It's possible to add other IP pools after deployment for the infrastructure network using PowerShell if the size of the pool you planned originally gets exhausted.

During deployment, environment checker tests ICMP connectivity from the management IP pool addresses to the management IP pool default gateway. Make sure your default gateway allows ICMP traffic from the Azure Local management subnet.

Here are the summarized considerations for the management IP pool:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | The IP range must use consecutive IPs, and all IPs must be available within that range. This IP range can't be changed post deployment.        | Both  |
|2     | The range of IPs must not include the cluster node management IPs but must be on the same subnet as your nodes.        | Both  |
|3     | The default gateway defined for the management IP pool must provide outbound connectivity to the internet.        | Both  |
|4     | The DNS servers must ensure name resolution with Active Directory and the internet.        | Both  |
|5     | The management IPs require outbound internet access.        | Both  |
|6     | Environment checker validates that ICMP traffic responds on the default gateway from the Azure Local management IP pool range.        | Both  |

### Management VLAN ID

We recommend that the management subnet of your Azure Local instance use the default VLAN, which in most cases is declared as VLAN ID 0. However, if your network requirements are to use a specific management VLAN for your infrastructure network, it must be configured on the physical network adapters that you plan to use for management traffic.

If you plan to use two physical network adapters for management, you need to set the VLAN on both adapters. This must be done as part of the bootstrap configuration of your machines, and before they're registered to Azure Arc, to ensure you successfully register the nodes using this VLAN.

To set the VLAN ID on the physical network adapters, use the following PowerShell command. This example configures VLAN ID 44 on physical network adapter `NIC1`:

```powershell
Set-NetAdapter -Name "NIC1" -VlanID 44
```

Once the VLAN ID is set and the IPs of your nodes are configured on the physical network adapters, the orchestrator reads this VLAN ID value from the physical network adapter used for management and stores it, so it can be used for the Azure Resource Bridge VM or any other infrastructure VM required during deployment. It isn't possible to set the management VLAN ID during cloud deployment from the Azure portal as this carries the risk of breaking the connectivity between the nodes and Azure if the physical switch VLANs aren't routed properly.

Plan the management VLAN ID carefully, because it can't be changed after deployment. The management VLAN ID is also inherited by the Azure Resource Bridge VM and the other infrastructure VMs, so it applies to them as well. Changing the infrastructure network VLAN ID post-deployment isn't supported and would break connectivity between the nodes, the infrastructure services, and Azure.

#### Management VLAN ID with a virtual switch

In some scenarios, there's a requirement to create a virtual switch before deployment starts.

> [!NOTE]
> Before you create a virtual switch, make sure to enable the Hyper-V role. For more information, see [Install required Windows role](../deploy/deployment-install-os.md).

If a virtual switch configuration is required and you must use a specific VLAN ID, follow these steps.

1. **Create the virtual switch with the recommended naming convention.**

   Azure Local deployments rely on Network ATC to create and configure the virtual switches and virtual network adapters for management, compute, and storage intents. By default, when Network ATC creates the virtual switch for the intents, it uses a specific name for the virtual switch.

   We recommend naming your virtual switch with the same naming convention. The recommended name for the virtual switches is `ConvergedSwitch($IntentName)`, where `$IntentName` must match the name of the intent typed into the portal during deployment. This string must also match the name of the virtual network adapter used for management, as described in the next step.

   The following example shows how to create the virtual switch with PowerShell using the recommended naming convention with `$IntentName`. The list of network adapter names is a list of the physical network adapters you plan to use for management and compute network traffic:

   ```powershell
   $IntentName = "MgmtCompute"
   New-VMSwitch -Name "ConvergedSwitch($IntentName)" -NetAdapterName "NIC1","NIC2" -EnableEmbeddedTeaming $true -AllowManagementOS $true
   ```

   > [!NOTE]
   > Once an Azure Local instance is deployed, changing the management intent name or the virtual switch name isn't supported. You must use the same intent name and virtual switch name if you need to update or recreate the intent after deployment.

1. **Configure the management virtual network adapter with the required Network ATC naming convention on all nodes.**

   Once the virtual switch and the associated management virtual network adapter are created, make sure that the network adapter name is compliant with Network ATC naming standards.

   Specifically, the name of the virtual network adapter used for management traffic must use the following conventions:

   - Name of the network adapter and the virtual network adapter must use `vManagement($intentname)`.
   - This name is case-sensitive.
   - `$Intentname` can be any string, but must be the same name used for the virtual switch. Make sure you use this same string in the Azure portal when defining the `Mgmt` intent name.

   To update the management virtual network adapter name, use the following commands:

   ```powershell
   $IntentName = "MgmtCompute"

   # Rename VMNetworkAdapter for management because during creation, Hyper-V uses the vSwitch name for the virtual network adapter.
   Rename-VmNetworkAdapter -ManagementOS -Name "ConvergedSwitch(MgmtCompute)" -NewName "vManagement(MgmtCompute)"

   # Rename NetAdapter because during creation, Hyper-V adds the string "vEthernet" to the beginning of the name.
   Rename-NetAdapter -Name "vEthernet (ConvergedSwitch(MgmtCompute))" -NewName "vManagement(MgmtCompute)"
   ```

   > [!NOTE]
   > During deployment validation, all vSwitches on nodes must have corresponding vNICs. If there are vSwitches present but no matching vNICs, the operation fails with the following error:
   >
   > *"Could not complete the operation. 200: There are vSwitches present on the nodes but no vnics, this scenario is not supported."*
   >
   > Ensure the names of the adapters match between the outputs of `Get-NetAdapter` and `Get-VMNetworkAdapter -ManagementOS`. If they don't match, rename the NICs before retrying deployment.

1. **Configure the VLAN ID on the management virtual network adapter on all nodes.**

   Once the virtual switch and the management virtual network adapter are created, you can specify the required VLAN ID for this adapter. Although there are different options to assign a VLAN ID to a virtual network adapter, the only supported option is to use the `Set-VMNetworkAdapterIsolation` command.

   Once the required VLAN ID is configured, you can assign the IP address and gateways to the management virtual network adapter to validate that it has connectivity with other nodes, DNS, Active Directory, and the internet.

   The following example shows how to configure the management virtual network adapter to use VLAN ID `8` instead of the default:

   ```powershell
   Set-VMNetworkAdapterIsolation -ManagementOS -VMNetworkAdapterName "vManagement($IntentName)" -AllowUntaggedTraffic $true -IsolationMode Vlan -DefaultIsolationID "8"
   ```

1. **Reference the physical network adapters for the management intent during deployment.**

   Although the newly created virtual network adapter shows as available when deploying via the Azure portal, it's important to remember that the network configuration is based on Network ATC. This means that when configuring the management, or the management and compute intent, you still need to select the physical network adapters used for that intent.

   > [!NOTE]
   > Don't select the virtual network adapter for the network intent.

   The same logic applies to the Azure Resource Manager templates. You must specify the physical network adapters that you want to use for the network intents and never the virtual network adapters.

Here are the summarized considerations for the VLAN ID:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | VLAN ID must be specified on the physical network adapter for management before registering the machines with Azure Arc.        | Both  |
|2     | Use specific steps when a virtual switch is required before registering the machines to Azure Arc.        | Both  |
|3     | The management VLAN ID is carried over from the host configuration to the infrastructure VMs during deployment.        | Both  |
|4     | There's no VLAN ID input parameter for Azure portal deployment or for Resource Manager template deployment.        | Both  |
|5     | All the adapters that you intend to use for management must have the same VLAN ID configured.        | Both  |
|6     | The management (infrastructure network) VLAN ID can't be changed after deployment. It's also inherited by the Azure Resource Bridge VM and the other infrastructure VMs, so plan it before you register the machines with Azure Arc.        | Both  |

### Node and cluster IP assignment

For an Azure Local instance, you have two options to assign IPs for the machine nodes and for the cluster IP:

- Both the static and Dynamic Host Configuration Protocol (DHCP) protocols are supported.
- Proper node IP assignment is key for cluster lifecycle management. Decide between the static and DHCP options before you register the nodes in Azure Arc.
- Infrastructure VMs and services such as Arc Resource Bridge and Network Controller keep using static IPs from the management IP pool. That implies that even if you decide to use DHCP to assign the IPs to your nodes and your cluster IP, the management IP pool is still required.

The following sections discuss the implications of each option.

#### Static IP assignment

If static IPs are used for the nodes, the management IP pool is used to obtain an available IP and assign it to the cluster IP automatically during deployment.

It's important to use management IPs for the nodes that aren't part of the IP range defined for the management IP pool. Machine node IPs must be on the same subnet as the defined IP range.

We recommend that you assign only one management IP for the default gateway and for the configured DNS servers for all the physical network adapters of the node. This ensures that the IP doesn't change once the management network intent is created. This also ensures that the nodes keep their outbound connectivity during the deployment process, including during the Azure Arc registration.

To avoid routing issues and to identify which IP is used for outbound connectivity and Arc registration, the Azure portal validates whether there's more than one default gateway configured.

If a virtual switch and a management virtual network adapter were created during the OS configuration, the management IP for the node must be assigned to that virtual network adapter.

#### DHCP IP assignment

If IPs for the nodes are acquired from a DHCP server, a dynamic IP is also used for the cluster IP. Infrastructure VMs and services still require static IPs, which implies that the management IP pool address range must be excluded from the DHCP scope used for the nodes and the cluster IP.

For example, if the management IP range is defined as 192.168.1.20 to 192.168.1.30 for the infrastructure static IPs, the DHCP scope defined for subnet 192.168.1.0/24 must have an exclusion equivalent to the management IP pool to avoid IP conflicts with the infrastructure services. We also recommend that you use DHCP reservations for node IPs.

The process of defining the management IP after creating the management intent involves using the MAC address of the first physical network adapter that is selected for the network intent. This MAC address is then assigned to the virtual network adapter that is created for management purposes. This means that the IP address that the first physical network adapter obtains from the DHCP server is the same IP address that the virtual network adapter uses as the management IP. Therefore, it's important to create a DHCP reservation for the node IP.

The network validation logic used during cloud deployment fails if it detects multiple physical network interfaces that have a default gateway in their configuration. If you need to use DHCP for your host IP assignments, you need to pre-create the SET _(switch embedded teaming)_ virtual switch and the management virtual network adapter as described above, so only the management virtual network adapter acquires an IP address from the DHCP server.

Here are the summarized considerations for the IP addresses:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | Node IPs must be on the same subnet as the defined management IP pool range regardless of whether they're static or dynamic addresses.        | Both  |
|2     | The management IP pool must not include node IPs. Use DHCP exclusions when dynamic IP assignment is used.        | Both  |
|3     | Use DHCP reservations for the nodes as much as possible.        | Both  |
|4     | DHCP addresses are only supported for node IPs and the cluster IP. Infrastructure services use static IPs from the management pool.        | Both  |
|5     | The MAC address from the first physical network adapter is assigned to the management virtual network adapter once the management network intent is created.        | Both  |

### DNS server considerations

Azure Local deployments based on Active Directory require a DNS server that can resolve the on-premises domain and the internet public endpoints. As part of the deployment, it's required to define the same DNS servers for the infrastructure IP address range that is configured on the nodes. The Azure Resource Bridge control plane VM and the AKS control plane use those same DNS servers for name resolution. Once deployment is completed, it isn't supported to change the DNS server IPs, and it isn't possible to update the addresses across the Azure Local platform stack.

The DNS servers used for Azure Local must be external and operational before deployment. It isn't supported to run *all* of the configured DNS servers as virtual machines on the same Azure Local instance that depends on them. Because the cluster nodes, Azure Resource Bridge, and AKS need name resolution during boot and before the workload VMs are running, at least one of the configured DNS servers must run outside the Azure Local instance. A cluster that relies solely on DNS VMs hosted on itself can't resolve names during a full shutdown, restart, or recovery, when those VMs aren't yet available. If you run DNS as VMs on the cluster for local resolution, keep at least one independent external DNS server in the configured list.

Here are the summarized considerations for DNS server addresses:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | DNS servers across all the nodes of the cluster must be the same.        | Both  |
|2     | The infrastructure IP address range DNS servers must be the same used for the nodes.        | Both  |
|3     | The Azure Resource Bridge VM control plane and AKS control plane use the DNS servers configured on the infrastructure IP address range.        | Both  |
|4     | It isn't supported to change the DNS servers after deployment. Make sure you plan your DNS strategy before doing the Azure Local deployment.        | Both  |
|5     | When defining an array of multiple DNS servers in an ARM template for the infrastructure network, make sure each value is within quotes "" and separated by commas, as in the following example.        | Both  |
|6     | It isn't supported to run *all* of the configured DNS servers as virtual machines on the same Azure Local instance. At least one configured DNS server must run outside the cluster so that name resolution works during boot, shutdown, restart, and recovery, when cluster-hosted VMs aren't available.        | Both  |
|7     | All DNS servers configured must resolve on-premises domains required for the infrastructure. Public DNS servers such as 8.8.8.8 aren't supported.        | Both  |
|8     | All DNS servers configured must not overlap with the reserved ARB subnet ranges (10.96.0.0/12 and 10.244.0.0/16).        | Both  |

```json
"dnsServers": [
    "10.250.16.124",
    "10.250.17.232",
    "10.250.18.107"
]
```

## Decision 9: Determine backup network

Decide whether your deployment requires a dedicated backup network for guest (VM) backup traffic. This decision applies to both the hyperconverged and disaggregated architectures.

- **No backup network**: Guest backup traffic shares the existing compute intent. This is sufficient for smaller deployments or where backup traffic volume is low.
- **Enable backup network**: Add a dedicated backup network with two extra network adapter ports per node. A dedicated backup network isolates backup traffic from production compute and storage traffic, which protects workload performance during backup windows.

### Hyperconverged (HCI)

For hyperconverged deployments, add a dedicated backup network as a second compute intent using the *Custom configuration* intent model described in [Decision 7](#decision-7-determine-network-traffic-intents). Assign two extra network adapter ports to the backup intent for high availability.

### Disaggregated (DA)

Backup network support depends on the SAN type and adapter layout you chose in [Decision 6](#decision-6-determine-network-adapter-ports-and-configuration):

- **Fiber Channel**: Use the 6-port layout, which adds a *Guest backup* compute intent on network ports 5 and 6 (SET), in addition to the management and compute intent and the cluster networks.
- **iSCSI 6-port (dedicated-path)**: Supports an optional backup network. When you enable backup, the management & compute ports (network ports 1 and 2 are wrapped in a NetworkATC managed SET switch that hosts the management host vNIC and trunks the tenant backup VLAN. The dedicated cluster and iSCSI ports (network ports 3, 4, 5, and 6) are unaffected. The customer will manually create the Guest Backup vNIC on the host on top of the Network ATC managed virtual switch.


For the Fiber Channel backup and no-backup reference patterns, see [Fiber Channel disaggregated pattern with backup network](../plan/fiber-channel-with-backup-disaggregated-pattern.md) and [Fiber Channel disaggregated pattern without backup network](../plan/fiber-channel-no-backup-disaggregated-pattern.md).

Here are the summarized considerations for the backup network decision:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | On hyperconverged deployments, add the backup network as a second compute intent using the custom configuration intent model or manually create an additional vNIC on top of the Management & Compute virtual switch.        | HCI  |
|2     | On disaggregated deployments, use the 6-port (Fiber Channel) or 6-port dedicated-path (iSCSI) layout to add a guest backup network.        | DA  |

## Decision 10: Determine outbound connectivity

Plan how your Azure Local nodes and infrastructure services reach Azure for registration, billing, and lifecycle management. This decision applies to both architectures and builds on the connectivity mode you chose in [Decision 1](#decision-1-determine-connectivity-mode). Azure Local supports five outbound connectivity topologies: four public-path variants and one fully private path.

| # | Topology | Enterprise proxy | Arc gateway | Summary |
|---|----------|------------------|-------------|---------|
| 1 | Direct outbound | Not configured | Not configured | Nodes reach Azure directly over the internet. Requires more than 100 FQDNs on the perimeter firewall. Best for labs or small isolated environments. |
| 2 | Enterprise proxy | Configured | Not configured | All host HTTP/HTTPS is routed through the corporate proxy. Still requires more than 100 FQDNs allowed and SSL inspection disabled for Azure Local endpoints. |
| 3 | Arc gateway | Not configured | Configured | Arc gateway tunnels supported HTTPS traffic to Azure, leaving fewer than 30 endpoints on the firewall allowlist. |
| 4 | Enterprise proxy and Arc gateway | Configured | Configured | Recommended for new production deployments. Centralized proxy policy plus a minimal allowlist. |
| 5 | Private path | Configured (Azure Firewall Explicit Proxy) | Configured | Nodes connect to Azure over Azure ExpressRoute or a site-to-site VPN. The proxy is always Azure Firewall Explicit Proxy, and Arc gateway is required. |

For air-gapped environments, use Azure Local disconnected operations, which provides a local Autonomous Cloud endpoint instead of public Azure endpoints. For more information, see [Decision 1](#decision-1-determine-connectivity-mode).

> [!IMPORTANT]
> Deploying the Azure Local *infrastructure* registration over a fully private path (Azure ExpressRoute or site-to-site VPN) isn't currently supported. Use a public-path topology for deployment. You can still use private connectivity for workloads and private endpoints.

### Azure Arc gateway

The Azure Arc gateway reduces the number of public endpoints required to deploy and operate Azure Local from more than 100 to fewer than 30. An Arc-gateway-enabled deployment relies on four components:

- **Arc agent**: Runs on every node and connects it to the Azure Arc control plane.
- **Arc proxy**: A local forward proxy service that is part of the Arc agentry and runs on every node. When Arc gateway is enabled on Azure Local, the Arc proxy redirects supported HTTPS traffic through the Arc gateway tunnel. The nodes reach their own Arc proxy locally on `localhost:40343`, while the Azure Resource Bridge VM and the AKS control plane and worker VMs reach it through the cluster IP on port 40343.
- **Cluster IP**: A single forwarder used by Azure Resource Bridge and AKS. It floats across nodes for high availability, so the redirected Azure Resource Bridge VM and AKS VM HTTPS traffic always flows through the Arc proxy on the node that owns the cluster IP at that moment. When you troubleshoot this traffic, analyze the Arc proxy logs on the node that currently owns the cluster IP, not on the other nodes.
- **Arc gateway resource**: The Azure-managed entry point, addressed as `<gatewayId>.gw.arc.azure.com`.

When Arc gateway is enabled, each component routes its outbound traffic through a specific proxy. Node OS HTTPS traffic uses the node's local Arc proxy (`http://localhost:40343`), while the Azure Resource Bridge VM and the AKS control plane and worker VMs use the cluster IP on port 40343. Arc-enabled Azure Local VMs use their own dedicated Arc proxy. In every case, the Arc proxy forwards only supported Microsoft-managed HTTPS endpoints through the Arc gateway tunnel.

HTTPS traffic to endpoints that the Arc gateway doesn't permit—including third-party and OEM services such as hardware-vendor update services or other agents installed on your nodes—is redirected to your enterprise proxy or firewall. You must allow those endpoints explicitly based on your requirements. HTTP traffic is never tunneled and always goes to the enterprise proxy or firewall.

For more information about how the Arc gateway works and how to create the gateway resource, see [About Azure Arc gateway for Azure Local](../deploy/deployment-azure-arc-gateway-overview.md). To register your machines through the gateway, see [Register Azure Local machines with Azure Arc using Arc gateway](../deploy/deployment-with-azure-arc-gateway.md). For a detailed breakdown of each outbound traffic flow (node OS, Azure Resource Bridge, AKS, and Azure Local VMs) with diagrams, see [Arc gateway outbound connectivity deep dive](https://github.com/Azure/AzureLocal-Supportability/blob/main/TSG/Networking/Arc-Gateway-Outbound-Connectivity/DeepDive-ArcGateway-Outbound-Traffic.md).

Complete these prerequisites before you register your nodes:

- Create the Arc gateway resource in the subscription where you plan to deploy Azure Local.
- Open your firewall to the Arc gateway endpoints and disable SSL inspection on them.
- If you use an enterprise proxy, add the required subnets, node names, cluster name, and any private endpoint FQDNs to the proxy bypass list before Arc registration.

Even with Arc gateway, approximately 23 FQDNs remain on your perimeter firewall or proxy allowlist, including:

- Two bootstrap and six Arc registration FQDNs.
- The Arc gateway endpoint (`<gatewayId>.gw.arc.azure.com`).
- Certificate revocation list (CRL) endpoints over HTTP only, because the Arc gateway handles HTTPS only.
- Azure Key Vault (`vault.azure.net`) and the witness storage account (`blob.core.windows.net`) for deployment.

For the full, current endpoint list, see [Firewall requirements](../concepts/firewall-requirements.md).

> [!NOTE]
> When AKS is deployed, the AKS subnet requires line of sight to the infrastructure subnet on TCP ports 22, 6443, 40343, 55000, and 65000.

Here are the summarized considerations for Arc gateway:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | Plan the proxy bypass list before deployment. Include supported private link endpoints and any node names and IPs that you plan to add when scaling out.        | Both  |
|2     | SSL inspection isn't supported for Arc gateway endpoints. When using a terminating proxy, you can't skip TLS inspection for the Arc gateway endpoint, because the proxy can't intercept the nested TLS tunnel.        | Both  |
|3     | Don't configure the proxy manually. The Arc registration script automates proxy configuration for WinINET, WinHTTP, and environment variables.        | Both  |
|4     | You can't update the proxy bypass list after deployment to add new endpoints or machines.        | Both  |
|5     | Use the same proxy configuration across all Azure Local machines.        | Both  |
|6     | HTTPS traffic to endpoints the Arc gateway doesn't permit, including third-party and OEM services, is redirected to your enterprise proxy or firewall. Allow those endpoints explicitly.        | Both  |
|7     | Redirected Azure Resource Bridge VM and AKS VM traffic always flows through the node that owns the cluster IP. Analyze Arc proxy logs for this traffic on the node that currently owns the cluster IP.        | Both  |

### Proxy requirements

A proxy is most likely required to reach the internet from your on-premises infrastructure. Since Azure Local 2506, you no longer configure the host proxy manually. Instead, you provide the enterprise proxy server and the proxy bypass list once during Arc registration, and the Arc registration script automatically configures the proxy across all three operating system components—WinINET, WinHTTP, and environment variables—on every node. You can supply the proxy details either through the Arc registration script or interactively through the Configurator app. For more information, see [Configure proxy settings](../manage/configure-proxy-settings-23h2.md).

The same proxy configuration is automatically carried over to the Arc Resource Bridge VM and AKS during deployment, so those components have internet access without extra manual steps. When you use the Arc gateway, the registration script sets the host HTTPS proxy to the local Arc proxy (`http://localhost:40343`) and routes HTTP traffic to the enterprise proxy, and it appends the required internal endpoints to each component's bypass list automatically.

Only non-authenticated proxies are supported. Proxy Auto-Configuration (PAC) files and proxy endpoints that use a `.local` domain (for example, `http://proxy.contoso.local`) aren't supported.

When you define the proxy bypass list, follow these formatting rules so that internal traffic bypasses the proxy correctly:

- Include, at a minimum, the IP address of each Azure Local machine, the cluster IP, and the infrastructure network IPs. Arc Resource Bridge, AKS, and future infrastructure services use these IPs. Alternatively, you can bypass the entire infrastructure subnet.
- Include the NetBIOS name of each machine and of the cluster.
- For internal domains, you can use a domain name with a leading asterisk (`*`) wildcard, such as `*.contoso.com`. For subnets, use wildcard notation such as `192.168.1.*`.
- Separate entries with commas. CIDR notation to bypass subnets isn't supported.

Here are the summarized considerations for proxy configuration:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | Since Azure Local 2506, you don't configure the host proxy manually. The Arc registration script configures it automatically across WinINET, WinHTTP, and environment variables.        | Both  |
|2     | Provide the enterprise proxy server and the proxy bypass list once during Arc registration, before the nodes are registered with Azure Arc.        | Both  |
|3     | You can supply the proxy details through the Arc registration script or interactively through the Configurator app.        | Both  |
|4     | The Arc registration script carries the proxy configuration over to the Arc Resource Bridge VM and AKS during deployment.        | Both  |
|5     | Only non-authenticated proxies are supported. PAC files and proxy endpoints with a `.local` domain aren't supported.        | Both  |
|6     | The proxy server configured for Azure Local nodes must not overlap with the reserved ARB subnet ranges (10.96.0.0/12 and 10.244.0.0/16).        | Both  |
|7     | In the proxy bypass list, include each machine IP, the cluster IP, and the infrastructure subnet, plus the machine and cluster NetBIOS names. Separate entries with commas and use wildcard notation (for example, `192.168.1.*`), because CIDR notation isn't supported.        | Both  |

### Private endpoints

You can use Azure Private Link private endpoints to keep traffic to supported Azure platform-as-a-service (PaaS) services on a private network path over Azure ExpressRoute or a site-to-site VPN. Private endpoints are supported across all five outbound topologies for services such as Azure Storage (Blob), Azure SQL, Azure Key Vault, Azure Container Registry (ACR), and Azure Site Recovery. For more information about the supported scenarios and their per-scenario configuration, see [About Azure private endpoints on Azure Local](../deploy/about-private-endpoints.md).

> [!IMPORTANT]
> Azure Arc Private Link isn't supported for Azure Local infrastructure (nodes and Azure Resource Bridge), Azure Local VMs, or AKS. Arc registration must use the public Arc endpoints. Your infrastructure DNS must resolve Arc FQDNs (for example, `gbl.his.arc.azure.com`) to public IPs. If your corporate DNS returns private IPs for these FQDNs, use a separate DNS server for Azure Local. If DNS returns a private IP (for example, in `10.x`, `172.16.x`, or `192.168.x`) for an Arc endpoint on a host, the configuration is unsupported.

When you plan private endpoints, follow these rules:

- **Avoid reserved-range overlap**: Private endpoint IPs must not fall within `10.244.0.0/16` (AKS pods) or `10.96.0.0/12` (Kubernetes services). An overlapping endpoint is treated as internal cluster traffic and never leaves the virtual network. For example, an endpoint at `10.244.1.4` fails, while `10.245.0.5` routes correctly.
- **Keep critical services public during deployment**: Keep public access enabled on Azure Key Vault and the witness storage account until deployment completes, then restrict them to private networks.
- **Add private endpoints to the bypass list**: When you use an enterprise proxy, add private endpoint FQDNs to the proxy bypass list during Arc registration. For AKS workloads, add them to the environment-variable bypass list after Arc registration.
- **Don't use wildcards**: Wildcard entries such as `*.azurecr.io` aren't supported on the bypass list. Add the exact registry FQDNs before deployment, because they're used by Azure Resource Bridge and AKS for image pulls.
- **Route private endpoints outside Arc gateway**: Private endpoints aren't routed through the Arc gateway. For services such as Azure Site Recovery, either disable SSL inspection on the enterprise proxy or, preferably, add the endpoint to the proxy bypass list.

The following table provides per-service private endpoint guidance:

| Service | FQDN | Guidance |
|---------|------|----------|
| Azure Key Vault | `vault.azure.net` | Required for deployment (secrets configuration). Keep public access enabled during deployment; restrict afterward. |
| Azure Storage | `blob.core.windows.net` | Required for two-node deployments (cloud witness). Keep public access enabled until setup completes. |
| Azure Container Registry | `azurecr.io` | Crucial for AKS image pulls. No wildcards on the bypass list; add specific registry FQDNs before deployment. |
| Azure Site Recovery | `privatelink.siterecovery.*` | Not allowed through Arc gateway. Disable SSL inspection on the proxy or add the endpoint to the proxy bypass list. |

### Firewall requirements

You're currently required to open several internet endpoints in your firewalls to ensure that Azure Local and its components can successfully connect to them. For a detailed list of the required endpoints, see [Firewall requirements](../concepts/firewall-requirements.md).

Firewall configuration must be done prior to registering the nodes in Azure Arc. You can use the standalone version of the environment checker to validate that your firewalls aren't blocking traffic sent to these endpoints. For more information, see [Azure Local Environment Checker](../manage/use-environment-checker.md) to assess deployment readiness for Azure Local.

Here are the summarized considerations for firewall:

|#  | Consideration  | Applies to  |
|------|---------|---------|
|1     | Firewall configuration must be done before registering the nodes in Azure Arc.        | Both  |
|2     | Environment Checker in standalone mode can be used to validate the firewall configuration.        | Both  |

## Decision 11: Determine software defined networking (SDN)

Software Defined Networking (SDN) is an optional workload-network layer that you apply after the host network (decisions 1 through 10) is in place. On Azure Local, SDN is *enabled by Azure Arc* and is scoped to two capabilities: SDN logical networks (LNETs) that provide software-defined network segments for your workloads and are backed by VLANs on the physical fabric, and microsegmentation through Network Security Groups (NSGs). Decide whether your workloads need programmable network segmentation and distributed security policy, and confirm that your architecture supports the SDN model you need.

> [!IMPORTANT]
> Arc-managed SDN on Azure Local doesn't support Virtual Networks (VNETs), Software Load Balancer (SLB) or RAS/GRE gateways. Only LNETs and NSGs are supported. If your workloads require VNETs, SLB, GRE, or the full Microsoft SDN gateway stack, Azure Local isn't the recommended platform. Use a Windows Server SDN deployment instead, where the complete Network Controller stack, including VNETs, SLB and gateways, is supported.

### Hyperconverged (HCI)

Hyperconverged deployments support Microsoft SDN enabled by Azure Arc for 1 to 16 nodes:

- The SDN control plane provides LNETs and NSGs only. Enabling it turns on the Azure Virtual Filtering extension on the workload virtual switch.
- LNETs are backed by VLANs on the fabric, so configure and trunk the corresponding VLANs on the ToR switches for each logical network.
- The Network Controller runs as a set of cluster services on the Azure Local instance, not as separate infrastructure virtual machines.

SDN is supported only on the following Network ATC intent patterns from [Decision 7](#decision-7-determine-network-traffic-intents):

| Intent pattern | Description | SDN supported |
|----------------|-------------|:-------------:|
| Group all traffic | A single intent that carries management, compute, and storage. Supported only with switched storage. | ✅ |
| Group management and compute, with a separate storage intent | One intent for management and compute, and a second intent dedicated to storage. | ✅ |
| Group compute and storage, with a separate management intent | Compute and storage share an intent, and management uses a separate intent. | ❌ |
| Custom configuration | Any custom grouping that separates compute from management across intents. | ❌ |

### Disaggregated (DA)

Disaggregated deployments don't use the Microsoft SDN Network Controller. SDN logical networks are provisioned on the external leaf-spine fabric using a VXLAN EVPN overlay, consistent with the multi-rack topology in [Decision 3](#decision-3-determine-cluster-topology):

- Design the fabric VRF and overlay to carry the required logical networks.
- AKS logical networks need Layer 3 reachability to the management logical network.
- Single-rack disaggregated clusters that don't need SDN at scale can stay on the simpler two-switch topology.

For more information about the VRF and VXLAN overlay design on the leaf-spine fabric, see [Network reference patterns overview for disaggregated deployments](../plan/network-patterns-overview-disaggregated.md).

Here are the summarized considerations for the SDN decision:

|#  | Consideration  | Applies to  |
|---------|---------|---------|
|1     | SDN is optional and layered on top of the host network after deployment. Decide whether workloads need SDN logical networks (LNETs) or microsegmentation (NSGs).        | Both  |
|2     | Arc-managed SDN on Azure Local supports LNETs and NSGs only. VNETs, SLB and RAS/GRE gateways aren't supported.        | HCI  |
|3     | Unmanaged virtual machines running on Azure Local, using SDN managed by on-premises tools, cannot be hydrated as Azure Local virtual machines.  | HCI |
|4     | LNETs are backed by VLANs on the fabric. Configure and trunk the corresponding VLANs on the physical switches for each logical network.        | HCI  |
|5     | If workloads require VNETs, SLB, GRE, or the full Microsoft SDN gateway stack, use a Windows Server SDN deployment instead of Azure Local.        | HCI  |
|6     | Disaggregated (DA) uses external fabric-based SDN (VXLAN EVPN) on the leaf-spine fabric. The Microsoft SDN Network Controller isn't used.        | DA  |

## Next steps

- [About Azure Local deployment](../deploy/deployment-introduction.md).
