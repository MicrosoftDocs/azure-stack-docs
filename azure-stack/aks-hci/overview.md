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

Azure Kubernetes Service on Azure Stack HCI is a Kubernetes-based orchestrator that automates running containerized applications on servers or failover clusters that use Azure Stack HCI . Orchestrators such as the open-source Kubernetes automate much of the work involved with deploying and managing multiple containers, but can be complex to set up and maintain. Azure Kubernetes Service (AKS) on Azure Stack HCI simplifies setting up Kubernetes, making it quicker to get started hosting Linux and Windows containers on your servers and clusters.

Azure Kubernetes Service on Azure Stack HCI is in preview, and has no added cost during preview. To get started, see [Set up Azure Kubernetes Service on Azure Stack HCI](setup.md). To instead use a hosted Kubernetes service in Azure, see [Azure Kubernetes Service in Azure](/azure/aks/intro-kubernetes).

## Automate management of containerized applications with Kubernetes

Containers are a technology for packaging and running Windows and Linux applications across diverse environments on-premises and in the cloud. Containers provide a lightweight, isolated environment that makes apps easier to develop, deploy, and manage. Containers start and stop quickly, making them ideal for apps that need to rapidly adapt to changing demand. The lightweight nature of containers also make them a useful tool for increasing the density and utilization of your infrastructure.

While you can manage a few containers manually using Docker and Windows, apps often make use of five, ten, or even hundreds of containers, which is where the open-source Kubernetes orchestrator comes in.

Kubernetes is a powerful orchestrator-a software package for automating container deployment and management at scale-but this power comes with complexity. Azure Kubernetes Service simplifies much of this complexity when using Kubernetes on a server or cluster, provides the following functionality while the service is in preview:

- Deploy containerized apps at scale to multiple VMs (called nodes) potentially running on multiple servers in a failover cluster
- Fail over when a node in the Kubernetes cluster fails
- Deploy and managing both Linux and Windows-based containerized apps
- Schedule workloads
- Monitor health
- Scale up or down by adding or removing nodes
- Manage networking
- Discover services
- Coordinate app upgrades
- Assign pods to cluster nodes with cluster node affinity

For a little more background on containers, see [Windows and containers](/virtualization/windowscontainers/about/).

## Simplify setting up Kubernetes

Kubernetes is an open-source project that's freely available on a number of platforms, but setting it up can be complicated (for project documentation, see [Kubernetes: Creating a cluster with kubeadm](https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/create-cluster-kubeadm/), then [Kuberentes: Adding Windows nodes](https://kubernetes.io/docs/tasks/administer-cluster/kubeadm/adding-windows-nodes/)).

Azure Kubernetes Service on Azure Stack HCI was designed to simplify this process of setting up Kubernetes, and includes the following:

- A graphical wizard to set up Azure Kubernetes Service in Windows Admin Center, which streamlines setting up Kubernetes
- A graphical wizard to create a Kubernetes cluster in Windows Admin Center, which streamlines creating a Kubernetes cluster that runs your containerized applications
- PowerShell cmdlets for setting up Azure Kubernetes Service and creating Kubernetes clusters, in case you'd rather script setup and Kubernetes cluster creation

## View and manage Kubernetes using on-premises tools or Azure Arc

Once you've set up Azure Kubernetes Service on your server or failover cluster and created a Kubernetes cluster, we provide a couple ways to manage and monitor your Kubernetes infrastructure:

- **On-premises using the Kubernetes Dashboard** - use an open-source web-based interface to deploy applications to a Kubernetes cluster, manage cluster resources, troubleshoot, and view running applications.
- **In the Azure portal using Azure Arc** - use an Azure service to manage Azure Kubernetes Service and Kubernetes clusters deployed across your cloud and on-premises environments. You can use Azure Arc to add and remove Kubernetes clusters as well as nodes to a Kubernetes cluster, change network settings, and install addons.
<br>Azure Arc also enables you to use other Azure services to monitor and manage your Kubernetes clusters including:

   - Azure Monitor
   - Azure Policy
   - Role-Based Access Control
   - Azure Security Center

## Where can I run Azure Kubernetes Service?

Azure Kubernetes Service is available on the following platforms.

- In the Azure cloud via [Azure Kubernetes Service in Azure](/azure/aks/intro-kubernetes)
- On-premises via Azure Kubernetes Service on Azure Stack HCI (what this article is all about)
- On-premises in an Azure Stack Hub environment using the [AKS engine on Azure Stack Hub](../user/azure-stack-kubernetes-aks-engine-overview).

## How does Azure Kubernetes Service work on Azure Stack HCI?

Azure Kubernetes Service works a little differently when run on Azure Stack HCI  than when using it in the Azure cloud:

- The Kubernetes Service in Azure is a hosted service where much of the Kubernetes management infrastructure (control plane) is managed for you, and both the control plane and your containerized applications run in Azure virtual machines.
- With Azure Kubernetes Service on Azure Stack HCI, you set up the service directly on your Azure Stack HCI cluster, putting you in control of the control plane, so to speak. The control plane, your containerized applications, and Azure Kubernetes Service itself all run in virtual machines hosted by your hyperconverged cluster.

Once Azure Kubernetes Service is set up on your Azure Stack HCI cluster, it works similarly to the hosted Azure Kubernetes Service: you use the service to create Kubernetes clusters that run your containerized applications. These Kubernetes clusters are groups of VMs that act as worker nodes, running your application containers. The Kubernetes cluster also contains a control plane, which consists of Kubernetes system services used to orchestrate the application containers.

Here are a couple diagrams showing how the architectures of Azure Kubernetes Service compare when run in Azure and in Azure Stack HCI.

:::image type="content" source="media\overview\aks-azure-architecture.png" alt-text="Architecture of Azure Kubernetes Service hosted in Azure, showing how the platform services and most of the control plane are managed by Azure, while Kubernetes clusters to run your containerized applications are managed by the customer." lightbox="image-file-expanded.png":::

:::image type="content" source="media\overview\aks-hci-architecture.png" alt-text="Architecture of Azure Kubernetes Service on Azure Stack HCI, showing how everything runs on top of your server or failover cluster. This includes the Azure Kubernetes Service platform, the control plane, and the Kubernetes clusters that run your containerized applications." lightbox="image-file-expanded.png":::

## What you need to get started

Here's a summary of what you need to run Azure Kubernetes Service on Azure Stack HCI:

- A cluster running Azure Stack HCI, version 20H2, with 

### Set up a Kubernetes host

### Create Kubernetes clusters




## 
What is it?
Why should I care?
How can I get started?


## Next steps

Review requirements
Set up Azure Kubernetes Service on Azure Stack HCI

## <article body>

<!---
After the intro, you can develop your overview by discussing the features that answer the "Why should I care" question with a bit more depth.
Be sure to call out any basic requirements and dependencies, as well as limitations or overhead.
Don't catalog every feature, and some may only need to be mentioned as available, without any discussion.
--->

## <Top task>

<!---Suggested:
An effective way to structure you overview article is to create an H2 for the top customer tasks identified in milestone one of the [Content + Learning content model](contribute-get-started-mvc.md) and describe how the product/service helps customers with that task.
Create a new H2 for each task you list.
--->

## Next steps

<!---Some context for the following links goes here--->
- [link to next logical step for the customer](global-quickstart-template.md)

<!--- Required:
In Overview articles, provide at least one next step and no more than three.
Next steps in overview articles will often link to a quickstart.
Use regular links; do not use a blue box link. What you link to will depend on what is really a next step for the customer.
Do not use a "More info section" or a "Resources section" or a "See also section".
--->