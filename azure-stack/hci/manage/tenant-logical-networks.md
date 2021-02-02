---
title: Manage tenant logical networks
description: This topic provides step-by-step instructions on how to use Windows Admin Center to create, update, and delete logical networks after you have deployed Network Controller.
author: AnirbanPaul
ms.author: anpaul
ms.topic: how-to
ms.date: 02/02/2021
---

# Manage tenant logical networks

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019; Windows Server 2016

This topic provides step-by-step instructions on how to use Windows Admin Center to create, update, and delete logical networks after you have deployed Network Controller. A Software Defined Networking (SDN) logical network is a traditional VLAN-based network.

By modeling a VLAN-based network as a SDN logical network, you can apply network policies to workloads that are attached to these networks. For example, you can apply security access control lists (ACLs) to workloads that are attached to SDN logical networks. Applying the ACLs protects your VLAN-based workloads from both external and internal attacks.

## Create a logical network
Use the following steps in Windows Admin Center to create a logical network.

:::image type="content" source="./media/tenant-logical-networks/create-logical-network.png" alt-text="The Logical networks name box in Windows Admin Center." lightbox="./media/tenant-logical-networks/create-logical-network.png":::

1. On the Windows Admin Center home screen, under **All Connections**, select the cluster that you want to create the logical network on.
1. Under **Tools**, scroll down to the **Networking** area, and select **Logical networks**.
1. Under **Logical networks**, select the **Inventory** tab, then select **New**.
1. In the **Logical networks** pane, type a name for the logical network.
1. Under **Logical subnet**, select **Add**.

    :::image type="content" source="./media/tenant-logical-networks/create-logical-network-subnet.png" alt-text="Screenshot of Windows Admin Center home screen showing the Logical subnet pane." lightbox="./media/tenant-logical-networks/create-logical-network-subnet.png":::

1. In the **Logical subnet** pane, type a name for the subnet, and then provide the following information:
    1. A **VLAN ID** for the network.
    1. An **Address Prefix** in Classless Interdomain Routing (CIDR) notation.
    1. The **Default Gateway** for the network.
    1. The **DNS** server address, if needed.
    1. Select the **Public Logical network** checkbox if the logical network is to provide connectivity for external clients.
1. Under **Logical subnet IP Pools**, select **Add** and then provide the following information:
    1. A logical **IP Pool Name**
    1. A **Start IP address**
    1. An **End IP address**. The start and end IP addresses must be within the address prefix provided for the subnet.
    1. Select **Add**.
1. On the **Logical Subnet** page, select **Add**.
1. On the **Logical networks** page, select **Submit**.
1. In the **Logical networks** list, verify that the state of the logical network is **Healthy**.

## Get a list of logical networks
You can easily see all of the logical networks in your cluster.

:::image type="content" source="./media/tenant-logical-networks/list-logical-networks.png" alt-text="Screenshot of Windows Admin Center home screen showing the Inventory pane of Logical networks." lightbox="./media/tenant-logical-networks/list-logical-networks.png":::

1. On the Windows Admin Center home screen, under **All connections**, select the cluster on which you want to view logical networks.
1. Under **Tools**, scroll down to the **Networking** area, and select **Logical networks**.
1. The **Inventory** tab lists all logical networks available on the cluster, and provides commands to manage individual logical networks. You can:
    - View the list of logical networks.
    - View logical network settings, the state of each logical network, and whether network virtualization is enabled for each logical network. If network virtualization is enabled, you can also view the number of virtual networks associated with each logical network.
    - Change the settings of a logical network.
    - Delete a logical network.

## View logical network details
You can view detailed information for a specific logical network from its dedicated page.

:::image type="content" source="./media/tenant-logical-networks/view-logical-network-details.png" alt-text="Screenshot of Windows Admin Center showing the details view of a logical network." lightbox="./media/tenant-logical-networks/view-logical-network-details.png":::

1. Under **Tools**, scroll down to the **Networking** area, and select **Logical networks**.
1. Select the **Inventory** tab, and then select the logical network that you want to view details on. On the subsequent page, you can:
    - View the provisioning state of the logical network (Succeeded, Failed).
    - View whether network virtualization is enabled for the logical network.
    - View the subnets in the logical network.
    - Add new subnets, delete existing subnets, and modify the settings for a logical network subnet.
    - Select each subnet to go to its **Subnet** page, where you can add, remove, and modify logical subnet IP pools.
    - View virtual networks and connections associated with the logical network.

## Change a logical network's virtualization setting
You can change the network virtualization setting for a logical network.

:::image type="content" source="./media/tenant-logical-networks/change-logical-network-setting.png" alt-text="Screenshot of Windows Admin Center showing the Enable network virtualization checkbox option of a logical network." lightbox="./media/tenant-logical-networks/change-logical-network-setting.png":::

1. Under **Tools**, scroll down to the **Networking** area, and select **Logical networks**.
1. Select the **Inventory** tab, select the logical network, and then select **Settings**.
1. If you plan to deploy virtual networks on top of the logical network, under the logical network name, select the **Enable network virtualization** checkbox, and then select **Submit**.

## Delete a logical network
You can delete a logical network if you no longer need it.

:::image type="content" source="./media/tenant-logical-networks/delete-logical-network.png" alt-text="Screenshot of Windows Admin Center showing the Delete confirmation prompt to delete a logical network." lightbox="./media/tenant-logical-networks/delete-logical-network.png":::

1. Under **Tools**, scroll down to the **Networking** area, and select **Logical networks**.
1. Select the **Inventory** tab, select the virtual network, and then select **Delete**.
1. On the **Delete** confirmation prompt, select **Yes**.
1. Next to the **Logical networks** search box, select **Refresh** to ensure that the logical network has been deleted.

## Next steps
For more information, see also:
- [Manage tenant virtual networks](tenant-virtual-networks.md)
- [Software Defined Networking (SDN) in Azure Stack HCI](../concepts/software-defined-networking.md)
