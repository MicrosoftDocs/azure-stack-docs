---
title: Azure Stack diagnostic log collection overview | Microsoft Docs
description: Overview of diagnostic log collection in Azure Stack Help + Support.
services: azure-stack
documentationcenter: ''
author: justinha
manager: femila
editor: ''

ms.assetid: a20bea32-3705-45e8-9168-f198cfac51af
ms.service: azure-stack
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 07/09/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 07/09/2019

---
# Overview of Azure Stack diagnostic log collection 

*Applies to: Azure Stack integrated systems*

add more general overview of diagnostics log, bandwidth consumption, average log size, if you are on a constrained line automatic log colleciton may use more bandwidth than collect logs now, add a decision tree.



Azure Stack helps simplify troubleshooting by providing an easy way to share diagnostic logs with Microsoft Customer Support Services (CSS). The logs can be stored in a blob container in Azure and access is restricted to only CSS. 
   
There are two ways to collect diagnostic logs in **Help and Support**:

- **Collect logs now**: You choose a 1-4 hour time period from the last week
- **Automatic collection**: If enabled, log collection is triggered by specific health alerts 

![Screenshot of diagnostic log collection options](media/azure-stack-automatic-log-collection/azure-stack-log-collection-overview.png)




## On-demand diagnostic log collection

For more information about collecting logs on demand, see [Collect Azure Stack logs now](azure-stack-configure-on-demand-log-collection.md).


## Automatic diagnostic log collection 

For more information about automatic log collection, see [Configure automatic Azure Stack log collection](azure-stack-configure-automatic-log-collection.md).

## Decision tree

scenario descriptions for each option

## See also

link to topics about other types of logs and vice-versa, audit logs, security logs, diagnostic logs, health logs.