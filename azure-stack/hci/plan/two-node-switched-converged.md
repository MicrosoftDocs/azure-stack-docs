---
title: Azure Stack HCI two-node storage switched, fully-converged deployment network reference pattern
description: Plan to deploy an Azure Stack HCI two-node storage switched, fully-converged network reference pattern.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/03/2022
---

# Review two-node storage switched, fully-converged deployment network reference pattern for Azure Stack HCI

[!INCLUDE [includes](includes/hci-patterns-versions.md)]

In this article, you'll learn about the two-node storage switched, fully converged with two TOR switches network reference pattern that you can use to deploy your Azure Stack HCI solution. The information in this article will also help you determine if this configuration is viable for your deployment planning needs. This article is targeted towards the IT administrators who deploy and manage Azure Stack HCI in their datacenters.

For information on other network patterns, see [Azure Stack HCI network deployment patterns](choose-network-pattern.md).

## Scenarios

Scenarios for this network pattern include laboratories, branch offices, and datacenter facilities.

Consider this pattern if you plan to add additional nodes and your bandwidth requirements for north-south traffic don't require dedicated adapters. This solution might be a good option when physical switch ports are scarce and you're looking for cost reductions for your solution. This pattern requires additional operational costs to fine-tune the shared host network adapters QoS policies to protect storage traffic from workload and management traffic. SDN L3 services are fully supported on this pattern.

Routing services such as BGP can be configured directly on the TOR switches if they support L3 services. Network security features such as microsegmentation and QoS don't require extra configuration on the firewall device as they're implemented at the virtual network adapter layer.

## Physical connectivity components

As described in the diagram below, this pattern has the following physical network components:

- For northbound/southbound traffic, the cluster in this pattern is implemented with two TOR switches in MLAG configuration.

- Two teamed network cards handle the management, compute, and RDMA storage traffic connected to the TOR switches. Each NIC is connected to a different TOR switch. SMB multichannel capability provides path aggregation and fault tolerance.

- As an option, single-node deployments can include a BMC card to enable remote management of the environment. Some solutions might use a headless configuration without a BMC card for security purposes.

:::image type="content" source="media/two-node-switched-converged/physical-components-layout.png" alt-text="Diagram showing two-node switchless physical connectivity layout" lightbox="media/two-node-switched-converged/physical-components-layout.png":::

|Networks|Management, compute, storage|Storage|BMC|
|--|--|--|--|
|Link speed|At 10 Gbps|Check with hardware manufacturer|
|Interface type|SFP+ or SFP28|RJ45|
|Ports and aggregation|Two teamed ports|One port|

## Network ATC intents

:::image type="content" source="media/two-node-switched-converged/network-atc.png" alt-text="Diagram showing two-node switchless Network ATC intents" lightbox="media/two-node-switched-converged/network-atc.png":::

### Management, compute, and storage intent

- Intent Type: Management, compute, and storage
- Intent Mode: Cluster mode
- Teaming: Yes. pNIC01 and pNIC02 are teamed
- Default Management VLAN: Configured VLAN for management adapters isn’t modified
- Storage vNIC 1:
    - VLAN 711
    - Subnet 10.71.1.0/24 for storage network 1
- Storage vNIC 2:
    - VLAN 712
    - Subnet 10.71.2.0/24 for storage network 2
- Storage vNIC1 and storage vNIC2 use SMB Multichannel to provide resiliency and bandwidth aggregation
- PA VLAN and vNICs: Network ATC is transparent to PA vNICs and VLAN
- Compute VLANs and vNICs: Network ATC is transparent to compute VM vNICs and VLANs

For more information, see [Deploy host networking](/deploy/network-atc.md).

Follow these steps to create network intents for this reference pattern:

1. Run PowerShell as administrator.
1. Run the following command:

    ```powershell
    Add-NetIntent -Name <Management_Compute> -Management -Compute -Storage -ClusterName <HCI01> -AdapterName <pNIC01, pNIC02>
    ```

## Logical connectivity components

As illustrated in the diagram below, this pattern has the following logical network components:

:::image type="content" source="media/two-node-switched-converged/logical-components-layout.png" alt-text="Diagram showing single-node switchless physical connectivity layout" lightbox="media/two-node-switched-converged/logical-components-layout.png":::

### Storage Network VLANs

The storage intent-based traffic in this pattern shares the physical network adapters with management and compute.

The storage network operates in different IP subnets. Each storage network uses the ATC predefined VLANs by default (711 and 712). However, these VLANs can be customized if necessary. In addition, if the default subnet defined by ATC isn't usable, you're responsible for assigning all storage IP addresses in the cluster.

For more information, see [Network ATC overview](/concepts/network-atc-overview.md).

[!INCLUDE [includes](includes/hci-patterns-two-node-include.md)]

## Next steps

Learn about the [two-node storage switched, non-converged network pattern](two-node-switched-non-converged.md).