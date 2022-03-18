---
title: Horizontal node autoscaling in Azure Kubernetes Services (AKS) on Azure Stack HCI
description: Learn about automatically scaling node pools in Azure Kubernetes Service (AKS) on Azure Stack HCI
ms.topic: conceptual
author: mattbriggs
ms.author: mabrigg 
ms.lastreviewed: 03/16/2022
ms.reviewer: mikek
ms.date: 03/16/2022

# Intent: As a Kubernetes user, I want to use cluster autoscaler to grow my nodes to keep up with application demand.
# Keyword: horizontal node autoscaling Kubernetes

---

# Horizontal node autoscaling in Azure Kubernetes Services (AKS) on Azure Stack HCI

To keep up with application demands in Azure Kubernetes Service (AKS), you need to adjust the number of nodes that run their workloads. Horizontal node autoscaling through the cluster autoscaler can watch for pods in your cluster that can't be scheduled because of resource constraints. When issues are detected, the number of nodes in a node pool is increased to meet the application demand. Nodes are also regularly checked for a lack of running pods, with the number of nodes then decreased as needed. This ability to automatically scale up or down the number of nodes in an AKS cluster lets customers run efficient, cost-effective clusters. By "autoscaling" we should imply ability of the system to automatically adjust (with help of some script or a program) specific parameters based on some inputs, metrics, rules.

> [!IMPORTANT]
> Horizontal node autoscaling is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.

## Horizontal node autoscaling in AKS on Azure Stack HCI

To enable horizontal node scaling the system needs to implement basic resource management. It's understood and assumed that resource requirement estimations at autoscaler enablement are only point in time measurements and won't take into account resource consumption from outside of AKS on Azure Stack HCI, for example, due to the customer running more VMs after enabling the autoscaler. For this preview release we'll focus on PowerShell user experience for enabling and managing automatic scaling of node pools in target clusters and a simplified WAC experience.

## Purpose of horizontal node autoscaling 

Automatically scale a node pool from the minimum to the maximum number of nodes specified. On enabling automatic scaling the system will determine if the maximum number of nodes is feasible and warn the customer about over provisioning the hardware resources available. On scaling a node pool up the system will verify that at the time of the operation enough resources are available. The system must be aware of available and promised resources across all deployed target clusters and node pools to make an informed decision. Utilize the builtin Kubernetes autoscaling feature analog to Azure autoscaler.

## How horizontal node autoscaling works

To adjust to changing application demands, such as between the workday and evening or on a weekend, clusters often need a way to automatically scale. AKS clusters can scale in one of two ways: 
- Triggers based on node utilization.  
    The cluster autoscaler watches for pods that can't be scheduled on nodes because of resource constraints. The cluster autoscaler decreases the number of nodes when there has been unused capacity for time. 
- Triggers defined in the autoscaler profiles.  
    The cluster autoscaler uses startup parameters for triggers like time intervals between scale events and resource thresholds. See [Autoscaler Profiles](#autoscaler-profiles). 

When enabling autoscaling on a node pool, the default profile is applied unless one or more of the settings are overridden using the '-ClusterAutoScalingProfile' parameter on `Set-AksHciCluster`. The default state of the node autoscaler is disabled at both the cluster and node pool creation time unless specified as enabled by the customer. When a customer enables autoscaler for a cluster and no **autoscalerconfig** object is provided the default autoscaler profile is added to the cluster. A customer can then fine tune the parameters in the profile by using the `Set-AksHciCluster` command and passing in an **autoscalerconfig** object with the values that need to change. The user doesn't have to provide all parameters in the object, only changed parameters have to be in the object.

## Autoscaler profiles

Autoscaler profiles define the parameters used to trigger scale events. The cluster autoscaler profile affects all node pools that use the cluster autoscaler. You cannot set an autoscaler profile per node pool. The profiles have the following attributes:

- Autoscaler profiles will apply to all node pools in a cluster.
- Profiles are global deployment level objects.
- There can be multiple profiles available in an AKS on Azure Stack HCI deployment.
- Only one profile is assigned to a given cluster. The profile is used for all node pools in the cluster.
- Changes to the profile are applied to all node pools, which have the autoscaler function enabled.
  
#### Profile Settings

The default profile consists of the below default values.

| Setting | Description | Default value |
|--|--|--|
| min-node-Count | The minimum node count the node pool this profile is assigned can scale down to. | 0 |
| max-node-Count | The maximum node count the node pool this profile is assigned to can scale up to. | 1 |
| scan-interval | How   often cluster is reevaluated for scale up or down. | 10   seconds |  |
| scale-downdelay-afteradd | How   long after scale up that scale down evaluation resumes. | 10   minutes |  |
| scale-downdelay-afterdelete | How   long after node deletion that scale down evaluation resumes. | scaninterval |
| scale-downdelay-afterfailure | How   long after scale down failure that scale down evaluation resumes. | 3   minutes |
| scale-downunneededtime | How   long a node should be unneeded before it's eligible for scale down. | 10   minutes |
| scale-downunreadytime | How   long an unready node should be unneeded before it is eligible for scale down. | 20   minutes |
| scale-downutilizationthreshold | Node utilization level,   defined as sum of requested resources divided by capacity, below which a node   can be considered for scale down. | 0.5 |
| max-     gracefulterminationsec | Maximum   number of seconds the cluster autoscaler waits for pod termination when   trying to scale down a node. | 600   seconds |
| balancesimilarnodegroups | Detects   similar node pools and balances the number of nodes between them. | false |
| expander | Type   of node pool expander to   be used in scale up. Possible values: most-pods,   random, least-waste, priority. | random |
| skip-nodeswith-localstorage | If true cluster   autoscaler will never delete nodes with pods with local storage, for example,   EmptyDir or HostPath. | true |
| skip-nodeswithsystempods | If true cluster autoscaler   will never delete nodes with pods from kube-system     (except   for DaemonSet or mirror pods). | true |
| max-emptybulk-delete | Maximum   number of empty nodes that can be deleted at the same time. | 10 nodes |
| new-podscale-updelay | For   scenarios like burst/batch scale where you don't want CA to act before the   kubernetes scheduler could schedule all the pods, you can tell CA to ignore   unscheduled pods before they're a certain age. | 0   seconds |
| max-totalunreadypercentage | Maximum   percentage of unready nodes in the cluster. After this percentage is   exceeded, CA halts operations. | 45% |
| max-nodeprovisiontime | Maximum   time the autoscaler waits for a node to be provisioned. | 15   minutes |

> [!NOTE]  
> The cluster autoscaler makes scaling decisions based on the minimum and maximum counts set on each node pool, but it does not enforce them after updating the min or max counts. For example, setting a min count of 5 when the current node count is 3 will not immediately scale the pool up to 5. If the minimum count on the node pool has a value higher than the current number of nodes, the new min or max settings will be respected when there are enough unschedulable pods present that would require 2 new additional nodes and trigger an autoscaler event. After the scale event, the new count limits are respected. You can also configure more granular details of the cluster autoscaler by changing the default values in the cluster-wide autoscaler profile. For example, a scale down event happens after nodes are under-utilized after 10 minutes. If you had workloads that ran every 15 minutes, you may want to change the autoscaler profile to scale down under utilized nodes after 15 or 20 minutes. When you enable the cluster autoscaler, a default profile is used unless you specify different settings. The cluster autoscaler profile has the following settings that you can update: To change the settings in the cluster autoscaler profile we introduce a new command to `Set-AksHciAutoScalerConfig`.

## Use PowerShell for horizontal node autoscaling

You can use PowerShell to configure and manage  horizontal node autoscaling.

### New-AksHciAutoScalerConfig

Create a new **AksHciAutoScalerConfig** object to pass into the `New-AksHciCluster` or `Set-AksHciCluster `commands.

``` powershell  
New-AksHciAutoScalerProfile -Name asp1 -AutoScalerProfileConfig @{ "min-node-count"=2; "max-node-count"=7; 'scale-down-unneeded-time'='1m'}
```

### Set-AksHciAutoScalerConfig

Change an existing **AksHciAutoScalerConfig profile** object. Clusters using this object will be updated to use the new parameters. 

``` powershell  
Set-AksHciAutoScalerProfile -name myProfile -autoScalerProfileConfig @{ "max-node-count"=5; "min-node-count"=2 }
```

### New-AksHciCluster to enable automatic node pool scaling

If you set `New-AksHciCluster` all subsequently created node pools will have autoscaling enabled upon creation.

``` powershell  
New-AksHciCluster -name mycluster -enableAutoScaler $true -autoScalerProfileName myAutoScalerProfile
```

### Set-AksHciCluster to enable autoscaling

If you set on an existing cluster using Set-AksHciCluster all subsequently created node pools will have autoscaling enabled. User must enable autoScaling for existing node pools using `Update-AksHcinode pool`.

``` powershell  
Set-AksHciCluster -Name <string> [-enableAutoScaler <boolean>] [-autoScalerProfileName <String>] 
```

### Set-AksHciCluster to disable autoscaling

If set on an existing cluster using `Set-AksHciCluster` all existing and subsequently created node pools will have autoscaling disabled.

``` powershell  
Set-AksHciCluster -Name <string> -enableAutoScaler $false
```

## Horizontal node autoscaling during a cluster upgrade

During cluster upgrade and update, the autoscaler will be *paused* and no scaling operation will take place until the cluster and all node pools in the cluster have completed the update operation. If the customer updates a specific node pool in a cluster to a newer K8s version autoscaler for that node pool will be paused. autoscaling operation will continue on all other node pools.

## Troubleshoot horizontal autoscaler

When the horizontal autoscaler is enabled for a target cluster, a new Kubernetes deployment will be created in the management cluster called `<cluster_name>-cluster-autoscaler`. This deployment monitors the target cluster to ensure there are enough worker nodes to schedule pods. Here are different ways to debug autoscaler related issues:

The cluster autoscaler pods running on the management cluster log useful information about how it's making scaling decisions, the number of nodes that it needs to bring up or remove, and any general errors that it may experience. Run this command to access the logs:

``` powershell  
kubectl --kubeconfig $(Get-AksHciConfig).Kva.kubeconfig logs -l app=<cluster_name>-cluster-autoscaler
```

Cloud operator logs Kubernetes events in the management cluster, which can be helpful to understand when autoscaler has been enabled or disabled for a cluster and a node pool.  These can be viewed by running:

``` powershell  
kubectl --kubeconfig $(Get-AksHciConfig).Kva.kubeconfig get events
```
The cluster autoscaler deployment creates a `configmap` in the target cluster that it manages. This `configmap` holds information about the autoscaler's status at the cluster wide level and per node pool.  Run this command against the target cluster to view the status:

> ![!NOTE]
> Ensure you have run `Get-AksHciCredentials -Name <clustername>` to retrieve the `kubeconfig` information to access the target cluster in question!

``` powershell  
kubectl --kubeconfig ~\.kube\config get configmap cluster-autoscaler-status -o yaml
```

The cluster autoscaler logs events on the cluster autoscaler status configmap when it scales a cluster's node pool. These can be viewed by running this command against the target cluster:
 
``` powershell
kubectl --kubeconfig ~\.kube\config describe configmap cluster-autoscaler-status
```

The cluster autoscaler emits events on pods in the target cluster when it makes a scaling decision if the pod can’t be scheduled. Run this command to view the events on a pod:

``` powershell
kubectl --kubeconfig ~\.kube\config describe pod <pod_name>
```

## Next steps

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