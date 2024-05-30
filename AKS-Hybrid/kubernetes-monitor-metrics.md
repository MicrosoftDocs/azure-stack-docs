---
title: Metrics and monitoring logs in AKS Arc
description: Learn about metrics and logs used to monitor Kubernetes clusters in AKS Arc.
author: sethmanheim
ms.topic: how-to
ms.date: 05/30/2024
ms.author: sethm 
ms.lastreviewed: 03/28/2024
ms.reviewer: haojiehan

---

# AKS Arc monitoring data reference

This article provides an overview of the metrics and logs used to monitor Kubernetes clusters in AKS Arc.

## Metrics

The following table lists the platform metrics collected for AKS Arc. Follow each link for a detailed list of the metrics for each particular type.

| Metric type           | Resource provider/type namespace                       |
|-----------------------|--------------------------------------------------------|
| Provisioned clusters  | [Microsoft.HybridContainerService/provisionedClusters](/azure/azure-monitor/reference/supported-metrics/microsoft-hybridcontainerservice-provisionedclusters-metrics)   |
| Connected clusters    | [Microsoft.Kubernetes/connectedClusters](/azure/azure-monitor/reference/supported-metrics/microsoft-kubernetes-connectedclusters-metrics)                 |

## Azure Monitor resource logs

AKS Arc implements control plane logs (including audit logs) for clusters as [resource logs in Azure Monitor](/azure/azure-monitor/essentials/resource-logs). For more information about creating diagnostic settings to collect these logs, see [Monitor Kubernetes audit events](/azure/aks/hybrid/kubernetes-monitor-audit-events). The following table lists the resource log categories you can collect for AKS Arc:

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

## Azure Monitor log tables

The following table lists all the Azure Monitor log tables relevant to AKS Arc:

| Resource Type     | Notes                                                                                            |
|-------------------|--------------------------------------------------------------------------------------------------|
| [ConnectedCluster](/azure/azure-monitor/reference/tables/tables-resourcetype#azure-arc-enabled-kubernetes)  | Follow this link for a list of all tables used by AKS Arc, and a description of their structure.  |

## Azure Activity log

The following table links to a few example operations related to AKS Arc that might be created in the [Activity log](/azure/azure-monitor/essentials/activity-log-insights). Use the activity log to track information such as when a cluster is created, or had its configuration change:

| Resource Type                | Notes                                                                            |
|------------------------------|----------------------------------------------------------------------------------|
| [ProvisionedClusterInstances](/rest/api/hybridcontainer/provisioned-cluster-instances)  | Follow this link for a list and descriptions of operations used in AKS Arc.  |

For more information about the schema of Activity log entries, see the [Activity log schema](/azure/azure-monitor/essentials/activity-log-schema).

## Next steps

- [Monitor real-time Kubernetes object events](kubernetes-monitor-object-events.md)
- [Monitor Kubernetes audit events](kubernetes-monitor-audit-events.md)
