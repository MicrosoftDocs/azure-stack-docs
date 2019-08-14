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
ms.date: 08/15/2019
ms.author: sethm
ms.reviewer: hectorl
ms.lastreviewed: 08/15/2019

---

# Azure Stack update activity checklist

This article contains a checklist of update-related activities for Azure Stack operators. If you are preparing to apply an update to Azure Stack, you can review this information.

## Prepare for Azure Stack update

| Activity                     | Details                                                   |
|------------------------------|-----------------------------------------------------------|
| Review known issues     | [List of known issues](azure-stack-release-notes-known-issues-1908.md).                |
| Review security updates | [List of security updates](azure-stack-release-notes-security-updates.md).      |
| Apply latest OEM package | Contact your OEM to ensure your system meets the minimum OEM Package requirements for the Azure Stack version your system is being updated to. |
| Run Test-AzureStack     | Run `Test-AzureStack -Group UpdateReadiness` to identify operational issues.      |
| Resolve issues          | Resolve any operational issues identified by **Test-AzureStack**.                |
| Apply latest hotfixes   | Apply the latest hotfixes that apply to the currently installed release.         |
| Run capacity planner tool   | Make sure to use the latest version of the [Azure Stack Capacity Planner](https://aka.ms/azstackcapacityplanner) tool to perform your workload planning and sizing. The latest version contains bug fixes and provides new features that are released with each Azure Stack update. |
| Update available        | In connected scenarios only, Azure Stack deployments periodically check a secured endpoint and automatically notify you if an update is available for your cloud. Disconnected customers can download and import the new 1906 package using the  [process described here](azure-stack-apply-updates.md). |


## During Azure Stack update

| Activity              | Details                                                                          |
|-----------------------|----------------------------------------------------------------------------------|
| Manage the update         | [Manage updates in Azure Stack using the operator portal](azure-stack-updates.md). |
| Monitor the update        | If the operator portal is unavailable, [monitor updates in Azure Stack using the privileged endpoint](azure-stack-monitor-update.md). |
| Resume updates            | After remediating a failed update, [resume updates in Azure Stack using the privileged endpoint](azure-stack-monitor-update.md). |

> [!IMPORTANT]  
> Do not run **Test-AzureStack** during an update, as this will cause the update to stall.

## After Azure Stack update

| Activity              | Details                                                                          |
|-----------------------|----------------------------------------------------------------------------------|
| Apply latest hotfixes | Apply the latest hotfixes applicable to updated version.                          |
| Retrieve encryption keys | Retrieve the data at rest encryption keys and securely store them outside of your Azure Stack deployment. Follow the [instructions on how to retrieve the keys](azure-stack-security-bitlocker.md). |
| Re-enable multi-tenancy | In case of a multi-tenanted Azure Stack, [make sure you configure all guest directory tenants](https://docs.microsoft.com/azure-stack/operator/azure-stack-enable-multitenancy#configure-guest-directory) after a successful update. |

## Next steps

- [Review list of known issues](azure-stack-release-notes-known-issues-1908.md)
- [Review list of security updates](azure-stack-release-notes-security-updates.md)
