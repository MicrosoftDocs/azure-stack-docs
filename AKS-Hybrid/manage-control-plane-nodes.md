---
title: Manage control plane nodes in a Kubernetes cluster
description: Learn how to manage control plane nodes in an AKS enabled by Azure Arc Kubernetes cluster.
ms.topic: how-to
ms.date: 02/02/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: abha
ms.lastreviewed: 02/02/2024

# Intent: As an IT Pro, I need to learn how to manage control plane nodes in an AKS Kubernetes cluster
# Keyword: node count scale clusters control plane nodes
---

# Manage control plane nodes in a Kubernetes cluster

Every Kubernetes cluster has control plane nodes and worker nodes. While worker nodes run your application, control plane nodes are used to manage core Kubernetes components and the worker nodes.
The control plane includes the following core Kubernetes components:

- **kube-apiserver**: The API server exposes the underlying Kubernetes APIs. This component provides the interaction for management tools, such as **kubectl** or the Kubernetes dashboard.
- **etcd**: To maintain the state of your Kubernetes cluster and configuration, the highly available etcd is a key value store within Kubernetes.
- **kube-scheduler**: When you create or scale applications, the scheduler determines what nodes can run the workload and starts them.
- **kube-controller-manager**: The controller manager oversees smaller controllers that perform actions such as replicating pods and handling node operations.

When you create a Kubernetes cluster, a single control plane node with a default VM size is automatically created for you. You can also define the number and size of the node VMs. If you decide to scale your worker node pools, add new node pools, or if the resource needs of your applications change in AKS, you can manually scale the number of control plane nodes in the cluster.

For durability and high availability, it's recommended that you deploy 3 or 5 control plane nodes in a production Kubernetes cluster. For more information about running control plane nodes in production, see [Operating etcd in Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/?utm_source=thenewstack&utm_medium=website&utm_content=inline-mention&utm_campaign=platform#scaling-up-etcd-clusters).

## Set control plane node parameters while creating an AKS cluster

The following example creates a Kubernetes cluster with 3 control plane nodes and 5 Linux worker nodes. You can use the [`az aksarc create`](/cli/azure/aksarc#az-aksarc-create) command to create Kubernetes clusters enabled by Azure Arc.

```azurecli
az aksarc create -g my-resource-group --custom-location custom-location-id -n sample-aks-cluster --vnet-id vnet-aks-cluster --control-plane-count 3 --control-plane-vm-size Standard-A4-v2 --node-count 5
```

## Scale control plane nodes in an AKS cluster

You can scale the control plane nodes in a Kubernetes cluster after you create the cluster using the [`az aksarc update`](/cli/azure/aksarc#az-aksarc-update) command.

The following command scales the number of control plane nodes in the sample-aks-cluster to 5:

```azurecli
az aksarc update -g my-resource-group -n sample-aks-cluster --control-plane-count 5
```

## Next steps

In this article, you learned how to manually scale a Kubernetes cluster to increase the number of control plane nodes. Next, you can:

- [Deploy a Linux application on a Kubernetes cluster](deploy-linux-application.md).
