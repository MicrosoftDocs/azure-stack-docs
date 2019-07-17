---
title: Manage a storage account for automatic Azure Stack log collection | Microsoft Docs
description: How to manage the storage account for automatic log collection in Azure Stack Help + Support
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
# Manage a storage account for automatic Azure Stack log collection 

*Applies to: Azure Stack integrated systems*

Azure [blob storage charges](https://azure.microsoft.com/pricing/details/storage/blobs/) depend on how much data is saved each month and other factors such as data redundancy. 
Automatic Azure Stack log collection requires only the least costly blob storage option.  
If you don't have an existing storage account, you can sign in to the Azure portal, click **Storage accounts**, and then click **Add** to create a storage account for blobs.

You can set the retention policy of the storage account between 1 and 365 days. For more information about setting the retention policy, see [storage account diagnostic settings](https://docs.microsoft.com/azure/azure-monitor/platform/archive-diagnostic-logs#diagnostic-settings). 

<!---For follow up: what are best practices for expiration, why SAS tokens are not used, can I point multiple Azure Stack systems to the same storage account? Etc. etc. 

need section on "setup log collection"

need section on best practices to manage log collection


Best practices


	
Multiple  log collection
	Bandwidth Consumption
	Retention policy
	 

--->


