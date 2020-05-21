---
title: Use Azure Network Adapter to connect a server to an Azure Virtual Network
description: This article provides requirements and steps on how to use Azure Network Adapter to connect a Windows Server to an Azure Virtual Network.
ms.topic: article
author: thomasmaurer
ms.author: thmaure
ms.date: 05/20/2020
---

# Use Azure Network Adapter to connect a server to an Azure Virtual Network

>Applies to: Windows Server 2019, Windows Server 2016, Windows Server 2012 R2

A lot of workloads running on-premises and in multi-cloud environments require
connections to virtual machines (VMs) running in Microsoft Azure. To connect a
server to an Azure Virtual Network, you have several options, including
Site-to-Site VPN, Azure Express Route, and Point-to-Site VPN.

Windows Admin Center and Azure Network Adapter provide a one-click experience to
connect the server with your Virtual Network using a [Point-to-Site
VPN](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal)
connection. The process automates configuring the Virtual Network gateway and the on-premises VPN client.

## When to use Azure Network Adapter
Azure Network Adapter Point-to-Site VPN connections are useful when you want to
connect to your Virtual Network from a remote location, such as a branch office,
store, or other location. You can also use Azure Network Adapter instead of a
Site-to-Site VPN when you require only a few servers to connect
to a Virtual Network. Azure Network Adapter connections don't require a VPN
device or a public-facing IP address.

### Requirements
Using Azure Network Adapter to connect to a Virtual Network requires the
following:
- An Azure account with at least one active subscription.
- An existing Virtual Network.
- Internet access for the target Windows servers that you want to back up to Azure.
- A Windows Admin Center connection to Azure.
  To learn more, see [Configuring Azure integration](https://docs.microsoft.com/windows-server/manage/windows-admin-center/azure/azure-integration).
- The latest version of Windows Admin Center.
  To learn more, see [Windows Admin Center](https://www.microsoft.com/windows-server/windows-admin-center).

> [!NOTE]
> It’s not required to install Windows Admin Center on the server that you want to connect to Azure. However, you can do that in a single server scenario.

## Add Azure Network Adapter to a Windows Server
To configure Azure Network Adapter, go to the Network extension for it in Windows Admin Center.

In Windows Admin Center:
1. Navigate to the server or cluster hosting the VMs that you want to add to Azure Network Adapter.
1. Under **Tools**, select **Networks**.
1. Select **Add Azure Network Adapter**.
1. On the **Add Azure Network Adapter** pane, enter the following required information, and then select **Create**:
    - **Subscription**
    - **Location**
    - **Virtual Network**
    - **Gateway Subnet** (if doesn’t exist)
    - **Gateway SKU** (if doesn’t exist)
    - **Client Address Space**

        The client address pool is a range of private IP addresses that you specify. The clients that connect over a Point-to-Site VPN dynamically receive an IP address from this range. Use a private IP address range that does not overlap with the on-premises location that you connect from, or the Virtual Network that you want to connect to.

    - **Authentication Certificate**

        Azure uses certificates to authenticate clients connecting to a Virtual Network over a Point-to-Site VPN connection. The public key information of the root certificate is uploaded to Azure. The root certificate is then considered “trusted” by Azure for a Point-to-Site connection to the Virtual Network. Client certificates must be generated from the trusted root certificate and installed on the client server. The client certificate is used to authenticate the client when it initiates a connection to the Virtual Network.
    
        To learn more, see the “Configure authentication type” section of [Configure a Point-to-Site VPN connection to a VNet using native Azure certificate authentication: Azure portal](https://docs.microsoft.com/azure/vpn-gateway/vpn-gateway-howto-point-to-site-resource-manager-portal).

    :::image type="content" source="media/azure-network-adapter/add-azure-network-adapter.png" alt-text="The Add Azure Network Adapter pane in Windows Admin Center.":::

> [!NOTE]
> Network appliances such as VPN Gateway and Application Gateway that run inside a virtual network are charged. To learn more, see [Virtual Network pricing](https://azure.microsoft.com/pricing/details/virtual-network/).

If there is no existing Azure Virtual Network gateway, Windows Admin Center creates one for you. The setup process can take up to 25 minutes. After the Azure Network Adapter is created, you can start to access VMs in the Virtual Network directly from your Windows Server.

If you don’t need the connectivity anymore, on the **Disconnect VPN Confirmation** pop-up window, select **Yes**.

## Next steps
For more information about Azure Virtual Network, see also:

- [Azure Virtual Network frequently asked questions (FAQ)](https://docs.microsoft.com/azure/virtual-network/virtual-networks-faq)
