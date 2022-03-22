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

You can adjust the number of nodes that run application workloads using  Azure Kubernetes Service (AKS) to keep up with demand.  For this preview release, you can use PowerShell to enable the autoscaler and to manage  automatic scaling of node pools in your target clusters. In this article we look at the context of the autoscaler on AKS on Azure Stack HCI, and how the autoscaler works.

> [!IMPORTANT]
> Horizontal node autoscaling is currently in PREVIEW.
> See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released into general availability.
## Horizontal node autoscaling

In AKS, the cluster autoscaler watches for pods in your cluster that can't be scheduled because of resource constraints. When issues are detected, the number of nodes in a node pool increases to meet application demand. Nodes are also regularly checked for a lack of running pods, and then the number of nodes decreases, as needed. This ability to automatically scale up or scale down the number of nodes in your AKS cluster lets you run efficient, cost-effective clusters. *Autoscaling* is the ability of the system to automatically adjust your workloads through automation and configuration that contains specific parameters based on input, measures, and rules.

To enable horizontal node scaling AKS needs to implement basic resource management. AKS estimates resource requirement that trigger autoscaling events at a point in time. AKS won't take into account resource consumption from outside of AKS on Azure Stack HCI. For example, when you add VMs after enabling the autoscaler, this event occurs outside of the context of the autoscaler.
## Purpose of horizontal node autoscaling 

The autoscaler automatically increases the size of a node pool from the minimum to the maximum number of nodes specified. When you have enabled automatic scaling, the autoscaler will determine if the maximum number of nodes is feasible and warn you about over provisioning the hardware resources available. 

The autoscaler tracks available and promised resources across all deployed target clusters and node pools.  The scaler uses this data to make an informed decision. As the autoscaler increases node pool, the autoscaler checks for the availability of resources. 

AKS on Azure Stack HCI uses the built in Kubernetes autoscaling feature to support operations similar to the Azure autoscaler.

## How horizontal node autoscaling works

The autoscaler adjusts to  changing application demands. As demands change between workday and evening loads, the autoscaler shifts your clusters resources. AKS clusters scale in two ways:  

- **Triggers based on node utilization**.  
 The cluster autoscaler watches for pods that can't be scheduled on nodes because of resource constraints. The cluster autoscaler decreases the number of nodes when there has been unused capacity for time. 
- **Triggers defined in the autoscaler profiles**.  
 The cluster autoscaler uses startup parameters for triggers like time intervals between scale events and resource thresholds. See [Autoscaler Profiles](work-with-autoscaler-profiles.md). 

When you enable autoscaling on a node pool, the default profile is applied unless you override one or more of the settings using the `-ClusterAutoScalingProfile` parameter on `Set-AksHciCluster`. Unless you enable them, the default state of the node autoscaler is disabled at both the cluster and node pool creation time. 

When you enable the autoscaler for a cluster and you don't provide an **autoscalerconfig** object, the default autoscaler profile is added to the cluster. You can then fine tune the parameters in the profile by using the `Set-AksHciCluster` command and pass an **autoscalerconfig** object with the updated values. You don't need to provide all parameters in the object, you can just provide your updated parameters in the object.

## Working with horizontal node autoscaler

You can set the parameters in the  autoscaler profile to configure the autoscaler. For more information, see [How to use the autoscaler profiles](work-with-autoscaler-profiles.md).

You can use Powershell to enable, configure, and disable the autoscaler. For more information, see [Use PowerShell for horizontal node autoscaling](work-with-horizontal-autoscaler.md).

## Horizontal node autoscaling during a cluster upgrade

During cluster upgrade and update, the autoscaler will be *paused* and no scaling operation will take place until the cluster and all node pools in the cluster have completed the update operation. If the customer updates a specific node pool in a cluster to a newer K8s version autoscaler for that node pool will be paused. autoscaling operation will continue on all other node pools.

## Next steps

- [Use PowerShell for horizontal node autoscaling](work-with-horizontal-autoscaler.md)  
- [How to use the autoscaler profiles](work-with-autoscaler-profiles.md)  
- [Vertical node autoscaling](concepts-vertical-node-pool-scaling.md)
