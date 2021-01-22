---
title: Manage tenant logical networks
description: This topic ...
author: JohnCobb1
ms.author: v-johcob
ms.topic: how-to
ms.date: 01/22/2021
---

# Manage tenant logical networks

>Applies to: Azure Stack HCI, version 20H2

This topic provides step-by-step instructions on how to use Windows Admin Center to create, update, and delete logical networks after you have deployed Network Controller. A Software Defined Networking (SDN) logical network is a traditional VLAN-based network.

By modelling a VLAN-based network as a SDN logical network, you can apply network policies to workloads that are attached to these networks. For example, you can apply security access control lists (ACLs) to workloads that are attached to SDN logical networks. Applying the ACLs protects your VLAN-based workloads from both external and internal attacks.

## Create a logical network
Use the following steps in Windows Admin Center to create a logical network.

:::image type="content" source="./media/tenant-logical-networks/create-logical-network.png" alt-text="The Logical networks name box in Windows Admin Center." lightbox="./media/tenant-logical-networks/create-logical-network.png":::

1. On the Windows Admin Center home screen, under **All Connections**, select the cluster that you want to create the logical network on.
1. Under **Tools**, scroll down to the **Networking** area, and select **Logical networks**.
1. Under **Logical networks**, select the **Inventory** tab, then select **New**. 
1. In the **Logical networks** pane, type a name for the logical network.
1. Under **Logical subnet**, select **Add**.

:::image type="content" source="./media/tenant-logical-networks/create-logical-network-subnet.png" alt-text="The Logical subnet pane in Windows Admin Center." lightbox="./media/tenant-logical-networks/create-logical-network-subnet.png":::

1. In the **Logical subnet** pane, type a name for the subnet, and then provide the following information:
    1. A **VLAN ID** for the network.
    1. An **Address Prefix** in CIDR notation.
    1. The **Default Gateway** for the network.
    1. The **DNS** server address, if needed. Specify the DNS server address if this is a public logical network to provide connectivity for external clients.
1. Under **Logical subnet IP Pools**, select **Add** and then provide the following information:
    1. A logical **IP Pool Name**
    1. A **Start IP address**
    1. An **End IP address**. The start and end IP address must be within the address prefix provided for the subnet.
    1. Select **Add**.
1. On the **Logical Subnet** page, select **Add**.
1. On the **Logical networks** page, select **Submit**.
1. In the **Logical networks** list, verify that the state of the logical network is **Healthy**.

## Get a list of logical networks
TBD


## View logical network details
TBD


## Change logical network settings
TBD


## Delete a logical network
TBD


## Next steps
For more information, see also:
- [Manage tenant virtual networks]()
