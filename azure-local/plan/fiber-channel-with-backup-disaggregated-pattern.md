---
title: Fiber Channel disaggregated pattern with backup network
description: Plan to deploy an Azure Local disaggregated cluster using Fiber Channel SAN with a dedicated backup network.
ms.topic: how-to
author: alkohli
ms.author: cedward
ms.reviewer: alkohli
ms.service: azure-local
ms.date: 04/14/2026
ms.subservice: hyperconverged
---

# Disaggregated Fiber Channel pattern with backup network for Azure Local

This article describes the network reference pattern for disaggregated Azure Local clusters that use Fiber Channel (FC) Storage Area Network (SAN) external storage **with** a dedicated backup network for virtual machine backup traffic. Cluster sizes can range from a single node up to 64 nodes across multiple racks.

For an overview of the leaf-spine fabric architecture, traffic flow, and key concepts such as Virtual Routing and Forwarding (VRF), Virtual Extensible LAN (VXLAN), and the role of compute leaf switches vs. service leaf switches, see [Network reference patterns overview for disaggregated deployments](network-patterns-overview-disaggregated.md).

## When to use this pattern

Use this pattern when your deployment meets the following criteria:

- Storage is provided by an external Fiber Channel (FC) SAN, separate from the Ethernet network.
- There **is a requirement** for a dedicated in-guest backup network for virtual machine backup traffic.
- The cluster spans one or more racks with up to 64 nodes.

If your deployment does **not** require a dedicated backup network, see the [Fiber Channel pattern without backup network](fiber-channel-no-backup-disaggregated-pattern.md) instead.

## Architecture overview

This pattern uses a leaf-spine (Clos) topology with the following components:

- **Leaf switches** (Top of Rack) in each rack for server connectivity.
- **Spine switches** for cross-rack transit.
- **Service leaf switches** for data center core peering, route leaking, and service appliance integration.
- **Fiber Channel switches** for storage fabric connectivity (separate from the Ethernet fabric).

:::image type="content" source="media/plan-deployment/disaggregated-rack-layout-overview.svg" alt-text="Diagram showing Azure Local disaggregated rack layout with 64 nodes across four racks." lightbox="media/plan-deployment/disaggregated-rack-layout-overview.svg":::

For detailed information about how the underlay, overlay, and Virtual Routing and Forwarding (VRF) segmentation work together, see [How the fabric works](network-patterns-overview-disaggregated.md#how-the-fabric-works).

## VLAN to VXLAN Network Identifier (VNI) mapping

All VXLAN Network Identifiers (VNIs) are placed inside the cluster Virtual Routing and Forwarding (VRF) to maintain traffic isolation. Each VLAN maps to a unique VNI, and this mapping is consistent across all racks. The following table shows an example configuration for disaggregated deployments spanning multiple racks.

| VLAN | Name | VNI | Purpose |
|---|---|---|---|
| 7 | Azure Local infrastructure subnet | 10007 | VLAN configured in access mode on the leaf for Azure Local management. |
| 1711 | Cluster subnet 1 | 11711 | VLAN configured in access mode on the leaf for Cluster Shared Volume (CSV) and live migration traffic. |
| 1712 | Cluster subnet 2 | 11712 | VLAN configured in access mode on the leaf for Cluster Shared Volume (CSV) and live migration traffic. |
| 300 | Backup subnet | 10300 | VLAN configured in trunk mode on the leaf for dedicated backup network traffic. |
| 100 | Tenant 1 | 10100 | VLAN configured in trunk mode on the leaf for Tenant 1 logical network (LNET) virtual machine traffic. |
| 200 | Tenant 2 | 10200 | VLAN configured in trunk mode on the leaf for Tenant 2 logical network (LNET) virtual machine traffic. |

## Leaf and spine fabric requirements

For the full list of switch capabilities required for leaf-spine Clos deployments, including underlay, overlay, segmentation, Quality of Service (QoS), high availability, and scale requirements, see [Leaf and spine fabric requirements](network-patterns-overview-disaggregated.md#leaf-and-spine-fabric-requirements).

## Host NIC configuration

Each server node connects to the network through six network adapter ports. Each server has a dual-port motherboard Open Compute Project (OCP) network adapter and **two** dual-port Peripheral Component Interconnect Express (PCIe) network adapters.

In this pattern:

- The **OCP dual-port adapter** is used for the management and compute intent.
- **PCIe adapter 1** (dual-port) is used for the cluster networks.
- **PCIe adapter 2** (dual-port) is used for the dedicated backup compute intent.

### Baseboard Management Controller (BMC) network adapter

Each server also has a Baseboard Management Controller (BMC) network port for out-of-band management. BMC traffic does **not** go through the leaf switches. BMC switches connect to the service leaf pair, keeping out-of-band management on a dedicated path through the fabric. This design ensures that a leaf failure doesn't affect your ability to remotely manage servers, and BMC traffic is isolated from compute and storage workloads. BMC devices can be accessed via a Layer 3 network, and access can be controlled through firewall services.

### Port allocation per leaf switch

The following table shows the host network port allocation per leaf physical switch. Each rack has 16 nodes:

| Port range | Function | Leaf A VLANs | Leaf B VLANs | Notes |
|---|---|---|---|---|
| 1-16 | Management and compute OCP ports | VLAN 7 for management. VLANs 100 and 200 for tenants. | VLAN 7 for management. VLANs 100 and 200 for tenants. | Native VLAN 7 in access mode. VLANs 100 and 200 for tenants in trunk mode. |
| 17-32 | Cluster network PCIe ports | VLAN 1711 for cluster network 1. | VLAN 1712 for cluster network 2. | PCIe adapter 1 port 1 for cluster network 1. PCIe adapter 1 port 2 for cluster network 2. Both VLANs in access mode. |
| 33-48 | Backup compute PCIe ports | VLAN 300 for backup network. | VLAN 300 for backup network. | PCIe adapter 2 ports for dedicated backup compute intent. VLAN 300 in trunk mode. |
| 49 | Internal BGP (iBGP) peering between leaf switches | N/A | N/A | Layer 3 routing. |
| 50 | Reserved | N/A | N/A | N/A |
| 51-52 | External BGP (eBGP) uplinks to spine switches | N/A | N/A | Layer 3 routing. |
| 53-56 | Reserved | N/A | N/A | N/A |

## Network ATC intents

In disaggregated deployments, Network ATC manages two intents: the management and compute intent, and the backup compute intent. The cluster networks use standalone Peripheral Component Interconnect Express (PCIe) ports (not managed by Network ATC) to maximize Server Message Block (SMB) Multichannel for Cluster Shared Volume (CSV) and live migration traffic without requiring a storage intent.

- **Management and compute intent** — Switch Embedded Teaming (SET) switch with the management virtual network interface (OCP adapter).
- **Backup compute intent** — Switch Embedded Teaming (SET) switch dedicated to backup network traffic (PCIe adapter 2).

> [!NOTE]
> In disaggregated deployments, the cluster networks use standalone network ports and are not managed by any Network ATC intent. The configuration of these cluster networks is done automatically once the subnets and VLANs information are provided by the user, either through the Azure portal or via ARM template.

- **Cluster network 1** — Standalone network adapter (PCIe adapter 1, port 1).
- **Cluster network 2** — Standalone network adapter (PCIe adapter 1, port 2).

## Quality of Service (QoS) settings

Because all traffic — Cluster Shared Volume (CSV), live migration, and cluster heartbeat — runs over TCP, there is no requirement for lossless Ethernet. Priority Flow Control (PFC) is disabled on all priorities with no pause frames.

Traffic is classified using 802.1p Class of Service (CoS) tags, and each class is assigned to a dedicated queue with explicit Enhanced Transmission Selection (ETS) bandwidth reservations enforced through Weighted Round-Robin (WRR) scheduling:

- **CSV/Live Migration (Priority 3)** receives a 20% reservation to ensure adequate throughput during VM migrations.
- **Cluster Heartbeat (Priority 7)** reserves 1% or 2% — sufficient for lightweight keepalive traffic.
- **Default traffic (Priority 0)** absorbs the remaining 79% or 78% of link bandwidth.

Under normal conditions, all classes can burst to full line rate. The bandwidth guarantees only apply during congestion.

> [!NOTE]
> In a Fiber Channel (FC) SAN configuration, storage traffic runs entirely on the Fiber Channel fabric, separate from the Ethernet network. No storage Quality of Service (QoS) policies are needed on the Ethernet switches. Backup traffic flows over the dedicated backup compute intent and does not share bandwidth with management or cluster traffic.

| Priority (802.1p) | Description | PFC / Pause Frame | ETS bandwidth (25 GbE) | ETS bandwidth (10 GbE) |
|---|---|---|---|---|
| 0 | Default traffic | No | 79% | 78% |
| 1-2 | N/A | N/A | N/A | N/A |
| 3 | CSV / Live Migration | No | 20% | 20% |
| 4-6 | N/A | N/A | N/A | N/A |
| 7 | Cluster heartbeat | No | 1% | 2% |

## Fiber Channel Host Bus Adapters (HBAs)

Each server has dual-port Fiber Channel Host Bus Adapters (HBAs) connected to the storage fabric. These adapters do not require Ethernet network connectivity.

- Fiber Channel HBA port A connects to Fiber Channel storage switch A.
- Fiber Channel HBA port B connects to Fiber Channel storage switch B.

The following diagram shows a logical representation of how the host networking, backup network, and Fiber Channel adapters are configured in this pattern:

:::image type="content" source="./media/plan-deployment/disaggregated-fiber-channel-san-with-backup-host-networking.svg" alt-text="Diagram showing disaggregated Fiber Channel SAN deployment with backup host networking pattern." lightbox="./media/plan-deployment/disaggregated-fiber-channel-san-with-backup-host-networking.svg":::

## Workload placement considerations

In a multi-rack Clos fabric, the physical location of workloads affects traffic patterns and bandwidth requirements. While the leaf-spine topology provides equal-cost paths between any two racks, workload placement can create uneven traffic distribution that impacts performance.

Key considerations:

- **High east-west traffic workloads** — Co-locating these workloads on the same rack or adjacent racks reduces spine bandwidth consumption.
- **Storage-heavy workloads** can saturate leaf-to-spine uplinks if spread across many racks.
- **Power-dense racks** may force workload spreading across racks for thermal or power distribution reasons, increasing cross-rack traffic.
- **Backup traffic** — When backup jobs run, VMs send traffic over the dedicated backup compute intent. Scheduling backup windows and co-locating backup-intensive VMs can reduce cross-rack backup traffic on spine links.

> [!NOTE]
> Azure Local does not currently provide hard workload placement controls (rack affinity). Administrators should be aware that uneven workload distribution may require adjusting the spine-to-leaf bandwidth ratio or adding spine capacity.

## Next steps

- Learn about the [Fiber Channel disaggregated pattern without backup network](fiber-channel-no-backup-disaggregated-pattern.md).
- [Install the Azure Local operating system for disaggregated deployments](/azure-local/deploy/deployment-install-os-disaggregated.md)