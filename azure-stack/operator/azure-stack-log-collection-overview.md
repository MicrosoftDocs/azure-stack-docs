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

add more general overview of diagnostics log, bandwidth consumption, average log size (4-8 MB), if you are on a constrained line automatic log colleciton may use more bandwidth than collect logs now, add a decision tree.

summary of diagnostic log collection, diagram, cmdlets, now we are adding log collection via Help and support portal. Ongoning investment. 

Azure Stack helps simplify troubleshooting by providing an easy way to share diagnostic logs with Microsoft Customer Support Services (CSS). The logs can be stored in a blob container in Azure and access can be restricted to only CSS. 
   
There are two ways to collect diagnostic logs in **Help and Support**:

- **Collect logs now**: You choose a 1-4 hour time period from the last week
- **Automatic collection**: If enabled, log collection is triggered by specific health alerts 

![Screenshot of diagnostic log collection options](media/azure-stack-automatic-log-collection/azure-stack-log-collection-overview.png)

If your policy allows sharing diagnostic logs with CSS, the portal is the easist way to collect them beginning with the 1907 release. You should only need to [use PEP](azure-stack-diagnostics.md) if the portal is unavailable.

## On-demand diagnostic log collection

To do: describe scenarios from spec from Theebs

For more information about collecting logs on demand, see [Collect Azure Stack logs now](azure-stack-configure-on-demand-log-collection.md).

## Automatic diagnostic log collection 

To do: describe scenarios from spec from Theebs

For more information about automatic log collection, see [Configure automatic Azure Stack log collection](azure-stack-configure-automatic-log-collection.md).



## Decision tree

![Screenshot of diagnostic log collection options](media/azure-stack-automatic-log-collection/azure-stack-diagnostic-log-decision-tree.png)

To cover Can you share logs? Can you connect to a cloud? Are you on 1907? Is portal available? If policy does not allow sending logs, CSS can work with you directly

## See also

link to topics about other types of logs and vice-versa, audit logs, security logs, diagnostic logs, health logs.

https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-data-collection 
https://docs.microsoft.com/en-us/azure/storage/common/storage-dotnet-shared-access-signature-part-1 