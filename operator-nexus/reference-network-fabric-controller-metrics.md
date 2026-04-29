---
title: Network Fabric Controller internal service metrics
description: Learn about the internal service metrics exposed by the Network Fabric Controller (NFC) for monitoring availability and stability.
ms.topic: reference
ms.date: 04/29/2026
author: bhumikashah
ms.author: bhumikashah
ms.service: azure-operator-nexus
---

# Network Fabric Controller internal service metrics

Azure Monitor exposes metrics that allow you to monitor the **availability** and **stability** of Network Fabric Controller (NFC) services. These metrics provide visibility into the availability and stability of NFC components and are exposed to the **NFC managed resource group (MRG)**.

Each metric section includes:

1. What the signal represents
2. How to interpret key states
3. A summary table describing category, usage, collection interval, and unit

## Availability signals

Availability signals indicate whether each component is running at its desired **pod** level in the specified cluster(s). They are intended to detect:

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
> The aggregation type for this metric should be **Max** in the Azure portal.

During initial rollout, metrics should be monitored to **establish appropriate alert thresholds**. These thresholds can then be refined based on observed behavior.

## Querying metrics

When querying metrics, use the **NFC managed resource group (MRG)** resource ID / scopes.

> [!NOTE]
> Metric names may vary by service (for example, `replica_state` vs `statefulset_status`). Refer to the metric definitions for the exact names.

### List available metrics

```azurecli
az monitor metrics list-definitions \
  --resource <nfc-resource-id> \
  --query "[].{name:name.value, display:name.localizedValue, description:displayDescription}" \
  -o table
```

### Query current values

**Availability** (state mapping may vary; refer to metric output for exact values):

```azurecli
az monitor metrics list \
  --resource <nfc-resource-id> \
  --metric "nfc_service_replica_state_xds,nfc_service_replica_state_envoy,nfc_service_replica_state_operator,nfc_services_statefulset_status_ntp" \
  --interval PT1H --aggregation Average \
  --query "value[].{metric:name.localizedValue, value:timeseries[0].data[-1].average}" \
  -o table
```

**Stability** (restart counts):

```azurecli
az monitor metrics list \
  --resource <nfc-resource-id> \
  --metric "kube_pod_container_status_restarts_total_envoy,kube_pod_container_status_restarts_total_ntp,kube_pod_container_status_restarts_total_operator,kube_pod_container_status_restarts_total_xds" \
  --interval PT1H --aggregation Average \
  --query "value[].{metric:name.localizedValue, restarts:timeseries[0].data[-1].average}" \
  -o table
```

**Split by cluster role:**

```azurecli
az monitor metrics list \
  --resource <nfc-resource-id> \
  --metric "nfc_service_replica_state_xds" \
  --interval PT5M --aggregation Average \
  --dimension nfcClusterRole -o table
```

## Configure alerts

> [!IMPORTANT]
> You must first create an **action group**; otherwise, the alert will not send a notification.

### Alert when a service becomes Unhealthy (Severity 1)

```azurecli
az monitor metrics alert create \
  --name "nfc-xds-unhealthy" \
  --resource-group <resource-group> \
  --scopes <nfc-resource-id> \
  --condition "avg nfc_service_replica_state_xds >= 3" \
  --window-size 5m --evaluation-frequency 1m \
  --severity 1 \
  --description "Alert when XDS service is Unhealthy"
```

### Alert when a service is Degraded or worse (Severity 2)

```azurecli
az monitor metrics alert create \
  --name "nfc-ntp-degraded" \
  --resource-group <resource-group> \
  --scopes <nfc-resource-id> \
  --condition "avg nfc_services_statefulset_status_ntp >= 2" \
  --window-size 5m --evaluation-frequency 1m \
  --severity 2 \
  --description "Alert when NTP service is Degraded or worse"
```

### Alert on container restarts (stability)

```azurecli
az monitor metrics alert create \
  --name "nfc-operator-restarts" \
  --resource-group <resource-group> \
  --scopes <nfc-resource-id> \
  --condition "avg kube_pod_container_status_restarts_total_operator > 0" \
  --window-size 5m --evaluation-frequency 1m \
  --severity 2 \
  --description "Alert when NFC Operator has container restarts"
```

> [!NOTE]
> Use **Max** aggregation for restart-based alerts.
