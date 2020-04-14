---

title: Intent and product brand in a unique string of 43-59 chars including spaces. Do not include site identifier (it is auto-generated).
description: 115-145 characters including spaces. This abstract displays in the search result.
author: sethmanheim
ms.author: sethm
ms.date: 4/14/2020
ms.topic: article
ms.reviewer: sranthar
ms.lastreviewed: 04/14/2020

---

# Troubleshoot site-to-site VPN connections

This article describes troubleshooting steps you can take after you configure a site-to-site (S2S) VPN connection between an on-premises network and an Azure Stack Hub virtual network, and the connection suddenly stops working and cannot be reconnected.

If your Azure Stack Hub issue is not addressed in this article, you can visit the [Azure Stack Hub MSDN forum](https://social.msdn.microsoft.com/Forums/azure/home?forum=azurestack).

You also can submit an Azure support request. Please see [Azure Stack Hub support](azure-stack-manage-basics.md#where-to-get-support).

## Troubleshooting steps

The Azure Stack Hub default parameters for IPsec/IKEV2 have changed [starting with the 1910 build](../user/azure-stack-vpn-gateway-settings.md#ike-phase-1-main-mode-parameters) Please contact your Azure Stack Hub operator for more information on the build version.

- Check whether you are using a [validated VPN device and operating system version](/azure/vpn-gateway/vpn-gateway-about-vpn-devices#devicetable). If the device is not a validated VPN device, you might have to contact the device manufacturer to see if there is a compatibility issue.

- Compare the shared key for the on-premises VPN device to the AzSH virtual network VPN to make sure that the keys match. To view the shared key for the AzSH VPN connection, use one of the following methods:

  - **Azure Stack Hub tenant portal**: Go to the VPN gateway site-to-site connection that you created. In the **Settings** section, select **Shared key**.

      :::image type="content" source="media/site-to-site/vpn-connection.png" alt-text="VPN connection":::

  - **Azure PowerShell**: Use the following PowerShell command:

      ```powershell
      Get-AzureRMVirtualNetworkGatewayConnectionSharedKey -Name <Connection name> -ResourceGroupName <Resource group>
      ```

- Verify the VPN peer IPs:

  - The IP definition in the **Local Network Gateway** object in Azure Stack Hub should match the on-premises device IP.

  - The Azure Stack Hub gateway IP definition that is set on the on-premises device should match the Azure Stack Hub gateway IP.

- Check the security association settings (for policy-based Azure virtual network gateways). Verify that the security association settings match.

- Check for, and remove the user-defined routing (UDR) and network security groups (NSGs) on the gateway subnet, and then test the result. If the problem is resolved, validate the settings that UDR or NSG applied.

   A user-defined route on the gateway subnet may be restricting some traffic and allowing other traffic. This makes it appear that the VPN connection is unreliable for some traffic, and good for others.

- Check the on-premises VPN device external interface address. 

  - If the internet-facing IP address of the VPN device is included in the **Local network** definition in Azure Stack Hub, you might experience sporadic disconnections.

  - The device's external interface must be directly on the internet. There should be no network address translation or firewall between the internet and the device.

  - To configure firewall clustering to have a virtual IP, you must break the cluster and expose the VPN appliance directly to a public interface with which the gateway can interface.

- Verify that the subnets match exactly.

  - Verify that the virtual network address space(s) match exactly between the Azure Stack Hub virtual network and on-premises definitions.

  - Verify that the subnets match exactly between the **Local Network Gateway** and on-premises definitions for the on-premises network.

- Check whether the on-premises VPN device has the perfect forward secrecy feature enabled. This feature can cause disconnection problems. If the VPN device has perfect forward secrecy enabled, disable the feature. Then, update the VPN gateway IPsec policy.

## Create a support ticket

If none of the preceding steps resolve your issue, please create a [support ticket](azure-stack-manage-basics.md#where-to-get-support) and use the [on demand log collection tool](azure-stack-configure-on-demand-diagnostic-log-collection.md) to provide logs.
