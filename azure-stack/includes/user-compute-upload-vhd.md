---
author: mattbriggs
ms.author: mabrigg
ms.service: azure-stack
ms.topic: include
ms.date: 08/04/2020
ms.reviewer: thoroet
ms.lastreviewed: 08/04/2020
---

1. Sign in to the Azure Stack Hub user portal.

2. Select **Storage Accounts** and select an existing storage account or create a new storage account.

3. Select **Blobs** in the storage account blade for your storage account. Select Container to create a new container.

4. Type the name of your container, and then select **Blob (anonymous read access for blobs only)**.

5. Select your container and then select **Upload**. Upload your VHD.

> [!NOTE]  
> You can use a command-line tool such as AzCopy, or other data transfer tools, to transfer your VJD from Azure to your on-premises machine or from your on-premises machine to Azure Stack Hub. For more information see [Use data transfer tools in Azure Stack Hub Storage](/azure-stack/user/azure-stack-storage-transfer)