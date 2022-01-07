---
title: Offer a Red Hat-based virtual machine for Azure Stack Hub 
titleSuffix: Azure Stack Hub
description: Learn to create and upload an Azure virtual hard disk (VHD) that contains a Red Hat Linux operating system.
author: sethmanheim
ms.topic: article
ms.date: 07/22/2021
ms.author: sethm
ms.reviewer: unknown
ms.lastreviewed: 3/3/2021

# Intent: As an Azure Stack operator, I want to prepare a red hat-based virtual machine for Azure Stack.
# Keyword: red hat operating system azure stack

---
# Offer a Red Hat-based virtual machine for Azure Stack Hub

This article describes how to prepare a Red Hat Enterprise Linux virtual machine (VM) for use in Azure Stack Hub.

## Offer a Red Hat-based VM

There are two ways that you can offer Red Hat-based VM in Azure Stack Hub:

- You can add the virtual machine to the Azure Stack Hub Marketplace.
  - Get familiar with the [Red Hat Cloud Access program](https://www.redhat.com/en/technologies/cloud-computing/cloud-access) terms. Enable your Red Hat subscriptions for Cloud Access at [Red Hat Subscription-Manager](https://access.redhat.com/management/cloud). To be registered for Cloud Access, you must have on hand the Azure subscriptions with which your Azure Stack Hub is registered.
  - Red Hat Enterprise Linux Images are a private offering on Azure Stack Hub. To make this offering available to your **Marketplace Management** tab, you will need to [complete a survey](https://forms.office.com/r/F10XvmPLVw). After you post the survey, it takes seven business days to see it in your **Add from Azure** tab within Marketplace Management.
  - For more information, see the [Azure Stack Hub Marketplace overview](azure-stack-marketplace.md).
- You can add your own custom image to your Azure Stack Hub, and then offer the image in the Marketplace.
  1. You must have Red Hat cloud access.
  2. For instructions on preparing the image for Azure and Azure Stack Hub, see [Prepare a Red Hat-based virtual machine for Azure](/azure/virtual-machines/linux/redhat-create-upload-vhd).
  3. For instructions on offering your custom image in the Azure Stack Hub Marketplace, see [Create and publish a Marketplace item](azure-stack-create-and-publish-marketplace-item.md).

## Next steps

For more information about the hypervisors that are certified to run Red Hat Enterprise Linux, see [the Red Hat website](https://access.redhat.com/certified-hypervisors).
