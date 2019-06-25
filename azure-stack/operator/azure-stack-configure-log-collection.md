---
title: Configure log collection | Microsoft Docs
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
ms.date: 06/21/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 06/21/2019

---
# Configure Azure Stack log collection

*Applies to: Azure Stack integrated systems*

You can streamline the process for troubleshooting problems with Azure Stack by uploading log files for analysis by Microsoft Customer Support Services (CSS). 
Logs can be uploaded on demand or automatically based system health conditions. 

Automatic log collection uses a new Support Bridge Service resource provider in Azure Stack.  
The service is resilient to Storage Spaces Direct and Software Defined Networking (SDN) failures. 

This topic covers how to configure log collection, see which logs have been collected, and resolve possible errors.

<!--- RP info came from the video. What else should we say in the intro? Should we mention the new resource provider? can we add how the resiliency helps here?--->

## Configure a blob container

To collect Azure Stack logs automatically, you can configure an existing blob container in Azure or [create a new one](azure-stack-create-blob-container-for-automatic-log-collection.md). 

## Configure automatic log collection 

1. Sign in to the Azure Stack administrator portal.
1. Open **Help and support Overview**.
1. Click **Enable automatic log collection**.

   ![Screenshot shows where to enable log collection in Help and support](media/azure-stack-automatic-log-collection/azure-stack-help-overview-enable-option.png)

1. Set Automatic log collection to **Enabled**.
1. Enter the shared access signature (SAS) URL of the storage account blob container.

   ![Screenshot shows blob SAS URL](media/azure-stack-automatic-log-collection/azure-stack-enable-automatic-log-collection.png)

## Configure on-demand log collection 

For on-demand collection, CSS might provide a blob service SAS URL. 

1. Open **Help and support Overview** and click **Collect logs now**. 
1. Choose any 1-4 hour period over the previous week, and enter the SAS URL that CSS provided.

![Screenshot of on-demand log collection](media/azure-stack-automatic-log-collection/collect-logs-now.png)

<!--- Will CSS always provide the SAS URL for on demand?--->

## View collected logs

You can see logs that were previously collected on the **Log collection** page in Help and Support. 
The **Collection time** refers to when the log collection operation began. 
The **Logs From** is the start of the time period you want to collect logs for and the **Logs To** is the end of that time period.

![Screenshot of Azure Stack log collection](media/azure-stack-automatic-log-collection/azure-stack-log-collection.png)


## Limitations

<!--- Need to confirm what Theebs wanted to cover here--->

## Alerts

<!--- demo says log collection (for all logs) triggers on alerts. See spec for algorithm--->

There are two types of alerts: 

- Expiration date approaching

  ![Expiration date approaching](media/azure-stack-automatic-log-collection/alert-expiration-date.png)

- SAS URL has expired
  
  ![SAS URL expired](media/azure-stack-automatic-log-collection/alert-url-expired.png)

## Troubleshooting errors

The next sections cover errors you might see while configuring automatic log collection. 

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
