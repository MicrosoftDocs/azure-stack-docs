---
title: Move Azure Local from public path to private path connectivity (preview)
description: Learn how to move an existing Azure Local instance from public-path connectivity to private-path connectivity by using Azure Firewall explicit proxy. This feature is in preview.
author: ronmiab
ms.author: cedward
ms.topic: how-to
ms.reviewer: shisab
ms.date: 09/29/2026
ms.subservice: hyperconverged
---

# Move Azure Local from public path to private path connectivity (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to move an existing Azure Local instance from public-path connectivity to the [Azure Local private path architecture](../concepts/private-path-network-overview.md). The migration replaces the current enterprise proxy address with the private IP address and explicit proxy port of an Azure Firewall instance. Traffic reaches Azure Firewall through Azure ExpressRoute or a site-to-site virtual private network (VPN) instead of through the public internet.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

Migrating an existing instance to private path uses the post-deployment Arc gateway and proxy update capabilities and requires Azure Local 2610 or later.

After Arc gateway is enabled, the migration uses `Update-AzureLocalProxy` to update the Windows proxy settings on every Azure Local machine and the proxy settings in the Azure Arc resource bridge appliance VM. For details about this cmdlet, its parameters, and supported proxy changes, see [Update proxy settings after deployment](update-proxy-settings.md).

> [!IMPORTANT]
> You must enable Arc gateway on the existing Azure Local instance before you update the proxy. First, use the [post-deployment Arc gateway feature](enable-arc-gateway-after-deployment.md) to enable and validate Arc gateway. Then, use `Update-AzureLocalProxy` to replace the current proxy with the Azure Firewall private IP address and explicit proxy port.
>
> `Update-AzureLocalProxy` doesn't create, enable, or configure Arc gateway. Changing the proxy address before Arc gateway is enabled doesn't create private path connectivity and can interrupt outbound connectivity.

Before you begin either operation, configure the private connection, routing, Azure Firewall explicit proxy, and application rules. Microsoft supports only the private path architecture described in the Azure Local documentation.

## Compare public path and private path connectivity

The following diagram compares the connectivity paths before and after the migration.

:::image type="content" source="media/move-public-path-to-private-path/public-to-private-path-connectivity.svg" alt-text="Diagram comparing Azure Local public-path connectivity through an enterprise proxy and the public internet with private-path connectivity through ExpressRoute or site-to-site VPN, Azure Firewall explicit proxy, and Azure Arc gateway." lightbox="media/move-public-path-to-private-path/public-to-private-path-connectivity.svg":::

After the migration:

- Traffic that matches the local bypass list, including configured internal addresses and private endpoint FQDNs, follows the source subnet's direct route. Configure DNS, routing, and firewall rules so that private endpoint traffic stays on the private connection.
- Host HTTP traffic uses the Azure Firewall explicit proxy private IP and port unless locally bypassed. HTTP traffic isn't tunneled through Arc gateway; the configured proxy first hop is distinct from the onward network path.
- HTTPS traffic to endpoints currently allowed by Arc gateway uses the local Arc proxy and gateway tunnel unless locally bypassed or listed in `gatewayBypass`.
- Non-allowed HTTPS endpoints use the fallback path through Azure Firewall explicit proxy. Allowed endpoints listed in `gatewayBypass` also skip the tunnel but retain the configured enterprise proxy, which is now Azure Firewall explicit proxy.
- Azure Arc resource bridge and AKS VM HTTPS traffic uses the cluster IP proxy on port `40343` unless locally bypassed. Cloud-side `gatewayBypass` doesn't remove this first hop. Existing AKS clusters require separate validation and might still use their previous configuration.

Review the [current Arc gateway endpoint guidance](../deploy/deployment-azure-arc-gateway-overview.md#azure-local-endpoints-not-redirected) when choosing a bypass option. Private DNS resolution alone doesn't select the bypass path, and non-allowed endpoints don't need `gatewayBypass` entries. For details, see [Choose an option](update-proxy-settings.md#choose-an-option).

## Prerequisites

Confirm the following prerequisites:

- Azure Local solution version 2610 or later.
- Registration with Azure, a running Azure Arc resource bridge, and healthy, connected machines.
- Local administrator permissions on an Azure Local machine.
- An Azure virtual network with at least one workload subnet and an `AzureFirewallSubnet` of `/26` or larger.
- Azure Arc Private Link Scope disabled on the virtual network that contains Azure Firewall. Use a separate virtual network for workloads that require Azure Arc Private Link Scope.
- Azure ExpressRoute or a site-to-site VPN connecting the on-premises environment to the Azure virtual network.
- Routing that allows every Azure Local machine to reach the Azure Firewall private IP over the private connection.
- Azure Firewall Standard or Premium tier with [explicit proxy enabled](../deploy/deployment-with-azure-arc-gateway-private-path.md#step-3-enable-explicit-proxy).
- Azure Firewall policy application rules that allow the [required Azure Local and Arc gateway endpoints](../deploy/deployment-azure-arc-gateway-overview.md#azure-local-endpoints-not-redirected).
- DNS, routes, and firewall rules that allow destinations in the local bypass lists or `gatewayBypass` over the intended private paths, including from the AKS subnet when required.
- TLS inspection disabled for required Azure Local and Arc gateway endpoints. Azure Local private path doesn't support TLS-terminating proxies, and you can't apply TLS certificates to Azure Firewall explicit proxy.
- [Azure Arc gateway enabled](enable-arc-gateway-after-deployment.md) on the Azure Local instance. Arc gateway is required for the private path topology.
- A record of the current proxy server, complete local bypass lists, and gateway `gatewayBypass` entries so that you can validate the intended paths and restore proxy settings if validation fails.
- You reviewed the [existing-AKS preview limitation](update-proxy-settings.md?tabs=local-proxy#apply-the-change-to-existing-aks-clusters) and planned how to apply and validate proxy changes for existing clusters. Pods can have independent proxy settings that must be reviewed separately.

For complete architecture and Azure Firewall preparation guidance, see [Register Azure Local with Arc gateway and private path](../deploy/deployment-with-azure-arc-gateway-private-path.md).

> [!WARNING]
> Keep the existing public path, proxy rules, and endpoint allow list available throughout the migration. Remove the public path only after the proxy update completes and you validate all Azure Local machines, Azure Arc resource bridge, AKS clusters, extensions, and lifecycle operations.

## Migration sequence

The following diagram summarizes the migration sequence. The order is required: prepare the private network and Azure Firewall, enable and validate Arc gateway on the existing instance, and only then run `Update-AzureLocalProxy`.

:::image type="content" source="media/move-public-path-to-private-path/public-to-private-path-steps.svg" alt-text="Diagram showing six steps to move Azure Local from public path to private path: prepare private connectivity, configure Azure Firewall explicit proxy, enable Arc gateway, record and test settings, update the proxy, and validate before cutover." lightbox="media/move-public-path-to-private-path/public-to-private-path-steps.svg":::

## Step 1: Prepare the private connection

Configure Azure ExpressRoute or a site-to-site VPN between the on-premises environment and the Azure virtual network. Confirm that routing and DNS allow every Azure Local machine and affected workload subnet to reach the required private destinations.

## Step 2: Configure Azure Firewall explicit proxy

Deploy Azure Firewall Standard or Premium, enable explicit proxy, and configure the required application rules. Record the firewall private IP and explicit proxy port, and confirm that TLS inspection is disabled for required Azure Local and Arc gateway endpoints.

## Step 3: Enable Arc gateway after deployment

Before you run any proxy update command, follow [Enable Azure Arc gateway after deployment on Azure Local](enable-arc-gateway-after-deployment.md) to:

1. Confirm that an Arc gateway resource already exists in the same tenant and subscription as the Azure Local instance.
1. Enable Arc gateway on the existing Azure Local instance if it isn't already enabled.
1. Wait for the enablement operation to finish.
1. Validate the Azure Connected Machine agent, WinHTTP, WinINet, Azure Arc resource bridge, existing AKS clusters, and firewall or proxy connectivity. Keep rules for local bypass and `gatewayBypass` destinations available.

Continue to step 4 only after Arc gateway is enabled and all validation checks in the Arc gateway enablement article pass.

> [!WARNING]
> Don't run `Update-AzureLocalProxy` before you complete this step. The cmdlet updates proxy settings only; it can't enable or configure Arc gateway.

## Step 4: Record and test settings

### Record the current configuration

Before you continue, confirm that the post-deployment Arc gateway operation completed successfully. Don't use `Update-AzureLocalProxy` to proceed with the migration if Arc gateway isn't enabled and healthy.

Record the following values before you make changes:

- Current proxy server URL.
- Complete current bypass list.
- Current `gatewayBypass` entries on the Arc gateway resource. The proxy update doesn't change this cloud-side list; see [Review the current Arc gateway configuration](update-proxy-settings.md?tabs=arc-gateway-bypass#review-the-current-arc-gateway-configuration).
- Proxy and bypass settings for existing AKS control plane and worker VMs, plus any application-defined pod proxy settings.
- Azure Firewall private IP address.
- TCP port configured for Azure Firewall explicit proxy. The same port handles HTTP and HTTPS proxy traffic.

To record the current WinHTTP and WinINet proxy settings, run:

```powershell
Get-WinHttpProxyConfiguration | Format-List ConnectionURI, @{Label="BypassList"; Expression={$_.BypassList -join ","}}
Get-WinInetProxyConfiguration | Format-List ConnectionURI, @{Label="BypassList"; Expression={$_.BypassList -join ","}}
```

To record the current Azure Arc resource bridge proxy settings, run:

```powershell
Get-ARBProxyConfiguration
```

Store the output in a secure location for use during rollback.

### Test the private proxy endpoint

From each Azure Local machine, test connectivity to the Azure Firewall private IP and explicit proxy port:

> [!NOTE]
> The private IP address `10.0.43.4` and port `8080` in the following examples are sample values. Replace them with the private IP address of your Azure Firewall instance and the TCP port configured for its explicit proxy feature.

```powershell
# Replace both values with your Azure Firewall explicit proxy configuration.
$azureFirewallPrivateIp = "10.0.43.4"
$explicitProxyPort = 8080
Test-NetConnection -ComputerName $azureFirewallPrivateIp -Port $explicitProxyPort
```

Continue only when `TcpTestSucceeded` is `True` on every machine. If the test fails, verify the ExpressRoute or site-to-site VPN connection, routing, network security rules, Azure Firewall configuration, and explicit proxy port.

This TCP check doesn't validate endpoint access through the proxy or local bypass routes. Also verify private DNS resolution and connectivity to required private endpoints from each affected source subnet, including the AKS subnet when local bypass is required.

## Step 5: Update Azure Local to use Azure Firewall explicit proxy

From an elevated PowerShell session on an Azure Local machine, run a full proxy update. Specify the Azure Firewall private IP and explicit proxy port as the proxy server, and provide the complete bypass list in Windows notation:

```powershell
# Replace this sample endpoint with your Azure Firewall private IP and explicit proxy port.
Update-AzureLocalProxy `
  -ProxyServer "http://10.0.43.4:8080" `
  -BypassList "localhost,*.contoso.com,node1,node2,192.168.1.*,192.168.2.*,192.168.3.*,AzCluster1" `
  -UpdateARBProxyBypassOnly $false
```

> [!IMPORTANT]
> `BypassList` is a full replacement. Include all existing entries and all new entries. Any existing entry that you omit is removed. For formatting requirements, see [Bypass list formats](update-proxy-settings.md?tabs=local-proxy#bypass-list-formats).

Review the values displayed by the cmdlet, and then enter `Yes` to start the update. The operation can take several minutes, depending on the number of machines.

When the operation finishes, the following message appears:

```output
[SUCCESS] Azure Local proxy configuration has been updated successfully.
```

Review the logs even when the operation succeeds:

- Cmdlet log: `C:\MASLogs\Update-AzureLocalProxy-YYYY-MM-DD.HH-mm-ss.log`
- Action plan log: `C:\MASLogs\ProxyConfiguration-UpdateAzureLocalProxy-*.log`

## Step 6: Validate and cut over

### Validate private path connectivity

Use the commands in [Verify the updated configuration](update-proxy-settings.md?tabs=local-proxy#verify-the-updated-configuration), and confirm the following results:

| Component | Expected private path configuration |
|---|---|
| WinHTTP and WinINet | `ConnectionURI` uses the Azure Firewall private IP and explicit proxy port for HTTP. When Arc gateway is enabled, HTTPS uses `http://localhost:40343`. |
| Environment variables | `HTTP_PROXY` uses the Azure Firewall private IP and port, `HTTPS_PROXY` uses `http://localhost:40343`, and `NO_PROXY` contains the expected private endpoints and internal addresses. |
| Azure Connected Machine agent | The agent is connected, **Using HTTPS Proxy** is `http://localhost:40343`, **Upstream Proxy** uses the Azure Firewall private IP and port, and the expected Arc gateway URL is present. |
| Azure Arc resource bridge | `Get-ARBProxyConfiguration` reports the cluster IP on port `40343` for HTTPS and contains the expected bypass entries. Inspect HTTP separately: a cluster-IP HTTP proxy value identifies the first hop, not gateway tunneling. Validate its onward path through Azure Firewall. See [Validate Azure Arc resource bridge](enable-arc-gateway-after-deployment.md#validate-azure-arc-resource-bridge). |
| Azure Firewall | Application rule logs show allowed proxy traffic from the Azure Local environment, including the Arc gateway URL, non-allowed endpoints, and allowed endpoints in `gatewayBypass`. |
| Local bypass destinations | DNS resolves private endpoint FQDNs to the intended private IPs. Route checks and firewall logs confirm that matching traffic uses the source subnet's intended private path without the local Arc proxy or enterprise proxy. |

Also validate:

- Azure Local resource and machine health.
- Azure Arc extension installation and update operations.
- Azure Local update checks and lifecycle operations.
- Azure Arc resource bridge status.
- Azure Local VM management operations.
- All AKS clusters and workloads, including control plane and worker proxy settings, image pulls, and required endpoint connectivity. Check application-defined pod proxy settings separately.

> [!WARNING]
> Existing AKS clusters don't automatically receive updated proxy settings. Review the [AKS preview limitation and workaround](update-proxy-settings.md?tabs=local-proxy#apply-the-change-to-existing-aks-clusters) before you remove the public path. Microsoft Support might require you to delete and re-create an AKS cluster if connectivity or configuration issues remain.

### Remove the public path

Only remove the previous public path after all validation checks pass:

1. Save a baseline copy of the existing routes, proxy rules, and endpoint allow list.
1. Confirm that local bypass destinations and destinations in `gatewayBypass` are reachable over their intended private paths. Keep any previous path still required by existing AKS clusters until their configuration and connectivity are validated.
1. Remove the public path incrementally rather than changing all routes and rules at once.
1. Monitor Azure Local, Azure Arc resource bridge, extensions, update operations, AKS, and Azure Firewall logs after each change.
1. Restore the most recently removed route or rule immediately if any component becomes unhealthy.
1. Keep the [endpoints not redirected through Arc gateway](../deploy/deployment-azure-arc-gateway-overview.md#azure-local-endpoints-not-redirected) allowed through Azure Firewall explicit proxy.
1. Keep Azure Firewall explicit proxy rules for `gatewayBypass` destinations and the private routes and firewall rules needed for locally bypassed destinations. Skipping the gateway tunnel doesn't make these rules redundant.

## Roll back to the previous proxy

If private path validation fails while the previous path is still available, restore the former proxy server and complete bypass list:

```powershell
Update-AzureLocalProxy `
  -ProxyServer "http://oldproxy.contoso.com:8080" `
  -BypassList "localhost,*.contoso.com,node1,node2,192.168.1.*,192.168.2.*,192.168.3.*,AzCluster1" `
  -UpdateARBProxyBypassOnly $false
```

Validate all components again after rollback. If the update or rollback fails, keep the existing network paths available, collect the logs from `C:\MASLogs`, and contact Microsoft Support.

Restoring the proxy doesn't disable Arc gateway or change its `gatewayBypass` list. Disabling Arc gateway isn't supported in this preview. Proxy rollback also doesn't automatically update existing AKS clusters or application-defined pod proxy settings; validate their settings and connectivity separately before removing any route or rule.

## Next steps

- [Update proxy settings after deployment](update-proxy-settings.md)
- [Private path network overview](../concepts/private-path-network-overview.md)
- [Register Azure Local with Arc gateway and private path](../deploy/deployment-with-azure-arc-gateway-private-path.md)
- [Enable Azure Arc gateway after deployment](enable-arc-gateway-after-deployment.md)
