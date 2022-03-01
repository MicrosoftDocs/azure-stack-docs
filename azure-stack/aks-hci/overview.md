---
title: What is Azure Kubernetes Service on Azure Stack HCI?
description: Azure Kubernetes Service on Azure Stack HCI is an on-premises implementation of Azure Kubernetes Service (AKS), which automates running containerized applications at scale.
ms.topic: overview
author: mattbriggs
ms.author: mabrigg 
ms.lastreviewed: 1/14/2022
ms.reviewer: abha
ms.date: 06/24/2021
#Customer intent: As an IT Pro, I want AKS on Azure Stack HCI so that I can easily deploy Kubernetes on-premises to orchestrate my containerized workloads.

#Intent: As a system operator, I want to learn about AKS on HCI so that I can offer a managed Kubernetes cluster to my on-premises system users.
#Keyword: on-premises Kubernetes
---
# What is Azure Kubernetes Service on Azure Stack HCI?

> Applies to: Azure Stack HCI, versions 21H2 and 20H2; Windows Server 2022 Datacenter, Windows Server 2019 Datacenter

Azure Kubernetes Service on Azure Stack HCI is an on-premises implementation of Azure Kubernetes Service (AKS), which automates running containerized applications at scale. Azure Kubernetes Service is available on Azure Stack HCI, Windows Server 2019 Datacenter, and Windows Server 2022 Datacenter, making it quicker to get started hosting Linux and Windows containers in your datacenter.

To get started with Azure Kubernetes Service on-premises, on Windows Server 2019/2022 or Azure Stack HCI, [set up Azure Kubernetes Service on Azure Stack HCI](setup.md). 

To instead use Azure Kubernetes Service to orchestrate your cloud-based containers, see [Azure Kubernetes Service in Azure](/azure/aks/intro-kubernetes).  If you are using Azure Stack Hub, see [AKS engine on Azure Stack Hub](../user/azure-stack-kubernetes-aks-engine-overview.md).

The following sections discuss some of the reasons to use Azure Kubernetes Service on Azure Stack HCI, then answer some common questions about the service and how to get started. For a background on containers, see [Windows and containers](/virtualization/windowscontainers/about/).  For a background on how Kubernetes works in Azure Kubernetes Service on Azure Stack HCI, see [Kubernetes core concepts](kubernetes-concepts.md) and for a background on Kubernetes, see [Kubernetes.io](https://kubernetes.io).

## Why use Azure Kubernetes Service on Azure Stack HCI for containerized applications?

While you can manage a few containers manually using Docker and Windows, apps often make use of five, ten, or even hundreds of containers, which is where the Kubernetes orchestrator comes in.

Kubernetes is an open-source orchestrator for automating container management at scale. Azure Kubernetes Service simplifies on-premises Kubernetes deployment by providing wizards for setting up Kubernetes and essential add-ons on Azure Stack HCI, and for creating Kubernetes clusters to host your workloads.

Here's some of the functionality provided by Azure Kubernetes Service on Azure Stack HCI:

- Deploy containerized apps at scale to Kubernetes clusters running across the Azure Stack HCI cluster
- Deploy and manage both Linux and Windows-based containerized apps
- Scale up or down by adding or removing nodes to the Kubernetes cluster
- Manage storage and networking on your Kubernetes cluster
- Provide automatic updates for your Kubernetes deployment
- Keep up-to-date with the latest available Kubernetes versions
- Use the popular Azure services through Azure Arc for Kubernetes

## Simplify setting up Kubernetes

Azure Kubernetes Service simplifies the process of setting up Kubernetes on Azure Stack HCI and Windows Server 2019/2022 Datacenter, and includes the following features:

- A Windows Admin Center wizard for setting up Azure Kubernetes Service and its dependencies 
- A Windows Admin Center wizard for creating Kubernetes clusters to run your containerized applications
- PowerShell cmdlets for setting up Kubernetes and creating Kubernetes clusters, in case you'd rather script the host setup and Kubernetes cluster creation

View the GIF below to familiarize yourself with the deployment process:

![GIF for deploying AKS HCI](media/aks-hci-deployment.gif)

## View and manage Kubernetes using on-premises tools or Azure Arc

Once you've set up Azure Kubernetes Service on-premises and created a Kubernetes cluster, we provide a couple ways to manage and monitor your Kubernetes infrastructure:

- **In the Azure portal using Azure Arc** - Use Azure Arc to manage applications deployed on top of Kubernetes clusters across your cloud and on-premises environments. 
  <br>Azure Arc also enables you to manage your Kubernetes clusters with other Azure services including:
  - Azure Monitor
  - Azure Policy
  - Role-Based Access Control
- **On-premises using popular tools like Kubectl** - There are many open-source tools that allow you to deploy applications to a Kubernetes cluster, manage cluster resources, troubleshoot, and view running applications. All of these tools work with Kubernetes clusters deployed with Azure Kubernetes Service on Azure Stack HCI.

## Run Linux and Windows containers

Azure Kubernetes Service fully supports both Linux-based and Windows-based containers. When you create a Kubernetes cluster on Azure Stack HCI, you can choose whether to create node pools (groups of identical Kubernetes cluster nodes) to run Linux containers, Windows containers, or both. 

Azure Kubernetes Service creates the Linux and Windows nodes so that you don't have to directly manage the Linux or Windows operating systems.

## Secure your container infrastructure

Azure Kubernetes Service includes a number of features to help secure your container infrastructure:

- **Hypervisor-based isolation for worker nodes** - Each Kubernetes cluster runs on its own dedicated and isolated set of virtual machines so tenants can share the same physical infrastructure.
- **Microsoft-maintained Linux and Windows images for worker nodes** - Worker nodes run Linux and Windows virtual machine images created by Microsoft to adhere to security best practices. Microsoft also refreshes these images monthly with the latest security updates.

## What you need to get started

The following sections summarize what you need to run Azure Kubernetes Service on Azure Stack HCI. For complete details on what you need before you install AKS on Azure Stack HCI, see [system requirements](system-requirements.md).

### On your Windows Admin Center system

Your machine running the Windows Admin Center gateway must be:  

 - Registered with Azure
 - In the same domain as the Azure Stack HCI or Windows Server 2019/2022 Datacenter cluster

### On the Azure Stack HCI cluster or Windows Server 2019/2022 Datacenter failover cluster that hosts Azure Kubernetes Service

The Azure Stack HCI cluster or Windows Server 2019/2022 Datacenter failover cluster has the following requirements:

- A maximum of eight servers in the cluster
- 1 TB of available capacity in the storage pool for Azure Kubernetes Service
- At least 30 GB of available memory for running Azure Kubernetes Service VMs
- All servers in the cluster must use the EN-US region and language selection

For general Azure Stack HCI system requirements, see [Azure Stack HCI system requirements](../hci/concepts/system-requirements.md).

### The network configuration for Azure Stack HCI

The network connected to VMs on the Azure Stack HCI or Windows Server 2019/2022 Datacenter cluster requires a dedicated scope of IPv4 addresses available for Azure Kubernetes Service and accessible by VMs on the Azure Stack HCI or Windows Server 2019/2022 Datacenter cluster. For more information on networking requirements, see [AKS on Azure Stack HCI system requirements](system-requirements.md).

## Next steps

To get started with Azure Kubernetes Service on Azure Stack HCI, see the following articles:

- [Review requirements](./system-requirements.md)
- [Set up Azure Kubernetes Service on Azure Stack HCI using Windows Admin Center](./create-kubernetes-cluster.md)
- [Set up an Azure Kubernetes Service host on Azure Stack HCI and deploy a workload cluster using PowerShell](./kubernetes-walkthrough-powershell.md)

