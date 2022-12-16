---
title: Azure Stack HCI two-node storage switchless deployment network reference pattern
description: Plan to deploy an Azure Stack HCI two-node storage switchless network reference pattern.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/10/2022
---

# Review two-node storage switchless, single switch deployment network reference pattern for Azure Stack HCI

[!INCLUDE [includes](../../includes/hci-applies-to-22h2-21h2.md)]

In this article, you'll learn about the two-node storage switchless with single TOR switch network reference pattern that you can use to deploy your Azure Stack HCI solution. The information in this article will also help you determine if this configuration is viable for your deployment planning needs. This article is targeted towards the IT administrators who deploy and manage Azure Stack HCI in their datacenters.

For information on other network patterns, see [Azure Stack HCI network deployment patterns](choose-network-pattern.md).

## Scenarios

Scenarios for this network pattern include laboratories, factories, retail stores, and government facilities.

Consider this pattern for a cost-effective solution that includes fault-tolerance at the cluster level, but can tolerate northbound connectivity interruptions if the single physical switch fails or requires maintenance.

You can scale out this pattern, but it will require workload downtime to reconfigure storage physical connectivity and storage network reconfiguration. Although SDN L3 services are fully supported for this pattern, the routing services such as BGP will need to be configured on the firewall device on top of the TOR switch if it doesn't support L3 services. Network security features such as microsegmentation and QoS don't require extra configuration on the firewall device, as they're implemented on the virtual switch.

## Physical connectivity components

As illustrate in the diagram below, this pattern has the following physical network components:

- Single TOR switch for north-south traffic communication.

- Two teamed network ports to handle management and compute traffic, connected to the L2 switch on each host

- Two RDMA NICs in a full-mesh configuration for east-west traffic for storage. Each node in the cluster has a redundant connection to the other node in the cluster.

- As an option, some solutions might use a headless configuration without a BMC card for security purposes.

:::image type="content" source="media/two-node-switchless-single-switch/physical-components-layout.png" alt-text="Diagram showing two-node switchless physical connectivity layout." lightbox="media/two-node-switchless-single-switch/physical-components-layout.png":::

|Networks|Management and compute|Storage|BMC|
|--|--|--|--|
|Link speed|At least 1 Gbps. 10 Gbps recommended|At least 10 Gbps|Check with hardware manufacturer|
|Interface type|RJ45, SFP+ or SFP28|SFP+ or SFP28|RJ45|
|Ports and aggregation|Two teamed ports|Two standalone ports|One port|

## Network ATC intents

For two-node storage switchless patterns, two Network ATC intents are created. The first for management and compute network traffic, and the second for storage traffic.

:::image type="content" source="media/two-node-switchless-single-switch/network-atc.png" alt-text="Diagram showing two-node switchless Network ATC intents" lightbox="media/two-node-switchless-single-switch/network-atc.png":::

### Management and compute intent

- Intent Type: Management and compute
- Intent Mode: Cluster mode
- Teaming: Yes. pNIC01 and pNIC02 are teamed
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

For more information, see [Deploy host networking](../deploy/network-atc.md).

Follow these steps to create network intents for this reference pattern:

1. Run PowerShell as administrator.
1. Run the following command:

    ```powershell
    Add-NetIntent -Name <Management_Compute> -Management -Compute -ClusterName <HCI01> -AdapterName <pNIC01, pNIC02>
    Add-NetIntent -Name <Storage> -Storage -ClusterName <HCI01> -AdapterName <pNIC03, pNIC04>
    ```

## Logical connectivity components

As illustrated in the diagram below, this pattern has the following logical network components:

:::image type="content" source="media/two-node-switchless-single-switch/logical-components-layout.png" alt-text="Diagram showing single-node switchless physical connectivity layout." lightbox="media/two-node-switchless-single-switch/logical-components-layout.png":::

### Storage Network VLANs

The storage intent-based traffic consists of two individual networks supporting RDMA traffic. Each interface will be dedicated to a separate storage network, and both may utilize the same VLAN tag. This traffic is only intended to travel between the two nodes. Storage traffic is a private network without connectivity to other resources.

The storage adapters operate on different IP subnets. To enable a switchless configuration, each connected node supports a matching subnet of its neighbor. Each storage network uses the Network ATC predefined VLANs by default (711 and 712). However, these VLANs can be customized if necessary. In addition, if the default subnets defined by Network ATC (10.71.1.0/24 and 10.71.2.0/24) aren't usable, you're responsible for assigning all storage IP addresses in the cluster.

For more information, see [Network ATC overview](../concepts/network-atc-overview.md).

[!INCLUDE [includes](includes/hci-patterns-two-node.md)]

## Next steps

Learn about the [two-node storage switchless, two switches network pattern](two-node-switchless-two-switches.md).