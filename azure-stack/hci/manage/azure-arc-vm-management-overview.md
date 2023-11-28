---
title: What is Azure Arc VM management? (preview)
description: Learn about Azure Arc VM managements to provision and manage on-premises Windows and Linux virtual machines (VMs) running on Azure Stack HCI clusters (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 11/20/2023
---

# What is Azure Arc VM management? (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article provides a brief overview of the Azure Arc VM management feature on Azure Stack HCI including the benefits, its components, and the high-level workflow.  

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## About Azure Arc VM management
 
Azure Arc VM management lets you provision and manage Windows and Linux VMs hosted in an on-premises Azure Stack HCI environment. This feature enables IT admins create, modify, delete, and assign permissions and roles to app owners thereby enabling self-service VM management.

Administrators can manage Arc VMs on their Azure Stack HCI clusters by using Azure management tools, including Azure portal, Azure CLI, Azure PowerShell, and Azure Resource Manager (ARM) templates. Using [Azure Resource Manager](/azure/azure-resource-manager/management/overview) templates, you can also automate VM provisioning in a secure cloud environment.

To find answers to frequently asked questions about Arc VM management on Azure Stack HCI, see the[FAQ](./azure-arc-vms-faq.yml).

## Benefits of Azure Arc VM management

While Hyper-V provides capabilities to manage your on-premises VMs, Azure Arc VMs offer many benefits over traditional on-premises tools including:

- Role-based access control via builtin Azure Stack HCI roles ensures that only authorized users can perform VM management operations thereby enhancing security. For more information, see [Azure Stack HCI Arc VM management roles](./assign-vm-rbac-roles.md).
- Arc VM management provides the ability to deploy with ARM templates, Bicep, and Terraform.
- The Azure portal acts as a single pane of glass to manage VMs on Azure Stack HCI clusters and Azure VMs. With Azure Arc VM management, you can perform various operations from the Azure portal or Azure CLI including:

  - Create, manage, update, and delete VMs. For more information, see [Create Arc VMs](./create-arc-virtual-machines.md)
  - Create, manage, and delete VM resources such as virtual disks, logical networks, network interfaces, and VM images.

- The self-service capabilities of Arc VM management reduce the administrative overhead.

## Components of Azure Arc VM management


Arc VM Management comprises several components including the Arc Resource Bridge, Custom Location, and the Kubernetes Extension for the VM operator.

- **Arc Resource Bridge**: This lightweight Kubernetes VM connects your on-premises Azure Stack HCI cluster to the Azure Cloud. The Arc Resource Bridge is created automatically when you deploy the Azure Stack HCI cluster. During the deployment, you specify an IP pool from which 3 IP addresses are used for the Arc Resource Bridge. 

    For more information, see the [Arc Resource Bridge overview](/azure/azure-arc/resource-bridge/overview).

- **Custom Location**: Just like the Arc Resource Bridge, a custom location is created automatically when you deploy your Azure Stack HCI cluster. You can use this custom location to deploy Azure services. You can also deploy VMs in these user-defined custom locations, integrating your on-premises setup more closely with Azure.

- **Kubernetes Extension for VM Operator**: Functioning as the on-premises counterpart of the Azure Resource Manager resource provider, this extension is an important component. It imbues your system with all the advanced capabilities of Azure Arc VM Management, ensuring you harness the full potential of Azure's features right on your local infrastructure.

By integrating these components, Azure Arc offers a unified and efficient VM management solution, seamlessly bridging the gap between on-premises and cloud infrastructures.


## Azure Arc VM management workflow

In this release, the Arc VM management workflow is as follows:

1. During the deployment of Azure Stack HCI cluster, one Arc Resource Bridge is installed per cluster and a custom location is also created.
1. [Assign builtin RBAC roles for Arc VM management](./assign-vm-rbac-roles.md).
1. You can then create VM resources such as:
    1. [Storage paths](./create-storage-path.md) for VM disks.
    1. VM images starting with an [Image in Azure Marketplace](./virtual-machine-image-azure-marketplace.md), in [Azure Storage account](./virtual-machine-image-storage-account.md), or in [Local share](./virtual-machine-image-local-share.md). These images are then used with other VM resources to create VMs.
    1. [Logical networks](./create-virtual-networks.md).  
    1. [VM network interfaces](./create-network-interfaces.md).
1. Use the VM resources to [Create VMs](./create-arc-virtual-machines.md).

To troubleshoot issues with your Arc VMs or to learn about existing known issues and limitations, see [Troubleshoot Arc virtual machines](troubleshoot-arc-enabled-vms.md).

## Next steps

- Review [Azure Arc VM management prerequisites](azure-arc-vm-management-prerequisites.md)
