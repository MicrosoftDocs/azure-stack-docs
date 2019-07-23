---
title: Best practices for automatic Azure Stack log collection | Microsoft Docs
description: Best practices for automatic log collection in Azure Stack Help + Support
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
ms.date: 07/18/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 07/18/2019

---
# Best practices for automatic Azure Stack log collection 

*Applies to: Azure Stack integrated systems*



This topic covers best practices for managing automatic diagnostic log collection for Azure Stack. 





## Collecting logs from multiple Azure Stack systems


As a best practice, only save diagnostic logs from the same Azure Stack stamp within a single storage account. Save diagnostic logs from a different stamp to another storage account.


## Retention policy

You can set the retention policy of the storage account between 1 and 365 days. For more information about setting the retention policy, see [storage account diagnostic settings](https://docs.microsoft.com/azure/azure-monitor/platform/archive-diagnostic-logs#diagnostic-settings). 

## Running on-demand and automatic collection in parallel

Scanning for automatic log collection occurs within a sliding window. If there are one or more alerts, a single log collection is queued for that window. 
After log collection, the next alert scanning is suppressed until around 30 mins. 

When automatic log collection is enabled and diagnostic logs are being collected: 
- If an operator creates an on-demand diagnostic log using **Help and Support**, the on-demand log collection begins after automatic log collection is complete. 
- If an operator creates an on-demand diagnostic log using PEP, the on-demand log collection begins while automatic log collection is still in progress. 

Running on-demand diagnostic log using PEP in parallel with automatic log collection should not cause conflicts. But as a best practice, you should run them separately because they collect data from the same set of endpoints. 


## Bandwidth consumption


If you are on a constrained line, **Automatic log collection** may use more bandwidth than **Collect logs now**. 
When automatic diagnostic log collection is enabled, the average size of ongoing diagnostic logs is 4-8 MB. 
After a critical alert occurs, the full diagnostic log size can average nearly 5 GB. 


Since you can't control when automatic log collection occurs, take caution when enabling automatic log collection if you are using a low-bandwidth, high-latency link. In this case, only use on-demand log collection so you control when collection happens. 


<!--- What to say n a more robust lin? Get from Faraz, on a T1 for ex, how long will it take to upload?--->

<!--- how often could automatic upload over a day--->


<!--To do: We should explain the difference between ongoing logs and critical alert logs. That is separate from automatic and on-demand log collection. --->


<!---For follow up: what are best practices for expiration, why SAS tokens are not used (place in SAS URL topic), can I point multiple Azure Stack systems to the same storage account? Etc. etc. 


<!---For follow up: what are best practices for expiration, why SAS tokens are not used, can I point multiple Azure Stack systems to the same storage account? Etc. etc. 


<!---For follow up: what are best practices for expiration, why SAS tokens are not used, can I point multiple Azure Stack systems to the same storage account? Etc. etc. 


--->

## Managing costs

Azure [blob storage charges](https://azure.microsoft.com/pricing/details/storage/blobs/) depend on how much data is saved each month and other factors such as data redundancy. 
Automatic Azure Stack log collection requires only the least costly blob storage option.  
If you don't have an existing storage account, you can sign in to the Azure portal, click **Storage accounts**, and then click **Add** to create a storage account for blobs.

