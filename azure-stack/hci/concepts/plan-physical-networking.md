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

This topic discusses physical (fabric) networking considerations and requirements for Azure Stack HCI, particularly for network switches. Work with your network vendor or support team to ensure your network switches are adequately sized for the workloads you intend to run.

> [!NOTE]
> Requirements for future Azure Stack HCI versions may change.


## Supported network switches

Microsoft tests Azure Stack HCI to the standards and protocols identified in the **Network Switch Requirements** section. While Microsoft does not certify network switches, we do work with vendors to identify devices that support Azure Stack HCI requirements.

These requirements are also published in [Windows Hardware Compatibility Program Specifications and Policies](https://docs.microsoft.com/windows-hardware/design/compatibility/whcp-specifications-policies) page in the **Components and Peripherals Specification** section under **Device.Network.Switch.SDDC**.

> [!IMPORTANT]
> While other network switches using technologies and protocols not listed here may work, Microsoft cannot guarantee they will work with Azure Stack HCI and may be unable to assist in troubleshooting the issues that occur.

When purchasing network switches, contact your switch vendor and ensure that the devices meet all Azure Stack HCI requirements. The following vendors (in alphabetical order) have confirmed that their switches support Azure Stack HCI requirements:

|Vendor|10 GbE|25 GbE|100 GbE|
|-----|-----|-----|-----|
|Dell|S41xx series| | |
|Dell| |S52xx series|S52xx series|
|Lenovo|G8272| | |
|Lenovo|NE1032| | |
|Lenovo| |NE2572| |
|Lenovo| | |NE10032|

> [!IMPORTANT]
> Microsoft will add or remove vendors from this list as they are informed of changes by network switch vendors.

If your switch is not included, contact your switch vendor to ensure your switch model and switch operating system version support the required IEEE standards in the next section.

## Network switch requirements

This section lists industry specifications, organizational standards, and protocols that are mandatory for network switched used in all Azure Stack HCI deployments. These requirements help ensure reliable communications between nodes in Azure Stack HCI cluster deployments. Reliable communications between cluster nodes is critical.

To provide the needed level of reliability for Azure Stack HCI requires that all switches:

- Comply with applicable industry specifications, standards, and protocols.
- Unless noted, compliance with the latest active (non-superseded) version of the standard is required. Only mandatory portions of a standard are required.
- Provide visibility as to which specifications, standards, and protocols the switch supports and which capabilities are enabled.

> [!NOTE]
> Network adapters used for compute, storage, and management traffic require Ethernet. For more information on network adapters, see [Plan Host Networking].

Here are the mandatory IEEE standards and specifications:

### Standard: IEEE 802.1Q

Ethernet switches must comply with the IEEE 802.1Q specification that defines VLANs. VLANs are required for several aspects of Azure Stack HCI and are required in all scenarios.

### Standard: IEEE 802.1Qbb

Ethernet switches must comply with the IEEE 802.1Qbb specification that defines Priority Flow Control (PFC). PFC is required where Data Center Bridging (DCB) is used. Since DCB can be used in both RoCE and iWARP RDMA scenarios, 802.1Qbb is required in all scenarios. A minimum of three Class of Service (CoS) priorities are required without downgrading the switch capabilities or port speeds. At least one of these traffic classes must provide lossless communication.

### Standard: IEEE 802.1Qaz

Ethernet switches must comply with the IEEE 802.1Qaz specification that defines Enhanced Transmission Select (ETS). ETS is required where DCB is used. Since DCB can be used in both RoCE and iWARP RDMA scenarios, 802.1Qaz is required in all scenarios. A minimum of three CoS priorities are required without downgrading the switch capabilities or port speed.

> [!NOTE]
> Hyper-converged infrastructure has a high reliance on East-West Layer-2 communication within the same rack and therefore requires ETS. Microsoft does not test Azure Stack HCI with Differentiated Services Code Point (DSCP). 

### Standard: IEEE 802.1AB

Ethernet switches must comply with the IEEE 802.1AB specification that defines the Link Layer Discovery Protocol (LLDP). LLDP is required for Azure Stack HCI and supports teaming to discover switch configuration.

Configuration of the LLDP Type-Length-Values (TLVs) must be dynamically enabled. These switches must not require additional configuration beyond enablement of a specific TLV. For example, enabling 802.1 Subtype 3 should automatically advertise all VLANs available on switch ports.

### Custom TLV Requirements

LLDP allows organizations to define and encode their own custom TLVs. These are called Organizationally Specific TLVs. All Organizationally Specific TLVs start with an LLDP TLV Type value of 127. The following table shows which Organizationally Specific Custom TLV (TLV Type 127) subtypes are required:

|Version required|Organization|TLV Subtype|
|-----|-----|-----|-----|
|20H2 and later|IEEE 802.1|VLAN Name (Subtype = 3)|
|20H2 and later|IEEE 802.3|Maximum Frame Size (Subtype = 4)|

## Network traffic and architecture

Network traffic can be classified by its direction. Traditional Storage Area Network (SAN) environments are heavily North-South where traffic flows from a compute tier to a storage tier across Layer-3 (IP) boundaries. This is a 3-Tier core-aggregation-access architecture.

Hyper-converged infrastructure is more heavily East-West where a substantial portion of data traffic stays within a Layer-2 (VLAN) boundary. This is a 2-Tier spine-leaf architecture.

Azure Stack HCI works in both spine-leaf and core-aggregation-access data center architectures.

Here is some more information on network traffic by direction in Azure Stack HCI:

### North-South traffic

North-South traffic has the following characteristics:

- Traffic flows out of a ToR switch to the spine or in from the spine to a ToR switch
- Traffic leaves the physical rack or crosses a Layer-3 boundary (IP)
- Includes management (PowerShell, Windows Admin Center), compute (VM), and storage (inter-site for stretched clusters) traffic
- Uses an Ethernet switch for connectivity to the physical network

### East-West traffic

East-West traffic has the following characteristics:

- Traffic remains within the ToR switch or switches
- Traffic stays within the same rack and Layer-2 boundary (VLAN)
- Includes storage traffic or Live Migration traffic between nodes in the same cluster and (if using stretched cluster) within the same site
- May use an Ethernet switch (switched) or a direct (switchless) connection, as described in the next two sections.

> [!NOTE]
>We highly recommend that all cluster nodes within a site are physically located in the same rack and connected to the same ToR switch or switches.

## Using switched connections

North-South traffic requires the use of switched connections. Besides using an Ethernet switch that supports the required protocols for Azure Stack HCI, the most important aspect is the proper sizing of the network fabric.

It is imperative to understand the "non-blocking" fabric bandwidth that your Ethernet switches can support and that you minimize (or preferably eliminate) oversubscription of the network.

Common congestion points and oversubscription, such as the [Multi-Chassis Link Aggregation Group](https://en.wikipedia.org/wiki/Multi-chassis_link_aggregation_group) used for path redundancy, can be eliminated through proper use of subnets and VLANs. For more information, see [Plan Host Networking] topic.

## Using switchless connections

Azure Stack HCI supports switchless (direct) connections for all cluster sizes so long as each node in the cluster has a redundant connection to every node in the cluster. This is called a "full-mesh" connection.

Generally speaking, using a direct switchless connection is more beneficial for smaller two-node and three-node clusters.

East-West traffic can use switchless connections between nodes in the cluster.

### Advantages of switchless connections

- No switch purchase is necessary for East-West traffic. A switch is required for North-South traffic. This may result in lower capital expenditures (Capex) costs but is dependent on the number of nodes in the cluster.
- Since there is no switch, configuration is limited to the host, which may reduce the potential number of configuration steps needed. This value diminishes as the cluster size increases.

### Disadvantages of switchless connections

- More network adapters are required to provide redundancy. As the number of nodes in the cluster grows, this may result in a higher Capex cost.
- More planning is required for IP and subnet addressing schemes
- Provides only local storage access. VM traffic, management traffic, and other traffic requiring North-South access cannot use these adapters.
- Generally does not scale well beyond three-node clusters.

## Next steps

- Plan networking for the Hyper-V host. See [Plan Host Networking]
- Brush up on failover clustering basics. See [Failover Clustering Networking Basics](https://techcommunity.microsoft.com/t5/failover-clustering/failover-clustering-networking-basics-and-fundamentals/ba-p/1706005?s=09)
- Brush up on using SET. See [Remote Direct Memory Access (RDMA) and Switch Embedded Teaming (SET)](https://docs.microsoft.com/windows-server/virtualization/hyper-v-virtual-switch/rdma-and-switch-embedded-teaming)
- For deployment, see [Create a cluster using Windows Admin Center](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster)
- For deployment, see [Create a cluster using Windows PowerShell](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster-powershell)