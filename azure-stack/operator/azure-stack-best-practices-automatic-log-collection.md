---
title: Best practices for automatic Azure Stack diagnostic log collection | Microsoft Docs
description: Best practices for automatic diagnostic log collection in Azure Stack Help + Support
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
# Best practices for automatic Azure Stack diagnostic log collection 

*Applies to: Azure Stack integrated systems*

This topic covers best practices for managing automatic diagnostic log collection for Azure Stack. 

## Best practices for managing the storage account 

Azure [blob storage charges](https://azure.microsoft.com/pricing/details/storage/blobs/) depend on how much data is saved each month and other factors such as data redundancy. 
Automatic Azure Stack log collection requires only the least costly blob storage option.  
If you don't have an existing storage account, you can sign in to the Azure portal, click **Storage accounts**, and then click **Add** to create a storage account for blobs.

You can set the retention policy of the storage account between 1 and 365 days. For more information about setting the retention policy, see [storage account diagnostic settings](https://docs.microsoft.com/azure/azure-monitor/platform/archive-diagnostic-logs#diagnostic-settings). 

## Collecting logs from multiple Azure Stack systems

As a best practice, only save diagnostic logs from the same Azure Stack stamp within a storage account. 
If you need to collect diagnostic logs from another stamp, save them to a separate storage account.

## Bandwidth consumption

If you are on a restricted 


<!---For follow up: what are best practices for expiration, why SAS tokens are not used (place in SAS URL topic), can I point multiple Azure Stack systems to the same storage account? Etc. etc. 

need section on "setup log collection"

need section on best practices to manage log collection


Best practices


	
Multiple  log collection
	Bandwidth Consumption
	Retention policy
	 

--->


