---
title: Azure Stack Hub VPN Fast Path for operators
description: Learn about Azure Stack Hub VPN Fast Path for operators
author: cedward
ms.topic: conceptual
ms.date: 01/23/2024
ms.author: cedward
ms.reviewer: iacarago
ms.lastreviewed: 01/09/2023

# Intent: As an Azure Stack Hub operator, I can enable, disable and operate the new features included in VPN Fast Path
# Keyword: azure stack hub VPN Gateways
---

# Azure Stack Hub VPN Fast Path for operators

## What is the Azure Stack Hub VPN Fast Path feature?

Azure Stack Hub is introducing the three new SKUs described in this article as part of the VPN Fast Path feature. Previously, S2S tunnels were limited to a maximum bandwidth of 200 Mbps using the HighPerformance SKU. The new SKUs enable customer scenarios in which higher network throughput is necessary. The throughput values for each SKU are unidirectional values, meaning it supports the given throughput on either of send or receive traffic.

## New VPN Fast Path virtual network gateway SKUs

With the introduction of the VPN Fast Path feature in Azure Stack Hub, tenant users can create VPN connections using 3 new SKUs:

- Basic
- Standard
- High Performance
- VpnGw1 (new)
- VpnGw2 (new)
- VpnGw3 (new)

## Important considerations before enabling Azure Stack Hub VPN Fast Path

To make any update process go as smoothly as possible so that there's minimal impact on your users, it's important to prepare your Azure Stack Hub stamp.

As the Azure Stack Hub operator enabling VPN Fast Path, we recommend that you coordinate with tenant users to schedule a maintenance window during which the changeover can happen. Notify your users of any possible VPN connection service outages, and then follow the steps here to prepare your stamp for the update.

### VPN Fast Path requires NAT-T on remote VPN devices

Azure Stack Hub VPN Fast Path relies on the new SDN Gateway service, and it comes with a new requirement when planning.

### Plan with tenant users before enabling VPN Fast Path

- List of existing virtual network gateway resources settings.
- List of existing connections resources settings.
- List of IPSec policies and settings used on their existing connections.
  - This step ensures your users have policies configured that work with their device, including custom IPSec policies.
- List local network gateway settings. Tenant users can re-use local network gateway resources and configurations. However, we also recommend that you save the existing configuration in case they need to be re-created.
- Once VPN Fast Path is enabled, tenants must re-create their virtual network gateways and connections as appropriate if they want to use the new SKUs.

With the release of VPN Fast Path, there is a new PowerShell command that operators can call to list all the existing connections created by their tenants. This cmdlet can help the operator manage capacity and reach out to the tenant admins if they need to recreate their Virtual Network gateways:

```powershell
Get-AzsVirtualNetworkGatewayConnection
```

For more information, see [**Get-AzsVirtualNetworkGatewayConnection**](/powershell/module/az.network/get-azvirtualnetworkgatewayconnection).

## How to enable Azure Stack Hub VPN Fast Path

With VPN Fast Path, operators can enable the new feature using the following PowerShell commands. Once the feature reaches general availability, the operators can also enable the feature using the Azure Stack Hub administrator portal.

You can adjust existing setups by re-creating the virtual network gateway and its connections with one of the new SKUs.

### Enable Azure Stack Hub VPN Fast Path using PowerShell

From the Azure Stack Hub privileged endpoint, you can run the following PowerShell command to enable the VPN Fast Path feature:

For more information about the Azure Stack Hub PEP, see [Access privileged endpoint](azure-stack-privileged-endpoint.md).

```powershell
Set-AzSVPNFastPath -Enable
```

:::image type="content" source="media/azure-stack-vpn-fast-path-operators/azure-vpn-fast-path-enable.png" alt-text="Screenshot showing PowerShell commands for enabling Fast Path." lightbox="media/azure-stack-vpn-fast-path-operators/azure-vpn-fast-path-enable.png":::

### Validate Azure Stack Hub VPN Fast Path is enabled using PowerShell

Once the VPN Fast Path feature is enabled, you can validate the current state of the Gateway VMs and the used capacity using the following PowerShell command:

```powershell
Get-AzSVPNFastPath
```

:::image type="content" source="media/azure-stack-vpn-fast-path-operators/azure-vpn-fast-path-get.png" alt-text="Screenshot showing PowerShell validation." lightbox="media/azure-stack-vpn-fast-path-operators/azure-vpn-fast-path-get.png":::

### Disable Azure Stack Hub VPN Fast Path using PowerShell

```powershell
Set-AzSVPNFastPath -Disable
```

If you need to disable VPN Fast Path, you must first work with your tenant to delete and recreate all their Virtual Network Gateways using VPN Fast Path SKUs. Because stamp VPN capacity increases when VPN Fast Path is enabled, you can't disable VPN Fast Path if the overall in-use capacity exceeds the total capacity when Azure Stack Hub isn't using VPN Fast Path.

## Azure Stack Hub Gateway Pool architecture

There are three multi-tenant gateway infrastructure VMs in Azure Stack Hub. Two of these VMs are in active mode, and the third is in redundant mode. Active VMs enable the creation of VPN connections on them, and the redundant VM only accepts VPN connections if a failover happens. If an active gateway VM becomes unavailable, the VPN connection fails over to the redundant VM after a short period (a few seconds) of connection loss.

Gateway connection failovers are expected during an OEM or an Azure Stack Hub update, as the VMs are patched and live migrated. This failover can result in a temporary disconnect of the tunnels.

:::image type="content" source="media/azure-stack-vpn-fast-path-operators/azure-vpn-gateway-pool-failover.png" alt-text="Conceptual diagram showing VPN Fast Path failover." lightbox="media/azure-stack-vpn-fast-path-operators/azure-vpn-gateway-pool-failover.png":::

## New Gateway Pool total capacity

The overall Gateway Pool capacity of an Azure Stack Hub stamp is 4 Gbps. This capacity is divided between the two Active Gateway VMs, with each Gateway VM supporting up to 2 Gbps of throughput. When a connection resource is created, twice its SKU is reserved on the Gateway VM. This design ensures that the maximum throughput of the SKU (measured in one direction) can be reached with either Tx or Rx traffic, depending on the requirements of the user workload.

For example, a **HighPerformance** SKU reserves 400 Mbps on a Gateway VM (200 for Tx, 200 for Rx). This means that on the existing engine, a **HighPerformance** connection reserves one tenth of the overall Gateway Pool capacity.

The following table shows the gateway types and the estimated aggregate throughput for each tunnel/connection by gateway SKU when VPN Fast Path is disabled:

| SKU | Max VPN Connection throughput (1) | Max # of VPN Connections per active GW VM | Max # of VPN Connections per stamp (2) |
|-------|-------|-------|-------|
|**Basic** **(3)** |  100 Mbps Tx/Rx  | 10 | 20 |
|**Standard** | 100 Mbps Tx/Rx  | 10 | 20 |
|**High Performance** |  200 Mbps Tx/Rx  | 5 | 10 |

**(1)** - Tunnel throughput is not a guaranteed throughput for cross-premises connections across the internet; it's the maximum possible throughput measurement. The total aggregate in one direction is 2 Gbps.  
**(2)** - Max tunnels is the total per Azure Stack Hub deployment for all subscriptions.  
**(3)** - BGP routing isn't supported for the Basic SKU.

:::image type="content" source="media/azure-stack-vpn-fast-path-operators/azure-vpn-fast-path-disabled.png" alt-text="Conceptual diagram showing VPN Fast Path disabled." lightbox="media/azure-stack-vpn-fast-path-operators/azure-vpn-fast-path-disabled.png":::

### Estimated aggregate tunnel throughput by SKU with VPN Fast Path Enabled

Once the operator enables VPN Fast Path on the Azure Stack Hub stamp, the overall Gateway Pool capacity is increased to 10 Gbps. Since the capacity is divided between the two active Gateway VMs, each Gateway VM has a capacity of 5 Gbps. The amount of capacity reserved for each connection is the same as outlined in the previous section. Therefore, a VpnGw3 SKU (1250 Mbps) reserves 2500 Mbps of capacity on a Gateway VM:

| SKU | Max VPN Connection throughput (1) |Max # of VPN Connections per active GW VM | Max # of VPN Connections per stamp (2) |
|-------|-------|-------|-------|
|**Basic** **(3)** | 100 Mbps Tx/Rx  | 25 | 50 |
|**Standard** | 100 Mbps Tx/Rx  | 25 | 50 |
|**High Performance** |  200 Mbps Tx/Rx  | 12 | 24 |
|**VPNGw1**|  650 Mbps Tx/Rx |3 |6|
|**VPNGw2**|  1000 Mbps Tx/Rx  |2 |4|
|**VPNGw3**|  1250 Mbps Tx/Rx  |2 |4|

**(1)** - Tunnel throughput is not a guaranteed throughput for cross-premises connections across the internet; it's the maximum possible throughput measurement. The total aggregate in one direction is 5 Gbps.  
**(2)** - Max tunnels is the total per Azure Stack Hub deployment for all subscriptions.  
**(3)** - BGP routing isn't supported for the Basic SKU.

:::image type="content" source="media/azure-stack-vpn-fast-path-operators/azure-vpn-fast-path-enabled.png" alt-text="Conceptual diagram showing VPN Fast Path enabled." lightbox="media/azure-stack-vpn-fast-path-operators/azure-vpn-fast-path-enabled.png":::

## Next steps

- [VPN gateway configuration settings for Azure Stack Hub](../user/azure-stack-vpn-gateway-settings.md)
