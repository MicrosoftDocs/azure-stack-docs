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
