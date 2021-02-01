---
title: Move a VM to Azure Stack Hub
description: Learn about the different ways that you can move a VM to Azure Stack Hub.
author: mattbriggs
ms.topic: conceptual
ms.date: 2/1/2021
ms.author: mabrigg
ms.reviewer: kivenkat
ms.lastreviewed: 9/8/2020

# Intent: As an Azure Stack Hub user, I wan to learn about how where to find more information developing solutions.
# Keywords: migration VM Linux Windows

---

# Move a VM to Azure Stack Hub overview

You can move virtual machines (VM)s from your environment to Azure Stack Hub. There are some limitations that you need to expect when planning to move your workloads. This article lists the requirements for virtual hard disk (VHD)s in Azure Stack Hub. Azure Stack Hub requires a generation one (1) VHD. Your VM will need to be either generalized or specialized. Use generalized VMs as the base-mage for VMS created in Azure Stack. Specialized VM contains user accounts. To migrate, prepare and download the VHD, validate that the VHD meets the requirements, upload the image to a storage account in Azure Stack Hub, and then create the VM in your cloud. If you have a more complex migration task, you can find a complete discussion in the *Migrate to Azure Stack Hub* whitepaper.

Custom images come in two forms: **generalized** and **specialized**.

- **Generalized image**  
  A generalized disk image is one that has been prepared with **Sysprep** to remove any unique information (such as user accounts), enabling it to be reused to create multiple VMs. Generalized VHDs are a good fit for when are creating images that the Azure Stack Hub cloud operator plans to use as marketplace items. Images offered through the administrator portal or administrator endpoints are **platform images**.

- **Specialized image**  
  A specialized disk image is a copy of a virtual hard disk (VHD) from an existing VM that contains the user accounts, applications, and other state data from your original VM. This is typically the format in which VMs are migrated to Azure Stack Hub. Specialized VHDs are a good fit for when you need to migrate VMs from on-premises to Azure Stack Hub.

When moving an image into Azure Stack Hub, consider how you would like to have the image used.

- **Personal workload**  
    You may have a machine in your on-premises environment or in global Azure that you use for development or specific tasks and you would like to take advantage of hosting it in a private cloud with Azure Stack Hub. You you would like to retain the data and user accounts on the machine. You would want to move this machine into the Azure Stack Hub as a specialized image.

- **Golden image**  
    You may want to share a common VM configuration and set of applications within your workgroup. You will not have the need to share the image with users outside of your Azure Stack Hub domain (directory tenant). In this case, you will want to generalize the image by removing data and user accounts. You can then share this image with other users in your tenant.

- **Azure Stack Hub Marketplace offering**  
    Your cloud operator can use generalized image as the basis of a marketplace offering. Once you have prepared your image, your cloud operator can use the custom image to create a marketplace offering for your Azure Stack Hub instance. Users can create their own VM from the image as they would any other offering in the Marketplace. You will need to work with your cloud operator to create this offering.

## Verify VHD requirements

> [!IMPORTANT]  
> When preparing your VHD, you must have the following requirements in place or your will not be able to use your VHD in Azure Stack Hub.
> Before you upload the image, consider the following:
> - Azure Stack Hub only supports images from generation one (1) VMs.
> - VHD is of fixed type. Azure Stack Hub does not support dynamic disk VHDs.
> - VHD has minimum virtual size of at least 20 MB.
> - VHD is aligned, that is, the virtual size must be a multiple of 1 MB.
> - VHD blob length = virtual size + vhd footer length (512). A small footer at the end of the blob describes the properties of the VHD. 

You can find steps to repair your VHD at [Verify your VHD](vm-move-from-azure.md#verify-your-vhd)

## Methods of moving a VM

You can manually move your VM into Azure Stack Hub with the following scenarios:

| Scenario | Instructions |
| --- | --- |
| Global Azure to Azure Stack Hub | Prepare your VHD in global Azure and then upload to Azure Stack Hub. For more information, see [Move a VM from Azure to Azure Stack Hub](vm-move-from-azure.md). |
| Local generalized to Azure Stack Hub | Prepare your VHD and generalize a VHD locally in Hyper-V and then upload to Azure Stack Hub. For more information, see [Move a generalized VM from on-premises to Azure Stack Hub](vm-move-generalized.md). |
| Local specialized to Azure Stack Hub | Prepare your specialized VHD locally in Hyper-V and then upload to Azure Stack Hub. For more information, see [Move a specialized VM from on-premises to Azure Stack Hub](vm-move-specialized.md). |

## Migrate to Azure Stack Hub

You can find details, checklists, and best practices for planning and migrating your workloads in bulk to Azure Stack Hub in a guide written by the AzureCAT experts in Azure Global. The guide focuses on the migration of existing applications that run either on physical servers or on existing virtualization platforms. By moving these workloads to the Azure Stack Hub IaaS environment, teams can benefit from smoother operations, self-service deployments, standardized hardware configurations, and Azure consistency.

[Get the white paper.](https://azure.microsoft.com/resources/migrate-to-azure-stack-hub-patterns-and-practices-checklists/)

You can also find guidance about migration in the Cloud Adoption Framework. For more information, see [Plan your Azure Stack Hub migration](/azure/cloud-adoption-framework/scenarios/azure-stack/plan). 

## Next steps

[Introduction to Azure Stack Hub VMs](azure-stack-compute-overview.md)

[Add a custom VM image to Azure Stack Hub](../operator/azure-stack-add-vm-image.md)