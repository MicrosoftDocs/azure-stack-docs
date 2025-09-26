---
title: Configure VRF route prefix limits (IPv4 and IPv6) on AON CE devices for Azure Operator Nexus
description: Learn the process for configuring VRF route prefix limits (IPv4 and IPv6) on AON CE devices for Azure Operator Nexus.
author: RaghvendraMandawale
ms.author: rmandawale
ms.date: 09/26/2025
ms.topic: how-to
ms.service: azure-operator-nexus
ms.custom: template-how-to, devx-track-azurecli
---

# VRF Route Prefix Limits (IPv4 and IPv6) on AON CE Devices

## Overview

The VRF-level route prefix limit for both IPv4 and IPv6 address families on AON CE devices helps prevent route table exhaustion across multiple BGP peers. It ensures system stability by maintaining active VRF and BGP sessions even when route limits are exceeded. This capability builds upon the neighbor-level prefix limits introduced in [Configure BGP Prefix Limit on CE Devices for Azure Operator Nexus - Operator Nexus | Microsoft Learn](https://learn.microsoft.com/en-us/azure/operator-nexus/howto-configure-bgp-prefix-limit-on-customer-edge-devices), extending overload protection to a broader scope across the entire VRF.

## Applicability

* Device Scope: AON CE devices in multi-tenant environments
* Configuration Scope: Optional, applied at the L3 Isolation Domain (ISD) level
* Protocol Scope: BGP IPv4 and IPv6

## Key Behaviors

### Hard Limit

Defines the maximum number of routes (per AF) allowed in the Routing Information Base (RIB). Once exceeded, new routes are dropped but the VRF and existing BGP sessions remain active. (Only new BGP neighbor routes are not installed). Suppressed routes are not installed in the FIB and not advertised to BGP peers.

### Soft Limit (Threshold)

A warning threshold (percentage of hard limit) that triggers alerts/logs. Does not block new routes but serves as an early warning mechanism.

Note:

* Hard and soft limits are not independently configurable. They must be defined together per VRF.
* When both the soft and hard route limits are reached, the system logs are generated to notify administrators of threshold breaches and potential route suppression events.

## Suppression Behavior

Suppressed routes exist in the BGP table/RIB, but are not installed in the FIB or advertised to peers. If the route count drops below the hard limit, suppressed routes are automatically re-evaluated and installed (FIFO queue logic applies). This behavior is NOS-dependent. Arista NOS supports suppression queues; others may require re-advertisement.

Neighbor-level limits and VRF-level limits can coexist. Example: Per-neighbor limits on NNI can be defined alongside per-VRF limits.

### CLI and REST API Examples

Create Operations

1. Azure CLI – Create a New L3 ISD

Use this command to create a new L3 ISD with route limits for both IPv4 and IPv6.

az networkfabric l3domain create \
 --resource-group <resource-group-name> \
 --nf-id <nf-id> \
 --resource-name <l3isd-name> \
 --v6route-prefix-limit "{\"hard-limit\":3000,\"threshold\":50}" \
 --v4route-prefix-limit "{\"hard-limit\":3000,\"threshold\":40}" \
 --location <location>

* hard-limit: Maximum number of routes allowed.
* threshold: Warning level (percentage of hard limit)
* This configuration ensures proactive monitoring and suppression of excess routes.

2. REST API – Create a New L3 ISD

Use this REST API call to create an L3 ISD with route limits and additional configuration options.

az rest --method PUT \
 --url "https://management.azure.com/subscriptions/<subscription\_id>/resourceGroups/<resource\_group>/providers/Microsoft.ManagedNetworkFabric/L3IsolationDomains/<l3isd-name>?api-version=2025-07-15" \
 --body "{
 \"location\": \"<location>\",
 \"properties\": {
 \"redistributeConnectedSubnets\": \"True\",
 \"redistributeStaticRoutes\": \"False\",
 \"networkFabricId\": \"<network\_fabric\_id>\",
 \"administrativeState\": \"Disabled\",
 \"v4routePrefixLimit\": {
 \"hardLimit\": 10,
 \"threshold\": 40
 },
 \"v6routePrefixLimit\": {
 \"hardLimit\": 10,
 \"threshold\": 40
 }
 }
 }"

* Route limits are applied per VRF and enforced via FIB updates.

Update Operations

3. Azure CLI – Update an Existing L3 ISD

Use this command to modify route limits for an existing ISD.

az networkfabric l3domain update \
 --resource-name <l3isd-name> \
 --resource-group <resource-group-name> \
 --v6route-prefix-limit "{\"hard-limit\":2000,\"threshold\":50}" \
 --v4route-prefix-limit "{\"hard-limit\":2000,\"threshold\":40}"

* Adjusts route limits dynamically without service disruption.
* Useful for scaling or tuning based on tenant growth or operational thresholds.

4. REST API – Update an Existing L3 ISD

Use this REST API call to patch route limits for an existing ISD.

az rest --method PATCH \
 --url "https://management.azure.com/subscriptions/<subscription\_id>/resourceGroups/<resource\_group>/providers/Microsoft.ManagedNetworkFabric/L3IsolationDomains/<l3isd-name>?api-version=2025-07-15" \
 --body "{
 \"properties\": {
 \"v4routePrefixLimit\": {
 \"hardLimit\": 10,
 \"threshold\": 40
 },
 \"v6routePrefixLimit\": {
 \"hardLimit\": 10,
 \"threshold\": 40
 }
 }
 }"

* Enables fine-tuning of route limits post-deployment.
* Changes are applied via API and enforced after a fabric commit v2 flow.

## Troubleshooting

The following CLI commands are useful for monitoring and diagnosing VRF route limit behavior on AON CE devices. They help administrators track route counts, identify suppressed routes, and verify enforcement of configured limits.

|  |  |  |
| --- | --- | --- |
| **Command** | **Description** | **Use Case** |
| show ip route vrf <vrf-name> summary | Displays the total number of IPv4/ IPv6 routes installed in the specified VRF and the configured route limit. | Verify if the IPv4/ IPv6 route count is approaching or exceeding the hard limit. |
| show ipv4/ipv6 route vrf <vrf-name> summary | Displays the total number of IPv4/ IPv6 routes installed in the specified VRF and the configured route limit. | Monitor IPv4/ IPv6 route growth and ensure it remains within configured thresholds. |
| show fib ipv4/ ipv6 route limit vrf <vrf-name> suppressed | Lists IPv4/ IPv6 routes that were suppressed due to exceeding the configured hard limit. | Identify which IPv4/ IPv6 routes are being held back from FIB installation. |
| show fib ipv4 / ipv6 route limit vrf <vrf-name> suppressed | Lists IPv4/ IPv6 routes that were suppressed due to exceeding the configured hard limit. | Troubleshoot IPv4/ IPv6 route suppression and propagation issues. |
