---
title: Azure Kubernetes Service hybrid (AKS hybrid) evaluation guide 
description: Quickstart to evaluate hybrid deployment options for Azure Kubernetes Service (AKS) by deploying AKS hybrid in an Azure Virtual Machine.
author: sethmanheim
ms.topic: quickstart
ms.date: 12/16/2022
ms.author: sethm 
ms.lastreviewed: 08/29/2022
ms.reviewer: oadeniji
# Intent: As an IT Pro, I need to learn how to deploy AKS hybrid in an Azure Virtual Machine.
# Keyword: Azure Virtual Machine deployment
---

# Azure Kubernetes Service hybrid (AKS hybrid) evaluation guide

[!INCLUDE [applies-to-azure stack-hci-and-windows-server-skus](includes/aks-hci-applies-to-skus/aks-hybrid-applies-to-azure-stack-hci-windows-server-sku.md)]

This guide demonstrates the basics of how to deploy [AKS hybrid](./overview.md) in an Azure Virtual Machine.

You'll learn how to:

* Deploy and configure a Windows Server 2019 or 2022 Azure Virtual Machine to host the infrastructure.
* Deploy an AKS hybrid management cluster using Windows Admin Center or PowerShell.
* Deploy the AKS target (workload) clusters using Windows Admin Center or PowerShell.
* Integrate your AKS deployment with Azure Arc.
* Deploy a simple test application, and expose the app externally.

## AKS version

This guide has been tested and validated with the **July 2022 release** of AKS.

> [!NOTE]
> Azure portal screens for AKS hybrid may change. Some screenshots in the evaluation guide may differ from what you see.<!--Time to get rid of this - after checking all screens?-->

## What is AKS hybrid?

AKS hybrid deployment is an on-premises implementation of Azure Kubernetes Service (AKS) that automates running containerized applications at scale. AKS hybrid is  available on Azure Stack HCI 21H2 and Windows Server 2019 and Windows Server 2200 based clusters, making it easier to get started hosting Linux and Windows containers in your datacenter.

To learn more about AKS hybrid, see [What is AKS hybrid?](overview.md). This guide also provides references to other articles that can help you build your knowledge of AKS hybrid.

## Who should read this guide?

This evaluation guide demonstrates how to create a sand-boxed, isolated AKS hybrid deployment by using [*nested virtualization*](/azure-stack/hci/concepts/nested-virtualization). This guide provides a solid foundation that will allow you to explore other AKS hybrid deployment scenarios in the future.

## Evaluate AKS hybrid using nested virtualization

Keep in mind that server-class hardware is required in order to test, validate, and evaluate this technology. If you have multiple server-class pieces of spare hardware (ideally hardware validated for Azure Stack HCI), you can perform a more real-world evaluation of AKS hybrid. For more information, see the [Azure Stack HCI Catalog](https://aka.ms/azurestackhcicatalog). If you don't have spare hardware, consider using [nested virtualization](/azure-stack/hci/concepts/nested-virtualization) as an alternative for evaluation.

At a high level, nested virtualization allows a virtualization platform (that is, Hyper-V, or VMware ESXi) to run virtual machines that run a virtualization platform. The following image shows this architectural view:

:::image type="content" source="media/aks-hci-evaluation-guide/nested-virt.png" alt-text="Diagram of nested virtualization architecture.":::

The outer box represents the Azure Resource Group, which will contain all of the artifacts deployed in Azure, including the virtual machine itself, and accompanying network adapter, storage and so on. You'll deploy an Azure Virtual Machine running Windows Server 2019 or 2022 Datacenter. Once the VM is deployed, you'll perform some host configuration, and then begin to deploy the other key components. First, on the left hand side, you'll deploy the management cluster. The management cluster provides the core orchestration mechanism and interface for deploying and managing one or more target clusters, which are shown on the right-hand side of the diagram. These target clusters, also known as *workload clusters*, contain worker nodes and are where application workloads run. These workloads are managed by a management cluster. To learn more about the building blocks of the Kubernetes infrastructure, see [Kubernetes cluster architecture and workloads for AKS hybrid](kubernetes-concepts.md).

The bottom (or base) layer represents the physical hardware on which you install a *hypervisor*. In this example, we're using Windows Server with the Hyper-V role enabled. The hypervisor on the lowest level is considered the L0 (level 0) hypervisor. Azure doesn't allow access or control over this.

On the physical host, you create a virtual machine, which then allows you to deploy an OS that has a hypervisor enabled.  

The first virtualized layer is running a nested operating system with Hyper-V enabled (i.e., Windows Server 2019 or 2022). This would be an L1 (or level 1) hypervisor. Inside that OS, you could create a virtual machine to run a workload. This could also contain a hypervisor, which would be known as the L2 (or level 2) hypervisor, and so on, with multiple levels of nested virtualization possible.

> [!IMPORTANT]
> The use of nested virtualization in this evaluation guide is aimed at providing flexibility for evaluating an AKS hybrid in a test environment, and shouldn't be seen as a substitute for real-world deployments, performance, and scale testing. Keep in mind that each level of nesting impacts overall performance. Therefore, for production use, AKS hybrid should be deployed on validated physical hardware. For more information, see the [Azure Stack HCI 21H2 catalog](https://aka.ms/azurestackhcicatalog) or the [Windows Server catalog](https://www.windowsservercatalog.com/results.aspx?bCatID=1283&cpID=0&avc=126&ava=0&avq=0&OR=1&PGS=25) for systems running Windows Server Datacenter edition.

## Deployment overview

This guide assumes you don't have multiple server-class pieces of hardware running Azure Stack HCI 21H2 or Windows Server 2019/2022; instead it describes how to deploy AKS hybrid inside an Azure Virtual Machine using [nested virtualization](/azure-stack/hci/concepts/nested-virtualization).

:::image type="content" source="media/aks-hci-evaluation-guide/deployment-overview.png" alt-text="Illustration of the AKS hybrid infrastructure.":::<!--Remove "AZURE STACK HCI" from top label.-->

In this configuration, you'll take advantage of the nested virtualization support provided within certain Azure Virtual Machine sizes.

* First, you'll deploy a single Azure Virtual Machine running Windows Server 2019 Datacenter. Inside this VM, you'll have all the necessary roles and features configured, so you can quickly proceed to deploying AKS hybrid.
* Next, you'll deploy the AKS hybrid management cluster, and then worker node clusters, all within a single Azure Virtual Machine.

> [!IMPORTANT]
> The steps outlined in this evaluation guide are specific to running inside an Azure Virtual Machine, running a single Windows Server 2019 or 2022 OS without a configured domain environment. If you plan to use these steps in an alternate environment, such as a nested/physical on-premises, or in a domain-joined environment, the steps may differ and certain procedures may not work. If this is the case, please refer to the [AKS hybrid overview](overview.md).

### Deployment workflow

This section demonstrates how to deploy a sandboxed AKS hybrid infrastructure on Azure Stack HCI. To accommodate different preferences, we've provided paths to use PowerShell or a GUI (Graphical User Interface) such as Windows Admin Center-based deployments.

The following figure shows the general flow:

:::image type="content" source="media/aks-hci-evaluation-guide/gui-deployment.png" alt-text="Illustration of a nested virtualization workflow.":::

**[Step 1 - Prepare an Azure Virtual Machine for your AKS hybrid deployment](aks-hci-evaluation-guide-1.md):** In this step, you'll learn to create a suitable VM in Azure using PowerShell or an Azure Resource Manager template. This VM will run the full desktop version of Windows Server 2019/2022 Datacenter. On this system, you will:

* automatically enable the necessary roles, features, and accompanying management tools.
* configure networking to enable network communication between sandbox VMs and the internet.

**[Step 2a - Deploy AKS hybrid with Windows Admin Center](aks-hci-evaluation-guide-2a.md) and [Step 2b - Deploy AKS hybrid with PowerShell](aks-hci-evaluation-guide-2b.md):** In this step, you'll use either Windows Admin Center or PowerShell to deploy AKS hybrid. You'll deploy the necessary management cluster, and then a target cluster for running workloads.

**[Step 3 - Explore the AKS hybrid environment](aks-hci-evaluation-guide-3.md):** With your deployment completed, you're now ready to explore many of the aspects of AKS hybrid. This includes experimenting with various provided hybrid solutions that can help you get started in using your AKS hybrid cluster. We'll also provide links to further scenarios and resources to continue your evaluation.

<!-- ### Fully automated deployment

If you have already deployed AKS on Azure Stack HCI and would like to fully automate the deployment inside an Azure Virtual Machine sandbox, [see this information on fully automated deployment](/eval/autodeploy/README.md). -->

## Product improvements

If you have an idea to make the product better, whether it's something in AKS hybrid on Azure Stack HCI, Windows Admin Center, or the Azure Arc integration and experience, let us know. We want to hear from you! [Follow this link to proceed to our AKS on Azure Stack HCI GitHub page](https://github.com/Azure/aks-hci/issues "AKS on Azure Stack HCI GitHub"), where you can share your thoughts and ideas about making the technologies better.  

## Report issues

If you notice something is wrong with the evaluation guide, for example, a step doesn't work, or something just doesn't make sense - help us to make this guide better!  Report an issue in GitHub, and we'll be sure to fix this as quickly as possible.

If however, you're having a problem with AKS hybrid **outside** of this evaluation guide, make sure you post to [our GitHub Issues page](https://github.com/Azure/aks-hci/issues "GitHub Issues"), where Microsoft experts and valuable members of the community will do their best to help you.

## Next steps

Proceed to step 1 of the evaluation guide:

* [Step 1 - Prepare Azure Virtual Machine for AKS hybrid deployment](aks-hci-evaluation-guide-1.md)
