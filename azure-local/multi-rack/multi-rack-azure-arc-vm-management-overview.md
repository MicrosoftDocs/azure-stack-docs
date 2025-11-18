---
title: What is Azure Local VM Management for Multi-rack Deployments (preview)?
description: Learn about using Azure Local VM management to provision and manage on-premises Windows and Linux virtual machines (VMs) in Azure Local multi-rack deployments (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.custom: linux-related-content
ms.date: 11/17/2025
---

# What is Azure Local VM management for multi-rack deployments (preview)?

[!INCLUDE [multi-rack-applies-to-preview](../includes/multi-rack-applies-to-preview.md)]

This article provides a brief overview of the Azure Local virtual machine (VM) management feature on Azure Local for multi-rack deployments, including benefits, components, and a high-level workflow.

Azure Local VM management enables IT admins to provision and manage Windows and Linux VMs hosted in an on-premises Azure Local environment. IT admins can use the feature to create, modify, delete, and assign permissions and roles to app owners, thereby enabling self-service VM management.

Administrators can manage Azure Local VMs enabled by Azure Arc on their Azure Local instances by using Azure management tools, including the Azure portal, the Azure CLI, Azure PowerShell, and [Azure Resource Manager](/azure/azure-resource-manager/management/overview) templates. By using Azure Resource Manager templates, you can also automate VM provisioning in a secure cloud environment.

[!INCLUDE [hci-preview](../includes/hci-preview.md)]

## Benefits of Azure Local VM management

- Role-based access control (RBAC) via built-in Azure Local roles enhances security by ensuring that only authorized users can perform VM management operations. For more information, see [Use role-based access control to manage Azure Local virtual machines](multi-rack-assign-vm-rbac-roles.md).
- Azure Local VM management provides the ability to deploy with Azure Resource Manager and Bicep templates. 
- The Azure portal acts as a single pane of glass to manage VMs on Azure Local and Azure VMs. With Azure Local VM management, you can perform various operations from the Azure portal or the Azure CLI, including:

  - Create, manage, update, and delete VMs. For more information, see [Create Azure Local VMs enabled by Azure Arc](multi-rack-create-arc-virtual-machines.md).
  - Create, manage, and delete VM resources such as virtual disks, logical networks, network interfaces, and VM images.

- The self-service capabilities of Azure Local VM management reduce administrative overhead.

## Limitations of Azure Local VM management

Consider the following limitations when you're managing VMs on Azure Local:

- Moving a resource group isn't supported for VMs on Azure Local and its associated resources (such as network interfaces and disks).

- Azure Local VMs only support IPv4 addresses. IPv6 addresses aren't supported.

- Once a logical network is created, you can't update the following:
  - Default gateway.
  - IP pools.
  - IP address space.
  - VLAN ID.
  - Fabric network (defines the underlying Layer 3 connectivity).
  
- Guest management can't be enabled after VM creation.
- You can't add or remove network interfaces after VM creation. Make sure to create all the required network interfaces during VM creation.
- You can't update VM size on a running VM. To update VM size (CPU or memory), first turn off the VM. Apply the change and then restart the VM.
- You can't add or remove data disks from a running VM. To add or remove data disks from a VM, first turn off the VM. Apply the change, and then restart the VM.
- Terraform isn't supported for VM and VM resource deployment.

## Azure Local VM management workflow

In this release, the Azure Local VM management workflow is as follows:

1. During deployment of Azure Local, one custom location is created.
1. You [assign built-in RBAC roles for Azure Local VM management](multi-rack-assign-vm-rbac-roles.md).
1. You create VM resources such as:
    1. VM images, starting with an image in an [Azure Storage account](multi-rack-virtual-machine-image-storage-account.md). These images are then used with other VM resources to create VMs.
    1. [Logical networks](multi-rack-create-logical-networks.md) or virtual networks.  
    1. [Network interfaces](multi-rack-create-network-interfaces.md).
1. You use the VM resources to [create VMs](multi-rack-create-arc-virtual-machines.md).

## Related content

- [Azure Local VM management prerequisites for multi-rack deployments](multi-rack-vm-management-prerequisites.md)