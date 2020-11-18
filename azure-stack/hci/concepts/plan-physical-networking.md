---
title: Plan the physical network for Azure Stack HCI
description: Learn how to plan the physical network for Azure Stack HCI clusters
author: v-dasis
ms.topic: how-to
ms.date: 11/18/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Plan the physical network for Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2

This topic discusses considerations and requirements for the physical network (fabric) in Azure Stack HCI environments.

## Network Switches for Azure Stack HCI

Microsoft tests Azure Stack HCI with the technologies and protocols identified in the section Network Switch Requirements. Microsoft does not certify network switches; however, we have worked with vendors to identify devices that support the Azure Stack HCI required technologies and protocols.

> [!IMPORTANT]
> While other network devices using technologies and protocols not listed here may work, Microsoft cannot guarantee they will work with Azure Stack HCI and may be unable to assist in troubleshooting the issues that occur.

When making a purchase of network switches, please contact your network switch vendor and ensure that the devices meet the Azure Stack HCI requirements (in the section Network Switch Requirements). The following vendors (in alphabetical order) have confirmed that the switches below support the Azure Stack HCI requirements:

|Vendor|10 GbE|25 GbE|100 GbE|
|-----|-----|-----|-----|
|Dell|S41xx series| | |
|Dell| |S52xx series|S52xx series|
|Lenovo|G8272| | |
|Lenovo|NE1032| | |
|Lenovo| |NE2572| |
|Lenovo| | |NE10032|

> [!IMPORTANT]
> Microsoft will add or remove vendors from the list as they are informed of changes in support by network switch vendors.

## Network Switch Requirements

This section defines the requirements for physical switches used with Azure Stack HCI and lists the industry specifications, organizational standards, and protocols that are mandatory for all Azure Stack HCI deployments. These requirements help ensure reliable communications between nodes in Azure Stack HCI cluster deployments. Reliable communications between nodes is critical.

To provide the needed level of reliability for Azure Stack HCI requires that switches:

- Comply with applicable industry specifications, standards, and protocols.
    - Only mandatory portions of the standard is required
    - Unless noted, compliance with the latest active (non-superseded) version of the standard is required
- Provide visibility as to which specifications, standards, and protocols the switch supports and which capabilities are enabled
If your switch is not included in the table of switches that support Azure Stack HCI Network Requirements (see section Network Switches for Azure Stack HCI), please contact your network switch vendor to ensure that your switch model and switch operating system version support the following technologies.

> [!NOTE]
> Though not listed here, Network Adapters used for Azure Stack HCI Management, Compute, and Storage, require Ethernet. For more information on the requirements for Network Adapters, see Plan Host Networking).

### Standard: IEEE 802.1Q

Ethernet switches must comply with the IEEE 802.1Q specification that defines VLANs. VLANs are required for several aspects of Azure Stack HCI and are required in all scenarios.

### Standard: IEEE 802.1Qbb

Ethernet switches must comply with the IEEE 802.1Qbb specification that defines Priority Flow Control (PFC). PFC is required where Data Center Bridging (DCB) is used. Since DCB can be used in both RoCE and iWARP RDMA scenarios, 802.1Qbb is required in all scenarios. A minimum of three Class of Service (CoS) priorities are required without downgrading the switch capabilities or port speeds. At least one of these traffic classes must provide lossless communication.

### Standard: IEEE 802.1Qaz

Ethernet switches must comply with the IEEE 802.1Qaz specification that defines Enhanced Transmission Select (ETS). ETS is required where DCB is used. Since DCB can be used in both RoCE and iWARP RDMA scenarios, 802.1Qaz is required in all scenarios. A minimum of three CoS priorities are required without downgrading the switch capabilities or port speed.

> [!NOTE]
> Microsoft does not test Azure Stack HCI with DSCP. Hyper-converged infrastructure has a high reliance on East/West Layer-2 communication within the same rack and therefore requires ETS.

### Standard: IEEE 802.1AB

Ethernet switches must comply with the IEEE 802.1AB specification that defines the Link Layer Discovery Protocol (LLDP). LLDP is required for Azure Stack HCI and support teams to discover switch configuration.

Configuration of the LLDP Type-Length-Values (TLVs) must be dynamically enabled. These switches must not require additional configuration beyond enablement of a specific TLV. For example, enabling 802.1 Subtype 3 should automatically advertise all VLANs available on switch ports.

### Custom TLV Requirements

LLDP allows organizations to define and encode their own custom TLVs. These are called Organizationally Specific TLVs. All Organizationally Specific TLVs start with an LLDP TLV Type value of 127. The following table shows which Organizationally Specific Custom TLV (TLV Type 127) subtypes are required:

|Version required|Organization|TLV Subtype|
|-----|-----|-----|-----|
|20H2 and later|IEEE 802.1|VLAN Name (Subtype = 3)|
|20H2 and later|IEEE 802.3|Maximum Frame Size (Subtype = 4)|

## Publication and Changes to Requirements

These requirements are also published in [Windows Hardware Compatibility Program Specifications and Policies](https://docs.microsoft.com/windows-hardware/design/compatibility/whcp-specifications-policies) page in the **Components and Peripherals Specification** under **Device.Network.Switch.SDDC**.

Requirements for future Azure Stack HCI versions may change.

## Network Architectures

Azure Stack HCI can function in various data center architectures including 2-tier (Spine-Leaf) or 3-tier (Core-Aggregation-Access) architectures.

In the following sections, we will more generally refer to concepts from the Spine/Leaf topology - which is commonly used with workloads that like Hyper-converged infrastructure which are heavily East/West - such as Top-of-Rack (ToR) switch however this should not be misconstrued as a support requirement.

> [!NOTE]
>We highly recommend that all cluster nodes in the same site are physically located in the same rack and connected to the same ToR(s).

## Network Traffic Patterns

Network traffic can be classified by its direction. Whereas traditional SAN environments are heavily North/South where traffic flows from a compute tier to the storage tier across layer-3 (IP) boundaries (Core/Aggregation), Hyper-Converged Infrastructure is more heavily East/West where a substantial portion of data stays within a layer-2 (VLAN) boundary (ToR/Leaf).

The following defines network traffic by direction in Azure Stack HCI:

- **North/South**: Traffic that flows into or out of the cluster crossing a layer-3 (IP) boundary. This type of traffic has the following characteristics:
    - Traffic that flows out of the ToR to the spine or in from the spine to a ToR.
    - Management (Remote Desktop, PowerShell, etc.), virtual machine, and (if using a stretch cluster) storage traffic between sites
    - Traffic that that leaves the physical rack and/or crosses a layer-3 boundary (IP)
    - Must use an Ethernet switch for connectivity to the physical network

- **East/West**: Traffic that flows in between nodes in the same cluster and stays within a layer-2 (VLAN) boundary. This type of traffic has the following characteristics:

    - Traffic remains within the ToR(s)
    - Includes storage traffic or live migration traffic between nodes in the same cluster and (if using stretch cluster) within the same site
    - Traffic that stays within the same rack and layer-2 boundary (VLAN).
    - May use an ethernet switch (switched) or direct (switchless) connection:
        - **Switched connections**: Ensure the fabric bandwidth (including Multi-Chassis Link Aggregation Group used for path redundancy) is sufficient to minimize network congestion. This is typically referred to as the “non-blocking” bandwidth of the fabric by switch vendors.
        - **Switchless connections**: Connections must be “full-mesh.” That is, every node must have a direct connection to every other node in the cluster.

### Switched Design Requirements and Limitations

Besides using a network device that supports the required protocols for Azure Stack HCI, the most important aspect is proper sizing of the fabric.

It is imperative to understand the fabric bandwidth (non-blocking) that your switches can support and ensure that you minimize (or preferably eliminate) oversubscription of the network. Depending on your design, common congestion points and oversubscription (such as the [Multi-Chassis Link Aggregation Group](https://en.wikipedia.org/wiki/Multi-chassis_link_aggregation_group) used for path redundancy) can be eliminated through proper use of Subnets and VLANs. For more information, see [Plan Host Networking] topic.

Work with your network vendor or network support team to ensure you network switches have been properly sized for the workload you are intending to run.

### Switchless Design Requirements and Limitations

East/West traffic can use a direct or back-to-back connection between nodes in the cluster.

Azure Stack HCI supports switchless for all cluster sizes so long as each node in the cluster has a redundant connection to every node in the cluster. However, generally switchless is more beneficial for smaller (2 to 3 node) clusters.

#### Advantages of switchless connections

- No Switch purchase is necessary for East/West Communication (still required for North/South traffic). This may result in lower CAPEX cost but is dependent on the number of nodes in the cluster.
- Since there is no switch, configuration is limited to the host which may reduce the potential number of configuration steps needed – As mentioned above, this value diminishes as the cluster size increases.

#### Disadvantages of switchless connections

- More network adapters are required to provide redundancy; as the number of nodes in the cluster grows, this may result in a higher CAPEX cost.
- More planning required for IP and Subnet addressing schemes
- Provides only local storage access; virtual machines, management, and other traffic requiring north/south access cannot share these adapters.
- Generally does not scale well beyond 3 node clusters.

## Next steps

- Plan networking for the Hyper-V host. See [Plan Host Networking]
- Brush up on failover clustering basics. See [Failover Clustering Networking Basics](https://techcommunity.microsoft.com/t5/failover-clustering/failover-clustering-networking-basics-and-fundamentals/ba-p/1706005?s=09)
- Brush up on using SET. See [Remote Direct Memory Access (RDMA) and Switch Embedded Teaming (SET)](https://docs.microsoft.com/windows-server/virtualization/hyper-v-virtual-switch/rdma-and-switch-embedded-teaming)
- For deployment, see [Create a cluster using Windows Admin Center](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster)
- For deployment, see [Create a cluster using Windows PowerShell](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster-powershell)