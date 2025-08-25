---
title: What is AKS enabled by Azure Arc?
description: Learn about AKS enabled by Azure Arc and available deployment options.
ms.topic: overview
ms.date: 08/25/2025
author: sethmanheim
ms.author: sethm 
ms.reviewer: rcheeran
ms.lastreviewed: 07/16/2025

---

# What is AKS enabled by Azure Arc?

Azure Kubernetes Service (AKS) enabled by Azure Arc on Azure Local is a managed Kubernetes service that lets you deploy and manage containerized applications on-premises, in datacenters, or at edge locations like retail stores or manufacturing plants. You need minimal Kubernetes expertise to get started with AKS. AKS reduces the complexity and operational overhead of managing Kubernetes by offloading much of that responsibility to Azure. AKS is a good platform for deploying and managing containerized applications that need high availability, scalability, and portability. It's also good for deploying applications to multiple locations, using open-source tools, and integrating with existing DevOps tools.

## About AKS on Azure Local

AKS Arc on Azure Local uses [Azure Arc](/azure/azure-arc/overview) to create new Kubernetes clusters on Azure Local directly from Azure. It lets you use familiar tools like the Azure portal, Azure CLI, and Azure Resource Manager templates to create and manage Kubernetes clusters running on Azure Local. Because clusters connect to Arc automatically when they're created, you can use your Microsoft Entra ID to connect to your clusters from anywhere. This way, your developers and app operators can set up and manage Kubernetes clusters according to company policies.

Microsoft focuses on delivering a consistent experience for all your AKS clusters. If you've created and managed Kubernetes clusters using Azure, you'll feel at home managing Kubernetes clusters running on Azure Local with Azure portal or Azure CLI.

## Simplified AKS component management on Azure Local

AKS Arc on Azure Local includes several infrastructure components that give you Azure experiences, like Arc Resource Bridge, Custom Location, and the Kubernetes extension for the AKS Arc operator. These infrastructure components are now part of Azure Local:

- **Arc Resource Bridge**: The Arc Resource Bridge is created automatically when you deploy Azure Local. This lightweight Kubernetes VM connects your Azure Local to Azure Cloud and enables on-premises resource management from Azure. Azure Arc Resource Bridge provides the line of sight to private clouds required to manage resources such as Kubernetes clusters on-premises through Azure.
- **Custom Location**: Like Arc Resource Bridge, a custom location is created automatically when you deploy Azure Local. A custom location is the on-premises equivalent of an Azure region and extends the Azure location concept. Custom locations let tenant admins use their data center with the right extensions installed as target locations for deploying AKS.
- **Kubernetes extension for AKS Arc operators**: The Kubernetes extension for AKS Arc operators is installed automatically on Arc Resource Bridge when you deploy Azure Local. It's the on-premises equivalent of an Azure Resource Manager resource provider and helps you manage AKS through Azure.

By integrating these components, Azure Arc gives you a unified and efficient way to provision and manage Kubernetes, bridging the gap between on-premises and cloud infrastructure.

## Key personas

**Infrastructure administrator**: The infrastructure admin sets up Azure Local, including all the infrastructure component deployments mentioned earlier. The admin also sets up platform configuration, like networking and storage, so Kubernetes operators can create and manage Kubernetes clusters.

**Kubernetes operator**: Kubernetes operators create and manage Kubernetes clusters on Azure Local to run applications without coordinating with infrastructure admins. The admin gives the operator access to the Azure subscription, Azure custom location, and virtual network. The operator doesn't need access to the underlying on-premises infrastructure. After getting the required access, the operator creates Kubernetes clusters based on application needs, like Windows or Linux node pools and Kubernetes versions.

## Overview of AKS enabled by Azure Arc

AKS enabled by Azure Arc reduces the complexity and operational overhead of managing Kubernetes by shifting that responsibility to Azure. When you create an AKS enabled by Azure Arc cluster, it's automatically connected to Azure Arc for centralized management. By managing all your Kubernetes resources in a single control plane on Azure, you enable a more consistent development and operator experience to run cloud-native apps anywhere and on any infrastructure option.

AKS enabled by Azure Arc provides the following features:

- Run Kubernetes clusters on-premises, at the edge, or in other cloud environments. This flexibility helps meet specific business or technical needs.
- Get a consistent experience for managing Kubernetes clusters across different infrastructures, similar to AKS in Azure.
- Manage Kubernetes clusters centrally through the Azure portal, no matter where they're hosted. This includes monitoring, updating, and scaling clusters.
- Extend Azure security and governance capabilities to Kubernetes clusters running anywhere. Apply Azure Policy for governance and use Azure Security Center for security monitoring and threat detection.
- Integrate with Azure services like Azure Monitor, Azure Policy, and Azure Security Center for a seamless operations and management experience.
- Use GitOps for configuration management and continuous deployment. This approach enables automated and consistent deployment processes.

## When to use AKS enabled by Azure Arc

Here are some common use cases for AKS enabled by Azure Arc:

- **Hybrid cloud deployments**: Run applications across on-premises and Azure environments with a consistent management layer.
- **Edge computing**: Deploy applications at the edge for low latency and local processing in places like retail stores, manufacturing floors, or remote locations.
- **Regulatory and compliance**: Meet regulatory and compliance requirements by deploying and managing Kubernetes clusters locally.

## AKS enabled by Azure Arc deployment options

Here are the available deployment options:

- [**AKS on Azure Local**](aks-whats-new-local.md): AKS on Azure Local uses Azure Arc to create new Kubernetes clusters on Azure Local directly from Azure. You use familiar tools like the Azure portal and Azure Resource Manager templates to create and manage your Kubernetes clusters running on Azure Local.

- [**AKS Edge Essentials**](aks-edge-overview.md): AKS Edge Essentials includes a lightweight Kubernetes distribution with a small footprint and simple installation experience, making it easy for you to deploy Kubernetes on PC-class or "light" edge hardware.
- [**AKS on VMWare (preview)**](aks-vmware-overview.md): AKS on VMware (preview) enables you to use Azure Arc to create new Kubernetes clusters on VMware vSphere. With AKS on VMware, you can manage your AKS clusters running on VMware vSphere using familiar tools like Azure CLI.
- [**AKS on Windows Server**](overview.md): AKS on Windows Server is an on-premises Kubernetes implementation of AKS that automates running containerized applications at scale, using Windows PowerShell and Windows Admin Center. It simplifies deploying and managing AKS on Windows Server 2019 or 2022 Datacenter.

## AKS enabled by Azure Arc and the adaptive cloud approach

AKS enabled by Azure Arc is part of Microsoft’s [adaptive cloud](https://azure.microsoft.com/solutions/adaptive-cloud) approach. This approach helps organizations run and manage apps in many environments, including Azure, other cloud providers, on-premises systems, and edge locations. AKS supports this approach by making it easier to deploy and manage Kubernetes clusters wherever they are needed like on Azure Local. With Azure Arc, you can use the same tools and policies to manage clusters across all these environments, which helps you keep operations consistent and secure.


## Next steps

- [What's new in AKS on Azure Local](aks-whats-new-local.md)
