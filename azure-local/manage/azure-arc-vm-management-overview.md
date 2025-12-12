---
title: What is Azure Local VM management
description: Learn about using Azure Local VM management to provision and manage on-premises Windows and Linux virtual machines (VMs) running on Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.custom: linux-related-content
ms.date: 12/09/2025
---

# What is Azure Local VM management?

[!INCLUDE [hci-applies-to-23h2](../includes/hci-applies-to-23h2.md)]

This article provides an overview of the virtual machine (VM) management feature in hyperconverged deployments of Azure Local (*formerly Azure Stack HCI*), including its benefits, components, and a high-level workflow.

Azure Local VM management enables IT admins to provision and manage Windows and Linux VMs hosted in an on-premises Azure Local environment. IT admins can use the feature to create, modify, delete, and assign permissions and roles to app owners, thereby enabling self-service VM management.

Administrators can manage Azure Local VMs enabled by Azure Arc on their Azure Local instances by using Azure management tools, including the Azure portal, the Azure CLI, Azure PowerShell, and [Azure Resource Manager](/azure/azure-resource-manager/management/overview) templates. By using Azure Resource Manager templates, you can also automate VM provisioning in a secure cloud environment.

To find answers to frequently asked questions about Azure Local VM management, see the [FAQ](./azure-arc-vms-faq.yml).

## Benefits of Azure Local VM management

Although Hyper-V provides capabilities to manage your on-premises VMs, Azure Local VMs offer many benefits over traditional on-premises tools. These benefits include:

- Role-based access control (RBAC) via built-in Azure Local roles enhances security by ensuring that only authorized users can perform VM management operations. For more information, see [Use role-based access control to manage Azure Local virtual machines](./assign-vm-rbac-roles.md).
- Azure Local VM management provides the ability to deploy with Resource Manager templates, Bicep, and Terraform.
- The Azure portal acts as a single pane of glass to manage VMs on Azure Local and Azure VMs. With Azure Local VM management, you can perform various operations from the Azure portal or the Azure CLI, including:

  - Create, manage, update, and delete VMs. For more information, see [Create Azure Local VMs enabled by Azure Arc](./create-arc-virtual-machines.md).
  - Create, manage, and delete VM resources such as virtual disks, logical networks, network interfaces, and VM images.

- The self-service capabilities of Azure Local VM management reduce administrative overhead.

## Limitations of Azure Local VM management

Consider the following limitations when you're managing VMs on Azure Local:

- Updates to VM configurations, such as vCPU, memory, network interface, or data disk via on-premises tools, won't be reflected on the Azure management plane.

- Moving a resource group isn't supported for VMs on Azure Local and its associated resources (such as network interfaces and disks).

- Creation of VMs by using Windows Server 2012 and Windows Server 2012 R2 images isn't supported via the Azure portal. You can do it only via the Azure CLI. For more information, see [Additional parameters for Windows Server 2012 and Windows Server 2012 R2 images](./create-arc-virtual-machines.md#additional-parameters-for-windows-server-2012-and-windows-server-2012-r2-images).

- Azure Local VMs only support IPv4 addresses. IPv6 addresses aren't supported.

- Once a logical network is created, you can't update the following:
   - Default gateway
  - IP pools
  - IP address space
  - VLAN ID
  - Virtual switch name

> [!NOTE]
> Taking a VM checkpoint locally is only supported for Azure Local 2504 and later.

## Components of Azure Local VM management

Azure Local VM management has several components, including:

- **Azure Arc resource bridge**: This lightweight Kubernetes VM connects your on-premises Azure Local instance to the Azure cloud. The Azure Arc resource bridge is created automatically when you deploy Azure Local.

    For more information, see [What is Azure Arc resource bridge?](/azure/azure-arc/resource-bridge/overview).

- **Custom location**: Just like the Azure Arc resource bridge, a custom location is created automatically when you deploy Azure Local. You can use this custom location to deploy Azure services. You can also deploy VMs in these user-defined custom locations, to integrate your on-premises setup more closely with Azure.

- **Kubernetes extension for VM operators**: The VM operator is the on-premises counterpart of the Azure Resource Manager resource provider. It's a Kubernetes controller that uses custom resources to manage your VMs.

By integrating these components, Azure Arc offers a unified and efficient VM management solution that bridges the gap between on-premises and cloud infrastructures.

## Azure Local VM management workflow

In this release, the Azure Local VM management workflow is as follows:

1. During your deployment of Azure Local, one Azure Arc resource bridge is installed per cluster. A custom location is also created.
1. You [assign built-in RBAC roles for Azure Local VM management](./assign-vm-rbac-roles.md).
1. You create VM resources such as:
    1. [Storage paths](./create-storage-path.md) for VM disks.
    1. VM images, starting with an image in [Azure Marketplace](./virtual-machine-image-azure-marketplace.md), in an [Azure Storage account](./virtual-machine-image-storage-account.md), or in a [local share](./virtual-machine-image-local-share.md). These images are then used with other VM resources to create VMs.
    1. [Logical networks](./create-logical-networks.md).  
    1. [VM network interfaces](./create-network-interfaces.md).
1. You use the VM resources to [create VMs](./create-arc-virtual-machines.md).

To troubleshoot problems with your VMs or to learn about known issues and limitations, see [Troubleshoot Azure Local VM management](troubleshoot-arc-enabled-vms.md).

## Related content

- [Azure Local VM management prerequisites](azure-arc-vm-management-prerequisites.md)
