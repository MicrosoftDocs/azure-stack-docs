---
title: Spread Azure Kubernetes Service (AKS) nodes in Rack Aware Cluster
description: Learn how to deploy AKS clusters with Rack Aware Cluster support to ensure fault tolerance and evenly distribute nodes across Azure Local zones.
author: ronmiab
ms.author: robess
ms.reviewer: mindyqdiep
ms.date: 10/03/2025
ms.topic: concept-article
---

# Spread Azure Kubernetes Service (AKS) nodes in Rack Aware Cluster

This article explains how to deploy Azure Kubernetes Service (AKS) clusters with Rack Aware Cluster support. You learn how to ensure fault tolerance and evenly distribute nodes across Azure Local zones for improved reliability.

## Prerequisites

## Key considerations

## Supported scenarios

## Deploy control plan nodes

AKS deployment supports any node configuration in Azure Local with rack aware cluster support. In this example, a 2:2 configuration (two zones with two nodes each) is used. Follow these steps to spread AKS nodes across zones.

1. Deploy AKS with control plane nodes across the zones using the `az aksarc create` cmdlet.
    - Make sure the number of control plane nodes is greater than the number of physical hosts in one zone.
    - With a 2:2 configuration, use three control plane nodes.

    ```azurecli
    az aksarc create --resource-group sample-rg --custom-location sample-cl --name sample-aksarccluster --vnet-ids "vnet-arm-id" --control-plane-count 3
    ```

2. Create a node pool with size equal to four using the `az aksarc nodepool scale` cmdlet.
    - AKS deploys a default node pool with one node, therefore scale the size to four.

    ```azurecli
    az aksarc nodepool scale --name "samplenodepool" --cluster-name "samplecluster" --resource-group "sample-rg" --node-count 4 --node-vm-size "Standard_A2_v2" 
    ```

    :::image type="content" source="./media/rack-aware-cluster-aks-nodes/spread-node-two-zones.png" alt-text="Screenshot of control plane and worker nodes spread across two zones." lightbox=" ./media/rack-aware-cluster-aks-nodes/spread-node-two-zones.png":::

    With availability sets enabled by default in AKS on Azure Local, both control plane nodes and worker nodes spread evenly across the physical hosts. For more information, see [Availability sets in AKS enabled by Azure Arc](/azure/aks/aksarc/availability-sets).

## Workload Deployment

Now that both control plane nodes and worker nodes spread evenly across the physical hosts and zones, you're ready to deploy the workload. For more information, see [Pod Anti-Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#more-practical-use-cases) in Kubernetes to deploy workload pods with replicas. In the case of a 2:2 node configuration, use four replicas.

## Fault injection

Simulate a rack failure by turning off all the physical hosts in one zone or rack, and force the Kubernetes node to fail over to the other zone or rack. After one rack or zone goes down, all Kubernetes nodes migrate to the healthy zone, and Kubernetes pods return to running status.

:::image type="content" source="./media/rack-aware-cluster-aks-nodes/zone-b-down-fault-injection.png" alt-text="Screenshot of Zone B being down during fault injection." lightbox=" ./media/rack-aware-cluster-aks-nodes/zone-b-down-fault-injection.png":::

:::image type="content" source="./media/rack-aware-cluster-aks-nodes/all-kubernetes-nodes-b-moved-to-a.png" alt-text="Screenshot of all Kubernetes nodes in Zone B moved to Zone A" lightbox=" ./media/rack-aware-cluster-aks-nodes/all-kubernetes-nodes-b-moved-to-a.png":::

## Zone Recovery

Remove the fault. The nodes fail over to the original hosts, and all Kubernetes pods return to running status.

:::image type="content" source="./media/rack-aware-cluster-aks-nodes/zone-b-recovery.png" alt-text="Screenshot of Zone B being back online after recovery." lightbox=" ./media/rack-aware-cluster-aks-nodes/zone-b-recovery.png":::

:::image type="content" source="./media/rack-aware-cluster-aks-nodes/zone-b-moved-after-recovery.png" alt-text="Screenshot of all Kubernetes nodes from Zone B moved back to Zone A." lightbox=" ./media/rack-aware-cluster-aks-nodes/zone-b-moved-after-recovery.png":::

## Limitations

Node spreading across the zone uses availability sets, which use fault domains and default to one physical machine. Availability sets aren't zone aware. For more information, see [Availability sets in AKS enabled by Azure Arc](/azure/aks/aksarc/availability-sets).

## Unsupported features or Unsupported scenarios

## Related content
