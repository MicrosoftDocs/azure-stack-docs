---
title: Create StatefulSets in Azure Kubernetes Service on Azure Stack HCI
description: Learn how to create StatefulSets in Azure Kubernetes Service (AKS) on Azure Stack HCI.
author: EkeleAsonye
ms.topic: how-to
ms.date: 12/21/2021
ms.author: v-susbo
---

# Create a StatefulSet

*StatefulSets* maintain the state of applications beyond an individual pod lifecycle, such as storage. Like deployments, a StatefulSet creates and manages at least one identical pod with unique, persistent identities and stable host names. Replicas in a StatefulSet follow a sequential approach to deployment, scale, and upgrade. 

A StatefulSet is useful for applications that require stable and unique identifiers, persistent storage, ordered deployment, deletion and scaling. Examples of these apps include MySQL, MongoDB, Kafka, and Cassandra. Stateless applications, such as Apache and Tomcat, do not care what network they're using and do not require persistent storage.

The main components of Statefulsets are the persistent volume provisioner and the headless service. For more information, see [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/).

## Create a StatefulSet

You create a StatefulSet using the `kubectl create` or `kubectl apply` command, for example:

```powershell
kubectl create –f statefulset.yaml
```
The headless service used by the StatefulSet can be created in the same manifest file.

To view the created components of your StatefulSet, run `kubectl get statefulset`, `kubectl get pv` for persistent volumes, and `kubectl get pvc` for a persistent volume claim.

## Update StatefulSets

To update a StatefulSet, edit the manifest file and run the same command used in creating the StatefulSet: `kubectl apply –f statefulset.yaml`. The update strategies can either be an _OnDelete_ update or a _rolling_ update. With the OnDelete strategy, pods will not be replaced when you apply the manifest, but you will have to manually delete existing StatefulSet pods before the new version is created. In a rolling update, StatefulSet pods will be removed and then be replaced in reverse ordinal order when you apply the manifest.

## Delete a StatefulSet

Use the `kubectl delete` command to delete a StatefulSet, but you must manually delete the headless service. For example, `kubectl delete statefulset <statefulset_NAME>`, and `kubectl delete service <svc_NAME>`. You can also delete the PV and PVC manually using `kubectl delete pv` and `kubectl delete pvc`, respectively. To prevent data loss, the PV and PVC are not deleted when StatefulSet is deleted.

## Next steps

- [Create replicasets](create-replicaset.md)
- [Create pods](create-pods.md)