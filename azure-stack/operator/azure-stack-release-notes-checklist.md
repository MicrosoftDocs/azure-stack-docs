---
title: Azure Stack release notes - update activity checklist | Microsoft Docs
description: Quick checklist to prepare your system for the latest Azure Stack update.
services: azure-stack
documentationcenter: ''
author: sethmanheim
manager: femila
editor: ''

ms.assetid:  
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 04/10/2019
ms.author: sethm
ms.reviewer: ''
ms.lastreviewed: 04/10/2019

---

# Azure Stack update activity checklist

This article contains a checklist of update-related activities for Azure Stack operators. If you are getting ready to apply an update to Azure Stack, you can review this information.

## Prepare for Azure Stack update

| Activity              | Details                                                                          |
|-----------------------|----------------------------------------------------------------------------------|
| Review known issues   | [List of known issues](azure-stack-release-notes-known-issues-1904.md)                |
| Review security updates | [List of security updates](azure-stack-release-notes-security-updates-1904.md)      |
| Run Test-AzureStack   | Run *Test-AzureStack -Group UpdateReadiness* to identify operational issues      |
| Resolve issues        | Resolve any operational issues identified by Test-AzureStack                     |
| Apply latest hotfixes | Apply the latest hotfixes that apply to the currently installed release.         |
| (activity)            | (details)                                                                        |

## During Azure Stack update

| Activity              | Details                                                                          |
|-----------------------|----------------------------------------------------------------------------------|
| Monitor the update        | [Monitor updates in Azure Stack using the privileged endpoint](azure-stack-monitor-update.md) |
| Resume updates        | [Monitor updates in Azure Stack using the privileged endpoint](azure-stack-monitor-update.md) |                     |

> [!IMPORTANT]  
> Do not run **Test-AzureStack** during an update, as this will cause the update to stall.

## After Azure Stack update

<!-- | Activity              | Details                                                                          |
|-----------------------|----------------------------------------------------------------------------------|
| Apply latest hotfixes | Apply the latest hotfixes applicable to updated version.                          |
| Retrieve encryption keys | Retrieve the data at rest encryption keys and securely store them outside of your Azure Stack deployment. Follow the [instructions on how to retrieve the keys](azure-stack-security-bitlocker.md). |
| (activity)            | (details)                                                                        | -->

## Next steps

- [Review list of known issues](azure-stack-release-notes-known-issues-1904.md)
- [Review list of security updates](azure-stack-release-notes-security-updates-1904.md)
