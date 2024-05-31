---
title: What is AKS enabled by Azure Arc?
description: Learn about AKS enabled by Azure Arc and available deployment options.
ms.topic: overview
ms.date: 05/28/2024
author: sethmanheim
ms.author: sethm 
ms.reviewer: abha
ms.lastreviewed: 05/28/2024

---

# What is AKS enabled by Azure Arc?

Azure Kubernetes Service (AKS) enabled by Azure Arc is a managed Kubernetes service that you can use to deploy and manage containerized applications on-premises, in datacenters, or at edge locations such as retail stores or manufacturing plants. You need minimal Kubernetes expertise to get started with AKS. AKS reduces the complexity and operational overhead of managing Kubernetes by offloading much of that responsibility to Azure. AKS is an ideal platform for deploying and managing containerized applications that require high availability, scalability, and portability. It's also ideal for deploying applications to multiple locations, using open-source tools, and integrating with existing DevOps tools.

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

- **AKS on Azure Stack HCI 23H2**: AKS on Azure Stack HCI 23H2 uses Azure Arc to create new Kubernetes clusters on Azure Stack HCI directly from Azure. It enables you to use familiar tools like the Azure portal and Azure Resource Manager templates to create and manage your Kubernetes clusters running on Azure Stack HCI.
- **AKS Edge Essentials**: AKS Edge Essentials includes a lightweight Kubernetes distribution with a small footprint and simple installation experience, making it easy for you to deploy Kubernetes on PC-class or "light" edge hardware.
- **AKS on Windows Server**: Azure Kubernetes Service on Windows Server (and on Azure Stack HCI 22H2) is an on-premises Kubernetes implementation of AKS that automates running containerized applications at scale, using Windows PowerShell and Windows Admin Center. It simplifies deployment and management of AKS on Windows Server 2019/2022 Datacenter and Azure Stack HCI 22H2.
- **AKS on VMWare (preview)**: AKS on VMware (preview) enables you to use Azure Arc to create new Kubernetes clusters on VMware vSphere. With AKS on VMware, you can manage your AKS clusters running on VMware vSphere using familiar tools like Azure CLI.

## Next steps

To get started with AKS enabled by Azure Arc, see the following deployment option overviews:

- [AKS on Azure Stack HCI 23H2](aks-whats-new-23h2.md)
- [AKS on Windows Server](overview.md)
- [AKS Edge Essentials](aks-edge-overview.md)
- [AKS on VMware (preview)](aks-vmware-overview.md)
