---
title: Offer a Red Hat-based virtual machine for Azure Stack Hub 
titleSuffix: Azure Stack Hub
description: Learn to create and upload an Azure virtual hard disk (VHD) that contains a Red Hat Linux operating system.
author: sethmanheim
ms.topic: article
ms.date: 2/18/2021
ms.author: sethm
ms.reviewer: kivenkat
ms.lastreviewed: 2/18/2021

# Intent: As an Azure Stack operator, I want to prepare a red hat-based virtual machine for Azure Stack.
# Keyword: red hat operating system azure stack

---
# Offer a Red Hat-based virtual machine for Azure Stack Hub

This article describes how to prepare a Red Hat Enterprise Linux virtual machine (VM) for use in Azure Stack Hub. 

## Offer a Red Hat-based VM

There are two ways that you can offer Red Hat-based VM in Azure Stack Hub:

- You can add offer the machine through the Azure Stack Hub Marketplace. 
    - Red Hat Enterprise Linux Images are a private offering on Azure Stack Hub. To make this offering available to your **Marketplace Management** tab, you will need to [complete a a survey](https://forms.office.com/pages/responsepage.aspx?id=v4j5cvGGr0GRqy180BHbR_e32WQju3tMrgXNcUR94AVUNkJTWjdQRjc3TzFLREdGU0dIVFRUQ1JCSi4u).
    - For more information, see [Azure Stack Hub Marketplace overview](azure-stack-marketplace.md).
- You can add your own custom to your Azure Stack Hub and then offer the image in the Marketplace. 
    1. You will need to have Red Hat cloud access.
    2. For instructions on preparing the image for Azure and Azure Stack Hub, see [Prepare a Red Hat-based virtual machine for Azure](/azure/virtual-machines/linux/redhat-create-upload-vhd).
    3. For instructions on offering your custom image in the Azure Stack Hub Marketplace, see [Create and publish a Marketplace item](azure-stack-create-and-publish-marketplace-item.md).

## Next steps

For more information about the hypervisors that are certified to run Red Hat Enterprise Linux, see [the Red Hat website](https://access.redhat.com/certified-hypervisors).