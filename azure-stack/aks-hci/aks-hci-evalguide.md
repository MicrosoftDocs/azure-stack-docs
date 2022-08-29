---
title: AKS on Azure Stack HCI and Windows Server in Azure VM Evaluation Guide 
description: An overview of what's necessary to deploy AKS on Azure Stack HCI in an Azure VM
author: sethmanheim
ms.topic: conceptual
ms.date: 08/29/2022
ms.author: sethm 
ms.lastreviewed: 08/29/2022
ms.reviewer: oadeniji
# Intent: As an IT Pro, I need to learn how to deploy AKS on Azure Stack HCI in an Azure VM
# Keyword: Azure VM deployment
---

# AKS on Azure Stack HCI and Windows Server evaluation guide

This guide demonstrates the basics of how to deploy the [Azure Kubernetes Service (AKS) on Azure Stack HCI in an Azure VM](./overview.md).  

You'll learn how to:

* Deploy and configure a Windows Server 2019 or 2022 Azure VM to host the infrastructure.
* Use Windows Admin Center or PowerShell to deploy the AKS on Azure Stack HCI management cluster.
* Deploy the AKS on Azure Stack HCI target/workload clusters with Windows Admin Center or PowerShell.
* Integrate with Azure Arc.
* Deploy a simple test application and expose the app externally.

## Version

This guide has been tested and validated with the **July 2022 release** of AKS on Azure Stack HCI and Windows Server.

> [!NOTE]
> The user interface is subject to updates and changes, so some of the screen shots in this guide may differ from what you actually see.

## What is AKS on Azure Stack HCI?

Azure Kubernetes Service (AKS) on Azure Stack HCI and Windows Server is an on-premises implementation of AKS that automates running containerized applications at scale. AKS is now available on Azure Stack HCI 21H2 and Windows Server 2019/2022-based clusters, making it easier to get started hosting Linux and Windows containers in your datacenter.

To learn more about AKS on Azure Stack HCI and Windows Server, make sure you [review the official documentation](overview.md) before completing your evaluation. This guide also provides references to available documents that can help build your knowledge of AKS on Azure Stack HCI.

## Who should read this guide?

This evaluation guide demonstrates how to create a sand-boxed, isolated AKS on Azure Stack HCI environment by using [*nested virtualization*](../hci/concepts/nested-virtualization.md). This guide provides a solid foundation that will allow you to explore additional AKS on Azure Stack HCI scenarios in the future.

## Evaluate AKS on Azure Stack HCI using nested virtualization

Keep in mind that server-class hardware is required in order to test, validate, and evaluate this technology. If you have multiple server-class pieces of spare hardware (ideally hardware validated for Azure Stack HCI [Azure Stack HCI Catalog](https://aka.ms/azurestackhcicatalog "Azure Stack HCI Catalog")), you can perform a more real-world evaluation of AKS on Azure Stack HCI. If you don't have spare hardware, consider using [nested virtualization](../hci/concepts/nested-virtualization.md) as an alternative for evaluation.

At a high level, nested virtualization allows a virtualization platform (i.e., Hyper-V, or VMware ESXi) to run virtual machines that run a virtualization platform. The following image shows this architectural view:

:::image type="content" source="media/aks-hci-evalguide/nested-virt.png" alt-text="Nested virtualization architecture diagram":::

The outer box represents the Azure Resource Group, which will contain all of the artifacts deployed in Azure, including the virtual machine itself, and accompanying network adapter, storage and so on. You'll deploy an Azure VM running Windows Server 2019 or 2022 Datacenter. Once deployed, you'll perform some host configuration, and then begin to deploy the other key components. First, on the left hand side, you'll deploy the management cluster. This provides the core orchestration mechanism and interface for deploying and managing one or more target clusters, which are shown on the right-hand side of the diagram. These target, or workload clusters contain worker nodes and are where application workloads run. These workloads are managed by a management cluster. To learn more about the building blocks of the Kubernetes infrastructure, [read more here](kubernetes-concepts.md).

The bottom (or base) layer represents the physical hardware on which you install a *hypervisor*. In this example, we're using Windows Server with the Hyper-V role enabled. The hypervisor on the lowest level is considered the L0 (level 0) hypervisor. Azure does not allow access or control over this.

On the physical host, you create a virtual machine, which then allows you to deploy an OS that has a hypervisor enabled.  

The first virtualized layer is running a nested operating system with Hyper-V enabled (i.e., Windows Server 2019 or 2022). This would be a L1 (or level 1) hypervisor. Inside that OS, you could create a virtual machine to run a workload.  This could also contain a hypervisor, which would be known as the L2 (or level 2) hypervisor, and so on, with multiple levels of nested virtualization possible.

> [!IMPORTANT]
> The use of nested virtualization in this evaluation guide is aimed at providing flexibility for evaluating AKS on Azure Stack HCI in test environment, and shouldn't be seen as a substitute for real-world deployments, performance, and scale testing. Keep in mind that each level of nesting impacts overall performance. Therefore, for production use, AKS on Azure Stack HCI should be deployed on validated physical hardware. For more information, see the [Azure Stack HCI 21H2 catalog](https://aka.ms/azurestackhcicatalog) or the [Windows Server catalog](https://www.windowsservercatalog.com/results.aspx?bCatID=1283&cpID=0&avc=126&ava=0&avq=0&OR=1&PGS=25) for systems running Windows Server Datacenter edition.

## Deployment overview

This guide assumes you do not have multiple server-class pieces of hardware running Azure Stack HCI 21H2 or Windows Server 2019/2022; instead it describes how to deploy AKS on Azure Stack HCI inside an Azure VM using [nested virtualization](../hci/concepts/nested-virtualization.md).

:::image type="content" source="media/aks-hci-evalguide/deployment-overview.png" alt-text="Diagram of AKS on Azure Stack HCI deployment":::

In this configuration, you'll take advantage of the nested virtualization support provided within certain Azure VM sizes.

* First, you will deploy a single Azure VM running Windows Server 2019 Datacenter. Inside this VM, you'll have all the necessary roles and features configured, so you can quickly proceed to deploying AKS on Azure Stack HCI. 
* Next, you deploy the AKS on Azure Stack HCI management cluster, and then worker node clusters, all within a single Azure VM.

> [!IMPORTANT]
> The steps outlined in this evaluation guide are specific to running inside an Azure VM, running a single Windows Server 2019 or 2022 OS without a configured domain environment. If you plan to use these steps in an alternate environment, such as a nested/physical on-premises, or in a domain-joined environment, the steps may differ and certain procedures may not work. If this is the case, please refer to the [official documentation to deploy AKS on Azure Stack HCI](overview.md).

### Deployment workflow

This section demonstrates how to deploy a sandboxed AKS on Azure Stack HCI infrastructure. To accommodate different preferences, we've provided paths to use PowerShell or a GUI (Graphical User Interface) such as Windows Admin Center-based deployments.

The following figure shows the general flow:

:::image type="content" source="media/aks-hci-evalguide/gui-deployment.png" alt-text="Image showing nested virtualization workflow":::

**[Step 1 - Start your deployment into Azure](aks-hci-evalguide-1.md):** In this step, you'll learn to create a suitable VM in Azure using PowerShell or an Azure Resource Manager template. This VM will run the full desktop version of Windows Server 2019/2022 Datacenter. On this system, you will:

* automatically enable the necessary roles  features and accompanying management tools.
* configure networking to enable network communication between sandbox VMs and the internet.

**[Step 2a](aks-hci-evalguide-2a.md) and [2b](aks-hci-evalguide-2b.md) - Deploy your AKS-HCI infrastructure:** In this step, you will use either Windows Admin Center or PowerShell to deploy AKS on Azure Stack HCI. First, you will deploy the necessary management cluster, and then a target cluster for running workloads.

**[Step 3 - Explore the AKS on Azure Stack HCI environment](aks-hci-evalguide-3.md):** With your deployment completed, you're now ready to explore many of the aspects of AKS on Azure Stack HCI. This includes experimenting with various provided hybrid solutions that can help you get started in using your AKS on the Azure Stack HCI cluster. We'll also provide links to further scenarios and resources to continue your evaluation.

<!-- ### Fully automated deployment

If you have already deployed AKS on Azure Stack HCI and would like to fully automate the deployment inside an Azure VM sandbox, [see this information on fully automated deployment](/eval/autodeploy/README.md). -->

## Product improvements

If you have an idea to make the product better, whether it's something in AKS on Azure Stack HCI, Windows Admin Center, or the Azure Arc integration and experience, let us know. We want to hear from you! [Follow this link to proceed to our AKS on Azure Stack HCI GitHub page](https://github.com/Azure/aks-hci/issues "AKS on Azure Stack HCI GitHub"), where you can share your thoughts and ideas about making the technologies better.  

## Report issues

If you notice something is wrong with the evaluation guide, for example, a step doesn't work, or something just doesn't make sense - help us to make this guide better!  Report an issue in GitHub, and we'll be sure to fix this as quickly as possible.

If however, you're having a problem with AKS on Azure Stack HCI **outside** of this evaluation guide, make sure you post to [our GitHub Issues page](https://github.com/Azure/aks-hci/issues "GitHub Issues"), where Microsoft experts and valuable members of the community will do their best to help you.

## Next steps

Proceed to step 1 of the evaluation guide:

* [Evaluate AKS on Azure Stack HCI in Azure](aks-hci-evalguide-1.md)
