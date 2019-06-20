---
title: Create a blob container to automatically collect Azure Stack logs | Microsoft Docs
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
ms.date: 06/19/2019
ms.author: justinha
ms.reviewer: prchint
ms.lastreviewed: 06/19/2019

---
# Create a blob container to automatically collect Azure Stack logs 

You can create a blob container in Azure to save Azure Stack log files that will be collected for analysis by Microsoft Customer Support Services (CSS). 
You can configure an existing blob container or complete the following steps to create a new one.

## Permissions

To configure the blob container in Azure, you'll need the [storage blog contributor role](https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#storage-blob-data-contributor) or be given [permission](https://docs.microsoft.com/rest/api/storageservices/authenticate-with-azure-active-directory#permissions-for-calling-blob-and-queue-data-operations). 

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
1. Click **Create**.  

The URL is constructed by using the storage account name, the blog container name, and an access token. 
Copy the URL and then [configure automatic log collection](azure-stack-configure-log-collection.md).

## Next step

[Configure Azure Stack log collection](azure-stack-configure-log-collection.md)