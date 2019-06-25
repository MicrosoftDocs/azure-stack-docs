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
ms.date: 06/25/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 06/25/2019

---
# Configure Azure Stack log collection

*Applies to: Azure Stack integrated systems*

You can streamline the process for troubleshooting problems with Azure Stack by uploading log files for analysis by Microsoft Customer Support Services (CSS). 
Logs can be uploaded on demand or automatically based system health conditions. 

Automatic log collection uses a new Support Bridge Service resource provider in Azure Stack.  
The service is resilient to Storage Spaces Direct and Software Defined Networking (SDN) failures. 

This topic covers how to configure log collection, see which logs have been collected, and resolve possible errors.

<!--- RP info came from the video. What else should we say in the intro? Should we mention the new resource provider? can we add how the resiliency helps here?--->

## Configure automatic log collection 

You'll need to provide the SAS URL for a blob container. You can use an existing blob container in Azure or [create a new one](azure-stack-create-blob-container-sas-url.md). Then follow these steps to add the SAS URL to the log collection UI: 

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

## View collected logs

You can see logs that were previously collected on the **Log collection** page in Help and Support. 
The **Collection time** refers to when the log collection operation began. 
The **Logs From** is the start of the time period for which you want to collect logs and the **Logs To** is the end of the time period.

![Screenshot of Azure Stack log collection](media/azure-stack-automatic-log-collection/azure-stack-log-collection.png)

## Alerts

There are two types of alerts: 

- Expiration date approaching

  ![Expiration date approaching](media/azure-stack-automatic-log-collection/alert-expiration-date.png)

- SAS URL has expired
  
  ![SAS URL expired](media/azure-stack-automatic-log-collection/alert-url-expired.png)

