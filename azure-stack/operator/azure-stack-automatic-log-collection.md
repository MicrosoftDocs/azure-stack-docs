---
title: Microsoft Azure Stack automatic log collection | Microsoft Docs
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
ms.date: 06/10/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 06/12/2019

---
# Microsoft Azure Stack automatic log collection

Beginning with the 1906 release, Azure Stack includes an easy way for operators to upload log files for analysis by Customer Support Services. These improvements help streamline the process for troubleshooting problems. 

Automatic log collection isn't enabled by default. Before you can enable it, you need to [configure an Azure storage account](azure-stack-storage-account.md) where the logs can be uploaded. 

## How to collect Azure Stack logs

You can collect diagnostic logs in two different ways:

- Automatically based on system health conditions
- On demand based on any 1-4 hour period over the previous week

## Prerequisites

<!--- any permissions, subscription requirements, or anything similar?--->

## Workflow

1. Open Help and support Overview.
2. Click **Enable automatic log collection**.
3. Set Automatic log collection to **Enabled**.
4. Enter the shared access signature (SAS) URL of the storage account.
   ![Enable log collection](media/azure-stack-automatic-log-collection/azure-stack-enable-automatic-log-collection.png)

## Limitations

<!--- Need to confirm what Theebs wanted to cover here--->

## Alerts

There are two types of alerts: 

- Expiration date approaching

  ![Expiration date approaching](media/azure-stack-automatic-log-collection/alert-expiration-date.png)

- SAS URL has expired
  
  ![SAS URL expired](media/azure-stack-automatic-log-collection/alert-url-expired.png)

## Troubleshooting errors

### Custom time range errors

Here are some errors you might see when you specify a custom time range:

- End time is before start time

  ![Over time eror](media/azure-stack-automatic-log-collection/azure-stack-log-collection-start-time-error.png)

- Time range is less than 1 hour

  ![Under time error](media/azure-stack-automatic-log-collection/azure-stack-log-collection-under-time-error.png)

- Time range is more than 4 hours

  ![Over time error](media/azure-stack-automatic-log-collection/azure-stack-log-collection-over-time-error.png)

### Container creation errors

<!--- Better heading title? I'm unsure if AuthN errors are actually containe errors.--->

Here are some errors you might see during automatic log collection:

<!--- how to resolve these?--->

- The storage container has not been created

  ![Storage container has not been created error](media/azure-stack-automatic-log-collection/azure-stack-log-collection-container-does-not-exist-error.png)

- The account used to collect the logs is not authorized

  ![Not authorized error](media/azure-stack-automatic-log-collection/azure-stack-log-collection-not-authorized-error.png)

- Time range is more than 4 hours

  ![Server could not authenticate error](media/azure-stack-automatic-log-collection/azure-stack-log-collection-server-could-not-authenticate-error.png)
