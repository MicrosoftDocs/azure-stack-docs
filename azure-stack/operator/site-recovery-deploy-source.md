---
title: Deploy virtual machines from source environments to Azure Site Recovery on Azure Stack Hub (preview)
description: Learn how to deploy virtual machines in Azure Site Recovery from source machines on Azure Stack Hub. 
author: sethmanheim
ms.author: sethm
ms.topic: how-to
ms.date: 06/08/2023
---


# Deploy for source environments (preview)

This article describes the actions that are required to complete the installation of the source environment.


> [!IMPORTANT]
> Azure Site Recovery on Azure Stack Hub requires the Azure Stack Hub 2301 update build number to be at least 1.2301.2.58.


## Prerequisites

As an Azure Stack Hub operator, download the **ASR appliance on AzureStack Hub** VM image and the respective **Azure Site Recovery –
extensions** in the Azure Stack Hub Marketplace Management.

For a disconnected or partially connected scenario, download the packages to your local machine then import them into your Azure Stack
Hub Marketplace:

1. Follow the instructions in [Download Marketplace items: disconnected or partially connected scenario](/azure-stack/operator/azure-stack-download-azure-marketplace-item?pivots=state-disconnected). Download and run the Marketplace Syndication tool, which enables you to download resource provider packages.
1. After the **Azure Marketplace Items** syndication tool window opens, find and select the name of the resource provider to download the required packages to your local machine.
1. Once the download finishes, import the packages to your Azure Stack Hub instance and publish to the Marketplace.

For a connected scenario, download the items from Azure Marketplace directly to the Azure Stack Hub Marketplace:

1. Sign in to the Azure Stack Hub administrator portal.
1. Select **Marketplace Management**.
1. Select **Marketplace Items**.
1. Select + **Add from Azure**.
1. Search for "Azure Site Recovery" using the search bar.

   :::image type="content" source="media/site-recovery-deploy-source/add-from-azure.png" alt-text="Screenshot of portal add from Azure page." lightbox="media/site-recovery-deploy-source/add-from-azure.png":::

1. The **ASR appliance on AzureStack Hub** is the VM that you must download. Based on the type of VMs you want to protect, select and download the respective **Virtual Machine Extensions** for each of the VM types to be protected.
1. Once the downloads are complete, you are ready to deploy and configure the appliance.

## Installation

In the source environment, in the Azure Stack Hub user subscription, you must now deploy the **ASR appliance on AzureStack Hub**. This is a VM that appears in the Azure Stack Hub Marketplace. Following the template, it creates a VM that has the following properties:

- Size: standard DS4 v2 (8 vcpus, 28 GiB memory). This means that by default, the VM can have 32 data disks attached. This is important when doing a "failback" operation; for example, when having more than 31 disks from protected VMs generates an error (in which case the appliance VM must have its size increased). By default, the Site Recovery appliance itself consumes one disk, and each data disk from a protected VM must be attached.
- Uses a 610 Gib disk.
- Uses a storage account. Appliance boot diagnostics data is stored here.
- After the deployment of the VM completes, sign in through RDP on that VM. This launches a set of PowerShell scripts that install all the requirements for the Site Recovery appliance and prepares the VM to be configured.

To start this process, open the **Microsoft Azure Appliance Configuration Manager** from the desktop of the Site Recovery appliance on Azure Stack Hub. Follow the wizard while using all the data from the vault connection properties, and the appliance is then configured.

> [!NOTE]
> During the configuration of the appliance, you must provide a user (or SPN) which the appliance then uses for discovery. This user (or SPN) must have **owner** rights on these subscriptions, both to discover resources as well as delegate rights as needed. The Site Recovery Vault discovers all the VMs this user (or SPN) has access to, within the respective tenant.

:::image type="content" source="media/site-recovery-deploy-source/appliance-configuration.png" alt-text="Screenshot of portal showing appliance configuration." lightbox="media/site-recovery-deploy-source/appliance-configuration.png":::

## Next steps

- Azure Site Recovery overview
- [Download Marketplace items - Disconnected or partially connected scenario](/azure-stack/operator/azure-stack-download-azure-marketplace-item?pivots=state-disconnected)
