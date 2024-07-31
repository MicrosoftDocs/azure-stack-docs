---
title: Azure Stack HCI three-node storage switchless, dual TOR, single link deployment network reference pattern
description: Plan to deploy an Azure Stack HCI three-node storage switchless, dual TOR, single link network reference pattern.
ms.topic: conceptual
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.custom: devx-track-arm-template
ms.date: 05/15/2024
---

# Review three-node storage switchless, dual TOR, single link deployment network reference pattern for Azure Stack HCI

[!INCLUDE [includes](../../includes/hci-applies-to-23h2.md)] and later

In this article, learn about the three-node storage switchless with two TOR L3 switches and full-mesh single link network reference pattern that you can use to deploy your Azure Stack HCI solution.

> [!NOTE]
> The 3-node switchless network reference patterns described in this article were tested and validated by Microsoft. For information on two-node switchless network patterns, see [Azure Stack HCI network deployment patterns](choose-network-pattern.md).

## Scenarios

Scenarios for this network pattern include laboratories, factories, retail stores, public sectors, and government.

Consider implementing this pattern when looking for a cost-efficient solution that has fault tolerance across all the network components. Software Defined Network (SDN) L3 services are fully supported on this pattern. Routing services such as Border Gateway Protocol (BGP) can be configured directly on the TOR switches if they support L3 services. Network security features such as micro segmentation or Quality of Service (QoS) don't require extra configuration of the firewall device, as they're implemented at virtual network adapter layer.

## Physical connectivity components

:::image type="content" source="media/three-node-switchless-two-switches-single-link/physical-components-layout.png" alt-text="Diagram showing three-node switchless, two TOR, single link physical connectivity layout." lightbox="media/three-node-switchless-two-switches-single-link/physical-components-layout.png":::

As illustrated in the diagram above, this pattern has the following physical network components:

- For northbound and southbound communication, the Azure Stack HCI cluster requires two TOR switches in multi-chassis link aggregation group (MLAG) configuration.
- Two network cards using SET virtual switch to handle management and compute traffic, connected to the TOR switches. Each NIC is connected to a different TOR.
- Two RDMA NICs on each node in a full-mesh single link configuration for East-West traffic for the storage.
    > [!NOTE]
    > For this configuration, there is no redundant network connection between the nodes.

|Networks|Management and compute|Storage|
|--|--|--|
|Link speed|At least 1 GBps. 10 GBps recommended|At least 10 GBps|
|Interface type|RJ45, SFP+ or SFP28|SFP+ or SFP28|
|Ports and aggregation|Two teamed ports|Two standalone ports|

## Logical networks

As illustrated in the diagram below, this pattern has the following logical network components:

:::image type="content" source="media/three-node-switchless-two-switches-single-link/logical-components-layout.png" alt-text="Diagram showing three-node switchless, two TOR, single link logical connectivity layout." lightbox="media/three-node-switchless-two-switches-single-link/logical-components-layout.png":::

### Node interconnect networks VLAN for SMB traffic (Storage and live migration)

The Storage intent-based traffic consists of three individual subnets supporting RDMA traffic. Each interface is dedicated to a separate node interconnect network. This traffic is only intended to travel between the three nodes. Storage traffic on these subnets is isolated without connectivity to other resources.

Each pair of storage adapters between the nodes operates in different IP subnets. To enable a switchless configuration, each connected node supports the same matching subnet of its neighbor.

When deploying a three-node switchless configuration, Network ATC has the following requirements:

- Only supports a single VLAN for all the IP subnets used for storage connectivity.

- `StorageAutoIP` parameter must be set to false, `Switchless` parameter must be set to true,  and you are responsible to specify the IPs on the ARM template used to deploy the Azure Stack HCI cluster from Azure.

- For Azure Stack HCI, version 23H2 cloud deployments:

    - Scale out storage switchless clusters aren't supported.

    - It's only possible to deploy this three-node scenario using ARM templates.
    
    For more information, see [Deploy via Azure Resource Manager deployment template](../deploy/deployment-azure-resource-manager-template.md).

### Management VLAN

All physical compute hosts must access the management logical network. For IP address planning purposes, each host must have at least one IP address assigned from the management logical network.

A DHCP server can automatically assign IP addresses for the management network, or you can manually assign static IP addresses. When DHCP is the preferred IP assignment method, DHCP reservations without expiration are recommended.

For information, see [DHCP Network considerations for cloud deployment.](cloud-deployment-network-considerations.md#dhcp-ip-assignment)

The management network supports two different VLAN configurations for traffic - **Native** and **Tagged**. The following considerations apply to each configuration:

- Native VLAN for management network doesn't require you to supply a VLAN ID.

- Tagged VLAN for management network requires VLAN ID configuration on the physical network adapters or the management virtual network adapter before registering the nodes in Azure Arc.

- Physical switch ports must be configured correctly to accept the VLAN ID on the management adapters.

- If the intent includes Management and Compute traffic types, the physical switch ports must be configured in trunk mode to accept all the VLANs required for management and compute workloads.

The Management network supports traffic used by the administrator for management of the cluster including Remote Desktop, Windows Admin Center, and Active Directory.

For more information, see [Management VLAN network considerations](cloud-deployment-network-considerations.md#management-vlan-id).

### Compute VLANs

In some scenarios, you don’t need to use SDN Virtual Networks with VXLAN encapsulation. Instead, you can use traditional VLANs to isolate their tenant workloads. Those VLANs need to be configured on the TOR switches port in trunk mode. When connecting new virtual machines to these VLANs, the corresponding VLAN tag is defined on the virtual network adapter.

### HNV Provider Address (PA) network

The Hyper-V Network Virtualization Provider Address (HNV PA) network serves as the underlying physical network for East-West (internal-internal) tenant traffic, North-South (external-internal) tenant traffic, and to exchange BGP peering information with the physical network. This network is only required when there's a need to deploy virtual networks using VXLAN encapsulation for an extra layer of isolation and network multitenancy.

For more information, see [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure-23h2.md#management-and-hnv-provider).

## Network ATC intents

For three-node storage switchless patterns, two Network ATC intents are created. The first intent is for management and compute network traffic, and the second intent is for storage traffic.

:::image type="content" source="media/three-node-switchless-two-switches-single-link/network-atc.png" alt-text="Diagram showing three-node switchless, two TOR, single link Network ATC intents." lightbox="media/three-node-switchless-two-switches-single-link/network-atc.png":::

### Management and compute intent

- Intent type: Management and Compute
- Intent mode: Cluster mode
- Teaming: Yes. pNIC01 and pNIC02 team
- Default management VLAN: Configured VLAN for management adapters isn’t modified.
- PA and compute VLANs and vNICs: Network ATC is transparent to PA vNICs and VLAN or compute VM vNICs and VLANs.

### Storage intent

- Intent type: Storage
- Intent mode: Cluster mode
- Teaming: No. RDMA NICs use SMB Multichannel to provide resiliency and bandwidth aggregation.
- Default VLANs: single VLAN for all subnets
- Storage Auto IP: False. This pattern requires manual IP configuration or ARM template IP definition.

- Three subnets required (user defined):
    - Storage Network 1: 10.0.1.0/24 – `Node1 -> Node2`
    - Storage Network 2: 10.0.2.0/24 – `Node1 -> Node2`
    - Storage Network 3: 10.0.3.0/24 – `Node2 -> Node3`

For more information, see [Deploy host networking with Network ATC](../deploy/network-atc.md).

## ARM template Storage intent network configuration example

You can use the [ARM template for 3-node storage switchless, dual TOR and single link](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-3Nodes-Switchless-SingleLink).

Here's a snippet from the template:

```powershell
"storageNetworkList": {
        "value": [
            {
                "name": "StorageNetwork1",
                "networkAdapterName": "SMB1",
                "vlanId": "711",
                "storageAdapterIPInfo": [
                    {
                        "physicalNode": "Node1",
                        "ipv4Address": "10.0.1.1",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node2",
                        "ipv4Address": "10.0.1.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node3",
                        "ipv4Address": "10.0.2.1",
                        "subnetMask": "255.255.255.0"
                    }
                ]
            },
            {
                "name": "StorageNetwork2",
                "networkAdapterName": "SMB2",
                "vlanId": "711",
                "storageAdapterIPInfo": [
                    {
                        "physicalNode": "Node1",
                        "ipv4Address": "10.0.2.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node2",
                        "ipv4Address": "10.0.3.1",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node3",
                        "ipv4Address": "10.0.3.2",
                        "subnetMask": "255.255.255.0"
                    }
                ]
            }
        ]
      },
```
