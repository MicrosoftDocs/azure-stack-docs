---
title: Manage control plane nodes in a AKS cluster
description: Learn how to manage control plane nodes in an AKS cluster enabled by Azure Arc
ms.topic: article
ms.date: 1/16/2023
author: sethmanheim
ms.author: sethm 
ms.lastreviewed: 1/16/2023
ms.reviewer: abha
# Intent: As an IT Pro, I need to learn how to manage control plane nodes in an AKS cluster
# Keyword: node count scale clusters control plane nodes
---

# Control plane nodes in an AKS cluster enabled by Azure Arc
Every Kubernetes cluster has control plane nodes and worker nodes. While worker nodes run your application, control plane nodes are used to manage core Kubernetes components and the worker nodes.
The control plane includes the following core Kubernetes components:
- kube-apiserver:	The API server is how the underlying Kubernetes APIs are exposed. This component provides the interaction for management tools, such as kubectl or the Kubernetes dashboard.
- etcd:	To maintain the state of your Kubernetes cluster and configuration, the highly available etcd is a key value store within Kubernetes.
- kube-scheduler:	When you create or scale applications, the Scheduler determines what nodes can run the workload and starts them.
- kube-controller-manager:	The Controller Manager oversees a number of smaller controllers that perform actions such as replicating pods and handling node operations.

When you create an AKS cluster, a single control plane node with a default VM size is automatically created for you. You also have the option to define the number and size of the node VMs yourself. 
If you decide to scale your worker node pools, add new node pools or if the resource needs of your applications change in AKS, you can manually scale the number of control plane nodes in the AKS cluster. 

For durability and high availability, it is recommended to deploy 3 or 5 control plane nodes in a production Kubernetes cluster. To learn more about running control plane nodes in production, visit [operating etcd in Kubernetes](https://kubernetes.io/docs/tasks/administer-cluster/configure-upgrade-etcd/?utm_source=thenewstack&utm_medium=website&utm_content=inline-mention&utm_campaign=platform#scaling-up-etcd-clusters).

## Set control plane node parameters while creating an AKS cluster
The below example creates an AKS cluster with 3 control plane nodes and 5 Linux worker nodes. You can use [`az aksarc create`](https://learn.microsoft.com/en-us/cli/azure/aksarc?view=azure-cli-latest#az-aksarc-create) command to create AKS clusters enabled by Azure Arc.

```azurecli
az aksarc create -g my-resource-group --custom-location custom-location-id -n sample-aks-cluster --vnet-id vnet-aks-cluster --control-plane-count 3 --control-plane-vm-size Standard-A4-v2 --node-count 5
```

## Scale control plane nodes in an AKS cluster
You can scale the control plane nodes in an AKS cluster after the cluster has been created by using the [`az aksarc update`](https://learn.microsoft.com/en-us/cli/azure/aksarc?view=azure-cli-latest#az-aksarc-update) command.

The following command scales the number of control plane nodes in the sample-aks-cluster to 5.
```azurecli
az aksarc create -g my-resource-group -n sample-aks-cluster --control-plane-count 5
```

## Next steps

In this article, you learned how to manually scale an AKS cluster to increase the number of control plane nodes. Next, you can:
- [Deploy a Linux application on a Kubernetes cluster](./deploy-linux-application.md).
