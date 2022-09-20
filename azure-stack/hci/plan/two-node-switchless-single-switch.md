---
title: Azure Stack HCI two-node storage switchless deployment network reference pattern
description: Plan to deploy an Azure Stack HCI two-node storage switchless network reference pattern.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/20/2022
---

# Review two-node storage switchless, single switch deployment network reference pattern for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

In this article, you'll learn about the two-node storage switchless with single TOR switch network reference pattern that you can use to deploy your Azure Stack HCI solution. The information in this article will also help you determine if this configuration is viable for your deployment planning needs. This article is targeted towards the IT administrators who deploy and manage Azure Stack HCI in their datacenters.

For information on other network patterns, see [Azure Stack HCI network deployment patterns](choose-network-pattern.md).

## Scenarios

Scenarios for this network pattern include laboratories, factories, retail stores, and government facilities.

Consider to implement this pattern when looking for a cost efficient solution that includes fault tolerance capabilities at cluster level, but can tolerate northbound connectivity interruptions if the single physical switch fails or requires some maintenance routine. 

It is possible to scale out this pattern, but it will require workload downtime to reconfigure storage physical connectivity and storage network reconfiguration. Although SDN L3 services are fully supported for this pattern, the routing services such as BGP will need to be configured on the firewall device on top of the TOR switch if it does not support L3 services. Network security feature such as micro-segmentation or QoS do not require additional configuration on the firewall device, as they are implemented on the virtual switch.

## Physical connectivity components

As illustrate in the diagram below, this pattern has the following physical network components:

- Single TOR switch for north-south traffic communication.

- Two teamed network ports to handle management and compute traffic, connected to the L2 switch on each host

- Two RDMA NICs in a full-mesh configuration for east-west traffic for storage. Each node in the cluster has a redundant connection to the other node in the cluster.

- As an option, some solutions might use a headless configuration without a BMC card for security purposes.

:::image type="content" source="media/two-node-switchless-single-switch/physical-components-layout.png" alt-text="Diagram showing two-node switchless physical connectivity layout" lightbox="media/two-node-switchless-single-switch/physical-components-layout.png":::

|Networks|Management & compute|Storage|BMC|
|--|--|--|--|
|Link speed|At least 1 GBps. 10 GBps recommended|At least 10 GBps|Check with hardware manufacturer|
|Interface type|RJ45, SFP+ or SFP28|SFP+ or SFP28|RJ45|
|Ports and aggregation|Two teamed ports|Two standalone ports|One port|

## Network ATC intents

:::image type="content" source="media/two-node-switchless-single-switch/network-atc.png" alt-text="Diagram showing two-node switchless Network ATC intents" lightbox="media/two-node-switchless-single-switch/network-atc.png":::

## Logical connectivity components

### Storage Network VLANs

The storage intent-based traffic consists of two individual networks supporting RDMA traffic. Each interface will be dedicated to a separate storage network, and both may utilize the same VLAN tag. This traffic is only intended to travel between the two nodes. Storage traffic is a private network without connectivity to other resources.

The storage adapters operate on different IP subnets. To enable a switchless configuration, each connected node supports a matching subnet of its neighbor. Each storage network uses the Network ATC predefined VLANs by default (711 and 712). However, these VLANs can be customized if required. In addition, if the default subnets defined by Network ATC (10.71.1.0/24 and 10.71.2.0/24) are not usable, you are responsible for assigning all storage IP addresses in the cluster.

:::image type="content" source="media/two-node-switchless-single-switch/logical-components-layout.png" alt-text="Diagram showing single-node switchless physical connectivity layout" lightbox="media/two-node-switchless-single-switch/logical-components-layout.png":::

[!INCLUDE [includes](includes/two-node-include.md)]

## Next steps

Learn about the [two-node storage switchless, two switches network pattern](two-node-switchless-two-switches.md).