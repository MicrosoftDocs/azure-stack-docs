---
title: Azure Stack HCI two-node storage switchless, two switches deployment network reference pattern
description: Plan to deploy an Azure Stack HCI two-node storage switchless, two switches network reference pattern.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/21/2022
---

# Review two-node storage switchless, two switches deployment network reference pattern for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

In this article, you'll learn about the two-node storage switchless with two TOR L3 switches network reference pattern that you can use to deploy your Azure Stack HCI solution. The information in this article will also help you determine if this configuration is viable for your deployment planning needs. This article is targeted towards the IT administrators who deploy and manage Azure Stack HCI in their datacenters.

For information on other network patterns, see [Azure Stack HCI network deployment patterns](choose-network-pattern.md).

## Scenarios

Scenarios for this network pattern include laboratories, branch offices, and datacenter facilities.

Consider implementing this pattern when looking for a cost-efficient solution that has fault tolerance across all the network components. It is possible to scale out the pattern, but will require workload downtime to reconfigure storage physical connectivity and storage network reconfiguration. SDN L3 services are fully supported on this pattern. Routing services such as BGP can be configured directly on the TOR switches if they support L3 services. Network security features such as micro-segmentation and QoS do not require additional configuration for the firewall device as they are implemented at the virtual network adapter layer.

## Physical connectivity components

As illustrated in the diagram below, this pattern has the following physical network components:

- For northbound/southbound traffic, the cluster requires two TOR switches in MLAG configuration.

- Two teamed network cards to handle management and compute traffic, and connected to the TOR switches. Each NIC will be connected to a different TOR switch.

- Two RDMA NICs in a full-mesh configuration for East-West storage traffic. Each node in the cluster has a redundant connection to the other node in the cluster.

- As an option, some solutions might use a headless configuration without a BMC card for security purposes.

|Networks|Management & compute|Storage|BMC|
|--|--|--|--|
|Link speed|At least 1 GBps. 10 GBps recommended|At least 10 GBps|Check with hardware manufacturer|
|Interface type|RJ45, SFP+ or SFP28|SFP+ or SFP28|RJ45|
|Ports and aggregation|Two teamed ports|Two standalone ports|One port|

:::image type="content" source="media/two-node-switchless-two-switches/physical-components-layout.png" alt-text="Diagram showing two-node switchless physical connectivity layout" lightbox="media/two-node-switchless-two-switches/physical-components-layout.png":::

## Logical connectivity components

As illustrated in the diagram below, this pattern has the following logical network components:

:::image type="content" source="media/two-node-switchless-two-switches/logical-components-layout.png" alt-text="Diagram showing single-node switchless physical connectivity layout" lightbox="media/two-node-switchless-two-switches/logical-components-layout.png":::

### Storage Network VLANs

The storage intent-based traffic consists of two individual networks supporting RDMA traffic. Each interface is dedicated to a separate storage network, and both may share the same VLAN tag. This traffic is only intended to travel between the two nodes. Storage traffic is a private network without connectivity to other resources.

The storage adapters operate in different IP subnets. To enable a switchless configuration, each connected node a matching subnet of its neighbor. Each storage network uses the Network ATC predefined VLANs by default (711 and 712). These VLANs can be customized if required. In addition, if the default subnet defined by ATC is not usable, you are responsible for assigning all storage IP addresses in the cluster.

For more information, see [Network ATC overview](/concepts/network-atc-overview.md).

[!INCLUDE [includes](includes/two-node-include.md)]

## Network ATC intents

For two-node storage switchless patterns, two Network ATC intents are created. The first for management and compute network traffic, and the second for storage traffic.

:::image type="content" source="media/two-node-switchless-single-switch/network-atc.png" alt-text="Diagram showing two-node switchless Network ATC intents" lightbox="media/two-node-switchless-single-switch/network-atc.png":::

### Management & compute intent

- Intent Type: Management and Compute
- Intent Mode: Cluster mode
- Teaming: Yes. pNIC01 and pNIC02 Team
- Default Management VLAN: Configured VLAN for management adapters isn’t modified
- PA & Compute VLANs and vNICs: Network ATC is transparent to PA vNICs and VLAN or compute VM vNICs and VLANs

### Storage intent

- Intent type: Storage
- Intent mode: Cluster mode
- Teaming: pNIC03 and pNIC04 use SMB Multichannel to provide resiliency and bandwidth aggregation
- Default VLANs:
    - 711 for storage network 1
    - 712 for storage network 2
- Default subnets:
    - 10.71.1.0/24 for storage network 1
    - 10.71.2.0/24 for storage network 2

For more information, see [Deploy host networking](/deploy/network-atc.md).

Follow these steps to create network intents for this reference pattern:

1. Run PowerShell as administrator.
1. Run the following command:

    ```powershell
    Add-NetIntent -Name <Management_Compute> -Management -Compute -ClusterName <HCI01> -AdapterName <pNIC01, pNIC02>
    Add-NetIntent -Name <Storage> -Storage -ClusterName <HCI01> -AdapterName <pNIC03, pNIC04>
    ```

## Next steps

Learn about the [two-node storage switchless, one switch network pattern](two-node-switchless-single-switch.md).