---
title: AKS Arc and workload cluster architecture (preview)
description: Learn about AKS Arc and workload cluster architecture.
ms.topic: overview
ms.date: 12/11/2023
author: sethmanheim
ms.author: sethm 
ms.reviewer: rbaziwane
ms.lastreviewed: 11/28/2023

---

# AKS Arc and workload cluster architecture (preview)

> Applies to: AKS on Azure Stack HCI

Azure Kubernetes Service (AKS) on Azure Stack HCI is an enterprise-grade Kubernetes container platform. It includes Microsoft-supported core Kubernetes, a purpose-built Windows container host, and a Microsoft-supported Linux container host, with a goal to have a simple deployment and lifecycle management experience.

This article introduces the core Kubernetes infrastructure components, such as the control plane, nodes, and nodepools. Workload resources such as pods, deployments, and sets are also introduced, along with how to group resources into namespaces.

## Cluster architecture

An Azure Kubernetes Service cluster has the following components:

- **Arc Resource Bridge** (also known as **Arc appliance**) provides the core orchestration mechanism and interface for deploying and managing one or more workload clusters.
- **Workload clusters** (also known as **target clusters**) are where containerized applications are deployed.

:::image type="content" source="media/cluster-architecture/cluster-architecture.png" alt-text="Diagram showing cluster architecture." lightbox="media/cluster-architecture/cluster-architecture.png":::

AKS Arc uses a set of predefined configurations to deploy Kubernetes clusters effectively and with scalability in mind. A deployment operation creates multiple Linux or Windows virtual machines and joins them together to create one or more Kubernetes clusters.

> [!NOTE]
> To help improve the reliability of the system, if you run multiple Cluster Shared Volumes (CSVs) in your cluster, by default virtual machine data is automatically spread out across all available CSVs in the cluster. This ensures that applications survive in the event of CSV outages.

### Arc Resource Bridge

The Arc Resource Bridge connects a private cloud (for example, Azure Stack HCI, VMWare/vSphere, or SCVMM) to Azure and enables on-premises resource management from Azure. Azure Arc Resource Bridge provides the line of sight to private clouds required to manage resources such as Kubernetes clusters on-premises through Azure. Arc Resource Bridge includes the following core AKS Arc components:

- **AKS Arc cluster extensions**: A cluster extension is the on-premises equivalent of an Azure Resource Manager resource provider. Just as the **Microsoft.ContainerService** resource provider manages AKS clusters in Azure, the AKS Arc cluster extension, once added to your Arc Resource Bridge, helps manage Kubernetes clusters via Azure.
- **Custom location**: A custom location is the on-premises equivalent of an Azure region and is an extension of the Azure location construct. Custom locations provide a way for tenant administrators to use their data center with the right extensions installed, as target locations for deploying Azure service instances.

### Workload clusters

The workload cluster is a highly available deployment of Kubernetes using Linux VMs for running Kubernetes control plane components and Linux worker nodes. Windows Server Core-based VMs are used for establishing Windows worker nodes. There can be one or more workload clusters managed by one management cluster.

A workload cluster has many components, as described in the following sections.

#### Control plane

- **API server**: The API server enables interaction with the Kubernetes API. This component provides the interaction for management tools, such as Windows Admin Center, PowerShell modules, or kubectl.
- **Etcd**: Etcd is a distributed key-value store that stores data required for lifecycle management of the cluster. It stores the control plane state.

#### Load balancer

The load balancer is a virtual machine running Linux and HAProxy and KeepAlive to provide load balanced services for the workload clusters deployed by the management cluster. For each workload cluster, AKS Arc adds at least one load balancer virtual machine. Any Kubernetes service of type LoadBalancer that is created on the workload cluster creates a load-balancing rule in the VM.

#### Worker nodes

To run your applications and supporting services, you need a **Kubernetes node**. An AKS workload cluster has one or more *worker nodes*. Worker
nodes act as virtual machines (VMs) that run the Kubernetes node components and host the pods and services that make up the application workload.

There are core Kubernetes workload components that you can deploy on AKS workload clusters, such as pods and deployments.

## Lifecycle management

Azure Arc is automatically enabled on all your Kubernetes clusters created using AKS Arc. You can use your Microsoft Entra identity for connecting to your clusters from anywhere. Azure Arc enables you to use familiar tools like the Azure portal, Azure CLI, and Azure Resource Manager templates to create and manage your Kubernetes clusters.

## Mixed-OS deployments

If a given workload cluster consists of both Linux and Windows worker nodes, it must be scheduled onto an OS that can support provisioning the workload. Kubernetes offers two mechanisms to ensure that workloads land on nodes with a target operating system:

- **Node Selector** is a simple field in the pod spec that constrains pods to only be scheduled onto healthy nodes matching the operating system.
- **Taints and tolerations** work together to ensure that pods are not scheduled onto nodes unintentionally. A node can be "tainted" so as to not accept pods that do not explicitly tolerate its taint through a "toleration" in the pod spec.

For more information, see [node selectors](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/) and [taints and tolerations](https://kubernetes.io/docs/concepts/scheduling-eviction/taint-and-toleration/).

## Next steps

- [What's new in AKS on Azure Stack HCI](aks-preview-overview.md)
- [Create and manage Kubernetes clusters on-premises using Azure CLI](aks-create-clusters-cli.md)
