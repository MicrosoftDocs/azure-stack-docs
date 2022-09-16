---
title: Azure Stack HCI single node storage switched deployment network reference pattern
description: Plan to deploy an Azure Stack HCI single-node storage switched network reference pattern.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/15/2022
---

# Review single-node storage switched deployment network reference pattern for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

In this article, you'll learn about the single-node storage switched network reference pattern that you can use to deploy your Azure Stack HCI solution. The information in this article will also help you determine if this configuration is viable for your deployment planning needs. This article is targeted towards the IT administrators who deploy and manage Azure Stack HCI in their datacenters.

For information on other network patterns, see [Azure Stack HCI network deployment patterns](choose-network-pattern.md).

## Scenarios

Use the single-node storage switched pattern in the following scenarios:

- Branch offices with datacenter services
- Laboratories, factories, retail stores, and government facilities

Consider implementing this pattern whenever if you have plans to scale up your Azure Stack HCI environment beyond a single node. Having storage connectivity already defined and connected to the top of rack (TOR) switches requires minimum planning when adding new nodes to your solution. The new node gets access to management, compute, and storage networks immediately, as long as the physical switch ports connected to the new node belong to the corresponding VLANs for each logical network.

Software Defined Networking (SDN) L3 services are fully supported on this pattern. Routing services such as BGP can be configured directly on the TOR switches if they support L3 services.

Network security features such as microsegmentation and Quality of Service (QoS) don't require extra configuration for the firewall device, as they're implemented at the virtual network adapter layer. For more information, see [Microsegmentation with Azure Stack HCI]https://techcommunity.microsoft.com/t5/azure-stack-blog/microsegmentation-with-azure-stack-hci/ba-p/2276339).

## Physical connectivity components

As illustrated in the diagram below, this pattern has the following physical network components:

- For northbound/southbound communication, the Azure Stack HCI cluster in this pattern is implemented with two TOR switches in multi-chassis link aggregation (MLAG) configuration.
- Two teamed network ports handle the management and compute traffic, and are connected to the TOR switches.
- Two RDMA NICs in standalone configuration. Each NIC is connected to a different TOR. SMB multichannel capability provides path aggregation and fault tolerance.
- As an option, single-node deployments can include a BMC card to enable remote management of the environment. Some solutions might use a headless configuration without a BMC card for security purposes.

:::image type="content" source="media/single-node-switched/physical-connectivity-layout.png" alt-text="Diagram showing single-node switched physical connectivity layout" lightbox="media/single-node-switched/physical-connectivity-layout.png":::

|Networks|Management & compute|Storage|BMC|
|--|--|--|--|
|Link speed|At least 1 GBps. 10 GBps recommended|At least 10 GBps.|Check with hardware manufacturer|
|Interface type|RJ45, SFP+ or SFP28|SFP+ or SFP28|RJ45|
|Ports and aggregation|Two teamed ports|Two standalone ports|One port|

## Network ATC intents

For the single-node storage switched pattern, two Network ATC intents are created. The first intent is used for management and compute network traffic, and the second intent is used for storage traffic.

:::image type="content" source="media/single-node-switched/network-atc.png" alt-text="Diagram showing Network ATC intents for the single-node switched pattern" lightbox="media/single-node-switched/network-atc.png":::

### Management and compute intent

- Intent type: Management and compute
- Intent mode: Cluster mode
- Teaming: Yes - pNIC01 and pNIC02 are teamed
- Default management VLAN: Configured VLAN for management adapters isn’t modified
- PA VLAN and vNICs: Network ATC is transparent to PA vNICs and VLANs
- Compute VLANs and vNICs: Network ATC is transparent to PA vNICs and VLANs and to compute VM vNICs and VLANs.

### Storage intent

- Intent type: None
- Intent mode: None
- Teaming: No. pNIC03 and pNIC04 use SMB Multichannel to provide resiliency and bandwidth aggregation
- Default VLANs:
    - 711 for storage network 1
    - 712 for storage network 2
- Default subnets:
    - 10.71.1.0/24 for storage network 1
    - 10.71.2.0/24 for storage network 2

Follow these steps to create network intents for this reference pattern:

1. Run PowerShell as administrator.
1. Run the following command:

    ```powershell
    Add-NetIntent -Name <Management_Compute> -Management -Compute -ClusterName <HCI01> -AdapterName <pNIC01, pNIC02>
    Add-NetIntent -Name <Storage> -Storage -ClusterName <HCI01> -AdapterName <pNIC03, pNIC04>
    ```

For more information, see [Deploy host networking: Compute and management intent](/azure-stack/hci/deploy/network-atc.md#compute-and-management-intent).

## Logical networks

As illustrated in the diagram below, this pattern has the following logical network components:

:::image type="content" source="media/single-node-switched/logical-connectivity-layout.png" alt-text="Diagram showing single-node switched logical connectivity layout" lightbox="media/single-node-switched/logical-connectivity-layout.png":::

### Storage network VLANs

The storage intent-based traffic consists of two individual networks supporting RDMA traffic. Each interface is dedicated to a separate storage network, although both may use the same VLAN tag. For single-node deployments with RDMA NICs connected to the physical switch, this network can be pre-staged and configured if you are planning to scale up the environment in the future.

The storage adapters operate in different IP subnets. To enable a switchless configuration, each connected node supports a matching subnet of its neighbor. Each storage network uses the ATC-predefined VLANs by default (711 and 712). However, these VLANs can be customized if needed. If the default subnet defined by Network ATC is not usable, you are responsible for assigning all storage IP addresses in the cluster.

For more information, see [Network ATC overview](/concepts/network-atc-overview.md).

[!INCLUDE [includes](includes/single-node-include.md)]

## Next steps

Learn about the [single-node storage switchless network pattern](single-node-switchless.md).