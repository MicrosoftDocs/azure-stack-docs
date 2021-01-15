---

title: Troubleshoot site-to-site VPN connections in Azure Stack Hub
description: Troubleshooting steps you can take after you configure a site-to-site VPN connection between an on-premises network and an Azure Stack Hub virtual network.
author: sethmanheim
ms.author: sethm
ms.date: 11/22/2020
ms.topic: article
ms.reviewer: sranthar
ms.lastreviewed: 11/22/2020

---

# Troubleshoot site-to-site VPN connections

This article describes troubleshooting steps you can take after you configure a site-to-site (S2S) VPN connection between an on-premises network and an Azure Stack Hub virtual network, and the connection suddenly stops working and cannot be reconnected.

If your Azure Stack Hub issue is not addressed in this article, you can visit the [Azure Stack Hub MSDN forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack).

You also can submit an Azure support request. Please see [Azure Stack Hub support](../operator/azure-stack-manage-basics.md#where-to-get-support).

> [!NOTE]
> Only one site-to-site VPN connection can be created between two Azure Stack Hub deployments. This is due to a limitation in the platform that only allows a single VPN connection to the same IP address. Because Azure Stack Hub leverages the multi-tenant gateway, which uses a single public IP for all VPN gateways in the Azure Stack Hub system, there can be only one VPN connection between two Azure Stack Hub systems. This limitation also applies to connecting more than one site-to-site VPN connection to any VPN gateway that uses a single IP address. Azure Stack Hub does not allow more than one local network gateway resource to be created using the same IP address.

## Initial troubleshooting steps

The Azure Stack Hub default parameters for IPsec/IKEV2 have changed [starting with the 1910 build](../user/azure-stack-vpn-gateway-settings.md#ike-phase-1-main-mode-parameters) Please contact your Azure Stack Hub operator for more information on the build version.

> [!IMPORTANT]
> When using an S2S tunnel, packets are further encapsulated with additional headers. This encapsulation increases the overall size of the packet. In these scenarios, you must clamp TCP **MSS** at **1350**. If your VPN devices do not support MSS clamping, you can set the MTU on the tunnel interface to **1400** bytes instead. For more information, see [Virutal Network TCPIP performance tuning](/azure/virtual-network/virtual-network-tcpip-performance-tuning).

- Confirm that the VPN configuration is route-based (IKEv2). Azure Stack Hub does not support policy-based (IKEv1) configurations.

- Check whether you are using a [validated VPN device and operating system version](/azure/vpn-gateway/vpn-gateway-about-vpn-devices#devicetable). If the device is not a validated VPN device, you might have to contact the device manufacturer to see if there is a compatibility issue.

- Verify that there are no overlapping IP ranges between Azure Stack Hub virtual network and on-premises network. This can cause connectivity issues. 

- Verify the VPN peer IPs:

  - The IP definition in the **Local Network Gateway** object in Azure Stack Hub should match the on-premises device IP.

  - The Azure Stack Hub gateway IP definition that is set on the on-premises device should match the Azure Stack Hub gateway IP.

## Status "Not Connected" - intermittent disconnects

### [Az modules](#tab/az)

- Compare the shared key for the on-premises VPN device to the AzSH virtual network VPN to make sure that the keys match. To view the shared key for the AzSH VPN connection, use one of the following methods:

  - **Azure Stack Hub tenant portal**: Go to the VPN gateway site-to-site connection that you created. In the **Settings** section, select **Shared key**.

      :::image type="content" source="media/site-to-site/vpn-connection.png" alt-text="VPN connection":::

  - **Azure PowerShell**: Use the following PowerShell command:

```powershell
Get-AzVirtualNetworkGatewayConnectionSharedKey -Name <Connection name> -ResourceGroupName <Resource group>
```

### [AzureRM modules](#tab/azurerm)

- Compare the shared key for the on-premises VPN device to the AzSH virtual network VPN to make sure that the keys match. To view the shared key for the AzSH VPN connection, use one of the following methods:

  - **Azure Stack Hub tenant portal**: Go to the VPN gateway site-to-site connection that you created. In the **Settings** section, select **Shared key**.

      :::image type="content" source="media/site-to-site/vpn-connection.png" alt-text="VPN connection":::

  - **Azure PowerShell**: Use the following PowerShell command:

```powershell
Get-AzurerRMVirtualNetworkGatewayConnectionSharedKey -Name <Connection name> -ResourceGroupName <Resource group>
```

---

## Status "Connected" - traffic not flowing

- Check for, and remove the user-defined routing (UDR) and network security groups (NSGs) on the gateway subnet, and then test the result. If the problem is resolved, validate the settings that UDR or NSG applied.

   A user-defined route on the gateway subnet may be restricting some traffic and allowing other traffic. This makes it appear that the VPN connection is unreliable for some traffic, and good for others.

- Check the on-premises VPN device external interface address. 

  - If the internet-facing IP address of the VPN device is included in the **Local network** definition in Azure Stack Hub, you might experience sporadic disconnections.

  - The device's external interface must be directly on the internet. There should be no network address translation or firewall between the internet and the device.

  - To configure firewall clustering to have a virtual IP, you must break the cluster and expose the VPN appliance directly to a public interface with which the gateway can interface.

- Verify that the subnets match exactly.

  - Verify that the virtual network address space(s) match exactly between the Azure Stack Hub virtual network and on-premises definitions.

  - Verify that the subnets match exactly between the **Local Network Gateway** and on-premises definitions for the on-premises network.

## Create a support ticket

If none of the preceding steps resolve your issue, please create a [support ticket](../operator/azure-stack-manage-basics.md#where-to-get-support) and use the [on demand log collection tool](../operator/diagnostic-log-collection.md) to provide logs.