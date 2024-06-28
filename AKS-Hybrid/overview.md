---
title: Overview of AKS on Windows Server and Azure Stack HCI, version 22H2
description: Learn about AKS enabled by Azure Arc on Windows Server and Azure Stack HCI.
ms.topic: overview
ms.custom: linux-related-content
author: sethmanheim
ms.author: sethm 
ms.date: 01/29/2024

# Intent: As an IT Pro, I want to use AKS on Azure Stack HCI and Windows Server to deploy on-premises Kubernetes and orchestrate containerized workloads.
# Keyword: on-premises Kubernetes
---

# Overview of AKS on Windows Server and Azure Stack HCI, version 22H2

[!INCLUDE [aks-hybrid-applies-to-azure-stack-hci-windows-server-sku](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server is an on-premises Kubernetes implementation of AKS. AKS on Azure Stack HCI and Windows Server automates running containerized applications at scale. AKS makes it quicker to get started hosting Linux and Windows containers in your datacenter.

To get started with on-premises Kubernetes using AKS, [set up AKS on Azure Stack HCI and Windows Server](setup.md).

Or, you can use AKS to orchestrate your cloud-based containers. See [Azure Kubernetes Service in Azure](/azure/aks/intro-kubernetes).  If you're using Azure Stack Hub, see [AKS engine on Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-overview).

The following sections discuss some of the reasons to use AKS on Azure Stack HCI and Windows Server, then answer some common questions about the service and how to get started. For a background on containers, see [Windows and containers](/virtualization/windowscontainers/about/).  For a background on how Kubernetes works in AKS on Azure Stack HCI and Windows Server, see [Kubernetes core concepts](kubernetes-concepts.md) and for a background on Kubernetes, see [Kubernetes.io](https://kubernetes.io).

## Why use AKS on Windows Server and Azure Stack HCI for containerized applications?

While you can manage a few containers manually using Docker and Windows, apps often make use of five, ten, or even hundreds of containers, which are where the Kubernetes orchestrator comes in.

Kubernetes is an open-source orchestrator for automating container management at scale. AKS simplifies on-premises Kubernetes deployment by providing wizards you can use to set up Kubernetes and essential Azure Stack HCI add-ons, and also create Kubernetes clusters to host your workloads.

Here's some of the functionality AKS provides on Windows Server and Azure Stack HCI:

- Deploy containerized apps at scale to Kubernetes clusters running across the Azure Stack HCI and Windows Server cluster.
- Deploy and manage both Linux and Windows-based containerized apps.
- Scale up or down by adding or removing nodes to the Kubernetes cluster.
- Manage storage and networking on your Kubernetes cluster.
- Provide regular Kubernetes updates and security fixes for your Kubernetes deployment.
- Keep up-to-date with the latest available Kubernetes versions.
- Use the popular Azure services through Azure Arc for Kubernetes.

## Simplify setting up on-premises Kubernetes

AKS simplifies the process of setting up Kubernetes on Azure Stack HCI and Windows Server 2019/2022 Datacenter, and includes the following features:

- A Windows Admin Center wizard for setting up AKS and its dependencies.
- A Windows Admin Center wizard for creating Kubernetes clusters to run your containerized applications.
- PowerShell cmdlets for setting up Kubernetes and creating Kubernetes clusters, in case you'd rather script the host setup and Kubernetes cluster creation.

View the GIF below to familiarize yourself with the deployment process:

:::image type="content" source="media/overview/aks-hci-deployment.gif" alt-text="GIF showing AKS deployment." lightbox="media/overview/aks-hci-deployment.gif":::

## View and manage on-premises Kubernetes using tools or Azure Arc

Once you've set up on-premises Kubernetes using AKS and created a Kubernetes cluster, you can manage and monitor your Kubernetes infrastructure with:

- **In the Azure portal using Azure Arc** - Use Azure Arc to manage applications deployed on top of Kubernetes clusters across your cloud and on-premises environments.  
  Azure Arc also enables you to manage your Kubernetes clusters with other Azure services including:
  - Azure Monitor
  - Azure Policy
- **On-premises using popular tools like Kubectl** - There are many open-source tools that allow you to deploy applications to a Kubernetes cluster, manage cluster resources, troubleshoot, and view running applications. All of these tools work with Kubernetes clusters deployed with AKS on Azure Stack HCI and Windows Server.

## Run Linux and Windows containers

AKS fully supports both Linux-based and Windows-based containers. When you create a Kubernetes cluster on Windows Server or Azure Stack HCI, you can choose whether to create node pools (groups of identical Kubernetes cluster nodes) to run Linux containers, Windows containers, or both. 

AKS creates the Linux and Windows nodes so that you don't have to directly manage the Linux or Windows operating systems.

## Secure your container infrastructure

AKS includes many features to help secure your container infrastructure:

- **Hypervisor-based isolation for worker nodes** - Each Kubernetes cluster runs on its own dedicated and isolated set of virtual machines so tenants can share the same physical infrastructure.
- **Microsoft-maintained Linux and Windows images for worker nodes** - Worker nodes run Linux and Windows virtual machine images created by Microsoft to adhere to security best practices. Microsoft also refreshes these images monthly with the latest security updates.

## What you need to get started

The following sections summarize what you need to run on-premises Kubernetes with AKS on Azure Stack HCI and Windows Server. For complete details on what you need before you install AKS on Azure Stack HCI and Windows Server, see [system requirements](system-requirements.md).

### On your Windows Admin Center system

Your machine running the Windows Admin Center gateway must be:  

- Registered with Azure
- In the same domain as the Azure Stack HCI or Windows Server 2019/2022 Datacenter cluster

### On the Azure Stack HCI and Windows Server cluster or Windows Server 2019/2022 Datacenter failover cluster that hosts AKS

The Azure Stack HCI and Windows Server cluster or Windows Server 2019/2022 Datacenter failover cluster has the following requirements:

- A maximum of eight servers in the cluster
- 1 TB of available capacity in the storage pool for AKS
- At least 30 GB of available memory for running AKS VMs
- All servers in the cluster must use the EN-US region and language selection

For general Azure Stack HCI system requirements, see [Azure Stack HCI system requirements](/azure-stack/hci/concepts/system-requirements).

### The network configuration for Azure Stack HCI

The network connected to VMs on the Azure Stack HCI or Windows Server 2019/2022 Datacenter cluster requires a dedicated scope of IPv4 addresses available for AKS and accessible by VMs on the Azure Stack HCI or Windows Server 2019/2022 Datacenter cluster. For more information on networking requirements, see [AKS on Azure Stack HCI and Windows Server system requirements](system-requirements.md).

Here's some of the functionality AKS provides:

## Native integration using Azure Arc

With AKS, you can connect your Kubernetes clusters to Azure. Once connected to Azure Arc-enabled Kubernetes, you can access your Kubernetes clusters running on-premises via the Azure portal and deploy management services such as GitOps and Azure Policy. You can also deploy data services such as SQL Managed Instance and PostgreSQL Hyperscale. For more information about Azure Arc-enabled Kubernetes, see the [Azure Arc overview](/azure/azure-arc/kubernetes/overview).

## Integrated logging and monitoring

Once you've connected your cluster to Azure Arc, you can use Azure Monitor for monitoring the health of your Kubernetes cluster and applications. Azure Monitor for containers gives you performance visibility by collecting memory and processor metrics from controllers, nodes, and containers. Metrics and container logs are automatically collected for you and are sent to the metrics database in Azure Monitor, while log data is sent to your Log Analytics workspace. For more information about Azure Monitor, see the [container insights overview](/azure/azure-monitor/containers/container-insights-overview).

## Software defined networking for your Kubernetes nodes and containerized applications

With SDN integration on Azure Stack HCI, you can now bring in your own networks and attach the Kubernetes nodes to these networks. Additionally, you can use the SDN Software Load Balancer to provide load balancer services for their containerized applications. For more information, see [software defined networking with AKS](software-defined-networking.md).

## Automatically resize your Kubernetes node pools

To keep up with application demands, you might need to adjust the number and size of nodes that run your workloads. The cluster autoscaler component can watch for pods in your cluster that can't be scheduled because of resource constraints. When issues are detected, the number of nodes in a node pool is increased to meet the application demand. Nodes are also regularly checked for a lack of running pods, with the number of nodes then decreased as needed. This ability to automatically scale up or down the number of nodes in your Kubernetes cluster lets you run an efficient, cost-effective environment.

## Deploy and manage Windows-based containerized apps

AKS fully supports running both Linux-based and Windows-based containers. When you create a Kubernetes cluster on Windows Server or Azure Stack HCI, you can choose whether to create node pools (groups of identical Kubernetes cluster nodes) to run Linux containers, Windows containers, or both. AKS creates the Linux and Windows nodes so that you don't have to directly manage the Linux or Windows operating systems.

## AKS supports deploying GPU-enabled nodes

AKS supports deploying GPU-enabled node pools on top of NVIDIA Tesla T4 GPUs using Discrete Device Assignment (DDA) mode, also known as *GPU Passthrough*. In this mode, one or more physical GPUs are dedicated to a single worker node with a GPU enabled VM size which gets full access to the entire GPU hence offering high level application compatibility as well as better performance. For more information about GPU-enabled node pools, see the [GPU documentation](deploy-gpu-node-pool.md).

## Next steps

To get started with AKS on Azure Stack HCI and Windows Server, see the following articles:

- [Review requirements](./system-requirements.md)
- [Set upAKS on Azure Stack HCI and Windows Server using Windows Admin Center](./create-kubernetes-cluster.md)
- [Set up an Azure Kubernetes Service host on Azure Stack HCI and deploy a workload cluster using PowerShell](./kubernetes-walkthrough-powershell.md)
