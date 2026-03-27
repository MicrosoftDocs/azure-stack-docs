---
title: What is Azure Local VM management
description: Learn about using Azure Local VM management to provision and manage on-premises Windows and Linux virtual machines (VMs) running on Azure Local.
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-local
ms.custom: linux-related-content
ms.date: 03/25/2026
ms.subservice: hyperconverged
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

- Changes to VM configurations, such as static network interface IP, or data disk configuration made either within the VM or through local management tools will not be reflected in Azure.

- Moving a resource group isn't supported for VMs on Azure Local and its associated resources (such as network interfaces and disks).

- Azure has limitations on subscriptions and services. For more information, see [Azure subscription and service limits, quotas, and constraints](/azure/azure-resource-manager/management/azure-subscription-service-limits).

- Creation of VMs by using Windows Server 2012 and Windows Server 2012 R2 images isn't supported via the Azure portal. You can do it only via the Azure CLI. For more information, see [Additional parameters for Windows Server 2012 and Windows Server 2012 R2 images](./create-arc-virtual-machines.md#additional-parameters-for-windows-server-2012-and-windows-server-2012-r2-images).

- Azure Local VMs only support IPv4 addresses. IPv6 addresses aren't supported.

- Once a logical network is created, you can't update the following:
  - Default gateway
  - IP pools
  - IP address space
  - VLAN ID
  - Virtual switch name

- Azure Local doesn't support provisioning an Azure Local VM using an IP address that is configured as the DNS server or a gateway on the same logical network.
> [!NOTE]
> Taking a VM checkpoint locally is only supported for Azure Local 2504 and later.

## Components of Azure Local VM management

Azure Local VM management has several components, including:

- **Azure Arc resource bridge**: A prepackaged virtual appliance that runs as a virtual machine (VM) on your Azure Local cluster. It hosts an Azure Arc-enabled Kubernetes cluster that acts as the management cluster and enables the projection of on-premises resources such as VMs, logical networks, network interfaces, disks, and other related resources into Azure for cloud-based management. The Azure Arc resource bridge is created automatically when you deploy Azure Local. The Arc resource bridge appears:

  - **In Azure**: as an Azure resource named *&lt;instance-name&gt;*-arcbridge
  - **On the local cluster**: as a VM named *&lt;GUID&gt;*-control-plane-*&lt;GUID&gt;*

    > [!IMPORTANT]
    > Azure Arc resource bridge is a critical component for Azure Local VM management and should not be deleted unless you plan to reimage or decommission your Azure Local instance. Deleting this resource results in loss of the Azure control plane used to manage Azure Local VMs.
    >
    > If you need to delete the Arc resource bridge, do so only after you've deleted all Azure resources associated with workload management, including:
    >
    > - Azure Local VMs
    > - AKS Arc clusters
    > - VM images
    > - Storage paths
    > - Logical networks
    > - Network interfaces
    > - Virtual hard disks
    > - Network security groups
    >
    > To delete the Arc resource bridge, follow the guidance here: [Azure Arc resource bridge deployment command overview](/azure/azure-arc/resource-bridge/deploy-cli).

    For more information, see [What is Azure Arc resource bridge?](/azure/azure-arc/resource-bridge/overview).

- **Infrastructure logical network**: A logical network associated with the Azure Local VM management and is created automatically when you deploy Azure Local. The Azure Arc resource bridge, a crucial component of Azure Local VM management, uses this logical network.

    For more information, see [Manage logical networks for Azure Local VMs enabled by Azure Arc](./manage-logical-networks.md).

- **Custom location**: An Azure resource that represents a target location for deploying Azure Local VMs and other associated resources. You can think of it as your organization's private Azure region. By selecting a custom location, Azure understands where and how to deploy resources within your Azure Local environment.

    Just like the Azure Arc resource bridge, a custom location is created automatically when you deploy Azure Local. It represents your Azure Local instance as a target location for deploying Azure resources. Custom locations bring Azure's consistent deployment model to Azure Local by abstracting away the underlying infrastructure details. Virtual machine administrators can deploy Azure resources such as VMs, disks, and network interfaces directly from Azure by simply choosing the custom location, without needing to interact directly with the underlying infrastructure.

    Each Azure Local instance has one custom location, and each custom location has a one-to-one mapping to the Azure Arc-enabled Kubernetes cluster namespace running inside the Azure Arc resource bridge.

    > [!IMPORTANT]
    > The custom location should only be deleted after the Arc resource bridge has been deleted.

- **Kubernetes cluster extension for Azure Local VMs**: This extension is a Kubernetes controller installed into the Azure Arc-enabled Kubernetes management cluster hosted inside the Azure Arc resource bridge. This extension implements the core business logic for Azure Local VM lifecycle management. It orchestrates fabric operations such as power operations, attaching and detaching disks and network interfaces, and GPU assignment on Azure Local VMs. The cluster extension processes requests from Azure Resource Manager (ARM), triggered by customer-initiated actions from the Azure control plane, and executes them locally on the Azure Local cluster.

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
