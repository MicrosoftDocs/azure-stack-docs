---
title: Create a blob container SAS URL | Microsoft Docs
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
# Create a blob container SAS URL 

*Applies to: Azure Stack integrated systems*

You'll need the shared access signature URL of a blob container in Azure to save Azure Stack log files that will be collected for analysis by Microsoft Customer Support Services (CSS). 
You can use an existing blob container or complete the following steps to create a new one.

>[!NOTE]
>To create a blob container in Azure, you need at least the [storage blog contributor role](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor) or the [specific permission](https://docs.microsoft.com/rest/api/storageservices/authenticate-with-azure-active-directory#permissions-for-calling-blob-and-queue-data-operations). Global administrators also have the necessary permission. 

## Create a blob container in Azure

1. Sign in to the Azure portal.
1. Click **Storage accounts** > **Add**.
1. Create a blob container with these properties:  
   - Subscription: Choose a subscription. 
   - Resource group: Choose a resource group or create a new one.
   - Storage account name: Specify a globally unique name. 
   - Location: Choose a location that is close to your Azure Stack deployment.
   - Performance: Standard
   - Account kind: BlobStorage
   - Replication: Locally redundant storage (LRS) 
   - Access geo default: Hot

   [!Screenshot showing the blob container properties](media/azure-stack-automatic-log-collection/create-blob-container.png)

<!--- Why don't i see Replcation or Access geo default?--->


1. Click **Review and Create**.   
1. After the deployment succeeds, click **Go to resource**. You can also pin the storage account to the Dashboard for easy access. 
1. Click **Storage Explorer (preview)**, right-click **Blob containers**, and click **Create new blob container**. 
1. Enter a name for the new container and click **OK**.
1. Right-click the new container, click **Get Shared Access Signature**, and choose these properties:
   - Start time: If you want to make sure time zone differences don't cause collection to begin later than you expect, you can move the start time back. 
   - Expiry time: Increase to at least one week for automatic log collection or longer to avoid related alerts about upcoming expiration.
   - Time zone: UTC
   - Permissions: Read, Write, and List
1. Click **Save**.  

The URL is constructed by using the storage account name, the blog container name, and an access token. 
Copy the URL and enter it when you [configure automatic log collection](azure-stack-configure-log-collection.md).

## Manage the log collection storage account

Azure [blob storage charges](https://azure.microsoft.com/pricing/details/storage/blobs/) depend on how much data is saved each month and other factors such as data redundancy. Azure Stack log collection requires only the least costly blob storage option. 

You can set the retention policy for Azure Stack logs between 1 and 365 days in the [storage account diagnostic settings](https://docs.microsoft.com/azure/azure-monitor/platform/archive-diagnostic-logs#diagnostic-settings). 

## Next step

[Configure Azure Stack log collection](azure-stack-configure-log-collection.md)