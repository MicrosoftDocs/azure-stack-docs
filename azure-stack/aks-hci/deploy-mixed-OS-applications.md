---
title: Deploy Applications in mixed OS Kubernetes Clusters
description: How to use node selectors or taints and tolerations to deploy applications in mixed OS Kubernetes clusters
author: abha
ms.topic: how-to
ms.date: 09/21/2020
ms.author: abha
ms.reviewer: 
---

# Deploy applications in mixed OS Kubernetes clusters


## Overview 
Ensuring Linux applications run on Linux OS Kubernetes nodes and Windows applications run on Windows OS Kubernetes nodes is critical. In this how-to guide, you'll learn how to ensure your application gets scheduled on the right host OS using either node selectors or taints and tolerations.

This how-to guide assumes a basic understanding of Kubernetes concepts. For more information, see Kubernetes core concepts for Azure Kubernetes Service on Azure Stack HCI.

## Node Selector 
*Node Selector* is a simple field in the pod specification YAML that constrains pods to only be scheduled onto healthy nodes matching the operating system. In your pod specification YAML, specify a `nodeSelector` - Windows or Linux, as shown in the examples below. 

```yaml
kubernetes.io/os = Windows
```
or,

```yaml
kubernetes.io/os = Linux
```

For more information on nodeSelectors, visit [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/). 

## Taints and tolerations 
*Taints* and *tolerations* work together to ensure that pods are not scheduled on nodes unintentionally. A node can be "tainted" to not accept pods that do not explicitly tolerate its taint through a "toleration" in the pod specification YAML.

Windows OS nodes in Azure Kubernetes Service on Azure Stack HCI can be tainted with the following key-value pair. Users should not use a different one.

```yaml
node.kubernetes.io/os=Windowss:NoSchedule
```
Run `kubectl get` and identify the Windows worker nodes you want to taint.

```PowerShell
kubectl get nodes --all-namespaces -o=custom-columns=NAME:.metadata.name,OS:.status.nodeInfo.operatingSystem
```
Output:
```output
NAME                                     OS
my-aks-hci-cluster-control-plane-krx7j   linux
my-aks-hci-cluster-md-md-1-5h4bl         windows
my-aks-hci-cluster-md-md-1-5xlwz         windows
```

Taint Windows server worker nodes using `kubectl taint node`.

```PowerShell
kubectl taint node my-aks-hci-cluster-md-md-1-5h4bl node.kubernetes.io/os=Windows:NoSchedule
kubectl taint node my-aks-hci-cluster-md-md-1-5xlwz node.kubernetes.io/os=Windows:NoSchedule
```

You specify a toleration for a pod in the pod specification YAML. The following toleration "matches" the taint created by the kubectl taint line above, and thus a pod with the toleration would be able to schedule onto my-aks-hci-cluster-md-md-1-5h4bl or my-aks-hci-cluster-md-md-1-5xlwz:

```yaml
tolerations:
- key: node.kubernetes.io/os
  operator: Equal
  value: Windows
  effect: NoSchedule
```
For more information on taints and tolerations, visit [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/). 

## Next steps

In this how-to guide, you learned how to add node selectors or taints and tolerations to your Kubernetes clusters using kubectl. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).
