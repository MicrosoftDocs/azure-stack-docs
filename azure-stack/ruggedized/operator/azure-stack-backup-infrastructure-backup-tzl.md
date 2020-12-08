---
title: Recover data in Azure Stack with the Infrastructure Backup Service | Microsoft Docs
description: Learn how to back up and restore configuration and service data in Azure Stack using the Infrastructure Backup Service.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila

ms.service: azure-stack
ms.workload: tzl
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 07/29/2020
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 07/29/2020

---

# Recover data in Azure Stack with the Infrastructure Backup Service

*Applies to: Modular Data Center and Azure Stack Hub ruggedized*

You can back up infrastructure service metadata using the Azure Stack Infrastructure Backup Service. These backups are used to remediate degraded infrastructure services. The backup only includes data from infrastructure services internal to the system. The backup data does not include user and application data. User and application data must be protected separately.

By default, infrastructure backup is enabled at deployment time. These backups are stored internal to the system and only accessible during advanced support cases. If the system has access to an external storage location, the infrastructure backup service can be instructed to export a backup to that storage location as a secondary copy.

Before you enable your backup service, make sure you have the [requirements in place](../../operator/azure-stack-backup-reference.md#backup-controller-requirements).

> [!NOTE]
> The Infrastructure Backup Service doesn't include user data and apps. For more info about how to protect IaaS VM-based apps, see the following articles:
>
> - [Protect VMs deployed on Azure Stack](../../user/azure-stack-manage-vm-protect.md)
> - Protect Event Hubs time series data on Azure Stack
> - Protect blob data on Azure Stack

## The Infrastructure Backup Service

The service contains the following features:

| Feature                                            | Description                                                                                                                                                |
|----------------------------------------------------|------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Backup Infrastructure Services                     | Coordinates backup across a subset of infrastructure services in Azure Stack. |
| Compression and encryption of backup data | Backup data is compressed and encrypted by the system before it\'s stored internally or exported to the external storage location provided by the operator.                |
| Backup job monitoring                              | System notifies you when backup jobs fail and how to fix the problem.                                                                                                |

## Verify requirements for the Infrastructure Backup Service

- **Storage location**
  If there is reliable access to an external storage location, you need a file share accessible from the Azure Stack infrastructure that can store multiple backups. For more information about selecting a storage location for the Infrastructure Backup Service, see [Backup Controller requirements]((../../operator/azure-stack-backup-reference.md#backup-controller-requirements).

- **Credentials**
  You need user account credentials that can access the storage location.

## Next steps

- Learn how to [Enable Backup for Azure Stack from the administrator portal](../../operator/azure-stack-backup-enable-backup-console.md).

- Learn how to [Enable Backup for Azure Stack with PowerShell](../../operator/azure-stack-backup-enable-backup-powershell.md).
