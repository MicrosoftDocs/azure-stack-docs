---
title: Metrics and monitoring logs in AKS Arc
description: Learn about metrics and logs used to monitor Kubernetes clusters in AKS Arc.
author: sethmanheim
ms.topic: how-to
ms.date: 05/30/2024
ms.author: sethm 
ms.lastreviewed: 03/28/2024
ms.reviewer: haojiehang

---

# AKS Arc monitoring data reference

This article provides an overview of the metrics and logs used to monitor Kubernetes clusters in AKS Arc.

## Metrics

### Platform Metrics
The following table lists the platform metrics supported for AKS Arc. In order to view these basic platform metrics, you may install the observability extension on your Kubernetes cluster and wait a few minutes to start automatic metrics ingestion. Follow each link for a detailed list of the metrics for each particular type.

| Metric type           | Resource provider/type namespace                       |
|-----------------------|--------------------------------------------------------|
| Provisioned clusters  | [Microsoft.HybridContainerService/provisionedClusters](/azure/azure-monitor/reference/supported-metrics/microsoft-hybridcontainerservice-provisionedclusters-metrics)   |
| Connected clusters    | [Microsoft.Kubernetes/connectedClusters](/azure/azure-monitor/reference/supported-metrics/microsoft-kubernetes-connectedclusters-metrics)                 |

### Prometheus Metrics
To view more granular metrics, it is recommended to enable Managed Prometheus extension in your Kubernetes and query Prometheus metrics in Metrics Explorer or Managed Grafana. The extension onboarding instructions can be found in [here](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli#enable-prometheus-and-grafana). 


## Azure Monitor Logs
AKS Arc supports two kinds of logs: Control Plane logs implemented as resource logs and container insights logs. For more information about exporting control plane logs such as audit logs using diagnostic settings, see [Monitor Kubernetes audit events](/azure/aks/hybrid/kubernetes-monitor-audit-events). For more information about enabling container insights, see [Enable Container Insights](https://learn.microsoft.com/en-us/azure/azure-monitor/containers/kubernetes-monitoring-enable?tabs=cli). 


### Control Plane Logs
The following table lists the log categories available for AKS Arc. This table can also be found in [Azure Monitor resource log reference](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/supported-logs/microsoft-kubernetes-connectedclusters-logs).

| Category                   | Description                                                                                                                                                                                                   | Table (resource-specific mode)  |
|----------------------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------|
| kube-apiserver             | Logs from the API server.                                                                                                                                                                                     | ArcK8SControlPlane             |
| kube-audit                 | Audit log data for every audit event including get, list, create, update, delete, patch, and post.                                                                                                            | ArcK8SAudit                     |
| kube-audit-admin           | Subset of the kube-audit log category. Significantly reduces the number of logs by excluding the get and list audit events from the log.                                                                      | ArcK8SAuditAdmin                |
| kube-controller-manager    | Gain deeper visibility into issues that can arise between Kubernetes and the Azure control plane. A typical example is when the AKS cluster has insufficient permissions to interact with Azure.                     | ArcK8SControlPlane              |
| kube-scheduler             | Logs from the scheduler.                                                                                                                                                                                      | ArcK8SControlPlane             |
| cluster-autoscaler         | Understand why the AKS cluster is scaled up or down, which might not be expected. This information is also useful to correlate time intervals during which something interesting might have happened in the cluster.  | ArcK8SControlPlane              |
| cloud-controller-manager   | Logs from the cloud-node-manager component of the Kubernetes cloud controller manager.                                                                                                                        | ArcK8SControlPlane              |
| guard                      | Managed Microsoft Entra ID and Azure RBAC audits. For managed Microsoft Entra ID, this category includes token in and user info out. For Azure RBAC, it includes access reviews in and out.                   | ArcK8SControlPlane              |
| csi-aksarcdisk-controller  | Logs from the AKS Arc CSI storage driver.                                                                                                                                                                     | ArcK8SControlPlane             |
| csi-aksarcsmb-controller   | Logs from the AKS Arc SMB CSI storage driver.                                                                                                                                                                 | ArcK8SControlPlane             |
| csi-aksarcnfs-controller   | Logs from the AKS Arc NFS CSI storage driver.                                                                                                                                                                 | ArcK8SControlPlane             |

For more information, see the list of [all resource log category types supported in Azure Monitor](/azure/azure-monitor/essentials/resource-logs-schema).


### Azure Monitor Log Tables

For both control plane logs and container insights, you can analyze them in Log Analytics Workspace. The Log Analytics tables can be found in [Azure Monitor Reference](https://learn.microsoft.com/en-us/azure/azure-monitor/reference/tables-index#azure-arc-enabled-kubernetes).


## Activity log

The following table lists a few example operations related to AKS that might be created in the Activity log. Use the Activity log to track information such as when a cluster is created or had its configuration change. You can view this information in the portal or by using other methods. You can also use it to create an Activity log alert to be proactively notified when an event occurs.

| Resource Type                | Notes                                                                            |
|------------------------------|----------------------------------------------------------------------------------|
| [ProvisionedClusterInstances](/rest/api/hybridcontainer/provisioned-cluster-instances)  | Follow this link for a list and descriptions of operations used in AKS Arc.  |


## Next steps

- [Monitor real-time Kubernetes object events](kubernetes-monitor-object-events.md)
- [Monitor Kubernetes audit events](kubernetes-monitor-audit-events.md)
