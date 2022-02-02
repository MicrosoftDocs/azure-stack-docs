---
title: Create a DaemonSet in Azure Kubernetes Service on Azure Stack HCI
description: Learn how to create a DaemonSet in Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: mattbriggs
ms.topic: how-to
ms.date: 09/08/2021
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: EkeleAsonye
---

# Create DaemonSets

_DaemonSet_ is a Kubernetes object that ensures a copy of a pod that's defined in the configuration is always available on every worker node in a cluster. When a new node is added to a cluster, the DaemonSet automatically allocates the pod on that node. Similarly, when a node is deleted, then the pod running on the node is also deleted and is not rescheduled on another node (for example, as happens when using a _ReplicaSet_). This allows a user to overcome Kubernetes scheduling limitations and make sure a specific application is deployed on all nodes within the cluster.

DaemonSets can improve the overall cluster performance. For example, you can use them to deploy pods to perform maintenance tasks and support services to every node: 

- Run a log collection daemon, such as like Fluentd and Logstash.
- Run a node monitoring daemon, such as Prometheus.
- Run a cluster storage daemon, such as glusterd or ceph.

Although DaemonSets create a pod on every node by default, you can limit the number of acceptable nodes by predefining the node selector field in the YAML file. Only nodes that match the node selector will get a pod created on it by the DaemonSet controller. 

Usually, one DaemonSet deploys one daemon type across all nodes, but it's possible to have multiple DaemonSets control one daemon type by using different labels. A Kubernetes label specifies deployment rules based on the characteristics of individual nodes.

For more information on how to use DaemonSets, see [Kubernetes DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/).

## Create a DaemonSet

You describe a DaemonSet using a YAML file, and then create it using the `kubectl create` or `kubectl apply` commands (for example, `kubectl create –f example-daemon.yaml`).

The following example describes the features of a DaemonSet configuration file using an nginx image:

```yml
apiVersion: apps/v1  
kind: DaemonSet  
metadata: 
      labels: 
         app: nginx
      name: example-daemon
 spec:  
     template:
           metadata:
   	 labels:
       	  app: nginx
          spec:  
      	containers:  
       	    -name: nginx  
       	    image: nginx
```

To view the current state of the DaemonSet, use the `kubectl describe` command (for example, `kubectl describe daemonset example-daemon`).

## Limit DaemonSet to specific nodes

By default, DaemonSets create pods on all the nodes in a cluster, but with node selectors, you can configure them to create pods only in specific nodes. If you want to limit a DaemonSet to specific nodes, use the `kubectl label` command.

## Update a DaemonSet

You can update a DaemonSet using the `kubectl edit ds<NAME>` command. However, it's recommended that the user edits the original configuration file, and the use the `kubectl apply` command when it was initially created. After applying an update, the update status can be viewed using the `kubectl rollout status ds <daemonset-name>` command.

## Delete a DaemonSet

To remove a DaemonSet, use the `kubectl delete` command (for example, `kubectl delete –f example-daemon.yaml -n monitoring`). You should be cautious when specifying the name of the DaemonSet file as deleting a DaemonSet will clean up all the pods it has deployed.

## Next steps

- [Create pods](create-pods.md)
- [Create a deployment](create-deployments.md)
- [Create a ReplicaSet](create-replicasets.md)