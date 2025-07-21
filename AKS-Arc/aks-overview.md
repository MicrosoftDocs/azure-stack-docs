---
title: What is AKS enabled by Azure Arc?
description: Learn about AKS enabled by Azure Arc and available deployment options.
ms.topic: overview
ms.date: 07/21/2025
author: sethmanheim
ms.author: sethm 
ms.reviewer: rcheeran
ms.lastreviewed: 07/16/2025

---

# What is AKS enabled by Azure Arc?

Azure Kubernetes Service (AKS) enabled by Azure Arc on Azure Local is a managed Kubernetes service that you can use to deploy and manage containerized applications on-premises, in datacenters, or at edge locations such as retail stores or manufacturing plants. You need minimal Kubernetes expertise to get started with AKS. AKS reduces the complexity and operational overhead of managing Kubernetes by offloading much of that responsibility to Azure. AKS is an ideal platform for deploying and managing containerized applications that require high availability, scalability, and portability. It's also ideal for deploying applications to multiple locations, using open-source tools, and integrating with existing DevOps tools.

## About AKS on Azure Local

AKS Arc on Azure Local uses [Azure Arc](/azure/azure-arc/overview) to create new Kubernetes clusters on Azure Local directly from Azure. It enables you to use familiar tools like the Azure portal, Azure CLI, and Azure Resource Manager templates to create and manage your Kubernetes clusters running on Azure Local. Since clusters are automatically connected to Arc when they are created, you can use your Microsoft Entra ID for connecting to your clusters from anywhere. This ensures your developers and application operators can provision and configure Kubernetes clusters in accordance with company policies.

Microsoft continues to focus on delivering a consistent user experience for all your AKS clusters. If you have created and managed Kubernetes clusters using Azure, you'll feel right at home managing Kubernetes clusters running on Azure Local using Azure portal or Azure CLI management experiences.

## Simplified AKS component management on Azure Local

AKS Arc on Azure Local includes several infrastructure components that provide Azure experiences, including the Arc Resource Bridge, Custom Location, and the Kubernetes Extension for the AKS Arc operator. These infrastructure components are now included in Azure Local:

- **Arc Resource Bridge**: The Arc Resource Bridge is created automatically when you deploy Azure Local. This lightweight Kubernetes VM connects your Azure Local to Azure Cloud and enables on-premises resource management from Azure. Azure Arc Resource Bridge provides the line of sight to private clouds required to manage resources such as Kubernetes clusters on-premises through Azure.
- **Custom Location**: Just like Azure Arc Resource Bridge, a custom location is created automatically when you deploy Azure Local. A custom location is the on-premises equivalent of an Azure region and is an extension of the Azure location construct. Custom locations provide a way for tenant administrators to use their data center with the right extensions installed, as target locations for deploying AKS.
- **Kubernetes Extension for AKS Arc Operators**: The Kubernetes Extension for AKS Operators is automatically installed on Arc Resource Bridge when you deploy Azure Local. It's the on-premises equivalent of an Azure Resource Manager resource provider, to help manage AKS via Azure.

By integrating these components, Azure Arc offers a unified and efficient Kubernetes provisioning and management solution, seamlessly bridging the gap between on-premises and cloud infrastructures.

## Key personas

**Infrastructure administrator**: The role of the infrastructure administrator is to set up Azure Local, which includes all the infrastructure component deployments previously mentioned. Administrators must also set up the platform configuration, such as the networking and storage configuration, so that Kubernetes operators can create and manage Kubernetes clusters.

**Kubernetes operator**: Kubernetes operators can create and manage Kubernetes clusters on Azure Local so they can run applications without coordinating with infrastructure administrators. The operator is given access to the Azure subscription, Azure custom location, and virtual network by the infrastructure administrator. No access to the underlying on-premises infrastructure is necessary. Once the operator has the required access, they can create Kubernetes clusters according to application needs: Windows/Linux node pools, Kubernetes versions, etc.

## Overview of AKS enabled by Azure Arc

AKS enabled by Azure Arc reduces the complexity and operational overhead of managing Kubernetes by shifting that responsibility to Azure. When you create an AKS enabled by Azure Arc cluster, it's automatically connected to Azure Arc for centralized management. By managing all of your Kubernetes resources in a single control plane on Azure, you can enable a more consistent development and operator experience to run cloud-native apps anywhere and on any infrastructure option.

AKS enabled by Azure Arc provides the following features:

- Supports running Kubernetes clusters on-premises, on the edge, or in other cloud environments. This provides flexibility to meet specific business or technical requirements.
- A consistent experience for managing Kubernetes clusters across different infrastructures, similar to the experience you get with AKS in Azure.
- Centralized management of Kubernetes clusters through the Azure portal, regardless of where they are hosted. This includes monitoring, updating, and scaling clusters.
- Extends Azure security and governance capabilities to Kubernetes clusters running anywhere. You can apply Azure Policy for governance and use Azure Security Center for security monitoring and threat detection.
- Integrates with various Azure services such as Azure Monitor, Azure Policy, and Azure Security Center, providing a seamless experience for operations and management.
- Supports GitOps for configuration management and continuous deployment practices. This enables automated and consistent deployment processes.

## When to use AKS enabled by Azure Arc

The following list describes some of the common use cases for AKS, but is not an exhaustive list:

- **Hybrid cloud deployments**: Ideal for organizations looking to run applications across multiple environments, including on-premises and Azure, while maintaining a consistent management layer.
- **Edge computing**: Useful for deploying applications at the edge, where low latency and local processing are critical, such as in retail stores, manufacturing floors, or remote locations.
- **Regulatory and compliance**: Helps to meet specific regulatory and compliance requirements by enabling localized deployment and management of Kubernetes clusters.

## AKS enabled by Azure Arc deployment options

The available deployment options are as follows:

- [**AKS on Azure Local**](aks-whats-new-local.md): AKS on Azure Local uses Azure Arc to create new Kubernetes clusters on Azure Local directly from Azure. It enables you to use familiar tools like the Azure portal and Azure Resource Manager templates to create and manage your Kubernetes clusters running on Azure Local.
- [**AKS Edge Essentials**](aks-edge-overview.md): AKS Edge Essentials includes a lightweight Kubernetes distribution with a small footprint and simple installation experience, making it easy for you to deploy Kubernetes on PC-class or "light" edge hardware.
- [**AKS on VMWare (preview)**](aks-vmware-overview.md): AKS on VMware (preview) enables you to use Azure Arc to create new Kubernetes clusters on VMware vSphere. With AKS on VMware, you can manage your AKS clusters running on VMware vSphere using familiar tools like Azure CLI.
- [**AKS on Windows Server**](overview.md): AKS on Windows Server is an on-premises Kubernetes implementation of AKS that automates running containerized applications at scale, using Windows PowerShell and Windows Admin Center. It simplifies deployment and management of AKS on Windows Server 2019/2022 Datacenter.

## Next steps

- [What's new in AKS on Azure Local](aks-whats-new-local.md)
