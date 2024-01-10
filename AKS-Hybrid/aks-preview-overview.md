---
title: What's new in AKS on Azure Stack HCI 23H2 (preview)
description: Learn about AKS on Azure Stack HCI 23H2.
ms.topic: overview
ms.date: 12/06/2023
author: sethmanheim
ms.author: sethm 
ms.reviewer: guanghu
ms.lastreviewed: 11/16/2023

---

# What's new in AKS on Azure Stack HCI 23H2 (preview)

[!INCLUDE [hci-applies-to-23h2](includes/hci-applies-to-23h2.md)]

This article lists the various features and improvements that are available in AKS on Azure Stack HCI, version 23H2.

> [!IMPORTANT]
> This feature is currently in preview. See the [Supplemental Terms of Use for Microsoft Azure Previews](https://azure.microsoft.com/support/legal/preview-supplemental-terms/) for legal terms that apply to Azure features that are in beta, preview, or otherwise not yet released
> into general availability.

## About AKS on Azure Stack HCI 23H2

AKS on Azure Stack HCI 23H2 uses [Azure Arc](/azure/azure-arc/overview) to create new Kubernetes clusters on Azure Stack HCI directly from Azure. It enables you to use familiar tools like the Azure portal, Azure CLI, and Azure Resource Manager templates to create and manage your Kubernetes clusters running on Azure Stack HCI. Since clusters are automatically connected to Arc when they are created, you can use your Microsoft Entra ID for connecting to your clusters from anywhere. This ensures your developers and application operators can provision and configure Kubernetes clusters in accordance with company policies.

Microsoft continues to focus on delivering consistent user experience for all your AKS clusters. If you have created and managed Kubernetes clusters using Azure, you'll feel right at home managing Kubernetes clusters running on Azure Stack HCI 23H2 using Azure portal or Azure CLI management experiences.

At this time, you can perform the following operations through the Azure CLI and Azure portal:

- Create/list/show Kubernetes clusters.
- Specify/upgrade Kubernetes cluster' version.
- Access the Kubernetes cluster using kubectl and your Microsoft Entra ID.
- Add/list/show Linux and Windows nodepools on your Kubernetes cluster.
- Delete your Kubernetes clusters and nodepools.

## Simplified AKS components management on Azure Stack HCI 23H2

AKS on Azure Stack HCI 23H2 includes several infrastructure components that provide Azure experiences, including the Arc Resource Bridge, Custom Location, and the Kubernetes Extension for the AKS Arc operator. These infrastructure components are now included in Azure Stack HCI 23H2.

- **Arc Resource Bridge**: The Arc Resource Bridge is created automatically when you deploy Azure Stack HCI. This lightweight Kubernetes VM connects your Azure Stack HCI to Azure Cloud and enables on-premises resource management from Azure. Azure Arc Resource Bridge provides the line of sight to private clouds required to manage resources such as Kubernetes clusters on-premises through Azure.
- **Custom Location**: Just like the Arc Resource Bridge, a custom location is created automatically when you deploy your Azure Stack HCI. A custom location is the on-premises equivalent of an Azure region and is an extension of the Azure location construct. Custom locations provide a way for tenant administrators to use their data center with the right extensions installed, as target locations for deploying AKS.
- **Kubernetes Extension for AKS Arc Operator**: The Kubernetes extension for AKS Operator is automatically installed on Arc Resource Bridge when you deploy Azure Stack HCI. It is the on-premises equivalent of an Azure Resource Manager resource provider, helping manage AKS via Azure.

By integrating these components, Azure Arc offers a unified and efficient Kubernetes provisioning and management solution, seamlessly bridging the gap between on-premises and cloud infrastructures.

## Key personas

**Infrastructure administrator**: The role of the infrastructure administrator is to set up Azure Stack HCI, which includes all the infrastructure component deployment as previously mentioned. Administrators must also set up the platform configuration, such as the networking and storage configuration, so that Kubernetes operators can create and manage Kubernetes clusters.

**Kubernetes operator**: Kubernetes operators can create and manage Kubernetes clusters on Azure Stack HCI so they can run applications without coordinating with infrastructure administrators. The operator is given access to the Azure subscription, Azure custom location, and virtual network by the infrastructure administrator. No access to the underlying on-premises infrastructure is necessary.

Once the operator has the required access, they are free to create Kubernetes cluster according to application needs - Windows/Linux node pools, Kubernetes versions, etc.

## AKS on Azure Stack HCI 23H2 workflow

The AKS on Azure Stack HCI 23H2 workflow is as follows:

1. Deploy an Azure Stack HCI cluster. The deployment automatically creates and configures all infrastructure components, including the Arc Resource Bridge, custom location, and the Kubernetes extension for the AKS operator.
2. Create virtual networks.
3. Create Kubernetes clusters on Azure Stack HCI 23H2.

## Next steps

- [Review AKS on Azure Stack HCI 23H2 prerequisites](aks-hci-network-system-requirements.md)
