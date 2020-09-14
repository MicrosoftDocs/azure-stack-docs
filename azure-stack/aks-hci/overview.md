---
title: What is Azure Kubernetes Service on Azure Stack HCI?
description: An overview of Azure Kubernetes Service on Azure Stack HCI
ms.topic: overview
author: jasongerend
ms.author: jgerend
ms.date: 09/21/2020
#Customer intent: As a IT Pro, I want AKS on Azure Stack HCI so that I can easily deploy Kubernetes on-premises to orchestrate my containerized workloads.
---
# What is Azure Kubernetes Service on Azure Stack HCI?

Azure Kubernetes Service on Azure Stack HCI is an on-premises implementation of the popular Azure Kubernetes Service (AKS) orchestrator, which automates running containerized applications at scale. Azure Kubernetes Service is now in preview on Azure Stack HCI,  making it quicker to get started hosting Linux and Windows containers in your datacenter.

To get started with Azure Kubernetes Service on-premises, [register for the preview](https://aka.ms/AKS-HCI-Evaluate) (there's no added cost during preview), then see [Set up Azure Kubernetes Service on Azure Stack HCI](setup.md). To instead use Azure Kubernetes Service to orchestrate your cloud-based containers, see [Azure Kubernetes Service in Azure](/azure/aks/intro-kubernetes).

The following sections discuss some of the reasons to use Azure Kubernetes Service on Azure Stack HCI, then answer some common questions about the service and how to get started.

## Automate management of containerized applications with Kubernetes

While you can manage a few containers manually using Docker and Windows, apps often make use of five, ten, or even hundreds of containers, which is where the Kubernetes orchestrator comes in.

Kubernetes is an open-source orchestrator for automating container management at scale. Azure Kubernetes Service simplifies on-premises Kubernetes deployment by providing wizards for setting up Kubernetes and essential add-ons on Azure Stack HCI, and for creating Kubernetes clusters to host your workloads.

Here's some of the functionality provided by Azure Kubernetes Service while in preview on Azure Stack HCI:

- Deploy containerized apps at scale to a cluster of VMs (called a Kubernetes cluster) running across the Azure Stack HCI cluster
- Fail over when a node in the Kubernetes cluster fails
- Deploy and manage both Linux and Windows-based containerized apps
- Schedule workloads
- Monitor health
- Scale up or down by adding or removing nodes to the Kubernetes cluster
- Manage networking
- Discover services
- Coordinate app upgrades
- Assign pods to cluster nodes with cluster node affinity

For more background on containers, see [Windows and containers](/virtualization/windowscontainers/about/). For more about Kuberentes, see [Kubernetes.io](https://kubernetes.io).

## Simplify setting up Kubernetes

Azure Kubernetes Service simplifies the process of setting up Kubernetes on Azure Stack HCI and includes the following features:

- A Windows Admin Center wizard for setting up Kubernetes and its dependencies (such as kubeadm, kubelet, kubectl, and a Pod network add-on)
- A Windows Admin Center wizard for creating Kubernetes clusters to run your containerized applications
- PowerShell cmdlets for setting up Kubernetes and creating Kubernetes clusters, in case you'd rather script the host setup and Kubernetes cluster creation

## View and manage Kubernetes using on-premises tools or Azure Arc

Once you've set up Azure Kubernetes Service on your Azure Stack HCI cluster and created a Kubernetes cluster, we provide a couple ways to manage and monitor your Kubernetes infrastructure:

- **On-premises using popular tools like Kubectl and Kubernetes Dashboard** - use an open-source web-based interface to deploy applications to a Kubernetes cluster, manage cluster resources, troubleshoot, and view running applications.
- **In the Azure portal using Azure Arc** - use an Azure service to manage Azure Kubernetes Service and Kubernetes clusters deployed across your cloud and on-premises environments. You can use Azure Arc to add and remove Kubernetes clusters as well as nodes to a Kubernetes cluster, change network settings, and install add-ons.
<br>Azure Arc also enables you to use other Azure services to monitor and manage your Kubernetes clusters including:

  - Azure Monitor
  - Azure Policy
  - Role-Based Access Control
  - Azure Security Center

## Run Linux and Windows containers

Azure Kubernetes Service fully supports both Linux-based and Windows-based containers. When you create a Kubernetes cluster on Azure Stack HCI, you can choose whether to create node pools to run Linux containers, Windows containers, or both. Azure Kubernetes Service then creates a 

to create node pools for Linux containers and Windows containers.

Linux virtual machines are automat

, you can choose to deploy Linux virtual machines (nodes) for your containers

the service deploys Linux and Windows virtual machines (nodes) for you based on 

## Where can I run Azure Kubernetes Service?

Azure Kubernetes Service is available on the following platforms:

- In the Azure cloud via [Azure Kubernetes Service in Azure](/azure/aks/intro-kubernetes)
- On-premises via Azure Kubernetes Service on Azure Stack HCI (what this article is all about)
- On-premises in an Azure Stack Hub environment using the [AKS engine on Azure Stack Hub](../user/azure-stack-kubernetes-aks-engine-overview.md).

## How does Azure Kubernetes Service work on Azure Stack HCI?

Azure Kubernetes Service works a little differently when run on Azure Stack HCI  than when using it in the Azure cloud:

- The Kubernetes service in Azure is a hosted service where much of the Kubernetes management infrastructure (control plane) is managed for you. Both the control plane and your containerized applications run in Azure virtual machines.
- With Azure Kubernetes Service on Azure Stack HCI, you set up the service directly on your Azure Stack HCI cluster, putting you in control of the control plane, so to speak. The control plane, your containerized applications, and Azure Kubernetes Service itself all run in virtual machines hosted by your hyperconverged cluster.

Once Azure Kubernetes Service is set up on your Azure Stack HCI cluster, it works similarly to the hosted Azure Kubernetes Service: you use the service to create Kubernetes clusters that run your containerized applications. These Kubernetes clusters are groups of VMs that act as worker nodes, running your application containers. The Kubernetes cluster also contains a control plane, which consists of Kubernetes system services used to orchestrate the application containers.

Here are a couple simplified diagrams showing how the architectures of Azure Kubernetes Service compare when run in Azure and in Azure Stack HCI.

:::image type="content" source="media\overview\aks-azure-architecture.png" alt-text="Architecture of Azure Kubernetes Service hosted in Azure, showing how the platform services and most of the control plane are managed by Azure, while Kubernetes clusters that run your containerized applications are managed by the customer." lightbox="media\overview\aks-azure-architecture.png":::

:::image type="content" source="media\overview\aks-hci-architecture.png" alt-text="Architecture of Azure Kubernetes Service on Azure Stack HCI, showing how everything runs on top of the Azure Stack HCI cluster, including the Azure Kubernetes Service platform, the control plane, and the Kubernetes clusters that run your containerized applications." lightbox="media\overview\aks-hci-architecture.png":::

## What you need to get started

The following sections summarize what you need to run Azure Kubernetes Service on Azure Stack HCI. For complete details, see [Before you install Azure Kubernetes Service on Azure Stack HCI](system-requirements.md).

### On your Windows Admin Center system

Your Windows Admin Center management PC or server has the following requirements:

- 40 GB of free space
- Registered with Azure
- In the same domain as the Azure Stack HCI cluster

### On the Azure Stack HCI cluster that hosts Azure Kubernetes Service

The cluster running Azure Stack HCI, version 20H2 or later has the following requirements:

- A maximum of four servers in the cluster for this preview release
- 1 TB of available capacity in the storage pool for Azure Kubernetes Service
- At least 30 GB of available memory for running Azure Kubernetes Service VMs
- All servers in the cluster must use the EN-US region and language selection for this preview release

For general Azure Stack HCI requirements, see [Before you deploy Azure Stack HCI](../hci/deploy/before-you-start.md).

### The compute network for Azure Stack HCI

The network connected to VMs on the Azure Stack HCI cluster requires a dedicated scope of DHCP IPv4 addresses available for Azure Kubernetes Service and accessible by VMs on the Azure Stack HCI cluster

While not strictly necessary, we also recommend avoiding VLAN tags on your compute network, instead using access (untagged) ports on your network switches for the compute network used by Azure Stack HCI and the Azure Kubernetes Service VMs.

## Next steps

To get started with Azure Kubernetes Service on Azure Stack HCI, see the following articles:

- [Review requirements](system-requirements.md)
- [Set up Azure Kubernetes Service on Azure Stack HCI](create-kubernetes-cluster.md)