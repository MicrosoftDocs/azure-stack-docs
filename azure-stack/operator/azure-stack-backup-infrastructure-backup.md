---
title: Recover data in Azure Stack Hub with the Infrastructure Backup Service | Microsoft Docs
description: Learn how to back up and restore configuration and service data in Azure Stack Hub using the Infrastructure Backup Service.
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila

ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/16/2019
ms.author: justinha
ms.reviewer: hectorl
ms.lastreviewed: 05/16/2019

---
# Recover data in Azure Stack Hub with the Infrastructure Backup Service

You can back up and restore configuration and service data using the Azure Stack Hub Infrastructure Backup Service. Each Azure Stack Hub installation contains an instance of the service. You can use backups created by the service for the redeployment of the Azure Stack Hub cloud to restore identity, security, and Azure Resource Manager data.

Enable backup when you're ready to put your cloud into production. Don't enable backup if you plan to perform testing and validation for a long period of time.

Before you enable your backup service, make sure you have the [requirements in place](#verify-requirements-for-the-infrastructure-backup-service).

> [!Note]  
> The Infrastructure Backup Service doesn't include user data and apps. For more info on how to protect IaaS VM-based apps, see [protect VMs deployed on Azure Stack Hub](../user/azure-stack-manage-vm-protect.md). For a comprehensive understanding of how to protect apps on Azure Stack Hub, see the [Azure Stack Hub considerations for business continuity and disaster recovery whitepaper](https://aka.ms/azurestackbcdrconsiderationswp).

## The Infrastructure Backup Service

The service contains the following features:

| Feature                                            | Description                                                                                                                                                |
|----------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Backup Infrastructure Services                     | Coordinate backup across a subset of infrastructure services in Azure Stack Hub. If there's a disaster, the data can be restored as part of redeployment. |
| Compression and encryption of exported backup data | Backup data is compressed and encrypted by the system before it's exported to the external storage location provided by the admin.                |
| Backup job monitoring                              | System notifies you when backup jobs fail and how to fix the problem.                                                                                                |
| Backup management experience                       | Backup RP supports enabling backup.                                                                                                                         |
| Cloud recovery                                     | If there's a catastrophic data loss, backups can be used to restore core Azure Stack Hub info as part of deployment.                                 |

## Verify requirements for the Infrastructure Backup Service

- **Storage location**  
  You need a file share accessible from Azure Stack Hub that can contain seven backups. Each backup is about 10 GB. Your share should be able to store 140 GB of backups. For more info on selecting a storage location for the Infrastructure Backup Service, see [Backup Controller requirements](azure-stack-backup-reference.md#backup-controller-requirements).
- **Credentials**  
  You need a domain user account and credentials. For example, you can use your Azure Stack Hub admin credentials.
- **Encryption certificate**  
  Backup files are encrypted using the public key in the certificate. Make sure to store this certificate in a secure location. 


## Next steps

Learn how to [Enable Backup for Azure Stack Hub from the administrator portal](azure-stack-backup-enable-backup-console.md).

Learn how to [Enable Backup for Azure Stack Hub with PowerShell](azure-stack-backup-enable-backup-powershell.md).

Learn how to [Back up Azure Stack Hub](azure-stack-backup-back-up-azure-stack.md).

Learn how to [Recover from catastrophic data loss](azure-stack-backup-recover-data.md).
