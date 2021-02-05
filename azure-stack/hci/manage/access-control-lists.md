---
title: Manage access control lists (ACLs) for network access
description: This topic provides instructions on how to use Windows Admin Center to create and configure access control lists (ACLs) to manage data traffic flow using Datacenter Firewall and ACLs on Software Defined Network (SDN) logical and virtual networks.
author: AnirbanPaul
ms.author: anpaul
ms.topic: how-to
ms.date: 02/05/2021
---

# Manage access control lists (ACLs) for network access

>Applies to: Azure Stack HCI, version 20H2; Windows Server 2019, Windows Server 2016

This topic provides step-by-step instructions on how to use Windows Admin Center to create and configure access control lists (ACLs) to manage data traffic flow using Datacenter Firewall. It also provides instructions on managing ACLs on Software Defined Network (SDN) logical and virtual networks. You enable and configure Datacenter Firewall by creating ACLs and applying them to either a subnet or a network interface. To learn more, see [What is Datacenter Firewall?](../concepts/datacenter-firewall-overview.md) To use PowerShell scripts to create and manage ACLs, see [Use Datacenter Firewall](use-datacenter-firewall.md).

Before you configure ACLs, you need to deploy Network Controller. To learn about Network Controller, see [What is Network Controller?](../concepts/network-controller-overview.md) To deploy Network Controller using PowerShell scripts, see [Deploy an SDN infrastructure](sdn-express.md).

<!---Deploying NC pulled from the Cluster creation wizard. Note in review handoff to Anirban.--->

Additionally, if you want to apply ACLs to an SDN logical network, you need to first create a logical network. Likewise, if you want to apply ACLs to an SDN virtual network, you need to first create a virtual network. To learn more, see:
- [Manage tenant logical networks](tenant-logical-networks.md)
- [Manage tenant virtual networks](tenant-virtual-networks.md)

## Create an ACL
You can easily create an ACL in Windows Admin Center.

:::image type="content" source="./media/access-control-lists/create-acl.png" alt-text="Screenshot of Windows Admin Center home screen showing the Access Control List Name box." lightbox="./media/access-control-lists/create-acl.png":::

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to create the ACL on.
1. Under **Tools**, scroll down to the **Networking** area, and select **Access control lists**.
1. Under **Access control lists**, select the **Inventory** tab, and then select **New**.
1. In the **Access Control List** pane, type a name for the ACL, and then select **Submit**.
1. Under **Access control lists**, verify that the **Provisioning state** of the new ACL shows **Succeeded**.

## Create ACL rules
After you create an ACL, you’re ready to create ACLs rules. If you want to apply ACL rules to both inbound and outbound traffic, you need to create two rules.

:::image type="content" source="./media/access-control-lists/create-acl-rules.png" alt-text="Screenshot of Windows Admin Center showing the Access Control Rule pane." lightbox="./media/access-control-lists/create-acl-rules.png":::

1. On the Windows Admin Center home screen, under **All connections**, select the cluster that you want to create the ACL on.
1. Under **Tools**, scroll down to the **Networking** area, and select **Access control lists**.
1. Under **Access control lists**, select the **Inventory** tab, and then select the ACL that you just created.
1. Under **Access Control Rule**, select **New**.
1. In the **Access Control Rule** pane, provide the following information:
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

## Apply an ACL to a virtual network
After you create an ACL and rules for it, you need to apply them to either a virtual network subnet, a logical network subnet, or a network interface.

:::image type="content" source="./media/access-control-lists/apply-acl-virtual-netowrk.png" alt-text="Screenshot of Windows Admin Center showing the Virtual subnet pane." lightbox="./media/access-control-lists/apply-acl-virtual-netowrk.png":::

1. Under **Tools**, scroll down to the **Networking** area, and select **Virtual networks**.
1. Select the **Inventory** tab, and then select a virtual network. On the subsequent page, select a virtual network subnet, and then select **Settings**.
1. Select an ACL from the drop-down list and then select **Submit**.

    Completing the last step associates the ACL with the virtual network subnet and applies it to all computers attached to the virtual network subnet.

## Apply an ACL to a network interface
You can apply an ACL to a network Interface, either while creating a virtual machine (VM) or later.

:::image type="content" source="./media/access-control-lists/apply-acl-network-interface.png" alt-text="Screenshot of Windows Admin Center showing the Network setting option to associates an ACL with a network interface." lightbox="./media/access-control-lists/apply-acl-network-interface.png":::

1. Under **Tools**, scroll down to the **Networking** area, and select **Virtual machines**.
1. Select the **Inventory** tab, select a VM, and then select **Settings**.
1. On the **Settings** page, select **Networks**.
1. Scroll down to **Access control list**, expand the drop-down list, select an ACL, and select **Save network settings**.

    Completing the last step associates the ACL with the network interface and applies it to all incoming and outgoing traffic for the network interface.

## Get a list of ACLs
TBD

## Delete an ACL
TBD

<!---Example note format.--->
   >[!NOTE]
   > TBD.

## Next steps
For more information, see also:
- [Software Defined Networking (SDN) in Azure Stack HCI](../concepts/software-defined-networking.md)
