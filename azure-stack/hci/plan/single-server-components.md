---
title: Review single-server storage reference pattern components for Azure Stack HCI
description: Learn about single-server storage reference pattern components for Azure Stack HCI.
ms.topic: conceptual
author: dansisson
ms.author: v-dansisson
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/03/2022
---

# Review single-server storage reference pattern components for Azure Stack HCI

[!INCLUDE [includes](includes/hci-patterns-versions.md)]

In this article, you'll learn about which network components are deployed for the single-server reference pattern, as shown in the following diagram:

:::image type="content" source="media/single-server-components/components.png" alt-text="Diagram showing components for single-server network pattern" lightbox="media/single-server-components/components.png":::

### Optional components

The following are optional components. For more information on Software Defined Networking (SDN), see  [Plan a Software Defined Network infrastructure](/concepts/plan-software-defined-networking-infrastructure.md).

#### SDN Network Controller VM

The Network Controller VM is optionally deployed. If a Network Controller VM is not deployed, default network access policies are not available. A Network Controller VM is needed if you have any of the following requirements:

- Create and manage virtual networks or connect VMs to virtual network subnets.

- Configure and manage microsegmentation for VMs connected to virtual networks or traditional VLAN-based networks.

- Attach virtual appliances to your virtual networks.

- Configure Quality of Service (QoS) policies for VMs attached to virtual networks or traditional VLAN-based networks.

#### SDN Software Load Balancer VM

The SDN Software Load Balancer (SLB) VM is used to evenly distribute network traffic among multiple VMs. It enables multiple servers to host the same workload, providing high availability and scalability. It is also used to provide inbound Network Address Translation (NAT) services for inbound access to VMs, and outbound NAT services for outbound connectivity.

#### SDN Gateway VM

THe SDN Gateway VM is used to route network traffic between a virtual network and another network, either local or remote. SDN Gateways can be used to:

- Create secure site-to-site IPsec connections between SDN virtual networks and external networks over the internet.

- Create Generic Routing Encapsulation (GRE) connections between SDN virtual networks and external networks. The difference between site-to-site connections and GRE connections is that the latter is not an encrypted connection. For more information about GRE connectivity, see [GRE Tunneling in Windows Server](/windows-server/remote/remote-access/ras-gateway/gre-tunneling-windows-server.md).

- Create Layer 3 (L3) connections between SDN virtual networks and external networks. In this case, SDN Gateway simply acts as a router between your virtual network and the external network.

## Host agents

The following components run as services or agents on the host server:

**ARC host agent**: Enables you to manage your Windows and Linux computers hosted outside of Azure on your corporate network or other cloud providers.

**Network Controller host agent**: Allows Network Controller to manage the goal state of the data plane, and to receive notification of events as the configuration of the data plane changes.

**Monitor host agent**: Orchestrator-managed agent used for emitting observability (telemetry and diagnostics) pipeline data that upload to Geneva (Azure Storage).

**Software Load Balancer host agent**: Listens for policy updates from the Network Controller. In addition, this agent programs agent rules into the SDN-enabled Hyper-V virtual switches that are configured on the local computer.

## Components running on VMs

The following table lists the various components running on virtual machines (VMs) for a single-server network pattern:

|Component|Number of VMs|OS disk size|Data disk size|vCPUs|Memory|
|--|--|--|--|--|--|
|Network Controller|1|100 GB|30 GB|4|4 GB|
|SDN Software Load Balancers|1|60 GB|30 GB|16|8 GB|
|SDN Gateways|1|60 GB|30 GB|8|8 GB|
|OEM Management|OEM defined|OEM defined|OEM defined|OEM defined|OEM defined|
|**Total**|3 + OEM|270 GB + OEM|90 GB + OEM|32 + OEM|28 GB + OEM|

## Next steps

Learn about [single-server IP requirements](single-server-ip-requirements.md).