---
title: Create StatefulSets in AKS hybrid
description: Learn how to create StatefulSets in Azure Kubernetes Service (AKS).
author: sethmanheim
ms.topic: how-to
ms.date: 10/21/2022
ms.author: sethm 
ms.lastreviewed: 1/14/2022
ms.reviewer: EkeleAsonye
# Intent: As an IT Pro, I need to learn how to create Stateful Sets in AKS.
# Keyword: Stateful Sets
---

# Create a StatefulSet in AKS hybrid

This article describes how to create, update, and delete **StatefulSets**, which are used to maintain the state of an application beyond a pod lifecycle in an Azure Kubernetes Serice deployment in AKS hybrid.

## Overview of StatefulSets

*StatefulSets* maintain the state of applications beyond an individual pod lifecycle. Like deployments, a StatefulSet creates and manages at least one identical pod with unique, persistent identities and stable host names. Replicas in a StatefulSet follow a sequential approach to deployment, scale, and upgrade. 

A StatefulSet is useful for applications that require stable and unique identifiers, persistent storage, an ordered deployment, and scaling. Examples of these apps include MySQL, MongoDB, Kafka, and Cassandra. Stateless applications, such as Apache and Tomcat, aren't concerned what network they're using and do not require persistent storage.

The main components of StatefulSets are the persistent volume provisioner and the headless service. For more information, see [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/).

## Create a StatefulSet

You create a StatefulSet using the `kubectl create` or the `kubectl apply` command - for example:

```powershell
kubectl create –f statefulset.yaml
```

In the same manifest YAML file, you can also create the headless service that the StatefulSet uses.

To view the components you created for your StatefulSet, run the following command:

```powershell
kubectl get statefulset
```

If you want to view persistent volumes, run `kubectl get pv`. To view a persistent volume claim, run `kubectl get pvc`.

## Update StatefulSets

To update a StatefulSet, edit the manifest file, and run the same command used when creating the StatefulSet: `kubectl apply –f statefulset.yaml`. 

You can use either an _OnDelete_ update or a _rolling_ update as the update strategy:

- With an _OnDelete_ update, pods are not replaced when you apply the manifest, but you'll have to manually delete existing StatefulSet pods before the new version is created. 
- In a _rolling_ update, StatefulSet pods are removed and then replaced in reverse ordinal order when you apply the manifest.

## Delete a StatefulSet

Use the `kubectl delete` command to delete a StatefulSet and to delete the headless service separately. To delete the StatefulSet, run the following command:

```powershell
kubectl delete statefulset <statefulset_NAME>
```

Then, to delete the headless service, run the following command:

```powershell
kubectl delete service <svc_NAME>
```

To delete the persistent volume and the persistent volume claim, use `kubectl delete pv` and `kubectl delete pvc`, respectively. To prevent data loss, the persistent volume and persistent volume claim aren't deleted when a StatefulSet is deleted.

## Next steps

- [Create ReplicaSets](create-replicasets.md).
- [Create pods](create-pods.md).