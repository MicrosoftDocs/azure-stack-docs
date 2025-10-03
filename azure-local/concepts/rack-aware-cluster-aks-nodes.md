---
title: Spread Azure Kubernetes Service (AKS) nodes in Rack Aware Cluster
description: Learn how to deploy AKS clusters with Rack Aware Cluster support to ensure fault tolerance and evenly distribute nodes across Azure Local zones.
author: ronmiab
ms.author: robess
ms.reviewer: mindyqdiep
ms.date: 10/03/2025
ms.topic: concept-article
---


This article explains how to deploy Azure Kubernetes Service (AKS) clusters with Rack Aware Cluster support. You learn how to ensure fault tolerance and distribute nodes evenly across zones in Azure Local.

## Overview

## Key considerations

## Prerequisites

## Spread Azure Kubernetes (AKS) nodes in rack aware cluster

AKS deployment supports any node configuration in Azure Local with rack aware cluster support. In this example, a 2:2 configuration is used. Follow these steps to spread AKS nodes.

1. Deploy AKS with control plane nodes across the zones using the `az aksarc create` cmdlet.
    1. Make sure the number of control plane nodes is larger than the number of physical hosts in one zone.
    1. With a 2:2 configuration, use 3 control plane nodes.

        ```azurecli
    az aksarc create --resource-group sample-rg --custom-location sample-cl --name sample-aksarccluster --vnet-ids "vnet-arm-id" --control-plane-count 3
    ```

2. Create a node pool with size equal to 4 using the `az aksarc nodepool scale` cmdlet.
    - AKS deploys a default node pool with 1 node, and you need to scale the size to 4.  

    ```azurecli
    az aksarc nodepool scale --name "samplenodepool" --cluster-name "samplecluster" --resource-group "sample-rg" --node-count 4 --node-vm-size "Standard_A2_v2" 
    ```

With availability sets enabled by default in AKS on Azure Local, both control plane nodes and worker nodes spread across the physical hosts evenly. For more information, see [Availability sets in AKS enabled by Azure Arc](/azure/aks/aksarc/availability-sets).

:::image type="content" source="media/rack-aware-cluster-aks-nodes/spread-node-two-zones.png" alt-text="Screenshot of control plane and worker nodes spread across two zones.":::

## Workload Deployment

Now that we have both control plane nodes and worker nodes spreading evenly across the physical hosts as well as zones, we should be ready to deploy the workload. For more information, see [Pod Anti-Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#more-practical-use-cases) in Kubernetes to deploy the workload pods with replicas. In the case of 2:2 node configuration, the recommended replica count is 4.  

## Fault injection

Simulate a rack failure by turning off all the physical hosts in one zone or rack, and force the Kubernetes node to fail over to the other zone or rack. After one rack or zone is down, all Kubernetes nodes migrate to the healthy zone, and Kubernetes pods return to running status.

:::image type="content" source="media/rack-aware-cluster-aks-nodes/zone-b-down-fault-injection.png" alt-text="Screenshot of Zone B being down during fault injection.":::

:::image type="content" source="media/rack-aware-cluster-aks-nodes/all-kubernetes-nodes-b-moved-to-a.png" alt-text="Screenshot of all Kubernetes nodes in Zone B moved to Zone A.":::

## Zone Recovery

Remove the fault. The nodes fail over to the original hosts, and all Kubernetes pods return to running status.  

:::image type="content" source="media/rack-aware-cluster-aks-nodes/zone-b-recovery.png" alt-text="Screenshot of Zone B being back online after recovery.":::

:::image type="content" source="media/rack-aware-cluster-aks-nodes/zone-b-moved-after-recovery.png" alt-text="Screenshot of all Kubernetes nodes from Zone B moved back to Zone A.":::

## Limitations

Node spreading across the zone uses availability sets, which have the concept of fault domain and default to one physical machine. Therefore, availability sets aren't zone aware. For more information, see [Availability sets in AKS enabled by Azure Arc](/azure/aks/aksarc/availability-sets).

## Next steps
