---
title: Configure Software Load Balancer for high availability ports
description: Learn how to configure Software Load Balancer for high availability ports.
ms.author: v-mandhiman
ms.reviewer: anpaul
ms.topic: article
author: ManikaDhiman
ms.date: 05/06/2022
---

# Configure Software Load Balancer for high availability ports

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022, Windows Server 2019

## Overview of high availability ports rule

High availability ports is a type of load balancing rule that helps you load-balance all protocols across all ports. Similar to all load balancing rules, high availability ports rule relies on the 5-tuple connection: source address, destination address, source port, destination port, and protocol. 

To apply this rule, you set your **Protocol** status to **All**, so that both User Datagram Protocol (UDP) and Transmission Control Protocol (TCP) datagrams are accepted. You also need to set your **Frontend Port** and **Backend Port** to **0** for high availability.

### Why use high availability ports?

High availability ports are useful for high availability scenarios and scaling out Network Virtual Appliances (NVA) within your virtual networks. This feature can also assist in load balancing a large number of ports.

For instance, if you are using virtual appliances to manage security for your workloads, you would want to ensure that the virtual appliances are highly available. High availability ports can provide high availability and reliability by offering:

- Fast failover to healthy instances
- High performance with scale-out to *n*-active instances

## Prerequisites

To set up the high availability ports rule, you must configure the following:

- Backend pool
- Frontend IP configuration
- Health probe

> [!NOTE]
> For **Backend Pool**, you must first configure your virtual machines. To learn how to set up a virtual machine and other configurations, refer to the following articles:
>
> - For Virtual Machine Management, see [Manage VMs with Windows Admin Center](../manage/vm.md).
> - For Software Load Balancer management, see [Manage Software Load Balancer for SDN](../manage/load-balancers.md).

## Configure load balancing rule for high availability ports

1. In Windows Admin Center, under **All Connections**, select the cluster you want to create the load balancer on.
1. Under **Tools**, scroll down to **Networking**, and select **Load balancers**.
    1. If **Load balancers** isn't available under **Tools**, add the feature through the **SDN Load balancers** extension. For information about how to install the extension, see [Install and manage extensions](/windows-admin-center/configure/using-extensions).
    1. If you don't have a load balancer created yet, see [Deploy SDN Software Load Balancer](../deploy/sdn-wizard.md#deploy-sdn-software-load-balancer).

1. After creating your load balancer or selecting the appropriate load balancer to apply the high availability rule to, scroll down to where you can see the **Load Balancing Rules** section.

    :::image type="content" source="media/software-load-balancer/load-balancing-rules.png" alt-text="Load Balancing Rules Screenshot":::

1. Select **New** to add a new rule.
1. Enter or select the following information in **Add load balancing rule**.

    | Name | Value |
    |----- | -------------------------- |
    | Frontend IP Configuration | Select your frontend IP configuration. |
    | Protocol | ALL |
    | Frontend Port | 0 |
    | Backend Port | 0 |
    | Backend Pool | Select the backend pool of the load balancer. |
    | Health Probe | Select the health probe. |
    | Session Persistence | Default |
    | Idle Timeout (minutes) | Leave the default or move the slider to your required idle timeout. |
    | Floating IP (direct server return) | On/Off|

1. After filling out the necessary information, select **Create** or **Submit**.

## Supported configurations

The high availability ports rule support the following configurations:

- A single, non-floating IP (non-Direct Server Return) high availability ports. Select **Disable** for the **Floating IP** button for this configuration.

- A single, floating IP (Direct Server Return) high availability ports. Select **Enable** for the **Floating IP** button for this configuration.

- Multiple high availability ports configurations on a load balancer. To configure more than one high availability port frontend for the same backend pool, use the following steps:

    - Configure more than one front-end IP address for a single internal load balancer
    - Configure multiple load balancing rules, where each rule has single unique front-end IP address
    - Set the high availability ports configurations and set **Floating IP** to **Enabled** for all load balancing rules

- Internal Load Balancer with high availability ports and a public load balancer on the same back-end instance and vice versa.

- High availability ports load balancing for both Internal Load Balancers and Public Load Balancers.

## Limitations

The following are the limitations of using high availability ports load balancing rules:

- Combining high availability ports load balancing rules and non high availability ports load balancing rules pointing to the same backend ipconfigurations is not supported unless both have **Floating IP** enabled.
- Flow symmetry (primarily for NVA scenarios) is only supported with a single front-end NIC (single front-end IP configuration) and a backend pool. Using multiple load-balancers, load balancing rules or multiple NICs will not provide symmetry.
- The backend instance of an high availability ports internal load balancer cannot be the backend instance of another internal load balancer.
- The backend instance of a **Floating IP** high availability ports internal load balancer cannot be the backend instance of another non-floating IP high availability ports internal load balancer.

## Next steps

See [Deploy an SDN infrastructure using SDN Express](sdn-express.md).