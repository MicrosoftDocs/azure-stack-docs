---
title: AKS on VMware overview (preview)?
description: Learn about AKS enabled by Azure Arc deployment options on VMware.
ms.topic: overview
ms.date: 03/15/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: leslielin
ms.lastreviewed: 03/15/2024

---

# What is AKS on VMware (preview)?

[!INCLUDE [aks-applies-to-vmware](includes/aks-hci-applies-to-skus/aks-applies-to-vmware.md)]

As part of the [Azure Kubernetes Service (AKS) enabled by Azure Arc](/azure/aks/hybrid), the AKS on VMware preview enables you to use [Azure Arc](/azure/azure-arc/overview) to create new Kubernetes clusters on VMware vSphere. AKS on VMware builds on the core capabilities developed for [AKS on Azure Stack HCI 23H2](aks-whats-new-23h2.md). These capabilities enable organizations to leverage the benefits of Azure cloud computing. AKS on VMware also helps you modernize applications and infrastructure, while maintaining control, flexibility, and compatibility across hybrid cloud deployments.

With AKS on VMware, you can manage your AKS Arc clusters running on VMware vSphere using familiar tools like Azure CLI. By default, AKS on VMware is Arc-connected, simplifying the process of bringing Azure capabilities to AKS on VMware through the [Arc Resource Bridge](/azure/azure-arc/resource-bridge/overview).

The built-in AKS extension that comes with Arc-enabling your VMware vSphere offers a familiar, cloud-based experience for managing your Kubernetes cluster lifecycle, and offers the following benefits:

- **Simplified infrastructure deployment on Arc-Enabled VMware vSphere**: You can onboard VMware vSphere to Azure using a single-step process with the AKS Arc extension installed.
- **Cloud-based management**: You can now use familiar tools like Azure CLI to create and manage Kubernetes clusters on VMware.
- **Azure-consistent CLI**: You have a consistent command-line experience (with AKS on Azure Stack HCI 23H2) for creating and managing Kubernetes clusters. Note that during the preview, only some commands are supported.

## Simplified management of AKS components on VMware vSphere

To use AKS on VMware, you must onboard [Arc-enabled VMware vSphere](/azure/azure-arc/vmware-vsphere/overview) by connecting vCenter to Azure through the [Arc Resource Bridge](/azure/azure-arc/resource-bridge/overview), with the Kubernetes extension for AKS Arc operators (preview) installed. Once you deploy Arc-enabled VMware vSphere, follow the instructions to [Enable Kubernetes Extension for AKS Arc Operators](aks-vmware-install-kubernetes-extension.md).

The following infrastructure components service the AKS on VMware experience, including Arc-enabled VMware vSphere, Arc Resource Bridge, Custom Location, and the Kubernetes extension for the AKS Arc operator:

- [**Arc-enabled VMware vSphere**](/azure/azure-arc/vmware-vsphere/overview): Azure Arc-enabled VMware vSphere is an Azure Arc service that helps you simplify management of hybrid IT estate distributed across VMware vSphere and Azure. It does so by extending the Azure control plane to VMware vSphere infrastructure and enabling the use of Azure security, governance, and management capabilities consistently across VMware vSphere and Azure.
- [**Arc Resource Bridge**](/azure/azure-arc/resource-bridge/overview): The Arc Resource Bridge is created automatically when you Arc-enable your VMware vSphere cluster. This lightweight Kubernetes VM connects your VMware vSphere to Azure Cloud and enables on-premises resource management from Azure. Azure Arc Resource Bridge provides the line of sight to private clouds required to manage resources such as Kubernetes clusters on-premises through Azure.
- [**Custom Location**](/azure/azure-arc/platform/conceptual-custom-locations): Similar to Azure Arc Resource Bridge, a custom location is created automatically when you deploy Arc-enabled VMware vSphere. A custom location is the on-premises equivalent of an Azure region and is an extension of the Azure location construct. Custom locations provide a way for tenant administrators to use their data center with the right extensions installed, as target locations for deploying AKS.
- **Kubernetes Extension for AKS Arc Operators**: The Kubernetes extension for AKS operators can be installed on Arc Resource Bridge using a help script from the Azure portal or Azure CLI commands. It's the on-premises equivalent of an Azure Resource Manager resource provider to help manage AKS via Azure.

By integrating these components, Azure Arc offers a unified and efficient solution for provisioning and managing Kubernetes. It seamlessly bridges the gap between on-premises and cloud infrastructures.

## Orchestrate containerized workloads

AKS on VMware is designed to enable infrastructure administrators and Kubernetes operators to orchestrate containerized workloads across Azure and VMware vSphere. The following are some of the key capabilities:

- **Infrastructure administrator**: The infrastructure administrator is responsible for setting up VMware vSphere, which encompasses the deployment of all previously mentioned infrastructure components. The administrator must also establish the platform configuration, including networking and storage, to enable Kubernetes operators to create and manage Kubernetes clusters.
- **Kubernetes operator**: Kubernetes operators create and manage Kubernetes clusters on VMware. This management enables them to run applications without needing to coordinate with infrastructure administrators. The operator is granted access to the Azure subscription, Azure custom location, and virtual network by the infrastructure administrator. There's no need for access to the underlying on-premises infrastructure. With the necessary access, the operator can create Kubernetes clusters based on application requirements.

## Pricing and terms of use

AKS on VMware is available for public preview and is currently free of charge. However, be aware that the AKS on VMware preview is not recommended for production workloads. Use it with caution. For more information, see [Troubleshooting and support policy](aks-vmware-support-troubleshoot.md).

## Next steps

- For information about the minimum requirements for running AKS on VMware, see the System Requirements and Support Matrix.
- If you already connected vCenter to Azure Arc and want to add the AKS extension, see "Install and uninstall Kubernetes extension for AKS Arc Operators" to install the Kubernetes Extension for AKS Arc Operators (preview).
- If your vCenter is not connected to Azure Arc and you want to add the AKS extension, see the [Quickstart: Connect VMware vCenter Server to Azure Arc using the help script](/azure/azure-arc/vmware-vsphere/quick-start-connect-vcenter-to-arc-using-script).
