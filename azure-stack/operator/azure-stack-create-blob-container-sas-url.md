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
>To create a blob container in Azure, you need at least the [storage blob contributor role](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor) or the [specific permission](https://docs.microsoft.com/rest/api/storageservices/authenticate-with-azure-active-directory#permissions-for-calling-blob-and-queue-data-operations). Global administrators also have the necessary permission. 

## Create a storage account for blobs

If you don't already have one, use the following steps to create a storage account for blobs:

1. Sign in to the Azure portal.
1. Click **Storage accounts** > **Add**.
1. Create a blob container using any [blog storage account](https://docs.microsoft.com/azure/storage/common/storage-account-overview#types-of-storage-accounts).
1. Click **Review and Create**.  
1. After the deployment succeeds, click **Go to resource**. You can also pin the storage account to the Dashboard for easy access. 

   ![Screenshot showing the blob container properties](media/azure-stack-automatic-log-collection/create-blob-container.png)

Azure [blob storage charges](https://azure.microsoft.com/pricing/details/storage/blobs/) depend on how much data is saved each month and other factors such as data redundancy. 
Azure Stack log collection requires only the least costly blob storage option. 

You can set the retention policy for Azure Stack logs between 1 and 365 days in the [storage account diagnostic settings](https://docs.microsoft.com/azure/azure-monitor/platform/archive-diagnostic-logs#diagnostic-settings). 

## Create a blob container
 
1. Click **Storage Explorer (preview)**, right-click **Blob containers**, and click **Create new blob container**. 
1. Enter a name for the new container and click **OK**.

## Copy the SAS URL

1. Right-click the new container, click **Get Shared Access Signature**, and choose these properties:
   - Start time: You can optionally move the start time back. 
   - Expiry time: Increase to two weeks or longer to avoid related alerts about upcoming expiration.
   - Time zone: UTC
   - Permissions: Read, Write, and List
1. Click **Save**.  

<!--- add screenshot with Read, Write, and List. I did not have perms to do it--->

The URL is constructed by using the storage account name, the blog container name, and an access token. 
Copy the URL and enter it when you [configure automatic log collection](azure-stack-configure-automatic-log-collection.md).


## Next step

[Configure automatic log collection](azure-stack-configure-automatic-log-collection.md)