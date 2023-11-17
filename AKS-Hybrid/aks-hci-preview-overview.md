---
title: Overview of AKS on Azure Stack HCI 23H2 (preview)
description: Learn about AKS on Azure Stack HCI 23H2.
ms.topic: overview
ms.date: 11/17/2023
author: sethmanheim
ms.author: sethm 
ms.reviewer: guanghu
ms.lastreviewed: 11/16/2023

# Intent: As an IT Pro, I want to learn how to create and manage AKS hybrid clusters on HCI
# Keyword: provisioned clusters 

---

# AKS on Azure Stack HCI 23H2

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article provides an overview of Azure Kubernetes Service (AKS) on Azure Stack HCI 23H2, including a brief introduction, its components, key persona and roles, and the high-level workflow.

This feature is currently in PREVIEW. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released
into general availability.

## Overview

AKS on Azure Stack HCI 23H2 uses Azure Arc to provision AKS Arc clusters from Azure. It enables you to use familiar tools like the Azure portal,
Azure CLI and Azure Resource Manager templates to create and manage your AKS Arc clusters running on Azure Stack HCI 23H2. Azure Arc is automatically enabled on all your AKS Arc clusters so you can use your Microsoft Entra ID identity for connecting to your clusters from anywhere. Microsoft Entra ensures that your developers and application operators can provision and configure Kubernetes clusters in accordance with company policies.

Microsoft continues to focus on delivering consistent user experience for all your AKS clusters. If you've created and managed AKS using
Azure, you can manage AKS Arc clusters with familiar Azure portal or Azure CLI management experiences.

You can also deploy applications at scale using GitOps in both AKS and AKS Arc clusters. GitOps applies development practices such as version control, collaboration, compliance, and continuous integration/continuous deployment (CI/CD) to infrastructure automation.

At this time, you can perform the following operations through the Azure portal, Azure CLI, and Resource Manager templates:

- Create/list/show AKS Arc clusters.
- Specify/upgrade AKS Arc cluster' version.
- Access the AKS Arc cluster using kubectl and your Microsoft Entra identity.
- Add/list/show Linux and Windows nodepools on your AKS Arc cluster.
- Delete your AKS Arc clusters and nodepools.

With Azure Arc, you can use the following Azure services on your AKS Arc cluster provisioning from Azure:

- Container Insights
- GitOps v2
- Open Service Mesh
- Azure Key Vault

To create and manage AKS clusters from Azure, you must install the key components described in the following sections.

## Components of AKS on Azure Stack HCI 23H2

The AKS on Azure Stack HCI 23H2 infrastructure is comprised of several components including the Arc Resource Bridge, Custom Location, and the Kubernetes extension for the AKS Arc operator. All of these infrastructure components are installed by default when Azure Stack HCI 23H2 is deployed.

- **Arc Resource Bridge**: The Arc Resource Bridge is created automatically when you deploy an Azure Stack HCI 23H2 cluster. This lightweight Kubernetes VM connects your Azure Stack HCI to the Azure cloud and enables on-premises resource management from Azure. Azure Arc Resource Bridge provides the line of sight to the private clouds required to manage resources such as Kubernetes clusters on-premises through Azure.
- **Custom Location**: Similar to the Arc Resource Bridge, a custom location is created automatically when you deploy your Azure Stack HCI cluster. A custom location is the on-premises equivalent of an Azure region and is an extension of the Azure location construct. Custom locations provide a way for tenant administrators to use their data center with the right extensions installed, as target locations for deploying AKS Arc instances.
- **Kubernetes Extension for AKS Arc Operator**: The Kubernetes extension for AKS Arc Operator is automatically installed on Arc Resource Bridge when you deploy your Azure Stack HCI 23H2 cluster. It is the on-premises equivalent of an Azure Resource Manager resource provider, helping manage AKS Arc clusters via Azure.

By integrating these components, Azure Arc offers a unified and efficient AKS Arc provisioning and management solution, seamlessly bridging the gap between on-premises and cloud infrastructures.

## Key personas and roles

**Infrastructure administrator role**: The role of the infrastructure administrator is to set up platform components; for example, setting up Azure Stack HCI, including the custom location, networking, and storage configurations. The admin role then creates on-premises networks that the Kubernetes operator uses to create AKS Arc clusters.

**Kubernetes operator role**: Kubernetes operators create and run applications on their on-premises AKS Arc clusters. The operator is given scoped Azure RBAC access to the Azure subscription, Azure custom location, and AKS Arc network by the infrastructure administrator. No access to the underlying on-premises infrastructure is necessary.

Once the operator has the required access, they are free to create AKS Arc cluster according to application needs - Windows/Linux node pools,
Kubernetes versions, and so on. The operator can also assign AKS cluster administrator permissions to other Microsoft Entra users in their organization, to access the provisioned AKS Arc clusters.

## AKS on Azure Stack HCI 23H2 workflow

The AKS on Azure Stack HCI 23H2 workflow is as follows:

1. The deployment of an Azure Stack HCI cluster automatically creates and configures all infrastructure components, including the Arc Resource Bridge, custom location, and the Kubernetes extension for the AKS Arc operator.
1. Assign built-in RBAC roles for the AKS Arc cluster.
1. Create AKS Arc virtual networks.
1. Create AKS Arc clusters on Azure Stack HCI 23H2.

To troubleshoot issues with your AKS Arc clusters or for more information about existing known issues and limitations, see Troubleshoot AKS on Azure Stack HCI 23H2.

## Next steps

- Review AKS on Azure Stack HCI 23H2 prerequisites.
