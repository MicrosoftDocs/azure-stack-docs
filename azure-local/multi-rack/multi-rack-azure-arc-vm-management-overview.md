---
title: What is Azure Local VM Management for Multi-rack Deployments (Preview)
description: Learn about using Azure Local VM management to provision and manage on-premises Windows and Linux virtual machines (VMs) in Azure Local multi-rack deployments (Preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.custom: linux-related-content
ms.date: 11/06/2025
---

# What is Azure Local VM management for multi-rack deployments?

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article provides a brief overview of the Azure Local virtual machine (VM) management feature on Azure Local for multi-rack deployments, including benefits, components, and a high-level workflow.

Azure Local VM management enables IT admins to provision and manage Windows and Linux VMs hosted in an on-premises Azure Local environment. IT admins can use the feature to create, modify, delete, and assign permissions and roles to app owners, thereby enabling self-service VM management.

Administrators can manage Azure Local VMs enabled by Azure Arc on their Azure Local instances by using Azure management tools, including the Azure portal, the Azure CLI, Azure PowerShell, and [Azure Resource Manager](/azure/azure-resource-manager/management/overview) templates. By using Azure Resource Manager templates, you can also automate VM provisioning in a secure cloud environment.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Benefits of Azure Local VM management

- Role-based access control (RBAC) via built-in Azure Local roles enhances security by ensuring that only authorized users can perform VM management operations. For more information, see [Use role-based access control to manage Azure Local virtual machines](../index.yml)<!--update link-->.
- Azure Local VM management provides the ability to deploy with Resource Manager templates. <!--Open comment present in the starter doc regarding Bicep and Terraform. Removed them for now.-->.
- The Azure portal acts as a single pane of glass to manage VMs on Azure Local and Azure VMs. With Azure Local VM management, you can perform various operations from the Azure portal or the Azure CLI, including:

  - Create, manage, update, and delete VMs. For more information, see [Create Azure Local VMs enabled by Azure Arc](./create-arc-virtual-machines.md).
  - Create, manage, and delete VM resources such as virtual disks, logical networks, network interfaces, and VM images.

- The self-service capabilities of Azure Local VM management reduce administrative overhead.

## Limitations of Azure Local VM management

Consider the following limitations when you're managing VMs on Azure Local:

<!--Open comment present in the starter doc about the following bullet.-->
- Moving a resource group isn't supported for VMs on Azure Local and its associated resources (such as network interfaces and disks).

- Azure Local VMs only support IPv4 addresses. IPv6 addresses aren't supported.

- Once a logical network is created, you can't update the following:
   - Default gateway
  - IP pools
  - IP address space
  - VLAN ID
  - Fabric network (defines the underlying L3 connectivity)

## Components of Azure Local VM management

Azure Local VM management has several components, including:

- **Custom location**: A custom location is created automatically when you deploy Azure Local. You can use this custom location to deploy Azure services. You can also deploy VMs in these user-defined custom locations, to integrate your on-premises setup more closely with Azure.

<!--Open comment present in the starter doc about the following bullet.-->
- **Kubernetes extension for VM operators**: The VM operator is the on-premises counterpart of the Azure Resource Manager resource provider. It's a Kubernetes controller that uses custom resources to manage your VMs.

By integrating these components, Azure Arc offers a unified and efficient VM management solution that bridges the gap between on-premises and cloud infrastructures.

## Azure Local VM management workflow

In this release, the Azure Local VM management workflow is as follows:

1. During deployment of Azure Local, one custom location is created.
1. You [assign built-in RBAC roles for Azure Local VM management](../index.yml)<!--update link-->.
1. You create VM resources such as:
    1. VM images, starting with an image in an [Azure Storage account](../index.yml)<!--update link-->. These images are then used with other VM resources to create VMs.
    1. [Logical networks](../index.yml)<!--update link--> or virtual networks.  
    1. [VM network interfaces](../index.yml)<!--update link-->.
1. You use the VM resources to [create VMs](../index.yml)<!--update link-->.

To troubleshoot problems with your VMs or to learn about known issues and limitations, see [Troubleshoot Azure Local VM management](../index.yml)<!--update link-->.

## Related content

- [Azure Local VM management prerequisites](../index.yml)<!--update link-->
