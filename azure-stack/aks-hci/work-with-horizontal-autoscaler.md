---
title: Horizontal node autoscaling in Azure Kubernetes Services (AKS) on Azure Stack HCI
description: Learn about automatically scaling node pools in Azure Kubernetes Service (AKS) on Azure Stack HCI
ms.topic: how-to
author: mattbriggs
ms.author: mabrigg 
ms.lastreviewed: 03/16/2022
ms.reviewer: mikek
ms.date: 03/16/2022

# Intent: As a Kubernetes user, I want to use cluster autoscaler to grow my nodes to keep up with application demand.
# Keyword: horizontal node autoscaling Kubernetes

---

# Use PowerShell for horizontal node autoscaling

You can use PowerShell to enable the autoscaler and to manage  automatic scaling of node pools in your target clusters. You can use PowerShell to configure and manage horizontal node autoscaling.

> [!IMPORTANT]
> Horizontal node autoscaling is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Create a new AksHciAutoScalerConfig object

Create a new **AksHciAutoScalerConfig** object to pass into the `New-AksHciCluster` or `Set-AksHciCluster` commands.

``` powershell 
New-AksHciAutoScalerProfile -Name asp1 -AutoScalerProfileConfig @{ "min-node-count"=2; "max-node-count"=7; 'scale-down-unneeded-time'='1m'}
```

You can provide the **autoscalerconfig** object when creating your cluster. The object contains the parameters for your autoscaler. For more information about the parameters. See [How to use the autoscaler profiles](work-with-autoscaler-profiles.md).

## Change an existing **AksHciAutoScalerConfig profile** object

Change an existing **AksHciAutoScalerConfig profile** object. Clusters using this object will be updated to use the new parameters. 

``` powershell 
Set-AksHciAutoScalerProfile -name myProfile -autoScalerProfileConfig @{ "max-node-count"=5; "min-node-count"=2 }
```

You can update the **autoscalerconfig** object. The object contains the parameters for your autoscaler. For more information about the parameters. See [How to use the autoscaler profiles](work-with-autoscaler-profiles.md).

## Enable autoscaling for new clusters

Set `New-AksHciCluster` and all subsequently created node pools will have autoscaling enabled upon creation.

``` powershell 
New-AksHciCluster -name mycluster -enableAutoScaler $true -autoScalerProfileName myAutoScalerProfile
```

### Enable autoscaling on an existing cluster

Set `enableAutoScaler` on an existing cluster using `Set-AksHciCluster` and all subsequently created node pools will have autoscaling enabled. You must enable autoScaling for existing node pools using `Update-AksHcinode pool`.

``` powershell 
Set-AksHciCluster -Name <string> [-enableAutoScaler <boolean>] [-autoScalerProfileName <String>] 
```

## Disable autoscaling

Set `enableAutoScaler` to false on an existing cluster using `Set-AksHciCluster` to disable autoscaling on all existing and subsequently created node pools.

``` powershell 
Set-AksHciCluster -Name <string> -enableAutoScaler $false
```

## Troubleshoot horizontal autoscaler

When the horizontal autoscaler is enabled for a target cluster, a new Kubernetes deployment will be created in the management cluster called `<cluster_name>-cluster-autoscaler`. This deployment monitors the target cluster to ensure there are enough worker nodes to schedule pods. Here are different ways to debug autoscaler related issues:

The cluster autoscaler pods running on the management cluster log useful information about how it's making scaling decisions, the number of nodes that it needs to bring up or remove, and any general errors that it may experience. Run this command to access the logs:

``` powershell 
kubectl --kubeconfig $(Get-AksHciConfig).Kva.kubeconfig logs -l app=<cluster_name>-cluster-autoscaler
```

Cloud operator logs Kubernetes events in the management cluster, which can be helpful to understand when autoscaler has been enabled or disabled for a cluster and a node pool. These can be viewed by running:

``` powershell 
kubectl --kubeconfig $(Get-AksHciConfig).Kva.kubeconfig get events
```
The cluster autoscaler deployment creates a `configmap` in the target cluster that it manages. This `configmap` holds information about the autoscaler's status at the cluster wide level and per node pool. Run this command against the target cluster to view the status:

> ![!NOTE]
> Ensure you have run `Get-AksHciCredentials -Name <clustername>` to retrieve the `kubeconfig` information to access the target cluster in question!

``` powershell 
kubectl --kubeconfig ~\.kube\config get configmap cluster-autoscaler-status -o yaml
```

The cluster autoscaler logs events on the cluster autoscaler status configmap when it scales a cluster's node pool. These can be viewed by running this command against the target cluster:
 
``` powershell
kubectl --kubeconfig ~\.kube\config describe configmap cluster-autoscaler-status
```

The cluster autoscaler emits events on pods in the target cluster when it makes a scaling decision if the pod can't be scheduled. Run this command to view the events on a pod:

``` powershell
kubectl --kubeconfig ~\.kube\config describe pod <pod_name>
```

## PowerShell reference

You can review the reference for the PowerShell cmdlets that support horizontal node autoscaling: 

 - [Get-AksHciAutoScalerProfile](./reference/ps/get-akshciautoscalerprofile.md)
 - [Get-AksHciCluster for AKS](./reference/ps/get-akshcicluster.md)
 - [Get-AksHciNodePool for AKS](./reference/ps/get-akshcinodepool.md)
 - [New-AksHciAutoScalerProfile](./reference/ps/new-akshciautoscalerprofile.md)
 - [New-AksHciCluster](./reference/ps/new-akshcicluster.md)
 - [New-AksHciNodePool](./reference/ps/new-akshcinodepool.md)
 - [Remove-AksHciAutoScalerProfile](./reference/ps/remove-akshciautoscalerprofile.md)
 - [Set-AksHciAutoScalerProfile](./reference/ps/set-akshciautoscalerprofile.md)
 - [Set-AksHciCluster](./reference/ps/set-akshcicluster.md)
 - [Set-AksHciNodePool](./reference/ps/set-akshcinodepool.md)

## Next steps
- [Learn about the autoscaler profiles](work-with-autoscaler-profiles.md)
- [Learn about horizontal node autoscaling](concepts-horizontal-node-autoscaling.md)
