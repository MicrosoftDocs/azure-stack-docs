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
ms.lastreviewed: 06/10/2019

---
# Microsoft Azure Stack automatic log collection


Beginning with the 1906 release, Azure Stack includes an easy way for operators to upload log files for analysis by Customer Support Services. These improvements help streamline the process for troubleshooting problems. 

Automatic log collection isn't enabled by default. Before you can enable it, you need to [configure an Azure storage account](azure-stack-storage-account.md) where the logs can be uploaded. 

## How to collect Azure Stack logs

You can collect diagnostic logs in two different ways:

- Automatically based on system health conditions
- On demand based on any 1-4 hour period over the last week

## Prerequisites

<!--- any permissions, subscription requirements, or anything similar?--->

## Workflow

workflow for uploading logs 

## Alerts
two types of alerts (failed and date approaching)

## Troubleshooting errors

### Custom time range errors

Here are some errors you might see when you specify a custom time range:

- End time is before start time

  ![Over time eror](media\azure-stack-log-collection\azure-stack-log-collection-over-time-error.png)

- Time range is less than 1 hour

  ![Under time error](media\azure-stack-log-collection\azure-stack-log-collection-under-time-error.png)

- Time range is more than 4 hours

  ![Over time error](media\azure-stack-log-collection\azure-stack-log-collection-over-time-error.png)

### Container creation errors

<!--- Better heading title? I'm unsure if AuthN errors are actually containe errors.--->

Here are some errors you might see during automatic log collection:

<!--- how to resolve these?--->

- The storage container has not been created

  ![Storage container has not been created error](media\azure-stack-log-collection\azure-stack-log-collection-container-does-not-exist-error.png)

- The account used to collect the logs is not authorized

  ![Not authorized error](media\azure-stack-log-collection\azure-stack-log-collection-not-authorized-error.png.png)

- Time range is more than 4 hours

  ![Server could not authenticate error](media\azure-stack-log-collection\azure-stack-log-collection-server-could-not-authenticate-error.png)
