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


Set up one container for every Azure Stack stamp you want to collect logs from. For more information about how to configure the blob container, see [Configure automatic Azure Stack diagnostic log collection](azure-stack-configure-automatic-diagnostic-log-collection.md). As a best practice, only save diagnostic logs from the same Azure Stack stamp within a single blob container. 


## Retention policy

 Create an Azure Blob storage [lifecycle management policy](https://docs.microsoft.com/azure/storage/blobs/storage-lifecycle-management-concepts) to manage the log retention policy. We suggest retaining diagnostic logs for 30 days. 


## SAS token expiration

The SAS URL expiry should be set to two years. If you ever renew your storage account keys, make sure to regenerate the SAS URL. You should manage the SAS token according to best practices. For more information, see [Best practices when using SAS](https://docs.microsoft.com/azure/storage/common/storage-dotnet-shared-access-signature-part-1#best-practices-when-using-sas).


## Bandwidth consumption

The average size of diagnostic log collection varies based on whether log collection is on-demand or automatic. 

For on-demand log collection, the size of the logs collection depends on how many hours are being collected. You can choose any 1-4 sliding window from the last seven days. 

>[!CAUTION]
>Don't enable automatic log collection if you are using a low-bandwidth, high-latency link. In this case, only use on-demand log collection. 

When automatic diagnostic log collection is enabled, the service monitors for critical alerts. 
After a critical alert occurs and persists for around 30 minutes, the service collects and uploads appropriate logs. 
This log collection size is around 2 GB on average. 
Alert monitoring, log collection, and upload are transparent to the user. 

In a healthy system, logs will not be collected at all. 
In an unhealthy system, log collection may run two or three times in a day, but typically only once. 
At most, it could potentially run up to ten times in a day in a worst-case scenario.  

## Managing costs

Azure [blob storage charges](https://azure.microsoft.com/pricing/details/storage/blobs/) depend on how much data is saved each month and other factors such as data redundancy. 
If you don't have an existing storage account, you can sign in to the Azure portal, click **Storage accounts**, and follow the steps to [create an Azure blob container SAS URL](azure-stack-configure-automatic-diagnostic-log-collection.md).

As a best practice, you should use StorageV2 [lifecycle management](https://docs.microsoft.com/azure/storage/blobs/storage-lifecycle-management-concepts) to reduce ongoing storage costs. For more information about how to set up the storage account, see [Configure automatic Azure Stack diagnostic log collection](azure-stack-configure-automatic-diagnostic-log-collection.md).


