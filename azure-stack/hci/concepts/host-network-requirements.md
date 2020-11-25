---
title: Host network requirements for Azure Stack HCI
description: Learn the host network requirements for Azure Stack HCI
author: v-dasis
ms.topic: how-to
ms.date: 11/24/2020
ms.author: v-dasis
ms.reviewer: JasonGerend
---

# Host network requirements for Azure Stack HCI

> Applies to Azure Stack HCI, version 20H2

This topic discusses Azure Stack HCI host networking considerations and requirements. For information on data center architectures and the physical connections between servers, see [Physical network requirements](host-network-requirements.md).

## Network traffic types

Azure Stack HCI Network traffic can be classified by its intended purpose:

- **Compute traffic** - traffic originating from or destined for a virtual machine (VM)
- **Storage traffic** - traffic for Storage Spaces Direct (S2D) using Server Message Block (SMB)
- **Management traffic** - traffic important to an administrator for cluster management, such as Active Directory, Remote Desktop, Windows Admin Center, and Windows PowerShell.

## Selecting a network adapter

For Azure Stack HCI, we require choosing a network adapter that has achieved the Windows Server Software-Defined Data Center (SDDC) certification with the Standard or Premium Additional Qualification (AQ). These adapters support the most advanced platform features and have undergone the most testing by our hardware partners. Typically, this level of scrutiny leads to a reduction in hardware and driver-related quality issues.

You can identify an adapter that has Standard or Premium AQ by reviewing the [Windows Server Catalog](https://www.windowsservercatalog.com/) entry for the adapter and the applicable operating system version. Below is an example of the notation for Premium AQ:

:::image type="content" source="media/plan-networking/windows-certified.png" alt-text="Windows Certified" lightbox="media/plan-networking/windows-certified.png":::

## Overview of key network adapter capabilities

Important network adapter capabilities leveraged by Azure Stack HCI include:

- Dynamic Virtual Machine Multi-Queue (Dynamic VMMQ or d.VMMQ)
- Remote Direct Memory Access (RDMA)
- Guest RDMA
- Switch Embedded Teaming (SET)

### Dynamic VMMQ

All network adapters with the Premium AQ support Dynamic VMMQ. Dynamic VMMQ requires the use of Switch Embedded Teaming.

**Applicable traffic types**: compute

**Certifications required**: Premium

Dynamic VMMQ is an intelligent receive-side technology that builds upon its predecessors of Virtual Machine Queue (VMQ), Virtual Receive Side Scaling (vRSS), and VMMQ to provide three primary improvements:

- Optimizes host efficiency by use use of CPU cores
- Automatic tuning of network traffic processing to CPU cores, thus enabling VMs to meet and maintain expected throughput
- Enables “bursty” workloads to receive the expected amount of traffic

For more information on Dynamic VMMQ, see the blog post [Synthetic Accelerations](https://techcommunity.microsoft.com/t5/networking-blog/synthetic-accelerations-in-a-nutshell-windows-server-2019/ba-p/653976).

### RDMA

RDMA is a network stack offload to the network adapter allowing SMB storage traffic to bypass the operating system for processing.

RDMA enables high-throughput, low-latency networking while using minimal host CPU resources. These host CPU resources can then be used to run additional VMs or containers.

**Applicable traffic types**: host storage

**Certifications required**: Standard

All adapters with Standard or Premium AQ support RDMA (Remote Direct Memory Access). RDMA is the recommended deployment choice for storage workloads in Azure Stack HCI and can be optionally enabled for storage workloads (using SMB) for virtual machines (VMs). See the **Guest RDMA** section later.

Azure Stack HCI supports RDMA using either the iWARP or RoCE protocol implementations.

> [!IMPORTANT]
> RDMA adapters only work with other RDMA adapters that implement the same RDMA protocol (iWARP or RoCE).

Not all network adapters from vendors support RDMA. The following table lists those vendors (in alphabetical order) that offer Premium certified RDMA adapters. However, there are hardware vendors not included in this list that also support RDMA. See the [Windows Server Catalog](https://www.windowsservercatalog.com/) to verify RDMA support.

> [!NOTE]
> InfiniBand (IB) is not supported with Azure Stack HCI.

|NIC vendor|iWARP|RoCE|
|----|----|----|
|Broadcom|No|Yes|
|Chelsio|Yes|No|
|Intel|Yes|Yes (some models)|
|Marvell (Qlogic/Cavium)|Yes|Yes|
|Nvidia (Mellanox)|No|Yes|

> [!NOTE]
> Not all adapters from the vendors support RDMA. Please verify RDMA support with your specific network card vendor.

For more information on deploying RDMA, download the Word doc from the [SDN GitHub repo](https://github.com/Microsoft/SDN/blob/master/Diagnostics/S2D%20WS2016_ConvergedNIC_Configuration.docx).

#### Internet Wide Area RDMA Protocol (iWARP)

iWARP uses the Transmission Control Protocol (TCP), and can be optionally enhanced with Data Center Bridging (DCB) Priority-based Flow Control (PFC) and Enhanced Transmission Service (ETS).

We recommend that you use iWARP if:

- You have little or no network experience or are uncomfortable managing network switches
- You do not control your ToR switches
- You will not be managing the solution after deployment
- You already have deployments using iWARP
- You are unsure which option to choose

#### RDMA over Converged Ethernet (RoCE)

RoCE uses User Datagram Protocol (UDP), and requires Data Center Bridging PFC and ETS to provide reliability.

We recommend that you use RoCE if:

- You already have deployments with RoCE in your data center
- You are knowledgeable with your physical network requirements

### Guest RDMA

Guest RDMA enables SMB workloads for VMs to gain the same benefits of using RDMA on hosts.

**Applicable traffic types**: compute

**Certifications required**: Premium

 The primary benefits of using Guest RDMA are:

- CPU offload to the NIC for network traffic processing
- Extremely low latency
- High throughput

For more information including how to deploy Guest RDMA, download the Word doc from the [SDN GitHub repo](https://github.com/Microsoft/SDN/blob/master/Diagnostics/S2D%20WS2016_ConvergedNIC_Configuration.docx).

### Switch Embedded Teaming (SET)

Switch Embedded Teaming (SET) is a software-based teaming technology that has been included in the Windows Server operating system since Windows Server 2016. SET is not dependent on the type of network adapters used.

**Applicable traffic types**: compute, storage, and management

**Certifications required:** none (built into the OS)

SET is the only teaming technology supported by Azure Stack HCI. Load Balancing/Failover (LBFO) is another teaming technology commonly used with Windows Server but is not supported with Azure Stack HCI. See the blog post [Teaming in Azure Stack HCI](https://techcommunity.microsoft.com/t5/networking-blog/teaming-in-azure-stack-hci/ba-p/1070642) for more information on LBFO in Azure Stack HCI. SET works well with compute, storage, and management traffic alike.

SET is important for Azure Stack HCI as it is the only teaming technology that enables:

- Teaming of RDMA adapters (if needed)
- Guest RDMA
- Dynamic VMMQ
- Other key Azure Stack HCI features (see [Teaming in Azure Stack HCI](https://techcommunity.microsoft.com/t5/networking-blog/teaming-in-azure-stack-hci/ba-p/1070642))

SET provides additional features over LBFO including quality and performance improvements. To do this, SET requires the use of symmetric (identical) adapters – teaming of asymmetric adapters is not supported. Symmetric network adapters are those that have the same:

- make (vendor)
- model (version)
- speed (throughput)
- configuration

The easiest way to identify if adapters are symmetric is if the speeds are the same and the interface descriptions match. They can deviate only in the numeral listed in the description. Use the [`Get-NetAdapterAdvancedProperty`](https://docs.microsoft.com/powershell/module/netadapter/get-netadapteradvancedproperty) cmdlet to ensure the configuration reported lists the same property values.

See the following table for an example of the interface descriptions deviating only by numeral (#):

|Name|Interface Description|Link Speed|
|----|----|----|
|NIC1|Network Adapter #1|25 Gbps|
|NIC2|Network Adapter #2|25 Gbps|
|NIC3|Network Adapter #3|25 Gbps|
|NIC4|Network Adapter #4|25 Gbps|

### RDMA traffic considerations

If you implement Data Center Bridging (DCB), you must ensure that the PFC and ETS configuration is implemented properly across every network port, including network switches. DCB is required for RoCE and optional for iWARP.

For detailed information on how to deploy RDMA, download the Word doc from the [SDN GitHub repo](https://github.com/Microsoft/SDN/blob/master/Diagnostics/S2D%20WS2016_ConvergedNIC_Configuration.docx).

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

## Storage traffic models

SMB provides many benefits as the storage protocol for Azure Stack HCI including SMB Multichannel. While SMB Multichannel is out-of-scope for this topic, it is important to understand that traffic is multiplexed across every possible link that SMB Multichannel can use.

> [!NOTE]
>We recommend using multiple subnets and VLANs to separate storage traffic in Azure Stack HCI.

Consider the following example of a four node cluster. Each server has two storage ports (left and right side). Because each adapter is on the same subnet and VLAN, SMB Multichannel will spread connections across all available links. Therefore, the left-side port on the first server (192.168.1.1) will make a connection to the left-side port on the second server (192.168.1.2). The right-side port on the first server (192.168.1.12) will connect to the right-side port on the second server. Similar connections are established for the third and fourth servers.

However, this creates unnecessary connections and causes congestion at the interlink (multi-chassis link aggregation group or MC-LAG) that connects the top of rack (ToR) switches (marked with Xs). See the following diagram:

:::image type="content" source="media/plan-networking/four-node-cluster-1.png" alt-text="four-node cluster same subnet" lightbox="media/plan-networking/four-node-cluster-1.png":::

The recommended approach is to use separate subnets and VLANs for each set of adapters. In the following diagram, the right-hand ports now use subnet 192.168.2.x /24 and VLAN2. This allows traffic on the left-side ports to remain on TOR1 and the traffic on the right-side ports to remain on TOR2. See the following diagram:

:::image type="content" source="media/plan-networking/four-node-cluster-2.png" alt-text="four-node cluster different subnets" lightbox="media/plan-networking/four-node-cluster-2.png":::


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
    - Live Migration (LM) is limited using the `Set-SMBBandwidthLimit` cmdlet and receives 29% of the remaining bandwidth
        - If the available bandwidth for Live Migration is >= 5 Gbps, and the network adapters are capable, use RDMA. Use the following cmdlet to do so:

            ```Powershell
            Set-VMHost VirtualMachineMigrationPerformanceOption SMB
            ```

        - If the available bandwidth for Live Migration is < 5 Gbps, use compression to reduce blackout times. Use the following cmdlet to do so:

            ```Powershell
            Set-VMHost -VirtualMachineMigrationPerformanceOption Compression
            ```

 - If using RDMA with Live Migration, ensure that Live Migration cannot consume the entire bandwidth allocated to the RDMA traffic class by use an SMB bandwidth limit. Be careful as this cmdlet takes entry in bytes per second (Bps) whereas network adapters are listed in bits per second (bps). Use the following cmdlet to set a bandwidth limit of 6 Gbps for example:

    ```Powershell
    Set-SMBBandwidthLimit -Category LiveMigration -BytesPerSecond 750MB
    ```

    > [!NOTE]
    >750 MBps in this example equates to 6 Gbps

The following table shows bandwidth allocations for various traffic types:

|NIC Speed|Teamed Bandwidth|SMB Bandwidth Reservation**|SBL/CSV %|SBL/CSV Bandwidth|Live Migration %|Max Live Migration Bandwidth|Heartbeat %|Heartbeat Bandwidth|
|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|-----|
|10 Gbps|20 Gbps|10 Gbps|70%|7 Gbps|*|*|2%|200 Mbps|
|25 Gbps|50 Gbps|25 Gbps|70%|17.5 Gbps|29%|7.25 Gbps|1%|250 Mbps|
|40 Gbps|80 Gbps|40 Gbps|70%|28 Gbps|29%|11.6 Gbps|1%|400 Mbps|
|50 Gbps|100 Gbps|50 Gbps|70%|35 Gbps|29%|14.5 Gbps|1%|500 Mbps|
|100 Gbps|200 Gbps|100 Gbps|70%|70 Gbps|29%|29 Gbps|1%|1 Gbps|
|200 Gbps|400 Gbps|200 Gbps|70%|140 Gbps|29%|58 Gbps|1%|2 Gbps|

*- should use compression rather than RDMA as the bandwidth allocation for Live Migration traffic is <5 Gbps

**- 50% is an example bandwidth reservation for this example

## Stretched cluster considerations

Stretched clusters provide disaster recovery that spans multiple data centers. In its simplest form, a stretched Azure Stack HCI cluster network looks like this:

:::image type="content" source="media/plan-networking/stretched-cluster.png" alt-text="Stretched cluster" lightbox="media/plan-networking/stretched-cluster.png":::

Stretched clusters have the following requirements and characteristics:

- RDMA is limited to a single site, and is not supported across different sites or subnets.
- Servers in the same site must reside in the same rack and Layer-2 boundary.
- Communication between sites cross a Layer-3 boundary; stretched Layer-2 topologies are not supported.

- If a site uses RDMA for its storage adapters, these adapters must be on a separate subnet and VLAN that cannot route between sites. This prevents Storage Replica from using RDMA across sites.
- Adapters used for communication between sites:

    - Can be physical or virtual (host vNIC). If virtual, you must provision one vNIC in its own subnet and VLAN per physical NIC.
    - Must be on their own subnet and VLAN that can route between sites
    - RDMA must be disabled using the `Disable-NetAdapterRDMA` cmdlet. We recommend that you explicitly require Storage Replica to use specific interfaces using the `Set-SRNetworkConstraint` cmdlet.
    - Must meet any additional requirements for Storage Replica.
-	In the event of a failover to another site, you must ensure that enough bandwidth is available to run the workloads at the other site. A safe option is to provision sites at 50% of their available capacity. This is not a hard requirement if you are able to tolerate lower performance during a failover.

## Next steps

- Learn about network switch and physical network requirements. See [Physical network requirements](host-network-requirements.md).
- Brush up on failover clustering basics. See [Failover Clustering Networking Basics](https://techcommunity.microsoft.com/t5/failover-clustering/failover-clustering-networking-basics-and-fundamentals/ba-p/1706005?s=09)
- Brush up on using SET. See [Remote Direct Memory Access (RDMA) and Switch Embedded Teaming (SET)](https://docs.microsoft.com/windows-server/virtualization/hyper-v-virtual-switch/rdma-and-switch-embedded-teaming)
- For deployment, see [Create a cluster using Windows Admin Center](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster)
- For deployment, see [Create a cluster using Windows PowerShell](https://docs.microsoft.com/azure-stack/hci/deploy/create-cluster-powershell)
