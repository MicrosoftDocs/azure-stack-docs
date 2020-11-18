---
title: Plan host networking for Azure Stack HCI
description: Learn how to plan host networking for Azure Stack HCI clusters
author: v-dasis
ms.topic: how-to
ms.date: 11/18/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Plan host networking for Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2

This topic discusses the host networking considerations and requirements for Azure Stack HCI.

## Host network designs

This section discusses the logical network design of Azure Stack HCI cluster nodes.
For information on data center architectures and the interconnects between cluster nodes, please see [Plan physical networking for Azure Stack HCI] which discusses the concepts of North/South vs East/West traffic; switched vs switchless; and other physical networking topic.

## Types of network traffic

Network traffic can be classified by its intended purpose:

- **Management traffic**: Traffic used by the administrator. This type of traffic is used for administration including connections to Active Directory, Remote Desktop, for Remote Administration (for example: PowerShell or Windows Admin Center), etc.
- **Compute traffic**: Traffic originating from or destined for a virtual machine
- **Storage traffic**: Traffic for Storage Spaces Direct using SMB

## Selecting a network adapter

For Azure Stack HCI, Microsoft requires choosing a network adapter that has achieved the Windows Server SDDC Premium or Standard AQ (Additional Qualification). These adapters support the most advanced platform features and have undergone the most testing by our hardware partners. Typically, this level of scrutiny leads to a reduction in hardware and driver related quality issues.

You can identify an adapter that has the Premium AQ by reviewing the Windows Server Catalog entry for that adapter and the applicable operating system version. Below is an example of the notation for a Premium AQ.

:::image type="content" source="media/plan-networking/windows-certified.png" alt-text="Windows Certified" lightbox="media/plan-networking/windows-certified.png":::

### Key Azure Stack HCI network adapter capabilities

#### Remote Direct Memory Access (RDMA)

**Applicable traffic types**: Host Storage or Guest Compute
**Certifications required**: Standard (Host) or Premium (Guest)
All adapters with the Standard or Premium certifications support RDMA (Remote Direct Memory Access). RDMA is the recommended deployment choice for Storage workloads in Azure Stack HCI and can optionally be enabled for storage workloads (SMB) into a Virtual Machine.

RDMA enables high-throughput, low-latency networking while using minimal host CPU resources. These host CPU resources can then be used to run additional Virtual Machines or Containers.

RDMA is a direct memory access technology from the memory of one computer into that of another without involving either operating system. That is, RDMA is a network stack offload to the network adapter allowing the applicable network traffic to bypass the operating system for processing by the consuming application. In Azure Stack HCI, the consuming application is SMB. Teaming of RDMA adapters requires Switch Embedded Teaming (SET).

Azure Stack HCI supports RDMA with either of the following two protocol implementations:
-	Internet Wide Area RDMA Protocol (iWARP)
    - Uses TCP
    - Can be optionally enhanced with Data Center Bridging (PFC and ETS)
-	RDMA over Converged Ethernet (RoCE)
    - Uses UDP
    - Requires Data Center Bridging (PFC and ETS) to provide reliability


> [!NOTE]
> Infiniband is not supported with Azure Stack HCI

> [!IMPORTANT]
> RDMA adapters can only interoperate with other RDMA adapters that implement the same RDMA protocol (iWARP or RoCE).

The following table shows vendors (in alphabetical order) that offer Premium certified RDMA adapters by RDMA protocol type. Note, there are hardware vendors not included in this list that do support RDMA. Please use the Windows Server Catalog to verify RDMA support.

|NIC Vendor|iWARP|RoCE|
|----|----|----|
|Broadcom|No|Yes|
|Chelsio|Yes|No|
|Intel|Yes|Yes (some models)|
|Marvell (Qlogic/Cavium)|Yes|Yes|
|Nvidia (Mellanox)|No|Yes|

> [!NOTE]
> Not all adapters from the vendors support RDMA. Please verify RDMA support with your network card vendor.

Microsoft recommends that you use iWARP if:

- You have little or no network experience or are uncomfortable managing network switches
- You do not control your ToR switches
- You are unsure which option to choose
- You will not be managing the solution after deployment
- You already have deployments with iWARP

Microsoft recommends that you use RoCE if:

- You already have deployments with RoCE in your data center
- You are familiar with the physical network requirements
For more information, please see the section below labelled RDMA Considerations

#### Dynamic VMMQ

**Applicable traffic types**: Compute

**Certifications required**: Premium

All adapters with Premium certifications support Dynamic Virtual Machine Multi-Queue (d.VMMQ).  Dynamic VMMQ is an intelligent receive-side technology that builds upon its predecessors of VMQ, VRSS, and VMMQ to provide three primary improvements:

- Optimizes the host’s efficiency (use of CPU cores)
- Automatic tuning of network traffic processing to CPU cores (enabling the VM to meet and maintain the expected throughput)
- Enables “bursty” workloads to receive the expected amount of traffic
Dynamic VMMQ requires Switch Embedded Teaming.

For more information on Dynamic VMMQ, please see the following [link].

#### Guest RDMA

**Applicable traffic types**: Compute

**Certifications required**: Premium

Guest RDMA enables SMB workloads into a virtual machine to gain the same benefits of RDMA on the host. The primary benefits are:

- CPU offload (to the NIC) of network traffic processing
- Extremely low latency
- High throughput
For more information including how to deploy Guest RDMA, please see the Guest RDMA section of the [RDMA deployment guide].

## Teaming in Azure Stack HCI

**Applicable traffic types**: Compute, Management, and Storage

**Certifications required:** None (built into the OS)

Switch Embedded Teaming (SET) is a software-based teaming mechanism included in the operating system. It is not dependent on the network adapters used. SET has been included in the Windows Server operating system since Windows Server 2016.

SET is the only teaming mechanism supported by Azure Stack HCI. LBFO is commonly used with Windows Server but is not supported with Azure Stack HCI. See the blog post [Teaming in Azure Stack HCI](https://techcommunity.microsoft.com/t5/networking-blog/teaming-in-azure-stack-hci/ba-p/1070642) for more information on LBFO in Azure Stack HCI. SET works well with Management, Compute, and Storage traffic alike.

SET is important for Azure Stack HCI as it is the only teaming technology that enables:

- Teaming of RDMA adapters (if needed)
- Dynamic VMMQ (see Dynamic VMMQ)
- Guest RDMA (see Guest RDMA)
- Several other key Azure Stack HCI features (outlined here)

Requirements: Switch Embedded Teaming provides many additional features including quality and performance improvements over its predecessor, LBFO. To do this, SET requires the use of symmetric adapters – teaming of asymmetric adapters is not supported. Symmetric adapters are those that have the same:

- Make (vendor)
- Model (version)
- Speed (throughput)
- Configuration

> [!IMPORTANT]
>The easiest way to identify if adapters can be symmetric are if the interface descriptions match (they can deviate only in the number proceeding the description) and the speed is the same. From there, ensure that the configuration reported on `Get-NetAdapterAdvancedProperty` report the same values for the available properties.

## RDMA Considerations

If you implement Data Center Bridging (required for RoCE; optional for iWARP) you must ensure that PFC and ETS configuration is implemented properly across every network port (including network switches).

For more information on deploying RDMA, please see the [RDMA Deployment Guide].

### Traffic Classes

RoCE-based Azure Stack HCI implementations requires the configuration of three PFC traffic classes (including the default traffic class) across the hosts and fabric. More information is found in the RDMA Deployment Guide linked above.

#### Cluster traffic class

This traffic class ensures that cluster heartbeats have bandwidth reserved for cluster heartbeats
- Required: Yes
- Flow Control (PFC) Enabled: No
- Recommended Traffic Class: Priority 7
- Recommended Bandwidth Reservation
    - 10 GbE or lower RDMA networks: 2%
    - 25 GbE or higher RDMA networks: 1%

#### RDMA traffic class

This traffic class ensures the lossless communication of RDMA (SMBDirect) and reserves the necessary bandwidth.

- Required: Yes
- Flow Control (PFC) Enabled: Yes
- Recommended Traffic class: Priority 3 or 4
- Recommended Bandwidth Reservation: 50%

#### Default traffic class
This traffic class carries all other traffic not defined in the cluster or RDMA traffic classes including management traffic, virtual machine traffic, etc.

- Required: By default – No configuration necessary on the host
- Flow Control (PFC) Enabled: No
- Recommended Traffic Class: Default – Traffic Class 0
- Recommended Bandwidth Reservation: Default; no host configuration required

## Storage Design Patterns

Microsoft highly recommends using multiple Subnets and VLANs to separate storage traffic in Azure Stack HCI.

SMB provides many benefits as the storage protocol for Azure Stack HCI including SMB Multichannel. While multichannel is out-of-scope for this document, it is important to understand that traffic can is multiplexed across every possible link that SMB Multichannel can use.

Consider the following example of a 4-node cluster. Each node has a redundant storage port (blue and green). Because every adapter is on the same subnet and VLAN, SMB Multichannel will spread connections across all available links. Therefore, the blue port on the first node (192.168.1.1) will make a connection to the second node blue port (192.168.1.2) and the second node green port (192.168.1.12) – it does the same for the 3rd and 4th nodes. This creates unnecessary connections and causes congestion at the interlink (MC-LAG) that connects the TORs (marked with Red X’s).

:::image type="content" source="media/plan-networking/four-node-cluster-1.png" alt-text="Windows Certified" lightbox="media/plan-networking/four-node-cluster-1.png":::

The recommended approach is to use separate subnets and VLANs for each group of adapters. In this picture, the green ports have been changed to the subnet 192.168.2.x /24 and VLAN 2. This allows the traffic on the blue ports to remain on TOR1 and the traffic on the green ports to remain on TOR2.

:::image type="content" source="media/plan-networking/four-node-cluster-2.png" alt-text="Windows Certified" lightbox="media/plan-networking/four-node-cluster-2.png":::

## Stretched cluster requirements

Stretched clusters provide disaster recovery that spans multiple data centers. In its simplest form, a stretched cluster network looks like this:

:::image type="content" source="media/plan-networking/stretched-cluster.png" alt-text="Stretched cluster" lightbox="media/plan-networking/stretched-cluster.png":::

The following lists requirements and characteristics of a stretched cluster:

- All nodes in the same site are within the same rack and layer-2 boundary
- Communication between sites crosses a layer-3 boundary; stretch clustering does not support stretched layer-2 topologies
- RDMA is not supported between stretch cluster sites
- If the local site uses RDMA for its storage adapters, you must use adapters on a separate subnet and VLAN for Stretch S2D in order to prevent Storage Replica from using RDMA across sites. These adapters:

    - Can be physical or virtual (Host vNIC). If virtual, provision one virtual NIC in its own subnet and VLAN per physical NIC.
    - Must disable RDMA using the `Disable-NetAdapterRDMA` cmdlet. It is recommended that you explicitly require storage replica to use specific interfaces through the `Set-SRNetworkConstraint` cmdlet
    - Must be on their own subnet and VLAN that can route between sites
    - Should enforce the bandwidth limits outlined in the section Traffic Bandwidth Allocation using the `Set-SmbBandwidthLimit` cmdlet
    - Must meet the additional requirements for Storage Replica
-	In the event of a failover to another site, ensure that enough bandwidth is available to run the workloads at the alternate site. A good rule of thumb is to provision sites at 50% of their available capacity however this is not a requirement if you are able to tolerate lower performance during a failover.

## Traffic bandwidth allocation

The following table shows an example for bandwidth allocations of various traffic types in Azure Stack HCI. Note that this is an example of a converged solution where all traffic types (Management, Compute, and Storage) run over the same physical adapters and are teamed with SET.

Since this scenario poses the most constraints on the solution, it represents a good baseline. However, considering the permutations including number of adapters, speed, etc., this should be considered an example and not a support requirement.
The following shows examples using common adapter speeds. The following assumptions are made for this example:

- There are two adapters in the team
- Storage Spaces Direct (SBL), Failover Clustering (CSV), Hyper-V (Live Migration) and Storage Replica are all:
    - Using the SMB
    - Using the same physical adapters
    - SMB has been given a 50% bandwidth allocation using Data Center Bridging (NetQos)
    - SBL/CSV is the highest priority traffic and receives 70% of the SMB bandwidth reservation
    - Live Migration is limited using the Set-SMBBandwidthLimit cmdlet and receives between 14% and 15% of the remaining bandwidth
        - If the available bandwidth for live migration is >= 5 Gbps, and the network adapters are capable, use RDMA. For example, use this cmdlet or your user interface of choice:
Set-VMHost VirtualMachineMigrationPerformanceOption SMB
        - If the available bandwidth for live migration is < 5 Gbps use compression to reduce blackout times. For example, use this cmdlet or your user interface of choice:

```Powershell
Set-VMHost -VirtualMachineMigrationPerformanceOption Compression
```

 - If using RDMA with Data Center Bridging, ensure that Live Migration cannot consume the entire bandwidth allocated to the RDMA traffic class by use an SMB Bandwith Limit. Be careful as this cmdlet takes entry as Bytes where as network adapters are in bits. For example, use the `Set-SMBBandwidthLimit` cmdlet to set a bandwidth limit of 6 Gbps:

```Powershell
Set-SMBBandwidthLimit -Category LiveMigration -BytesPerSecond 750MB
```

> [!NOTE]
>750 MBps converts to 6 Gbps

- Storage Replica (if used) is limited using the `Set-SMBBandwidthLimit` cmdlet and receives 14% of the remaining bandwidth.

The following table shows bandwidth allocations for various traffic types, where:

- All units are in Gbps
- Values apply to both stretched and non-stretched clusters
- SMB traffic gets 50% of the total bandwidth allocation
- Storage Bus Layer/Cluster Shared Volume (SBL/CSV) traffic gets 70% of the remaining 50% allocation
- Live Migration (LM) traffic gets 15% of the remaining 50% allocation
- Storage Replica (SR) traffic gets 14% of the remaining 50% allocation
- Heartbeat (HB) traffic gets 1% of the remaining 50% allocation


|NIC Speed|Teamed Bandwidth|SMB 50% Reservation|SBL/CSV %|SBL/CSV Bandwidth|LM %|LM Bandwidth|SR % |SR Bandwidth|HB %|HB Bandwidth|
|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
|10|20|10|70%|7|14%*|1.4*|14%|1.4|2%|0.2|
|25|50|25|70%|17.5|15%*|3.75*|14%|3.5|1%|0.25|
|40|80|	40|70%|28|15%|6|14%|5.6|1%|0.4|
|50|100|50|70%|35|15%|7.5|14%|7|1%|0.5|
|100|200|100|70%|70|15%|15|14%|14|1%|1|
|200|400|200|70%|140|15%|30|14%|28|1%|2|

*- should use compression rather than RDMA if bandwidth allocation for LM traffic is <5 Gbps

## Next steps

- Brush up on failover clustering basics. See [Failover Clustering Networking Basics](https://techcommunity.microsoft.com/t5/failover-clustering/failover-clustering-networking-basics-and-fundamentals/ba-p/1706005?s=09)
- Brush up on using SET. See [Remote Direct Memory Access (RDMA) and Switch Embedded Teaming (SET)](https://docs.microsoft.com/windows-server/virtualization/hyper-v-virtual-switch/rdma-and-switch-embedded-teaming)
- For deployment, see [Create a cluster using Windows Admin Center](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster)
- For deployment, see [Create a cluster using Windows PowerShell](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster-powershell)