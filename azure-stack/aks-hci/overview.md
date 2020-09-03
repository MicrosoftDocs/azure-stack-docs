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

Azure Kubernetes Service on Azure Stack HCI is an orchestrator for running containerized applications on servers or failover clusters running Azure Stack HCI or Windows Server. Orchestrators such as the open-source Kubernetes automate much of the work involved with deploying and managing multiple containers, but can be complex to set up and maintain. Azure Kubernetes Service (AKS) on Azure Stack HCI simplifies setting up Kubernetes, making it quicker to get started hosting Linux and Windows containers on your servers and clusters.

To instead use Kubernetes in Azure, see [Azure Kubernetes Service in Azure](/azure/aks/intro-kubernetes). For a background on containers, see [Windows and containers](/virtualization/windowscontainers/about/).

<!---Required:
The introductory paragraph helps customers quickly determine whether an article is relevant.
Describe in customer-friendly terms what the service is and does, and why the customer should care. Keep it short for the intro.
You can go into more detail later in the article. Many services add artwork or videos below the introduction.
--->

<!---Avoid notes, tips, and important boxes. Readers tend to skip over them. Better to put that info directly into the article text.--->

<!---Screenshots and videos can add another way to show and tell the overview story. But don’t overdo them. Make sure that they offer value for the overview.
If users access your product/service via a web browser, the first screenshot should always include the full browser window in Chrome or Safari. This is to show users that the portal is browser-based - OS and browser agnostic.
--->

## Where can I run Azure Kubernetes Service?

Azure Kubernetes Service is available on the following platforms.

In the cloud

- [Azure Kubernetes Service in Azure](/azure/aks/intro-kubernetes)

On-premises (what this article is all about)

- Azure Kubernetes Service on Azure Stack HCI
- Azure Kubernetes Service Runtime on Windows Server

For users of Azure Stack Hub, there's also the [AKS engine on Azure Stack Hub](../user/azure-stack-kubernetes-aks-engine-overview).

## How does Azure Kubernetes Service work on Azure Stack HCI or Windows Server?

Azure Kubernetes Service works a little differently when run on Azure Stack HCI or Windows Server than when using it in the Azure cloud:

- The Kubernetes Service in Azure is a hosted service where much of the Kubernetes management infrastructure (control plane) is managed for you, and both the control plane and your containerized applications run in Azure virtual machines.
- With Azure Kubernetes Service on Azure Stack HCI, you set up the service directly on your server or cluster, putting you in control of the control plane, so to speak. The control plane, your containerized applications, and Azure Kubernetes Service itself all run in virtual machines hosted by your server or failover cluster.

Once Azure Kubernetes Service is set up on your server or cluster, it works similarly to the hosted Azure Kubernetes Service: you use the service to create Kubernetes clusters that run your containerized applications. These Kubernetes clusters are groups of VMs that act as worker nodes, running your application containers. The Kubernetes cluster also contains a control plane, which consists of Kubernetes system services used to orchestrate the application containers.

Here are a couple diagrams showing how the architectures compare.

:::image type="content" source="media\overview\aks-azure-architecture.png" alt-text="Architecture of Azure Kubernetes Service hosted in Azure, showing how the platform services and most of the control plane are managed by Azure, while Kubernetes clusters to run your containerized applications are managed by the customer." lightbox="image-file-expanded.png":::

:::image type="content" source="media\overview\aks-hci-architecture.png" alt-text="Architecture of Azure Kubernetes Service on Azure Stack HCI, showing how everything runs on top of your server or failover cluster. This includes the Azure Kubernetes Service platform, the control plane, and the Kubernetes clusters that run your containerized applications." lightbox="image-file-expanded.png":::

- Managed by Windows Admin Center vs. Azure portal
- Windows containers and Linux containers
- 


## Set up a Kubernetes host

## Create Kubernetes clusters

## What you need to get started


## 
What is it?
Why should I care?
How can I get started?

## Feature summary

## Azure Arc integration

## AKS in the cloud and on-premises



## Top task

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