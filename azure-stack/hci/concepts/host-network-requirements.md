---
title: Host network requirements for Azure Stack HCI
description: Learn the host network requirements for Azure Stack HCI
author: dcuomo
ms.topic: how-to
ms.date: 04/17/2023
ms.author: dacuo
ms.reviewer: JasonGerend
---

# Host network requirements for Azure Stack HCI

[!INCLUDE [applies-to](../../includes/hci-applies-to-22h2-21h2.md)]

This topic discusses host networking considerations and requirements for Azure Stack HCI. For information on datacenter architectures and the physical connections between servers, see [Physical network requirements](physical-network-requirements.md).

For information on how to simplify host networking using Network ATC, see [Simplify host networking with Network ATC](../deploy/network-atc.md).

## Network traffic types

Azure Stack HCI network traffic can be classified by its intended purpose:

- **Management traffic:** Traffic to or from outside the local cluster. For example, storage replica traffic or traffic used by the administrator for management of the cluster like Remote Desktop, Windows Admin Center, Active Directory, etc.
- **Compute traffic:** Traffic originating from or destined to a virtual machine (VM).
- **Storage traffic:** Traffic using Server Message Block (SMB), for example Storage Spaces Direct or SMB-based live migration. This traffic is layer-2 traffic and is not routable.


> [!IMPORTANT]
> Storage replica uses non-RDMA based SMB traffic. This and the directional nature of the traffic (North-South) makes it closely aligned to that of "management" traffic listed above, similar to that of a traditional file share.

## Select a network adapter

Network adapters are qualified by the **network traffic types** (see above) they are supported for use with. As you review the [Windows Server Catalog](https://www.windowsservercatalog.com), the Windows Server 2022 certification now indicates one or more of the following roles. Before purchasing a server for Azure Stack HCI, you must minimally have *at least* one adapter that is qualified for management, compute, and storage as all three traffic types are required on Azure Stack HCI. You can then use [Network ATC](network-atc-overview.md) to configure your adapters for the appropriate traffic types.

For more information about this role-based NIC qualification, please see this [link](https://aka.ms/RoleBasedNIC).

> [!IMPORTANT]
> Using an adapter outside of its qualified traffic type is not supported.

|Level|Management Role|Compute Role|Storage Role|
|----|----|----|----|
|Role-based distinction|Management|Compute Standard|Storage Standard|
|Maximum Award|Not Applicable|Compute Premium|Storage Premium|
 
> [!NOTE]
> The highest qualification for any adapter in our ecosystem will contain the **Management**, **Compute Premium**, and **Storage Premium** qualifications.
 
![image](https://user-images.githubusercontent.com/12801954/188225569-bb160be0-96a2-4563-97d5-3d8efb3cb597.png)

## Driver Requirements

Inbox drivers are not supported for use with Azure Stack HCI. To identify if your adapter is using an inbox driver, run the following cmdlet. An adapter is using an inbox driver if the **DriverProvider** property is **Microsoft.**

```Powershell
Get-NetAdapter -Name <AdapterName> | Select *Driver*
```

## Overview of key network adapter capabilities

Important network adapter capabilities used by Azure Stack HCI include:

- Dynamic Virtual Machine Multi-Queue (Dynamic VMMQ or d.VMMQ)
- Remote Direct Memory Access (RDMA)
- Guest RDMA
- Switch Embedded Teaming (SET)

### Dynamic VMMQ

All network adapters with the Compute (Premium) qualification support Dynamic VMMQ. Dynamic VMMQ requires the use of Switch Embedded Teaming.

**Applicable traffic types:** compute

**Certifications required:** Compute (Premium)

Dynamic VMMQ is an intelligent, receive-side technology. It builds upon its predecessors of Virtual Machine Queue (VMQ), Virtual Receive Side Scaling (vRSS), and VMMQ, to provide three primary improvements:

- Optimizes host efficiency by using fewer CPU cores.
- Automatic tuning of network traffic processing to CPU cores, thus enabling VMs to meet and maintain expected throughput.
- Enables “bursty” workloads to receive the expected amount of traffic.

For more information on Dynamic VMMQ, see the blog post [Synthetic accelerations](https://techcommunity.microsoft.com/t5/networking-blog/synthetic-accelerations-in-a-nutshell-windows-server-2019/ba-p/653976).

### RDMA

RDMA is a network stack offload to the network adapter. It allows SMB storage traffic to bypass the operating system for processing.

RDMA enables high-throughput, low-latency networking, using minimal host CPU resources. These host CPU resources can then be used to run additional VMs or containers.

**Applicable traffic types:** host storage

**Certifications required:** Storage (Standard)

All adapters with Storage (Standard) or Storage (Premium) qualification support host-side RDMA. For more information on using RDMA with guest workloads, see the "Guest RDMA" section later in this article.

Azure Stack HCI supports RDMA with either the Internet Wide Area RDMA Protocol (iWARP) or RDMA over Converged Ethernet (RoCE) protocol implementations.

> [!IMPORTANT]
> RDMA adapters only work with other RDMA adapters that implement the same RDMA protocol (iWARP or RoCE).

Not all network adapters from vendors support RDMA. The following table lists those vendors (in alphabetical order) that offer certified RDMA adapters. However, there are hardware vendors not included in this list that also support RDMA. See the [Windows Server Catalog](https://www.windowsservercatalog.com/) to find adapters with the Storage (Standard) or Storage (Premium) qualification which require RDMA support.

> [!NOTE]
> InfiniBand (IB) is not supported with Azure Stack HCI.

|NIC vendor|iWARP|RoCE|
|----|----|----|
|Broadcom|No|Yes|
|Intel|Yes|Yes (some models)|
|Marvell (Qlogic)|Yes|Yes|
|Nvidia|No|Yes|

For more information on deploying RDMA for the host, we highly recommend you use Network ATC. For information on manual deployment see the [SDN GitHub repo](https://github.com/Microsoft/SDN/blob/master/Diagnostics/S2D%20WS2016_ConvergedNIC_Configuration.docx).

#### iWARP

iWARP uses Transmission Control Protocol (TCP), and can be optionally enhanced with Priority-based Flow Control (PFC) and Enhanced Transmission Service (ETS).

Use iWARP if:

- You don't have experience managing RDMA networks.
- You don't manage or are uncomfortable managing your top-of-rack (ToR) switches.
- You won't be managing the solution after deployment.
- You already have deployments that use iWARP.
- You're unsure which option to choose.

#### RoCE

RoCE uses User Datagram Protocol (UDP), and requires PFC and ETS to provide reliability.

Use RoCE if:

- You already have deployments with RoCE in your datacenter.
- You're comfortable managing the DCB network requirements.

### Guest RDMA

Guest RDMA enables SMB workloads for VMs to gain the same benefits of using RDMA on hosts.

**Applicable traffic types:** Guest-based storage

**Certifications required:** Compute (Premium)

 The primary benefits of using Guest RDMA are:

- CPU offload to the NIC for network traffic processing.
- Extremely low latency.
- High throughput.

For more information, download the document from the [SDN GitHub repo](https://github.com/Microsoft/SDN/blob/master/Diagnostics/S2D%20WS2016_ConvergedNIC_Configuration.docx).

### Switch Embedded Teaming (SET)

SET is a software-based teaming technology that has been included in the Windows Server operating system since Windows Server 2016. SET is the only teaming technology supported by Azure Stack HCI. SET works well with compute, storage, and management traffic and is supported with up to eight adapters in the same team.

**Applicable traffic types:** compute, storage, and management

**Certifications required:** Compute (Standard) or Compute (Premium)

SET is the only teaming technology supported by Azure Stack HCI. SET works well with compute, storage, and management traffic.

> [!IMPORTANT]
> Azure Stack HCI doesn’t support NIC teaming with the older Load Balancing/Failover (LBFO). See the blog post [Teaming in Azure Stack HCI](https://techcommunity.microsoft.com/t5/networking-blog/teaming-in-azure-stack-hci/ba-p/1070642) for more information on LBFO in Azure Stack HCI.

SET is important for Azure Stack HCI because it's the only teaming technology that enables:

- Teaming of RDMA adapters (if needed).
- Guest RDMA.
- Dynamic VMMQ.
- Other key Azure Stack HCI features (see [Teaming in Azure Stack HCI](https://techcommunity.microsoft.com/t5/networking-blog/teaming-in-azure-stack-hci/ba-p/1070642)).

SET requires the use of symmetric (identical) adapters. Symmetric network adapters are those that have the same:

- make (vendor)
- model (version)
- speed (throughput)
- configuration

In 22H2, Network ATC will automatically detect and inform you if the adapters you've chosen are asymmetric. The easiest way to manually identify if adapters are symmetric is if the speeds and interface descriptions are **exact** matches. They can deviate only in the numeral listed in the description. Use the [`Get-NetAdapterAdvancedProperty`](/powershell/module/netadapter/get-netadapteradvancedproperty) cmdlet to ensure the configuration reported lists the same property values.

See the following table for an example of the interface descriptions deviating only by numeral (#):

|Name|Interface description|Link speed|
|----|----|----|
|NIC1|Network Adapter #1|25 Gbps|
|NIC2|Network Adapter #2|25 Gbps|
|NIC3|Network Adapter #3|25 Gbps|
|NIC4|Network Adapter #4|25 Gbps|

> [!NOTE]
> SET supports only switch-independent configuration by using either Dynamic or Hyper-V Port load-balancing algorithms. For best performance, Hyper-V Port is recommended for use on all NICs that operate at or above 10 Gbps. Network ATC makes all the required configurations for SET.

### RDMA traffic considerations

If you implement DCB, you must ensure that the PFC and ETS configuration is implemented properly across every network port, including network switches. DCB is required for RoCE and optional for iWARP.

For detailed information on how to deploy RDMA, download the document from the [SDN GitHub repo](https://github.com/Microsoft/SDN/blob/master/Diagnostics/S2D%20WS2016_ConvergedNIC_Configuration.docx).

RoCE-based Azure Stack HCI implementations require the configuration of three PFC traffic classes, including the default traffic class, across the fabric and all hosts.

#### Cluster traffic class

This traffic class ensures that there's enough bandwidth reserved for cluster heartbeats:

- Required: Yes
- PFC-enabled: No
- Recommended traffic priority: Priority 7
- Recommended bandwidth reservation:
    - 10 GbE or lower RDMA networks = 2 percent
    - 25 GbE or higher RDMA networks = 1 percent

#### RDMA traffic class

This traffic class ensures that there's enough bandwidth reserved for lossless RDMA communications by using SMB Direct:

- Required: Yes
- PFC-enabled: Yes
- Recommended traffic priority: Priority 3 or 4
- Recommended bandwidth reservation: 50 percent

#### Default traffic class

This traffic class carries all other traffic not defined in the cluster or RDMA traffic classes, including VM traffic and management traffic:

- Required: By default (no configuration necessary on the host)
- Flow control (PFC)-enabled: No
- Recommended traffic class: By default (Priority 0)
- Recommended bandwidth reservation: By default (no host configuration required)

## Storage traffic models

SMB provides many benefits as the storage protocol for Azure Stack HCI, including SMB Multichannel. SMB Multichannel isn't covered in this article, but it's important to understand that traffic is multiplexed across every possible link that SMB Multichannel can use.

> [!NOTE]
>We recommend using multiple subnets and VLANs to separate storage traffic in Azure Stack HCI.

Consider the following example of a four node cluster. Each server has two storage ports (left and right side). Because each adapter is on the same subnet and VLAN, SMB Multichannel will spread connections across all available links. Therefore, the left-side port on the first server (192.168.1.1) will make a connection to the left-side port on the second server (192.168.1.2). The right-side port on the first server (192.168.1.12) will connect to the right-side port on the second server. Similar connections are established for the third and fourth servers.

However, this creates unnecessary connections and causes congestion at the interlink (multi-chassis link aggregation group or MC-LAG) that connects the ToR switches (marked with Xs). See the following diagram:

:::image type="content" source="media/plan-networking/four-node-cluster-1.png" alt-text="Diagram that shows a four-node cluster on the same subnet." lightbox="media/plan-networking/four-node-cluster-1.png":::

The recommended approach is to use separate subnets and VLANs for each set of adapters. In the following diagram, the right-hand ports now use subnet 192.168.2.x /24 and VLAN2. This allows traffic on the left-side ports to remain on TOR1 and the traffic on the right-side ports to remain on TOR2.

:::image type="content" source="media/plan-networking/four-node-cluster-2.png" alt-text="Diagram that shows a four-node cluster on different subnets." lightbox="media/plan-networking/four-node-cluster-2.png":::

## Traffic bandwidth allocation

The following table shows example bandwidth allocations of various traffic types, using common adapter speeds, in Azure Stack HCI. Note that this is an example of a *converged solution*, where all traffic types (compute, storage, and management) run over the same physical adapters, and are teamed by using SET.

Because this use case poses the most constraints, it represents a good baseline. However, considering the permutations for the number of adapters and speeds, this should be considered an example and not a support requirement.

The following assumptions are made for this example:

- There are two adapters per team.
- Storage Bus Layer (SBL), Cluster Shared Volume (CSV), and Hyper-V (Live Migration) traffic:

    - Use the same physical adapters.
    - Use SMB.
- SMB is given a 50 percent bandwidth allocation by using DCB.
    - SBL/CSV is the highest priority traffic, and receives 70 percent of the SMB bandwidth reservation.
    - Live Migration (LM) is limited by using the `Set-SMBBandwidthLimit` cmdlet, and receives 29 percent of the remaining bandwidth.
        - If the available bandwidth for Live Migration is >= 5 Gbps, and the network adapters are capable, use RDMA. Use the following cmdlet to do so:

            ```Powershell
            Set-VMHost -VirtualMachineMigrationPerformanceOption SMB
            ```

        - If the available bandwidth for Live Migration is < 5 Gbps, use compression to reduce blackout times. Use the following cmdlet to do so:

            ```Powershell
            Set-VMHost -VirtualMachineMigrationPerformanceOption Compression
            ```

 - If you're using RDMA for Live Migration traffic, ensure that Live Migration traffic can't consume the entire bandwidth allocated to the RDMA traffic class by using an SMB bandwidth limit. Be careful, because this cmdlet takes entry in bytes per second (Bps), whereas network adapters are listed in bits per second (bps). Use the following cmdlet to set a bandwidth limit of 6 Gbps, for example:

    ```Powershell
    Set-SMBBandwidthLimit -Category LiveMigration -BytesPerSecond 750MB
    ```

    > [!NOTE]
    >750 MBps in this example equates to 6 Gbps.

Here is the example bandwidth allocation table:

|NIC speed|Teamed bandwidth|SMB bandwidth reservation**|SBL/CSV %|SBL/CSV bandwidth|Live Migration %|Max Live Migration bandwidth|Heartbeat %|Heartbeat bandwidth|
|---------|-----------------|--------------------------|---------|-----------------|----------------|-----------------------------|----------|-------------------|
|10 Gbps  |20 Gbps          |10 Gbps                   |70%       |7 Gbps           |*\*            |200 Mbps                     |          |
|25 Gbps  |50 Gbps          |25 Gbps                   |70%       |17.5 Gbps        |29%            |7.25 Gbps                    |1%        |250 Mbps               |
|40 Gbps  |80 Gbps          |40 Gbps                   |70%       |28 Gbps          |29%            |11.6 Gbps                    |1%        |400 Mbps|
|50 Gbps  |100 Gbps         |50 Gbps                   |70%       |35 Gbps          |29%            |14.5 Gbps                    |1%        |500 Mbps|
|100 Gbps |200 Gbps        |100 Gbps                    |70%      |70 Gbps          |29%            |29 Gbps                      |1%        |1 Gbps|
|200 Gbps |400 Gbps        |200 Gbps                    |70%      |140 Gbps         |29%            |58 Gbps                      |1%        |2 Gbps|

\* Use compression rather than RDMA, because the bandwidth allocation for Live Migration traffic is <5 Gbps.

\** 50 percent is an example bandwidth reservation.

## Stretched clusters

Stretched clusters provide disaster recovery that spans multiple datacenters. In its simplest form, a stretched Azure Stack HCI cluster network looks like this:

:::image type="content" source="media/plan-networking/stretched-cluster.png" alt-text="Diagram that shows a stretched cluster." lightbox="media/plan-networking/stretched-cluster.png":::

### Stretched cluster requirements

Stretched clusters have the following requirements and characteristics:

- RDMA is limited to a single site, and isn't supported across different sites or subnets.

- Servers in the same site must reside in the same rack and Layer-2 boundary.

- Host communication between sites must cross a Layer-3 boundary; stretched Layer-2 topologies aren't supported.

- Have enough bandwidth to run the workloads at the other site. In the event of a failover, the alternate site will need to run all traffic. We recommend that you provision sites at 50 percent of their available network capacity. This isn't a requirement, however, if you are able to tolerate lower performance during a failover.

- Replication between sites (north/south traffic) can use the same physical NICs as the local storage (east/west traffic). If you're using the same physical adapters, these adapters must be teamed with SET. The adapters must also have additional virtual NICs provisioned for routable traffic between sites.

- Adapters used for communication between sites:

  - Can be physical or virtual (host vNIC). If adapters are virtual, you must provision one vNIC in its own subnet and VLAN per physical NIC.

  - Must be on their own subnet and VLAN that can route between sites.

  - RDMA must be disabled by using the `Disable-NetAdapterRDMA` cmdlet. We recommend that you explicitly require Storage Replica to use specific interfaces by using the `Set-SRNetworkConstraint` cmdlet.

  - Must meet any additional requirements for Storage Replica.

### Stretched cluster example

The following example illustrates a stretched cluster configuration. To ensure that a specific virtual NIC is mapped to a specific physical adapter, use the [Set-VMNetworkAdapterTeammapping](/powershell/module/hyper-v/set-vmnetworkadapterteammapping) cmdlet.

:::image type="content" source="media/plan-networking/stretched-cluster-example.png" alt-text="Diagram that shows an example of stretched cluster storage." lightbox="media/plan-networking/stretched-cluster-example.png":::

The following shows the details for the example stretched cluster configuration.

> [!NOTE]
>Your exact configuration, including NIC names, IP addresses, and VLANs, might be different than what is shown. This is used only as a reference configuration that can be adapted to your environment.

#### SiteA – Local replication, RDMA enabled, non-routable between sites

|Node name|vNIC name|Physical NIC (mapped)|VLAN|IP and subnet|Traffic scope|
|-----|-----|-----|-----|-----|-----|
|NodeA1|vSMB01|pNIC01|711|192.168.1.1/24|Local Site Only|
|NodeA2|vSMB01|pNIC01|711|192.168.1.2/24|Local Site Only|
|NodeA1|vSMB02|pNIC02|712|192.168.2.1/24|Local Site Only|
|NodeA2|vSMB02|pNIC02|712|192.168.2.2/24|Local Site Only|

#### SiteB – Local replication, RDMA enabled, non-routable between sites

|Node name|vNIC name|Physical NIC (mapped)|VLAN|IP and subnet|Traffic scope|
|-----|-----|-----|-----|-----|-----|
|NodeB1|vSMB01|pNIC01|711|192.168.1.1/24|Local Site Only|
|NodeB2|vSMB01|pNIC01|711|192.168.1.2/24|Local Site Only|
|NodeB1|vSMB02|pNIC02|712|192.168.2.1/24|Local Site Only|
|NodeB2|vSMB02|pNIC02|712|192.168.2.2/24|Local Site Only|

#### SiteA – Stretched replication, RDMA disabled, routable between sites

|Node name|vNIC name|Physical NIC (mapped)|IP and subnet|Traffic scope|
|-----|-----|-----|-----|-----|
|NodeA1|Stretch1|pNIC01|173.0.0.1/8|Cross-Site Routable|
|NodeA2|Stretch1|pNIC01|173.0.0.2/8|Cross-Site Routable|
|NodeA1|Stretch2|pNIC02|174.0.0.1/8|Cross-Site Routable|
|NodeA2|Stretch2|pNIC02|174.0.0.2/8|Cross-Site Routable|

#### SiteB – Stretched replication, RDMA disabled, routable between sites

|Node name|vNIC name|Physical NIC (mapped)|IP and subnet|Traffic scope|
|-----|-----|-----|-----|-----|
|NodeB1|Stretch1|pNIC01|175.0.0.1/8|Cross-Site Routable|
|NodeB2|Stretch1|pNIC01|175.0.0.2/8|Cross-Site Routable|
|NodeB1|Stretch2|pNIC02|176.0.0.1/8|Cross-Site Routable|
|NodeB2|Stretch2|pNIC02|176.0.0.2/8|Cross-Site Routable|

## Next steps

- Learn about network switch and physical network requirements. See [Physical network requirements](physical-network-requirements.md).
- Learn how to simplify host networking using Network ATC. See [Simplify host networking with Network ATC](../deploy/network-atc.md).
- Brush up on [failover clustering networking basics](https://techcommunity.microsoft.com/t5/failover-clustering/failover-clustering-networking-basics-and-fundamentals/ba-p/1706005?s=09).
- For deployment, see [Create a cluster using Windows Admin Center](../deploy/create-cluster.md).
- For deployment, see [Create a cluster using Windows PowerShell](../deploy/create-cluster-powershell.md).
