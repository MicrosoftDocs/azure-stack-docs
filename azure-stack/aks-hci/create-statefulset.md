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

A StatefulSet is useful for applications that require stable and unique identifiers, persistent storage, an ordered deployment, and scaling. Examples of these apps include MySQL, MongoDB, Kafka, and Cassandra. Stateless applications, such as Apache and Tomcat, do not care what network they're using and do not require persistent storage.

The main components of StatefulSets are the persistent volume provisioner and the headless service. For more information, see [StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/).

## Create a StatefulSet

You create a StatefulSet using the `kubectl create` or `kubectl apply` command, for example:

```powershell
kubectl create –f statefulset.yaml
```

You can create the headless service that's used by the StatefulSet in the same manifest file.

To view the components you created for your StatefulSet, run the following command:

```powershell
kubectl get statefulset
```

To view persistent volumes, run `kubectl get pv`, and to view a persistent volume claim, run `kubectl get pvc`.

## Update StatefulSets

To update a StatefulSet, edit the manifest file and run the same command used when creating the StatefulSet: `kubectl apply –f statefulset.yaml`. You can use either an _OnDelete_ update or a _rolling_ update as the update strategy. With an _OnDelete_ update, pods are not replaced when you apply the manifest, but you'll have to manually delete existing StatefulSet pods before the new version is created. In a _rolling_ update, StatefulSet pods are removed and then replaced in reverse ordinal order when you apply the manifest.

## Delete a StatefulSet

Use the `kubectl delete` command to delete a StatefulSet, but you must also manually delete the headless service. For example, run `kubectl delete statefulset <statefulset_NAME>` to delete the StatefulSet, and `kubectl delete service <svc_NAME>` to delete the headless service. 

To delete the persistent volume and the persistent volume claim, use `kubectl delete pv` and `kubectl delete pvc`, respectively. To prevent data loss, the persistent volume and persistent volume claim are not deleted when a StatefulSet is deleted.

## Next steps

- [Create replicasets](create-replicasets.md)
- [Create pods](create-pods.md)