---
title: Move a VM to Azure Stack Hub
description: Learn about the different ways that you can move a VM to Azure Stack Hub.
author: mattbriggs
ms.topic: article
ms.date: 8/24/2020
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 8/24/2020

# Intent: As an Azure Stack Hub user, I wan to learn about how where to find more information developing solutions.
# Keywords: Develop solutions with Azure Stack Hub

---

# Move a VM to Azure Stack Hub Overview

You can move virtual machines (VM)s from your environment to Azure Stack Hub. There some limitations that you need to expect when planning to move your workloads. Azure Stack Hub requires a generation 1 virtual hard disk (VHD). Your VM will need to be either generalized or specialized. Use generalized VMs as the base-mage for VMS created in Azure Stack. Specialized VM contains user accounts. To migrate, prepare and download the VHD, upload the image to a storage account in Azure Stack Hub, and then create the VM in your cloud.

Custom images come in two forms: **generalized** and **specialized**.

- **Generalized image**

  A generalized disk image is one that has been prepared with **Sysprep** to remove any unique information (such as user accounts), enabling it to be reused to create multiple VMs. Generalized VHDs are a good fit for when are creating images that the Azure Stack Hub cloud operator plans to use as marketplace items.

- **Specialized image**

  A specialized disk image is a copy of a virtual hard disk (VHD) from an existing VM that contains the user accounts, applications, and other state data from your original VM. This is typically the format in which VMs are migrated to Azure Stack Hub. Specialized VHDs are a good fit for when you need to migrate VMs from on-premises to Azure Stack Hub.

Before you upload the image, consider the following:

- Azure Stack Hub only supports generation 1 VMs in the fixed disk VHD format. The fixed-format structures the logical disk linearly within the file, so that disk offset **X** is stored at blob offset **X**. A small footer at the end of the blob describes the properties of the VHD. To confirm if your disk is fixed, use the **Get-VHD** PowerShell cmdlet.

- Azure Stack Hub does not support dynamic disk VHDs.

## Methods of moving a VM

You can manually move your VM into Azure Stack Hub with the following scenarios:

| Scenario | Instructions |
| --- | --- |
| global Azure to Azure Stack Hub | Prepare your VHD in global Azure and then upload to Azure Stack Hub. For more information, see [Move a VM from Azure to Azure Stack Hub](vm-move-vm-from-azure.md). |
| local generalized to Azure Stack Hub | Prepare your VHD and generalize a VHD locally in Hyper-V and then upload to Azure Stack Hub. For more information, see [Move a generalized VM from on-premises to Azure Stack Hub](vm-move-vm-generalized.md). |
| local specialized to Azure Stack Hub | Prepare your specialized VHD locally in Hyper-V and then upload to Azure Stack Hub. For more information, see [Move a specialized VM from on-premises to Azure Stack Hub](vm-move-vm-specialized.md). |

## Migrate to Azure Stack Hub: Patterns and practices checklists

You can find details, checklists, and best practices for planning and migrating your workloads in bulk to Azure Stack Hub in a guide written by the AzureCAT experts in Azure Global. The guide focuses on the migration of existing applications that run either on physical servers or on existing virtualization platforms. By moving these workloads to the Azure Stack Hub IaaS environment, teams can benefit from smoother operations, self-service deployments, standardized hardware configurations, and Azure consistency.

[Get the white paper.](https://azure.microsoft.com/resources/migrate-to-azure-stack-hub-patterns-and-practices-checklists/)

## Next steps

[Introduction to Azure Stack Hub VMs](azure-stack-compute-overview.md)

[Add a custom VM image to Azure Stack Hub](../operator/azure-stack-add-vm-image.md)