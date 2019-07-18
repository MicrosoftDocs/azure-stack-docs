---
title: Configure automatic Azure Stack log collection | Microsoft Docs
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
ms.date: 07/09/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 07/09/2019

---
# Configure automatic Azure Stack log collection

*Applies to: Azure Stack integrated systems*

You can streamline the process for troubleshooting problems with Azure Stack by configuring automatic log collection. 
If system health conditions need to be investigated, the logs can be uploaded automatically for analysis by Microsoft Customer Support Services (CSS). 


## Steps to configure automatic log collection

You'll need to provide the SAS URL for a blob container where the logs can be uploaded. You can use any blob container in Azure. If you need to create a new SAS URL, see [Create a blob container SAS URL](azure-stack-create-blob-container-shared-access-signature-url.md). 

Follow these steps to add the SAS URL to the log collection UI: 

1. Sign in to the Azure Stack administrator portal.
1. Open **Help and support Overview**.
1. Click **Automatic collection settings**.

   ![Screenshot shows where to enable log collection in Help and support](media/azure-stack-automatic-log-collection/azure-stack-help-overview-enable-option.png)

1. Set Automatic log collection to **Enabled**.
1. Enter the shared access signature (SAS) URL of the storage account blob container.

   ![Screenshot shows blob SAS URL](media/azure-stack-automatic-log-collection/azure-stack-enable-automatic-log-collection.png)

<!--- change the first screenshot to show the buton rather than the banner--->


## View collected logs

You can see logs that were previously collected on the **Log collection** page in Help and Support. 
The **Collection time** refers to when the log collection operation began. 
The **From Date** is the start of the time period for which you want to collect logs and the **To Date** is the end of the time period.

![Screenshot of Azure Stack log collection](media/azure-stack-automatic-log-collection/azure-stack-log-collection.png)

<!-- Replace screenshot as UI has changed to From date and to date--->


## Disable automatic log collection

Automatic log collection can be disabled and re-enabled anytime. The SAS URL configuration won't change. If automatic log collection is re-enabled, the previously entered SAS URL will undergo the same validation checks, and an expired SAS URL will be rejected. 

## Log collection scanning

Scanning for automatic log collection occurs within a sliding window. If there are one or more alerts, a single log collection is queued for that window. 
After log collection, the next alert scanning is suppressed until 30 mins. 

## SAS URL alerts

There are two types of alerts related to the SAS URL used for automatic log collection. 
Each alert can be resolved by generating a new SAS URL. 
For more information, see [Create a blob container SAS URL](azure-stack-create-blob-container-shared-access-signature-url.md).

- Expiration date approaching

  ![Expiration date approaching](media/azure-stack-automatic-log-collection/alert-expiration-date.png)

- SAS URL has expired. 
  If you renew the SAS URL, you'll need to re-enter it in the automatic log collection settings. 
  If you rotate storage account keys, the previously provided SAS URL will no longer work. Check the log collection history to see why upload failed.

  ![SAS URL expired](media/azure-stack-automatic-log-collection/alert-url-expired.png)

  