---
title: Azure Stack HCI single node storage deployment network reference pattern
description: Plan to deploy an Azure Stack HCI single-node storage network reference pattern.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/27/2022
---

# Review single-node storage deployment network reference pattern for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

In this article, you'll learn about the single-node storage network reference pattern that you can use to deploy your Azure Stack HCI solution. The information in this article will also help you determine if this configuration is viable for your deployment planning needs. This article is targeted towards the IT administrators who deploy and manage Azure Stack HCI in their datacenters.

For information on other network patterns, see [Azure Stack HCI network deployment patterns](choose-network-pattern.md).

## Introduction

Single-node deployments provide cost and space benefits while helping to modernize your infrastructure and bring Azure hybrid computing to locations that can tolerate the resiliency of a single server. Azure Stack HCI running on a single-server behaves similarly to Azure Stack HCI on a multi-node cluster: it brings native Azure Arc integration, the ability to add servers to scale out the cluster, and it includes the same [Azure benefits](/azure-stack/hci/manage/azure-benefits.md).

It also supports the same workloads, such as Azure Virtual Desktop (AVD) and Azure Kubernetes Service (AKS) on Azure Stack HCI, and is supported and billed the same way.

## Scenarios

Use the single-node storage pattern in the following scenarios:

- **Facilities that can tolerate lower level of resiliency**. Consider implementing this pattern whenever your location or service provided by this pattern can tolerate a lower level of resiliency without impacting your business.

- **Food, healthcare, finance, retail, government facilities**. Some food, healthcare, finance, and retail scenarios can apply this option to minimize their costs without impacting core operations and business transactions.

Although Software Defined Networking (SDN) Layer 3 (L3) services are fully supported on this pattern, routing services such as Border Gateway Protocol (BGP) may need to be configured for the firewall device on the top-of-rack (TOR) switch.

Network security features such as microsegmentation and Quality of Service (QoS) don't require extra configuration for the firewall device, as they're implemented at the virtual network adapter layer. For more information, see [Microsegmentation with Azure Stack HCI](https://techcommunity.microsoft.com/t5/azure-stack-blog/microsegmentation-with-azure-stack-hci/ba-p/2276339).

## Physical connectivity components

As illustrated in the diagram below, this pattern has the following physical network components:

- For northbound/southbound traffic, the Azure Stack HCI cluster is implemented using a single TOR L2 or L3 switch.
- Two teamed network ports to handle the management and compute traffic connected to the switch.
- Two disconnected RDMA NICs that are only used if add a second server to your cluster for scale-out. This means no increased costs for cabling or physical switch ports.
- (Optional) A BMC card can be used to enable remote management of your environment. For security purposes, some solutions might use a headless configuration without the BMC card.

:::image type="content" source="media/single-node-switchless/physical-connectivity-layout.png" alt-text="Diagram showing single-node physical connectivity layout" lightbox="media/single-node-switchless/physical-connectivity-layout.png":::

The following table lists some guidelines for a single-node deployment:

|Network|Management & compute|Storage|BMC|
|--|--|--|--|
|Link speed|At least 1 Gbps; 10 Gbps recommended.|At least 1 Gbps; 10 GBps recommended.|Check with hardware manufacturer.|
|Interface type|RJ45, SFP+, or SFP28|SFP+ or SFP28|RJ45|
|Ports and aggregation|Two teamed ports|Optional to allow adding a second server; disconnected ports.|One port|
|RDMA|Optional. Depends on requirements for guest RDMA and NIC support.|N/A|N/A|

## Network ATC intents

The single-node pattern uses only one Network ATC intent for management and compute traffic. The RDMA network interfaces are optional and disconnected.

:::image type="content" source="media/single-node-switchless/network-atc.png" alt-text="Diagram showing Network ATC intents for the single-node switchless pattern" lightbox="media/single-node-switchless/network-atc.png":::

### Management and compute intent

The management and compute intent has the following characteristics:

- Intent type: Management and compute
- Intent mode: Cluster mode
- Teaming: Yes - pNIC01 and pNIC02 are teamed
- Default management VLAN: Configured VLAN for management adapters is ummodified
- PA VLAN and vNICs: Network ATC is transparent to PA vNICs and VLANs
- Compute VLANs and vNICs: Network ATC is transparent to compute VM vNICs and VLANs

### Storage intent

The storage intent has the following characteristics:

- Intent type: None
- Intent mode: None
- Teaming: pNIC03 and pNIC04 are disconnected
- Default VLANs: None
- Default subnets: None

Follow these steps to create a network intent for this reference pattern:

1. Run PowerShell as Administrator.
1. Run the following command:

    ```powershell
    Add-NetIntent -Name <management_compute> -Management -Compute -ClusterName <HCI01> -AdapterName <pNIC01, pNIC02>
    ```

For more information, see [Deploy host networking: Compute and management intent](/deploy/network-atc.md#compute-and-management-intent).

## Logical network components

As illustrated in the diagram below, this pattern has the following logical network components:

:::image type="content" source="media/single-node-switchless/logical-connectivity-layout.png" alt-text="Diagram showing single-node switchless logical connectivity layout" lightbox="media/single-node-switchless/logical-connectivity-layout.png":::

### Storage network VLANs

Optional - this pattern doesn't require a storage network.

[!INCLUDE [includes](includes/single-node-include.md)]

## Next steps

Learn about two-node patterns - [Azure Stack HCI network deployment patterns](choose-network-pattern.md).