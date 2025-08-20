---
title: Offer Commvault marketplace item in Azure Stack | Microsoft Docs
description: Deploy Commvault from Azure Stack Marketplace
services: azure-stack
author: sethmanheim
manager: lizross
ms.service: azure-stack
ms.topic: article
ms.date: 06/15/2021
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 12/14/2019

---

# Offer Commvault marketplace item in Azure Stack

*Applies to: Modular Data Center, Azure Stack Hub ruggedized*

Commvault supports backup and restore of the following resource types on Azure Stack Hub:

- VM level backup
  - IaaS VM
  - Unmanaged disks
  - Managed disks
  - For more information, see [Backing Up Virtual Machines](https://docs.metallic.io/metallic/configuring_backups_for_hyper_v_virtual_machines.html).

- Storage account backup
  - Blob
  - For more information, see [Azure Blob Storage Overview](https://docs.metallic.io/metallic/azure_blob_storage.html).

- Agent-based backup
  - Guest OS -- Windows and Linux
  - Application -- SQL, MySQL
  - For more information, see [Backup Agents](https://documentation.commvault.com/2023e/essential/application_based_backups_for_virtual_server_agent.html).

You can deploy Commvault on an external machine and protect resources on Azure Stack Hub remotely. In addition, it is possible to deploy Commvault as a virtual appliance on Azure Stack Hub. Complete guidance from Commvault is available on their documentation site that covers [Azure Stack Hub](https://documentation.commvault.com/2023e/essential/azure_stack_hub.html). For reference, Commvault also publishes a [complete list of capabilities for Microsoft Azure](https://docs.metallic.io/metallic/index.html).

## Deploy from Azure Stack Hub Marketplace

Commvault publishes a BYOL image in the Azure Marketplace and enables the image for syndication to Azure Stack Hub. The minimum version required to back up VMs on Azure Stack is SP16. If you plan to use a virtual appliance, make sure to update to at SP16 (the latest [long-term supported release](https://www.cdw.com/content/cdw/en/brand/commvault.html)) or SP17 (the latest mainstream release available).

| Cloud        | Version | Available for syndication | Next update |
|--------------|---------|---------------------------|-------------|
| Azure public | SP13    | Yes                       | TBD         |
| Azure Gov    | SP13    | TBD                       | TBD         |

## Download from Azure Marketplace

Azure Stack Hub operators can download items to the local Azure Stack Marketplace for connected and disconnected environments. In a connected environment, the operator can browse the list of available items to add from Azure:

![Add from Azure](media/azure-stack-commvault-offer-tzl/add-from-azure.png)

## Upload and publish manually

In disconnected environments, the item must be downloaded from Azure, and then uploaded to Azure Stack Hub manually. For more information, see the [full instructions for connected and disconnected environments](../../operator/azure-stack-download-azure-marketplace-item.md).

## Deployment considerations

- Deploy external to Azure Stack Hub
- Deploy as virtual appliance on Azure Stack Hub
- Disk Library vs Cloud Library
- Network line of sight consideration
- Subscription level isolation

## Next steps

- To learn more about protecting IaaS VMs, see Protecting VMs on Azure Stack Hub.
