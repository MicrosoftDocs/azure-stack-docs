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
ms.date: 07/02/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 07/02/2019

---
# Configure Azure Stack automatic log collection

*Applies to: Azure Stack integrated systems*

You can streamline the process for troubleshooting problems with Azure Stack by configuring automatic log collection. automatically uploading log files. 
If system health conditions need investigation, logs can be uploaded automatically for analysis by Microsoft Customer Support Services (CSS). 

You'll need to provide the SAS URL for a blob container where the logs can be uploaded. You can use any blob container in Azure. If you need to create a new one, see [Create a blob container SAS URL](azure-stack-create-blob-container-sas-url.md). 

Follow these steps to add the SAS URL to the log collection UI: 

1. Sign in to the Azure Stack administrator portal.
1. Open **Help and support Overview**.
1. Click **Enable automatic log collection**.

   ![Screenshot shows where to enable log collection in Help and support](media/azure-stack-automatic-log-collection/azure-stack-help-overview-enable-option.png)

1. Set Automatic log collection to **Enabled**.
1. Enter the shared access signature (SAS) URL of the storage account blob container.

   ![Screenshot shows blob SAS URL](media/azure-stack-automatic-log-collection/azure-stack-enable-automatic-log-collection.png)

## View collected logs

You can see logs that were previously collected on the **Log collection** page in Help and Support. 
The **Collection time** refers to when the log collection operation began. 
The **From Date** is the start of the time period for which you want to collect logs and the **To Date** is the end of the time period.

![Screenshot of Azure Stack log collection](media/azure-stack-automatic-log-collection/azure-stack-log-collection.png)

<!-- Replace screenshot as UI has changed to From date and to date--->

## Alerts

There are two types of alerts related to the SAS URL used for automatic log collection. 
Each one can be resolved by increasing the expiry for the SAS URL. 
For more information, see [Create a blob container SAS URL](azure-stack-create-blob-container-sas-url.md).

- Expiration date approaching

  ![Expiration date approaching](media/azure-stack-automatic-log-collection/alert-expiration-date.png)

- SAS URL has expired. In this case
  
  ![SAS URL expired](media/azure-stack-automatic-log-collection/alert-url-expired.png)

