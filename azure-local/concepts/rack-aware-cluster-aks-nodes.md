---
title: Spread Azure Kubernetes Service (AKS) nodes in Rack Aware cluster
description: Learn how to deploy AKS clusters with Rack Aware cluster support to ensure fault tolerance and evenly distribute nodes across Azure Local zones.
author: ronmiab
ms.author: robess
ms.reviewer: mindyqdiep
ms.date: 10/03/2025
ms.topic: concept-article
---

# Spread Azure Kubernetes Service (AKS) nodes in Rack Aware cluster

This article explains how to deploy Azure Kubernetes Service (AKS) clusters with Rack Aware cluster support. You'll learn how to ensure fault tolerance and evenly distribute nodes across Azure local zones for improved reliability.

## About AKS and Rack Aware cluster

In Azure Kubernetes Service (AKS), a node is a virtual machine (VM) that runs your containerized applications. These nodes are part of a node pool, which is a group of VMs with the same configuration. Each AKS cluster has two main components:

- **Control Plane**: Azure manages the service. The control plane orchestrates workloads and handles cluster operations.
- **Nodes**: Worker machines (VMs) that run your application containers.

A Rack Aware cluster in Azure Local is an architecture that improves fault tolerance and data distribution. It clusters machines across two physical racks in separate rooms or buildings, connected with high bandwidth and low latency. This setup helps prevent data loss or downtime if one rack fails, such as during a fire or power outage. Data is distributed evenly between the racks, so if one rack goes down, the other keeps your data available. This design is especially useful in environments like manufacturing plants that need high availability.

## Prerequisites

Review [Create Kubernetes clusters using Azure CLI](/azure/aks/aksarc/aks-create-clusters-cli#before-you-begin).

## Key considerations

When you distribute AKS nodes in Rack Aware clusters, keep these key points in mind:

- Make sure the AKS control plane has more nodes than a single zone. This setup lets the control plane deploy across zones and recover faster. For example, in a 3:3 rack aware configuration, use a five-node control plane to ensure a 3:2 split. If you use only three nodes, you can end up with a 3:0 split, which slows recovery.

- Control plane high availability isn't supported in Rack Aware clusters because they support only two zones. If a zone fails, the control plane majority can be affected, such as in a 2:1 or 3:2 split.

## Deploy control plane nodes across the zones

AKS deployment supports any node configuration in Azure Local with Rack Aware cluster support. In this example, a 2:2 configuration (two zones with two nodes each) is used. Follow these steps to spread AKS nodes across zones.

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

    With availability sets enabled by default in AKS on Azure Local, both control plane nodes and worker nodes spread evenly across the physical hosts. For more information, see [Availability sets in AKS enabled by Azure Arc](/azure/aks/aksarc/aks-create-clusters-cli).

## Workload Deployment

Now that both control plane nodes and worker nodes spread evenly across the physical hosts and zones, you're ready to deploy the workload. For more information, see [Pod Anti-Affinity](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#more-practical-use-cases) in Kubernetes to deploy workload pods with replicas. For a 2:2 node configuration, use four replicas.

## Fault injection

Fault injection is a testing technique used to intentionally introduce errors or faults into a system to check how it responds and recovers. This helps identify weaknesses and improve the system’s reliability and resilience.

You can simulate a rack failure by turning off all the physical hosts in one zone or rack, and force the Kubernetes node to fail over to the other zone or rack. After one rack or zone goes down, all Kubernetes nodes migrate to the healthy zone, and Kubernetes pods return to running status.

Here's an example:

:::image type="content" source="./media/rack-aware-cluster-aks-nodes/zone-b-down-fault-injection.png" alt-text="Screenshot of Zone B being down during fault injection." lightbox=" ./media/rack-aware-cluster-aks-nodes/zone-b-down-fault-injection.png":::

:::image type="content" source="./media/rack-aware-cluster-aks-nodes/all-kubernetes-nodes-b-moved-to-a.png" alt-text="Screenshot of all Kubernetes nodes in Zone B moved to Zone A" lightbox=" ./media/rack-aware-cluster-aks-nodes/all-kubernetes-nodes-b-moved-to-a.png":::

## Zone Recovery

Zone recovery helps you restore data or services after a failure in a specific zone, like a data center or region. It reduces downtime and data loss by letting you recover from backups or replicas in other zones.

To simulate zone recovery, remove the fault. After you remove the fault, the nodes fail over to the original hosts, and all Kubernetes pods return to running status.

Here's an example:

:::image type="content" source="./media/rack-aware-cluster-aks-nodes/zone-b-recovery.png" alt-text="Screenshot of Zone B being back online after recovery." lightbox=" ./media/rack-aware-cluster-aks-nodes/zone-b-recovery.png":::

:::image type="content" source="./media/rack-aware-cluster-aks-nodes/zone-b-moved-after-recovery.png" alt-text="Screenshot of all Kubernetes nodes from Zone B moved back to Zone A." lightbox=" ./media/rack-aware-cluster-aks-nodes/zone-b-moved-after-recovery.png":::

## Limitations

Node spreading across the zone uses availability sets, which use fault domains and default to one physical machine. Availability sets aren't zone aware. For more information, see [Availability sets in AKS enabled by Azure Arc](/azure/aks/aksarc/availability-sets).

## Related content
