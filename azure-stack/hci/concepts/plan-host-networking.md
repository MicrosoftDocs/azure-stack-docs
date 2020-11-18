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

This topic discusses the Hyper-V host networking considerations and requirements for Azure Stack HCI.

## Host network considerations

This section discusses the logical network design of Azure Stack HCI cluster server nodes. For information on data center architectures and the interconnects between cluster nodes, see [Plan physical networking for Azure Stack HCI], which discusses North-South vs East-West network traffic, switched vs switchless connections, and other physical networking topics.

Network traffic can be classified by its intended purpose:

- **Compute traffic** - traffic originating from or destined for a virtual machine (VM)
- **Storage traffic** - traffic for Storage Spaces Direct (S2D) using Server Message Block (SMB)
- **Management traffic** - traffic used by an administrator for cluster management using Active Directory, Remote Desktop, Windows Admin Center, and Windows PowerShell.

## Selecting a network adapter

For Azure Stack HCI, we require choosing a network adapter that has achieved the Windows Server Software-Defined Data Center (SDDC) Premium or Standard AQ (Additional Qualification) certification. These adapters support the most advanced platform features and have undergone the most testing by our hardware partners. Typically, this level of scrutiny leads to a reduction in hardware and driver-related quality issues.

You can identify an adapter that has the Premium AQ certification by reviewing the [Windows Server Catalog](https://www.windowsservercatalog.com/) entry for that adapter and the applicable operating system version. Below is an example of the notation for a Premium AQ certification:

:::image type="content" source="media/plan-networking/windows-certified.png" alt-text="Windows Certified" lightbox="media/plan-networking/windows-certified.png":::

## Using RDMA

Remote Direct Memory Access (RDMA) is a direct memory access technology from the memory of one computer into that of another without involving either operating system. That is, RDMA is a network stack offload to the network adapter allowing the network traffic to bypass the operating system for processing by the consuming application. In Azure Stack HCI, the consuming application is SMB. Teaming of RDMA adapters requires Switch Embedded Teaming (SET).

**Applicable traffic types**: host storage or guest compute

**Certifications required**: Standard (host) or Premium (guest)

RDMA enables high-throughput, low-latency networking while using minimal host CPU resources. These host CPU resources can then be used to run additional VMs or containers.

All adapters with Standard or Premium certification support RDMA. RDMA is the recommended deployment choice for storage workloads in Azure Stack HCI and can optionally be enabled for storage workloads using SMB in a VM.

> [!NOTE]
> Not all adapters from vendors support RDMA. Please verify RDMA support with your specific network card vendor.

For more information on deploying RDMA, download the Word doc from the [SDN Github repo](https://github.com/Microsoft/SDN/blob/master/Diagnostics/S2D%20WS2016_ConvergedNIC_Configuration.docx).

Azure Stack HCI supports RDMA with either of the following two protocol implementations:

### Internet Wide Area RDMA Protocol (iWARP)

iWARP uses Transmission Control Protocol (TCP). It can be optionally enhanced with Data Center Bridging (DCB) Priority-based Flow Control (PFC) and Enhanced Transmission Service (ETS).

We recommend that you use iWARP if:

- You have little or no network experience or are uncomfortable managing network switches
- You do not control your ToR switches
- You will not be managing the solution after deployment
- You already have deployments using iWARP
- You are unsure which option to choose

### RDMA over Converged Ethernet (RoCE)

RoCE uses User Datagram Protocol (UDP), and requires Data Center Bridging PFC and ETS to provide reliability.

We recommend that you use RoCE if:

- You already have deployments with RoCE in your data center
- You are familiar with your physical network requirements

> [!NOTE]
> InfiniBand (IB) with RDMA is not supported with Azure Stack HCI.

> [!IMPORTANT]
> RDMA adapters only work with other RDMA adapters that implement the same RDMA protocol (iWARP or RoCE).

The following table lists those vendors (in alphabetical order) that offer Premium certified RDMA adapters. Note that there are hardware vendors not included in this list that also support RDMA. See the [Windows Server Catalog](https://www.windowsservercatalog.com/) to verify RDMA support.

|NIC Vendor|iWARP|RoCE|
|----|----|----|
|Broadcom|No|Yes|
|Chelsio|Yes|No|
|Intel|Yes|Yes (some models)|
|Marvell (Qlogic/Cavium)|Yes|Yes|
|Nvidia (Mellanox)|No|Yes|

#### Using Guest RDMA

Guest RDMA enables SMB workloads into a VM to gain the same benefits of RDMA on the host.

**Applicable traffic types**: compute

**Certifications required**: Premium

 The primary benefits of using Guest RDMA are:

- CPU offload (to the NIC) of network traffic processing
- Extremely low latency
- High throughput

For more information including how to deploy Guest RDMA, download the Word doc from the [SDN Github repo](https://github.com/Microsoft/SDN/blob/master/Diagnostics/S2D%20WS2016_ConvergedNIC_Configuration.docx).

### Traffic classes

RoCE-based Azure Stack HCI implementations requires the configuration of three PFC traffic classes, including the default traffic class, across the fabric and all hosts:

#### Cluster traffic class

This traffic class ensures there is enough bandwidth reserved for cluster heartbeats:

- Required: Yes
- Flow control (PFC) enabled: No
- Recommended traffic priority: Priority 7
- Recommended bandwidth reservation:
    - 10 GbE or lower RDMA networks = 2%
    - 25 GbE or higher RDMA networks = 1%

#### RDMA traffic class

This traffic class there is enough bandwidth reserved for lossless RDA communications using SMB Direct:

- Required: Yes
- Flow control (PFC) enabled: Yes
- Recommended traffic priority: Priority 3 or 4
- Recommended bandwidth reservation: 50%

#### Default traffic class

This traffic class carries all other traffic not defined in the cluster or RDMA traffic classes including VM traffic and management traffic:

- Required: By default (no configuration necessary on the host)
- Flow control (PFC) enabled: No
- Recommended traffic class: By default (Priority 0)
- Recommended bandwidth reservation: By default (no host configuration required)

## Using Dynamic VMMQ

All network adapters with Premium certification support Dynamic Virtual Machine Multi-Queue (d.VMMQ). 

**Applicable traffic types**: compute

**Certifications required**: Premium

Dynamic VMMQ is an intelligent receive-side technology that builds upon its predecessors of VMQ, VRSS, and VMMQ to provide three primary improvements:

- Optimizes host efficiency by use use of CPU cores
- Automatic tuning of network traffic processing to CPU cores, thus enabling VMs to meet and maintain expected throughput
- Enables “bursty” workloads to receive the expected amount of traffic

Dynamic VMMQ requires Switch Embedded Teaming (SET). For more information on Dynamic VMMQ, see the blog post [Synthetic Accelerations in a Nutshell – Windows Server 2019](https://techcommunity.microsoft.com/t5/networking-blog/synthetic-accelerations-in-a-nutshell-windows-server-2019/ba-p/653976).

## Using Switch Embedded Teaming (SET)

Switch Embedded Teaming (SET) is a software-based teaming technology that has been included in the Windows Server operating system since Windows Server 2016. SET is not dependent on the type of network adapters used.

**Applicable traffic types**: compute, storage, and management

**Certifications required:** none (built into the OS)

SET is the only teaming technology supported by Azure Stack HCI. Load Balancing/Failover (LBFO) is another teaming technology commonly used with Windows Server but is not supported with Azure Stack HCI. See the blog post [Teaming in Azure Stack HCI](https://techcommunity.microsoft.com/t5/networking-blog/teaming-in-azure-stack-hci/ba-p/1070642) for more information on LBFO in Azure Stack HCI. SET works well with compute, storage, and management traffic alike.

SET is important for Azure Stack HCI as it is the only teaming technology that enables:

- Teaming of RDMA adapters (if needed)
- Guest RDMA
- Dynamic VMMQ

- Other key Azure Stack HCI features

SET provides additional features over LBFO including quality and performance improvements. To do this, SET requires the use of symmetric adapters – teaming of asymmetric adapters is not supported. Symmetric network adapters are those that have the same:

- Make (vendor)
- Model (version)
- Speed (throughput)
- Configuration

> [!IMPORTANT]
>The easiest way to identify if adapters are symmetric are if the interface descriptions match. They can deviate only in the number proceeding the description and the speed is the same. Use the [`Get-NetAdapterAdvancedProperty`](https://docs.microsoft.com/powershell/module/netadapter/get-netadapteradvancedproperty?view=win10-ps) cmdlet to ensure the configuration reported lists the same property values.

## Storage traffic considerations

SMB provides many benefits as the storage protocol for Azure Stack HCI including SMB Multichannel. While SMB Multichannel is out-of-scope for this topic, it is important to understand that traffic is multiplexed across every possible link that SMB Multichannel can use.

> [!NOTE]
>We highly recommend using multiple subnets and VLANs to separate storage traffic in Azure Stack HCI.

Consider the following example of a four-node cluster. Each server node has a redundant storage port (blue and light-green). Because each adapter is on the same subnet and VLAN, SMB Multichannel will spread connections across all available links. Therefore, the blue port on the first node (192.168.1.1) will make a connection to the second node blue port (192.168.1.2) and the green port on the first node (192.168.1.12) will do likewise for the second node green. This happens the same for the third and fourth nodes. However, this creates unnecessary connections and causes congestion at the interlink (MC-LAG) that connects the top of rack (TOR) switches (marked with red Xs).

See the following diagram:

:::image type="content" source="media/plan-networking/four-node-cluster-1.png" alt-text="four-node cluster same subnet" lightbox="media/plan-networking/four-node-cluster-1.png":::

The recommended approach is to use separate subnets and VLANs for each sey of adapters. In the following diagram, the green ports now use subnet 192.168.2.x /24 and VLAN2. This allows traffic on the blue ports to remain on TOR1 and the traffic on the green ports to remain on TOR2.

:::image type="content" source="media/plan-networking/four-node-cluster-2.png" alt-text="four-node cluster different subnets" lightbox="media/plan-networking/four-node-cluster-2.png":::

## Stretched cluster considerations

Stretched clusters provide disaster recovery that spans multiple data centers. In its simplest form, a stretched Azure Stack HCI cluster network looks like this:

:::image type="content" source="media/plan-networking/stretched-cluster.png" alt-text="Stretched cluster" lightbox="media/plan-networking/stretched-cluster.png":::

Stretched clusters have the following requirements and characteristics:

- RDMA is not supported between different sites or subnets
- Server nodes in the same site must reside in the same rack and Layer-2 boundary
- Communication between sites cross a Layer-3 boundary, therefore stretched layer-2 topologies are not supported

- If a site uses RDMA for its storage adapters, such adapters must be on a separate subnet and VLAN for Storage Spaces Direct. This prevents Storage Replica from using RDMA across sites. These adapters:

    - Can be physical or virtual (host vNIC). If virtual, you must provision one vNIC in its own subnet and VLAN per physical NIC.
    - Must be on their own subnet and VLAN that can route between sites
    - RDMA must be disabled using the `Disable-NetAdapterRDMA` cmdlet. We recommend that you explicitly require Storage Replica to use specific interfaces using the `Set-SRNetworkConstraint` cmdlet.
    - Should folow the bandwidth limits listed in the **Traffic Bandwidth Allocation** table below using the `Set-SmbBandwidthLimit` cmdlet.
    - Must meet any additional requirements for Storage Replica
-	In the event of a failover to another site, you must ensure that enough bandwidth is available to run the workloads at the other site. A good rule of thumb is to provision sites at 50% of their available capacity. This is not a hard requirement if you are able to tolerate lower performance during a failover.

## Traffic bandwidth allocation

The following table shows bandwidth allocations of various traffic types in Azure Stack HCI. Note that this is an example of a converged solution where all traffic types (compute, storage, and management) run over the same physical adapters and are teamed using SET.

Since this use case poses the most constraints, it represents a good baseline. However, considering the permutations for number of adapters and speeds, this should be considered an example and not a support requirement.

The table shows examples using common adapter speeds. The following assumptions are made for this example:

- There are two adapters per team
- Storage Spaces Direct (SBL), Failover Clustering (CSV), Hyper-V (Live Migration), and Storage Replica traffic:

    - Use the same physical adapters
    - Use SMB
    - SMB is given a 50% bandwidth allocation using Data Center Bridging (NetQos)
    - Storage Bus Layer/Cluster Shared Volume (SBL/CSV) is the highest priority traffic and receives 70% of the SMB bandwidth reservation, and:
    - Live Migration (LM) is limited using the `Set-SMBBandwidthLimit` cmdlet and receives between 14% and 15% of the remaining bandwidth
        - If the available bandwidth for Live Migration is >= 5 Gbps, and the network adapters are capable, use RDMA. Use the following cmdlet to do so:

            ```Powershell
            Set-VMHost VirtualMachineMigrationPerformanceOption SMB
            ```

        - If the available bandwidth for Live Migration is < 5 Gbps use compression to reduce blackout times. Use the following cmdlet to do so:

            ```Powershell
            Set-VMHost -VirtualMachineMigrationPerformanceOption Compression
            ```

 - If using RDMA with Data Center Bridging, ensure that Live Migration cannot consume the entire bandwidth allocated to the RDMA traffic class by use an SMB Bandwith Limit. Be careful as this cmdlet takes entry as Bytes whereas network adapters are listed in bits. Use the following cmdlet to set a bandwidth limit of 6 Gbps for example:

    ```Powershell
    Set-SMBBandwidthLimit -Category LiveMigration -BytesPerSecond 750MB
    ```

    > [!NOTE]
    >750 MBps converts to 6 Gbps

- Storage Replica (if used) can also be limited using the `Set-SMBBandwidthLimit` cmdlet and receives 14% of the remaining bandwidth.

The following table shows bandwidth allocations for various traffic types. All units are in Gbps:

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