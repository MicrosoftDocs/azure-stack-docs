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
> * Run [Test-AzureStack](azure-stack-diagnostic-test.md)
> * Collect logs each month using log collection <!--- Diagnostic logs? Why collect them, what should they look for?--->
> * Update firmware every two months
> * Back up infrastructure services <!--- how often? Which services? which backup types? For ex, DC needs system state backup?--->


## Day-to-day operations as needed

Azure Stack operators will also need to do these things as needed from day-to-day:

> [!div class="checklist"]
> * Create [plans](azure-stack-create-plan.md)
> * Create [offers](azure-stack-create-offer.md)
> * Create [subscriptions](azure-stack-subscribe-plan-provision-vm.md)
> * Update [quotas](azure-stack-quota-types.md)
> * Publish [marketplace samples](azure-stack-create-and-publish-marketplace-item.md)
> * Apply [marketplace updates](azure-stack-marketplace-changes.md)
> * Add pilot users to test ring (SelfHosting)
> * Patch & updates (Software and FRU updates)

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

Config telemtry,
Regional management
starting and stopping, in case you want to move it for example. 
Replacing hardware
Add a node
Monitor add-on RPS, like SQL, MySQL, Appsvc, 



Monthly, look at usage and billing reports, look at these APIs 

To be successful, do these things

ask Brian what are all the the things they need to write down for quick access, like passswords, IP addresses, and so on, to make them more efficient

have a password manager for azure-stack, pep, inventory

A checklist so operators can be successful, so someone onboarding is operator know what to do weekly, daily, monthly. 

for ex, how often

