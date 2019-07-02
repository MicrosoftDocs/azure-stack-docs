---
title: Manage a storage account for automatic Azure Stack log collection | Microsoft Docs
description: How to create a blob account SAS URL for automatic log collection in Azure Stack Help + Support.
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
ms.date: 07/02/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 07/02/2019

---
# Manage a storage account for automatic Azure Stack log collection 

*Applies to: Azure Stack integrated systems*

## Create a storage account for blobs

Azure [blob storage charges](https://azure.microsoft.com/pricing/details/storage/blobs/) depend on how much data is saved each month and other factors such as data redundancy. 
Azure Stack log collection requires only the least costly blob storage option. 
If you don't already have a storage account for blobs, sign in to the Azure portal, click **Storage accounts**  and then click **Add** to create one.

You can set the retention policy of the storage account between 1 and 365 days. For more information about setting the retion policy, see [storage account diagnostic settings](https://docs.microsoft.com/azure/azure-monitor/platform/archive-diagnostic-logs#diagnostic-settings). 

## Next step

[Configure automatic Azure Stack log collection](azure-stack-configure-automatic-log-collection.md)