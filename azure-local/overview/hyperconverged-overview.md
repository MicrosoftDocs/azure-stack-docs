---
title: Overview of Hyperconverged Deployments for Azure Local
description: Learn the benefits, features, and use cases of Azure Local hyperconverged deployments, designed to accelerate cloud and AI innovation from edge to core.
#customer intent: As an IT admin, I want to understand the benefits and features of Azure Local hyperconverged deployments so that I can evaluate its suitability for my organization.
author: alkohli
ms.author: alkohli
ms.reviewer: alkohli
ms.date: 11/11/2025
ms.topic: overview
ai-usage: ai-assisted
ms.service: azure-local
---

# Overview of hyperconverged deployments for Azure Local

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article provides an overview of hyperconverged deployments for Azure Local. The overview details the benefits, key features, use cases, and how to get started with this generally available solution.

Azure Local hyperconverged deployments (*formerly Azure Stack HCI*) offer a range of sizes from a single machine footprint to a maximum of 16 machines that use hyperconverged storage. They offer a unified management control plane and support a wide range of validated hardware from trusted Microsoft partners.

Hyperconverged deployments also accelerate cloud and AI innovation by seamlessly delivering new applications, workloads, and services from cloud to edge.

## Overview

A hyperconverged deployment of Azure Local consists of a machine or a cluster of machines connected to Azure. You can use the Azure portal to view, monitor, and manage individual Azure Local instances or your entire fleet. You can also manage Azure Local with your existing tools, including Windows Admin Center and PowerShell.

You can [Download the operating system software](../deploy/download-23h2-software.md) from the Azure portal with a free 60-day trial. To acquire the machines that support Azure Local, you can purchase validated hardware from a Microsoft hardware partner with the operating system pre-installed. See the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) for hardware options and use the sizing tool to estimate hardware requirements.

## Features and architecture

Azure Local is built on proven technologies including Hyper-V, Storage Spaces Direct, Failover Clustering and core Azure Management service. Each Azure Local instance can have 1 to 16 physical machines (excluding Rack aware cluster where a maximum of 8 machines is supported).

Azure Local has the following features and capabilities:

| **Features** | **Description** |
|---|---|
| Hardware | Validated hardware procured from a Microsoft hardware partner. Each instance can have 1 to 16 Azure Local machines. |
| Storage | Storage Spaces Direct-based virtualized storage. External SAN storage is offered in Preview for qualified opportunities. |
| Networking | Customer-managed networking that uses physical switches and VLANs in your datacenter with the option of enabling software-defined networking (SDN) services. |
| Azure Local services | Foundational services such as Azure Local virtual machines for general purpose VM workloads and Azure Kubernetes services (AKS) enabled by Azure Arc for containerized workloads. |
| Azure management services  | Onboard Azure Arc services such as Azure Policy, Azure Monitor, and Microsoft Defender for Cloud amongst others to manage, govern, and secure your Azure Local environment. |
| Observability | Metrics and logs are sent from on-premises to Azure Monitor and Log Analytics for both infrastructure and workload resources. |
| Management tools | Cloud management via Azure portal, Azure CLI, and Azure Resource Manager/Bicep/Terraform templates.<br><br>On-premises management via local tools such as PowerShell, Windows Admin Center, Hyper-V Manager, and Failover Cluster Manager. |
| Disaster Recovery | Can be enabled through Azure Backup, Azure Site Recovery, and other third-party vendors. |
| Security | A secure-by-default configuration with >300 security settings that provide a consistent security baseline and a drift control mechanism.<br><br>Once deployed, secure your Azure Local VM workloads by using the Trusted launch.<br><br>Moreover use the Microsoft Defender for Cloud to assess and improve the security posture of your Azure Local instance and your Azure Local VMs. |


The following diagram illustrates the architecture and the capabilities of Azure Local for hyperconverged deployments.

:::image type="content" source="media/hyperconverged-overview/azure-local-hyperconverged-solution.png" alt-text="The architecture diagram of the Azure Local solution." lightbox="media/hyperconverged-overview/azure-local-hyperconverged-solution.png":::

See [What's new in Azure Local for hyperconverged](../whats-new.md) for details on the latest enhancements.

## Benefits

Azure Local for hyperconverged deployments has the following key benefits:

- Azure Local is priced per physical core on your on-premises machines, plus any consumption-based charges for additional Azure services you use. All charges roll up to your existing Azure subscription.

- It provides a resilient infrastructure that can be configured for high-availability.

- Flexible hardware choices allow customers to choose the vendor with the best service and support in their geography. Joint support between Microsoft and the hardware vendor improves the customer experience.

- Built on familiar technologies such as Hyper-V and Failover clustering, Azure Local allows admins to leverage existing virtualization and storage concepts and skills.

- Azure Local includes all the familiar Azure management plane tooling such as Azure portal, Azure CLI, and Azure Resource Manager (ARM) templates to provision and manage resources.

- Solution updates make it easy to keep the entire solution up-to-date.

- Azure Local allows you to access key Arc-enabled Azure services within your on-premises environment.

- Azure Local offers unified governance and compliance across cloud and on-premises infrastructure. You can use Azure role-based access control (RBAC) and Azure Policy to unify data governance and enforce security and compliance policies.

## Common Azure services used with Azure Local

The following table includes a list of most commonly used Azure services with Azure Local:

| **Use case** | **Description** |
|---|---|
| Azure Local VMs enabled by Azure Arc | Deploy Windows and Linux VMs hosted on your Azure Local instance. To learn more, see [Create Azure Local virtual machines enabled by Azure Arc](../manage/create-arc-virtual-machines.md).<br><br>Additionally, Trusted launch for Azure Local VMs enables secure boot and vTPM, automatically transfers the vTPM state within a cluster, and supports the ability to attest whether the VM started in a known good state. |
| Azure Virtual Desktop (AVD) | Deploy and manage Azure Virtual Desktop session hosts on your on-premises Azure Local. To learn more, see [Azure Virtual Desktop for Azure Local](/azure/virtual-desktop/azure-stack-hci-overview). |
| Azure Kubernetes Service (AKS) enabled by Azure Arc | Use Azure Local to host container-based deployments using Azure Kubernetes Service (AKS) enabled by Azure Arc. To learn more, see [Azure Kubernetes Service on Azure Local](/azure/aks/aksarc/aks-whats-new-local). |
| Run Azure Arc services on-premises | Azure Arc allows you to run select Azure services to support hybrid workloads. To learn more, see [Azure Arc overview](/azure/azure-arc/overview). |
| Highly performant SQL Server | Azure Local provides additional resiliency to highly available, mission-critical deployments of SQL Server. To learn more, see [Deploy SQL Server on Azure Local](../deploy/sql-server-23h2.md). |
| Azure Video Indexer | Extract the insights from your videos using **Azure** AI **Video Indexer** video and audio models. To learn more, see [What is Azure AI Video Indexer enabled by Azure Arc](/azure/azure-video-indexer/arc/azure-video-indexer-enabled-by-arc-overview)? |
| Azure Edge RAG (Preview) | Azure Edge RAG, enabled by Azure Arc is a turnkey solution that packages everything that's necessary to allow customers to build custom chat assistants and derive insights from their private data. To learn more, see [What is Edge Retrieval Augmented Generation (RAG)?](/azure/azure-arc/edge-rag/overview) |
| Azure IoT Operations | Deploy Azure IoT Operations on Azure Kubernetes Service (AKS) enabled by Azure Arc clusters running on Azure Local to manage and process IoT data at the edge. To learn more, see [Azure IoT Operations overview](/azure/iot-operations/overview-iot-operations). |

For more details on the cloud service components of Azure Local, see [Azure Local hybrid capabilities with Azure services](../hybrid-capabilities-with-azure-services-23h2.md).

## What you need to get started with Azure Local

To get started, you'll need:

- One or more machines from the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog), purchased from your preferred Microsoft hardware partner.

- An [Azure subscription](https://azure.microsoft.com/).

- Operating system licenses for your workload VMs – for example, Windows Server. See [Activate Windows Server VMs](../manage/vm-activate.md).

- An internet connection for each machine in the system that can connect via HTTPS outbound traffic to well-known Azure endpoints at least every 30 days. See [Azure connectivity requirements](../concepts/firewall-requirements.md) for more information.

- If you plan to use SDN, read [SDN overview](../concepts/sdn-overview.md).

Make sure your hardware meets the [System requirements](../concepts/system-requirements-23h2.md) and that your network meets the [physical network](../concepts/physical-network-requirements.md) and [host network](../concepts/host-network-requirements.md) requirements for Azure Local.

For Azure Kubernetes Service on Azure Local, see [AKS network requirements](/azure/aks/hybrid/aks-hci-network-system-requirements).


## Hardware and software partners

Microsoft recommends purchasing Premier Solutions offered in collaboration with our hardware partners to provide the best experience for Azure Local solution. Microsoft partners also offer a single point of contact for implementation and support services.

Browse the [Azure Local Catalog](https://aka.ms/AzureStackHCICatalog) to view Azure Local solutions from Microsoft partners such as ASUS, Blue Chip, DataON, Dell EMC, Fujitsu, HPE, Hitachi, Lenovo, NEC, primeLine Solutions, QCT, and Supermicro.


## Next steps

- Learn more [About Azure Local hyperconvereged deployments](../deploy/deployment-introduction.md).