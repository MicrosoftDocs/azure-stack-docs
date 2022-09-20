---
title: Review single-node storage reference pattern components for Azure Stack HCI
description: Learn about single-node storage reference pattern components for Azure Stack HCI.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/21/2022
---

# Review single-node storage reference pattern components for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

In this article, you'll learn about which network components get deployed for single-node reference patterns, as shown below:

:::image type="content" source="media/single-node-components/components.png" alt-text="Diagram showing components for single-node network pattern" lightbox="media/single-node-components/components.png":::

## Components running on VMs

The following table lists all the components running on VMs for a single-node network pattern:

|Component|Number of VMs|OS disk size|Data disk size|vCPUs|Memory|
|--|--|--|--|--|--|
|Network Controller|1|100 GB|30 GB|4|4 GB|
|SDN Load Balancers|1|60 GB|30 GB|16|8 GB|
|SDN Gateways|1|60 GB|30 GB|8|8 GB|
|OEM Management|OEM defined|OEM defined|OEM defined|OEM defined|OEM defined|
|**Total**|3 + OEM|270 GB + OEM|90 GB + OEM|32 + OEM|28 GB + OEM|

### Default components

#### Network Controller VM

The Network Controller VM is deployed by default unless it is explicitly opt-out. If Network Controller VM is not deployed, the default access network access policies will not be available. Additionally, it is needed if you have any of the following requirements:

- Create and manage virtual networks. Connect virtual machines (VMs) to virtual network subnets.

- Configure and manage micro-segmentation for VMs connected to virtual networks or traditional VLAN-based networks.

- Attach virtual appliances to your virtual networks.

- Configure Quality of Service (QoS) policies for VMs attached to virtual networks or traditional VLAN-based networks.

#### Tenant VMs

Tenant VMs...

### Optional components

#### SDN Load Balancer VM

This is a first-party software load balancer used to evenly distribute customer network traffic among multiple VMs. It enables multiple servers to host the same workload, providing high availability and scalability. It is also used to provide inbound Network Address Translation (NAT) services for inbound access to virtual machines, and outbound NAT services for outbound connectivity.

#### SDN Gateway VM

This is used for routing network traffic between a virtual network and another network, either local or remote. Gateways can be used to:

- Create secure site-to-site IPsec connections between SDN virtual networks and external customer networks over the internet.

- Create Generic Routing Encapsulation (GRE) connections between SDN virtual networks and external networks. The difference between site-to-site connections and GRE connections is that the latter is not an encrypted connection. For more information about GRE connectivity scenarios, see [GRE Tunneling in Windows Server](/windows-server/remote/remote-access/ras-gateway/gre-tunneling-windows-server.md).

- Create Layer 3 connections between SDN virtual networks and external networks. In this case, the SDN gateway simply acts as a router between your virtual network and the external network.

#### OEM management VM

The OEM managememt VM...

## Host service and agent components

The following components run as services or agents on the host server:

**ARC host agent**: Description here

**NC host agent**: Description here

**Monitor host agent**: ALM managed agent used for emitting observability (telemetry and diagnostics) pipeline data that upload to Geneva (Azure Storage).

**SLB host agent**: Description here

## Next steps

Learn about [single-node IP requirements](single-node-ip-requirements.md).