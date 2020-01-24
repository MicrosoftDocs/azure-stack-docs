---
title: Create storage accounts in Azure Stack Hub | Microsoft Docs
titleSuffix: Azure Stack Hub
description: Learn how to create storage accounts in Azure Stack Hub.
author: mattbriggs

ms.service: azure-stack
ms.topic: conceptual
ms.date: 1/22/2020
ms.author: mabrigg
ms.lastreviewed: 01/18/2019

---
# Create storage accounts in Azure Stack Hub

Storage accounts in Azure Stack Hub include Blob and Table services, and the unique namespace for your storage data objects. By default, the data in your account is available only to you, the storage account owner.

1. On the Azure Stack Hub POC computer, sign in to `https://adminportal.local.azurestack.external` as [an admin](../asdk/asdk-connect.md), and then click **+ Create a resource** > **Data + Storage** > **Storage account**.

   ![Create your storage account in Azure Stack Hub administrator portal](media/azure-stack-provision-storage-account/image01.png)

2. In the **Create storage account** blade, type a name for your storage account. Create a new **Resource Group**, or select an existing one, then click **Create** to create the storage account.

   ![Review your storage account in Azure Stack Hub administrator portal](media/azure-stack-provision-storage-account/image02.png)

3. To see your new storage account, click **All resources**, then search for the storage account and click its name.

    ![Your storage account name in Azure Stack Hub administrator portal](media/azure-stack-provision-storage-account/image03.png)

### Next steps

- [Use Azure Resource Manager templates](../user/azure-stack-arm-templates.md)
- [Learn about Azure storage accounts](/azure/storage/common/storage-create-storage-account)
- [Download the Azure Stack Hub Azure-consistent Storage Validation Guide](https://aka.ms/azurestacktp1doc)
