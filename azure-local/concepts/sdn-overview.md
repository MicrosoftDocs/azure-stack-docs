---
title: Cloud-managed and traditional Software defined networking (SDN) in Azure Local, version 24H2
description: Software defined networking (SDN) provides a way to centrally configure and manage networks and network services such as switching, routing, and load balancing in Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-local
ms.date: 04/15/2025
---

# Software Defined Networking (SDN) in Azure Local

> Applies to: Azure Local 2504 and later

This article provides an overview of the Software defined networking (SDN) in Azure Local including the types of SDN, when to use which type, and supported scenarios.

SDN provides a way to centrally configure and manage networks and network services such as switching, routing, and load balancing in your datacenter. You can use SDN to dynamically create, secure, and connect your network to meet the evolving needs of your apps. <!--Operating global-scale datacenter networks for services like Microsoft Azure, which efficiently performs tens of thousands of network changes every day, is possible only because of SDN.-->

[!INCLUDE [important](../includes/hci-preview.md)]

## About SDN in Azure Local

The Azure Local solution has the following two types of SDN:

- **Cloud-managed SDN**: This is the Preview SDN solution that is available in Azure Local 2504 and later. This preview solution is not recommended for production use.

    The cloud-managed SDN has network controller running as a Failover Cluster service. There is no need to deploy additional VMs to run the Network Controller thus allowing more capacity for workloads.

    Once you enable cloud-managed SDN, you can manage logical networks, network security groups, and virtual machine networks interfaces via the Arc control plane.

    With cloud-based SDN:

    - The existing and new logical networks are managed by the network controller.
    - You can create and apply network security groups to logical networks and virtual machine network interfaces (NICs). You can also create and add security rules.
    - You can create and delete virtual machine NICs.

- **Traditional SDN**: This SDN solution is available in Azure Local 2311.2 and later. The traditional SDN has three major SDN components, and you can choose which you want to deploy: Network Controller, Software Load Balancer, and Gateway. For more information, see [Traditional SDN](../concepts/software-defined-networking-23h2.md).


## Supported operations for cloud-managed and traditional SDN

| SDN type | SDN resources  | VM types  | Management tools  |
|---------|---------|---------|---------|
| Cloud-managed   | Logical networks<br>VM NICs<br>Network security groups        | Azure Local VMs        | Azure portal <br> Azure CLI <br> ARM templates         |
| Traditional     |Logical networks<br>VM NICs<br>Network security groups<br>Virtual networks<br>Peering<br>Software Load Balancers<br>VPN Gateways        | Hyper-V VMs<br>SCVMM VMs         | SDN Express<br>Windows Admin Center<br>PowerShell<br>SCVMM VMs        |

## Supported network topologies



## Choose cloud-managed or traditional SDN

Starting release 2504, you have two ways to enable SDN.

- Use cloud-managed SDN if workloads only require logical networks based on VLAN isolation and network security groups to secure access.​
- Use traditional SDN if workloads require virtual networks for isolation, and load balancers or gateways.

Use the following detailed decision matrix to select the SDN type based on your requirements:

:::image type="content" source="./media/sdn-overview/sdn-type-decision-matrix.png" alt-text="Screenshot of selecting create network security group." lightbox="./media/sdn-overview/sdn-type-decision-matrix.png":::



## Next steps

For related information, see also:

- [Enable cloud-managed SDN via ECE action plan](./enable-sdn-action-plan.md)
- [Deploy traditional SDN infrastructure using SDN Express](../deploy/sdn-express-23h2.md)
