---
title: Cluster autoscaling in AKS hybrid
description: Learn about automatically scaling node pools in Azure Kubernetes Service on Azure Stack HCI
ms.topic: conceptual
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 04/15/2022
ms.reviewer: mikek
ms.date: 10/28/2022

# Intent: As a Kubernetes user, I want to use cluster autoscaler to grow my nodes to keep up with application demand.
# Keyword: cluster autoscaling

---

# Cluster autoscaling in AKS hybrid

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

You can adjust the number of nodes that run application workloads in AKS hybrid by using Azure Kubernetes Service (AKS) to keep up with demand. For this preview release, you can use PowerShell to enable the autoscaler and to manage automatic scaling of node pools in your target clusters. 

This article describes the context of the autoscaler in AKS hybrid, and how the autoscaler works. For cluster autoscaling to work effectively, you can also make use of the Kubernetes horizontal pod autoscaler, which is a standard Kubernetes component. For more information about the Kubernetes horizontal Pod autoscaler, see [Horizontal Pod Autoscaling](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale/).

## Cluster autoscaling

In AKS, the cluster autoscaler watches for pods in your cluster that can't be scheduled because of resource constraints. When issues are detected, the number of nodes in a node pool increases to meet application demand. Nodes are also regularly checked for a lack of running pods, and then the number of nodes decreases, as needed. This ability to automatically scale up or scale down the number of nodes in your AKS cluster lets you run efficient, cost-effective clusters. *Autoscaling* is the ability of the system to automatically adjust your workloads through automation and configuration that contains specific parameters based on input, measures, and rules.

To enable the cluster autoscaler, AKS needs to implement basic resource management. AKS estimates resource requirements that will trigger autoscaling events at a point in time. AKS won't take into account resource consumption from outside AKS hybrid. For example, when you add VMs after enabling the autoscaler, this event occurs outside the context of the autoscaler.

## Purpose of cluster autoscaling 

The autoscaler automatically increases the size of a node pool from the minimum to the maximum number of nodes specified. When you have enabled automatic scaling, the autoscaler will determine if the maximum number of nodes is feasible and warn you about over provisioning the hardware resources available. 

The autoscaler tracks available and promised resources across all deployed target clusters and node pools. The scaler uses this data to make an informed decision. As the autoscaler increases the node pool, the autoscaler checks for the availability of resources. 

AKS hybrid uses the built-in Kubernetes autoscaling feature to support operations similar to the Azure autoscaler.

## How cluster autoscaling works

The autoscaler adjusts to changing application demands. As demands change between workday and evening loads, the autoscaler shifts your clusters resources. AKS clusters scale in two ways:  

- **Triggers based on node utilization**.  
  The cluster autoscaler watches for pods that can't be scheduled on nodes because of resource constraints. The cluster autoscaler decreases the number of nodes when there has been unused capacity for time. 
- **Triggers defined in the autoscaler profiles**.  
  The cluster autoscaler uses startup parameters for triggers like time intervals between scale events and resource thresholds. See [Autoscaler Profiles](work-with-autoscaler-profiles.md). 

When you enable autoscaling on a node pool, the default profile is applied unless you override one or more of the settings using the `-ClusterAutoScalingProfile` parameter on `Set-AksHciCluster`. Unless you enable them, the default state of the node autoscaler is disabled at both the cluster and node pool creation time. 

When you enable the autoscaler for a cluster and you don't provide an **autoscalerconfig** object, the default autoscaler profile is added to the cluster. You can then fine tune the parameters in the profile by using the `Set-AksHciCluster` command and pass an **autoscalerconfig** object with the updated values. You don't need to provide all parameters in the object, you can just provide your updated parameters in the object.

## Working with the autoscaler

You can set the parameters in the autoscaler profile to configure the autoscaler. For more information, see [How to use the autoscaler profiles](work-with-autoscaler-profiles.md).

You can use PowerShell to enable, configure, and disable the autoscaler. For more information, see [Use PowerShell for cluster autoscaling](work-with-horizontal-autoscaler.md).

## Cluster autoscale during a cluster upgrade

During cluster upgrade and update, the autoscaler will be *paused* and no scaling operation will take place until the cluster and all node pools in the cluster have completed the update operation. If a specific node pool in a cluster is updated to a newer Kubernetes version, the autoscaler for that node pool will be paused. The autoscaling operation will continue on all other node pools.

## Next steps

- [Use PowerShell for cluster autoscaling](work-with-horizontal-autoscaler.md)  
- [How to use the autoscaler profiles](work-with-autoscaler-profiles.md)  
- [Vertical node autoscaling](concepts-vertical-node-pool-scaling.md)
