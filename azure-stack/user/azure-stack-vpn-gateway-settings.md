---
title: Configure VPN gateway settings for Azure Stack Hub | Microsoft Docs
description: Learn about and configure VPN gateways settings for Azure Stack Hub.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid: fa8d3adc-8f5a-4b4f-8227-4381cf952c56
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: conceptual
ms.date: 10/03/2019
ms.author: sethm
ms.lastreviewed: 12/27/2018
---

# Configure VPN gateway settings for Azure Stack Hub

*Applies to: Azure Stack Hub integrated systems and Azure Stack Development Kit*

A VPN gateway is a type of virtual network gateway that sends encrypted traffic between your virtual network in Azure Stack Hub and a remote VPN gateway. The remote VPN gateway can be in Azure, a device in your datacenter, or a device on another site. If there is network connectivity between the two endpoints, you can establish a secure Site-to-Site (S2S) VPN connection between the two networks.

A VPN gateway connection relies on the configuration of multiple resources, each of which contains configurable settings. This article describes the resources and settings that relate to a VPN gateway for a virtual network that you create in the Resource Manager deployment model. You can find descriptions and topology diagrams for each connection solution in [About VPN Gateway for Azure Stack Hub](azure-stack-vpn-gateway-about-vpn-gateways.md).

## VPN gateway settings

### Gateway types

Each Azure Stack Hub virtual network supports a single virtual network gateway, which must be of the type **Vpn**.  This support is different from Azure, which supports additional types.

When you create a virtual network gateway, you must make sure that the gateway type is correct for your configuration. A VPN gateway requires the `-GatewayType Vpn` flag; for example:

```powershell
New-AzureRmVirtualNetworkGateway -Name vnetgw1 -ResourceGroupName testrg `
-Location 'West US' -IpConfigurations $gwipconfig -GatewayType Vpn `
-VpnType RouteBased
```

### Gateway SKUs

When you create a virtual network gateway, you must specify the gateway SKU that you want to use. Select the SKUs that satisfy your requirements based on the types of workloads, throughputs, features, and SLAs.

Azure Stack Hub offers the VPN gateway SKUs shown in the following table:

| | VPN gateway throughput |VPN gateway maximum IPsec tunnels |
|-------|-------|-------|
|**Basic SKU**  | 100 Mbps	| 20	|
|**Standard SKU**   | 100 Mbps  | 20 |
|**High Performance SKU** | 200 Mbps | 10 |

### Resizing gateway SKUs

Azure Stack Hub does not support a resize of SKUs between the supported legacy SKUs.

Similarly, Azure Stack Hub does not support a resize from a supported legacy SKU (**Basic**, **Standard**, and **HighPerformance**) to a newer SKU supported by Azure (**VpnGw1**, **VpnGw2**, and **VpnGw3**).

### Configure the gateway SKU

#### Azure Stack Hub portal

If you use the Azure Stack Hub portal to create a Resource Manager virtual network gateway, you can select the gateway SKU by using the dropdown list. The options correspond to the gateway type and VPN type that you select.

#### PowerShell

The following PowerShell example specifies the `-GatewaySku` parameter as **Standard**:

```powershell
New-AzureRmVirtualNetworkGateway -Name vnetgw1 -ResourceGroupName testrg `
-Location 'West US' -IpConfigurations $gwipconfig -GatewaySku Standard `
-GatewayType Vpn -VpnType RouteBased
```

### Connection types

In the Resource Manager deployment model, each configuration requires a specific virtual network gateway connection type. The available Resource Manager PowerShell values for `-ConnectionType` are **IPsec**.

In the following PowerShell example, a S2S connection is created that requires the IPsec connection type:

```powershell
New-AzureRmVirtualNetworkGatewayConnection -Name localtovon -ResourceGroupName testrg `
-Location 'West US' -VirtualNetworkGateway1 $gateway1 -LocalNetworkGateway2 $local `
-ConnectionType IPsec -RoutingWeight 10 -SharedKey 'abc123'
```

### VPN types

When you create the virtual network gateway for a VPN gateway configuration, you must specify a VPN type. The VPN type that you choose depends on the connection topology that you want to create. A VPN type can also depend on the hardware that you're using. S2S configurations require a VPN device. Some VPN devices only support a certain VPN type.

> [!IMPORTANT]  
> Currently, Azure Stack Hub only supports the route-based VPN type. If your device only supports policy-based VPNs, then connections to those devices from Azure Stack Hub are not supported.  
>
> In addition, Azure Stack Hub does not support using policy-based traffic selectors for route-based gateways at this time, because custom IPSec/IKE policy configurations are not supported.

* **PolicyBased**: Policy-based VPNs encrypt and direct packets through IPsec tunnels based on the IPsec policies that are configured with the combinations of address prefixes between your on-premises network and the Azure Stack Hub VNet. The policy, or traffic selector, is usually an access list in the VPN device configuration.

  >[!NOTE]
  >**PolicyBased** is supported in Azure, but not in Azure Stack Hub.

* **RouteBased**: Route-based VPNs use routes that are configured in the IP forwarding or routing table to direct packets to their corresponding tunnel interfaces. The tunnel interfaces then encrypt or decrypt the packets in and out of the tunnels. The policy, or traffic selector, for **RouteBased** VPNs are configured as any-to-any (or use wild cards). By default, they cannot be changed. The value for a **RouteBased** VPN type is **RouteBased**.

The following PowerShell example specifies the `-VpnType` as **RouteBased**. When you create a gateway, you must make sure that the `-VpnType` is correct for your configuration.

```powershell
New-AzureRmVirtualNetworkGateway -Name vnetgw1 -ResourceGroupName testrg `
-Location 'West US' -IpConfigurations $gwipconfig `
-GatewayType Vpn -VpnType RouteBased
```

### Gateway requirements

The following table lists the requirements for VPN gateways.

| |Policy-based Basic VPN Gateway | Route-based Basic VPN Gateway | Route-based Standard VPN Gateway | Route-based High Performance VPN Gateway|
|--|--|--|--|--|
| **Site-to-Site connectivity (S2S connectivity)** | Not Supported | Route-based VPN configuration | Route-based VPN configuration | Route-based VPN configuration |
| **Authentication method**  | Not Supported | Pre-shared key for S2S connectivity  | Pre-shared key for S2S connectivity  | Pre-shared key for S2S connectivity  |
| **Maximum number of S2S connections**  | Not Supported | 20 | 20| 10|
|**Active routing support (BGP)** | Not supported | Not supported | Supported | Supported |

### Gateway subnet

Before you create a VPN gateway, you must create a gateway subnet. The gateway subnet has the IP addresses that the virtual network gateway VMs and services use. When you create your virtual network gateway, gateway VMs are deployed to the gateway subnet and configured with the required VPN gateway settings. Don't deploy anything else (for example, additional VMs) to the gateway subnet.

>[!IMPORTANT]
>The gateway subnet must be named **GatewaySubnet** to work properly. Azure Stack Hub uses this name to identify the subnet to which to deploy the virtual network gateway VMs and services.

When you create the gateway subnet, you specify the number of IP addresses that the subnet contains. The IP addresses in the gateway subnet are allocated to the gateway VMs and gateway services. Some configurations require more IP addresses than others. Look at the instructions for the configuration that you want to create and verify that the gateway subnet you want to create meets those requirements.

Additionally, you should make sure your gateway subnet has enough IP addresses to handle additional future configurations. Although you can create a gateway subnet as small as /29, we recommend you create a gateway subnet of /28 or larger (/28, /27, /26, and so on.) That way, if you add functionality in the future, you do not have to tear down your gateway, then delete and recreate the gateway subnet to allow for more IP addresses.

The following Resource Manager PowerShell example shows a gateway subnet named **GatewaySubnet**. You can see the CIDR notation specifies a /27, which allows for enough IP addresses for most configurations that currently exist.

```powershell
Add-AzureRmVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -AddressPrefix 10.0.3.0/27
```

> [!IMPORTANT]
> When working with gateway subnets, avoid associating a network security group (NSG) to the gateway subnet. Associating a network security group to this subnet can cause your VPN gateway to stop functioning as expected. For more information about network security groups, see [What is a network security group?](/azure/virtual-network/virtual-networks-nsg).

### Local network gateways

When creating a VPN gateway configuration in Azure, the local network gateway often represents your on-premises location. In Azure Stack Hub, it represents any remote VPN device that sits outside Azure Stack Hub. This device could be a VPN device in your datacenter (or a remote datacenter), or a VPN gateway in Azure.

You give the local network gateway a name, the public IP address of the VPN device, and specify the address prefixes that are on the on-premises location. Azure looks at the destination address prefixes for network traffic, consults the configuration that you've specified for your local network gateway, and routes packets accordingly.

This PowerShell example creates a new local network gateway:

```powershell
New-AzureRmLocalNetworkGateway -Name LocalSite -ResourceGroupName testrg `
-Location 'West US' -GatewayIpAddress '23.99.221.164' -AddressPrefix '10.5.51.0/24'
```

Sometimes you need to modify the local network gateway settings; for example, when you add or modify the address range, or if the IP address of the VPN device changes. For more info, see [Modify local network gateway settings using PowerShell](/azure/vpn-gateway/vpn-gateway-modify-local-network-gateway).

## IPsec/IKE parameters

When you set up a VPN connection in Azure Stack Hub, you must configure the connection at both ends. If you're configuring a VPN connection between Azure Stack Hub and a hardware device such as a switch or router that is acting as a VPN gateway, that device might ask you for additional settings.

Unlike Azure, which supports multiple offers as both an initiator and a responder, Azure Stack Hub supports only one offer by default. If you need to use different IPSec/IKE settings to work with your VPN device, there are more settings available to you to configure your connection manually. For more information, see [Configure IPsec/IKE policy for site-to-site VPN connections](azure-stack-vpn-s2s.md).

### IKE Phase 1 (Main Mode) parameters

| Property              | Value|
|-|-|
| IKE Version           | IKEv2 |
|Diffie-Hellman Group   | ECP384 |
| Authentication Method | Pre-Shared Key |
|Encryption & Hashing Algorithms | AES256, SHA384 |
|SA Lifetime (Time)     | 28,800 seconds|

### IKE Phase 2 (Quick Mode) parameters

| Property| Value|
|-|-|
|IKE Version |IKEv2 |
|Encryption & Hashing Algorithms (Encryption)     | GCMAES256|
|Encryption & Hashing Algorithms (Authentication) | GCMAES256|
|SA Lifetime (Time)  | 27,000 seconds  |
|SA Lifetime (Kilobytes) | 33,553,408     |
|Perfect Forward Secrecy (PFS) | ECP384 |
|Dead Peer Detection | Supported|  

## Next steps

* [Connect using ExpressRoute](../operator/azure-stack-connect-expressroute.md)
