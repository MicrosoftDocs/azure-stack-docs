---
title: Azure Local four-node storage switchless, dual TOR, dual link deployment network reference pattern
description: Plan to deploy an Azure Local four-node storage switchless, dual TOR, dual link network reference pattern.
ms.topic: article
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.service: azure-local
ms.custom: devx-track-arm-template
ms.date: 05/15/2025
---

# Review four-node storage switchless, dual TOR, dual link deployment network reference pattern for Azure Local

> Applies to: Azure Local 2411.1 and later

This article describes how you can use a four-node storage switchless network reference pattern with two TOR L3 switches and two full-mesh links to deploy your Azure Local solution.

> [!NOTE]
> Microsoft has tested and validated the four-node switchless network reference patterns described in this article.

## Scenarios

Scenarios for this network pattern include laboratories, factories, branch offices, and datacenters.

Consider implementing this pattern when looking for a cost-efficient solution that has fault tolerance across all the network components.

[!INCLUDE [includes](../includes/switchless-scale-out.md)]

SDN L3 services are fully supported on this pattern. Routing services such as Border Gateway Protocol (BGP) can be configured directly on the TOR switches if they support L3 services. Network security features such as micro segmentation or QoS don't require extra configuration of the firewall device, as they're implemented at virtual network adapter layer.

:::image type="content" source="./media/four-node-switchless-two-switches-two-links/four-node-switchless-components-layout.png" alt-text="Diagram showing four-node switchless, two TOR, two link physical connectivity layout." lightbox="./media/four-node-switchless-two-switches-two-links/four-node-switchless-components-layout.png":::

## Physical connectivity components

As illustrated in the following four-node network diagram, this pattern has the following physical network components:

- For northbound and southbound communication, the Azure Local instance requires two TOR switches in multi-chassis link aggregation group (MLAG) configuration.

- Two network cards using SET virtual switch to handle management and compute traffic, connected to the TOR switches. Each network interface port is connected to a different TOR.

- Six RDMA NICs on each node in a full-mesh dual link configuration for East-West traffic for the storage. Each node in the system has a redundant connection with two paths to the other node in the system.

|Networks|Management and compute|Storage|
|--|--|--|
|Link speed|At least 1 GBps. 10 GBps recommended|At least 10 GBps|
|Interface type|RJ45, SFP+ or SFP28|SFP+ or SFP28|
|Ports and aggregation|Two teamed ports|Four standalone ports|

## Logical networks

### Node interconnect networks VLAN for SMB traffic (Storage and live migration)

The Storage intent-based traffic consists of twelve individual subnets supporting RDMA traffic. Each interface is dedicated to a separate node interconnect network. This traffic is only intended to travel between the four nodes. Storage traffic on these subnets is isolated without connectivity to other resources.

Each pair of storage adapters between the nodes operates in different IP subnets. To enable a switchless configuration, each connected node supports the same matching subnet of its neighbor.

When deploying four nodes in a switchless configuration, Network ATC has the following requirements:

- Only supports a single VLAN for all the IP subnets used for storage connectivity.

- `StorageAutoIP` parameter must be set to false, `Switchless` parameter must be set to true, and you must specify the IPs on the Azure Resource Manager (ARM) template used to deploy the Azure Local instance from Azure.

- For Azure Local:

    - Scale out storage switchless systems aren't supported.

    - It's only possible to deploy this four-node scenario using ARM templates.

For more information, see [Deploy via Azure Resource Manager deployment template](../deploy/deployment-azure-resource-manager-template.md).

### Management VLAN

All physical compute hosts must access the management logical network. For IP address planning purposes, each host must have at least one IP address assigned from the management logical network.

A DHCP server can automatically assign IP addresses for the management network, or you can manually assign static IP addresses. When DHCP is the preferred IP assignment method, DHCP reservations without expiration are recommended.

For information, see [DHCP Network considerations for cloud deployment.](cloud-deployment-network-considerations.md#dhcp-ip-assignment)

The management network supports two different VLAN configurations for traffic - **Native** and **Tagged**:

- Native VLAN for management network doesn't require you to supply a VLAN ID.

- Tagged VLAN for management network requires VLAN ID configuration on the physical network adapters or the management virtual network adapter before registering the nodes in Azure Arc.

- Physical switch ports must be configured correctly to accept the VLAN ID on the management adapters.

- If the intent includes management and compute traffic types, the physical switch ports must be configured in trunk mode to accept all the VLANs required for management and compute workloads.

The Management network supports traffic used by the administrator for management of the system including Remote Desktop, Windows Admin Center, and Active Directory.

For more information, see [Management VLAN network considerations](cloud-deployment-network-considerations.md#management-vlan-id).

### Compute VLANs

In some scenarios, you don’t need to use SDN Virtual Networks with VXLAN encapsulation. Instead, you can use traditional VLANs to isolate their tenant workloads. Those VLANs need to be configured on the TOR switches port in trunk mode. When connecting new virtual machines to these VLANs, the corresponding VLAN tag is defined on the virtual network adapter.

### HNV Provider Address (PA) network

The Hyper-V Network Virtualization Provider Address (HNV PA) network serves as the underlying physical network for East-West (internal-internal) tenant traffic, North-South (external-internal) tenant traffic, and to exchange BGP peering information with the physical network. This network is only required when there's a need for deploying virtual networks using VXLAN encapsulation for an extra layer of isolation and network multitenancy.

For more information, see [Plan a Software Defined Network infrastructure](../concepts/plan-software-defined-networking-infrastructure-23h2.md#management-and-hnv-provider).

## Network ATC intents

For four-node storage switchless patterns, two Network ATC intents are created. The first intent is for management and compute network traffic, and the second intent is for storage traffic.

### Management and compute intent

- Intent type: Management and compute
- Intent mode: Cluster mode
- Teaming: Yes. pNIC01 and pNIC02 team.
- Default management VLAN: Configured VLAN for management adapters isn’t modified.
- PA and compute VLANs and vNICs: Network ATC is transparent to PA vNICs and VLAN or compute VM vNICs and VLANs.

### Storage intent

- Intent type: Storage
- Intent mode: Cluster mode
- Teaming: No. RDMA NICs use SMB Multichannel to provide resiliency and bandwidth aggregation.
- Default VLANs: single VLAN for all subnets.
- Storage Auto IP: False. This pattern requires manual IP configuration or ARM template IP definition.

- Twelve subnets required (user defined):
    - Storage Network 1: 10.0.1.0/24 – `Node1 -> Node2`
    - Storage Network 2: 10.0.2.0/24 – `Node1 -> Node2`
    - Storage Network 3: 10.0.3.0/24 – `Node1 -> Node3`
    - Storage Network 4: 10.0.4.0/24 – `Node1 -> Node3`
    - Storage Network 5: 10.0.5.0/24 – `Node1 -> Node4`
    - Storage Network 6: 10.0.6.0/24 – `Node1 -> Node4`
    - Storage Network 7: 10.0.7.0/24 – `Node2 -> Node3`
    - Storage Network 8: 10.0.8.0/24 – `Node2 -> Node3`
    - Storage Network 9: 10.0.9.0/24 – `Node2 -> Node4`
    - Storage Network 10: 10.0.10.0/24 – `Node2 -> Node4`
    - Storage Network 11: 10.0.11.0/24 – `Node3 -> Node4`
    - Storage Network 12: 10.0.12.0/24 – `Node3 -> Node4`

For more information, see [Deploy host networking with Network ATC](../deploy/network-atc.md).

## ARM template Storage intent networks configuration example

You can use the [ARM template for four-node storage switchless, dual TOR and dual link](https://github.com/Azure/azure-quickstart-templates/tree/master/quickstarts/microsoft.azurestackhci/create-cluster-4Nodes-Switchless-DualLink).

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
                        "ipv4Address": "10.0.1.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node2",
                        "ipv4Address": "10.0.1.3",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node3",
                        "ipv4Address": "10.0.3.3",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node4",
                        "ipv4Address": "10.0.5.3",
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
                        "ipv4Address": "10.0.2.3",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node3",
                        "ipv4Address": "10.0.4.3",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node4",
                        "ipv4Address": "10.0.6.3",
                        "subnetMask": "255.255.255.0"
                    }
                    ]
                },
                {
                  "name": "StorageNetwork3",
                  "networkAdapterName": "SMB3",
                  "vlanId": "711",
                  "storageAdapterIPInfo": [
                    {
                        "physicalNode": "Node1",
                        "ipv4Address": "10.0.3.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node2",
                        "ipv4Address": "10.0.7.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node3",
                        "ipv4Address": "10.0.7.3",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node4",
                        "ipv4Address": "10.0.9.3",
                        "subnetMask": "255.255.255.0"
                    }
                  ]
              },
              {
                "name": "StorageNetwork4",
                "networkAdapterName": "SMB4",
                "vlanId": "711",
                "storageAdapterIPInfo": [
                    {
                        "physicalNode": "Node1",
                        "ipv4Address": "10.0.4.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node2",
                        "ipv4Address": "10.0.8.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node3",
                        "ipv4Address": "10.0.8.3",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node4",
                        "ipv4Address": "10.0.10.3",
                        "subnetMask": "255.255.255.0"
                    }
                ]
            },
            {
                "name": "StorageNetwork5",
                "networkAdapterName": "SMB5",
                "vlanId": "711",
                "storageAdapterIPInfo": [
                    {
                        "physicalNode": "Node1",
                        "ipv4Address": "10.0.5.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node2",
                        "ipv4Address": "10.0.9.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node3",
                        "ipv4Address": "10.0.11.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node4",
                        "ipv4Address": "10.0.11.3",
                        "subnetMask": "255.255.255.0"
                    }
                ]
            },
            {
                "name": "StorageNetwork6",
                "networkAdapterName": "SMB6",
                "vlanId": "711",
                "storageAdapterIPInfo": [
                    {
                        "physicalNode": "Node1",
                        "ipv4Address": "10.0.6.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node2",
                        "ipv4Address": "10.0.10.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node3",
                        "ipv4Address": "10.0.12.2",
                        "subnetMask": "255.255.255.0"
                    },
                    {
                        "physicalNode": "Node4",
                        "ipv4Address": "10.0.12.3",
                        "subnetMask": "255.255.255.0"
                    }
                ]
            }
            ]
        },
```
