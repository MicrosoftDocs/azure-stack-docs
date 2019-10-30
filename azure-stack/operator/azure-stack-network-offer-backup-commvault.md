---
title: Add Commvault to the Azure Stack Marketplace | Microsoft Docs
description: Learn how to add Commvault to the Azure Stack Marketplace.
services: azure-stack
documentationcenter: ''
author: mattbriggs
manager: femila
editor: ''

ms.service: azure-stack
ms.workload: na
pms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/28/2019
ms.author: mabrigg
ms.reviewer: sijuman
ms.lastreviewed: 10/28/2019

---

# Add Commvault to the Azure Stack Marketplace

*Applies to: Azure Stack integrated systems and Azure Stack Development Kit*

This article walks through offering Commvault Live Sync to update a recovery VM located on a separate Azure Stack scale unit. You can download and offer Commvault as a backup and replication solution for your users. 

## Notes for Commvault

- Your user needs to install the backup and replication software on a VM in their the Source Azure Stack subscription. Azure Site Recovery and Azure Backup can offer an off-Stack location to store your backups and recovery images. They both require the creation of a Recovery Services Vault in Azure prior to downloading the software images to be installed on your Azure Stack from the following locations: [Azure Backup Server](https://go.microsoft.com/fwLink/?LinkId=626082&clcid=0x0409) and [Azure Site Recovery](https://aka.ms/unifiedinstaller_eus).  
    
- You may need licenses for third Party Software (if chosen).
- Your users may need assistant in connecting their source and target through a Virtual Network Gateway (VPN) or Public IP on the backup and replication host.
- Target Azure Cloud subscription or subscription on a Recovery Target Azure Stack.
- Target resource group and Blob Storage Account on a Recovery Target Azure Stack.
- Some solutions require that you create virtual machines in the target subscription that need to run 24x7x365 in order to receive changes from the source server. In the [Back up your VM on Azure Stack with Commvault](../user/azure-stack-network-howto-backup-commvault.md), Commvault Live Sync creates the target recovery VMs during initial configuration and keeps them idle (not running, not billable) until changes need to be applied during a replication cycle.


## Get Commvault for your Marketplace

1. Open the Azure Stack Administrative portal.
2. Select **Marketplace management** > **Add from Azure**.

    ![Commvault for Azure Stack](./media/azure-stack-network-offer-backup-commvault/get-commvault-for-marketplace.png)

3. Enter `commvault`.
4. Select **Commvault Trail**. And then select **Download**.


## Next steps

[Back up your VM on Azure Stack with Commvault](../user/azure-stack-network-howto-backup-commvault.md)

[Overview of offering services in Azure Stack](service-plan-offer-subscription-overview.md)
