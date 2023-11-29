---
title: Plan to deploy Network Controller
description: This article covers how to plan to deploy Network Controller via Windows Admin Center on a set of virtual machines (VMs).
author: AnirbanPaul
ms.author: anpaul
ms.topic: conceptual
ms.date: 11/29/2023
---

# Plan to deploy Network Controller

> Applies to: Azure Stack HCI, versions 22H2 and 21H2; Windows Server 2022, Windows Server 2019, Windows Server 2016

Planning to deploy Network Controller via Windows Admin Center requires a set of virtual machines (VMs) running the Azure Stack HCI or Windows Server operating system. Network Controller is a highly available and scalable server role that requires a minimum of three VMs to provide high availability on your network.

   >[!NOTE]
   > We recommend deploying Network Controller on its own dedicated VMs.

## Network Controller requirements

The following is required to deploy Network Controller:

- A virtual hard disk (VHD) for the Azure Stack HCI operating system to create Network Controller VMs.
- A domain name and credentials to join Network Controller VMs to a domain.
- At least one virtual switch that you configure using the Cluster Creation wizard in Windows Admin Center.
- A physical network configuration that matches one of the topology options in this section.

    Windows Admin Center creates the configuration within the Hyper-V host. However, the management network must connect to the host physical adapters according to one of the following three options:

    **Option 1**: The management network is physically separated from the workload networks. This option uses a single virtual switch for both compute and storage:

    :::image type="content" source="./media/network-controller/topology-option-1.png" alt-text="Option 1 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-1.png":::

    **Option 2**: The management network is physically separated from the workload networks. This option uses a single virtual switch for compute only:

    :::image type="content" source="./media/network-controller/topology-option-2.png" alt-text="Option 2 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-2.png":::

    **Option 3**: The management network is physically separated from the workload networks. This option uses two virtual switches, one for compute, and one for storage:

    :::image type="content" source="./media/network-controller/topology-option-3.png" alt-text="Option 3 to create a physical network for the Network Controller." lightbox="./media/network-controller/topology-option-3.png":::

- You can also team the management physical adapters to use the same management switch. In this case, we still recommend using one of options in this section.
- Management network information that Network Controller uses to communicate with Windows Admin Center and the Hyper-V hosts.
- Either DHCP-based or static network-based addressing for Network Controller VMs.
- The Representational State Transfer (REST) fully qualified domain name (FQDN) for Network Controller that the management clients use to communicate with the Network Controller.

   >[!NOTE]
   > Windows Admin Center currently does not support Network Controller authentication, either for communication with REST clients or communication between Network Controller VMs. You can use Kerberos-based authentication if you use PowerShell to deploy and manage it.

## Dynamic DNS updates

You can deploy Network Controller cluster nodes on either the same subnet or different subnets. If you plan to deploy Network Controller cluster nodes on different subnets, you must provide the Network Controller REST DNS name during the deployment process.

> [!NOTE]
> If you've deployed your Network Controllers with static IP addresses for your REST API services, there's no need to enable dynamic DNS.

### Enable dynamic DNS updates for a zone

To enable dynamic DNS updates for a zone, follow these steps:

1. On the DNS server, open the **DNS Manager** console.
1. In the left pane, select **Forward Lookup Zones**.
1. Right-click the zone that hosts the Network Controller name record, then click **Properties**.
1. On the **General** tab, next to **Dynamic updates**, select **Secure only**.

### Restrict dynamic updates to Network Controller nodes

To restrict dynamic updates of the Network Controller name record to only Network Controller nodes, follow these steps:

1. On the DNS server, open the **DNS Manager** console.
1. In the left pane, select **Forward Lookup Zones**.
1. Right-click the zone that hosts the Network Controller name record, then click **Properties**.
1. On the **Security** tab, select **Advanced**.
1. Select **Add**.
1. Choose **Select a principal**.
1. In the **Select User, Computer, Service Account, or Group** dialog box, select **Object Types**. Check **Computers** and click **OK**.
1. In the **Select User, Computer, Service Account, or Group** dialog box, enter the computer name of one of the Network Controller nodes and click **OK**.
1. In **Type**, select **Allow**.
1. In **Permissions**, check **Full Control**.
1. Click **OK**.
1. Repeat Steps 5 to 11 for all computers in the Network Controller cluster.

## Next steps

Now you’re ready to deploy Network Controller on VMs.

## See also

- [Create an Azure Stack HCI cluster](../deploy/create-cluster.md)
- [Deploy an SDN infrastructure using SDN Express](../manage/sdn-express.md)
- [Network Controller overview](network-controller-overview.md)
- [Network Controller High Availability](/windows-server/networking/sdn/technologies/network-controller/network-controller-high-availability)