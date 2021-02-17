---
title: Manage tenant virtual networks
description: This topic provides step-by-step instructions on how to use Windows Admin Center to create, update, and delete Hyper-V Network Virtualization (HNV) virtual networks after you have deployed Software Defined Networking (SDN).
author: AnirbanPaul
ms.author: anpaul
ms.topic: how-to
ms.date: 02/01/2021
---

# Manage tenant virtual networks

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019, Windows Server 2016

This topic provides step-by-step instructions on how to use Windows Admin Center to create, update, and delete Hyper-V Network Virtualization (HNV) virtual networks after you have deployed Software Defined Networking (SDN).

HNV helps you isolate tenant networks so that each tenant network is a separate entity. Each entity has no cross-connection possibility, unless you either configure public access workloads or peering between virtual networks.

## Create a virtual network
Use the following steps in Windows Admin Center to create a virtual network.

:::image type="content" source="./media/tenant-virtual-networks/create-virtual-network.png" alt-text="Screenshot of Windows Admin Center home screen showing pane in which to create a Virtual network name and address prefix." lightbox="./media/tenant-virtual-networks/create-virtual-network.png":::

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to create the virtual network on.
1. Under **Tools**, scroll down to the **Networking** area, and select **Virtual networks**.
1. Under **Virtual networks**, select the **Inventory** tab, and then select **New**.
1. In the **Virtual networks** pane, type a name for the virtual network.
1. Under **Address Prefixes** select **Add**, and then type an address prefix in Classless Interdomain Routing (CIDR) notation. You can optionally add more address prefixes.
1. Under **Subnets**, select **Add**, type a name for the subnet, and then provide an address prefix in CIDR notation.

   >[!NOTE]
   > The subnet address prefix must be within the address prefix range that you defined in **Address Prefixes** of the virtual network.

1. Select **Submit** or optionally add more subnets and then select **Submit**.
1. In the **Virtual networks** list, verify that the state of the virtual network is **Healthy**.

## Get a list of virtual networks
You can easily see all the virtual networks in your cluster.

:::image type="content" source="./media/tenant-virtual-networks/list-virtual-networks.png" alt-text="Screenshot of Windows Admin Center showing list of virtual networks." lightbox="./media/tenant-virtual-networks/list-virtual-networks.png":::

1. On the Windows Admin Center home screen, under **All connections**, select the cluster on which you want to view virtual networks.
1. Under **Tools**, scroll down to the **Networking** area, and select **Virtual networks**.
1. The **Inventory** tab lists all virtual networks available on the cluster, and provides commands to manage individual virtual networks. You can:
    - View the list of virtual networks.
    - View virtual network settings, the state of each virtual network, and the number of virtual machines (VMs) connected to each virtual network.
    - Change the settings of a virtual network.
    - Delete a virtual network.

## View virtual network details
You can view detailed information for a specific virtual network from its dedicated page.

:::image type="content" source="./media/tenant-virtual-networks/view-virtual-network-details.png" alt-text="Screenshot of Windows Admin Center showing the details view of a virtual network." lightbox="./media/tenant-virtual-networks/view-virtual-network-details.png":::

1. Under **Tools**, scroll down to the **Networking** area, and select **Virtual networks**.
1. Select the **Inventory** tab, and then select the virtual network that you want to view details on. On the subsequent page, you can:
    - View the **Provisioning State** of the virtual network (Succeeded, Failed).
    - View the **Configuration State** of the virtual network (Healthy, Error, Warning, Unknown).
    - View the underlying **Logical Network** of the virtual network.
    - View the **Address Space** of the virtual network.
    - Add new subnets, delete existing subnets, and modify the settings of a virtual network subnet.
    - View **Virtual machine connections** to the virtual network.

## Change virtual network settings
You can update virtual network address prefixes, manage virtual network peering, and configure a Border Gateway Protocol (BGP) router and peers for the virtual network.

:::image type="content" source="./media/tenant-virtual-networks/change-virtual-network-settings.png" alt-text="Screenshot of Windows Admin Center showing the Settings view of a virtual network." lightbox="./media/tenant-virtual-networks/change-virtual-network-settings.png":::

1. Under **Tools**, scroll down to the **Networking** area, and select **Virtual networks**.
1. Select the **Inventory** tab, select a virtual network, and then select **Settings**.
1. On the **General** tab, you can:
    - Remove existing address prefixes or add new ones.
    - Configure peering with another virtual network.
    - Add a BGP router to the virtual network. To do so, you need to provide the BGP router name and Autonomous System Number (ASN) number.
    - Add one or more BGP peers for the BGP router. To do so, you need to provide each BGP peer name, and the ASN number for each BGP peer.

## Delete a virtual network
You can delete a virtual network if you no longer need it.

:::image type="content" source="./media/tenant-virtual-networks/delete-virtual-network.png" alt-text="Screenshot of Windows Admin Center showing the Delete virtual network confirmation prompt." lightbox="./media/tenant-virtual-networks/delete-virtual-network.png":::

1. Under **Tools**, scroll down to the **Networking** area, and select **Virtual networks**.
1. Select the **Inventory** tab, select a virtual network, and then select **Delete**.
1. On the **Delete virtual network** confirmation prompt, select **Delete**.
1. Next to the Virtual networks search box, select **Refresh** to ensure that the virtual network has been deleted.

## Next steps
For more information, see also:
- [Software Defined Networking (SDN) in Azure Stack HCI](../concepts/software-defined-networking.md)
