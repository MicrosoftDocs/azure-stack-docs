---
title: Enable Azure Arc gateway after deployment on Azure Local (preview)
description: Learn how to enable Azure Arc gateway on an existing Azure Local instance and validate outbound connectivity. This feature is in preview.
author: ronmiab
ms.author: cedward
ms.topic: how-to
ms.reviewer: shisab
ms.date: 09/29/2026
ms.subservice: hyperconverged
---

# Enable Azure Arc gateway after deployment on Azure Local (preview)

[!INCLUDE [applies-to](../includes/hci-applies-to-23h2.md)]

This article describes how to enable Azure Arc gateway on an existing Azure Local instance. Arc gateway reduces the number of outbound endpoints that you need to allow by providing a common entry point for Azure Arc traffic to allowed endpoints.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

For an overview of the architecture and traffic flows, see [About Azure Arc gateway for Azure Local](../deploy/deployment-azure-arc-gateway-overview.md).

## Key considerations

- Your Azure Local instance must run solution version 2610 or later.
- You can't disable Arc gateway after you enable it in this preview.
- Existing AKS clusters don't automatically receive proxy changes made during gateway enablement. Record and validate their current proxy and bypass configuration separately.
- Keep the existing endpoint allow list available until gateway enablement and all validation checks succeed.

## How the configuration changes traffic flow

After you enable Arc gateway:

- Each Azure Local machine sends HTTPS traffic through the Arc proxy at `http://localhost:40343`, except for destinations in the local bypass list. The gateway tunnel handles traffic to allowed endpoints unless the endpoint is configured in `gatewayBypass`.
- HTTP traffic doesn't tunnel through Arc gateway. Its configured proxy first hop and its onward path through the enterprise proxy or firewall are separate from gateway tunnel eligibility.
- Azure Arc resource bridge uses the cluster IP as its forward proxy, which sends HTTPS traffic to allowed endpoints through the Arc proxy on the Azure Local machine that owns the cluster IP, subject to the bypass configuration.
- HTTPS traffic to endpoints that Arc gateway doesn't allow uses the fallback path through your enterprise proxy or firewall.

The configuration workflow associates the Azure Local machines and Azure Arc resource bridge with the gateway, configures their proxy settings, and updates the instance configuration used by subsequent lifecycle operations.

## Prerequisites

Before you begin, confirm the following requirements:

- All machines show **Connected**, Azure Arc resource bridge shows **Running**, and the instance is healthy.
- An Arc gateway resource already exists in the same tenant and subscription as the Azure Local instance.
- You have permissions to view the existing Arc gateway resource and configure the Azure Local resource.
- You coordinated the change with your network and security teams.
- You recorded the current local bypass lists, the gateway's `gatewayBypass` entries, and the proxy configuration and connectivity requirements of any existing AKS clusters. Don't assume that a successful infrastructure configuration job verifies or updates every existing AKS cluster or application.

### Review the existing Arc gateway resource

Before you configure the Azure Local instance:

> [!IMPORTANT]
> Create and provision the Arc gateway resource before you begin this procedure.

1. In the Azure portal, go to **Azure Arc** > **Azure Arc gateway**.
1. Open the Arc gateway resource that you plan to use.
1. On the gateway resource **Overview** page, record the gateway URL in the form `<gateway-id>.gw.arc.azure.com`.

:::image type="content" source="media/enable-arc-gateway-after-deployment/arc-gateway-resource-overview.png" alt-text="Screenshot of an Arc gateway resource Overview page with the gateway URL highlighted." lightbox="media/enable-arc-gateway-after-deployment/arc-gateway-resource-overview.png":::

### Prepare your firewall and proxy

Before you configure Arc gateway:

1. Allow outbound HTTPS traffic on TCP port 443 from every Azure Local machine to your gateway URL, `<gateway-id>.gw.arc.azure.com`.
1. If you use a forward proxy, disable TLS inspection for the gateway URL. Arc gateway doesn't support TLS-terminating proxies.
1. Keep all currently allowed Azure Local required endpoints open during the configuration operation.
1. Confirm that the [Azure Local endpoints not redirected through Arc gateway](../deploy/deployment-azure-arc-gateway-overview.md#azure-local-endpoints-not-redirected) remain allowed.

> [!IMPORTANT]
> Don't remove or restrict existing Azure Local endpoints until the configuration completes and you validate Arc gateway end to end. Removing endpoints during the operation can cause the job to fail and leave the instance partially configured.

## Enable Arc gateway

1. In the [Azure portal](https://portal.azure.com), go to your Azure Local resource.
1. On the **Overview** page, find **Arc gateway** under **Networking**. The status shows **Not configured**.
1. Select **Configure**.

	:::image type="content" source="media/enable-arc-gateway-after-deployment/cluster-overview-arc-gateway-not-configured.png" alt-text="Screenshot of an Azure Local resource Overview page showing Arc gateway as not configured under Networking." lightbox="media/enable-arc-gateway-after-deployment/cluster-overview-arc-gateway-not-configured.png":::

1. Select the existing Arc gateway resource that you want to use. The portal only lists eligible gateways from the same tenant and subscription as the Azure Local instance.
1. Select **Configure** to start the operation.

	:::image type="content" source="media/enable-arc-gateway-after-deployment/select-arc-gateway-resource.png" alt-text="Screenshot of the Arc gateway configuration pane with a precreated Arc gateway selected." lightbox="media/enable-arc-gateway-after-deployment/select-arc-gateway-resource.png":::

1. The Azure portal displays the configuration job after the operation starts.

   :::image type="content" source="media/enable-arc-gateway-after-deployment/arc-gateway-enablement-job-started.png" alt-text="Screenshot of the Azure Local Jobs page showing the Arc gateway configuration job in progress." lightbox="media/enable-arc-gateway-after-deployment/arc-gateway-enablement-job-started.png":::

The configuration operation performs the following steps:

- Associates each Azure Local machine and Azure Arc resource bridge with the selected gateway.
- Configures the Azure Connected Machine agent on each machine to use Arc gateway.
- Configures Azure Arc resource bridge to use the cluster IP as its forward proxy.
- Updates WinINet, WinHTTP, and the instance lifecycle configuration so HTTPS traffic uses the local Arc proxy, except for destinations in the local bypass list.
- Establishes and validates the HTTPS tunnel to the Arc gateway URL.

Expand the configuration job to monitor the individual Arc agent, Azure Arc resource bridge, and machine configuration steps.

:::image type="content" source="media/enable-arc-gateway-after-deployment/arc-gateway-enablement-job-progress.png" alt-text="Screenshot of the expanded Arc gateway configuration job showing individual steps and their progress." lightbox="media/enable-arc-gateway-after-deployment/arc-gateway-enablement-job-progress.png":::

The agent configuration typically takes approximately 15 minutes. Allow 30–60 minutes for the complete operation on a multimachine instance. Duration varies with instance size, agent health, and network conditions.

Monitor the operation from the Azure Local resource in the Azure portal. Don't change firewall or proxy rules while the operation is running. When every step succeeds, the job status changes to **Success**.

:::image type="content" source="media/enable-arc-gateway-after-deployment/arc-gateway-enablement-job-completed.png" alt-text="Screenshot of the expanded Arc gateway configuration job showing the job and all configuration steps completed successfully." lightbox="media/enable-arc-gateway-after-deployment/arc-gateway-enablement-job-completed.png":::

## Validate the configuration

After the operation succeeds, complete all the following validation steps before you reduce your firewall or proxy allow list.

### Validate each Azure Connected Machine agent

Open an elevated PowerShell session on each Azure Local machine and run:

```powershell
azcmagent show
azcmagent check
```

Confirm the following values:

- **Agent Status** is **Connected**.
- **Using HTTPS Proxy** is `http://localhost:40343`.
- **Upstream Proxy** shows your enterprise proxy when you configure one. Otherwise, it's empty.
- **Gateway URL** is your `<gateway-id>.gw.arc.azure.com` URL.
- The connectivity check reports `Reachable = true` for each required tested URL. Expect `connection.type = gateway` for traffic intended to traverse the gateway; verify the intended non-gateway path for bypassed and non-allowed endpoints.

### Validate WinINet and WinHTTP settings

Verify the WinHTTP and WinINet proxy server and complete bypass list on each Azure Local machine:

```powershell
Get-WinHttpProxyConfiguration | Format-List ConnectionURI, @{Label="BypassList"; Expression={$_.BypassList -join ","}}
Get-WinInetProxyConfiguration | Format-List ConnectionURI, @{Label="BypassList"; Expression={$_.BypassList -join ","}}
```

Each command displays `ConnectionURI` and `BypassList` on separate lines. Confirm the following values:

- `ConnectionURI` contains the expected HTTP and HTTPS proxy addresses.
- HTTPS uses the local Arc proxy at `http://localhost:40343`.
- `BypassList` contains all expected entries.

:::image type="content" source="media/update-proxy-settings/verify-windows-proxy-configuration.png" alt-text="Screenshot of PowerShell output showing the WinINet and WinHTTP proxy connection URI and complete bypass list on separate lines." lightbox="media/update-proxy-settings/verify-windows-proxy-configuration.png":::

### Validate Azure Arc resource bridge

View the Azure Arc resource bridge proxy configuration:

```powershell
Get-ARBProxyConfiguration
```

Confirm the following values and behavior:

- `HTTPS` uses the cluster IP on port `40343`.
- `ByPass` contains all expected entries.
- `HTTP` is reviewed separately. The following example shows both `HTTP` and `HTTPS` set to the cluster IP on port `40343`.
- The values identify the configured proxy first hop, not the protocols carried by the Arc gateway tunnel.
- HTTP traffic isn't tunneled through Arc gateway. Validate its actual onward path with proxy and firewall logs rather than manually changing the appliance settings to match another topology's example.

:::image type="content" source="media/update-proxy-settings/verify-azure-arc-resource-bridge-proxy.png" alt-text="Screenshot of PowerShell output from Get-ARBProxyConfiguration showing the HTTP, HTTPS, and bypass settings for Azure Arc resource bridge." lightbox="media/update-proxy-settings/verify-azure-arc-resource-bridge-proxy.png":::

### Validate existing AKS clusters

For each existing AKS cluster, verify:

- The control plane and worker proxy and bypass settings.
- Required endpoint connectivity.
- Image pulls and workload health.
- Application-defined pod proxy settings.

Keep the previous connectivity path available until these checks pass.

If a proxy update is needed, use [Update proxy settings after deployment](update-proxy-settings.md). That preview operation doesn't automatically apply the new settings to existing AKS clusters; review [Apply the change to existing AKS clusters](update-proxy-settings.md?tabs=local-proxy#apply-the-change-to-existing-aks-clusters) before changing their network path. Don't treat infrastructure job success as proof that the AKS proxy configuration has changed.

### Validate your firewall or proxy

Use your firewall or proxy logs to confirm that:

- HTTPS traffic to allowed endpoints uses the Arc gateway URL unless the destination is in a local bypass list or `gatewayBypass`.
- Endpoints that Arc gateway doesn't redirect remain allowed and reachable.
- Destinations in the local bypass lists or `gatewayBypass` remain reachable over their intended non-tunneled paths, including from the AKS subnet where required.
- Traffic to the gateway URL isn't blocked or subjected to TLS inspection.

## Safely reduce the endpoint allow list

Only reduce the allow list after all validation checks pass. Use the following approach:

1. Save a baseline copy of the allow list so that you can restore it.
1. Keep the Arc gateway URL and all [endpoints not redirected through Arc gateway](../deploy/deployment-azure-arc-gateway-overview.md#azure-local-endpoints-not-redirected) allowed.
1. Keep firewall and proxy rules for destinations in local bypass lists or `gatewayBypass`, and for existing AKS clusters that still use their previous path. Gateway enablement doesn't make these rules redundant.
1. Remove endpoints in stages, one category at a time.
1. Wait 24–48 hours between stages while you monitor machine connectivity, Azure Arc resource bridge, extensions, and workloads.
1. Run `azcmagent check` and review resource and extension health after each change.
1. Restore the most recently removed endpoints immediately if any component becomes unhealthy.

## Troubleshoot Arc gateway configuration

| Symptom | Resolution |
|---|---|
| The job fails while configuring the agents | Verify outbound TCP 443 access from every machine to the gateway URL, `gbl.his.arc.azure.com`, and `<region>.his.arc.azure.com`. Confirm that TLS inspection is disabled for the gateway URL. |
| The job fails while configuring Azure Arc resource bridge | Confirm that Azure Arc resource bridge is running and can reach the cluster IP. Review the Arc proxy log collected from the machine that serves the appliance traffic. |
| The job fails while configuring the machines | Check whether Group Policy or another management tool resets WinINet or WinHTTP settings. Pause the conflicting policy before you retry. |
| `azcmagent check` reports `Reachable = false` | Allow the reported endpoint through the enterprise firewall or proxy. Not every Azure Local endpoint is redirected through Arc gateway. |
| A machine or extension becomes unhealthy after allow list changes | Restore the most recently removed endpoints and repeat the validation steps. |

To collect Azure Connected Machine agent and Arc proxy logs, run:

```powershell
azcmagent logs
```

The generated archive includes `arcproxy.log` from `%ProgramData%\AzureConnectedMachineAgent\Log`.

## Next steps

- [Update proxy settings after deployment](update-proxy-settings.md)
- [About Azure Arc gateway for Azure Local](../deploy/deployment-azure-arc-gateway-overview.md)
- [Firewall requirements for Azure Local](../concepts/firewall-requirements.md)