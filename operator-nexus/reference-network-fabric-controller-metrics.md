---
title: Network Fabric Controller internal service metrics
description: Learn about the internal service metrics exposed by the Network Fabric Controller (NFC) for monitoring availability and stability.
ms.topic: reference
ms.date: 10/27/2026
author: rbhupatiraju-ms
ms.author: rbhupatiraju
ms.service: azure-operator-nexus
---

# Network Fabric Controller internal service metrics

Azure Monitor exposes metrics for monitoring the **availability** and **stability** of Network Fabric Controller (NFC) components.

Resource-level NFC metrics are available in Azure Monitor for resources of type `Microsoft.ManagedNetworkFabric/networkFabricControllers`. Each component exposes availability, restart-count, and container restart-stability metrics.

This article also describes internal-service availability and short-window pod restart signals in the NFC managed resource group (MRG). These signals are described separately from the resource-level container restart-stability metrics.

## NFC component metrics

Each component exposes separate availability, restart-count, and restart-stability metrics.

| Component | Availability display name | Restart-count display name | Restart-stability display name |
|-----------|---------------------------|----------------------------|--------------------------------|
| Operator | NFC Operator Availability | NFC Operator Restarts | NFC Operator Restart Stability |
| gNMI Gateway | NFC gNMI Gateway Availability | NFC gNMI Gateway Restarts | NFC gNMI Gateway Restart Stability |
| Geneva Monitoring Infra | NFC Geneva Monitoring Infra Availability | NFC Geneva Monitoring Infra Restarts | NFC Geneva Monitoring Infra Restart Stability |
| Redis | NFC Redis Availability | NFC Redis Restarts | NFC Redis Restart Stability |
| ZooKeeper | NFC ZooKeeper Availability | NFC ZooKeeper Restarts | NFC ZooKeeper Restart Stability |
| Envoy | NFC Envoy Availability | NFC Envoy Restarts | NFC Envoy Restart Stability |
| NTP | NFC NTP Availability | NFC NTP Restarts | NFC NTP Restart Stability |
| xDS | NFC XDS Availability | NFC XDS Restarts | NFC xDS Restart Stability |

## Availability signals

The following internal-service availability signals indicate whether each component is running at its desired **pod** level in the specified cluster(s). They are intended to detect:

- **Partial capacity loss** (Degraded)
- **Service unavailability** (Unhealthy)

These states are based on pod availability. Metric values map to states as described in the following table.

| Metrics Category | Description/Usage | Collection interval | Measured unit |
|--|--|--|--|
| NTP availability | Indicates whether NTP is Healthy / Degraded / Unhealthy in **InfraCluster (NFC MRG)** based on running pods compared to desired pods. | 5 minutes | N/A |
| xDS availability | Indicates whether xDS is Healthy / Degraded / Unhealthy in **InfraServicesCluster** and **tenantServicesCluster (NFC MRG)** based on running pods compared to desired pods. | 5 minutes | N/A |
| Envoy availability | Indicates whether Envoy is Healthy / Degraded / Unhealthy in **InfraServicesCluster** and **tenantServicesCluster (NFC MRG)** based on running pods compared to desired pods. | 5 minutes | N/A |
| nfaOperator availability | Indicates whether nfaOperator is Healthy / Unhealthy in **nfcCluster (NFC MRG)** based on running pods compared to desired pods. | 5 minutes | N/A |

### Availability state mapping

| State | Definition |
|--|--|
| **Healthy (1)** | All desired pods are up and running. |
| **Degraded (2)** | One or more pods are not running, but the service remains operational. nfaOperator does not emit Degraded (only Healthy / Unhealthy). |
| **Unhealthy (3)** | Insufficient pods to provide service functionality. |

## Stability signal

The stability signal tracks **short-window pod restarts** for NTP, xDS, Envoy, and nfaOperator in their respective clusters. This helps detect **crash loops or instability**, even when pods are currently running.

| Metrics Category | Description/Usage | Collection interval | Measured unit |
|--|--|--|--|
| Pod restarts (5-minute window) | Measures the number of pod restarts in the last 5 minutes for NTP / xDS / Envoy / nfaOperator. Used to determine alert thresholds. | 5 minutes | Count |

> [!NOTE]
> The aggregation type for this metric should be **Max** .

Monitor restart counts to **establish appropriate alert thresholds**. Refine these thresholds based on observed behavior.

## Container restart stability

Restart-stability metrics report the health of container restart behavior for each NFC component. These state metrics are separate from restart-count metrics.

Select **Maximum** as the aggregation type when viewing or configuring alerts for restart-stability metrics.

| State | Value | Description |
|-------|-------|-------------|
| Healthy | 1 | Container restart stability is healthy. |
| Degraded | 2 | Container restart stability is degraded. |
| Unhealthy | 3 | Container restart stability is unhealthy. |
| NoSignal | No data | The restart-counter or container start-time signal is unavailable. The metric displays a gap rather than a numeric state. |

> [!NOTE]
> A healthy container can temporarily have no restart-counter or start-time signal. During that interval, its restart-stability metric displays a gap, not Healthy (1). NoSignal isn't emitted as a numeric value.

### Alert configuration

Use **Maximum** aggregation to identify the highest reported restart-stability state during the evaluation window.

- To detect Degraded or Unhealthy states, use a condition greater than 1.
- To detect only Unhealthy states, use a condition greater than 2.
- Choose evaluation windows and alert severities according to your operational requirements.
- Treat missing data separately from reported health states. A gap isn't a value of 0 or evidence that the component is healthy.

## Querying metrics

For the resource-level NFC metrics listed in this article, use the NFC resource ID with resource type `Microsoft.ManagedNetworkFabric/networkFabricControllers`. The component table lists portal display names; use the returned metric definitions to identify API metric names.

For internal-service availability and short-window pod restart signals, use the corresponding resource scopes in the **NFC managed resource group (MRG)**.

> [!NOTE]
> Metric names may vary by service (for example, `replica_state` vs `statefulset_status`). Refer to the metric definitions for the exact names.

### List available metrics

```azurecli
az monitor metrics list-definitions \
  --resource <nfc-resource-id> \
  --query "[].{name:name.value, display:name.localizedValue, description:displayDescription}" \
  -o table
```

For device health and connectivity metrics, see [Network Fabric metrics](list-of-metrics-collected.md#network-fabric-metrics).
