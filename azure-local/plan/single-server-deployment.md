---
title: Azure Local single node storage deployment network reference pattern
description: Plan to deploy an Azure Local single-server storage network reference pattern.
ms.topic: how-to
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
ms.date: 02/15/2025
---

# Review single-server storage deployment network reference pattern for Azure Local

[!INCLUDE [includes](../includes/hci-applies-to-23h2-22h2.md)]

This article describes the single-server storage network reference pattern that you can use to deploy your Azure Local solution. The information in this article also helps you determine if this configuration is viable for your deployment planning needs. This article is targeted towards the IT administrators who deploy and manage Azure Local in their datacenters.

For information about other network patterns, see [Azure Local network deployment patterns](choose-network-pattern.md).

## Introduction

Single-server deployments provide cost and space benefits while helping to modernize your infrastructure and bring Azure hybrid computing to locations that can tolerate the resiliency of a single machine. Azure Local running on a single machine behaves similarly to Azure Local on a multi-node cluster: it brings native Azure Arc integration, the ability to add servers to scale out the system, and it includes the same [Azure benefits](../manage/azure-benefits.md).

It also supports the same workloads, such as Azure Virtual Desktop (AVD) and AKS on Azure Local, and is supported and billed the same way.

## Scenarios

Use the single-server storage pattern in the following scenarios:

- **Facilities that can tolerate lower level of resiliency**. Consider implementing this pattern whenever your location or service provided by this pattern can tolerate a lower level of resiliency without impacting your business.

- **Food, healthcare, finance, retail, government facilities**. Some food, healthcare, finance, and retail scenarios can apply this option to minimize their costs without impacting core operations and business transactions.

Although Software Defined Networking (SDN) Layer 3 (L3) services are fully supported on this pattern, routing services such as Border Gateway Protocol (BGP) may need to be configured for the firewall device on the top-of-rack (TOR) switch.

Network security features such as microsegmentation and Quality of Service (QoS) don't require extra configuration for the firewall device, as they're implemented at the virtual network adapter layer. For more information, see [Microsegmentation with Azure Local](https://techcommunity.microsoft.com/t5/azure-stack-blog/microsegmentation-with-azure-stack-hci/ba-p/2276339).

> [!NOTE]
> Single servers must use only a single drive type: Non-volatile Memory Express (NVMe) or Solid-State (SSD) drives.

## Physical connectivity components

As illustrated in the diagram below, this pattern has the following physical network components:

- For northbound/southbound traffic, the Azure Local instance is implemented using a single TOR L2 or L3 switch.
- Two teamed network ports to handle the management and compute traffic connected to the switch.
- Two disconnected RDMA NICs that are only used if add a second server to your system for scale-out. This means no increased costs for cabling or physical switch ports.
- (Optional) A BMC card can be used to enable remote management of your environment. For security purposes, some solutions might use a headless configuration without the BMC card.

:::image type="content" source="media/single-server/physical-connectivity-layout.png" alt-text="Diagram showing single-server physical connectivity layout." lightbox="media/single-server/physical-connectivity-layout.png":::

The following table lists some guidelines for a single-server deployment:

|Network|Management & compute|Storage|BMC|
|--|--|--|--|
|Link speed|At least 1Gbps if RDMA is disabled, 10Gbps recommended.|At least 10Gbps.|Check with hardware manufacturer.|
|Interface type|RJ45, SFP+, or SFP28|SFP+ or SFP28|RJ45|
|Ports and aggregation|Two teamed ports|Optional to allow adding a second server; disconnected ports.|One port|
|RDMA|Optional. Depends on requirements for guest RDMA and NIC support.|N/A|N/A|

## Network ATC intents

The single-server pattern uses only one Network ATC intent for management and compute traffic. The RDMA network interfaces are optional and disconnected.

:::image type="content" source="media/single-server/network-atc.png" alt-text="Diagram showing Network ATC intents for the single-server switchless pattern." lightbox="media/single-server/network-atc.png":::

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

For more information, see [Deploy host networking: Compute and management intent](../deploy/network-atc.md#compute-and-management-intent).

## Logical network components

As illustrated in the diagram below, this pattern has the following logical network components:

:::image type="content" source="media/single-server/logical-connectivity-layout.png" alt-text="Diagram showing single-server logical connectivity layout." lightbox="media/single-server/logical-connectivity-layout.png":::

### Storage network VLANs

Optional - this pattern doesn't require a storage network.

[!INCLUDE [includes](../includes/hci-patterns-single-node.md)]

## Next steps

Learn about [Two-node Azure Local network deployment patterns](choose-network-pattern.md).
