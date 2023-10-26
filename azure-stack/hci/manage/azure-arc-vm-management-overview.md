---
title: What is Azure Arc VM management? (preview)
description: Learn about Azure Arc VM managements to provision and manage on-premises Windows and Linux virtual machines (VMs) running on Azure Stack HCI clusters (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/25/2023
---

# What is Azure Arc VM management? (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

This article provides a brief overview of the Azure Arc VM management feature on Azure Stack HCI including the benefits, its components, and the high-level workflow.  

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## About Azure Arc VM management
 
Azure Arc VM management lets you provision and manage Windows and Linux VMs hosted in an on-premises Azure Stack HCI environment. This feature also helps IT admins create and assign permissions and roles to app owners thereby enabling self-service VM management. 

Administrators can manage Arc VMs on their Azure Stack HCI clusters by using Azure management tools, including Azure portal, Azure CLI, Azure PowerShell, and Azure Resource Manager (ARM) templates. Additionally, you can automate VM provisioning via the [Azure Resource Manager](/azure/azure-resource-manager/management/overview) templates in a secure cloud environment.

To find answers to frequently asked questions about Arc VM management on Azure Stack HCI, see the[FAQ](./azure-arc-vms-faq.yml).

## Benefits of Azure Arc VM management

Arc VM management offers the following benefits:

- The Azure portal provides a single pane of glass to manage VMs on Azure Stack HCI clusters and Azure VMs.
- With Azure Arc VM management, you can perform various operations from the Azure portal or Azure CLI including:

  - Create, manage, update, and delete VMs.
  - Create, manage, and delete VM resources such as virtual disks, virtual networks, virtual network interfaces, and VM images.

- Role-based access control via builtin Azure Stack HCI roles ensures that only authorized users can perform VM management operations thereby enhancing security. For more information, see [Azure Stack HCI Arc VM management roles](./assign-vm-rbac-roles.md).
- The self-service capabilities of Arc VM management reduce the administrative overhead.

## Components of Azure Arc VM management


Arc VM Management comprises of several components including the Arc Resource Bridge, Custom Location, and the Kubernetes Extension for the VM operator. 

- **Arc Resource Bridge**: This lightweight Kubernetes VM connects your on-premises Azure Stack HCI cluster to the Azure Cloud. The Arc Resource Bridge is created automatically when you deploy the Azure Stack HCI cluster. During the deployment, you specify an IP pool from which 3 IP addresses are used for the Arc Resource Bridge.

- **Custom Location**: Just like the Arc Resource Bridge, a custom location is created automatically when you deploy your Azure Stack HCI cluster. You can use this custom location to deploy Azure services. You can also deploy VMs in these user-defined custom locations, integrating your on-premises setup more closely with Azure. 

- **Kubernetes Extension for VM Operator**: Functioning as the on-prem counterpart of the Azure Resource Manager resource provider, this extension is an important component. It imbues your system with all the advanced capabilities of Azure Arc VM Management, ensuring you harness the full potential of Azure's features right on your local infrastructure. 

By integrating these components, Azure Arc offers a unified and efficient VM management solution, seamlessly bridging the gap between on-premises and cloud infrastructures

A resource bridge is required to enable VM provisioning through the Azure portal on Azure Stack HCI. Azure Arc Resource Bridge is a Kubernetes-backed, lightweight VM that enables users to perform full lifecycle management of resources on Azure Stack HCI from the Azure control plane, including the Azure portal, Azure CLI, and Azure PowerShell. Azure Arc Resource Bridge also creates Azure Resource Manager entities for VM disks, VM images, VM interfaces, VM networks, custom locations, and VM cluster extensions.

  
    
A **custom location** for an Azure Stack HCI cluster is analogous to an Azure region. As an extension of the Azure location construct, custom locations allow tenant administrators to use their Azure Stack HCI clusters as target location for deploying Azure services.

A **cluster extension** is the on-premises equivalent of an Azure Resource Manager resource provider. The Azure Stack HCI cluster extension helps manage VMs on an Azure Stack HCI cluster in the same way that the "Microsoft.Compute" resource provider manages VMs in Azure, for example.


## Azure Arc VM management deployment workflow

With the introduction of HCI version 23H2, activating Azure Arc-enabled VM operations has been streamlined. The process is initiated by default during the HCI cluster creation, employing the combined capabilities of the Lifecycle Manager (LCM) for a more integrated and efficient setup. One Arc Resource Bridge is installed per cluster with one custom location automatically during the deployment
To enable Azure Arc-based VM operations on your Azure Stack HCI system, you must:

1. Have access to an Azure Stack HCI system that is deployed and registered with Azure. During the deployment, one Arc Resource Bridge is installed per cluster and a custom location is also created.
1. Create VM resources such as:
    1. Storage paths for VM disks.
    1. VM images starting with an image in Azure Marketplace, in Azure Storage account, or in local share. These images are then used with other VM resources to create VMs.
    1. Virtual networks.  
    1. VM network interfaces.
1. Use the VM resources to create VMs.


### Additional considerations

- REMOVE? Only one Arc Resource Bridge can be deployed on a cluster.
- REMOVE? Each Azure Stack HCI cluster can have only one custom location.
- Multiple OS images can be added to the gallery.
- Additional virtual networks and images can be added any time after the initial setup.




To troubleshoot issues with your Arc VMs or to know existing known issues and limitations, see [Troubleshoot Arc virtual machines](troubleshoot-arc-enabled-vms.md).

## Next steps

- Review [Azure Arc VM management prerequisites](azure-arc-vm-management-prerequisites.md)
