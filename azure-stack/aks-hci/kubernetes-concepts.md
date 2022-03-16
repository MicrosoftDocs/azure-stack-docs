---
title: Concepts - Kubernetes cluster architecture for Azure Kubernetes Services (AKS) on Azure Stack HCI
description: Learn the basic cluster and workload components of Kubernetes and how they relate to Azure Kubernetes Service on Azure Stack HCI features
author: mattbriggs
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: daschott
ms.topic: conceptual
ms.date: 08/03/2021
#intent: As an IT Pro, I want to learn about the basic cluster and workload components of Kubernetes and how they relate to features in ASK on Azure Stack HCI.
#keyword: Azure Kubernetes ASK workload components Azure Stack HCI
---

# Clusters and workloads for Azure Kubernetes Service on Azure Stack HCI

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022 Datacenter, Windows Server 2019 Datacenter

Azure Kubernetes Service on Azure Stack HCI is an enterprise-grade Kubernetes container platform powered by Azure Stack HCI. It includes Microsoft-supported core Kubernetes, a purpose-built Windows container host, and a Microsoft-supported Linux container host with a goal to have a **simple deployment and life cycle management experience**.

This article introduces the core Kubernetes infrastructure components, such as the control plane, nodes, and node pools. Workload resources such as pods, deployments, and sets are also introduced, along with how to group resources into namespaces.

## Cluster components

Kubernetes is the core component of the Azure Kubernetes Service on Azure Stack HCI. Azure Kubernetes Service on Azure Stack HCI uses a set of predefined configurations to deploy Kubernetes cluster(s) effectively and with scalability in mind.

The deployment operation will create multiple Linux or Windows virtual machines and join these together to create Kubernetes cluster(s).

> [!NOTE]
> To help improve the reliability of the system, if you are running multiple Cluster Shared Volumes (CSV) in your Azure Stack HCI cluster, by default virtual machine data is automatically spread out across all available CSVs in the cluster. This ensures that applications survive in the event of CSV outages. This applies to only new installations (not upgrades).

The deployed system is ready to receive standard Kubernetes workloads, scale these workloads, or even scale the number of virtual machines and the number of clusters up and down as needed.

An Azure Kubernetes Service cluster has the following components on Azure Stack HCI:

- *Management cluster* (also known as the AKS host) provides the core orchestration mechanism and interface for deploying and managing one or more workload clusters.
- *Workload clusters* (also known as target clusters) are where containerized applications are deployed.

![Illustrates the technical architecture of Azure Kubernetes Service on Azure Stack HCI](.\media\concepts\architecture.png)

## Manage AKS on Azure Stack HCI

You can manage AKS on Azure Stack HCI using the following management options:

- **Windows Admin Center** offers an intuitive UI for the Kubernetes operator to manage the lifecycle of Azure Kubernetes Service clusters on Azure Stack HCI.
- A **PowerShell module**  makes it easy to download, configure, and deploy Azure Kubernetes Service on Azure Stack HCI. The PowerShell module also supports deploying and configuring additional workload clusters and reconfiguring existing ones.

## The management cluster

When you create an Azure Kubernetes Service cluster on Azure Stack HCI, a management cluster is automatically created and configured. This management cluster is responsible for provisioning and managing workload clusters where workloads run. A management cluster includes the following core Kubernetes components:

- *API Server* - The API server is how the underlying Kubernetes APIs are exposed. This component provides the interaction for management tools, such as Windows Admin Center, PowerShell modules, or `kubectl`.
- *Load Balancer* - The load balancer is a single dedicated Linux VM with a load-balancing rule for the API server of the management cluster.

## The workload cluster

The workload cluster is a highly available deployment of Kubernetes using Linux VMs for running Kubernetes control plane components and Linux worker nodes. Windows Server Core based VMs are used for establishing Windows worker nodes. There can be one or more workload cluster(s) managed by one management cluster.

### Workload cluster components

The workload cluster has many components, which are described in the following sections.

#### Control plane

* *API Server* - The API server allows interaction with the Kubernetes API. This component provides the interaction for management tools, such as Windows Admin Center, PowerShell modules, or `kubectl`.
* *Etcd* - etcd is a distributed key-value store that stores data required for lifecycle management of the cluster. It stores the control plane state. 

#### Load balancer

The load balancer is a virtual machine running Linux and HAProxy + KeepAlive to provide load balanced services for the workload clusters deployed by the management cluster. For each workload cluster, Azure Kubernetes Service on Azure Stack HCI will add at least one load balancer virtual machine. Any Kubernetes service of type `LoadBalancer` that is created on the workload cluster will end up creating a load-balancing rule in the VM.

#### Worker nodes

To run your applications and supporting services, you need a Kubernetes node. An Azure Kubernetes Service workload cluster on Azure Stack HCI has one or more worker nodes, which are a virtual machines (VM) that runs the Kubernetes node components, and hosting the pods and services that make up the application workload. There are core Kubernetes workload components that can be deployed on Azure Kubernetes Service on Azure Stack HCI workload clusters such as pods and deployments.

#### Pods

Kubernetes uses *pods* to run an instance of your application. A pod represents a single instance of your application. Typically, pods have a 1:1 mapping with a container, although there are advanced scenarios where a pod may contain multiple containers. These multi-container pods are scheduled together on the same node and allow containers to share related resources. For more information, see [Kubernetes pods](https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/) and [Kubernetes pod lifecycle](https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/).

#### Deployments
 A *deployment* represents one or more identical pods, managed by the Kubernetes Deployment Controller. A deployment defines the number of *replicas* (pods) to create, and the Kubernetes Scheduler ensures that if pods or nodes encounter problems, additional pods are scheduled on healthy nodes. For more information, see [Kubernetes deployments](https://kubernetes.io/docs/concepts/workloads/controllers/deployment/).

#### StatefulSets and DaemonSets

The Deployment Controller uses the Kubernetes Scheduler to run a given number of replicas on any available node with available resources. This approach of using deployments may be sufficient for stateless applications, but not for applications that require a persistent naming convention or storage. For applications that require a replica to exist on each node, or selected nodes, within a cluster, the Deployment Controller doesn't look at how replicas are distributed across the nodes.

- *StatefulSets* -  A StatefulSet is similar to a deployment in that one or more identical pods are created and managed. Replicas in a StatefulSet follow a graceful, sequential approach to deployment, scale, upgrades, and terminations. With a StatefulSet (as replicas are rescheduled) the naming convention, network names, and storage persist. *Replicas* in a StatefulSet are scheduled and run across any available node in an Azure Kubernetes Service on Azure Stack HCI cluster. If you need to ensure that at least one pod in your Set runs on a node, you can instead use a DaemonSet. For more information, see [Kubernetes StatefulSets](https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/).

- *DaemonSets* - For specific log collection or monitoring needs, you may need to run a given pod on all, or selected, nodes. A *DaemonSet* is again used to deploy one or more identical pods, but the DaemonSet Controller ensures that each node specified runs an instance of the pod. For more information, see [Kubernetes DaemonSets](https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/).

#### Namespaces

Kubernetes resources, such as pods and deployments, are logically grouped into a *namespace*. These groupings provide a way to logically divide an Azure Kubernetes Service on Azure Stack HCI workload cluster and restrict access to create, view, or manage resources. You can create namespaces to separate business groups, for example. Users can only interact with resources within their assigned namespaces. For more information, see [Kubernetes namespaces](https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/). 

When you create an Azure Kubernetes Service cluster on Azure Stack HCI, the following namespaces are available:

- *default* - This namespace is where pods and deployments are created by default when none is provided. In smaller environments, you can deploy applications directly into the default namespace without creating additional logical separations. When you interact with the Kubernetes API, such as with `kubectl get pods`, the default namespace is used when none is specified.
- *kube-system* - This namespace is where core resources exist, such as network features like DNS and proxy, or the Kubernetes dashboard. You typically don't deploy your own applications into this namespace.
- *kube-public* - This namespace is typically not used, but can be used for resources to be visible across the whole cluster, and can be viewed by any user.

#### Secrets

Kubernetes secrets allow you to store and manage sensitive information, such as passwords, OAuth tokens, and Secure Shell (SSH) keys. By default, Kubernetes stores secrets as unencrypted base64-encoded strings and can be retrieved as plain text by anyone with API access. For more information, see [Kubernetes Secrets](https://kubernetes.io/docs/concepts/configuration/secret/).

#### Persistent volumes

A persistent volume is a storage resource in a Kubernetes cluster that has either been provisioned by the administrator or dynamically provisioned using storage classes. To use persistent volumes, pods request access using a *PersistentVolumeClaim*. For more information, see [Persistent Volumes](https://kubernetes.io/docs/concepts/storage/persistent-volumes/).

## Mixed-OS deployments

If a given workload cluster consists of both Linux and Windows worker nodes, workloads need to be scheduled onto an OS that can support provisioning the workload. Kubernetes offers two mechanisms to ensure workloads land on nodes with a target operating system:

- *Node Selector* is a simple field in the pod spec that constraints pods to only be scheduled onto healthy nodes matching the operating system.
- *Taints and tolerations* work together to ensure that pods are not scheduled onto nodes unintentionally. A node can be "tainted" so as to not accept pods that do not explicitly tolerate its taint through a "toleration" in the pod spec.

For more information, see [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) and [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

## Next steps
In this article, you learned about the cluster architecture of AKS on Azure Stack HCI and the workload cluster components. To learn more about AKS on Azure Stack HCI concepts, see the following articles:

- [Security](./concepts-security.md)
- [Container networking](./concepts-container-networking.md)
- [Storage](./concepts-storage.md)

[kubernetes-pods]: https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/
[kubernetes-pod-lifecycle]: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/
[kubernetes-deployments]: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
[kubernetes-statefulsets]: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/
[kubernetes-daemonset]: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
[kubernetes-namespaces]: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
[node-selectors]: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/
[taints-tolerations]: https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
