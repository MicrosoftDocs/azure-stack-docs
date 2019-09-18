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

## Azure Stack operations checklist

## Routine daily and weekly operations


Azure Stack operators need to do the following things routinely:

> [!div class="checklist"]
> * Monitor SCOM and [Azure Monitor](https://docs.microsoft.com/azure/azure-monitor/overview) twice daily
> * Identify exceptions for different components of your application
> * View details of an exception
> * Download a snapshot of the exception to Visual Studio for debugging
> * Analyze details of failed requests using query language
> * Create a new work item to correct the faulty code



## Day-to-day operations

Azure Stack operators will also need to do these things as needed from day-to-day:

> [!div class="checklist"]
> * Add pilot users to test ring (SelfHosting)
> * Create subscriptions
> * Identify exceptions for different components of your application
> * View details of an exception
> * Download a snapshot of the exception to Visual Studio for debugging
> * Analyze details of failed requests using query language
> * Create a new work item to correct the faulty code


1.	Prioritizing and resolving tickets for the service desk 
1.	Tenant User requests (Adding users to selfhost, creating subscriptions, etc As requests come in.
2.	Patch & updates (Software and FRU updates) - If Needed
3.	Monitoring & Remediation (SCOM & OMS, twice a day
4.	Run Test AzureStack once a day. 
