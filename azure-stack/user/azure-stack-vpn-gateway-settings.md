---
title: Configure VPN gateway settings for Azure Stack Hub
description: Configure Azure Stack VPN gateway settings including gateway SKUs, VPN types, and IPsec/IKE parameters. Start building secure S2S connections.
author: sethmanheim
ms.topic: how-to
ms.date: 07/09/2026
ms.author: sethm
ms.reviewer: cedward
ms.lastreviewed: 02/03/2022
ms.custom:
  - devx-track-azurepowershell
  - sfi-image-nochange

# Intent: As an Azure Stack user, I want to configure my VPN gateway settings so that my VPN gateway works the way I want it to.
# Keyword: azure stack vpn gateway settings
---


# Configure VPN gateway settings for Azure Stack Hub

A VPN gateway is a type of virtual network gateway that sends encrypted traffic between your virtual network in Azure Stack Hub and a remote VPN gateway. The remote VPN gateway can be in Azure, a device in your datacenter, or a device on another site. If there is network connectivity between the two endpoints, you can establish a secure Site-to-Site (S2S) VPN connection between the two networks.

A VPN gateway relies on the configuration of multiple resources, each of which contains configurable settings. This article describes the resources and settings that relate to a VPN gateway for a virtual network that you create in the Resource Manager deployment model. You can find descriptions and topology diagrams for each connection solution in [Create VPN gateways for Azure Stack Hub](azure-stack-vpn-gateway-about-vpn-gateways.md).

## VPN gateway settings

### Gateway types

Each Azure Stack Hub virtual network supports a single virtual network gateway, which must be of the type **Vpn**. This support is different from Azure, which supports additional types.

When you create a virtual network gateway, you must make sure that the gateway type is correct for your configuration. A VPN gateway requires the `-GatewayType Vpn` flag; for example:

```powershell
New-AzVirtualNetworkGateway -Name vnetgw1 -ResourceGroupName testrg `
   -Location 'West US' -IpConfigurations $gwipconfig -GatewayType Vpn `
   -VpnType RouteBased
```

### Gateway SKUs without VPN Fast Path Enabled

When you create a virtual network gateway, specify the SKU that you want to use. Select the SKUs that satisfy your requirements based on the types of workloads, throughput, features, and SLAs.

You can have 10 high performance gateways or 20 basic and standard before you reach the maximum capacity.

Azure Stack Hub offers the VPN gateway SKUs shown in the following table:

| SKU | Max VPN Connection throughput | Max # of connections per active GW VM | Max # of VPN Connections per stamp |
|-------|-------|-------|-------|
|**Basic**| 100 Mbps Tx/Rx | 10 | 20 |
|**Standard** | 100 Mbps Tx/Rx | 10 | 20 |
|**High Performance** | 200 Mbps Tx/Rx | 5 | 10 |

### Gateway SKUs with VPN Fast Path enabled

When Microsoft released the VPN Fast Path public preview, Azure Stack Hub added support for three new SKUs with higher throughput.

When you enable VPN Fast Path on your Azure Stack stamp, you get new limits and throughput.

Azure Stack Hub offers the VPN gateway SKUs shown in the following table:

| SKU | Max VPN Connection throughput |Max # of connections per active GW VM | Max # of VPN Connections per stamp |
|-------|-------|-------|-------|
|**Basic** | 100 Mbps Tx/Rx | 25 | 50 |
|**Standard** | 100 Mbps Tx/Rx | 25 | 50 |
|**High Performance** | 200 Mbps Tx/Rx | 12 | 24 |
|**VPNGw1**| 650 Mbps Tx/Rx | 3 | 6 |
|**VPNGw2**| 1000 Mbps Tx/Rx | 2 | 4 |
|**VPNGw3**| 1250 Mbps Tx/Rx | 2 | 4 |

### Resizing virtual network gateway SKUs

Azure Stack Hub doesn't support resizing from a supported legacy SKU (**Basic**, **Standard**, and **HighPerformance**) to a newer SKU supported by Azure (**VpnGw1**, **VpnGw2**, and **VpnGw3**).

To use the new SKUs enabled by VPN Fast Path, you need to create new virtual network gateways and connections.

### Configure the virtual network gateway SKU

#### Azure Stack Hub portal

If you use the Azure Stack Hub portal to create a virtual network gateway, select the SKU from the dropdown list. To see the new VPN Fast Path SKUs (**VpnGw1**, **VpnGw2**, **VpnGw3**), add the query parameter **"?azurestacknewvpnskus=true"** to the URL and refresh the page.

The following URL example makes the new virtual network gateway SKUs visible in the Azure Stack Hub user portal:

```http
https://portal.local.azurestack.local/?azurestacknewvpnskus=true
```

Before creating these resources, the operator must enable VPN Fast Path on the Azure Stack Hub stamp. For more information, see [VPN Fast Path for operators](../operator/azure-stack-vpn-fast-path-operators.md).

:::image type="content" source="media/azure-stack-vpn-gateway-settings/vpn-fast-path-vng-new-skus.png" alt-text="Screenshot shows Azure VNG new SKUs.":::

#### PowerShell

The following PowerShell example specifies the `-GatewaySku` parameter as **Standard**:

```powershell
New-AzVirtualNetworkGateway -Name vnetgw1 -ResourceGroupName testrg `
   -Location 'West US' -IpConfigurations $gwipconfig -GatewaySku Standard `
   -GatewayType Vpn -VpnType RouteBased
```

### Connection types

In the Resource Manager deployment model, each configuration requires a specific virtual network gateway connection type. The available Resource Manager PowerShell values for `-ConnectionType` are **IPsec**.

In the following PowerShell example, you create a S2S connection that requires the IPsec connection type:

```powershell
New-AzVirtualNetworkGatewayConnection -Name localtovon -ResourceGroupName testrg `
   -Location 'West US' -VirtualNetworkGateway1 $gateway1 -LocalNetworkGateway2 $local `
   -ConnectionType IPsec -RoutingWeight 10 -SharedKey 'abc123'
```

### VPN types

When you create the virtual network gateway for a VPN gateway configuration, you must specify a VPN type. The VPN type that you choose depends on the connection topology that you want to create. A VPN type can also depend on the hardware that you're using. S2S configurations require a VPN device. Some VPN devices only support a certain VPN type.

> [!IMPORTANT]  
> Currently, Azure Stack Hub only supports the route-based VPN type. If your device only supports policy-based VPNs, connections to those devices from Azure Stack Hub aren't supported.  
>
> In addition, Azure Stack Hub doesn't support using policy-based traffic selectors for route-based gateways at this time, because Azure Stack Hub doesn't support policy-based traffic selectors, although they're supported in Azure.

* **PolicyBased**: Policy-based VPNs encrypt and direct packets through IPsec tunnels based on the IPsec policies that you configure with combinations of address prefixes between your on-premises network and the Azure Stack Hub VNet. The policy, or traffic selector, is usually an access list in the VPN device configuration.

  >[!NOTE]
  >**PolicyBased** is supported in Azure, but not in Azure Stack Hub.

* **RouteBased**: Route-based VPNs use routes that you configure in the IP forwarding or routing table to direct packets to their corresponding tunnel interfaces. The tunnel interfaces then encrypt or decrypt the packets in and out of the tunnels. You configure the policy, or traffic selector, for **RouteBased** VPNs as any-to-any (or use wild cards). By default, you can't change it. The value for a **RouteBased** VPN type is **RouteBased**.

The following PowerShell example specifies the `-VpnType` as **RouteBased**. When you create a gateway, make sure that the `-VpnType` is correct for your configuration.

```powershell
New-AzVirtualNetworkGateway -Name vnetgw1 -ResourceGroupName testrg `
   -Location 'West US' -IpConfigurations $gwipconfig `
   -GatewayType Vpn -VpnType RouteBased
```

### Virtual network gateways supported configurations when VPN Fast Path is not enabled

| SKU | VPN Type | Connection type| Active Routing support (BGP) | Remote endpoint NAT-T Enabled |
|--|--|--|--|--|
|Basic VNG SKU| Route-based VPN | IPSec Pre-shared key | Not Supported | Not required |
|Standard VNG SKU | Route-based VPN | IPSec Pre-shared key | Supported, up to 150 routes | Not required |
|High-Performance VNG SKU| Route-based VPN | IPSec Pre-shared key | Supported, up to 150 routes | Not required |

### Virtual network gateways supported configurations when VPN Fast Path is enabled

| SKU | VPN Type | Connection type| Active routing support (BGP) | Remote endpoint NAT-T Enabled |
|--|--|--|--|--|
|Basic VNG SKU| Route-based VPN | IPSec Pre-shared key | Not Supported | Required  |
|Standard VNG SKU | Route-based VPN | IPSec Pre-shared key | Supported, up to 150 routes | Required  |
|High-Performance VNG SKU| Route-based VPN | IPSec Pre-shared key | Supported, up to 150 routes | Required  |
|VPNGw1 VNG SKU| Route-based VPN | IPSec Pre-shared key | Supported, up to 150 routes | Required |
|VPNGw2 VNG SKU| Route-based VPN | IPSec Pre-shared key | Supported, up to 150 routes | Required  |
|VPNGw2 VNG SKU| Route-based VPN  | IPSec Pre-shared key | Supported, up to 150 routes | Required  |


### Gateway subnet

Before you create a VPN gateway, you must create a gateway subnet. The gateway subnet has the IP addresses that the virtual network gateway VMs and services use. When you create your virtual network gateway and the connection, the Gateway VM owning the connection is linked to the gateway subnet and is configured with the required VPN gateway settings. Don't deploy anything else (for example, additional VMs) to the gateway subnet.

>[!IMPORTANT]
>The gateway subnet must be named **GatewaySubnet** to work properly. Azure Stack Hub uses this name to identify the subnet to which to deploy the virtual network gateway VMs and services.

When you create the gateway subnet, you specify the number of IP addresses that the subnet contains. The IP addresses in the gateway subnet are allocated to the gateway VMs and gateway services. Some configurations require more IP addresses than others. Look at the instructions for the configuration that you want to create and verify that the gateway subnet you want to create meets those requirements.

Additionally, make sure your gateway subnet has enough IP addresses to handle additional future configurations. Although you can create a gateway subnet as small as /29, create a gateway subnet of /28 or larger (/28, /27, /26, and so on.) That way, if you add functionality in the future, you don't have to tear down your gateway, then delete and recreate the gateway subnet to allow for more IP addresses.

The following Resource Manager PowerShell example shows a gateway subnet named **GatewaySubnet**. You can see the CIDR notation specifies a /27, which allows for enough IP addresses for most configurations that currently exist.

```powershell
Add-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix 10.0.3.0/27
```

> [!IMPORTANT]
> When working with gateway subnets, avoid associating a network security group (NSG) to the gateway subnet. Associating a network security group to this subnet can cause your VPN gateway to stop functioning as expected. For more information about network security groups, see [What is a network security group?](/azure/virtual-network/virtual-networks-nsg).

### Local network gateways

When you create a VPN gateway configuration in Azure, the local network gateway often represents your on-premises location. In Azure Stack Hub, it represents any remote VPN device that sits outside Azure Stack Hub. This device could be a VPN device in your datacenter (or a remote datacenter), or a VPN gateway in Azure.

You give the local network gateway a name, the public IP address of the remote VPN device, and specify the address prefixes that are on the on-premises location. Azure Stack Hub looks at the destination address prefixes for network traffic, consults the configuration that you specified for your local network gateway, and routes packets accordingly.

This PowerShell example creates a new local network gateway:

```powershell
New-AzLocalNetworkGateway -Name LocalSite -ResourceGroupName testrg `
   -Location 'West US' -GatewayIpAddress '198.51.100.101' -AddressPrefix '10.5.51.0/24'
```

Sometimes you need to modify the local network gateway settings. For example, you might need to change the address range or if the IP address of the VPN device changes. For more info, see [Modify local network gateway settings using PowerShell](/azure/vpn-gateway/vpn-gateway-modify-local-network-gateway).

## IPsec/IKE parameters

When you set up a VPN connection in Azure Stack Hub, you must configure the connection at both ends. If you're configuring a VPN connection between Azure Stack Hub and a hardware device such as a switch or router that acts as a VPN gateway, that device might require additional settings.

Unlike Azure, which supports multiple offers as both an initiator and a responder, Azure Stack Hub supports only one offer by default. If you need to use different IPSec/IKE settings to work with your VPN device, you can configure your connection manually. For more information, see [Configure IPsec/IKE policy for site-to-site VPN connections](azure-stack-vpn-s2s.md).

> [!IMPORTANT] 
> When you use the S2S tunnel, packets are further encapsulated with additional headers which increases the overall size of the packet. In these scenarios, you must clamp TCP **MSS** at **1350**. Or, if your VPN devices don't support MSS clamping, you can alternatively set the **MTU** on the tunnel interface to **1400** bytes instead. For more information, see [Virutal Network TCPIP performance tuning](/azure/virtual-network/virtual-network-tcpip-performance-tuning).
>

### IKE Phase 1 (Main Mode) parameters

| Property              | Value|
|-|-|
| IKE Version           | IKEv2 |
|Diffie-Hellman Group*   | ECP384 |
| Authentication Method | Pre-Shared Key |
|Encryption & Hashing Algorithms* | AES256, SHA384 |
|SA Lifetime (Time)     | 28,800 seconds|

### IKE Phase 2 (Quick Mode) parameters

| Property| Value|
|-|-|
|IKE Version |IKEv2 |
|Encryption & Hashing Algorithms (Encryption)     | GCMAES256|
|Encryption & Hashing Algorithms (Authentication) | GCMAES256|
|SA Lifetime (Time)  | 27,000 seconds  |
|SA Lifetime (Kilobytes) | 33,553,408     |
|Perfect Forward Secrecy (PFS)* | ECP384 |
|Dead Peer Detection | Supported| 

\* New or changed parameter.

## Next steps

* [Connect using ExpressRoute](../operator/azure-stack-connect-expressroute.md)
