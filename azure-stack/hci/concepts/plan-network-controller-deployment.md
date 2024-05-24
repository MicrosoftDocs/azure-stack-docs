---
title: Plan to deploy Network Controller on your Azure Stack HCI, version 23H2 cluster
description: This article covers how to plan to deploy Network Controller on your Azure Stack HCI via Windows Admin Center on a set of virtual machines (VMs).
author: AnirbanPaul
ms.author: anpaul
ms.topic: conceptual
ms.date: 05/22/2024
---

# Plan to deploy Network Controller for Azure Stack HCI, version 23H2

[!INCLUDE [applies-to](../../includes/hci-applies-to-23h2.md)]

Planning to deploy Network Controller via Windows Admin Center requires a set of virtual machines (VMs) running the Azure Stack HCI operating system. Network Controller is a highly available and scalable server role that requires a minimum of three VMs to provide high availability on your network.

> [!NOTE]
> We recommend that you deploy Network Controller on its own dedicated VMs.

## Network Controller requirements

The following are required before you deploy the Network Controller:

- A virtual hard disk (VHDX) for the Azure Stack HCI, version 23H2 operating system to create Network Controller VMs. Download the [VHDX file](../deploy/download-azure-stack-hci-23h2-software.md#download-azure-stack-hci-version-23h2-software).
- A domain name and credentials to join Network Controller VMs to a domain. These are the same domain name and credentials that were used for management settings during the [Azure Stack HCI deployment via Azure portal]( ../deploy/deploy-via-portal.md#specify-management-settings).
- At least one virtual switch that you configure using the Cluster Creation wizard in Windows Admin Center. If using a single network intent for management and compute, you can also use the default switch created during the Azure Stack HCI deployment.
- A physical network configuration that matches one of the [Supported topology options for Azure Stack HCI, version 23H2 deployment](../deploy/deployment-introduction.md#supported-network-topologies).
- You can also team the management physical adapters to use the same management switch. In this case, we still recommend using one of supported topology options.
- Management network information that Network Controller uses to communicate with Windows Admin Center and the Hyper-V hosts.
- Either DHCP-based or static network-based addressing for Network Controller VMs.
- The Representational State Transfer (REST) fully qualified domain name (FQDN) for Network Controller that the management clients use to communicate with the Network Controller.

   > [!NOTE]
   > Windows Admin Center currently does not support Network Controller authentication, either for communication with REST clients or communication between Network Controller VMs. You can use Kerberos-based authentication if you use PowerShell to deploy and manage it.

## Dynamic DNS updates

You can deploy Network Controller cluster nodes on either the same subnet or different subnets. If you plan to deploy Network Controller cluster nodes on different subnets, you must provide the Network Controller REST DNS name during the deployment process.

> [!NOTE]
> If you've deployed your Network Controllers with static IP addresses for your REST API services, there's no need to enable dynamic DNS.

### Enable dynamic DNS updates for a zone

To enable dynamic DNS updates for a zone, follow these steps:

1. On the DNS server, open the **DNS Manager** console.
1. In the left pane, select **Forward Lookup Zones**.
1. Right-click the zone that hosts the Network Controller name record, then select **Properties**.
1. On the **General** tab, next to **Dynamic updates**, select **Secure only**.

### Restrict dynamic updates to Network Controller nodes

To restrict dynamic updates of the Network Controller name record to only Network Controller nodes, follow these steps:

1. On the DNS server, open the **DNS Manager** console.
1. In the left pane, select **Forward Lookup Zones**.
1. Right-click the zone that hosts the Network Controller name record, then select **Properties**.
1. On the **Security** tab, select **Advanced**.
1. Select **Add**.
1. Choose **Select a principal**.
1. In the **Select User, Computer, Service Account, or Group** dialog box, select **Object Types**. Check **Computers** and select **OK**.
1. In the **Select User, Computer, Service Account, or Group** dialog box, enter the computer name of one of the Network Controller nodes and select **OK**.
1. In **Type**, select **Allow**.
1. In **Permissions**, check **Full Control**.
1. Select **OK**.
1. Repeat Steps 5 to 11 for all computers in the Network Controller cluster.

## Next steps

Now you’re ready to deploy Network Controller on VMs.

## See also

- [Deploy an Azure Stack HCI cluster](../deploy/deploy-via-portal.md)
- [Deploy an SDN infrastructure using SDN Express](../deploy/sdn-express-23h2.md)
- [What is Network Controller?](network-controller-overview.md)
- [Network Controller High Availability](/windows-server/networking/sdn/technologies/network-controller/network-controller-high-availability)
