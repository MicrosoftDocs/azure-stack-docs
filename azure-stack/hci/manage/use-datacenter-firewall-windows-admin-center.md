---
title: Configure network security groups with Windows Admin Center
description: Configure network security groups with Windows Admin Center
author: AnirbanPaul
ms.author: anpaul
ms.topic: how-to
ms.date: 09/27/2022
---

# Configure network security groups with Windows Admin Center

>Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022, Windows Server 2019, Windows Server 2016

This topic provides step-by-step instructions on how to use Windows Admin Center to create and configure network security groups (NSGs) to manage data traffic flow using Datacenter Firewall. It also provides instructions on managing network security groups on Software Defined Network (SDN) virtual and logical networks. You enable and configure Datacenter Firewall by creating network security groups and applying them to either a subnet or a network interface. To learn more, see [What is Datacenter Firewall?](../concepts/datacenter-firewall-overview.md) To use PowerShell scripts to do this, see [Configure network security groups with PowerShell](use-datacenter-firewall-powershell.md).

Before you configure network security groups, you need to deploy Network Controller. To learn about Network Controller, see [What is Network Controller?](../concepts/network-controller-overview.md) To deploy Network Controller using PowerShell scripts, see [Deploy an SDN infrastructure](sdn-express.md).

Additionally, if you want to apply network security groups to an SDN logical network, you need to first create a logical network. Likewise, if you want to apply network security groups to an SDN virtual network, you need to first create a virtual network. To learn more, see:

- [Manage tenant virtual networks](tenant-virtual-networks.md)
- [Manage tenant logical networks](tenant-logical-networks.md)

## Create a network security group

You can create a network security group in Windows Admin Center.

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to create the network security group on.
1. Under **Tools**, scroll down to the **Networking** area, and select **Network security groups**.
1. Under **Network security groups**, select the **Inventory** tab, and then select **New**.
1. In the **Network Security Group** pane, type a name for the network security group, and then select **Submit**.

    :::image type="content" source="./media/network-security-groups/create-network-security-group.png" alt-text="Screenshot of Windows Admin Center home screen showing the Network Security Group Name box." lightbox="./media/network-security-groups/create-network-security-group.png":::

1. Under **Network security groups**, verify that the **Provisioning state** of the new network security group shows **Succeeded**.

## Create network security group rules

After you create a network security group, you’re ready to create network security groups rules. If you want to apply network security group rules to both inbound and outbound traffic, you need to create two rules.

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to create the network security group on.
1. Under **Tools**, scroll down to the **Networking** area, and select **Network security groups**.
1. Under **Network security groups**, select the **Inventory** tab, and then select the network security group that you just created.
1. Under **Network security rule**, select **New**.

   :::image type="content" source="./media/network-security-groups/create-network-security-group-rules.png" alt-text="Screenshot of Windows Admin Center showing the Network security rule pane." lightbox="./media/network-security-groups/create-network-security-group-rules.png":::

1. In the **Network security rule** pane, provide the following information:
    1. **Name** of the rule.
    1. **Priority** of the rule – Acceptable values are **101** to **65000**. A lower value denotes a higher priority.
    1. **Types** – This can be inbound or outbound.
    1. **Protocol** – Specify the protocol to match either an incoming or outgoing packet. Acceptable values are **All**, **TCP** and **UDP**.
    1. **Source Address Prefix** – Specify the source address prefix to match either an incoming or outgoing packet. If you provide *, that denotes all source addresses.
    1. **Source Port Range** – Specify the source port range to match either an incoming or outgoing packet. If you provide *, that denotes all source ports.
    1. **Destination Address Prefix** – Specify the destination address prefix to match either an incoming or outgoing packet. If you provide *, that denotes all destination addresses.
    1. **Destination Port Range** – Specify the destination port range to match either an incoming or outgoing packet. If you provide *, that denotes all destination ports.
    1. **Actions** – If the above conditions are matched, specify either to allow or block the packet. Acceptable values are **Allow** and **Deny**.
    1. **Logging** – Specify either to enable or disable logging for the rule. If logging is enabled, all  traffic matched by this rule is logged on the host computers.
1. Select **Submit**.

## Apply a network security group to a virtual network

After you create a network security group and rules for it, you need to apply the network security group to either a virtual network subnet, a logical network subnet, or a network interface.

1. Under **Tools**, scroll down to the **Networking** area, and select **Virtual networks**.
1. Select the **Inventory** tab, and then select a virtual network. On the subsequent page, select a virtual network subnet, and then select **Settings**.

    :::image type="content" source="./media/network-security-groups/apply-network-security-group-virtual-network.png" alt-text="Screenshot of Windows Admin Center showing the Virtual subnet pane." lightbox="./media/network-security-groups/apply-network-security-group-virtual-network.png":::

1. Select a network security group from the drop-down list and then select **Submit**.

    Completing the last step associates the network security group with the virtual network subnet and applies it to all computers attached to the virtual network subnet.

## Apply a network security group to a logical network

You can apply a network security group to a logical network subnet.

1. Under **Tools**, scroll down to the **Networking** area, and select **Logical networks**.
1. Select the **Inventory** tab, and then select a logical network. On the subsequent page, select a logical subnet, and then select **Settings**.

1. Select a network security group from the drop-down list and then select **Add**.

    Completing the last step associates the network security group with the logical network subnet and applies it to all computers attached to the logical network subnet.

## Apply a network security group to a network interface

You can apply a network security group to a network interface, either while creating a virtual machine (VM) or later.

1. Under **Tools**, scroll down to the **Networking** area, and select **Virtual machines**.
1. Select the **Inventory** tab, select a VM, and then select **Settings**.
1. On the **Settings** page, select **Networks**.
1. Scroll down to **Network security group**, expand the drop-down list, select a network security group, and select **Save network settings**.

    :::image type="content" source="./media/network-security-groups/apply-network-security-group-network-interface.png" alt-text="Screenshot of Windows Admin Center showing the Network setting option to associate a network security group with a network interface." lightbox="./media/network-security-groups/apply-network-security-group-network-interface.png":::

    Completing the last step associates the network security group with the network interface and applies it to all incoming and outgoing traffic for the network interface.

## Get a list of network security groups

You can easily view all the network security groups in your cluster in a list.

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to view a list of network security groups on.
1. Under **Tools**, scroll down to the **Networking** area, and select **Network security groups**.
1. The **Inventory** tab displays the list of the network security groups available on the cluster and provides commands that you can use to manage individual network security groups in the list. You can:
    - View the network security groups list.
    - View the number of rules for each network security group, and the number of applied subnets and NICs applied to each network security group.
    - View the **Provisioning State** of each network security group (**Succeeded**, **Failed**).
    - Delete a network security group.
    - If you select a network security group in the list, you can view its rules. You can then add, delete, or modify network security group rule settings.

        :::image type="content" source="./media/network-security-groups/get-network-security-groups-list.png" alt-text="Screenshot of Windows Admin Center showing a list of network security groups on the Inventory tab." lightbox="./media/network-security-groups/get-network-security-groups-list.png":::

## Delete a network security group

You can delete a network security group if you no longer need it.

>[!NOTE]
> After you delete a network security group from the list of network security groups, ensure that it is not associated with either a subnet or a network interface.

1. Under **Tools**, scroll down to the **Networking** area, and select **Network security groups**.
1. Select the **Inventory** tab, select a network security group in the list, and then select **Delete**.
1. On the **Delete Confirmation** prompt select **Yes**.

    :::image type="content" source="./media/network-security-groups/delete-network-security-group.png" alt-text="Screenshot of Windows Admin Center showing the Delete confirmation prompt to delete a network security group." lightbox="./media/network-security-groups/delete-network-security-group.png":::

1. Next to the search box, select **Refresh** to ensure that the network security group has been deleted.

## Next steps

For more information, see also:

- [Software Defined Networking (SDN) in Azure Stack HCI and Windows Server](../concepts/software-defined-networking.md)
