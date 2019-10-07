---
title: Azure Stack operations checklist | Microsoft Docs
description: Learn common tasks that Azure Stack operators need to do and how often to do them.
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila
editor: ''

ms.assetid:  
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: PowerShell
ms.topic: conceptual
ms.date: 10/07/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 10/07/2019

---

# Azure Stack operator's checklist

We put together some operations checklists so Azure Stack operators be successful. You can add specific operations that need to be done for your environment. They're meant to help someone onboarding as an operator know what to do daily, weekly, and monthly. 

## Routine daily, weekly, and monthly operations

Azure Stack operators need to do the following things routinely: 

> [!div class="checklist"]
> * Monitor and remediate errors in [Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/overview) and [Systen Center Operations Manager](https://docs.microsoft.com/system-center/scom/welcome) twice daily
> * Run [Test-AzureStack](azure-stack-diagnostic-test.md) once daily
> * Report [Azure Stack usage](azure-stack-usage-reporting.md) weekly 
> * Update [OEM firmware](azure-stack-update-oem.md) every two months or as notified by the OEM
> * Prepare [Azure Stack updates](release-notes-checklist.md) monthly

## Day-to-day operations as needed

Azure Stack operators will also need to do these things as needed from day-to-day: 

> [!div class="checklist"]
> * Create [plans](azure-stack-create-plan.md)
> * Create [offers](azure-stack-create-offer.md)
> * Create [subscriptions](azure-stack-subscribe-plan-provision-vm.md)
> * Update [quotas](azure-stack-quota-types.md)
> * Publish [marketplace samples](azure-stack-create-and-publish-marketplace-item.md)
> * Add a [custom virtual machine image](azure-stack-add-vm-image.md)
> * Offer [virtual machine scale sets](azure-stack-compute-add-scalesets.md) 
> * Apply [marketplace updates](azure-stack-marketplace-changes.md)
> * Configure [telemetry](azure-stack-telemetry.md)
> * Review [region management](azure-stack-region-management.md)
> * Shut down or [restart Azure Stack services](azure-stack-start-and-stop.md) 
> * Replace a [scale unit node](azure-stack-replace-node.md)
> * Replace a [physical disk](azure-stack-replace-disk.md)
> * Replace a [hardware component](azure-stack-replace-component.md)
> * Update add-on resource providers such as [SQL](azure-stack-sql-resource-provider-update.md), [MySQL](azure-stack-mysql-resource-provider-update.md), and the [App Service](azure-stack-app-service-update.md)
> * Run [diagnostic log collection](azure-stack-diagnostic-log-collection-overview.md)  



<!---Ask Jeff, Brian, is this everything you do, how can we make it more useful? Theebs has another user.

To be successful, do these things

ask Brian what are all the the things they need to write down for quick access, like passswords, IP addresses, and so on, to make them more efficient

have a password manager for azure-stack, pep, inventory

A checklist so operators can be successful, so someone onboarding is operator know what to do weekly, daily, monthly. --->


