---
title: Azure Stack operations checklist | Microsoft Docs
description: Learn common tasks that Azure Stack operators should perform and how often to do them.
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
ms.date: 09/19/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 09/19/2019

---

## Azure Stack operations checklists

We put together some operations checklists so Azure Stack operators be successful. You can add specific operations that need to be done for your environment. They're meant to help someone onboarding as an operator know what to do daily, weekly, and monthly. 

## Routine daily and weekly operations

Azure Stack operators need to do the following things routinely:

> [!div class="checklist"]
> * Monitor and remediate [Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/overview) and Systen Center Operations Monitor errors twice daily
> * Identify exceptions 
> * View details of an exception
> * Run [Test-AzureStack](azure-stack-diagnostic-test.md) once daily
> * Run [diagnostic log collection](azure-stack-diagnostic-log-collection-overview.md) monthly <!--- Diagnostic logs? Why collect them, what should they look for?--->
> * Perform [infrastructure service backups](azure-stack-backup-infrastructure-backup.md) weekly <!--- how often?--->
> * Update [OEM firmware](azure-stack-update-oem) every two months <!---how often?>

## Day-to-day operations as needed

Azure Stack operators will also need to do these things as needed from day-to-day:

> [!div class="checklist"]
> * Create [plans](azure-stack-create-plan.md)
> * Create [offers](azure-stack-create-offer.md)
> * Create [subscriptions](azure-stack-subscribe-plan-provision-vm.md)
> * Update [quotas](azure-stack-quota-types.md)
> * Publish [marketplace samples](azure-stack-create-and-publish-marketplace-item.md)
> * Apply [marketplace updates](azure-stack-marketplace-changes.md)
> * Configure [telemetry](azure-stack-telemetry.md)
> * Review [region management](azure-stack-region-management.md)
> * Shut down or [restart Azure Stack services](azure-stack-start-and-stop.md). 
> * Replacing a [scale unit node](azure-stack-replace-node.md)
> * Replace a [physical disk](azure-stack-replace-disk.md)
> * Update add-on resource providers such as [SQL](azure-stack-sql-resource-provider-update.md), [MySQL](/azure-stack-mysql-resource-provider-update.md), and the [App Service](azure-stack-app-service-update.md)


## List from Brian

1.	Prioritizing and resolving tickets for the service desk 
1.	Tenant User requests (Adding users to selfhost, creating subscriptions, etc As requests come in.
2.	Patch & updates (Software and FRU updates) - If Needed
3.	Monitoring & Remediation (SCOM & OMS, twice a day
4.	Run Test AzureStack once a day. 

collect logs once a month using log collection
check health of 

on a daily basis look at scom alerts and perform remediation

you should update your firmware every couple months

Infrabackups, schedule them or perform them

Add as needed to heading and list Create plans, offers quotas, updating from marketplace

Ask Jeff, Brian, is this everything you do, how can we make it more useful? Theebs has another user.





Monthly, look at usage and billing reports, look at these APIs 

To be successful, do these things

ask Brian what are all the the things they need to write down for quick access, like passswords, IP addresses, and so on, to make them more efficient

have a password manager for azure-stack, pep, inventory

A checklist so operators can be successful, so someone onboarding is operator know what to do weekly, daily, monthly. 

for ex, how often

