---
title: Collect Azure Stack logs now | Microsoft Docs
description: How to configure automatic log collection in Azure Stack Help + Support.
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
# Collect Azure Stack logs now (on demand)

*Applies to: Azure Stack integrated systems*

As part of troubleshooting, Microsoft Customer Support Services (CSS) often needs to analyze diagnostic logs. In some cases, CSS might need you to collect the logs on demand and save them in a designated blob container. 
If CSS provides a SAS URL for saving diagnostic logs, follow these steps to configure on-demand log collection:

1. Open **Help and support Overview** and click **Collect logs now**. 
1. Choose any 1-4 hour period from the past week, and enter the SAS URL that CSS provided.

   ![Screenshot of on-demand log collection](media/azure-stack-automatic-log-collection/collect-logs-now.png)

