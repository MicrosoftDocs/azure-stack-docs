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

<!--- Maybe retitle to Use Datacenter Firewall to create ACLs with PowerShell.--->

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

## Create an ACL rule
TBD

## Apply an ACL to a virtual network
TBD

## Apply an ACL to a network interface
TBD

## Get a list of ACLs
TBD

## Delete an ACL
TBD

<!---Example note format.--->
   >[!NOTE]
   > TBD.

<!---Example figure format--->
<!---:::image type="content" source="./media/network-controller/topology-option-1.png" alt-text="Option 1 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-1.png":::--->

## Next steps
For more information, see also:
- [Software Defined Networking (SDN) in Azure Stack HCI](../concepts/software-defined-networking.md)
