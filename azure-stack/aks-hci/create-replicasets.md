---
title: Create a ReplicaSet in Azure Kubernetes Service on Azure Stack HCI
description: Learn how to create a ReplicaSet in Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: mattbriggs
ms.topic: how-to
ms.date: 04/25/2022
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: EkeleAsonye
# Intent: As an IT Pro, I need to understand ReplicaSets and how to create or delete them in order to manage pods in my AKS on Azure Stack HCI deployment. 
# Keyword: ReplicaSet replica pods pod fails create ReplicaSets delete ReplicaSets
---

# Create ReplicaSets

A *ReplicaSet* is a process that runs multiple instances of a pod and keeps the specified number of pods constant. It makes sure that a stable set of replica pods is running at any given time, which guarantees an available specified number of identical pods.

When a pod fails, a ReplicaSet brings up a new instance of the pod and scales up when the running instances reach a specified number. Conversely, it scales down or deletes pods when an instance with the same label is created.

## Create a ReplicaSet

Use the `kubectl create` and `kubectl apply` commands to create ReplicaSets. The example below creates a ReplicaSet using a YAML file:

```powershell
kubectl apply –f nginx_replicaset.yaml
```

The features of a ReplicaSet configuration file are shown in YAML format:

```yml
apiVersion: apps/v1  
kind: ReplicaSet  
metadata: 
      name: web
      labels: 
         env: dev
         role: web
 spec:  
       replicas: 4
       selector: 
           matchlabels: 
  	 role: web
        template:
           metadata:
   	labels:
       	    role: web
            spec:  
      	containers:  
       	    -name: nginx  
       	    image: nginx
```

After you create a ReplicaSet, you can view the status by running the following command:

```powershell
kubectl get rs
```

You can remove, but not delete, a pod that a ReplicaSet manages by changing its label using the `kubectl edit` command. For example, if you run `kubectl edit pods 7677-69h5b`, you can change the pod label once the configuration file opens.

## Scale a ReplicaSet

There are two ways to change the number of pods that a ReplicaSet manages. 

You can edit the controller's configuration using the following command:

```powershell
kubectl edit rs <ReplicaSet_NAME>
```

You can also directly increase or decrease the number using the following command:

```powershell
kubectl scale –replicas=2 rs <ReplicaSet_NAME>
```

When you edit a manifest file, you can replace your existing configuration with the updated one:

```powershell
kubectl replace –f nginx_replicaset.yaml
```

Then, to view the status of your ReplicaSet, run `kubectl get rs <ReplicaSet_NAME>`.

Autoscaling is also an option with ReplicaSets using `kubectl autoscale rs web –max=5`. You can use autoscaling to adapt the number of pods according to the CPU load of a node.

## Delete a ReplicaSet

As with other Kubernetes objects such as DaemonSets, you can delete ReplicaSets using the `kubectl delete` command. For example, you can use the following commands:

```powershell
kubectl delete rs <ReplicaSet_NAME>
```

To delete a ReplicaSet using its filename, run the following:

```powershell
kubectl delete –f nginx_replicaset.yaml
```

Using these commands, you delete the ReplicaSet and all the pods that it manages. However, if you want to delete only the ReplicaSet resource and then keep the pods without an owner, you need to manually delete them. To manually delete a ReplicaSet, run the following command:

```powershell
kubectl delete rs <ReplicaSet_NAME> --cascade=false
```

## Next steps

- [Create pods](create-pods.md)
- [Create a DaemonSet](create-daemonsets.md)
- [Create a deployment](create-deployments.md)
