---
title: Azure Stack HCI two-node storage switched, non-converged deployment network reference pattern
description: Plan to deploy an Azure Stack HCI two-node storage switched, non-converged network reference pattern.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 12/02/2022
---

# Review two-node storage switched, non-converged deployment network reference pattern for Azure Stack HCI

[!INCLUDE [includes](../../includes/hci-applies-to-22h2-21h2.md)]

In this article, you'll learn about the two-node storage switched, non-converged, two-TOR-switch network reference pattern that you can use to deploy your Azure Stack HCI solution. The information in this article will also help you determine if this configuration is viable for your deployment planning needs. This article is targeted towards the IT administrators who deploy and manage Azure Stack HCI in their datacenters.

For information on other network patterns, see [Azure Stack HCI network deployment patterns](choose-network-pattern.md).

## Scenarios

Scenarios for this network pattern include laboratories, factories, branch offices, and datacenter facilities.

Deploy this pattern for enhanced network performance of your system and if you plan to add additional nodes. East-West storage traffic replication won't interfere or compete with north-sound traffic dedicated for management and compute. Logical network configuration when adding additional nodes are ready without requiring workload downtime or physical connection changes. SDN L3 services are fully supported on this pattern.

Routing services such as BGP can be configured directly on the TOR switches if they support L3 services. Network security features such as microsegmentation and QoS don't require extra configuration on the firewall device as they're implemented at the virtual network adapter layer.

## Physical connectivity components

As described in the diagram below, this pattern has the following physical network components:

- For northbound/southbound traffic, the cluster in this pattern is implemented with two TOR switches in MLAG configuration.

- Two teamed network cards to handle management and compute traffic connected to two TOR switches. Each NIC is connected to a different TOR switch.

- Two RDMA NICs in standalone configuration. Each NIC is connected to a different TOR switch. SMB multichannel capability provides path aggregation and fault tolerance.

- As an option, deployments can include a BMC card to enable remote management of the environment. Some solutions might use a headless configuration without a BMC card for security purposes.

:::image type="content" source="media/two-node-switched-non-converged/physical-components-layout.png" alt-text="Diagram showing two-node switchless physical connectivity layout." lightbox="media/two-node-switched-non-converged/physical-components-layout.png":::

|Networks|Management & compute|Storage|BMC|
|--|--|--|--|
|Link speed|At least 1 Gbps. 10 Gbps recommended|At least 10 Gbps|Check with hardware manufacturer|
|Interface type|RJ45, SFP+ or SFP28|SFP+ or SFP28|RJ45|
|Ports and aggregation|Two teamed ports|Two standalone ports|One port|

## Network ATC intents

:::image type="content" source="media/two-node-switched-non-converged/network-atc.png" alt-text="Diagram showing two-node switchless Network ATC intents" lightbox="media/two-node-switched-non-converged/network-atc.png":::

### Management & compute intent

- Intent type: Management and compute
- Intent mode: Cluster mode
- Teaming: Yes. pNIC01 and pNIC02 are teamed
- Default management VLAN: Configured VLAN for management adapters isn’t modified
- PA & compute VLANs and vNICs: Network ATC is transparent to PA vNICs and VLAN or compute VM vNICs and VLANs

### Storage intent

- Intent Type: Storage
- Intent Mode: Cluster mode
- Teaming: pNIC03 and pNIC04 use SMB Multichannel to provide resiliency and bandwidth aggregation
- Default VLANs:
    - 711 for storage network 1
    - 712 for storage network 2
- Default subnets:
    - 10.71.1.0/24 for storage network 1
    - 10.71.2.0/24 for storage network 2

Follow these steps to create network intents for this reference pattern:

1. Run PowerShell as administrator.
1. Run the following commands:

    ```powershell
    Add-NetIntent -Name <Management_Compute> -Management -Compute -ClusterName <HCI01> -AdapterName <pNIC01, pNIC02>
    Add-NetIntent -Name <Storage> -Storage -ClusterName <HCI01> -AdapterName <pNIC03, pNIC04>
    ```

## Logical connectivity components

As illustrated in the diagram below, this pattern has the following logical network components:

:::image type="content" source="media/two-node-switched-non-converged/logical-components-layout.png" alt-text="Diagram showing two-node physical connectivity layout." lightbox="media/two-node-switched-non-converged/logical-components-layout.png":::

### Storage Network VLANs

The storage intent-based traffic consists of two individual networks supporting RDMA traffic. Each interface is dedicated to a separate storage network, and both can use the same VLAN tag.

The storage adapters operate in different IP subnets. Each storage network uses the ATC predefined VLANs by default (711 and 712). However, these VLANs can be customized if necessary. In addition, if the default subnet defined by ATC isn't usable, you're responsible for assigning all storage IP addresses in the cluster.

For more information, see [Network ATC overview](/concepts/network-atc-overview.md).

[!INCLUDE [includes](includes/hci-patterns-two-node.md)]

## Next steps

Learn about the [two-node storage switched, fully converged network pattern](two-node-switched-converged.md).