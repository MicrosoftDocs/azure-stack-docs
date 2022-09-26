---
title: Review single-node storage reference pattern components for Azure Stack HCI
description: Learn about single-node storage reference pattern components for Azure Stack HCI.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 09/26/2022
---

# Review single-node storage reference pattern components for Azure Stack HCI

> Applies to: Azure Stack HCI, version 21H2, Azure Stack HCI, version 22H2 (preview)

In this article, you'll learn about which network components are deployed for the single-node reference pattern, as shown in the following diagram:

:::image type="content" source="media/single-node-components/components.png" alt-text="Diagram showing components for single-node network pattern" lightbox="media/single-node-components/components.png":::

## Components running on VMs

The following table lists the various components running on virtual machines (VMs) for a single-node network pattern:

|Component|Number of VMs|OS disk size|Data disk size|vCPUs|Memory|
|--|--|--|--|--|--|
|Network Controller|1|100 GB|30 GB|4|4 GB|
|SDN Software Load Balancers|1|60 GB|30 GB|16|8 GB|
|SDN Gateways|1|60 GB|30 GB|8|8 GB|
|OEM Management|OEM defined|OEM defined|OEM defined|OEM defined|OEM defined|
|**Total**|3 + OEM|270 GB + OEM|90 GB + OEM|32 + OEM|28 GB + OEM|

### Default components

The following default components run on VMs:

#### SDN Network Controller VM

The Network Controller VM is deployed by default unless it is explicitly not deployed. If a Network Controller VM is not deployed, default network access policies are not available. A Network Controller VM is needed if you have any of the following requirements:

- Create and manage virtual networks or connect VMs to virtual network subnets.

- Configure and manage microsegmentation for VMs connected to virtual networks or traditional VLAN-based networks.

- Attach virtual appliances to your virtual networks.

- Configure Quality of Service (QoS) policies for VMs attached to virtual networks or traditional VLAN-based networks.

#### Tenant VMs

Tenant VMs...

### Optional components

The following components are optional for VMs:

#### SDN Software Load Balancer VM

The SDN Software Load Balancer (SLB) VM is used to evenly distribute network traffic among multiple VMs. It enables multiple servers to host the same workload, providing high availability and scalability. It is also used to provide inbound Network Address Translation (NAT) services for inbound access to VMs, and outbound NAT services for outbound connectivity.

#### SDN Gateway VM

THe SDN Gateway VM is used to route network traffic between a virtual network and another network, either local or remote. SDN Gateways can be used to:

- Create secure site-to-site IPsec connections between SDN virtual networks and external networks over the internet.

- Create Generic Routing Encapsulation (GRE) connections between SDN virtual networks and external networks. The difference between site-to-site connections and GRE connections is that the latter is not an encrypted connection. For more information about GRE connectivity, see [GRE Tunneling in Windows Server](/windows-server/remote/remote-access/ras-gateway/gre-tunneling-windows-server.md).

- Create Layer 3 (L3) connections between SDN virtual networks and external networks. In this case, SDN Gateway simply acts as a router between your virtual network and the external network.

#### OEM management VM

The OEM managememt VM...

## Host agents

The following components run as services or agents on the host server:

**ARC Host agent**: Enables you to manage your Windows and Linux machines hosted outside of Azure on your corporate network or other cloud providers.

**NC host agent**: Allows Network Controller to manage the goal state of the data plane, and to receive notification of events as the configuration of the data plane changes.

**Monitor host agent**: An ALM-managed agent used for telemetry and diagnostics pipeline data that is uploaded to Microsoft Geneva (Azure Storage).

**SLB host agent**: Listens for SLB policy updates from the network controller. In addition, programs rules for SLB into the SDN-enabled Hyper-V virtual switches that are configured on the local computer.

## Next steps

Learn about [single-node IP requirements](single-node-ip-requirements.md).