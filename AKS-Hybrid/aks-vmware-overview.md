---
title: AKS enabled by Azure Arc on VMware overview (preview)
description: Learn about AKS enabled by Azure Arc deployment options on VMware.
ms.topic: overview
ms.date: 03/22/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: leslielin
ms.lastreviewed: 03/15/2024

---

# What is AKS enabled by Azure Arc on VMware (preview)?

[!INCLUDE [aks-applies-to-vmware](includes/aks-hci-applies-to-skus/aks-applies-to-vmware.md)]

As part of the [Azure Kubernetes Service (AKS) enabled by Azure Arc](/azure/aks/hybrid), the AKS on VMware preview enables you to use [Azure Arc](/azure/azure-arc/overview) to create new Kubernetes clusters on VMware vSphere. AKS on VMware builds on the core capabilities developed for [AKS on Azure Stack HCI 23H2](aks-whats-new-23h2.md). These capabilities enable organizations to leverage the benefits of Azure cloud computing. AKS on VMware also helps you modernize applications and infrastructure, while maintaining control, flexibility, and compatibility across hybrid cloud deployments.

With AKS on VMware, you can manage your AKS Arc clusters running on VMware vSphere using familiar tools like Azure CLI. By default, AKS on VMware is Arc-connected, simplifying the process of bringing Azure capabilities to AKS on VMware through the [Arc Resource Bridge](/azure/azure-arc/resource-bridge/overview).

The integration of the Kubernetes extension for AKS Arc operators in Arc-enabled VMware vSphere environments simplifies the orchestration and management of containerized workloads across Azure and VMware vSphere platforms. This innovative approach provides infrastructure administrators and Kubernetes operators a unified, cloud-centric experience for the whole lifecycle management of Kubernetes clusters. It offers key capabilities and benefits such as:

- **Simplified infrastructure deployment on Arc-Enabled VMware vSphere with seamless onboarding**: The installation of the Kubernetes extension for AKS Arc operators is now incorporated into the single-step onboarding process for Arc-enabled VMWare vSphere through the Azure Portal.
- **Unified cloud-based management tools**: Administrators can use widely-adopted tools, such as the Azure Command-Line Interface (CLI), to create, configure, and manage Kubernetes clusters directly on VMware. This integration provides a consistent toolset for managing resources, regardless of their deployment environment.
- **Azure-consistent command-line experience**: The experience provided by AKS on Azure Stack HCI 23H2 also extends to AKS on VMware, offering a consistent CLI experience in line with Azure standards. Even during the preview phase, where only a subset of commands might be supported, this consistency is essential for administrators who value a uniform and standardized interface across their adaptive cloud deployments.

## Simplified management of AKS components on VMware vSphere

To use AKS on VMware, you must onboard [Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/overview) by connecting vCenter to Azure through the Arc Resource Bridge, with the Kubernetes extension for AKS Arc operators (preview) installed. If you have an existing Arc-enabled VMware vSphere, follow the instructions to [enable the Kubernetes Extension for AKS Arc Operators](aks-vmware-install-kubernetes-extension.md).

The following infrastructure components comprise the AKS on VMware experience:

- [**Arc-enabled VMware vSphere**](/azure/azure-arc/vmware-vsphere/overview): Azure Arc-enabled VMware vSphere is an Azure Arc service that helps you simplify management of hybrid IT estates distributed across VMware vSphere and Azure. It does so by extending the Azure control plane to VMware vSphere infrastructure and enabling the consistent use of Azure security, governance, and management capabilities across VMware vSphere and Azure.
- [**Arc Resource Bridge**](/azure/azure-arc/resource-bridge/overview): The Arc Resource Bridge is created automatically when you Arc-enable your VMware vSphere cluster. This lightweight Kubernetes VM connects your VMware vSphere to Azure Cloud and enables on-premises resource management from Azure. Azure Arc Resource Bridge provides the line of sight to private clouds required to manage resources, such as Kubernetes clusters on-premises through Azure.
- [**Custom locations**](/azure/azure-arc/platform/conceptual-custom-locations): Similar to Azure Arc Resource Bridge, a custom location is created automatically when you deploy Arc-enabled VMware vSphere. A custom location is the on-premises equivalent of an Azure region and is an extension of the Azure location construct. Custom locations provide a way for tenant administrators to use their data center with the right extensions installed, as target locations for deploying AKS.
- **Kubernetes Extension for AKS Arc Operators**: The Kubernetes extension for AKS operators can be installed on Arc Resource Bridge using a helper script, from the Azure portal or using Azure CLI commands. It's the on-premises equivalent of an Azure Resource Manager resource provider to help manage AKS via Azure.

By integrating these components, Azure Arc offers a unified and efficient solution for provisioning and managing Kubernetes. It seamlessly bridges the gap between on-premises and cloud infrastructures.

## Enable infrastructure administrators and Kubernetes operators to orchestrate containerized workloads

- **Infrastructure administrator**: The infrastructure administrator is responsible for setting up VMware vSphere, which encompasses the deployment of all previously mentioned infrastructure components. The administrator must also establish the platform configuration, including networking and storage, to enable Kubernetes operators to create and manage Kubernetes clusters.
- **Kubernetes operator**: Kubernetes operators create and manage Kubernetes clusters on VMware. This management enables operators to run applications without needing to coordinate with infrastructure administrators. The operator is granted access to the Azure subscription, Azure custom location, and virtual network by the infrastructure administrator. There's no need for access to the underlying on-premises infrastructure. With the necessary access, the operator can create Kubernetes clusters based on application requirements.

## Pricing and terms of use

AKS on VMware is available for public preview and is currently free of charge. During the preview, a trial meter is operational. To understand the data collection of billing events, see the [data collection](data-collection.md) article for more details. However, be aware that the AKS on VMware preview is not recommended for production workloads. Use it with caution. For more information, see [Troubleshooting and support policy](aks-vmware-support-troubleshoot.md).

## Next steps

- For information about the minimum requirements for running AKS on VMware, see [System requirements and support matrix](aks-vmware-system-requirements.md).
- If you already connected vCenter to Azure Arc and want to add the AKS extension, see [enable Kubernetes Extension for AKS Arc Operators](aks-vmware-install-kubernetes-extension.md).
- If your vCenter is not connected to Azure Arc and you want to add the Kubernetes Extension for AKS Arc Operators (preview), see the [Quickstart: Connect VMware vCenter Server to Azure Arc using the help script](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script).
