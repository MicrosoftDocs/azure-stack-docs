---
title: Concepts - Kubernetes basics for Azure Kubernetes Services (AKS) HCI
description: Learn the basic cluster and workload components of Kubernetes and how they relate to features in Azure Kubernetes Service (AKS) HCI
author: daschott
ms.author: daschott
ms.topic: conceptual
ms.date: 09/10/2020
---

# Kubernetes core concepts for Azure Kubernetes Service on Azure Stack HCI (AKS HCI)
AKS HCI is an enterprise-grade Kubernetes container platform powered by Azure Stack HCI. It includes Microsoft supported core Kubernetes, add-ons, a purpose-built Windows container host and a Microsoft-supported Linux container host with a goal to have a **simple deployment and life cycle management experience**. 

This article introduces the core Kubernetes infrastructure components such as the control plane, nodes, and node pools. Workload resources such as pods, deployments, and sets are also introduced, along with how to group resources into namespaces.

## Kubernetes cluster architecture
Kubernetes is the core component of AKS HCI. AKS HCI uses a set of predefined configurations to deploy Kubernetes Cluster(s) on Azure Stack HCI. 
 
The deployment operation will create multiple Linux or Windows virtual machines and join these together to create Kubernetes Cluster(s). 
 
The deployed system is ready to receive standard Kubernetes workloads, scale these workloads, or even scale the number of virtual machines as well as the number of Clusters up and down as needed.

An AKS HCI Kubernetes cluster is divided into two main components:

- *Management* cluster provides the the core orchestration mechanism and interface for deploying and managing one or more target clusters.
- *Target* clusters (also known as workload clusters) are where application workloads run and are managed by a management cluster.

:::image type="content" source="media/architecture.png" alt-text="AKS HCI Architecture":::

## Management cluster
When you create an AKS HCI cluster, a management cluster is automatically created and configured. This management cluster is responsible for provisioning and managing target clusters where workloads run. A management cluster includes the following core Kubernetes components:
- *API Server* - The API server is how the underlying Kubernetes APIs are exposed. This component provides the interaction for management tools such as Windows Admin Center, PowerShell modules, or `kubectl`.
- *Load Balancer* - The load balancer is a single dedicated Linux VM with a load balancing rule for the API server of the management cluster.

### Windows Admin Center (WAC) 
Windows Admin Center offers an intuitive UI for the Kubernetes operator to manage the lifecycle of AKS HCI clusters.

### PowerShell module
The PowerShell module is an easy way to download, configure and deploy AKS HCI. The PowerShell module also supports deploying and configuring additional target clusters as well as reconfiguring existing ones.

## Target cluster
The target (workload) cluster is a highly available deployment of Kubernetes using Linux VMs for running Kubernetes control plane components as well as Linux worker nodes. Windows Server Core based VMs are used for establishing Windows worker nodes. There can be one or more target cluster(s) managed by one management cluster.

### Worker nodes

To run your applications and supporting services, you need a Kubernetes node. An AKS HCI target cluster has one or more worker nodes, which is a virtual machine (VM) that runs the Kubernetes node components, as well as hosting the Pods and Services that make up the application workload.

### Load balancer
The load balancer is a virtual machine running Linux and HAProxy + KeepAlive to provide load balanced services for the target clusters deployed by the management cluster.

For each target cluster, AKS HCI will add at least one load balancer virtual machines (LB VM). In addition to this, another load balancer can be created for high availability of the API server on the target cluster. Any Kubernetes service of type `LoadBalancer` that is created on the target cluster will end up creating a load balancing rule in the LB VM.

### Add-On components
There are several optional add-on components that can be deployed in any given cluster, most notably: Azure Arc, Prometheus, Grafana, or the Kubernetes Dashboard.

## Kubernetes components
This section introduces the core Kubernetes workload components that can be deployed on AKS HCI target clusters such as pods, deployments, and sets, along with how to group resources into namespaces.

### Pods

Kubernetes uses *pods* to run an instance of your application. A pod represents a single instance of your application. Pods typically have a 1:1 mapping with a container, although there are advanced scenarios where a pod may contain multiple containers. These multi-container pods are scheduled together on the same node, and allow containers to share related resources.

When you create a pod, you can define *resource requests* to request a certain amount of CPU or memory resources. The Kubernetes Scheduler tries to schedule the pods to run on a node with available resources to meet the request. You can also specify maximum resource limits that prevent a given pod from consuming too much compute resource from the underlying node. A best practice is to include resource limits for all pods to help the Kubernetes Scheduler understand which resources are needed and permitted.

For more information, see [Kubernetes pods][kubernetes-pods] and [Kubernetes pod lifecycle][kubernetes-pod-lifecycle].

A pod is a logical resource, but the container(s) are where the application workloads run. Pods are typically ephemeral, disposable resources, and individually scheduled pods miss some of the high availability and redundancy features Kubernetes provides. Instead, pods are deployed and managed by Kubernetes *Controllers*, such as the Deployment Controller.

### Deployments and YAML manifests

A *deployment* represents one or more identical pods, managed by the Kubernetes Deployment Controller. A deployment defines the number of *replicas* (pods) to create, and the Kubernetes Scheduler ensures that if pods or nodes encounter problems, additional pods are scheduled on healthy nodes.

You can update deployments to change the configuration of pods, container image used, or attached storage. The Deployment Controller drains and terminates a given number of replicas, creates replicas from the new deployment definition, and continues the process until all replicas in the deployment are updated.

Most stateless applications in AKS HCI should use the deployment model rather than scheduling individual pods. Kubernetes can monitor the health and status of deployments to ensure that the required number of replicas run within the cluster. When you only schedule individual pods, the pods aren't restarted if they encounter a problem, and aren't rescheduled on healthy nodes if their current node encounters a problem.

If an application requires a quorum of instances to always be available for management decisions to be made, you don't want an update process to disrupt that ability. *Pod Disruption Budgets* can be used to define how many replicas in a deployment can be taken down during an update or node upgrade. For example, if you have *five (5)* replicas in your deployment, you can define a pod disruption of *4* to only permit one replica from being deleted/rescheduled at a time. As with pod resource limits, a best practice is to define pod disruption budgets on applications that require a minimum number of replicas to always be present.

Deployments are typically created and managed with `kubectl create` or `kubectl apply`. To create a deployment, you define a manifest file in the YAML (YAML Ain't Markup Language) format. The following example creates a basic deployment of the NGINX web server. The deployment specifies *three (3)* replicas to be created, and requires port *80* to be open on the container. Resource requests and limits are also defined for CPU and memory.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:1.15.2
        ports:
        - containerPort: 80
        resources:
          requests:
            cpu: 250m
            memory: 64Mi
          limits:
            cpu: 500m
            memory: 256Mi
```

More complex applications can also be created by also including services such as load balancers within the YAML manifest.

For more information, see [Kubernetes deployments][kubernetes-deployments]

##### Mixed-OS Deployments

If a given AKS HCI target cluster consists of both Linux and Windows worker nodes, workloads need to be scheduled onto an OS that can support provisioning the workload. Kubernetes offers two mechanisms to ensure workloads land on nodes with a target operating system:

- *Node Selector* is a simple field in the pod spec that constraints pods to only be scheduled onto healthy nodes matching the operating system. 
- *Taints and tolerations* work together to ensure that pods are not scheduled onto inappropriate nodes. A node can be tainted so as to not accept pods that do not explicitly tolerate its taint through a "toleration" in the pod spec.

For more information, see [node selectors][node-selectors] and [taints and tolerations][taints-tolerations].

### StatefulSets and DaemonSets

The Deployment Controller uses the Kubernetes Scheduler to run a given number of replicas on any available node with available resources. This approach of using deployments may be sufficient for stateless applications, but not for applications that require a persistent naming convention or storage. For applications that require a replica to exist on each node, or selected nodes, within a cluster, the Deployment Controller doesn't look at how replicas are distributed across the nodes.

There are two Kubernetes resources that let you manage these types of applications:

- *StatefulSets* - Maintain the state of applications beyond an individual pod lifecycle, such as storage.
- *DaemonSets* - Ensure a running instance on each node, early in the Kubernetes bootstrap process.

### StatefulSets

Modern application development often aims for stateless applications, but *StatefulSets* can be used for stateful applications, such as applications that include database components. A StatefulSet is similar to a deployment in that one or more identical pods are created and managed. Replicas in a StatefulSet follow a graceful, sequential approach to deployment, scale, upgrades, and terminations. With a StatefulSet (as replicas are rescheduled) the naming convention, network names, and storage persist.

You define the application in YAML format using `kind: StatefulSet`, and the StatefulSet Controller then handles the deployment and management of the required replicas. Data is written to persistent storage, provided by Azure Managed Disks or Azure Files. With StatefulSets, the underlying persistent storage remains even when the StatefulSet is deleted.

For more information, see [Kubernetes StatefulSets][kubernetes-statefulsets].

Replicas in a StatefulSet are scheduled and run across any available node in an AKS HCI cluster. If you need to ensure that at least one pod in your Set runs on a node, you can instead use a DaemonSet.

### DaemonSets

For specific log collection or monitoring needs, you may need to run a given pod on all, or selected, nodes. A *DaemonSet* is again used to deploy one or more identical pods, but the DaemonSet Controller ensures that each node specified runs an instance of the pod.

The DaemonSet Controller can schedule pods on nodes early in the cluster boot process, before the default Kubernetes scheduler has started. This ability ensures that the pods in a DaemonSet are started before traditional pods in a Deployment or StatefulSet are scheduled.

Like StatefulSets, a DaemonSet is defined as part of a YAML definition using `kind: DaemonSet`.

For more information, see [Kubernetes DaemonSets][kubernetes-daemonset].

### Namespaces

Kubernetes resources, such as pods and Deployments, are logically grouped into a *namespace*. These groupings provide a way to logically divide an AKS HCI target cluster and restrict access to create, view, or manage resources. You can create namespaces to separate business groups, for example. Users can only interact with resources within their assigned namespaces.

When you create an AKS HCI cluster, the following namespaces are available:

- *default* - This namespace is where pods and deployments are created by default when none is provided. In smaller environments, you can deploy applications directly into the default namespace without creating additional logical separations. When you interact with the Kubernetes API, such as with `kubectl get pods`, the default namespace is used when none is specified.
- *kube-system* - This namespace is where core resources exist, such as network features like DNS and proxy, or the Kubernetes dashboard. You typically don't deploy your own applications into this namespace.
- *kube-public* - This namespace is typically not used, but can be used for resources to be visible across the whole cluster, and can be viewed by any user.

For more information, see [Kubernetes namespaces][kubernetes-namespaces].

<!-- EXTERNAL LINKS -->
[kubernetes-pods]: https://kubernetes.io/docs/concepts/workloads/pods/pod-overview/
[kubernetes-pod-lifecycle]: https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/
[kubernetes-deployments]: https://kubernetes.io/docs/concepts/workloads/controllers/deployment/
[kubernetes-statefulsets]: https://kubernetes.io/docs/concepts/workloads/controllers/statefulset/
[kubernetes-daemonset]: https://kubernetes.io/docs/concepts/workloads/controllers/daemonset/
[kubernetes-namespaces]: https://kubernetes.io/docs/concepts/overview/working-with-objects/namespaces/
[node-selectors]: https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/
[taints-tolerations]: https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/
