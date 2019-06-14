---
title: Microsoft Azure Stack storage account for automatic log collection | Microsoft Docs
description: How to configure a storage account for automatic log collection in Azure Stack Help + Support.
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
ms.date: 06/14/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 06/12/2019

---
# Microsoft Azure Stack storage account for automatic log collection

<!--- is the storage account dedicated to log collection?--->
<Explain what the storage account is and why it's needed...> 

https://docs.microsoft.com/en-us/azure-stack/operator/azure-stack-manage-storage-accounts 

You'll need to enter a blob service shared access signature (SAS) URL. 

![Automatic log collection](media/azure-stack-automatic-log-collection/azure-stack-enable-automatic-log-collection.png)

## Prerequisites

<!--- any permissions, subscription requirements, or anything similar?--->

## How to configure a storage account

1. create a Blob container in Azure Storage
2. provide the SAS Uri as input.


...
An alert is triggered, and after a predefined pause to filter out transient alerts, the logs start to apper in the storage account.