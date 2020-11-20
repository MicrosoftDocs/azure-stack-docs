---
title: What is Azure Kubernetes Service on Azure Stack HCI?
description: Azure Kubernetes Service on Azure Stack HCI is an on-premises implementation of Azure Kubernetes Service (AKS), which automates running containerized applications at scale.
ms.topic: overview
author: jasongerend
ms.author: jgerend
ms.date: 09/22/2020
#Customer intent: As an IT Pro, I want AKS on Azure Stack HCI so that I can easily deploy Kubernetes on-premises to orchestrate my containerized workloads.
---
# What is Azure Kubernetes Service on Azure Stack HCI?
> Applies to: AKS on Azure Stack HCI, AKS runtime on Windows Server 2019 Datacenter

Azure Kubernetes Service on Azure Stack HCI is an on-premises implementation of Azure Kubernetes Service (AKS), which automates running containerized applications at scale. Azure Kubernetes Service is now in preview on Azure Stack HCI and Windows Server 2019 Datacenter, making it quicker to get started hosting Linux and Windows containers in your datacenter.

To get started with Azure Kubernetes Service on-premises, [register for the preview](https://aka.ms/AKS-HCI-Evaluate) (there's no added cost during the preview), then see [Set up Azure Kubernetes Service on Azure Stack HCI](setup.md). To instead use Azure Kubernetes Service to orchestrate your cloud-based containers, see [Azure Kubernetes Service in Azure](/azure/aks/intro-kubernetes).

The following sections discuss some of the reasons to use Azure Kubernetes Service on Azure Stack HCI, then answer some common questions about the service and how to get started. For a background on containers, see [Windows and containers](/virtualization/windowscontainers/about/) and for a background on Kubernetes, see [Kubernetes core concepts](kubernetes-concepts.md) or [Kubernetes.io](https://kubernetes.io).

## Use AKS to automate management of containerized applications

While you can manage a few containers manually using Docker and Windows, apps often make use of five, ten, or even hundreds of containers, which is where the Kubernetes orchestrator comes in.

Kubernetes is an open-source orchestrator for automating container management at scale. Azure Kubernetes Service simplifies on-premises Kubernetes deployment by providing wizards for setting up Kubernetes and essential add-ons on Azure Stack HCI, and for creating Kubernetes clusters to host your workloads.

Here's some of the functionality provided by Azure Kubernetes Service while in preview on Azure Stack HCI:

- Deploy containerized apps at scale to Kubernetes clusters running across the Azure Stack HCI cluster
- Deploy and manage both Linux and Windows-based containerized apps
- Deploy AKS on Azure Stack HCI using Windows Admin Center or PowerShell
- Scale up or down by adding or removing nodes to the Kubernetes cluster
- Manage storage and networking on your Kubernetes cluster
- Provide automatic updates for your Kubernetes deployment
- Upgrade to the latest available Kubernetes version
- Use the popular Azure services through Azure Arc for Kubernetes

## Simplify setting up Kubernetes

Azure Kubernetes Service simplifies the process of setting up Kubernetes on Azure Stack HCI and Windows Server 2019 Datacenter, and includes the following features:

- A Windows Admin Center wizard for setting up Kubernetes and its dependencies (such as kubeadm, kubelet, kubectl, and a pod network add-on)
- A Windows Admin Center wizard for creating Kubernetes clusters to run your containerized applications
- PowerShell cmdlets for setting up Kubernetes and creating Kubernetes clusters, in case you'd rather script the host setup and Kubernetes cluster creation

## View and manage Kubernetes using on-premises tools or Azure Arc

Once you've set up Azure Kubernetes Service on-premises and created a Kubernetes cluster, we provide a couple ways to manage and monitor your Kubernetes infrastructure:

- **On-premises using popular tools like Kubectl and Kubernetes dashboard** - Use an open-source, web-based interface to deploy applications to a Kubernetes cluster, manage cluster resources, troubleshoot, and view running applications.
- **In the Azure portal using Azure Arc** - Use Azure Arc to manage applications deployed on top of Kubernetes clusters across your cloud and on-premises environments. 
<br>Azure Arc also enables you to manage your Kubernetes clusters with other Azure services including:

  - Azure Monitor
  - Azure Policy
  - Role-Based Access Control

## Run Linux and Windows containers

Azure Kubernetes Service fully supports both Linux-based and Windows-based containers. When you create a Kubernetes cluster on Azure Stack HCI, you can choose whether to create node pools (groups of identical Kubernetes cluster nodes) to run Linux containers, Windows containers, or both. 

Azure Kubernetes Service creates the Linux and Windows nodes so that you don't have to directly manage the Linux or Windows operating systems.

## Secure your container infrastructure

Azure Kubernetes Service includes a number of features to help secure your container infrastructure:

- **Hypervisor-based isolation for worker nodes** - Each Kubernetes cluster runs on its own dedicated and isolated set of virtual machines so tenants can share the same physical infrastructure.
- **Microsoft-maintained Linux and Windows images for worker nodes** - Worker nodes run Linux and Windows virtual machine images created by Microsoft to adhere to security best practices. Microsoft also refreshes these images monthly with the latest security updates.

Security is an ongoing area of investment for the Azure Kubernetes Service preview release on Azure Stack HCI, so stay tuned.

## Where can I run Azure Kubernetes Service?

Azure Kubernetes Service is available on the following platforms:

- In the Azure cloud via [Azure Kubernetes Service in Azure](/azure/aks/intro-kubernetes)
- On-premises via Azure Kubernetes Service on Azure Stack HCI (what this article is all about)
- On-premises via Azure Kubernetes Service runtime on Windows Server (this article also applies to AKSr on Windows Server)
- On-premises in an Azure Stack Hub environment using the [AKS engine on Azure Stack Hub](../user/azure-stack-kubernetes-aks-engine-overview.md).

## How does Kubernetes work on Azure Stack HCI?

Azure Kubernetes Service works a little differently when run on Azure Stack HCI than when using it in the Azure cloud:

- The Kubernetes service in Azure is a hosted service where much of the Kubernetes management infrastructure (control plane) is managed for you. Both the control plane and your containerized applications run in Azure virtual machines.
- With Azure Kubernetes Service on Azure Stack HCI, you set up the service directly on your Azure Stack HCI cluster, putting you in control of the control plane, so to speak. The control plane, your containerized applications, and Azure Kubernetes Service itself all run in virtual machines hosted by your hyperconverged cluster.

Once Azure Kubernetes Service is set up on your Azure Stack HCI cluster, it works similarly to the hosted Azure Kubernetes Service: you use the service to create Kubernetes clusters that run your containerized applications. These Kubernetes clusters are groups of VMs that act as worker nodes, running your application containers. The Kubernetes cluster also contains a control plane, which consists of Kubernetes system services used to orchestrate the application containers.

Here are a couple simplified diagrams showing how the architectures of Azure Kubernetes Service compare when run in Azure and in Azure Stack HCI.

:::image type="content" source="media\overview\aks-azure-architecture.png" alt-text="Architecture of Azure Kubernetes Service hosted in Azure, showing how the platform services and most of the control plane are managed by Azure, while Kubernetes clusters that run your containerized applications are managed by the customer." lightbox="media\overview\aks-azure-architecture.png":::

:::image type="content" source="media\overview\aks-hci-architecture.png" alt-text="Architecture of Azure Kubernetes Service on Azure Stack HCI, showing how everything runs on top of the Azure Stack HCI cluster, including the Azure Kubernetes Service platform, the control plane, and the Kubernetes clusters that run your containerized applications." lightbox="media\overview\aks-hci-architecture.png":::

## What you need to get started

The following sections summarize what you need to run Azure Kubernetes Service on Azure Stack HCI. For complete details, see [Before you install Azure Kubernetes Service on Azure Stack HCI](system-requirements.md).

### On your Windows Admin Center system

Your machine running the Windows Admin Center gateway has the following requirements:

- A Windows 10 or Windows Server machine (we don't support running Windows Admin Center on the Azure Stack HCI or Windows Server 2019 Datacenter right now)
- 60 GB of free space
- Registered with Azure
- In the same domain as the Azure Stack HCI or Windows Server 2019 Datacenter cluster

### On the Azure Stack HCI cluster or Windows Server 2019 Datacenter failover cluster that hosts Azure Kubernetes Service

The Azure Stack HCI cluster or Windows Server 2019 Datacenter failover cluster has the following requirements:

- A maximum of four servers in the cluster for this preview release
- 1 TB of available capacity in the storage pool for Azure Kubernetes Service
- At least 30 GB of available memory for running Azure Kubernetes Service VMs
- All servers in the cluster must use the EN-US region and language selection for this preview release

For general Azure Stack HCI system requirements, see [Azure Stack HCI system requirements](../hci/concepts/system-requirements.md).

### The network configuration for Azure Stack HCI

The network connected to VMs on the Azure Stack HCI or Windows Server 2019 Datacenter cluster requires a dedicated scope of DHCP IPv4 addresses available for Azure Kubernetes Service and accessible by VMs on the Azure Stack HCI or Windows Server 2019 Datacenter cluster.

## Next steps

To get started with Azure Kubernetes Service on Azure Stack HCI, see the following articles:

- [Review requirements](system-requirements.md)
- [Set up Azure Kubernetes Service on Azure Stack HCI](create-kubernetes-cluster.md)
