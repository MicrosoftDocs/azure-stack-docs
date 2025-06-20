---
title: Software Defined Networking (SDN) enabled by Azure Arc on Azure Local (Preview)
description: Software Defined Networking enabled by Arc provides a way to centrally configure and manage logical networks, network security groups, network security rules via the Azure portal and Azure CLI in Azure Local. (Preview)
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-local
ms.date: 06/17/2025
---

# Software Defined Networking enabled by Azure Arc on Azure Local (Preview)

::: moniker range=">=azloc-2506"

This article provides an overview of Software Defined Networking (SDN) enabled by Azure Arc on Azure Local. The overview includes SDN management methods, guidance on when to use each method, and supported as well as unsupported SDN scenarios.

SDN offers a centralized way to configure and manage networks and network services such as switching, routing, and load balancing in your datacenter. SDN enables you to dynamically create, secure, and connect your network to meet the evolving needs of your applications.

[!INCLUDE [important](../includes/hci-preview.md)]

## About SDN management on Azure Local

SDN on Azure Local can be managed in two ways: via Arc and via on-premises tools.

**SDN enabled by Arc** is currently in Preview and available for Azure Local 2506 running OS version 26100.xxxx and later.

In this method, the Network Controller runs as a Failover Cluster service instead of running on a virtual machine (VM). When SDN is enabled, the Network Controller integrates with the Azure Arc control plane, allowing the management of both existing and new logical networks.

With SDN enabled by Azure Arc, you can create and apply network security groups (NSGs) to logical networks and Azure Local VM network interfaces (NICs).

An alternative way to manage SDN is through on-premises tools such as Windows Admin Center or SDN Express scripts. This approach is available for Windows Server and Azure Local 2311.2 and later. This method uses three major SDN components, allowing you to choose which to deploy: Network Controller, Software Load Balancer (SLB), and Gateway. For more information, see [SDN managed by on-premises tools](../concepts/software-defined-networking-23h2.md).


## Comparison summary of SDN management

Here's a comparative summary of the SDN managed by Arc and via on-premises tools:

| SDN management | Supported SDN resources  | Supported VMs  | Management tools  |
|---------|---------|---------|---------|
| SDN enabled by Arc   | Logical networks<br><br>VM NICs<br><br>NSGs        | Azure Local VMs        | Azure portal <br><br> Azure CLI <br><br> ARM templates         |
| SDN managed by on-premises tools     |Logical networks<br><br>VM NICs<br><br>NSGs<br><br>Virtual networks<br><br>SLBs<br><br>VPN Gateways        | Hyper-V VMs<br><br>System Center Virtual Machine Manager (SCVMM) VMs         | SDN Express scripts<br><br>Windows Admin Center<br><br>PowerShell<br><br>SCVMM       |


## Unsupported scenarios for SDN enabled by Arc

Here's a summary of unsupported scenarios for SDN enabled by Arc on Azure Local:

|Scenario  |Description  |
|---------|---------|
|SDN resources     | The following resources aren't supported:<br><br> - Virtual networks <br><br> - Software Load Balancers <br><br> - Gateways (VPN, L3, GRE)         |
|Hybrid scenarios     | Deployment and management method must be consistent. <br><br> - If SDN is enabled by Arc, manage it only using Azure portal, Azure CLI, and Azure Resource Manager templates. <br><br> - Don't manage via on-premises tools such as Windows Admin Center and SDN Express scripts.         |
|Multiple NICs     | Scenarios that require multiple NICs simultaneously aren't supported.        |
|DHCP-based networks     | DHCP-based logical networks and network interfaces aren't supported.         |
|AKS workloads     | AKS workloads aren't supported.      |
|Disaster recovery     | Disaster recovery support isn't available.      |


## Supported networking patterns for SDN enabled by Arc

Before you deploy Azure Local and enable SDN, we recommend that you review the following supported networking patterns and available options.

### Group all traffic on single network intent

- Use the *Group all traffic* host networking pattern in single or multi node configuration. For more information about this pattern, see [Group all traffic on a single intent](../upgrade/install-enable-network-atc.md#example-intent-group-all-traffic-on-a-single-intent).

- Use this pattern only with switched storage network connectivity.

    :::image type="content" source="./media/sdn-overview/group-all-traffic.png" alt-text="Screenshot of selecting switched storage connectivity." lightbox="./media/sdn-overview/group-all-traffic.png":::

- A single virtual switch is available to create SDN resources.

- The Azure Virtual Filtering extensions are turned on after the Network Controller is enabled.  

### Group management and compute traffic in one intent with a separate storage intent

- Use the *Group management and compute traffic* host networking pattern in single or multi node configuration. For more information about this pattern, see [Group management and compute traffic in one intent with a separate storage intent](../upgrade/install-enable-network-atc.md#example-intent-group-management-and-compute-in-one-intent-with-a-separate-intent-for-storage).

- Use this pattern with switched or switchless storage network connectivity for up to 4-node Azure Local deployments. Use only storage switched connectivity for deployments with 5 or more nodes.

    :::image type="content" source="./media/sdn-overview/group-management-compute-traffic.png" alt-text="Screenshot of selecting switched storage connectivity for 2-node system." lightbox="./media/sdn-overview/group-all-traffic.png":::

- A single virtual switch is available to create SDN resources.

- The Azure Virtual Filtering extensions are turned on after the Network Controller is enabled.  

### Custom configuration for disaggregated host networking

- Use the *Custom configuration* host networking pattern in single or multi node configuration. For more information about this pattern, see [Custom configuration - Disaggregated host networking](../upgrade/install-enable-network-atc.md#example-intent-fully-disaggregated-host-networking).

    :::image type="content" source="./media/sdn-overview/pattern-custom-configuration-disaggregated-networking.png" alt-text="Screenshot of custom configuration for fully disaggregated networking." lightbox="./media/sdn-overview/pattern-custom-configuration-disaggregated-networking.png":::

- Use this pattern with switched or switchless storage connectivity for up to 4-node Azure Local deployments. Use only storage switched connectivity for deployments with 5 or more nodes.

    :::image type="content" source="./media/sdn-overview/custom-configuration-disaggregated-networking.png" alt-text="Screenshot of switched or switchless storage connectivity for up to 4 nodes." lightbox="./media/sdn-overview/custom-configuration-disaggregated-networking.png":::

- A single virtual switch is available to create SDN resources.

- You can use up to 3 network intents provided there are enough network adapter ports to separate the network traffic types.
    - The first management intent is used only for host management traffic.
    - The second compute intent is used only for VMs and workloads traffic.
    - The third storage intent is used only for storage traffic.

<!--## Choose SDN type based on your requirements

Starting release 2504, you have two ways to enable SDN.

- Use SDN enabled by Arc if workloads only require logical networks based on VLAN isolation and network security groups to secure access.​
- Use SDN managed by on-prem tools if workloads require virtual networks for isolation, and load balancers or gateways.

Use the following detailed decision matrix to select the SDN type based on your requirements:

:::image type="content" source="./media/sdn-overview/sdn-type-decision-matrix.png" alt-text="Screenshot of SDN decision matrix." lightbox="./media/sdn-overview/sdn-type-decision-matrix.png":::-->


## Next steps

For related information, see also:

- [Enable SDN via action plan](../deploy/enable-sdn-integration.md)
- [Deploy SDN infrastructure using SDN Express PowerShell scripts](../deploy/sdn-express-23h2.md)

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available only in Azure Local 2506 with OS build 26100.xxxx or later.

::: moniker-end