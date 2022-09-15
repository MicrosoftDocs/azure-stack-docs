---
title: Azure Stack HCI single node storage switchless deployment network reference pattern
description: Plan to deploy an Azure Stack HCI single-node storage switchless network reference pattern.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/14/2022
---

# Review single-node storage switchless deployment network reference pattern for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

In this article, you'll learn about the single-node storage switchless network reference pattern that you can use to deploy your Azure Stack HCI. The information in this article will also help you determine if this configuration is viable for your deployment planning needs. This article is targeted towards the IT administrators who deploy and manage Azure Stack HCI in their datacenters.

For information on other network patterns, see [Azure Stack HCI network deployment patterns](test0.md).

## Scenarios

Use the single-node storage switchless pattern in the following scenarios:

- **Facilities that can tolerate lower level of resiliency**. Consider implementing this pattern whenever your location or service provided by this pattern can tolerate the lower level of resiliency without impacting your business.

- **Food, healthcare, finance, retail, government facilities**. Some food, healthcare, finance, and retail scenarios can apply this option to minimize their costs without impacting their core operations and business transactions.

Consider implementing this pattern whenever your location/service provided by this pattern can tolerate the lower level of resiliency without impacting your business. Some food, healthcare, finance, and retail scenarios can apply this option to minimize their costs without impacting their core operations and business transactions. Although Software Defined Networking (SDN) L3 services are fully supported on this pattern, the routing services such as as Border Gateway Protocol (BGP) may need to be configured on the firewall device on top of the rack (TOR) switch..

Network security features such as micro-segmentation or Quality of Service (QoS) don't require extra configuration the firewall device, as they're implemented at virtual network adapter layer. For more information, see [Microsegmentation with Azure Stack HCI]https://techcommunity.microsoft.com/t5/azure-stack-blog/microsegmentation-with-azure-stack-hci/ba-p/2276339).

## Physical connectivity components

As illustrated in the diagram below, this pattern has the following physical network components:

- For northbound/southbound communication, the Azure Stack HCI cluster in this pattern is implemented with a single TOR switch.
- Two network ports in teaming to handle the management and compute traffics, connected to the L2 switch.
- The two RDMA NICs are disconnected as they aren’t used unless you add a second server to the system. There's no need to increase costs on cabling or physical switch ports consumption.
- As an option, single-node deployments can include a BMC card to enable remote management of the environment. Some solutions might use headless configuration without BMC card for security purposes.

:::image type="content" source="media/single-node-switchless/physical-connectivity-layout.png" alt-text="Diagram showing single-node switchless physical connectivity layout" lightbox="media/single-node-switchless/physical-connectivity-layout.png":::

|Networks|Management & compute|Storage|BMC|
|--|--|--|--|
|Link speed|At least 1 GBps. 10 GBps recommended|At least 1 GBps. 10 GBps recommended|Check with hardware manufacturer|
|Interface type|RJ45, SFP+ or SFP28|SFP+ or SFP28|RJ45|
|Ports and aggregation|Two teamed ports|Optional to allow adding a second server. Disconnected Ports|1 port|
|RDMA|Optional. Depends on requirements for Guest RDMA and NIC support|N/A|N/A|

## Network ATC intents

For single-node storage switchless pattern only one Network ATC intent is created for management and compute. RDMA network interfaces are disconnected.

:::image type="content" source="media/single-node-switchless/network-atc.png" alt-text="Diagram showing Network ATC intents for the single-node switchless pattern" lightbox="media/single-node-switchless/network-atc.png":::

### Management and compute intent

- Intent Type: Management and Compute
- Intent Mode: Cluster mode
- Teaming: Yes. pNIC01 and pNIC02 Team
- Default Management VLAN: Configured VLAN for management adapters isn’t modified
- PA VLAN and vNICs: Network ATC is transparent to PA vNICs and VLAN
- Compute VLANs and vNICs: Network ATC is transparent to compute VMs vNICs and VLANs

### Storage intent

- Intent type: None
- Intent mode: None
- Teaming: pNIC03 and pNIC04 are disconnected
- Default VLANs: None
- Default subnets: None

Follow these steps to create network intents for this reference pattern:

1. Run PowerShell as administrator.
1. Run the following command:

    ```powershell
    Add-NetIntent -Name <management_compute> -Management -Compute -ClusterName <HCI01> -AdapterName <pNIC01, pNIC02>
    ```

For more information, see [Deploy host networking: Compute and management intent](/azure-stack/hci/deploy/network-atc.md#compute-and-management-intent).

## Logical networks

As illustrated in the diagram below, this pattern has the following logical network components:

:::image type="content" source="media/single-node-switchless/logical-connectivity-layout.png" alt-text="Diagram showing single-node switchless logical connectivity layout" lightbox="media/single-node-switchless/logical-connectivity-layout.png":::

### Storage network VLANs

This pattern doesn't require a storage network.

### Management VLAN

All physical compute hosts must access the management logical network. For IP address planning purposes, each physical compute host must have at least one IP address assigned from the management logical network.

A DHCP server can automatically assign IP addresses for the management network, or you can manually assign static IP addresses. When DHCP is the preferred IP assignment method, DHCP reservations without expiration are recommended.

The management network supports two different VLAN configurations Native or Tagged traffic:

- Native VLAN configuration, the customer isn't required to supply a VLAN ID. Required for solution-based installations.

- Tagged VLAN will be supplied by the customer at the time of deployment.
The Management network supports traffic used by the administrator for management of the cluster including Remote Desktop, Windows Admin Center, Active Directory, etc.

For more information, see [Plan an SDN infrastructure: Management and HNV Provider](/azure-stack/hci/concepts/plan-software-defined-networking-infrastructure.md#management-and-hnv-provider).

[!INCLUDE [includes](includes/single-node-include.md)]

## Next steps

Learn about the [single-node storage switched network pattern](single-node-switchless.md).