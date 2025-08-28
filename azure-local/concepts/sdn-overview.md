---
title: Software Defined Networking (SDN) enabled by Azure Arc on Azure Local (preview)
description: Software Defined Networking enabled by Arc provides a way to centrally configure and manage logical networks, network security groups, network security rules via the Azure portal and Azure CLI in Azure Local (preview).
author: alkohli
ms.author: alkohli
ms.topic: conceptual
ms.service: azure-local
ms.date: 07/07/2025
---

# Software Defined Networking enabled by Azure Arc on Azure Local (preview)

::: moniker range=">=azloc-2506"

This article explains Software Defined Networking (SDN) enabled by Azure Arc on Azure Local. It covers SDN management methods, when to use each method, and supported and unsupported SDN scenarios.

SDN offers a centralized way to configure and manage networks and network services such as switching, routing, and load balancing in your datacenter. SDN enables you to dynamically create, secure, and connect your network to meet the evolving needs of your applications.

[!INCLUDE [important](../includes/hci-preview.md)]

## About SDN management on Azure Local

You can manage SDN on Azure Local in two ways: with Arc or with on-premises tools.

- **SDN enabled by Arc**: This feature is in preview and is available for Azure Local 2506 with OS version 26100.xxxx or later.

    In this method, the Network Controller runs as a Failover Cluster service instead of on a virtual machine (VM). When you enable SDN, the Network Controller integrates with the Azure Arc control plane, so you can manage both existing and new logical networks.

    With SDN enabled by Azure Arc, you create and apply network security groups (NSGs) to logical networks and Azure Local VM network interfaces (NICs).

- **SDN managed by on-premises tools**: You can also manage SDN with on-premises tools like Windows Admin Center or SDN Express scripts. This approach is available for Windows Server and Azure Local 2311.2 or later. This method uses three main SDN components, and you choose which to deploy: Network Controller, Software Load Balancer (SLB), and Gateway. For more information, see [SDN managed by on-premises tools](../concepts/software-defined-networking-23h2.md).

## Important considerations


|Management method  |Consideration |
|---------|---------|
|SDN enabled by Azure Arc    | Enable SDN by running this PowerShell command `Add-EceFeature`. <br><br>If Network controller on your Azure Local was deployed using on-premises tools, you must not attempt to run this method. <br><br>The only VMs that are in scope for using NSGs with this feature are Azure Local VMs. These Azure Local VMs were deployed from Azure client interfaces (Azure CLI, Azure portal, Azure Resource Manager). <br><br>Do not use an Azure Local VM in conjunction with an NSG that is managed and applied from on-premises tools.        |
|SDN managed by on-premises tools    | Enable SDN using on-premises tools like Windows Admin Center or SDN Express scripts. <br><br>If Network Controller on your Azure Local was deployed using PowerShell command `Add-EceFeature`, you must not attempt to run SDN managed by on-premises tools. <br><br>The only VMs that are in scope for NSG management using this feature are unmanaged VMs that were deployed from local tools such as Windows Admin Center, Hyper-V Manager, System Center Virtual Machine Manager and Failover Cluster Manager. To manage NSGs on unmanaged VMs, you can only use Windows Admin Center, and SDN Express scripts.         |

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
|AKS workloads     | AKS workloads aren't supported.      |
|Disaster recovery     | Disaster recovery support isn't available.      |
|Multi-cast workloads     | Multi-cast workloads aren't supported.      |

## Supported networking patterns for SDN enabled by Arc

Before you deploy Azure Local and enable SDN, review these supported networking patterns and options.

### Group all traffic on single network intent

- Use the *Group all traffic* host networking pattern in single or multi node configuration. For details, see [Group all traffic on a single intent](../upgrade/install-enable-network-atc.md#example-intent-group-all-traffic-on-a-single-intent).

- Use this pattern only with switched storage network connectivity.

    :::image type="content" source="./media/sdn-overview/group-all-traffic.png" alt-text="Screenshot of selecting switched storage connectivity." lightbox="./media/sdn-overview/group-all-traffic.png":::

- A single virtual switch is available to create SDN resources.

- The Azure Virtual Filtering extensions are turned on after the Network Controller is enabled.  

### Group management and compute traffic in one intent with a separate storage intent

- Use the *Group management and compute traffic* host networking pattern in single or multi node configuration. For details, see [Group management and compute traffic in one intent with a separate storage intent](../upgrade/install-enable-network-atc.md#example-intent-group-management-and-compute-in-one-intent-with-a-separate-intent-for-storage).

- Use this pattern with switched or switchless storage connectivity for up to four-node Azure Local deployments. Use only storage switched connectivity for deployments with five or more nodes.

    :::image type="content" source="./media/sdn-overview/group-management-compute-traffic.png" alt-text="Screenshot of selecting switched storage connectivity for 2-node system." lightbox="./media/sdn-overview/group-all-traffic.png":::

- A single virtual switch is available to create SDN resources.

- The Azure Virtual Filtering extensions are turned on after the Network Controller is enabled.  

### Custom configuration for disaggregated host networking

- Use the *Custom configuration* host networking pattern in single or multi node configuration. For details, see [Custom configuration - Disaggregated host networking](../upgrade/install-enable-network-atc.md#example-intent-fully-disaggregated-host-networking).

    :::image type="content" source="./media/sdn-overview/pattern-custom-configuration-disaggregated-networking.png" alt-text="Screenshot of custom configuration for fully disaggregated networking." lightbox="./media/sdn-overview/pattern-custom-configuration-disaggregated-networking.png":::

- Use this pattern with switched or switchless storage connectivity for up to four-node Azure Local deployments. Use only storage switched connectivity for deployments with five or more nodes.

    :::image type="content" source="./media/sdn-overview/custom-configuration-disaggregated-networking.png" alt-text="Screenshot of switched or switchless storage connectivity for up to 4 nodes." lightbox="./media/sdn-overview/custom-configuration-disaggregated-networking.png":::

- A single virtual switch is available to create SDN resources.

- Use up to three network intents provided there are enough network adapter ports to separate the network traffic types.
    - The first management intent is only for host management traffic.
    - The second compute intent is only for VMs and workloads traffic.
    - The third storage intent is only for storage traffic.

## Unsupported intent configurations

The following network intent configurations are not supported for SDN enabled by Arc on Azure Local:

- More than three intents on any deployment size.
- Combined compute and storage intents without a management intent.
- Standalone compute intent on a single-node deployment.
- Three-intent configurations on two- or three-node switchless deployments.

## Next steps

For related information, see:

- [Enable SDN integration](../deploy/enable-sdn-integration.md)
- [Deploy SDN infrastructure using SDN Express PowerShell scripts](../deploy/sdn-express-23h2.md)

::: moniker-end

::: moniker range="<=azloc-2505"

This feature is available in Azure Local 2506 with OS build 26100.xxxx or later.

::: moniker-end
