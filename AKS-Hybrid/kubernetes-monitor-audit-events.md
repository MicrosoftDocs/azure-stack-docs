---
title: Monitor Kubernetes audit events in AKS enabled by Azure Arc
description: Learn how to create a diagnostic setting to access Kubernetes audit logs.
author: sethmanheim
ms.topic: how-to
ms.date: 02/26/2024
ms.author: sethm 
ms.lastreviewed: 02/26/2024
ms.reviewer: guanghu

---

# Monitor Kubernetes audit events

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)], AKS enabled by Azure Arc on VMware (preview)

You can access Kubernetes audit logs in Kubernetes control plane logs. Control plane logs for AKS clusters are implemented as [resource logs](/azure/azure-monitor/essentials/resource-logs) in Azure Monitor. Resource logs aren't collected and stored until you create a diagnostic setting to route them to one or more locations. You typically send them to a Log Analytics workspace, which is where most of the data for Container Insights is stored.

## Create a diagnostic setting

Before creating the diagnostic setting, install the **Arc K8S** extension, which enables log collection from the AKS cluster.

Install the Arc K8S extension by running the following command:

```azurecli
az k8s-extension create -g <resouerce-group-name> -c <cluster-name> --cluster-type connectedClusters --extension-type Microsoft.AKSArc.AzureMonitor --name "aksarc-azuremonitor" --auto-upgrade true
```

After the extension installs successfully, follow the instructions in [Diagnostic settings in Azure Monitor](/azure/azure-monitor/essentials/diagnostic-settings#resource-logs) to create a diagnostic setting using the Azure portal, Azure CLI, or PowerShell. During this process, you can specify which categories of logs to collect. The categories for AKS Arc are listed in the [Azure Monitor reference](/azure/azure-monitor/reference/tables/tables-resourcetype#azure-arc-enabled-kubernetes).

The example command is as follows:

```azurecli
az monitor diagnostic-settings create –name <Diagnostics_Setting_Name> --resource <Cluster_Resource_ID> --logs "[{category:kube-audit,enabled:true},{category:kube-audit-admin,enabled:true},{category:kube-apiserver,enabled:true},{category:kube-controller-manager,enabled:true},{category:kube-scheduler,enabled:true},{category:cluster-autoscaler,enabled:true},{category:cloud-controller-manager,enabled:true},{category:guard,enabled:true},{category:csi-aksarcdisk-controller,enabled:true},{category:csi-aksarcsmb-controller,enabled:true},{category:csi-aksarcnfs-controller,enabled:true}]" --workspace <LA_Workspace_ID>
```

:::image type="content" source="media/kubernetes-monitor-audit-events/diagnostic-settings.png" alt-text="Screenshot of portal blade showing diagnostic settings." lightbox="media/kubernetes-monitor-audit-events/diagnostic-settings.png":::

AKS supports either [Azure diagnostics mode](/azure/azure-monitor/essentials/resource-logs#azure-diagnostics-mode) or [resource-specific mode](/azure/azure-monitor/essentials/resource-logs#resource-specific) for resource logs. The mode specifies the tables in the Log Analytics workspace to which the data is sent. Azure diagnostics mode sends all data to the [AzureDiagnostics table](/azure/azure-monitor/reference/tables/azurediagnostics), while resource-specific mode sends data to [ArcK8SAudit](/azure/azure-monitor/reference/tables/arck8saudit), [ArcK8SAuditAdmin](/azure/azure-monitor/reference/tables/arck8sauditadmin), and [ArcK8SControlPlane](/azure/azure-monitor/reference/tables/arck8scontrolplane), as shown in the log category table in the next section.

After you save the setting, it can take an hour to see the events in the Log Analytics workspace or other supported destination. You can write a KQL query to extract the insights based on the log category you enabled.

### Log category

|       Category                   |      Description                                                                                                                                                                                                |      Table  (resource-specific mode)  |
|----------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------------------------|
|      kube-apiserver              |     Logs from the API server.                                                                                                                                                                                   |     ArcK8SControlPlane.                |
|      kube-audit                  |     Audit log data for every audit event including get, list, create, update, delete, patch, and post.                                                                                                          |     ArcK8SAudit                       |
|      kube-audit-admin            |     Subset of the kube-audit log category. Significantly reduces the number of logs by excluding the get and list audit events from the log.                                                                    |     ArcK8SAuditAdmin                  |
|      kube-controller-manager     |     Gain deeper visibility of issues that may arise between Kubernetes and the Azure control plane. A typical example is the AKS cluster having a lack of permissions to interact with Azure.                   |     ArcK8SControlPlane                |
|      kube-scheduler              |     Logs from the scheduler.                                                                                                                                                                                    |     ArcK8SControlPlane.                |
|      cluster-autoscaler          |     Understand why the AKS cluster is scaling up or down, which may not be expected. This information is also useful to correlate time intervals where something interesting might have happened in the cluster.  |     ArcK8SControlPlane                |
|      cloud-controller-manager    |     Logs from the cloud-node-manager component of the Kubernetes cloud controller manager.                                                                                                                      |     ArcK8SControlPlane                |
|      guard                       |     Managed Microsoft Entra ID and Azure RBAC audits. For managed Microsoft Entra ID, this category includes token in and user info out. For Azure RBAC, it includes access reviews in and out.                        |     ArcK8SControlPlane                |
|      csi-aksarcdisk-controller   |     Logs from the AKS Arc CSI storage driver.                                                                                                                                                                    |     ArcK8SControlPlane.                |
|      csi-aksarcsmb-controller    |     Logs from the AKS Arc SMB CSI storage driver.                                                                                                                                                                |     ArcK8SControlPlane.                |
|      csi-aksarcnfs-controller    |     Logs from the AKS Arc NFS CSI storage driver.                                                                                                                                                                |     ArcK8SControlPlane.                |

## Delete and disable the diagnostics setting

You can delete the diagnostics setting using the Azure portal, PowerShell, or Azure CLI:

```azurecli
az monitor diagnostic-settings delete –name <diagnostics-setting-name> --resource <resource-name> -g <resource-group-name>
```

After you successfully delete the setting, you can then delete the extension using Azure CLI:

```azurecli
az k8s-extension delete -g <resouerce-group-name> -c <cluster-name> --cluster-type connectedClusters --name "hybridaks-observability"
```

## Next steps

[Monitor Kubernetes object events](kubernetes-monitor-object-events.md)