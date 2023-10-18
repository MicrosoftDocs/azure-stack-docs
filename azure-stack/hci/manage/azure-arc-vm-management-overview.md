---
title: What is Azure Arc VM management? (preview)
description: Learn about Azure Arc VM managements to provision and manage on-premises Windows and Linux virtual machines (VMs) running on Azure Stack HCI clusters (preview).
author: alkohli
ms.author: alkohli
ms.topic: how-to
ms.service: azure-stack
ms.subservice: azure-stack-hci
ms.date: 10/18/2023
---

# What is Azure Arc VM management? (preview)

[!INCLUDE [hci-applies-to-23h2](../../includes/hci-applies-to-23h2.md)]

Azure Arc VM management enables you to use the Azure portal to provision and manage Windows and Linux VMs hosted in an on-premises Azure Stack HCI environment. [Azure Arc](https://azure.microsoft.com/services/azure-arc/) enables IT administrators to delegate permissions and roles to app owners and DevOps teams to enable self-service VM management for their Azure Stack HCI clusters by using Azure management tools, including Azure portal, Azure CLI, Azure PowerShell, and ARM templates. Using [Azure Resource Manager](/azure/azure-resource-manager/management/overview) templates, you can automate VM provisioning in a secure cloud environment.

To find answers to frequently asked questions about Arc VMs on Azure Stack HCI, see [FAQs](./azure-arc-vms-faq.yml).

To troubleshoot issues with your Arc VMs or to know existing known issues and limitations, see [Troubleshoot Arc virtual machines](troubleshoot-arc-enabled-vms.md).

[!INCLUDE [hci-preview](../../includes/hci-preview.md)]

## Benefits of Azure Arc VM management

With Azure Arc VM management, you can perform various operations from the Azure portal including:

- Create a VM
- Start, stop, and restart a VM
- Delete a VM
- Control access and add Azure tags
- Add and remove virtual disks and network interfaces
- Update memory and virtual CPUs for the VM

By using the Azure portal, you get the same consistent experience when provisioning and managing on-premises VMs or cloud VMs. You can access your VMs only, not the host fabric, enabling role-based access control and self-service.

QUESTION Even if you delete this section, at a minimum, you must define what is ARB here as the key component of the underlying infra. At the end of the deployment, customers will see the ARB as well as custom location.

## What is Azure Arc Resource Bridge?

A resource bridge is required to enable VM provisioning through the Azure portal on Azure Stack HCI. Azure Arc Resource Bridge is a Kubernetes-backed, lightweight VM that enables users to perform full lifecycle management of resources on Azure Stack HCI from the Azure control plane, including the Azure portal, Azure CLI, and Azure PowerShell. Azure Arc Resource Bridge also creates Azure Resource Manager entities for VM disks, VM images, VM interfaces, VM networks, custom locations, and VM cluster extensions.

  > [!NOTE]
  > To use Arc Resource Bridge side-by-side with Azure Kubernetes Service (for example, to run your container workloads) on the same cluster, there are some limitations that you should be aware of, such as a required deployment order. For a complete list of limitations and known issues, see [Limitations and known issues](troubleshoot-arc-enabled-vms.md#limitations-and-known-issues).  
    
A **custom location** for an Azure Stack HCI cluster is analogous to an Azure region. As an extension of the Azure location construct, custom locations allow tenant administrators to use their Azure Stack HCI clusters as target location for deploying Azure services.

A **cluster extension** is the on-premises equivalent of an Azure Resource Manager resource provider. The Azure Stack HCI cluster extension helps manage VMs on an Azure Stack HCI cluster in the same way that the "Microsoft.Compute" resource provider manages VMs in Azure, for example.

   > [!NOTE]
   > **Arc Appliance** is an earlier name for Arc Resource Bridge, and you may see the term used in some places like the PowerShell commands or on the Azure portal. The feature has also been called self-service VMs in the past; however, this is only one of the several capabilities available with Arc-enabled Azure Stack HCI.

## Azure Arc VM management deployment workflow

To enable Azure Arc-based VM operations on your Azure Stack HCI system, you must:

1. Have access to an Azure Stack HCI system that is deployed and registered with Azure. During the deployment, an Arc Resource Bridge and a custom location are also created.
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

## Next steps

- Review [Azure Arc VM management prerequisites](azure-arc-vm-management-prerequisites.md)
