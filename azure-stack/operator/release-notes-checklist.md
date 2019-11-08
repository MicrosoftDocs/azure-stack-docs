---
title: Azure Stack update activity checklist | Microsoft Docs
description:  Checklist to prepare your system for the latest Azure Stack update.
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
ms.date: 11/07/2019
ms.author: sethm
ms.reviewer: ppacent
ms.lastreviewed: 11/07/2019

---

# Azure Stack update activity checklist

*Applies to: Azure Stack integrated systems*

Review this checklist in order to prepare for an Azure Stack update. This article contains a checklist of update-related activities for Azure Stack operators.

## Prepare for Azure Stack update

| Activity                     | Details                                                   |
|------------------------------|-----------------------------------------------------------|
| Review known issues     | [List of known issues](known-issues.md).                |
| Review security updates | [List of security updates](release-notes-security-updates.md).      |
| Apply latest OEM package | Contact your OEM to ensure your system meets the minimum OEM Package requirements for the Azure Stack version your system is being updated to. Ensure your OEM package is compatible with the Azure Stack version you are updating to. If your OEM package is not compatible with the Azure Stack version you are updating to, you will need to perform an OEM package update before running an Azure Stack update. For instructions, see "Apply Azure Stack original equipment manufacturer (OEM) updates." |
| Apply latest hotfixes | Apply the latest hotfixes that apply to the currently installed release. For a list of the latest hotfixes, see the release notes Hotfix section. |
| Run capacity planner tool | Make sure to use the latest version of the [Azure Stack Capacity Planner tool](azure-stack-capacity-planning-overview.md) to perform your workload planning and sizing. The latest version contains bug fixes and provides new features that are released with each Azure Stack update. |
| Run Test-AzureStack | Run `Test-AzureStack -Group UpdateReadiness` to identify operational issues. The cmdlet is accessible through the  Privileged Endpoint Session (PEP). For more information, see [Validate Azure Stack system state](azure-stack-diagnostic-test.md). |
| Resolve issues | Resolve any operational issues identified by `Test-AzureStack`. |
| Update available | In connected scenarios only, Azure Stack deployments periodically check a secured endpoint and automatically notify you if an update is available for your cloud. Disconnected customers can download and import new packages using the [process described here](azure-stack-apply-updates.md). |
| Notify your users | You should notify users of any maintenance operations, and that you schedule normal maintenance windows during non-business hours if possible. Maintenance operations can affect both tenant workloads and portal operations. |

## During Azure Stack update

| Activity | Details |
|--------------------|------------------------------------------------------------------------------------------------------|
| Manage the update |[Manage updates in Azure Stack using the operator portal](azure-stack-updates.md). |
|  |  |
| Monitor the update | If the operator portal is unavailable, [monitor updates in Azure Stack using the privileged endpoint](azure-stack-monitor-update.md). |
|  |  |
| Resume updates | After remediating a failed update, [resume updates in Azure Stack using the privileged endpoint](azure-stack-monitor-update.md). |

> [!Important]  
> Do not run **Test-AzureStack** during an update, as this will cause the update to stall.

## After Azure Stack update

| Activity | Details |
|--------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Apply latest hotfixes | Apply the latest hotfixes applicable to the updated version. |
| Retrieve encryption keys | Retrieve the data at rest encryption keys and securely store them outside of your Azure Stack deployment. Follow the [instructions on how to retrieve the keys](azure-stack-security-bitlocker.md). |
|  |  |
| Re-enable multi-tenancy | In case of a multi-tenanted Azure Stack, [make sure you configure all guest directory tenants](azure-stack-enable-multitenancy.md#configure-guest-directory) after a successful update. |

## Next steps

- [Review list of known issues](known-issues.md)
- [Review list of security updates](release-notes-security-updates.md)
