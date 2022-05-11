---
title: Adapt applications for use in mixed-OS Kubernetes clusters
description: How to use node selectors or taints and tolerations on Azure Kubernetes Service to ensure applications in mixed OS Kubernetes clusters running on Azure Stack HCI are scheduled on the correct worker node operating system
author: mattbriggs
ms.topic: how-to
ms.date: 04/13/2022
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: abha
# Intent: As an IT Pro, I want to learn how use node selectors, taints, and tolerations so I can adapt apps for use on mixed-OS Kubernetes clusters. 
# Keyword: Node Selector mixed-OS clusters taints tolerations

---
# Adapt apps for mixed-OS Kubernetes clusters using node selectors or taints and tolerations

> Applies to: Azure Stack HCI versions 21H2 and 20H2; Windows Server 2022 Datacenter, Windows Server 2019 Datacenter

Azure Kubernetes Service on Azure Stack HCI and Windows Server enables you to run Kubernetes clusters with both Linux and Windows nodes, but requires you to make small edits to your apps for use in these mixed-OS clusters. In this how-to guide, you'll learn how to ensure your application gets scheduled on the right host OS using either node selectors, or taints and tolerations.

This how-to guide assumes a basic understanding of Kubernetes concepts. For more information, see [Kubernetes core concepts for Azure Kubernetes Service on Azure Stack HCI and Windows Server](kubernetes-concepts.md).

## Node Selector

A *Node Selector* is a simple field in the pod specification YAML that constrains pods to only be scheduled onto healthy nodes matching the operating system. In your pod specification YAML, specify a `nodeSelector` - Windows or Linux, as shown in the examples below. 

```yaml
kubernetes.io/os = Windows
```
or,

```yaml
kubernetes.io/os = Linux
```

For more information on nodeSelectors, visit [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/). 

## Taints and tolerations

*Taints* and *tolerations* work together to ensure that pods aren't scheduled on nodes unintentionally. A node can be "tainted" not to accept pods that don't explicitly tolerate its taint through a "toleration" in the pod specification YAML.

Windows OS nodes in AKS on Azure Stack HCI and Windows Server can be tainted when created in the [New-AksHciNodePool](./reference/ps/new-akshcinodepool.md) command or the [New-AksHciCluster](./reference/ps/new-akshcicluster.md) command. You can also use these commands to taint Linux OS nodes. The following example uses Windows.

If you are also creating a new cluster, run the following command to create a Windows node pool with a taint. If you have an existing cluster that you want to add a node pool with a taint to, go to the next example that uses the `New-AksHciNodePool` command.

```powershell
New-AksHciCluster -name mycluster -nodePoolName taintnp -nodeCount 1 -osType windows -taints sku=Windows:NoSchedule
```

To add a tainted node pool to an existing cluster, run the following command:

```powershell
New-AksHciNodePool -clusterName <cluster-name> -nodePoolNAme taintnp -count 1 -osType windows -taints sku=Windows:NoSchedule
```

 To check that the node pool was successfully deployed with the taint, run the following command:

```powershell
Get-AksHciNodePool -clusterName <cluster-name> -name taintnp
```

**Example Output**
```Output
Status       : {Phase, Details}
ClusterName  : mycluster
NodePoolName : taintnp
Version      : v1.20.7-kvapkg.1
OsType       : Windows
NodeCount    : 0
VmSize       : Standard_K8S3_v1
Phase        : Deployed
Taints       : {sku=Windows:NoSchedule}
```

You specify a toleration for a pod in the pod specification YAML. The following toleration "matches" the taint created by the `kubectl` taint line shown above. The result is that a pod with the toleration will be able to schedule onto the tainted nodes.

```yaml
tolerations:
- key: node.kubernetes.io/os
  operator: Equal
  value: Windows
  effect: NoSchedule
```


The steps in this section will work well if you are in control of the pod spec that you're deploying. However, in some cases, users have a pre-existing large number of deployments for Linux containers, as well as an ecosystem of common configurations, such as community [Helm charts](https://helm.sh/docs/intro/using_helm/#helm-search-finding-charts). You won’t have access to the pod spec unless you want to download the chart and edit it. If you deploy these Helm charts to a mixed cluster environment with both Linux and Windows worker nodes, your application pods will fail with the error "ImagePullBackOff", for example:

```powershell
C:\>kubectl get pods
NAMESPACE              NAME                                                    READY   STATUS              RESTARTS   AGE
default                nginx-deployment-558fc78868-795dp                       0/1     ImagePullBackOff    0          6m24s
default                nginx-deployment-6b474476c4-gpb77                       0/1     ImagePullBackOff    0          11m
```

In this instance, you should look at using [taints](https://cloud.google.com/kubernetes-engine/docs/how-to/node-taints) to help with this:
Windows Server nodes can be tainted with the following key-value pair: node.kubernetes.io/os=windows:NoSchedule

For more information on taints and tolerations, visit [Taints and Tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/). 

## Next steps

In this how-to guide, you learned how to add node selectors or taints and tolerations to your Kubernetes clusters using kubectl. Next, you can:
- [Deploy a Linux applications on a Kubernetes cluster](./deploy-linux-application.md).
- [Deploy a Windows Server application on a Kubernetes cluster](./deploy-windows-application.md).