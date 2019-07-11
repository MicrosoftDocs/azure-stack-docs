---
title: Azure Stack log collection overview | Microsoft Docs
description: Overview of log collection in Azure Stack Help + Support.
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
# Overview of Azure Stack log collection 

*Applies to: Azure Stack integrated systems*

Azure Stack helps simplify troubleshooting by providing an easy way to share diagnostic logs with Microsoft Customer Support Services (CSS). The logs can be stored in a blob container in Azure and access is restricted to only CSS. 
   
There are two ways to collect logs:

- **Collect logs now**: You choose a 1-4 hour time period from the last week
- **Automatic collection**: If enabled, log collection is triggered by specific health alerts 

You can choose either option on the Help and Support **Overview - Log Collection** page. 

![Screenshot of Log Collection options](media/azure-stack-automatic-log-collection/azure-stack-log-collection-overview.png)

For more information about collecting logs on demand, see [Collect Azure Stack logs now](azure-stack-configure-on-demand-log-collection.md).

For more information about automatic log collection, see [Configure automatic Azure Stack log collection](azure-stack-configure-automatic-log-collection.md).